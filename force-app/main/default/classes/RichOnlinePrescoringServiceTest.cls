//----------------------------------------------------------------------
//-- - Author       : SANA BADJI
//-- - Date         : 30/07/2019
//-- - Description  : Handle RichOnlinePrescoringServiceTest
//----------------------------------------------------------------------
@isTest
public  class RichOnlinePrescoringServiceTest {
  public static  Case v1;  
@TestSetup
static void makeData(){
     v1 = new Case (Stato_Pratica__c='20',NumeroPratica__c='18866725',
    Attributi_Pratica__c ='SD',stato_ocs__c='20SD',RO_Vecchio_Cellulare__c='773528750',
    Subject='This is a test case for testCaseForForum');
    insert v1;    
    System.debug(' case  '+ v1 );
    List<RO_CRMRich_online_prescoring__c> richOnlineStepLog = new List<RO_CRMRich_online_prescoring__c>{
    new RO_CRMRich_online_prescoring__c (Pricing__c='100',RO_CRMRichiesta_Online__c=v1.Id)
};
insert richOnlineStepLog;



}


@IsTest
static void createCrmOnlinePrescoringTest(){
   /* Case v2 = new Case (Stato_Pratica__c='20',NumeroPratica__c='18866725',
    Attributi_Pratica__c ='SD',stato_ocs__c='20SD',RO_Vecchio_Cellulare__c='773528750',
    Subject='This is a test case for testCaseForForum');
    insert v2;    */
      RO_CRMRich_online_prescoring__c rop = new RO_CRMRich_online_prescoring__c();
    rop.Pricing__c = '2';
    rop.Channel__c = 'Richiesta di Finanziamento DS';
    rop.RO_Input_motore__c = 'imputmotore';
    rop.RO_output_motore__c = 'motoreC';
    RequestOnlineApexClass.data.put('rop', rop); 
    
    Case v2 = [SELECT Id FROM Case LIMIT 1];
    Test.startTest();
    RO_CRMRich_online_prescoring__c crm= RichOnlinePrescoringService.createCrmOnlinePrescoring(v2);
    System.assert(crm != null,'');  
    Test.stopTest();
}
@IsTest
static void createCrmOnlinePrescoringTestException(){
   /* Case v2 = new Case (Stato_Pratica__c='20',NumeroPratica__c='18866725',
    Attributi_Pratica__c ='SD',stato_ocs__c='20SD',RO_Vecchio_Cellulare__c='773528750',
    Subject='This is a test case for testCaseForForum');
    insert v2;    */
      RO_CRMRich_online_prescoring__c rop = new RO_CRMRich_online_prescoring__c();
    rop.Pricing__c = '2';
    rop.Channel__c = 'Richiesta';
    rop.RO_Input_motore__c = 'imputmotore';
    rop.RO_output_motore__c = 'motoreC';
    RequestOnlineApexClass.data.put('rop', rop); 
    
    Case v2 = [SELECT Id FROM Case LIMIT 1];
    Test.startTest();
    RO_CRMRich_online_prescoring__c crm= RichOnlinePrescoringService.createCrmOnlinePrescoring(v2);
    //System.assert(crm == null,'');  
    Test.stopTest();
}

}