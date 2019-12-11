global  class Batch_Di_Allineamento_Stato_OCS_Pr_DSP implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {
        public String query;
        public List<Case> listCases = new List<Case>(); 
        public Datetime createdDate_Batch;

        public Batch_Di_Allineamento_Stato_OCS_Pr_DSP() {
                query = 'SELECT Id, Status FROM Case WHERE Product__r.Family= \'PP_ONLINE_PARTNER_DS\'  AND Status!=\'Gestito\'';
        }

        global Database.QueryLocator start(Database.BatchableContext BC){
             AsyncApexJob a = CGMWSUtils_1_0.getInformationAbout_Batch(BC);

            createdDate_Batch = a.CreatedDate;
            return Database.getQueryLocator(query);
        }

        global void execute(Database.BatchableContext ctx, List<Case> caseLists){
             System.debug('********** execute atch_Di_Allineamento_Stato_OCS_Pr_DSP ');
             if(caseLists.size() > 0 ){
                System.debug(' *********** Batch_Di_Allineamento_Stato_OCS_Pr_DSP ');
                 String  dataInizio =   CGMWSUtils_1_0.ToString(createdDate_Batch.date());
                     String oraInizio =   CGMWSUtils_1_0.ToString(createdDate_Batch.time());
                              RecuperaPraticheAggiornateResponse response = RecuperaPraticheAggiornateInvoker.build_recuperaPraticheAggiornateRequest(dataInizio, oraInizio, 'PPCB');
                           // RecuperaPraticheAggiornateResponse response = Invoker.build_recuperaPraticheAggiornateRequest(dataInizio, oraInizio , 'PPCB');
                              if(RecuperaPraticheAggiornateService.ValidateResponse(response)){
                                    List<RecuperaPraticheAggiornateResponse.recuperaPraticheAggiornateResp> resultats = response.recuperaPraticheAggiornateResponse.elenco;
                                    Map<String, Object> returnValues =   RecuperaPraticheAggiornateService.gestitoResponse(resultats);

                                }



             }
        }

        global void finish (Database.BatchableContext ctx){
            System.debug('*********** finish Batch_Di_Allineamento_Stato_OCS_Pr_DSP size '+ listCases.size() );
           Id idjob = Database.executeBatch(new Batch_Di_Allineamento_Stato_OCS_Pr_Ecom() );

        }

}