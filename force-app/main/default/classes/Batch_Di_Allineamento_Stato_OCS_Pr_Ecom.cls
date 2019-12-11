/***
*@Author Madicke BALDE
*@description batch retrieve All Case  With Product type is  PF_ECOMMERCE_STANDARD and status equal to Gestato
*  and call web service RecuperaPraticheAggiornate
*/

global class Batch_Di_Allineamento_Stato_OCS_Pr_Ecom implements Database.Batchable<sObject>, Database.Stateful,Database.AllowsCallouts {
    public String query;
    public List<Case> listCases = new List<Case>();
      public Datetime createdDate_Batch;
    public Batch_Di_Allineamento_Stato_OCS_Pr_Ecom() {
        query = 'SELECT Id, Status FROM Case WHERE Product__r.Family= \'PF_ECOMMERCE_STANDARD\'  AND Status!=\'Gestito\'';
   
    }

    global Database.QueryLocator start (Database.BatchableContext BC){
        AsyncApexJob a = CGMWSUtils_1_0.getInformationAbout_Batch(BC);
        createdDate_Batch = a.CreatedDate;
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext ctx, List<Case> caseLists){
        System.debug('********** execute Batch_Di_Allineamento_Stato_OCS_Pr_Ecom '+caseLists.size());
         if(caseLists.size() > 0 ){
              System.debug(' *********** Batch_Di_Allineamento_Stato_OCS_Pr_Ecom ');
                 String  dataInizio =   CGMWSUtils_1_0.ToString(createdDate_Batch.date());
                     String oraInizio =   CGMWSUtils_1_0.ToString(createdDate_Batch.time());
                               RecuperaPraticheAggiornateResponse response = RecuperaPraticheAggiornateInvoker.build_recuperaPraticheAggiornateRequest(dataInizio, oraInizio, 'ECO');
                            //RecuperaPraticheAggiornateResponse response = Invoker.build_recuperaPraticheAggiornateRequest(dataInizio, oraInizio , 'ECO');
                              if(RecuperaPraticheAggiornateService.ValidateResponse(response)){
                                    List<RecuperaPraticheAggiornateResponse.recuperaPraticheAggiornateResp> resultats = response.recuperaPraticheAggiornateResponse.elenco;
                                    Map<String, Object> returnValues =   RecuperaPraticheAggiornateService.gestitoResponse(resultats);

                                }


         }

    }
    global void finish(Database.BatchableContext ctx){
 System.debug('*********** finish Batch_Di_Allineamento_Stato_OCS_Pr_Ecom size '+ listCases.size() );

    }

}