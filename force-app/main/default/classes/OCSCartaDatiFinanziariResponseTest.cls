/**
 * @File Name          : OCSCartaDatiFinanziariResponseTest.cls
 * @Description        : 
 * @Author             : Lorenzo Marzocchi
 * @Group              : 
 * @Last Modified By   : Lorenzo Marzocchi
 * @Last Modified On   : 2019-9-3 11:52:38
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    2019-9-3   Lorenzo Marzocchi     Initial Version
**/
@isTest
public class OCSCartaDatiFinanziariResponseTest {
    
    @isTest
    public static void test(){
        
        //  String response = '{"resultCode":0,"resultMessage":"Ok","datiCartaDatiFinanziariResponse":{"numeroPratica":"8180824247","emettitore":"8","pagamentoMinimo":"0","pagamentoMinimoPerc":"0.00","modCalcoloRata":"T","dataValidita":"20130426","dataScadenza":"201905","checkIntermediario":"12","contoCorrente":"100571605864","iban":"IT04P14","stato":"60","pan":"447","fidoTotale":"35","dispTotale":"35","fidoRiserva1":"200","flagAttivazioneCarta":"N","codProdotto":"NI","desProdotto":"CARTA DIPENDENTI FIDO 3500","as400Status":"OK","as400Errore":""}}';
        OCSCartaDatiFinanziariResponse r = new OCSCartaDatiFinanziariResponse();
        
        r.datiCartaDatiFinanziariResponse.numeroPratica = '1332';
        r.datiCartaDatiFinanziariResponse.filiale = 'Cina';
        r.datiCartaDatiFinanziariResponse.emettitore = '';
        r.datiCartaDatiFinanziariResponse.pagamentoMinimo = 0;
        r.datiCartaDatiFinanziariResponse.pagamentoMinimoPerc = '';
        r.datiCartaDatiFinanziariResponse.commissioneEntrata = '';
        r.datiCartaDatiFinanziariResponse.modCalcoloRata = '';
        r.datiCartaDatiFinanziariResponse.intestazione1 = '';
        r.datiCartaDatiFinanziariResponse.intestazione2 = '';
        r.datiCartaDatiFinanziariResponse.dataValidita = '20180522';
        r.datiCartaDatiFinanziariResponse.dataScadenza = '201802';
        r.datiCartaDatiFinanziariResponse.checkIntermediario = '';
        r.datiCartaDatiFinanziariResponse.pagamento = '';
        r.datiCartaDatiFinanziariResponse.bancaCliAbi = '';
        r.datiCartaDatiFinanziariResponse.bancaCliCab = '';
        r.datiCartaDatiFinanziariResponse.contoCorrente = '';
        r.datiCartaDatiFinanziariResponse.iban = '';
        r.datiCartaDatiFinanziariResponse.comRinnovo = '';
        r.datiCartaDatiFinanziariResponse.comRinnovo1 = '';
        r.datiCartaDatiFinanziariResponse.comRinnovoDurata1 = '';
        r.datiCartaDatiFinanziariResponse.comRinnovo2 = '';
        r.datiCartaDatiFinanziariResponse.comRinnovoDurata2 = '';
        r.datiCartaDatiFinanziariResponse.comRinnovo3 = '';
        r.datiCartaDatiFinanziariResponse.comRinnovoDurata3 = '';        
        r.datiCartaDatiFinanziariResponse.stato = '';
        r.datiCartaDatiFinanziariResponse.blocco = '';
        r.datiCartaDatiFinanziariResponse.tassoTan = '';
        r.datiCartaDatiFinanziariResponse.tassoTaeg = '';
        r.datiCartaDatiFinanziariResponse.pan = '';
        r.datiCartaDatiFinanziariResponse.fidoTotale = 0;
        r.datiCartaDatiFinanziariResponse.dispTotale = 0;       
        r.datiCartaDatiFinanziariResponse.fidoRiserva1 = '';
        r.datiCartaDatiFinanziariResponse.dispRiserva1 = '';
        r.datiCartaDatiFinanziariResponse.fidoRiserva2 = '';        
        r.datiCartaDatiFinanziariResponse.dispRiserva2 = '';
        r.datiCartaDatiFinanziariResponse.fidoRiserva3 = '';
        r.datiCartaDatiFinanziariResponse.dispRiserva3 = '';       
        r.datiCartaDatiFinanziariResponse.flagAttivazioneCarta = '';
        r.datiCartaDatiFinanziariResponse.codProdotto = '';
        r.datiCartaDatiFinanziariResponse.desProdotto = '';        
        r.datiCartaDatiFinanziariResponse.flagAlertSms = '';       
        r.datiCartaDatiFinanziariResponse.riservaPrincipaleFido = 0;
        r.datiCartaDatiFinanziariResponse.riservaPrincipaleFidoSegno = '';
        r.datiCartaDatiFinanziariResponse.riservaPrincipaleSaldo = 0;        
        r.datiCartaDatiFinanziariResponse.riservaPrincipaleSaldoSegno = '';       
        r.datiCartaDatiFinanziariResponse.riservaPrincipaleDisp =0;
        r.datiCartaDatiFinanziariResponse.riservaPrincipaleDispSegno = '';
        r.datiCartaDatiFinanziariResponse.riservaPrincipaleSconfino = 0;      
        r.datiCartaDatiFinanziariResponse.riservaPrincipaleSconfinoSegno = '';       
        r.datiCartaDatiFinanziariResponse.riservaPrincipaleOverlimit = 0;
        r.datiCartaDatiFinanziariResponse.riservaPrincipaleOverlimitSegno = '';
        r.datiCartaDatiFinanziariResponse.riservaPrincipaleDispTeorMax = 0;       
        r.datiCartaDatiFinanziariResponse.riservaPrincipaleDispTeorMaxSegno = '';       
        r.datiCartaDatiFinanziariResponse.riservaSalvadanaioFido = 0;
        r.datiCartaDatiFinanziariResponse.riservaSalvadanaioFidoSegno = '';
        r.datiCartaDatiFinanziariResponse.riservaSalvadanaioSaldo = 0;        
        r.datiCartaDatiFinanziariResponse.riservaSalvadanaioSaldoSegno = '';       
        r.datiCartaDatiFinanziariResponse.riservaSalvadanaioDisp = 0;
        r.datiCartaDatiFinanziariResponse.riservaSalvadanaioDispSegno = '';
        r.datiCartaDatiFinanziariResponse.riservaSalvadanaioSconfino = 0;        
        r.datiCartaDatiFinanziariResponse.riservaSalvadanaioSconfinoSegno = '';       
        r.datiCartaDatiFinanziariResponse.riservaSalvadanaioOverlimit = 0;
        r.datiCartaDatiFinanziariResponse.riservaSalvadanaioOverlimitSegno = '';
        r.datiCartaDatiFinanziariResponse.riservaSalvadanaioDispTeorMax = 0;        
        r.datiCartaDatiFinanziariResponse.riservaSalvadanaioDispTeorMaxSegno = '';       
        r.datiCartaDatiFinanziariResponse.riservaInternetFido = 0;
        r.datiCartaDatiFinanziariResponse.riservaInternetFidoSegno = '';
        r.datiCartaDatiFinanziariResponse.riservaInternetSaldo = 0;        
        r.datiCartaDatiFinanziariResponse.riservaInternetSaldoSegno = '';       
        r.datiCartaDatiFinanziariResponse.riservaInternetDisp = 0;
        r.datiCartaDatiFinanziariResponse.riservaInternetDispSegno = '';
        r.datiCartaDatiFinanziariResponse.riservaInternetSconfino = 0;        
        r.datiCartaDatiFinanziariResponse.riservaInternetSconfinoSegno = '';       
        r.datiCartaDatiFinanziariResponse.riservaInternetOverlimit = 0;
        r.datiCartaDatiFinanziariResponse.riservaInternetOverlimitSegno = '';
        r.datiCartaDatiFinanziariResponse.riservaInternetDispTeorMax = 0;
        r.datiCartaDatiFinanziariResponse.riservaInternetDispTeorMaxSegno = '';       
        r.datiCartaDatiFinanziariResponse.riservaMulticontoFido = 0;
        r.datiCartaDatiFinanziariResponse.riservaMulticontoSaldo = 0;
        r.datiCartaDatiFinanziariResponse.riservaMulticontoSaldoSegno = '';        
        r.datiCartaDatiFinanziariResponse.riservaMulticontoDisp = 0;       
        r.datiCartaDatiFinanziariResponse.riservaMulticontoDispSegno = '';
        r.datiCartaDatiFinanziariResponse.riservaMulticontoSconfino = 0;
        r.datiCartaDatiFinanziariResponse.riservaMulticontoSconfinoSegno = '';       
        r.datiCartaDatiFinanziariResponse.riservaMulticontoOverlimit = 0;       
        r.datiCartaDatiFinanziariResponse.riservaMulticontoOverlimitSegno = '';
        r.datiCartaDatiFinanziariResponse.riservaMulticontoDispTeorMax = 0;
        r.datiCartaDatiFinanziariResponse.riservaMulticontoDispTeorMaxSegno = '';        
        r.datiCartaDatiFinanziariResponse.as400Status = '';
        r.datiCartaDatiFinanziariResponse.as400Errore = '';
        
        r.datiCartaDatiFinanziariResponse.dataValiditaSlashed ='';
        r.datiCartaDatiFinanziariResponse.dataScadenzaSlashed=''; 
        r.datiCartaDatiFinanziariResponse.fidoCustom='';
        r.datiCartaDatiFinanziariResponse.disponibilitaCustom='';
        r.datiCartaDatiFinanziariResponse.modCalcoloRataCustom='';
        r.datiCartaDatiFinanziariResponse.statoCustom='';
        r.datiCartaDatiFinanziariResponse.statoRinnovoCustom='';
       
        System.assert(r.datiCartaDatiFinanziariResponse.dataValiditaSlashed != null );
        
    }
    
    
    
    
     @isTest
    public static void testMethods(){
        
        OCSCartaDatiFinanziariResponse r = new OCSCartaDatiFinanziariResponse();
        r.datiCartaDatiFinanziariResponse.as400Status = 'OK';
        r.datiCartaDatiFinanziariResponse.as400Errore = '';
        System.assert(r.isStatusOK() && r.getAs400Status() != null && r.getAs400Errore() != null ); 


        
        
    }
    
    
    
}