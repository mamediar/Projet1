public class SFAConvenzionamento2IDMAccolloCtrller {
  
    @AuraEnabled
    public static Dati getDati(String dossierId ) {        
        Dati dati=new Dati();
        Dossier__c dossier = SFAConvenzionamento.getDossier(dossierId);
        dati.caseId=dossier.IdAttivita__c;
        dati.dossier=dossier;
        dati.dossierId=dossier.Id;
        dati.disableButtonConferma=true;
        Account dealer = SFAConvenzionamento.getDealer(dati.caseId);       
        Case caseAttivita =SFAConvenzionamento.getCase(dati.caseId);
        dati.caseAttivita=caseAttivita;
        List<SFADossierDocumento__c> documentiListAll = SFAConvenzionamento.getDossierDocumenti(dati.caseId,dossier); 
        List<SFADossierDocumento__c> documentiList = SFAConvenzionamento.getDocumentiList(documentiListAll);
        
        if(dossier.IsDocumentiNonManipolati__c && dossier.IsDocumentiCompleti__c){
            dati.disableButtonConferma=false;
        }
        System.debug('*****dati.disableButtonConferma: '+dati.disableButtonConferma);
 		System.debug('***IsDocumentiNonManipolati__c && IsDocumentiCompleti__c: '+ dossier.IsDocumentiNonManipolati__c +'__' +dossier.IsDocumentiCompleti__c);
        dati.isInManoAdIDM=SFAConvenzionamento.evaluateActivityOwnershipRole(dati.caseId,GroupUtils.IDM_RITORNIPOSTALI);
        if(SFAConvenzionamento.evaluateActivityOwnership(dati.caseId,caseAttivita.OCSExternalFilialeConvenzionato__c)){
            dati.message='Accollo gestito - ora in mano alla filiale di competenza.';
        } else if(SFAConvenzionamento.evaluateActivityOwnership(dati.caseId,SFAConvenzionamento.queueMD)){
            dati.message='Accollo gestito - ora in mano a Monitoraggio Dealer.';
        } else {
            dati.message='Accollo gestito ed inviato all\'ufficio di competenza.';
        }
        dati.dealerId=dealer.Id;
        Account acc = [SELECT ParentId,Tipo_Intermediario__c FROM Account WHERE Id=:dealer.Id];
         System.debug('*****AccountMast: '+acc);
        dati.MasterDealerId = acc.ParentId;
        System.debug('*****MasterDealerId: '+dati.MasterDealerId);
        
        dati.tipoIntermediario=acc.Tipo_Intermediario__c;
        dati.OCSExternalFiliale=dealer.OCS_External_Id__c.Substring(1);
        dati.documentiList=documentiList;
        System.debug('*****documentiList: '+documentiList);
        //System.debug('*****documentiList.NumeroAllegati__c: '+documentiList.NumeroAllegati__c);
        return dati;
    }      
    
   @AuraEnabled  
   public static List<ContentDocument> getFileAllegati(String recordId, boolean IsCreato ){
       List<SFADossierDocumento__c> dossierDocumento=SFAConvenzionamento.getDossierDocumento(recordId);

       if(dossierDocumento.size()>0){
           dossierDocumento[0].NumeroAllegati__c=CompassUtils.numberOfAttach(recordId);  
           update dossierDocumento[0];  
           
       }
       List<ContentDocument> Document = new List<ContentDocument>();
       Document = CompassUtils.getAttachments(recordId); 
       
 /*      if(IsCreato == true){
      	 if(Document.size()>0 && IdDoc !='')
       		AggiornaRecordNascosto(recordId,IdDossier,IdDoc,Document);
       }*/
    
       return Document;
   }   
   
   @AuraEnabled  
   public static void AggiornaRecordNascosto(string IdDossierDoc,Id idDoc){       
       
       List<SFADossierDocumento__c> dossierDocumento=SFAConvenzionamento.getDossierDocumento(IdDossierDoc);
       string IdDossier = '';
       string IdDocList = '';
       decimal NumDoc;
       System.debug('***idDoc***: '+idDoc);
       if(dossierDocumento.size()>0){
       		IdDocList= dossierDocumento[0].SFAConvenzDealerDocumentsList__c;
           	IdDossier = dossierDocumento[0].Dossier__c;
            NumDoc = dossierDocumento[0].NumeroAllegati__c;
      		list<Id> docIdList  = new list<Id>(); 
          	docIdList.add(idDoc);
       		Map<Id, Id> linkDoc = new Map<Id, Id>();
       		list<ContentDocumentLink> DocLink = New List<ContentDocumentLink>();

           	system.debug('AggiornaRecordNascosto - docIdList:  ' + idDoc);
           
           List<ContentDocumentLink> cdl=[select id,LinkedEntityId,ContentDocumentId from ContentDocumentLink where ContentDocumentId = :docIdList]; 
           	system.debug('AggiornaRecordNascosto - cdl:  ' + cdl);
           
          	for(ContentDocumentLink cdLink:cdl){  
               linkDoc.put(cdLink.LinkedEntityId,cdLink.ContentDocumentId);  
           	}
       
       list<SFADossierDocumento__c> dossDocDaAgg = [select Id , NumeroAllegati__c from SFADossierDocumento__c where SFAConvenzDealerDocumentsList__c = :IdDocList and  Dossier__c=:IdDossier and  Id != :IdDossierDoc AND Rimozione_Logica__c = false ];
       if(dossDocDaAgg.size()!=0){
          for(SFADossierDocumento__c dDoc : dossDocDaAgg) {
              if(!linkDoc.containsKey(dDoc.Id)){
                system.debug('AggiornaRecordNascosto - linkDoc.get(dDoc.Id):  ' + idDoc);
                system.debug('AggiornaRecordNascosto - dDoc.Id:  ' + dDoc.Id);
                  
              	DocLink.add(new ContentDocumentLink(ContentDocumentId = idDoc, LinkedEntityId = dDoc.Id, ShareType = 'I', Visibility = 'AllUsers'));
				dDoc.NumeroAllegati__c=NumDoc; 
                system.debug('dDoc.NumeroAllegati__c ' + NumDoc);
      		  }		                  
          }
		  insert DocLink;
		  update dossDocDaAgg;		
		}
       
       }
     
   }
    
   @AuraEnabled  
   public static void assignToFiliale(string caseId, string dossierId, String note){       
       Case caseAttivita= SFAConvenzionamento.getCase(caseId);
       caseAttivita.Status=CaseUtils.SOSPESO;
       caseAttivita=CaseUtils.aggiornaDispositionCase(caseAttivita,XCS_DispositionUtils.ACCOLLO_INCOMPLETO_IDM,false);   //non riassegna nulla perchè la filiale è già owner del case
       caseAttivita=SFAConvenzionamento.utenteLavorazione(caseAttivita,caseAttivita.OCSExternalFilialeConvenzionato__c,false);
       caseAttivita.StepAttivitaConvenzionamento__c=SFAConvenzionamento.GAD_DocumentiObbligatori;
       update caseAttivita;
       
       //aggiorna campi del dossier
       Date today = Date.today();
       Dossier__c dossier= SFAConvenzionamento.getDossier(dossierId);
       dossier.DataLavorazioneIDM__c=today;
	   note=String.isEmpty(note)?'':(note+'\n');       
       if(!dossier.IsDocumentiCompleti__c){
           note+='Documenti NON formalmente completi, firmati ed integri.\n';
       }
       if(!dossier.IsDocumentiNonManipolati__c){
           note+='Documenti Manipolati.\n';
       }  
       dossier.Note__c=note;    
       dossier.IsDossierReinviato__c=true;    
	   update dossier;   
       
       //posta nota nel ContentNote
       if(!String.IsEmpty(note)){
           XCSNoteUtils.postANote(caseId,'IDM',note);
       }
       XCSNoteUtils.postANote(caseId,SFAConvenzionamento.TITLE_NOTE_EVENTO,SFAConvenzionamento.NOTA_EVENTO_ACCOLLO_RICONSEGNATOFILIALE);
       
       //invio emailPersonaDiRiferimento alla filiale con i dettagli della segnalazione da gestire:
       List<String> lstOCSExternal=new List<String>();
       List<String> lstEmailcc=new List<String>();
       //email template:
       String emailTemplateSegnalazioneDealer='SFA_Convenzionamento_Dossier_DaIDM';
       //recupera email Monitoraggio Dealer:
       String EmailGDV= CompassParametersUtils.getValue('gdv.mail');
       lstEmailcc.add(EmailGDV);       
	   //recupera email filiale:
       lstOCSExternal.add(caseAttivita.OCSExternalFilialeConvenzionato__c);
       RoleUtils.lstIndirizziEmail lstIndirizziEmail= RoleUtils.recoverListRolesEmail(lstOCSExternal);   //creo un oggetto per memorizzarmi la rsposta della classe e poi recupero gli indirizzi delle filiali e coord e regional a cui inviare l'email, oltre al template che wserve (da chiedere ad Alessio)
	   lstEmailcc.addAll(lstIndirizziEmail.emailManagerFiliali); 
       System.debug('$$$$$$$$$$$$$lstEmail:: '+lstEmailcc);
       //invia email
  //Da ripristinare     Messaging.SingleEmailMessage messageMail = EmailUtils.generateEmail(emailTemplateSegnalazioneDealer,lstIndirizziEmail.emailFiliali,lstEmailcc,dossier.Id);
  //Da ripristinare    EmailUtils.sendEmail(messageMail);  
   }
    
   @AuraEnabled  
   public static void assignToMD(string caseId, string dossierId, String note){
	   
       Case caseAttivita= SFAConvenzionamento.getCase(caseId);
       caseAttivita.Status=CaseUtils.LAVORATA;  
       caseAttivita=CaseUtils.aggiornaDispositionCase(caseAttivita,XCS_DispositionUtils.ACCOLLO_COMPLETO_IDM,false);
       caseAttivita=SFAConvenzionamento.utenteLavorazione(caseAttivita,SFAConvenzionamento.queueMD,false);
       caseAttivita=CaseShareUtil.appendStringToCaseShare(caseAttivita,SFAConvenzionamento.sharingToMD);      
       update caseAttivita;
       
       Date today = Date.today();
       Dossier__c dossier = new Dossier__c(Id=dossierId);
       dossier.DataLavorazioneIDM__c=today;
	   update dossier;
       
       //posta nota nel ContentNote
       if(!String.IsEmpty(note)){
           XCSNoteUtils.postANote(caseId,'IDM',note);
       }
       XCSNoteUtils.postANote(caseId,SFAConvenzionamento.TITLE_NOTE_EVENTO,SFAConvenzionamento.NOTA_EVENTO_ACCOLLO_COMPLETAMENTOIDM);
   } 
    
   @AuraEnabled
    public static void AnnullaAccollo(String caseId, String note)
    {   
		Case caseAttivita= SFAConvenzionamento.getCase(caseId);
		caseAttivita.Status=CaseUtils.ANNULLATO;
		caseAttivita=CaseUtils.aggiornaDispositionCase(caseAttivita,XCS_DispositionUtils.ACCOLLO_ANNULLATO_MD,false);
        caseAttivita.Utente_Lavorazione__c='';   //il case non è più in lavorazione da nessuno
		update caseAttivita;
         CancellazioneRimossi(CaseId);

        if(!String.isEmpty(note)){
            XCSNoteUtils.postANote(caseId,'IDM',note);
        }
        else{
            XCSNoteUtils.postANote(caseId,'IDM','ANNULLATO - IDM');
        }
	}
	
	
	@AuraEnabled
    public static void CancellazioneRimossi(String caseId)
    {   
		Dossier__c dossier = SFAConvenzionamento.getIdAccollo_Dossier_ByCase(caseId);
        list<SFADossierDocumento__c> DossDocRemove = new  list<SFADossierDocumento__c>();
        list<Accolli_type__c> AccTypeRemove = new  list<Accolli_type__c>();
         System.debug('RimozzioneaccolloID:  ** '+dossier.Id);
        
        DossDocRemove = [SELECT Id FROM SFADossierDocumento__c  WHERE Dossier__c=:dossier.Id AND Rimozione_Logica__c = true];
        AccTypeRemove = [select Id From Accolli_type__c where Accollo_Id__c =:dossier.Id and Rimozione_Logica__c = true];
         System.debug('RimozzioneListaDoc:  ** '+DossDocRemove);
         System.debug('RimozzioneListaJunk:  ** '+AccTypeRemove);
        
        if(DossDocRemove.size() > 0)
        	delete DossDocRemove;
        if(AccTypeRemove.size() > 0)
        	delete AccTypeRemove;
	}
  
    
 	public class Dati {
        @AuraEnabled
        public Id dealerId {get; set;} 
          @AuraEnabled
        public Id MasterDealerId {get; set;} 
        @AuraEnabled
        public String tipoIntermediario {get; set;} 
        @AuraEnabled
        public Id caseId {get; set;}
        @AuraEnabled
        public Case caseAttivita {get; set;}
        @AuraEnabled
        public Boolean disableButtonConferma {get; set;}
        @AuraEnabled
        public Boolean isInManoAdIDM {get; set;}        
        @AuraEnabled
        public String OCSExternalFiliale {get; set;}     
        @AuraEnabled
        public String message {get; set;}         
        @AuraEnabled
        public List<SFADossierDocumento__c> documentiList {get; set;}     
        @AuraEnabled
        public String Partita_IVA {get; set;}         
        @AuraEnabled
        public String Name {get; set;} 
        @AuraEnabled
        public String OCS_External_Id {get; set;}         
        @AuraEnabled
        public String dossierId {get; set;}      
        @AuraEnabled
        public Dossier__c dossier {get; set;}     
    }   
    
   /*@AuraEnabled  
   public static List<ContentDocument> allegaFile(string documentId, string recordId){
         CompassUtils.attachFile(documentId,recordId,'C'); 
         return CompassUtils.getAttachments(recordId); 
   }*/      
    
}