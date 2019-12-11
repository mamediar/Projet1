@isTest
public class OCSRecuperaPacchettiServiziResponseTest {
    
    @isTest
    public static void test() {
        
        OCSRecuperaPacchettiServiziResponse rp = new OCSRecuperaPacchettiServiziResponse();
        OCSRecuperaPacchettiServiziResponse.RecuperaPacchettiServiziResponseDTO rpdto = new OCSRecuperaPacchettiServiziResponse.RecuperaPacchettiServiziResponseDTO();
        
        OCSRecuperaPacchettiServiziResponse.PacchettoServizioDTO pa = new   OCSRecuperaPacchettiServiziResponse.PacchettoServizioDTO();
        pa.codServizio ='';
        pa.codPacchetto ='';
        pa.codFornitore ='';
        pa.dataInizioCopertura ='';
        pa.dataFineCopertura ='';
        pa.assicurazioneAttivaFinanziata ='';
        pa.durata='';
        pa.desFornitore ='';
        
        
    }
    
}