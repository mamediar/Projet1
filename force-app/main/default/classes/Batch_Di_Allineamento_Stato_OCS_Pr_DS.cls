global class Batch_Di_Allineamento_Stato_OCS_Pr_DS implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {
                public String query;
                public List<Case> caseLists = new List<Case>();
                public Datetime createdDate_Batch;

    public Batch_Di_Allineamento_Stato_OCS_Pr_DS(String query) {
                  this.query = query;
    }

    global Database.QueryLocator start(Database.BatchableContext  BC){
                    AsyncApexJob a = CGMWSUtils_1_0.getInformationAbout_Batch(BC);

                    createdDate_Batch = a.CreatedDate;

                    return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext ct, List<Case> listCases){
                System.debug('*********** execute Batch_Di_Allineamento_Stato_OCS_Pr_DS'+ listCases.size());
               
               try {
                 if(listCases.size() > 0 ){
                     System.debug(' *********** Batch_Di_Allineamento_Stato_OCS_Pr_DS new');
                     String  dataInizio =   CGMWSUtils_1_0.ToString(createdDate_Batch.date());
                     String oraInizio =     CGMWSUtils_1_0.ToString(createdDate_Batch.time());
              
                           // RecuperaPraticheAggiornateResponse response = Invoker.build_recuperaPraticheAggiornateRequest(dataInizio, oraInizio , 'DS');
                             RecuperaPraticheAggiornateResponse response = RecuperaPraticheAggiornateInvoker.build_recuperaPraticheAggiornateRequest(dataInizio, oraInizio, 'DS');
                             System.debug(' ************* response *********** '+response);
                              if(RecuperaPraticheAggiornateService.ValidateResponse(response)){
                                  List<RecuperaPraticheAggiornateResponse.recuperaPraticheAggiornateResp> resultats = response.recuperaPraticheAggiornateResponse.elenco;
                                    System.debug(' ************** resultat ************* '+resultats);
                                    Map<String, Object> returnValues =   RecuperaPraticheAggiornateService.gestitoResponse(resultats);
                                       System.debug( (List<Case>) returnValues.get('cases') );
                                }
                }
      
               } catch (Exception e) {
                 System.debug('************ errorMessage execute  Batch_Di_Allineamento_Stato_OCS_Pr_DS'+e.getMessage());
                 System.debug('errorStract'+ e.getStackTraceString() ); 
                 
               }
               
                
    }

    global void finish(Database.BatchableContext BC){
                    System.debug(' ************  finish Batch_Di_Allineamento_Stato_OCS_Pr_DS '+caseLists.size());
                    
                   

         Id idjob = Database.executeBatch(new Batch_Di_Allineamento_Stato_OCS_Pr_DSP() );

    }
}