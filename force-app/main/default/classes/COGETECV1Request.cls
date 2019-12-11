//----------------------------------------------------------------------
//-- - Author       : SANA BADJI
//-- - Date         : 12/07/2019
//-- - Description  : Handle WS_COGETECV1Request
//----------------------------------------------------------------------
public  class COGETECV1Request extends OCSAPIRequest{

    public   COGETECV1RequestDTO  cogetecv1Request  {get;set;}

    public COGETECV1Request() {
        this.serviceId='OCS_COGETEC_V1';
        this.cogetecv1Request=new COGETECV1RequestDTO();
    }
    
    public class COGETECV1RequestDTO {
        public  String mftcoeciNUMPRATICA {get;set;}
        public  String msfilogonUTENTEOVR {get;set;}
        public  String msfilogonRIFSICOVR {get;set;}
        public  String msfilogonUTENTEAS400 {get;set;}
        public  String msfilogonCODINTFILIALE {get;set;}
        public  String msfilogonCREAUTENTECOLL {get;set;}
        public  String msfilogonPOSTAZIONE {get;set;}
        public  String mftcoeciPROGRESSIVO {get;set;}
        public  String mftcoeciDATASITUAZIONE {get;set;}
        public  String mftcoeciSELEZSCAD {get;set;}
        public  String mftcoeciSELEZSALDO {get;set;}
        public  String mftcoeciNUMELEMENTI {get;set;}
        public  String msflogonTMPKEY {get;set;}
        public  String msfilogonSENDERTIPO {get;set;}
        public  String msfilogonSENDERCODICE {get;set;}
        public  String msfilogonCANALEACQUISIZ {get;set;}
        public  String msfilogonTIPOCARICAMENTO {get;set;}
    }
}