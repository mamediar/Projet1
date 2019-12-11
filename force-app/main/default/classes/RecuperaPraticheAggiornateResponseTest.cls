@isTest
public class RecuperaPraticheAggiornateResponseTest {
    
    @isTest 
    public static void testRequest(){
        RecuperaPraticheAggiornateResponse r                                                   = new RecuperaPraticheAggiornateResponse();
        RecuperaPraticheAggiornateResponse.RecuperaPraticheAggiornateResp   responseInner      = new RecuperaPraticheAggiornateResponse.RecuperaPraticheAggiornateResp();
        responseInner.numPratica                              = '000001';
        responseInner.statoAttuale                            = 'statoAttuale';
        responseInner.attributoAttuale                        = 'attributoAttuale';
        responseInner.dataUltimoAggiornamento                 = '01/01/2020';
        responseInner.oraUltimoAggiornamento                 = '00:00:00';
    }

}