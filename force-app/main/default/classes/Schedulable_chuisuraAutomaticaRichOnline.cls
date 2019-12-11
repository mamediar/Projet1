global  class Schedulable_chuisuraAutomaticaRichOnline implements Schedulable {
    public String query;
    public Datetime dt;
    public  Datetime currentDateTime;
    
    // Compass_query__c  compassQuery;
     global static Boolean testjob = false;
     
    public Schedulable_chuisuraAutomaticaRichOnline() {
    /**    compassQuery =  Compass_query__c.getValues('Case_with_empty_numberPratica');
        d = system.today().addDays(-7);
        query ='SELECT Id, CreatedDate,Status, Product__r.Name, Product__r.Family, NumeroPratica__c FROM Case WHERE NumeroPratica__c= null AND  CreatedDate <= :d AND  ( Product__r.Family=\'PP_ONLINE_COMPASS_DS\' OR Product__r.Family=\'PP_ONLINE_PARTNER_DS\'' ;*/
    } 
    
    global void execute(SchedulableContext ctx ){
          currentDateTime = getCurrentDateTime();
          Datetime d = datetime.now().addhours(-1);
          System.debug(' ************  time '+currentDateTime.hour());

       if(currentDateTime.hour() == 22 ){
           System.debug('************* after 22');
          Id idjob =  Database.executeBatch(new ChuisuraAutomaticaRichOnline_Batch() ); 
        } 
        dt = datetime.now().addhours(-1);
        System.debug(' ************** dt '+dt);
        Id idjob =  Database.executeBatch(new ChuisuraAutomaticaRichOnline_Batch(dt) );
    }
    public static Datetime getCurrentDateTime(){
        if(Test.isRunningTest()){
            return Datetime.newInstance(2019, 07, 27, 22, 25, 12);
        }
        else {
            return Datetime.now();
        }
        
    }
}