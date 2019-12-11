@isTest
public  class RecuperaPraticheAggiornateRequestTest {

    @isTest 
    public static void testRequest(){
        RecuperaPraticheAggiornateRequest r = new RecuperaPraticheAggiornateRequest();
        r.recuperaPraticheAggiornateRequest.filtroPartner = 'DS';
        r.recuperaPraticheAggiornateRequest.dataInizio = '01/01/2020';
        r.recuperaPraticheAggiornateRequest.oraInizio  = '00:00:00';
    }
    
}