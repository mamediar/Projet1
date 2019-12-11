@isTest
public class COM_ScheduleBatchSFDCIntervFiliali_Test {
    
      @testSetup
    public static void setup(){
        Account testComFiliale= new Account(Name='test account', 
                                            OCS_External_Id__c='ocs test',
                                            COM_NumeroTotali_Pratiche__c='2',
                                            COM_PraticheChiuse_Conforme__c='test practicheChiuse',
                                            COM_ChiusoNon_Conforme__c='test com chiusoNon');
        insert testComFiliale;
        COM_Intervista__c testObject=new COM_Intervista__c(COM_MD_Filiale__c=testComFiliale.Id,
                                                           COM_Stato_Avanzamento_Intervista__c='Nuovo',
                                                           COM_Intervista_Non_Utile__c=false,
                                                           COM_Status__c = 'Processing',
                                                           COM_Status_ASS__c = 'Processing',
                                                           COM_Current_Period_Filiale__c=true);
        insert testObject;
        System.debug('testObject avant: '+testObject.COM_Intervista_Non_Utile__c); 
		testObject.COM_Intervista_Non_Utile__c=true;
        update testObject;
        
        System.debug('testObject apres: '+testObject.COM_Intervista_Non_Utile__c);
    }
    
    
     public static testmethod void test1()
     {
          
        COM_Intervista__c testObject=[SELECT ID,LastModifiedDate,COM_Stato_Avanzamento_Intervista__c,
                                             COM_Status__c,COM_Status_ASS__c
                                      FROM COM_Intervista__c Limit 1];
     
     
        String CRON_EXP =  '0 6 13 5 OCT ? 2019';
        String jobId = System.schedule('COM_ScheduleBatchSFDCIntervisteFiliali', CRON_EXP, new COM_ScheduleBatchSFDCIntervisteFiliali());
  
     }

}