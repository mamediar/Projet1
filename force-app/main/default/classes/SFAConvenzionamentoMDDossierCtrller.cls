public class SFAConvenzionamentoMDDossierCtrller {
  
    @AuraEnabled
    public static Dati getDati(String dossierId ) {  
        Dati dati=new Dati();
        Dossier__c dossier = SFAConvenzionamento.getDossier(dossierId);
        dati.caseId=dossier.IdAttivita__c;
        dati.dossierId=dossier.Id;
        dati.dossier=dossier;
        dati.disableButtonConferma=true;
        dati.isAutonomiaSede=false;
        dati.caseUtenteAppropriato=false;
        dati.actualUserOwnerCase=true;
        Account dealer = SFAConvenzionamento.getDealer(dati.caseId);       
        Case caseAttivita =SFAConvenzionamento.getCase(dati.caseId);
        if(caseAttivita.IsAutonomiaConvenzionamentoSede__c ){
            dati.isAutonomiaSede=true;
            dati.dataRiconsegnaAFiliale=caseAttivita.DataTermineLavoro__c;
            dati.dataAssegnazioneAdAV=caseAttivita.Data_Ricezione__c;
        }
        if(!String.isEmpty(caseAttivita.Owner_User__c)){
            dati.caseUtenteAppropriato=true;
            dati.actualUserOwnerCase=SFAConvenzionamento.evaluateCaseUserOwner(caseAttivita);  
        }
       
        String dispositionExternalId=XCS_DispositionUtils.getDispositionExternalId(caseAttivita.Disposition__c);
        List<SFADossierDocumento__c> documentiList = SFAConvenzionamento.getDossierDocumenti(dati.caseId,dossier);        
        if(dossier.IsDocumentiNonManipolati__c && dossier.IsDocumentiCompleti__c){
            dati.disableButtonConferma=false;
        }
        dati.isInManoAdMD=SFAConvenzionamento.evaluateActivityOwnership(dati.caseId,GroupUtils.QUEUE_MD);
        if(!dati.isInManoAdMD){
            dati.message=SFAConvenzionamento.getMessageToVisualize('Monitoraggio Dealer',dispositionExternalId);
            if(String.isEmpty(dati.message)){
                dati.message='Dossier gestito.'; //aggiungere messaggio generico da visualizzare
            }
        }
        dati.dealerId=dealer.Id;
        dati.OCSExternalFiliale=dealer.OCS_External_Id__c.Substring(1);
        dati.documentiList=documentiList;
        System.debug('*****documentiList: '+documentiList);
        //System.debug('*****documentiList.NumeroAllegati__c: '+documentiList[0].NumeroAllegati__c);

        //Gestione visibilità bottoni
        dati.showButtons=getIfShowButtons(dispositionExternalId,dealer.Status__c);
		//dati.showButtons=getIfShowButtons('DP1911',dealer.Status__c);
        
        return dati;
    }      


   @AuraEnabled  
   public static ShowButtons getIfShowButtons(String dispositionExternalId, String dealerStatus){
       ShowButtons showButtons = new ShowButtons();
       showButtons.showButtonApprova=false;
       showButtons.showButtonRichiediMaggioriInformazioni=false;
       showButtons.showButtonSospendi=false;
       showButtons.showButtonRespingi=false;
       showButtons.showButtonCambiaStato=false;
       if(!String.isEmpty(dispositionExternalId)){
           List<String> disp_Approva_Info_Sospendi = new list<String> {XCS_DispositionUtils.DOSSIER_DISPONIBILE, XCS_DispositionUtils.DOSSIER_SOSPESO_MD};
           List<String> disp_CambiaStato = new list<String> {XCS_DispositionUtils.DOSSIER_DISPONIBILE, XCS_DispositionUtils.DOSSIER_APPROVATO, XCS_DispositionUtils.DOSSIER_RESPINTO};                
           if(disp_Approva_Info_Sospendi.contains(dispositionExternalId)){
               showButtons.showButtonApprova=true;     
               showButtons.showButtonRichiediMaggioriInformazioni=true;     
               showButtons.showButtonSospendi=true;
               if(dealerStatus=='CH'){
                   showButtons.showButtonRespingi=true;
               }
           }
           if(disp_CambiaStato.contains(dispositionExternalId) && dealerStatus=='CH'){
               showButtons.showButtonCambiaStato=true;     
           }       
       }
       
       return showButtons; 
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
    public static void deleteFile(String fileId)
    {   
		fileId = fileId.Substring(1);
		SFACancellazioneFile.deleteFile(fileId);
	}

	@AuraEnabled
    public static void approva(String caseId, String note)
    {   
		Case caseAttivita= SFAConvenzionamento.getCase(caseId);
		caseAttivita.Status=CaseUtils.GESTITO;
		caseAttivita=CaseUtils.aggiornaDispositionCase(caseAttivita,XCS_DispositionUtils.DOSSIER_APPROVATO,false);
        caseAttivita.Utente_Lavorazione__c='';   //il case non è più in lavorazione da nessuno
		update caseAttivita;

        if(!String.isEmpty(note)){
            XCSNoteUtils.postANote(caseId,'MD',note);
        }
	}

	@AuraEnabled
    public static void richiediMaggioriInformazioni(String caseId, String note)
    {   
		Case caseAttivita= SFAConvenzionamento.getCase(caseId);
		caseAttivita.Status=CaseUtils.SOSPESO;
		caseAttivita=CaseUtils.aggiornaDispositionCase(caseAttivita,XCS_DispositionUtils.DOSSIER_INCOMPLETO_MD,false);
		caseAttivita=SFAConvenzionamento.utenteLavorazione(caseAttivita,caseAttivita.OCSExternalFilialeConvenzionato__c,false);
		
		update caseAttivita;
        
        if(!String.isEmpty(note)){
            XCSNoteUtils.postANote(caseId,'MD',note);
        }
		
	}

	@AuraEnabled
    public static void sospendi(String caseId, String note)  //cambia solo la disposition e lo stato, per il resto non cambia nulla e il case rimane in carico a MD
    {   
		Case caseAttivita= SFAConvenzionamento.getCase(caseId);
		caseAttivita.Status=CaseUtils.SOSPESO;
		caseAttivita=CaseUtils.aggiornaDispositionCase(caseAttivita,XCS_DispositionUtils.DOSSIER_SOSPESO_MD,false);
		
		update caseAttivita;

        if(!String.isEmpty(note)){
            XCSNoteUtils.postANote(caseId,'MD',note);
        }
	}

	@AuraEnabled
    public static void respingi(String caseId, String note)
    {   
		Case caseAttivita= SFAConvenzionamento.getCase(caseId);
		caseAttivita.Status=CaseUtils.GESTITO;
		caseAttivita=CaseUtils.aggiornaDispositionCase(caseAttivita,XCS_DispositionUtils.DOSSIER_RESPINTO,false);
		caseAttivita.Utente_Lavorazione__c='';   //il case non è più in lavorazione da nessuno
		update caseAttivita;

        if(!String.isEmpty(note)){
            XCSNoteUtils.postANote(caseId,'MD',note);
        }
	}    
    
	@AuraEnabled
    public static void prendiCase(String caseId)
    {   
		CaseUtils.popolateOwner(caseId);
	}     
    
 	public class Dati {
        @AuraEnabled
        public Id dealerId {get; set;} 
        @AuraEnabled
        public Id caseId {get; set;}     
        @AuraEnabled
        public Boolean disableButtonConferma {get; set;}
        @AuraEnabled
        public Boolean isAutonomiaSede {get; set;}        
        @AuraEnabled
        public Boolean isInManoAdMD {get; set;} 
        @AuraEnabled
        public Boolean isInManoAdUtenteConnesso {get; set;}   
        @AuraEnabled
        public Boolean nomeUtenteOwnerDossier {get; set;}         
        @AuraEnabled
        public Boolean caseUtenteAppropriato {get; set;}   
        @AuraEnabled
        public Boolean actualUserOwnerCase {get; set;}        
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
        @AuraEnabled
        public Datetime dataAssegnazioneAdAV {get; set;}           
        @AuraEnabled
        public Datetime dataRiconsegnaAFiliale {get; set;}           
        @AuraEnabled
        public ShowButtons showButtons {get; set;}         
    
    } 
    
 	public class ShowButtons {     
        @AuraEnabled
        public Boolean showButtonApprova {get; set;}
        @AuraEnabled
        public Boolean showButtonRichiediMaggioriInformazioni {get; set;} 
        @AuraEnabled
        public Boolean showButtonSospendi {get; set;}
        @AuraEnabled
        public Boolean showButtonRespingi {get; set;}  
        @AuraEnabled
        public Boolean showButtonCambiaStato {get; set;}        
    }

    
}