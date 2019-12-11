public class SFAConvenz2DossierAccolloSedeCtrller {

     @AuraEnabled
     public static String CreaCaseNote(String Tipo, String OCScode, String Note, string CaseId){
    //	System.debug('Check Apex1!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
        
        string Subject = '';
         
        List<Group> CodaDaSede=  GroupUtils.getQueueList('Q100');
        string IdCoda = CodaDaSede[0].id;
        
     //   system.debug('substring: '+OCScode.substring(0,1));
        if(OCScode.substring(0,1) != 'D')
            	OCScode = 'D'+OCScode;
         
		list<Account> Acc = [select  id, ParentId, Name from account where OCS_External_Id__c =:OCScode];
            
        if(Acc.size() > 0){
            string AccId = Acc[0].Id;
                            
            if(CaseId == '' || CaseId == 'undefined' || CaseId == null)
            {
            	String utenteId = UserInfo.getUserId();
				//String filialeQueue = [SELECT Id, DefaultQueueId__c FROM User WHERE Id = :utenteId][0].DefaultQueueId__c;            
		    	System.debug('Check Apex2- caseId : ' + CaseId);	
            	Case nuovoCaseAccollo = CaseUtils.getCase(RecordTypeUtil.SFA_CONVENZIONAMENTO,XCS_CategoriaUtil.SFA_CONVENZIONAMENTO_GESTIONE_DOSSIER_ACCOLLO_FITT);
            
            	if(Tipo =='Accollo'){
          	    	nuovoCaseAccollo = XCS_DispositionUtils.aggiungiDispositionCase(nuovoCaseAccollo, XCS_DispositionUtils.NUOVO_ACCOLLO);
      				nuovoCaseAccollo.StepAttivitaConvenzionamento__c=SFAConvenzionamento.GAD_StampaCover; 
     				nuovoCaseAccollo.Subject=CaseUtils.SFA_SUBJECT_GESTIONE_ACCOLLO_FIT;
           		}
            	else{
                	nuovoCaseAccollo = XCS_DispositionUtils.aggiungiDispositionCase(nuovoCaseAccollo, XCS_DispositionUtils.NUOVO_DOSSIER);
      				nuovoCaseAccollo.StepAttivitaConvenzionamento__c=SFAConvenzionamento.GDD_StampaCover; 
     				nuovoCaseAccollo.Subject=CaseUtils.SFA_SUBJECT_GESTIONE_DOSSIER_FIT;
            	}
            
            	nuovoCaseAccollo.AccountId = AccId;	 
      			nuovoCaseAccollo.DataCreazioneDossier__c=datetime.now();
                nuovoCaseAccollo.OwnerId=IdCoda;
            	//nuovoCaseAccollo.OCSExternalFilialeConvenzionato__c = 'Q100';
     			insert nuovoCaseAccollo;
            	caseId = nuovoCaseAccollo.id;
            
         		XCSNoteUtils.postANote(caseId,'MD',Note);
            }
            else{
              
                XCSNoteUtils.postANote(CaseId,'MD',Note);
            }   
        }   
        else{
        	//Dealer non trovato
        	System.debug('Check Apex3');
        	caseId ='Dealer Non trovato';
        }
   		System.debug('Check Apex4 - caseId : ' + CaseId);	
        return CaseId;
    }
    
     @AuraEnabled
    public static String CreaCover(string Tipo, string OCScode, string CaseId)
    {
        system.debug('Coveeeerrrr');
        
        String res=''; 
        if(Tipo=='Accollo')
        	res='/apex/SFAConvenzGestioneAccolloGeneraCover?AccId='+OCScode+'&Tipo='+Tipo+'&CaseId='+CaseId;
     	else
        {
            res='/apex/SFAConvenzGestioneDossierGeneraCover?AccId='+OCScode+'&Tipo='+Tipo+'&CaseId='+CaseId;
        }
        System.debug('Risulato Cover : '+res);
        return res;
    }   
   
    
    
  /*  public class InitData {
    @AuraEnabled
    public Integer errorCode {get; set;}
     @AuraEnabled
    public String errorDesc {get; set;}
    @AuraEnabled
    public String nuovoCaseId {get; set;}
    @AuraEnabled
    public Dossier__c dossier {get; set;}
    @AuraEnabled
    public String tipoChecklist {get; set;}
    @AuraEnabled
    public String dealerId {get; set;}


    @AuraEnabled
    public List<Accolli_Type_List__c>  Tipologie {get; set;}  
    @AuraEnabled
    public List<Id>  Selezione {get; set;}  
  }*/
}