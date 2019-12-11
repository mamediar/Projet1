@isTest
public class OCSObjectsFactoryTest {
    @testSetup 
    public static void setup() {
        Map<String,String> resTest = new Map<String,String>();
        
        resTest.put('abi','p1');
        resTest.put('agente','p2');
        resTest.put('cab','p3');
        resTest.put('canale','p4');
        resTest.put('classifRecupero', 'p5');
        resTest.put('codAttributoPratica','p6');
        resTest.put('codCliente','p7');
        resTest.put('codRecuperatore','p8');
        resTest.put('codStatoPratica','p9');
        resTest.put('convenzionato','p10');
        resTest.put('dataCaricamento','dd/MM/yyyy');
        resTest.put('dataEstinzione','p12');
        resTest.put('desAttributoPratica','p13'); 
        resTest.put('desRecuperatore','p14');
        resTest.put('desStatoPratica','p15');
        resTest.put('filiale','p16');
        resTest.put('flagRecupero','p17');
        resTest.put('iban','p18');
        resTest.put('numConto','p19');
        resTest.put('numPratica','p20');
        resTest.put('pan','p21');
        resTest.put('prodotto','p22');
        resTest.put('puntoVendita','p23');
        resTest.put('societa','p24');
        resTest.put('statoPratica','p25');
        resTest.put('subAgente','p26');
        resTest.put('tipoPagamento','p27');
        resTest.put('tipoPratica','p28');
        resTest.put('venditore','p29');
        
        OCSPratica obj = OCSObjectsFactory.makePratica(resTest);
        
    }
    @isTest
    public static void testMakePratiche() {
        
        List<OCSRecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO> dataTest = new List<OCSRecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO>();
        OCSRecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO varPra = new  OCSRecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO();
        varPra.abi='p1';
        dataTest.add(varPra);
        System.assert(OCSObjectsFactory.makePratiche(dataTest) != null);
        
        List<OCSRecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO> dataTestNull = null;
        System.assert(OCSObjectsFactory.makePratiche(dataTestNull) != null);
        
        List<OCSRecuperaDatiFuturoResponse.DatiPraticaFuturoDTO> praFutNull = null;
        System.assert(OCSObjectsFactory.makePratiche(praFutNull) != null);
        
    }
    
    @isTest
    public static void testMakeClienteWithAccount() {
        
        Account acc = new Account();
        OCSCliente obj = OCSObjectsFactory.makeCliente(acc);
        
    }
    
    @isTest
    public static void testMakeClienteFuturoMBCS() {
        
        Account_Futuro_MBCS__c accFut = new Account_Futuro_MBCS__c();
        OCSCliente obj = OCSObjectsFactory.makeClienteFuturoMBCS(accFut);
    }
    
    
    @isTest
    public static void testMakeCliente() {
        
        Map<String,String> resTest = new Map<String,String>();
        
        resTest.put('cognome','p1');
        resTest.put('codCliente','p2');
        resTest.put('nome','p3');
        resTest.put('dataNascita','p4');
        resTest.put('luogoNascita', 'p5');
        resTest.put('provNascita','p6');
        resTest.put('sesso','p7');
        resTest.put('codFiscale','p8');
        resTest.put('piva','p9');
        resTest.put('indirizzo','p10');
        resTest.put('cap','p11');
        resTest.put('localita','p12');
        resTest.put('provincia','p13'); 
        resTest.put('paeseEstero','p14');
        resTest.put('email','p15');
        resTest.put('tipoDocumento','p16');
        resTest.put('numDocumento','p17');
        resTest.put('ufficioRilascio','p18');
        resTest.put('luogoRilascio','p19');
        resTest.put('provRilascio','p20');
        resTest.put('dataRilascio','p21');
        resTest.put('denominazioneAzienda','p22');
        resTest.put('formaGiuridica','p23');
        resTest.put('tipoAnagrafica','p24');
        resTest.put('dataScadenza','p25');
        resTest.put('telefonoCasa','p26');
        resTest.put('telCellulare','p27');
        resTest.put('tipoRapporto','p28');
        resTest.put('dataDepennamento','p29');
        resTest.put('ndg','30');
        
        OCSCliente obj = OCSObjectsFactory.makeCliente(resTest);
        
    }
    
    @isTest
    public static void testMakeClienti() {
        
        OCSRecuperaDatiPostvenditaResponse varCli = new OCSRecuperaDatiPostvenditaResponse();
        OCSRecuperaDatiPostvenditaResponse.PSVDatiClienteDTO cliObject = new  OCSRecuperaDatiPostvenditaResponse.PSVDatiClienteDTO();
        OCSRecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO praObject = new OCSRecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO();
        
        cliObject.cognome = 'Rossi';
        cliObject.codCliente = '123';
        praObject.codCliente = '123';
        varCli.cliente.add(cliObject);
        varCli.pratiche.add(praObject);
        
        System.assert(OCSObjectsFactory.makeClienti(varCli) != null);
        
        /*---------------------------------------------------------TEST NULL -------------------------------------------------------------------*/
        
        OCSRecuperaDatiPostvenditaResponse varCliNull = new OCSRecuperaDatiPostvenditaResponse();  
        OCSRecuperaDatiPostvenditaResponse.PSVDatiClienteDTO cliObjectNull = new  OCSRecuperaDatiPostvenditaResponse.PSVDatiClienteDTO();
        OCSRecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO praObjectNull = new OCSRecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO();
        
        varCliNull.pratiche = null;
        cliObjectNull.cognome = 'Verdi';
        varCliNull.cliente.add(cliObjectNull);
        
        System.assert(OCSObjectsFactory.makeClienti(varCliNull) != null);
        
        
        /*-----------------------------------------------------------METODO #2-------------------------------------------------------------------*/
        
        OCSRecuperaDatiFuturoResponse futRes = new OCSRecuperaDatiFuturoResponse();
        OCSRecuperaDatiFuturoResponse.DatiPraticaFuturoDTO futPra = new OCSRecuperaDatiFuturoResponse.DatiPraticaFuturoDTO(); 
        OCSRecuperaDatiPostVenditaResponse.PSVDatiClienteDTO resCli = new OCSRecuperaDatiPostVenditaResponse.PSVDatiClienteDTO();
        
        futPra.codCliente='123';
        resCli.codCliente='123';
        futRes.cliente = new OCSRecuperaDatiPostVenditaResponse.PSVDatiClienteDTO[]{};
        futRes.pratiche = new OCSRecuperaDatiFuturoResponse.DatiPraticaFuturoDTO[]{};
                
        futRes.cliente.add(resCli);
        futRes.pratiche.add(futPra);
        
        OCSObjectsFactory.makeClienti(futRes);
        
        /*---------------------------------------------------------METODO #2 TEST NULL--------------------------------------------------------------*/
        
        OCSRecuperaDatiFuturoResponse futResNull = new OCSRecuperaDatiFuturoResponse();
        OCSRecuperaDatiFuturoResponse.DatiPraticaFuturoDTO futPraNull = null;
        OCSRecuperaDatiPostVenditaResponse.PSVDatiClienteDTO resCliNull = new OCSRecuperaDatiPostVenditaResponse.PSVDatiClienteDTO();
        
        
        resCliNull.codCliente='123';
        futResNull.cliente = new OCSRecuperaDatiPostVenditaResponse.PSVDatiClienteDTO[]{};     
        futResNull.cliente.add(resCliNull);
        futRes.pratiche.add(futPraNull);
        
        OCSObjectsFactory.makeClienti(futResNull);
        
        
    }
    
}