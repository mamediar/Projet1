@isTest
public class OCSRecuperaSaldoClienteInvokerTest {
    
    @TestSetup
    static void setup(){   
        if(([SELECT Id FROM User WHERE Username = 'test@compass.com.test']).size()==0){
            Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
            User utenteAdmin = new User(
                FirstName= 'Test',
                LastName= 'Test',
                Username= 'test@compass.com.test',
                Email= 'test@lynxspa.com',
                Alias= 'test',
                TimeZoneSidKey= 'Europe/Rome',
                LocaleSidKey= 'it_IT',
                EmailEncodingKey= 'ISO-8859-1',
                ProfileId= p.Id,
                LanguageLocaleKey= 'en_US'
            );
            insert utenteAdmin;
        }
    }
    
    @isTest
    static void callGetSaldoClienteTest(){
        User u = [SELECT Id FROM User WHERE LastName = 'Test'];
        String response = '{"resultCode":0,"resultMessage":"Ok","recuperaSaldoClienteResponse":{"elencoPratiche":[{"numPratica":"1101300423","tipoPratica":"CA","saldo":"0","tipoProdotto":"","dataEsame":"","stato":"70","attributo":"XZ","tipoRapporto":"CL","prodotto":"13"}]}}';
        ApiRest__c testCall = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaSaldoCliente',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/recuperaSaldoCliente');      
        insert testCall;
        OCSRecuperaSaldoClienteResponse.PraticheClass datiPratica;
        Test.startTest();
		System.runAs(u) { 
            UtilityMockResponse UMR = new UtilityMockResponse();
            UMR.apiname='ocs.recuperaSaldoCliente'; 
            Test.setMock(HttpCalloutMock.class,UMR);
            OCSRecuperaSaldoClienteResponse myResponse = OCSRecuperaSaldoClienteInvoker.callGetSaldoCliente('1231236');
            datiPratica = myResponse.recuperaSaldoClienteResponse.elencoPratiche[0]; 
        }
		Test.stopTest();
        System.assertEquals('1101300423',datiPratica.numPratica);
        System.assertEquals('CA',datiPratica.tipoPratica);
        System.assertEquals('0',datiPratica.saldo);
        System.assertEquals('',datiPratica.tipoProdotto);
        System.assertEquals('',datiPratica.dataEsame);
        System.assertEquals('70',datiPratica.stato);
        System.assertEquals('XZ',datiPratica.attributo);
        System.assertEquals('CL',datiPratica.tipoRapporto);
        System.assertEquals('13',datiPratica.prodotto);
        System.assertEquals(null,datiPratica.scaduto);
        System.assertEquals(null,datiPratica.finanziato);
        System.assertEquals(null,datiPratica.dataPrimoUtilizzo);
        System.assertEquals(null,datiPratica.dataPrimaAttivazione);
        System.assertEquals(null,datiPratica.dataCompetenzaPrimoEC);
    }

}