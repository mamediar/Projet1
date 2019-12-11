/**
  *************** @author Madicke BALDE*********************************************************
  *************** @description : This batch will close all Cases that are registered with an empty 
                                 and that their creation dates are about 7 days for DS and DSP product
                                 and one hour for ECOM Product. Then he puts them in a queue (Q524)
  *************** @date 2019/05/12
 **/
global  class ChuisuraAutomaticaRichOnline_Batch  implements Database.Batchable<sObject>, Database.Stateful{
    public String query; 
    public Datetime dt;
    public date  d;
    public List<Case> casesUpdated = new List<Case>();
   
   /**
    */
    public ChuisuraAutomaticaRichOnline_Batch() {
         d = system.today().addDays(-7);
         query ='SELECT Id, CreatedDate,Status, Product__r.Name, Product__r.Family, NumeroPratica__c FROM Case WHERE NumeroPratica__c= null  AND  ( Product__r.Family=\'PP_ONLINE_COMPASS_DS\' OR Product__r.Family=\'PP_ONLINE_PARTNER_DS\') AND  CreatedDate <=:d' ;
        System.debug(' ************ constructor in 22 h '+d);
    }

     public ChuisuraAutomaticaRichOnline_Batch(Datetime dt) {
        this.dt = dt;
        System.debug('********* DateTime Values '+dt);
        query = 'Select Id, CreatedDate, Status, Product__r.Name, Product__r.Family  From Case  Where NumeroPratica__c =null AND Product__r.Family = \'PF_ECOMMERCE_STANDARD\' AND CreatedDate <:dt';
        System.debug(' ************ constructor in  not in 22 h ');
    }

    global Database.QueryLocator start (Database.BatchableContext bc){
        System.debug('********** execute start *******');
        System.debug('vvvvvvvvvvvvvvvvvv '+query);
       return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<Case> list_Cases){
       System.debug('********** execute job ChuisuraAutomaticaRichOnline_Batch *******'+list_Cases.size() );
          if(list_Cases.size() > 0 ) {

              for(Case c : list_Cases){
                  System.debug(' createdDate '+c.CreatedDate + ' **** Family  2'+ c.Product__r.Family+ '**** Name Family'+c.Product__r.Name);
              }
          }
            List<Case> listes = CaseService.changeStatoCase(list_Cases, 'Closed');
          if(listes.size() > 0 ) casesUpdated = CaseService.addCaseToQueue(list_Cases, 'Q524');
          
       
    }
    global void finish(Database.BatchableContext bc){
        System.debug('********** finish job ChuisuraAutomaticaRichOnline_Batch *******' + casesUpdated);
       if(casesUpdated.size()  > 0) Schedulable_chuisuraAutomaticaRichOnline.testjob = true;
     

    }

}