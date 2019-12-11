/**
 * @File Name          : OCSRecuperaDatiClienteResponse.cls
 * @Description        : 
 * @Author             : sabrina vitali
 * @Group              : 
 * @Last Modified By   : sabrina vitali
 * @Last Modified On   : 18/9/2019, 14:15:43
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    18/9/2019   sabrina vitali     Initial Version
**/
public class OCSRecuperaDatiClienteResponse extends OCSResponse{
    public RecuperaDatiClienteResponse recuperaDatiClienteResponse {get; set;}
        
    public OCSRecuperaDatiClienteResponse(){
        recuperaDatiClienteResponse = new RecuperaDatiClienteResponse();
    }
    public class RecuperaDatiClienteResponse{
        @AuraEnabled
        public String telefonoCasa {get{
            if(telefonoCasa == null) return '';
            return(telefonoCasa.replaceAll(' ', ''));
        } set;}
        @AuraEnabled
        public String telefonoAlternativo {get{
            if(telefonoAlternativo == null) return '';
            return(telefonoAlternativo.replaceAll(' ', ''));
        } set;}
        @AuraEnabled
        public String telCellulare {get{
            if(telCellulare == null) return '';
            return(telCellulare.replaceAll(' ', ''));
        } set;}
        @AuraEnabled
        public String fax {get{
            if(fax == null) return '';
            return(fax.replaceAll(' ', ''));
        } set;}
        public String privacyOffCommInterne {get; set;}
        public String privacyOffCommIntAut {get; set;}
        public String privacyOffCommEsterne {get; set;}
        public String privacyOffCommEstAut {get; set;}
        public String privacyServiziAltri {get; set;}
        public String privacyDatiSensibili {get; set;}
        public String privacyIstruttPratiche {get; set;}
        public String privacyRilevQualita {get; set;}
        public String privacyConsInfoSic {get; set;}
        public String privacyRichCanc {get; set;}
        public String privacyDataIstruttPratiche {get; set;}
        public String privacyDataOfferte {get; set;}
        public String privacyDataSensibili {get; set;}
        public String privacyDataConsSic {get; set;}
        public String privacyNoteConsSic {get; set;}        
    }
}