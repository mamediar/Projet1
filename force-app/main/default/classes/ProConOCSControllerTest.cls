@isTest
public class ProConOCSControllerTest 
{
	@TestSetup
    public static void setup()
    {
       // Test.loadData(ApiRest__c.sobjectType,'TestMockup');
    }
    
    @isTest
    public static void invokeStatusContract()
    {
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c='{"resultCode": 0,"resultMessage":"Ok","statoPratica": "30RE"}',Test_Request__c = '{"serviceId":"recuperaStatoPratica","companyType":{"value":"COMPASS"},"numPratica":"19098265"}',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name = 'ricerca.ocs.recuperaStatoPratica',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
       	insert test1;
        test.startTest();
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname='ricerca.ocs.recuperaStatoPratica';
        Test.setMock(HttpCalloutMock.class,UMR);
        List<ProConOCSController.OcsSearchResult> ListOSR;
        String[] listNumPratica = new String[1];
        listNumPratica[0] = 'CA0019098265';
        try
        {
            ProConOCSController.ricercaStatoPratica(listNumPratica);
        }
        catch(Exception e){}
        test.stopTest();
    }
    
    @isTest
    public static void invokeStatusContractmock()
    {
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c='{"resultCode": 0,"resultMessage":"Ok","statoPratica": "30RE"}',Test_Request__c = '{"serviceId":"recuperaStatoPratica","companyType":{"value":"COMPASS"},"numPratica":"19098265"}',Mock__c = true ,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name = 'ricerca.ocs.recuperaStatoPratica',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
       	insert test1;
        test.startTest();
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname='ricerca.ocs.recuperaStatoPratica';
        Test.setMock(HttpCalloutMock.class,UMR);
        List<ProConOCSController.OcsSearchResult> ListOSR;
        String[] listNumPratica = new String[1];
        listNumPratica[0] = 'CA0019098265';
        try
        {
            ProConOCSController.ricercaStatoPratica(listNumPratica);
        }
        catch(Exception e){}
        test.stopTest();
    }
    
    
    
    
    
}