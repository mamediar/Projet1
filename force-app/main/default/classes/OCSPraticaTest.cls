@isTest
public class OCSPraticaTest {
    @isTest static void testPratica() {
        
        OCSPratica pratica = new OCSPratica();
        
        pratica.numPratica = 'test';
        pratica.codCliente = 'test';
        pratica.abi = 'test';
        pratica.cab = 'test';
        pratica.numConto = 'test';
        pratica.iban = 'test';
        pratica.statoPratica = 'test';
        pratica.tipoPagamento = 'test';
        pratica.prodotto = 'test';
        pratica.filiale = 'test';
        pratica.dataEstinzione = 'test';
        pratica.tipoPratica = 'test';
        pratica.dataCaricamento = '10/11/2015';
        pratica.pan = 'test';
        pratica.convenzionato = 'test';
        pratica.puntoVendita = 'test';
        pratica.venditore = 'test';
        pratica.agente = 'test';
        pratica.subAgente = 'test';
        pratica.flagRecupero = 'test';
        pratica.classifRecupero = 'test';
        pratica.societa = 'test';
        pratica.codStatoPratica = 'test';
        pratica.codAttributoPratica = 'test';
        pratica.desStatoPratica = 'test';
        pratica.desAttributoPratica = 'test';
        pratica.codRecuperatore = 'test';
        pratica.desRecuperatore = 'test';
        pratica.canale = 'test';
        pratica.cedCom='test';
        OCSCliente cli = new OCSCliente();
        List<OCSCliente> obList = new List<OCSCliente>();
        obList.add(cli);
        pratica.elencoCoobbligati = obList;
        
        System.assertEquals(pratica.numPratica, 'test');
        System.assertEquals(pratica.codCliente, 'test');
        System.assertEquals(pratica.abi, 'test');
        System.assertEquals(pratica.cab, 'test');
        System.assertEquals(pratica.numConto, 'test');
        System.assertEquals(pratica.iban, 'test');
        System.assertEquals(pratica.statoPratica, 'test');
        System.assertEquals(pratica.tipoPagamento, 'test');
        System.assertEquals(pratica.prodotto, 'test');
        System.assertEquals(pratica.filiale, 'test');
        System.assertEquals(pratica.dataEstinzione, 'test');
        System.assertEquals(pratica.tipoPratica, 'test');
        System.assertEquals(pratica.dataCaricamento, '10/11/2015');
        System.assertEquals(pratica.pan, 'test');
        System.assertEquals(pratica.convenzionato, 'test');
        System.assertEquals(pratica.puntoVendita, 'test');
        System.assertEquals(pratica.venditore, 'test');
        System.assertEquals(pratica.agente, 'test');
        System.assertEquals(pratica.subAgente, 'test');
        System.assertEquals(pratica.flagRecupero, 'test');
        System.assertEquals(pratica.classifRecupero, 'test');
        System.assertEquals(pratica.societa, 'test');
        System.assertEquals(pratica.codStatoPratica, 'test');
        System.assertEquals(pratica.codAttributoPratica, 'test');
        System.assertEquals(pratica.desStatoPratica, 'test');
        System.assertEquals(pratica.desAttributoPratica, 'test');
        System.assertEquals(pratica.codRecuperatore, 'test');
        System.assertEquals(pratica.desRecuperatore, 'test');
        System.assertEquals(pratica.canale, 'test');
    }
}