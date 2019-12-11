/**
* @Author:      Orlando S.
* @Description:
* 
* */
global class COM_BatchSFDCLimiteFiliali implements Database.Batchable<sObject> , Database.Stateful
{
       //Attributes
       @testvisible private String queryToDO        = '';
    
       //Constructor
       global COM_BatchSFDCLimiteFiliali()
       {
              queryToDo  = 'SELECT Id,Name,OCS_External_Id__c,CodiceClienteFilled__c,COM_NumeroTotali_Pratiche__c,'+
                                  'COM_PraticheChiuse_Conforme__c,COM_ChiusoNon_Conforme__c,COM_Numero_Pratiche_Filiale__c,'+
                                  'COM_Numero_Pratiche_Conf_Filiale__c,COM_Numero_Pratiche_NConf_Filiale__c,'+
                                  'getCodice_Cliente__c,COM_Numero_Pratiche_ConfEV_Filiale__c '+ 
                           'FROM Account '+ 
                           'WHERE COM_Numero_Pratiche_Conf_Filiale__c = 10 AND '+
                           'Id IN ( select COM_MD_Filiale__c  FROM COM_Intervista__c WHERE COM_Current_Period_Filiale__c = true )';
       }
     
       //Start Method
       global Database.QueryLocator start(Database.BatchableContext BC) 
       {
              return Database.getQueryLocator( queryToDO );
       }
    
       //Execute Method
       global void execute(Database.BatchableContext BC, List<SObject> scope ) 
       {
              try {
                     checkFilialiToElaborate( scope );     
                  }catch( Exception ErrorException )
                 {
            
                 }
       }
    
       //Finish Method
       global void finish(Database.BatchableContext BC) 
       {
              AsyncApexJob job = [ SELECT Id,
                                          ApexClass.Name,
                                          CompletedDate,
                                          JobType,
                                          NumberOfErrors,
                                          JobItemsProcessed,
                                          TotalJobItems,
                                          CreatedBy.Email,
                                          CreatedBy.Name,
                                          Createddate 
                                   FROM AsyncApexJob
                                   WHERE Id =: BC.getJobId() ];
        }
    
       /********************************Work Methods*************************************/
       @testvisible 
       private void checkFilialiToElaborate(List<SObject> listAccounts )
       {
               system.debug('COM_BatchSFDCLimiteFiliali/checkFilialiToElaborate/listaAccounts::'+listAccounts);
               List<COM_Intervista__c> ListIntervista         = new List<COM_Intervista__c>();
               List<COM_Intervista__c> ListIntervistaToUpdate = new List<COM_Intervista__c>();
               ListIntervista                                 = [ SELECT Id, COM_Status__c , COM_Stato_Avanzamento_Intervista__c
                                                                  FROM COM_Intervista__c
                                                                  WHERE ( COM_Status__c = 'New' OR COM_Status__c = 'Processing' ) 
                                                                      AND COM_MD_Filiale__c IN : listAccounts ];
               
               system.debug('COM_BatchSFDCLimiteFiliali/checkFilialiToElaborate/ListIntervista::'+ListIntervista);
               if( ListIntervista != null && ListIntervista.size() > 0 )
               {
                   for( COM_Intervista__c INTObj : ListIntervista )
                   {
                        INTObj.COM_Status__c                       = 'Archived';
                        INTObj.COM_Stato_Avanzamento_Intervista__c = 'Conclusa';
                        INTObj.COM_Current_Period_Filiale__c       = false;
                        ListIntervistaToUpdate.add( INTObj );
                   }
                   
                   update ListIntervistaToUpdate;
               }
         
           
       }


}
/*************
SELECT Id,
       Name,
       OCS_External_Id__c,
       CodiceClienteFilled__c,
       COM_NumeroTotali_Pratiche__c,
       COM_PraticheChiuse_Conforme__c,
       COM_ChiusoNon_Conforme__c,
       COM_Numero_Pratiche_Filiale__c,
       COM_Numero_Pratiche_Conf_Filiale__c,
       COM_Numero_Pratiche_NConf_Filiale__c,
       getCodice_Cliente__c,
       COM_Numero_Pratiche_ConfEV_Filiale__c 
FROM Account 
WHERE COM_Numero_Pratiche_Conf_Filiale__c = 10 AND
      Id IN ( select COM_MD_Filiale__c  FROM COM_Intervista__c WHERE COM_Current_Period_Filiale__c = true )
**************/