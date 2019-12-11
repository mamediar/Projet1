/**
 * @File Name          : PV2550SinistroDaContabInserimento.cls
 * @Description        : 
 * @Author             : Andrea Vanelli
 * @Group              : 
 * @Last Modified By   : sabrina vitali
 * @Last Modified On   : 11/11/2019, 15:35:51
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    10/7/2019, 14:42:18   Andrea Vanelli     Initial Version
**/

public class PV2550SinistroDaContabInserimento extends PVAction  {
	public class PV2550SinistroDaContabilizzareForm extends PVForm {
		@AuraEnabled public OCSPratica pratica {get; set;}

		@AuraEnabled public String dataSinistro {get; set;}
		@AuraEnabled public String tipoSinistro {get; set;}
		@AuraEnabled public String ultimoIndennizzo {get; set;}
		@AuraEnabled public String importoIndennizzo {get; set;}
		@AuraEnabled public String dataDefinizione {get; set;}
		@AuraEnabled public String compagniaAssicurativa {get; set;}
        @AuraEnabled public String filiale {get; set;}
        //sabrina : il PV ha un Case master, Id del Case master
        @AuraEnabled public String parentId {get; set;}
        
	}


	@AuraEnabled
	public static void conferma(PV2550SinistroDaContabilizzareForm datiForm){
		new PV2550SinistroDaContabInserimento().execute(datiForm);
        
        /*******************************
        // AV esempio chiamata esterna

    /***********************/    
/*    
    // prova inserimento PV esterna
    //sremmare!
    PV2550SinistroDaContabInserimento.PV2550SinistroDaContabilizzareForm datiForm = new PV2550SinistroDaContabInserimento.PV2550SinistroDaContabilizzareForm();

    // se si vuole usare l'utente collegato (deve essere correttamente configurato per l'inseimento PV altrimenti verrà ritornata un'eccezione)
    datiForm = (PV2550SinistroDaContabInserimento.PV2550SinistroDaContabilizzareForm) PV2550SinistroDaContabInserimento.prepareFormExternal(datiForm, '2550', null);
    // in alternativa è possibile parrare l'id specifico di un utente (es: simulare l'inserimento da parte di un ufficio specifico)    
    // datiForm = (PV2550SinistroDaContabInserimento.PV2550SinistroDaContabilizzareForm)PV2550SinistroDaContabInserimento.prepareFormExternal(datiForm, '2550', '0050Q000002FQu4QAG');
    
    // i dati del cliente sono obbligatori sono obbligatori    
    // visto che potenzialmente potrebbe essere creata un'anagrafica sarebbe corretto passare tutti quelli a disposizione
    datiForm.cliente = new OCSCliente();
    datiForm.cliente.email = 'POSTVENDITA@EMAIL.TEST';
    datiForm.cliente.codCliente = '1';
    datiForm.cliente.cognome = 'COGNOME';
    datiForm.cliente.nome = 'NOME';
    datiForm.cliente.denominazioneAzienda = 'NOME COGNOME';
    datiForm.cliente.dataNascita = '20100101';

    // note operatore/batch
    datiform.note = 'richiesta creata automaticamente';
    
    // specifici per ogni PV (ho inserito quelli per il 5864)
    datiform.pratica = new OCSPratica();
    datiform.pratica.tipoPratica = 'CA';
    datiform.pratica.numPratica = '2106662676';

    datiform.dataSinistro = '1';
    datiform.tipoSinistro = 'DC';
    datiform.ultimoIndennizzo = '3';
    datiform.importoIndennizzo = '4';
    datiform.dataDefinizione = '5';
    datiform.compagniaAssicurativa = '6';
    datiform.filiale = '11';
    //setto la filiale come Account
    datiForm.userData.accountOffice = AccountUtils.getBranch(datiform.filiale)[0];
	
    //id del Case padre Sinistro Assicurativo
    datiform.parentId = '5005E000005qC9vQAE';

    //System.debug('MDT: '+myForm.reasonMdt.dispositionId__c);
    //preparo la reason
    //select Id, PostvenditaConfig_subtypeId__c, PostvenditaId__c, dispositionId__c, uniqueId__c  from PostvenditaConfig_reason__mdt where Descrizione__c = 'MG' and PostvenditaId__c = 2550
    datiform.reasonMdt = [select Id,Descrizione__c, DeveloperName, dispositionId__c, free_text_required__c, Label, PostvenditaConfig_subtypeId__c, QualifiedApiName, uniqueId__c, Visibility__c from PostvenditaConfig_reason__mdt
			          WHERE PostvenditaId__c =: 2550 AND Descrizione__c =: datiform.tipoSinistro];
    //la disposition verrà inserita in chiusura CCLI !!!
    // esecuzione inserimento
    PV2550SinistroDaContabInserimento.conferma(datiform);
    //se errore il metodo esegue "throw new AuraHandledException"
*/    
	}



	/* metodi NON aura enabled */


	public void execute(PVForm form){
		String messaggio_errore = '';
		try{
			PV2550SinistroDaContabilizzareForm myForm = (PV2550SinistroDaContabilizzareForm) form;
			commonExecute(myForm);
		}catch(Exception e) {
			messaggio_errore = e.getMessage();
		}finally{
			if(messaggio_errore != '') {
				gestisciException(messaggio_errore);
			}
		}
	}



	public override Case completaCasePostVendita(Case casoPV,PVForm form){
		//continuare a valorizzare l'oggetto casoPV integrando i dati di questo post vendita
        //serve solo il parent
        PV2550SinistroDaContabilizzareForm myForm = (PV2550SinistroDaContabilizzareForm) form;
        casoPV.ParentId = myForm.parentId;
        //aggiungere la filiale di riferimento arrivata da form pvForm.userData.accountOffice.Id
		return casoPV;
	}

	public override String recuperaNotaSpecificaPV(PVForm form, Case casoPV){
		//preparazione nota
		PV2550SinistroDaContabilizzareForm myForm = (PV2550SinistroDaContabilizzareForm) form;

		String notaSpecificaPV;
		notaSpecificaPV =  'Sinistro da contabilizzare\n';
		notaSpecificaPV +=  'Pratica : ' + myForm.pratica.tipoPratica + ' ' + myform.pratica.numPratica + '\n';
		notaSpecificaPV +=  'Data sinistro: ' + myForm.dataSinistro + '\n';
		notaSpecificaPV +=  'Tipo sinistro: ' + myForm.tipoSinistro + '\n';
        if(String.isNotBlank(myForm.ultimoIndennizzo)){
		    notaSpecificaPV +=  'Ultimo Indennizzo: ' + myForm.ultimoIndennizzo + '\n';
        }
		notaSpecificaPV +=  'Importo Indennizzo: ' + myForm.importoIndennizzo + '\n';
		notaSpecificaPV +=  'Data definizione: ' + myForm.dataDefinizione + '\n';
		notaSpecificaPV +=  'Compagnia Assicurativa: ' + myForm.compagniaAssicurativa + '\n';
		return notaSpecificaPV;
	}

	public override XCS_Messaggio__c preparaMessaggioOCS(PVForm form, XCS_Messaggio__c xcs_messaggio){
		//preparazione XCS_Messaggio
		//PV2550SinistroDaContabilizzareForm myForm = (PV2550SinistroDaContabilizzareForm) form;
		//xcs_messaggio.CodCliente__c = myForm.cliente.codCliente;
        //sembra che questo PV on scriva note su OCS
		return xcs_messaggio;
	}



}