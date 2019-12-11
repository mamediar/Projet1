@isTest
public class OCS_OCS_COPSVDTA_V1ResponseTest {
    @isTest
    public static void test(){
        OCS_OCS_COPSVDTA_V1Response r = new OCS_OCS_COPSVDTA_V1Response();
        
        r.copsvdtaresponse.mftpsres_STATUS = '';
        r.copsvdtaresponse.mftpsres_PROCEDURA = '';
        r.copsvdtaresponse.mftpsres_NUM_PRATICA = 0;
        r.copsvdtaresponse.mftpsres_STATO = '';
        r.copsvdtaresponse.mftpsres_ATTRIBUTO = '';
        r.copsvdtaresponse.mftpsres_PROGRESSIVO = 0;
        
        r.copsvdtaresponse.mftpsres_CODICE_RIF_EXT_2 = '';
        r.copsvdtaresponse.msfologon_ERRORE = '';
        r.copsvdtaresponse.msfologon_ERRORE_DES = '';
        r.copsvdtaresponse.msfologon_STATUS = '';
        r.copsvdtaresponse.msfologon_SESSION_ID = '';
        
    OCS_OCS_COPSVDTA_V1Response.Mfterr_OMSFERR_OCCURS p = new OCS_OCS_COPSVDTA_V1Response.Mfterr_OMSFERR_OCCURS();
        p.msferr_N_RECORD = 0;
        p.msferr_N_CAMPO = 0;
        
        p.msferr_TIPO = '';
        p.msferr_CODICE = '';
        p.msferr_DESCRIZIONE = '';
        p.msferr_COD_MSG = '';
    }
    
    
}