@isTest
public class OCSClienteTest {
    
    @isTest
    public static void testOCSClienteClass() {
        
        OCSCliente ocscli = new OCSCliente();
        ocscli.cap='';
        ocscli.codCliente='';
        ocscli.codFiscale='';
        ocscli.cognome='';
        ocscli.dataDepennamento='';
        ocscli.dataNascita='';
        ocscli.dataRilascio='';
        ocscli.dataScadenza='';
        ocscli.denominazioneAzienda='';
        ocscli.denominazione='';
        ocscli.email='';
        ocscli.formaGiuridica='';
        ocscli.indirizzo='';
        ocscli.localita='';
        ocscli.luogoNascita='';
        ocscli.luogoRilascio='';
        ocscli.ndg='';
        ocscli.nome='';
        ocscli.numDocumento='';
        ocscli.paeseEstero='';
        ocscli.piva='';
        ocscli.pratiche= new List<OCSPratica>();
        ocscli.provincia='';
        ocscli.provNascita='';
        ocscli.provRilascio='';
        ocscli.ragioneSociale='';
        ocscli.sesso='';
        ocscli.SFId='';
        ocscli.telefonoCasa='';
        ocscli.telCellulare='';
        ocscli.tipoAnagrafica='';
        ocscli.tipoDocumento='';
        ocscli.tipoRapporto='';
        ocscli.ufficioRilascio='';
    }
    
    @isTest
    public static void testGetCA(){
        OCSCliente o = new OCSCliente();
        
        List<OCSPratica> listPrat = new List<OCSPratica>();
        OCSPratica prat = new OCSPratica();
        prat.tipoPratica = 'CA';
        listPrat.add(prat);
        o.pratiche = listprat;
        
        System.assert(o.getCA().size() == 1);        
    }
    
    @isTest
    public static void testGetCO(){
        OCSCliente o = new OCSCliente();
        
        List<OCSPratica> listPrat = new List<OCSPratica>();
        OCSPratica prat = new OCSPratica();
        prat.tipoPratica = 'CO';
        listPrat.add(prat);
        o.pratiche = listprat;
        
        System.assert(o.getCO().size() == 1);        
    }
    
    @isTest
    public static void testGetCQ(){
        OCSCliente o = new OCSCliente();
        
        List<OCSPratica> listPrat = new List<OCSPratica>();
        OCSPratica prat = new OCSPratica();
        prat.tipoPratica = 'CQ';
        listPrat.add(prat);
        o.pratiche = listprat;
        
        System.assert(o.getCQ().size() == 1);        
    }
    
    @isTest
    public static void testGetAssicurazioni(){
        OCSCliente o = new OCSCliente();
        
        List<OCSPratica> listPrat = new List<OCSPratica>();
        OCSPratica prat = new OCSPratica();
        prat.dataCaricamento = '344434';
        prat.societa = 'soc';
        listPrat.add(prat);
        o.pratiche = listprat;
        
        System.assert(o.getAssicurazioni().size() == 1);        
    }
    
    @isTest
    public static void testGetIbanPerPagamento(){
        OCSCliente o = new OCSCliente();
        
        List<OCSPratica> listPrat = new List<OCSPratica>();
        OCSPratica prat = new OCSPratica();
        prat.tipoPagamento = 'RI';
        prat.tipoPratica = 'CO';
        prat.statoPratica = '40';
        prat.dataCaricamento = '344434';
        prat.societa = 'soc';
        
        OCSPratica pratTwo = new OCSPratica();
        pratTwo.tipoPratica='CA';
        pratTwo.statoPratica='50';
        pratTwo.tipoPagamento='RI';
        
        listPrat.add(prat);
        listPrat.add(pratTwo);
        o.pratiche = listprat;
        
        o.getIbanPerPagamentoList();
        
    }
    
    @isTest
    public static void getCALogic(){
        OCSCliente o = new OCSCliente();
        
        List<OCSPratica> listPrat = new List<OCSPratica>();
        OCSPratica prat = new OCSPratica();
        prat.tipoPagamento = 'RI';
        prat.tipoPratica = 'CO';
        prat.statoPratica = '50';
        prat.dataCaricamento = '344434';
        prat.societa = 'soc';
        listPrat.add(prat);
        o.pratiche = listPrat;
        
        System.assert(o.getAssicurazioni().size() == 1);        
    }
    
    @isTest
    public static void testGetAssicurazioniToday() {
        
        OCSCliente c = new OCSCliente();
        List<OCSPratica> listPrat = new List<OCSPratica>();
        OCSPratica prat = new OCSPratica();
        prat.dataCaricamento = System.today().format();
        prat.societa='Compass';
        
        listPrat.add(prat);
        c.pratiche = listPrat;
        
        c.getAssicurazioniToday();
        
        
    }
    
    @isTest
    public static void testGetCALogic() {
        
        String response = '{"resultCode":0,"resultMessage":"Ok","datiCartaDatiFinanziariResponse":{"numeroPratica":"818","modCalcoloRata":"T","dataValidita":"20130426","pan":"4","fidoTotale":"35","dispTotale":"35","as400Status":"OK","as400Errore":"","flagAttivazioneCarta" : ""}}';
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.cartaDatiFinanziari',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
        XCS_CompassParameters__c x = new XCS_CompassParameters__c();
        x.Name='venditaAssicurazioni.emettitoreList';
        x.Value__c='Value__c';
        insert x;
        insert test1;
        /*---------------------------------------------------------------------TEST--------------------------------------------------------------------------*/
        test.startTest();
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname='ocs.cartaDatiFinanziari';
        Test.setMock(HttpCalloutMock.class,UMR);
        OCSCliente o = new OCSCliente();
        List<OCSPratica> listPrat = new List<OCSPratica>();
        OCSPratica prat = new OCSPratica();
        prat.tipoPratica = 'CA';
        prat.statoPratica='50';
        listPrat.add(prat);
        o.pratiche = listprat;
        o.getCALogic();
        test.stopTest();	
        
    }
}