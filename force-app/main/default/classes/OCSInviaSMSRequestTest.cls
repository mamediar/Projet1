@isTest
public class OCSInviaSMSRequestTest {
    
    
    @isTest
    static void test(){
    	OCSInviaSMSRequest ogg = new OCSInviaSMSRequest();
    	ogg.inviaSMSRequest.tipo = 'WEB2';
        ogg.inviaSMSRequest.numero = '3498307332';
        ogg.inviaSMSRequest.emettitore = '';
        ogg.inviaSMSRequest.pan = '';
        ogg.inviaSMSRequest.testo = 'TESTO1';

    }

}