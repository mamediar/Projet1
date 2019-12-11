@isTest
public class OCSRecuperaLettereFaxHostRequestTest {
    
    @isTest
    public static void testRequest() {
        OCSRecuperaLettereFaxHostRequest req = new OCSRecuperaLettereFaxHostRequest();
        OCSRecuperaLettereFaxHostRequest.RecuperaLettereFaxHostRequestDTO reqDTO = new OCSRecuperaLettereFaxHostRequest.RecuperaLettereFaxHostRequestDTO();
        reqDTO.codCliente='';
        reqDTO.dataDa='';
        reqDTO.numPratica='';
        reqDTO.tipoPratica='';
        
    }
    
    @isTest
    public static void testSetDataDa(){
        DateTime dat = DateTime.newInstance(2019, 2, 25, 7, 8, 12);
        OCSRecuperaLettereFaxHostRequest req = new OCSRecuperaLettereFaxHostRequest();
        req.setDataDa(dat);
    }
    
}