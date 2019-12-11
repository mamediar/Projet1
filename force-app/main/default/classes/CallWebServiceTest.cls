//----------------------------------------------------------------------
//-- - Author       : SANA BADJI
//-- - Date         : 30/07/2019
//-- - Description  : Handle RichOnlinePrescoringServiceTest
//----------------------------------------------------------------------
@isTest
public  class CallWebServiceTest {
    

@TestSetup
static void makeData(){
        String response = '{"resultCode": 0,"resultMessage": "Ok","recuperaStatiAttributiPrtResponse": {  "elencoPratiche": [{"tipoPratica": "CA","numPratica": "33190097388","statoPratica": "05","attrbutoPratica": "BT","canale": "MAE"}]}}';
        ApiRest__c apiRest = new ApiRest__c(Method__c = 'POST' ,
                                            Test_Response__c= response ,
                                            Test_Request__c = 'testRequest',
                                            Mock__c = false, 
                                            User__c = 'CDSLF00',
                                            Password__c = 'P00FLSDC' ,
                                            Name ='recuperaStatiAttributiPrt',
                                            EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
        insert apiRest;  
        System.debug(apiRest);
    Case  v1 = new Case (Stato_Pratica__c='20',NumeroPratica__c='18866725',
    Attributi_Pratica__c ='SD',stato_ocs__c='20SD',RO_Vecchio_Cellulare__c='773528750',
    Subject='This is a test case for testCaseForForum');
    insert v1;   
}
@isTest 
static void recuperaRequestPreSicTest(){
String jsonString = '{"serviceId" : "recuperaStatiAttributiPrt","companyType" : { "value" : "COMPASS"},"recuperaStatiAttributiPrtRequest" : {"elencoPratiche" : [ {"tipoPratica" : "CA","numPratica" : "33190097388","statoPratica" : "05","attributoPratica" : "BT","canale" : null} ]}}';
ApiRest__c apiObj = ApiRest__c.getValues('recuperaStatiAttributiPrt');
System.debug(' ************** apiObj recuperaStatiAttributiPrt ' +apiObj);
RecuperaStatiAttributiPrtRequest rest = (RecuperaStatiAttributiPrtRequest) JSON.deserializeStrict(jsonString, RecuperaStatiAttributiPrtRequest.class);
System.debug(' ************** rest  ' +rest);
Test.startTest();
Set<Id> caseId = new Set<Id>();
Case v2 = [SELECT Id FROM Case ];
caseId.add(v2.Id);
UtilityMockResponse umr = new UtilityMockResponse();
umr.apiname ='recuperaStatiAttributiPrt';
Test.setMock(HttpCalloutMock.class, umr);
CallWebService.recuperaRequestPreSic(caseId);
System.assert(v2 != null,'');                                                                                                         
Test.stopTest();
}

}