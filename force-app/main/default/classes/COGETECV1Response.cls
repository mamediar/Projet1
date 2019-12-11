//----------------------------------------------------------------------
//-- - Author       : SANA BADJI
//-- - Date         : 12/07/2019
//-- - Description  : Handle WS_COGETECV1Response
//----------------------------------------------------------------------
public  class COGETECV1Response extends OCSAPIResponse{
    @AuraEnabled
    public COGETECV1ResponseDTO cogetecv1Response {get;set;}
     @AuraEnabled
    public MFTCOECO mftcoECO {get;set;}
     @AuraEnabled
    public MSFERR_ERRORIV1 mfterrOMSFERROCCURSV1 {get;set;}
    
    public COGETECV1Response() {
        this.cogetecv1Response=new COGETECV1ResponseDTO();
        this.mftcoECO=new MFTCOECO();
        this.mfterrOMSFERROCCURSV1=new MSFERR_ERRORIV1();
        this.cogetecv1Response.mftcoecoOCCURS=new List<MFTCOECO>();
        this.cogetecv1Response.mfterrOMSFERROCCURS=new  List<MSFERR_ERRORIV1>();
        this.mftcoECO.mftcoecoELEMENTO=new List<MFTCOECO_ELEMENTO>();

    }
    public class COGETECV1ResponseDTO{
        @AuraEnabled  public String msfologonSTATUS;
        @AuraEnabled  public String msfologonSESSIONID;
        @AuraEnabled  public String msfologonERRORE;
        @AuraEnabled  public String msfologonERROREDES;
        @AuraEnabled public List<MSFERR_ERRORIV1> mfterrOMSFERROCCURS {get;set;}
        @AuraEnabled public List<MFTCOECO>  mftcoecoOCCURS{get;set;}

    }
    public class MSFERR_ERRORIV1{
        @AuraEnabled public String msferrNRECORD;
        @AuraEnabled public String msferrTIPO;
        @AuraEnabled public String msferrCODICE;
        @AuraEnabled public String msferrDESCRIZIONE;
        @AuraEnabled public String msferrNCAMPO;
        @AuraEnabled public String msferrCODMSG;
    }
    public class MFTCOECO{
        public List<MFTCOECO_ELEMENTO> mftcoecoELEMENTO {get;set;}
        
    }
    public class MFTCOECO_ELEMENTO{
       @AuraEnabled  public Integer mftcoecoPARTITA;
       @AuraEnabled  public String mftcoecoPARTITATIPO;
       @AuraEnabled  public String mftcoecoIMPORTO;
      @AuraEnabled   public String mftcoecoIMPORTOS;
       @AuraEnabled  public String mftcoecoNUMERORATA;
       @AuraEnabled  public String mftcoecoDATASCADENZA;
       @AuraEnabled  public Integer mftcoecoMORAMATURATA;
       @AuraEnabled  public Integer mftcoecoSALDO;
        @AuraEnabled public String mftcoecoSALDOS;
    }
}