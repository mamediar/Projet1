//----------------------------------------------------------------------
//-- - Author       : SANA BADJI
//-- - Date         : 31/07/2019
//-- - Description  : Handle RichOnlineSteplogServiceTest
//----------------------------------------------------------------------
@isTest
public  class RichOnlineSteplogServiceTest {
    
@TestSetup
static void makeData(){
    Case v1 = new Case (Stato_Pratica__c='20',NumeroPratica__c='18866725',
    Attributi_Pratica__c ='SD',stato_ocs__c='20SD',RO_Vecchio_Cellulare__c='773528750',
    Subject='This is a test case for testCaseForForum');
    insert v1;    
    System.debug(' case  '+ v1 );
    List<RO_CRMRich_online_steplog__c> richOnlineStepLog = new List<RO_CRMRich_online_steplog__c>{
    new RO_CRMRich_online_steplog__c (RO_CRMModalita_richiesta__c ='TELIN',RO_CRMRichiesta_Online__c=v1.Id)
    };
    insert richOnlineStepLog;
}


@IsTest
static void createCrmOnlineStepLogTest(){
    RO_CRMRich_online_steplog__c ros = new RO_CRMRich_online_steplog__c();
    ros.RO_CRMStep__c = 'RO_CRMStep__c';
    ros.RO_CRMModalita_firma__c = 'RO_CRMModalita_firma__c';
    ros.RO_CRMModalita_richiesta__c = 'RO_CRMModalita_richiesta__c';
    ros.RO_documenti__c = 'RO_documenti__c';
    RequestOnlineApexClass.data.put('ros', ros); 

    Case v2 = [SELECT Id FROM Case LIMIT 1];
    Test.startTest();
    RO_CRMRich_online_steplog__c crm= RichOnlineSteplogService.createCrmOnlineStepLog(v2);
    System.assert(crm != null,'');  
    Test.stopTest();
}

@IsTest
static void createCrmOnlineStepLogTestException(){
    RO_CRMRich_online_steplog__c ros = new RO_CRMRich_online_steplog__c();
    ros.RO_CRMStep__c = 'RO_CRMS';
    ros.RO_CRMModalita_firma__c = 'RO_CRMModalita_firma__c';
    ros.RO_CRMModalita_richiesta__c = 'RO_CRMModalita_richiesta__c';
    ros.RO_documenti__c = 'RO_documenti__c';
    RequestOnlineApexClass.data.put('ros', null);  
    Case v2 = [SELECT Id FROM Case LIMIT 1];
    Test.startTest();
    RO_CRMRich_online_steplog__c crm= RichOnlineSteplogService.createCrmOnlineStepLog(v2);
    System.assert(crm == null,'');  
    Test.stopTest();
}


@IsTest
static void seracrModalitaRichestaTrueTest(){
    List<RO_CRMRich_online_steplog__c> steplogList = [SELECT RO_CRMModalita_richiesta__c,
    RO_CRMRichiesta_Online__c FROM RO_CRMRich_online_steplog__c LIMIT 1];
    Test.startTest();
    Boolean crm= RichOnlineSteplogService.seracrModalitaRichesta(steplogList);
    System.assert(crm == true,'');  
    Test.stopTest();
}



@IsTest
static void seracrModalitaRichestaFalseTest(){
    List<RO_CRMRich_online_steplog__c> steplogList = new List<RO_CRMRich_online_steplog__c>();
    Test.startTest();
    Boolean crm= RichOnlineSteplogService.seracrModalitaRichesta(steplogList);
    System.assert(crm == false,'');  
    Test.stopTest();
}

}