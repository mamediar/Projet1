public class SFAConvenzionamentoIDMDossierCtrller {
  
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
        List<SFADossierDocumento__c> documentiList = SFAConvenzionamento.getDossierDocumenti(dati.caseId,dossier);        
        if(dossier.IsDocumentiNonManipolati__c && dossier.IsDocumentiCompleti__c){
            dati.disableButtonConferma=false;
        }
        dati.isInManoAdIDM=SFAConvenzionamento.evaluateActivityOwnershipRole(dati.caseId,GroupUtils.IDM_RITORNIPOSTALI);
        if(SFAConvenzionamento.evaluateActivityOwnership(dati.caseId,caseAttivita.OCSExternalFilialeConvenzionato__c)){
            dati.message='Dossier gestito - ora in mano alla filiale di competenza.';
        } else if(SFAConvenzionamento.evaluateActivityOwnership(dati.caseId,SFAConvenzionamento.queueMD)){
            dati.message='Dossier gestito - ora in mano a Monitoraggio Dealer.';
        } else {
            dati.message='Dossier gestito ed inviato all\'ufficio di competenza.';
        }
        dati.dealerId=dealer.Id;
        dati.OCSExternalFiliale=dealer.OCS_External_Id__c.Substring(1);
        dati.documentiList=documentiList;
        System.debug('*****documentiList: '+documentiList);
        //System.debug('*****documentiList.NumeroAllegati__c: '+documentiList.NumeroAllegati__c);
        return dati;
    }      
    
   @AuraEnabled  
   public static List<ContentDocument> getFileAllegati(String recordId){
       List<SFADossierDocumento__c> dossierDocumento=SFAConvenzionamento.getDossierDocumento(recordId);
       if(dossierDocumento.size()>0){
           dossierDocumento[0].NumeroAllegati__c=CompassUtils.numberOfAttach(recordId);
           update dossierDocumento[0];           
       } else {
           Dossier__c dossier=SFAConvenzionamento.getDossier(recordId);
           dossier.NumeroAllegati__c=CompassUtils.numberOfAttach(recordId);
           update dossier;
       }
       return CompassUtils.getAttachments(recordId); 
   }   
    
   @AuraEnabled  
   public static void assignToFiliale(string caseId, string dossierId, String note){       
       Case caseAttivita= SFAConvenzionamento.getCase(caseId);
       caseAttivita.Status=CaseUtils.SOSPESO;
       caseAttivita=CaseUtils.aggiornaDispositionCase(caseAttivita,XCS_DispositionUtils.DOSSIER_INCOMPLETO_IDM,false);   //non riassegna nulla perchè la filiale è già owner del case
       caseAttivita=SFAConvenzionamento.utenteLavorazione(caseAttivita,caseAttivita.OCSExternalFilialeConvenzionato__c,false);
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
       XCSNoteUtils.postANote(caseId,SFAConvenzionamento.TITLE_NOTE_EVENTO,SFAConvenzionamento.NOTA_EVENTO_DOSSIER_RICONSEGNATOFILIALE);
       
       //invio emailPersonaDiRiferimento alla filiale con i dettagli della segnalazione da gestire:
       List<String> lstOCSExternal=new List<String>();
       List<String> lstEmailcc=new List<String>();
       //email template:
       String emailTemplateSegnalazioneDealer='SFA_Convenzionamento_Dossier_DaIDM';
       //recupera email Monitoraggio Dealer:
       String EmailGDV= CompassParametersUtils.getValue('monitoraggioDealer.mail');
        System.debug('EmailGDV: '+EmailGDV);
       lstEmailcc.add(EmailGDV);       
	   //recupera email filiale:
       lstOCSExternal.add(caseAttivita.OCSExternalFilialeConvenzionato__c);
       RoleUtils.lstIndirizziEmail lstIndirizziEmail= RoleUtils.recoverListRolesEmail(lstOCSExternal);   //creo un oggetto per memorizzarmi la rsposta della classe e poi recupero gli indirizzi delle filiali e coord e regional a cui inviare l'email, oltre al template che wserve (da chiedere ad Alessio)
	   lstEmailcc.addAll(lstIndirizziEmail.emailManagerFiliali); 
       System.debug('$$$$$$$$$$$$$lstEmail:: '+lstEmailcc);
       //invia email
       Messaging.SingleEmailMessage messageMail = EmailUtils.generateEmail(emailTemplateSegnalazioneDealer,lstIndirizziEmail.emailFiliali,lstEmailcc,dossier.Id);
       EmailUtils.sendEmail(messageMail);  
   }
    
   @AuraEnabled  
   public static void assignToMD(string caseId, string dossierId, String note){
	   
       Case caseAttivita= SFAConvenzionamento.getCase(caseId);
       caseAttivita.Status=CaseUtils.LAVORATA;
       caseAttivita=CaseUtils.aggiornaDispositionCase(caseAttivita,XCS_DispositionUtils.DOSSIER_DISPONIBILE,false);
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
       XCSNoteUtils.postANote(caseId,SFAConvenzionamento.TITLE_NOTE_EVENTO,SFAConvenzionamento.NOTA_EVENTO_DOSSIER_COMPLETAMENTOIDM);
   }    
  
    
 	public class Dati {
        @AuraEnabled
        public Id dealerId {get; set;} 
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