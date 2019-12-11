/**
 * @File Name          : OCSCartaDatiFinanziariInvokerTest.cls
 * @Description        : 
 * @Author             : Lorenzo Marzocchi
 * @Group              : 
 * @Last Modified By   : Lorenzo Marzocchi
 * @Last Modified On   : 2019-9-3 11:47:33
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    2019-9-3   Lorenzo Marzocchi     Initial Version
**/
@isTest
public class OCSCartaDatiFinanziariInvokerTest {
    
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
    static void cartaDatiFinanziariTest(){
        User u = [SELECT Id FROM User WHERE LastName = 'Test'];
        String response = '{"resultCode":0,"resultMessage":"Ok","datiCartaDatiFinanziariResponse":{"numeroPratica":"8180824247","filiale":"212","emettitore":"8","pagamentoMinimo":"0","pagamentoMinimoPerc":"0.00","commissioneEntrata":"0","modCalcoloRata":"T"}}';
        /*
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.cartaDatiFinanziari',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
        insert test1;
        */
         //-- - INIZIO MODIFICA

       //-- - Autor        : Giuseppe Laria

       //-- - Date         : 04/06/2019

       //-- - Description  : aggiunto Ref__c dentro test1, aggiunto ApiUtil__c test2
     
         ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,ref__c = 'CompassInternal',Name ='ocs.cartaDatiFinanziari',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
         ApiUtil__c test2 = new ApiUtil__c(Name = 'CompassInternal' ,EndPoint__c ='https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute' ,Password__c = 'P00FLSDC',User__c = 'CDSLF00');      
        insert test1;
        insert test2;
        
         //-- - FINE MODIFICA

       //--------------------------------------------------------------------
        
        
        OCSCartaDatiFinanziariResponse.DatiCartaDatiFinanziariResponseDTO datiCarta;
        Test.startTest();
		System.runAs(u) {
            UtilityMockResponse UMR = new UtilityMockResponse();
            UMR.apiname='ocs.cartaDatiFinanziari';
            Test.setMock(HttpCalloutMock.class,UMR);
            OCSCartaDatiFinanziariResponse myResponse = OCSCartaDatiFinanziariInvoker.cartaDatiFinanziari('8180824247');
            datiCarta = myResponse.datiCartaDatiFinanziariResponse; 
        }
		Test.stopTest();
        System.assertEquals('8180824247',datiCarta.numeroPratica);
        System.assertEquals('8',datiCarta.emettitore);
        System.assertEquals('212',datiCarta.filiale);
        System.assertEquals(0,datiCarta.pagamentoMinimo);
        System.assertEquals('0.00',datiCarta.pagamentoMinimoPerc);
        System.assertEquals('0',datiCarta.commissioneEntrata);
        System.assertEquals('T',datiCarta.modCalcoloRata);
        System.assertEquals(null,datiCarta.intestazione1);
        System.assertEquals(null,datiCarta.intestazione2);
        System.assertEquals(null,datiCarta.dataValidita);
        System.assertEquals(null,datiCarta.dataScadenza);
        
        System.assertEquals('',datiCarta.dataValiditaSlashed);
        System.assertEquals('',datiCarta.dataScadenzaSlashed);
        
        System.assertEquals(null,datiCarta.checkIntermediario);
		System.assertEquals(null,datiCarta.pagamento);
		System.assertEquals(null,datiCarta.bancaCliAbi);
		System.assertEquals(null,datiCarta.bancaCliCab);
		System.assertEquals(null,datiCarta.contoCorrente);
		System.assertEquals(null,datiCarta.iban);
		System.assertEquals(null,datiCarta.comRinnovo);
		System.assertEquals(null,datiCarta.comRinnovo1);
		System.assertEquals(null,datiCarta.comRinnovoDurata1);
		System.assertEquals(null,datiCarta.comRinnovo2);
		System.assertEquals(null,datiCarta.comRinnovoDurata2);
		System.assertEquals(null,datiCarta.comRinnovo3);
		System.assertEquals(null,datiCarta.comRinnovoDurata3);
		System.assertEquals(null,datiCarta.stato);
		System.assertEquals(null,datiCarta.blocco);
		System.assertEquals(null,datiCarta.tassoTan);
		System.assertEquals(null,datiCarta.tassoTaeg);
		System.assertEquals(null,datiCarta.pan);
		System.assertEquals(null,datiCarta.fidoRiserva1);
		System.assertEquals(null,datiCarta.dispRiserva1);
		System.assertEquals(null,datiCarta.fidoRiserva2);
		System.assertEquals(null,datiCarta.dispRiserva2);
		System.assertEquals(null,datiCarta.fidoRiserva3);
		System.assertEquals(null,datiCarta.dispRiserva3);
		System.assertEquals(null,datiCarta.flagAttivazioneCarta);
		System.assertEquals(null,datiCarta.codProdotto);
		System.assertEquals(null,datiCarta.desProdotto);
		System.assertEquals(null,datiCarta.flagAlertSms);
		System.assertEquals(null,datiCarta.riservaPrincipaleFido);
		System.assertEquals(null,datiCarta.riservaPrincipaleFidoSegno);
		System.assertEquals(null,datiCarta.riservaPrincipaleSaldo);
		System.assertEquals(null,datiCarta.riservaPrincipaleSaldoSegno);
		System.assertEquals(null,datiCarta.riservaPrincipaleDisp);
		System.assertEquals(null,datiCarta.riservaPrincipaleDispSegno);
		System.assertEquals(null,datiCarta.riservaPrincipaleSconfino);
		System.assertEquals(null,datiCarta.riservaPrincipaleSconfinoSegno);
		System.assertEquals(null,datiCarta.riservaPrincipaleOverlimit);
		System.assertEquals(null,datiCarta.riservaPrincipaleOverlimitSegno);
		System.assertEquals(null,datiCarta.riservaPrincipaleDispTeorMax);
		System.assertEquals(null,datiCarta.riservaPrincipaleDispTeorMaxSegno);
		System.assertEquals(null,datiCarta.riservaSalvadanaioFido);
		System.assertEquals(null,datiCarta.riservaSalvadanaioFidoSegno);
		System.assertEquals(null,datiCarta.riservaSalvadanaioSaldo);
		System.assertEquals(null,datiCarta.riservaSalvadanaioSaldoSegno);
		System.assertEquals(null,datiCarta.riservaSalvadanaioDisp);
		System.assertEquals(null,datiCarta.riservaSalvadanaioDispSegno);
		System.assertEquals(null,datiCarta.riservaSalvadanaioSconfino);
		System.assertEquals(null,datiCarta.riservaSalvadanaioSconfinoSegno);
		System.assertEquals(null,datiCarta.riservaSalvadanaioOverlimit);
		System.assertEquals(null,datiCarta.riservaSalvadanaioOverlimitSegno);
		System.assertEquals(null,datiCarta.riservaSalvadanaioDispTeorMax);
		System.assertEquals(null,datiCarta.riservaSalvadanaioDispTeorMaxSegno);
		System.assertEquals(null,datiCarta.riservaInternetFido);
		System.assertEquals(null,datiCarta.riservaInternetFidoSegno);
		System.assertEquals(null,datiCarta.riservaInternetSaldo);
		System.assertEquals(null,datiCarta.riservaInternetSaldoSegno);
		System.assertEquals(null,datiCarta.riservaInternetDisp);
		System.assertEquals(null,datiCarta.riservaInternetDispSegno);
		System.assertEquals(null,datiCarta.riservaInternetSconfino);
		System.assertEquals(null,datiCarta.riservaInternetSconfinoSegno);
		System.assertEquals(null,datiCarta.riservaInternetOverlimit);
		System.assertEquals(null,datiCarta.riservaInternetOverlimitSegno);
		System.assertEquals(null,datiCarta.riservaInternetDispTeorMax);
		System.assertEquals(null,datiCarta.riservaInternetDispTeorMaxSegno);
		System.assertEquals(null,datiCarta.riservaMulticontoFido);
		System.assertEquals(null,datiCarta.riservaMulticontoSaldo);
		System.assertEquals(null,datiCarta.riservaMulticontoSaldoSegno);
		System.assertEquals(null,datiCarta.riservaMulticontoDisp);
		System.assertEquals(null,datiCarta.riservaMulticontoDispSegno);
		System.assertEquals(null,datiCarta.riservaMulticontoSconfino);
		System.assertEquals(null,datiCarta.riservaMulticontoSconfinoSegno);
		System.assertEquals(null,datiCarta.riservaMulticontoOverlimit);
		System.assertEquals(null,datiCarta.riservaMulticontoOverlimitSegno);
		System.assertEquals(null,datiCarta.riservaMulticontoDispTeorMax);
		System.assertEquals(null,datiCarta.riservaMulticontoDispTeorMaxSegno);
		System.assertEquals(null,datiCarta.as400Status);
		System.assertEquals(null,datiCarta.as400Errore);
                
    }
    
   
    @isTest
    public static void getAs400Test(){
        
        OCSCartaDatiFinanziariResponse r = new OCSCartaDatiFinanziariResponse();
        r.datiCartaDatiFinanziariResponse.as400Status = 'OK';
        r.datiCartaDatiFinanziariResponse.as400Errore = '';
        System.assert(r.isStatusOK() && r.getAs400Status() != null && r.getAs400Errore() != null ); 
        
    }
    
    

}