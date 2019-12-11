/**
 * @File Name          : PVAction.cls
 * @Description        :
 * @Author             : Andrea Vanelli
 * @Group              :
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 6/11/2019, 10:52:29
 * @Modification Log   :
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    2019-6-19 17:18:58   Andrea Vanelli     Initial Version
 **/
public without sharing abstract class PVAction {

	// Activity Types
	//public static final String CRM_POSTVENDITA = 'CRM_POSTVENDITA';
	// Stati
	//public static final String DA_PROCESSARE = 'PV_Da_Processare';
	// RecordType
	//public static final String CRM_POSTVENDITA_RT = 'XCS_Post_Vendita';

/*
public class AsyncExecutionExample implements Queueable {
    public void execute(QueueableContext context) {
        Account a = new Account(Name='Acme',Phone='(415) 555-1212');
        insert a;        
    }
}
ID jobID = System.enqueueJob(new AsyncExecutionExample());
AsyncApexJob jobInfo = [SELECT Status,NumberOfErrors FROM AsyncApexJob WHERE Id=:jobID];
*/
	public static PVResponse risposta = new PVResponse();

	protected boolean isValid(PVForm form){
		return true;
	}

	public static PVForm  prepareFormExternal(PVForm form, String postVenditaId, Id userId) {

		form.categoriaPV = PVInserimentoController.getCommonComponents(postVenditaId);
		if (userId == null) {
			form.userData =  PVInserimentoController.getUserData();
		} else {
			form.userData =  PVInserimentoController.getUserData(userId);
		}

		return form;

	}

    @AuraEnabled
    public static OCSCartaDatiFinanziariResponse.DatiCartaDatiFinanziariResponseDTO recuperaDatiFinanziari2(String numeroCarta){
        OCSCartaDatiFinanziariResponse cartaDatiFinanziariResponse = OCSCartaDatiFinanziariInvoker.cartaDatiFinanziari(numeroCarta);
		return cartaDatiFinanziariResponse.datiCartaDatiFinanziariResponse;
    } 

	public void commonExecute(PVForm form){
		String messaggio_errore = '';
		try{
		
			if(isValid(form)) {
				//Account accountPV = AccountUtils.upsertAccount(AccountUtils.makeAccount(form.cliente,'Compass'),'Compass');
				// AV inserisco modulo anagrafico
				// AV NOTA la AccountUtils.makeaccount mi pare bacata, non prende mail e telefoni????????
				// AV TODO crerne una per il PV perche non ci si può fidare nemmeno dei metodi utils
				System.debug('*** CLIENTE : '+form.cliente.codCliente);
				Account accountPV = AccountUtils.makeAccount(form.cliente,'Compass');
				 Map<Account, Account> accountMap = new Map<Account, Account>();
				 accountMap.put(accountPV, null);
				XCSGestioneAnagrafica.execute(accountMap, true, false);
				 accountPV =  accountMap.get(accountPV);
				System.debug('*** ID : '+accountPV.Id);
				if(accountPV.Id != null) {
					System.debug('*** sono dentro PRIMA della creazione del case');
					Case casoPV = preparaCasePostVenditaCommon(form,accountPV);
					System.debug('*** sono dentro DOPO della creazione del case');
					casoPV = completaCasePostVendita(casoPV,form);  //completo nel metodo override di ogni singolo postvendita
					System.debug('*** casoPV COMPLETATO');
					insert casoPV;
					System.debug('*** INSERITO : '+casoPV.Id);
					
					if(casoPV.Id != null) {
						
						
						insertTabelleExtra(form,casoPV);  // se devo inserire righe in tabelle extra


						system.debug('****   casoPV : ' + casoPV.Id);
						system.debug('****   Owner : ' + casoPV.OwnerId);

						alertMessaggi(form, casoPV); 

						String notaSpecificaPV = recuperaNotaSpecificaPV(form,casoPV);
						List<String> parametriTemplateNota = preparaParametriTemplateNotaCommon(form,casoPV,notaSpecificaPV);
						String noteOCS=buildBodyPostVendita(parametriTemplateNota,form.categoriaPV.XCS_Template__r.Body__c);
						postANotePV(casoPV.Id,'Nota PostVendita',noteOCS);
						system.debug('****  postANotePV terminato ');
						//NOTE PER OCS
						noteOCS=buildHeadAndFoot(casoPV.Id,parametriTemplateNota,form.categoriaPV.XCS_Template__r.Body__c,form.categoriaPV.Name);
						XCS_Messaggio__c xcs_messaggio = preparaMessaggioOCSCommon(form,noteOCS);
						if ( (xcs_messaggio.CodCliente__c !=null && !xcs_messaggio.CodCliente__c.equals('') )
							|| (xcs_messaggio.NumPratica__c !=null && !xcs_messaggio.NumPratica__c.equals('') ) ) {
							insert xcs_messaggio;
						}


						//inserimento allegati
						if(form.attachmentList != null && form.attachmentList.size()>0) {
							for(Attachment allegato : form.attachmentList) {
								allegato.Body = EncodingUtil.base64Decode(allegato.Body + '');
								allegato.ParentId = casoPV.Id;
								insert allegato;
							}
						}

						// allegati arrivati come parametro Id, quindi già a sistema
						if(form.attachmentsIDs != null && form.attachmentsIDs.size()>0) {
							for(Id allegatoID : form.attachmentsIDs) {
								// decodifico il tipo di ID
								String tipo = String.valueOf(allegatoID.getSobjectType());
								if (tipo.equalsIgnoreCase('Attachment')) {
									Attachment allegatoOrigine = [Select Id, Body, Name, Description, ParentId
																From Attachment where Id =: allegatoID];
									Attachment allegatoDuplicato = new Attachment();
									allegatoDuplicato = allegatoOrigine.clone();
									allegatoDuplicato.ParentId = casoPV.Id;
									insert allegatoDuplicato;

								} else if (tipo.equalsIgnoreCase('quellochemidirà Ivan')) {

								}


							}
						}


						casoPV.Status =  CaseUtils.DA_PROCESSARE;
						update casoPV;
					}
				}
			}
		}catch(Exception e) {
			messaggio_errore = loggaException(e);
		}finally{
			if(messaggio_errore != '') {
				gestisciException(messaggio_errore);
			}
		}

	}
	public Case preparaCasePostVenditaCommon(PVForm pvForm, Account accountPV){
		Case casoPV = CaseUtils.getCase(RecordTypeUtil.CRM_POSTVENDITA_RT,pvForm.categoriaPV.External_Id__c);
		//casoPV.Categoria_Riferimento__c =  pvForm.categoriaPV.Id;
		//casoPV.RecordTypeId = [select Id from RecordType where SobjectType = 'Case' AND IsActive = true AND Name =: CRM_POSTVENDITA_RT].Id;
		//casoPV.OwnerId = pvForm.userData.user.Id;
		casoPV.ActivityType__c = CaseUtils.CRM_POSTVENDITA;
		casoPV.AccountId = accountPV.Id;
		casoPV.Branch__c = pvForm.userData.accountOffice.Id;
		casoPV.Status = CaseUtils.APERTO;
		casoPV.Subject = pvForm.categoriaPV.Name;
		casoPV.DescrizioneMotivo__c = pvForm.motivazione;
		if(pvForm.urgente==null) {
			casoPV.Urgente__c = 'No';
		}else{
			casoPV.Urgente__c = pvForm.urgente;
			if(casoPV.Urgente__c == 'Si') {
				casoPV.Subject = '-- Urgente -- ' + pvForm.categoriaPV.Name;
			}
		}

		// AV aggiunto pratica e tipo
		System.debug('aaaaaaaaaaaaaaa' + pvForm.pratica);
		if ( pvForm.pratica != null) {
			casoPV.NumeroPratica__c = pvForm.pratica.numPratica;
			casoPV.Tipo_Pratica__c = pvForm.pratica.tipoPratica;
			casoPV.stato_ocs__c = pvForm.pratica.statoPratica;
	        casoPV.CodiceDealer__c = pvForm.pratica.convenzionato;
			System.debug('aaaaaaaaaaaaaaa' +casoPV);
		}

		// generalmente passato dall'esterno		
		if(pvForm.parentId !=null) {
			casoPV.ParentId = pvForm.parentId;
		}

		casoPV.Step_PV__c = '1';
		casoPV.Disposition__c = pvForm.categoriaPV.XCS_Disposition__c;
		return casoPV;
	}

	// override in ogni specifico postvendita in caso di dati aggiuntivi al Case
	public abstract Case completaCasePostVendita(Case casoPV,PVForm pvForm);

	// override in ogni specifico postvendita per la preparazione dei parametri da passare al template per le note
	// AV FIX ma è proprio necessario che ogni P abbia questo metodo visto che le note sono le stesse??
	public abstract String recuperaNotaSpecificaPV(PVForm pvForm,Case casoPV);

	// override solo se necessario in ogni specifico postvendita per la visualizzazione di alert specifici del PV
	public virtual void alertMessaggi(PVForm pvForm,Case casoPV){
	}

	// override solo se necessario in ogni specifico postvendita per la preparazione dei parametri da passare al template per le note
	public virtual void insertTabelleExtra(PVForm pvForm,Case casoPV) {
	}


	public List<String> preparaParametriTemplateNotaCommon(PVForm pvForm,Case casoPV, String notaSpecificaPV){
		List<String> parametriTemplateNota=new List<String>();
		//List<UserRole> roles=[select Name from UserRole where Id=:UserInfo.getUserRoleId()];
		//String role='[Null Role]';
		//if(roles.size()>0){role=roles[0].Name;}
		//parametriTemplateNota.add('<br>' + role);																//0 : ruolo
		//parametriTemplateNota.add([select LastName, Alias from User where Id=:UserInfo.getUserId()].Alias);		//1 : utente
		parametriTemplateNota.add(pvForm.userData.user.UserRole.Name);                                                                          //0 : ruolo
		parametriTemplateNota.add(pvForm.userData.user.Alias);                                               //1 : utente
		parametriTemplateNota.add(casoPV.Status);                                                                                                                       //2 : stato
		parametriTemplateNota.add(casoPV.Urgente__c==null ? 'No' : casoPV.Urgente__c);                                                  //3 : Urgente
		parametriTemplateNota.add(casoPV.DescrizioneMotivo__c!=null ? casoPV.DescrizioneMotivo__c : '');        //4 : Descrizione motivazione
		parametriTemplateNota.add(pvForm.cliente.codCliente);                                                                                           //5 : Codice Cliente
		parametriTemplateNota.add(pvForm.cliente.denominazioneAzienda);                                                                         //6 : Nome Cliente

		// AV TODO DA FARE nel template va aggiunto un placeholder sia per sottotipologia che per motivazione(reason)
		// che alimentiamo eventualmente se i due campi standard sono valorizzati
		// AV TODO inoltre potrebbe valere lo stesso per motivazione campo testo
/*Sottotipologia: Addebito Specifico
Motivazione: Contestazione cliente		
Descrizione motivazione: bla bla dell'utente
*/
		//7 Sottotipologia e Reason - sabry: aggiunto parametro
		String parametroNotaSottotipologiaReason = '';
		if(pvForm.sottotipologiaMdt!=null){
			parametroNotaSottotipologiaReason += 'Sottotipologia: ' + pvForm.sottotipologiaMdt.Descrizione__c + '\n';
		}
		if(pvForm.reasonMdt!=null){
			parametroNotaSottotipologiaReason += 'Motivo: ' + pvForm.reasonMdt.Descrizione__c;
		}
		parametriTemplateNota.add(parametroNotaSottotipologiaReason);


		//8 : Note specifiche PV
		parametriTemplateNota.add(notaSpecificaPV);

		parametriTemplateNota.add(pvForm.note!=null ? pvForm.note : '' + '<br>');                                                       //9 : note
		System.debug('*** parametriTemplateNota : '+parametriTemplateNota);
		return parametriTemplateNota;
	}

	public XCS_Messaggio__c preparaMessaggioOCSCommon(PVForm pvForm,String noteOCS){
		//!!!ATTENZIONE preparazione XCS_Messaggio da distinguere se si tratta di nota cliente o pratica
		XCS_Messaggio__c xcs_messaggio = new XCS_Messaggio__c();
		xcs_messaggio.RecordTypeId = [select Id from RecordType where SobjectType = 'XCS_Messaggio__c' AND IsActive = true AND Name =: 'Note'].Id;
		xcs_messaggio.CompanyType__c = 'COMPASS';
		xcs_messaggio.Modalita__c = 'A';
		xcs_messaggio.TipoNote__c = 'P';
		xcs_messaggio.Testo__c = noteOCS;
		//completo nel metodo override di ogni singolo postvendita (cliente o pratica)
		return preparaMessaggioOCS(pvForm,xcs_messaggio);
	}
	// override in ogni specifico postvendita per la preparazione record note da passare a OCS
	public abstract XCS_Messaggio__c preparaMessaggioOCS(PVForm pvForm,XCS_Messaggio__c xcs_messaggio);

	private String buildHeadAndFoot(String idCaso,List<String> parametriTemplateNota,String body,String categoria){
		String caseNumber = CaseUtils.getCaseNumber(idCaso);
		return buildHeader(caseNumber,categoria)+buildBodyPostVendita(parametriTemplateNota,body)+buildFooter(caseNumber);
	}
	private String buildHeader(String caseNumber,String categoria){
		List<String> parametriTemplateHeader=new List<String>();
		parametriTemplateHeader.add(caseNumber);
		parametriTemplateHeader.add(categoria);
		return XCS_TemplateUtils.buildTemplateByName('postvendita.header',parametriTemplateHeader);
	}
	private String buildFooter(String caseNumber){
		return XCS_TemplateUtils.buildTemplateByName('postvendita.footer',new List<String> {caseNumber});
	}

	private String buildBodyPostVendita(List<String> parametriTemplateNota,String body){
		return XCS_TemplateUtils.buildTemplatePVByName(parametriTemplateNota,body);
	}

	public static void gestisciException(String messaggio_errore){
		throw new AuraHandledException('Si è verificato un errore: ' + messaggio_errore);
	}

	public String loggaException(Exception e){
		system.debug('-- ERRORE PVAction: ' + e.getMessage());
		system.debug(e.getStackTraceString());
		system.debug('-- FINE ERRORE PVAction--');
		return e.getMessage();
	}

	public static void postANotePV(String recordId,String title,String body){


		String formattedBody = body;
/*        if (body.contains('<br>')){
            formattedBody = '<p>' + body.replaceAll('<br>','</p><p>') + '</p>';
        }
        system.debug('****  formattedBody : ' + formattedBody);
 */
		formattedBody = body.replaceAll('<br>','\n');


		//ContentNote res=new ContentNote();
		/*
		   res.Title=title;
		   res.Content=Blob.valueOf(formattedBody);
		   insert res;


		   ContentDocumentLink link=new ContentDocumentLink();
		   system.debug('****  ContentDocumentLink : res.id = ' + res.id);
		   link.ContentDocumentId=res.id;
		   system.debug('****  ContentDocumentLink : recordId = ' + recordId);
		   link.LinkedEntityId=recordId;
		   link.ShareType='I';
		   link.Visibility='AllUsers';
		   system.debug('****  ContentDocumentLink : inserimento....');
		   insert link;
		   system.debug('****  ContentDocumentLink : ....fatto ');
		 */
		//XCSChatterUtils.postMessageWithMention('Monitoraggio Dealer', recordId, message, true);


		//ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), recordId, ConnectApi.FeedElementType.FeedItem, formattedBody);
		/*        ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
		        ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
		        ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
		        ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
		                    messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();

		        textSegmentInput.text = formattedBody;
		        messageBodyInput.messageSegments.add(textSegmentInput);

		                    feedItemInput.body = messageBodyInput;
		        feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
		        feedItemInput.subjectId = recordId;
		        ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(null, feedItemInput);
		 */
		XCSChatterUtils.postMessagePV(recordId, formattedBody);

		//return res;

/* METADATALOADER
   public with sharing class MetadataRecordDataController {

    @AuraEnabled
    public static SObject loadRecord(String fullName, String fields) {
        // TODO: Protected against SOQL injection etc...
        // TODO: Better unhandled excepiton handling, looks like these have to be wrapped in AuraHandledException's
        List<String> fullNameParts = fullName.split('\\.');
        List<SObject> records = Database.query('select ' + fields + ' from ' + fullNameParts[0] + '__mdt where DeveloperName = \'' + fullNameParts[1] + '\'');
        if(records.size()==0) {
            throw new AuraHandledException('Record not found');
        }
        return records[0];
    }

    @AuraEnabled
    public static String upsertRecord(SObject record) {
        return CustomMetadata.Operations
            .callback(
                MetadataDeployment__e.getSObjectType(),
                MetadataDeployment__e.DeploymentId__c,
                MetadataDeployment__e.Result__c)
            .enqueueUpsertRecords(
                new List<SObject> { record })
            .deployId;
    }
   }*/

	}


}