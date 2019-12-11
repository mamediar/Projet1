@isTest
public class OCSRecuperaDatiPostvenditaControllerTest {
    
    public class ClassInterfaceTest implements OCSRecuperaDatiPVFiltroPraticheInterface{
        public List<OCSPratica> filtraPratiche (List<OCSPratica> praticheTest) {
            return new List<OCSPratica>();
        }
    }
    
    @isTest
    public static void testMethods() {
        
        String response = '{"resultCode":0,"resultMessage":"Ok","pratiche":[{"numPratica":"800000329783","codCliente":"9529124"}],"cliente":[{"codCliente":"9529151"}, {"cognome":"PIPPO","codCliente":"18129","nome":"LEIO", "dataNascita": "19801010" , "dataScadenza" : "25/08/1980"}]}';
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaDatiPostvendita',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
        insert test1;
        
        test.startTest();
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname='ocs.recuperaDatiPostvendita';
        Test.setMock(HttpCalloutMock.class,UMR);
        OCSRecuperaDatiPostvenditaController.getClienti(new Map<String,String>(),'');
        test.stopTest();
        
    }
    
    
    @isTest
    public static void testGetClienti() {
        String response2 = '{"resultCode":0,"resultMessage":"Ok","pratiche":[{"numPratica":"800000329783","codCliente":"9529124"}],"cliente":[{"codCliente":"9529151","Nome" : "Mario", "Cognome":"Rossi"}]}';
        ApiRest__c test2 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response2 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaDatiPostvendita',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
        insert test2;
        
        test.startTest();
        UtilityMockResponse UMR2 = new UtilityMockResponse();
        UMR2.apiname='ocs.recuperaDatiPostvendita';
        Test.setMock(HttpCalloutMock.class,UMR2);  
        Map<String,List<Object>> mapTest = OCSRecuperaDatiPostvenditaController.getClienti(new Map<String,String>(),'');
        test.stopTest();
    }
    
    
    @isTest
    public static void testFiltraPratiche() {
        
        String response = '[{"numPratica":"800000329783","codCliente":"9529124"}]';
        OCSRecuperaDatiPostvenditaController.filtraPratiche(response, 'OCSRecuperaDatiPostvenditaControllerTest.ClassInterfaceTest');
    }
    
    @isTest
    public static void testGetInputAccountOCSId() {
        
        Account acc = new Account();
        acc.Name='AccName';
        Insert acc;
        OCSRecuperaDatiPostVenditaController.getInputAccountOCSId(acc.Id);
        
    }
    
    @isTest
    public static void testGetClienteOCS(){
        OCSCliente ocli = new OCSCliente();
        OCSRecuperaDatiPostVenditaController.getClienteOCS(ocli);
    }
    
}