@isTest
public class ProVerificaLottoTest 
{
	 @isTest
    public static void test()
    {
        List<String> stringa = new List<String>();
        stringa.add('CO000000000014');
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c='{"resultCode":0,"resultMessage":"Ok","ebagetadlv1Response":{"mfbayadlo_OU_LOTTO":0}}',Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ricerca.ocs.ricercaPresenzaLotto',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
       	insert test1;
        test.startTest();
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname='ricerca.ocs.ricercaPresenzaLotto';
        Test.setMock(HttpCalloutMock.class,UMR);
        List<ProVerificaLotto.OcsSearchResult> lista = ProVerificaLotto.ricercaPresenzaLotto(stringa);
        test.stopTest();
    }
}