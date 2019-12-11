public class SFAConvenzionamento2MDAccolloCtrller {
  
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
       
        
       List<Accolli_Type__c> ListAccType =  [SELECT  Id	 FROM Accolli_Type__c WHERE Accollo_Id__c = :dossier.Id and Rimozione_Logica__c = false and AccolloType__r.Accollo_Type_Desc_Abrev__c  ='Addendum GDO'];
       if (ListAccType.size() > 0)
       {
        	dati.ListGDO = [select MasterLabel, Flag_Rientro__c from Accolli_Addendum_GDO__mdt where Tipologia_Accollo__c ='GDO'];
          	dati.VisualizzaGDO=true;
       }
       else
           dati.VisualizzaGDO=false;
        
        String dispositionExternalId=XCS_DispositionUtils.getDispositionExternalId(caseAttivita.Disposition__c);
        List<SFADossierDocumento__c> documentiListAll = SFAConvenzionamento.getDossierDocumenti(dati.caseId,dossier); 
         List<SFADossierDocumento__c> documentiList = SFAConvenzionamento.getDocumentiList(documentiListAll);
        if(dossier.IsDocumentiNonManipolati__c && dossier.IsDocumentiCompleti__c){
            dati.disableButtonConferma=false;
        }
        dati.isInManoAdMD=SFAConvenzionamento.evaluateActivityOwnership(dati.caseId,GroupUtils.QUEUE_MD);
        System.debug('****isInManoAdMD***** : '+ dati.isInManoAdMD);
        if(!dati.isInManoAdMD){
            dati.message=SFAConvenzionamento.getMessageToVisualize('Monitoraggio Dealer',dispositionExternalId);
            if(String.isEmpty(dati.message)){
                dati.message='Accollo gestito.'; //aggiungere messaggio generico da visualizzare
            }
        }
        dati.dealerId=dealer.Id;
        Account acc = [SELECT ParentId,Tipo_Intermediario__c FROM Account WHERE Id=:dealer.Id];
        dati.MasterDealerId=acc.ParentId;
        dati.tipoIntermediario=acc.Tipo_Intermediario__c;
        
        dati.OCSExternalFiliale=dealer.OCS_External_Id__c.Substring(1);
        dati.documentiList=documentiList;
        System.debug('*****documentiList: '+documentiList);
        //System.debug('*****documentiList.NumeroAllegati__c: '+documentiList[0].NumeroAllegati__c);
		System.debug('*****(dispositionExternalId,dealer.Status__c: '+ dispositionExternalId+' __ '+dealer.Status__c);
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
       showButtons.showButtonAnnulla=false;
       if(!String.isEmpty(dispositionExternalId)){
           List<String> disp_Approva_Info_Sospendi = new list<String> {XCS_DispositionUtils.ACCOLLO_COMPLETO_IDM, XCS_DispositionUtils.ACCOLLO_SOSPESO_MD};
           List<String> disp_CambiaStato = new list<String> {XCS_DispositionUtils.ACCOLLO_INCOMPLETO_IDM, XCS_DispositionUtils.ACCOLLO_APPROVATO_MD, XCS_DispositionUtils.ACCOLLO_RESPINTO_MD};                
           if(disp_Approva_Info_Sospendi.contains(dispositionExternalId)){
               showButtons.showButtonApprova=true;     
               showButtons.showButtonRichiediMaggioriInformazioni=true;     
               showButtons.showButtonSospendi=true;
               showButtons.showButtonAnnulla=true;
               showButtons.showButtonRespingi=true;
               
           }
           if(dealerStatus=='CH'){
                   showButtons.showButtonRespingi=true;
               	   showButtons.showButtonAnnulla=true;
               }
           if(disp_CambiaStato.contains(dispositionExternalId)){
               showButtons.showButtonCambiaStato=true;
               showButtons.showButtonAnnulla=true;
           }       
       }
       return showButtons; 
   }
    
    
    
   @AuraEnabled  
   public static List<ContentDocument> getFileAllegati(String recordId){
       List<SFADossierDocumento__c> dossierDocumento=SFAConvenzionamento.getDossierDocumento(recordId);
       string IdDossier = '';
       string IdDocList = '';
       if(dossierDocumento.size()>0){
           dossierDocumento[0].NumeroAllegati__c=CompassUtils.numberOfAttach(recordId);
           update dossierDocumento[0];
           IdDocList= dossierDocumento[0].SFAConvenzDealerDocumentsList__c;
           IdDossier = dossierDocumento[0].Dossier__c;
           AggiornaNascosti(recordId,dossierDocumento[0].NumeroAllegati__c,IdDocList,IdDossier); 
       }   
       return CompassUtils.getAttachments(recordId); 
   }   
    
    public static void  AggiornaNascosti(string recordId, decimal NumAllegati, string IdDocList,string IdDossier){
        list<SFADossierDocumento__c> dossDocDaAgg = [select Id, NumeroAllegati__c from SFADossierDocumento__c where SFAConvenzDealerDocumentsList__c = :IdDocList and  Dossier__c=:IdDossier and  Id != :recordId AND Rimozione_Logica__c = false ];
       if(dossDocDaAgg.size()!=0){
           for(SFADossierDocumento__c Doc : dossDocDaAgg ){
               if(Doc.NumeroAllegati__c!=NumAllegati){
                  Doc.NumeroAllegati__c=NumAllegati;
               }
           }
           update dossDocDaAgg;
       }
    }
    
   @AuraEnabled
    public static void deleteFile(String fileId)
    {   
		fileId = fileId.Substring(1);
		SFACancellazioneFile.deleteFile(fileId);
	}

	@AuraEnabled
    public static boolean approva(String caseId, String note, integer GDOSelezionato,String DealerCode)
    {   
        system.debug('ApprovaApex!!!! : ');
     	boolean Procedi = false;
        if(GDOSelezionato != null)
        {
            RientroAddendumConvenzionatoInvoker.response res = RientroAddendumConvenzionatoInvoker.invoke(DealerCode,GDOSelezionato);
             system.debug('RispostaInvoker : '+res.isOK());
        	 procedi = res.isOK();          
        }
        else{
         	Procedi = true;
        }
    	
        if(Procedi){
            Case caseAttivita= SFAConvenzionamento.getCase(caseId);
            caseAttivita.Status=CaseUtils.GESTITO;
            caseAttivita=CaseUtils.aggiornaDispositionCase(caseAttivita,XCS_DispositionUtils.ACCOLLO_APPROVATO_MD,false);
            caseAttivita.Utente_Lavorazione__c='';   //il case non è più in lavorazione da nessuno
            update caseAttivita;
            System.debug('RimozzioneCaseID:  ** '+CaseId);
            CancellazioneRimossi(CaseId);
            
    
            if(!String.isEmpty(note)){
                XCSNoteUtils.postANote(caseId,'MD',note);
            }
        }
        return Procedi;
        
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
        delete DossDocRemove;
        delete AccTypeRemove;
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
            XCSNoteUtils.postANote(caseId,'MD',note);
        }
        else{
            XCSNoteUtils.postANote(caseId,'MD','ANNULLATO - MD');
        }
	}

	@AuraEnabled
    public static void richiediMaggioriInformazioni(String caseId, String note)  //OK
    {   
		Case caseAttivita= SFAConvenzionamento.getCase(caseId);
		caseAttivita.Status=CaseUtils.SOSPESO;
		caseAttivita=CaseUtils.aggiornaDispositionCase(caseAttivita,XCS_DispositionUtils.ACCOLLO_INCOMPLETO_MD,false);
		caseAttivita=SFAConvenzionamento.utenteLavorazione(caseAttivita,caseAttivita.OCSExternalFilialeConvenzionato__c,false);
		caseAttivita.StepAttivitaConvenzionamento__c=SFAConvenzionamento.GAD_DocumentiObbligatori;
		update caseAttivita;
        
        if(!String.isEmpty(note)){
            XCSNoteUtils.postANote(caseId,'MD',note);
        }
		
	}

	@AuraEnabled
    public static void sospendi(String caseId, String note)  //OK  //cambia solo la disposition e lo stato, per il resto non cambia nulla e il case rimane in carico a MD
    {   
		Case caseAttivita= SFAConvenzionamento.getCase(caseId);
		caseAttivita.Status=CaseUtils.SOSPESO;
		caseAttivita=CaseUtils.aggiornaDispositionCase(caseAttivita,XCS_DispositionUtils.ACCOLLO_SOSPESO_MD,false);
		
		update caseAttivita;

        if(!String.isEmpty(note)){
            XCSNoteUtils.postANote(caseId,'MD',note);
        }
	}

	@AuraEnabled
    public static void respingi(String caseId, String note)  //OK
    {   
		Case caseAttivita= SFAConvenzionamento.getCase(caseId);
		caseAttivita.Status=CaseUtils.GESTITO;
		caseAttivita=CaseUtils.aggiornaDispositionCase(caseAttivita,XCS_DispositionUtils.ACCOLLO_RESPINTO_MD,false);
		caseAttivita.Utente_Lavorazione__c='';   //il case non è più in lavorazione da nessuno
		update caseAttivita;

        CancellazioneRimossi(CaseId);
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
        public Id MasterDealerId {get; set;} 
        @AuraEnabled
        public String tipoIntermediario {get; set;} 
        @AuraEnabled
        public Boolean VisualizzaGDO {get; set;} 
       	@AuraEnabled
        public List<Accolli_Addendum_GDO__mdt> ListGDO {get; set;}     
      
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
         @AuraEnabled
        public Boolean showButtonAnnulla {get; set;}  
        
    }

    
}