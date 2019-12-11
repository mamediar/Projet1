@isTest
public class OCSRecuperaPacchettiServiziInvokerTest {
    
    @isTest 
    public static void test() {
                
        String responseInfoPratica ='{"resultCode":0,"resultMessage":"Ok","recuperaPacchettiServiziResponse":{"elencoPacchettiServizi":[{"codServizio":"1245"}]}'; 
        ApiRest__c test2 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c=responseInfoPratica ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaPacchettiServizi',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
        insert test2;     
        
        OCSRecuperaPacchettiServiziRequest re = new  OCSRecuperaPacchettiServiziRequest();
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname='ocs.recuperaPacchettiServizi';
        Test.setMock(HttpCalloutMock.class,UMR);
        
        //OCSRecuperaPacchettiServiziInvoker.callRecPacchServ(re);
        OCSRecuperaPacchettiServiziInvoker.callRecPacchServ('','800000329783');
        
        
    }
    
    
}