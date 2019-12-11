//----------------------------------------------------------------------
//-- - Author       : SANA BADJI
//-- - Date         : 12/07/2019
//-- - Description  : Handle WS_COGETECV1Service
//----------------------------------------------------------------------
public  class COGETECV1Service {
    public static Boolean hasError = false;
    public static List<ValidationError> errors = new List<ValidationError>();
    public static COGETECV1Response invoke(COGETECV1Request req){
        return (COGETECV1Response) OCSApiUtils.callApi('OCS_COGETEC_V1',
                                                                                req,
                                                                                COGETECV1Response.class,'C');
    }

    public static COGETECV1Response buildCOGETECV1Response (
                                                    String mftcoeciNUMPRATICA,
                                                    String  msfilogonUTENTEOVR,
                                                    String msfilogonRIFSICOVR,
                                                    String msfilogonUTENTEAS400,
                                                    String msfilogonCODINTFILIALE,
                                                    String msfilogonCREAUTENTECOLL,
                                                    String msfilogonPOSTAZIONE, 
                                                    String mftcoeciPROGRESSIVO,
                                                    String mftcoeciDATASITUAZIONE,
                                                    String mftcoeciSELEZSCAD,
                                                    String mftcoeciSELEZSALDO,
                                                    String mftcoeciNUMELEMENTI,
                                                    String msflogonTMPKEY,
                                                    String msfilogonSENDERTIPO,
                                                    String msfilogonSENDERCODICE,
                                                    String msfilogonCANALEACQUISIZ,
                                                    String msfilogonTIPOCARICAMENTO){
        COGETECV1Response response;
        COGETECV1Request request = new COGETECV1Request();
      /*  COGETECV1Request.COGETECV1RequestDTO obj = new  COGETECV1Request.COGETECV1RequestDTO ();
         request.cogetecv1Request = obj;*/
        request.cogetecv1Request.mftcoeciNUMPRATICA = mftcoeciNUMPRATICA;
        request.cogetecv1Request.msfilogonUTENTEOVR = msfilogonUTENTEOVR;
        request.cogetecv1Request.msfilogonRIFSICOVR = msfilogonRIFSICOVR;
        request.cogetecv1Request.msfilogonUTENTEAS400 = msfilogonUTENTEAS400;
        request.cogetecv1Request.msfilogonCODINTFILIALE = msfilogonCODINTFILIALE;
        request.cogetecv1Request.msfilogonCREAUTENTECOLL = msfilogonCREAUTENTECOLL;
        request.cogetecv1Request.msfilogonPOSTAZIONE = msfilogonPOSTAZIONE;
        request.cogetecv1Request.mftcoeciPROGRESSIVO = mftcoeciPROGRESSIVO;
        request.cogetecv1Request.mftcoeciDATASITUAZIONE = mftcoeciDATASITUAZIONE;
        request.cogetecv1Request.mftcoeciSELEZSCAD = mftcoeciSELEZSCAD;
        request.cogetecv1Request.mftcoeciSELEZSALDO = mftcoeciSELEZSALDO;
        request.cogetecv1Request.mftcoeciNUMELEMENTI = mftcoeciNUMELEMENTI;
        request.cogetecv1Request.msflogonTMPKEY = msflogonTMPKEY;
        request.cogetecv1Request.msfilogonSENDERTIPO = msfilogonSENDERTIPO;
        request.cogetecv1Request.msfilogonSENDERCODICE = msfilogonSENDERCODICE;
        request.cogetecv1Request.msfilogonCANALEACQUISIZ = msfilogonCANALEACQUISIZ;
        request.cogetecv1Request.msfilogonTIPOCARICAMENTO = msfilogonTIPOCARICAMENTO; 
        
        response = invoke(request);
    return response;
}

/*
    *@Author SANA BADJI
    *@description Validate field Response
    *@param response : validateResponse
    *@return Boolean
    */
    public static Boolean validateResponse (COGETECV1Response response){
                
                System.debug(' ************** response.cogetecv1Response.mftcoecoOCCURS '+response.cogetecv1Response.mftcoecoOCCURS.size());
                //System.debug(' ************** response.cogetecv1Response.mfterrOMSFERROCCURS '+response.cogetecv1Response.mfterrOMSFERROCCURS.size());
                    if(response.resultCode != 0 ){
                        hasError = true;
                        errors.add(new ValidationError ('invalid Response ', 'COGETECV1Response')); }

                    if(response.resultMessage=='KO' ){
                        hasError = true;
                        errors.add(new ValidationError('InValid resultMessage','COGETECV1Response' ) );
                    }
                    if (response.cogetecv1Response.mftcoecoOCCURS.size() == 0 ){
                    hasError = true;
                    errors.add(new ValidationError ('mftcoecoOCCURS list can\'t be null ', 'COGETECV1Response'));
                    }
                    if (response.cogetecv1Response.mftcoecoOCCURS.size() == 0 ){
                    hasError = true;
                    errors.add(new ValidationError ('mftcoECO  can\'t be null ', 'COGETECV1Response'));
                    }
                    // if (response.cogetecv1Response.mfterrOMSFERROCCURS.size() == 0 ){
                    // hasError = true;
                    // errors.add(new ValidationError ('mftcoecoOCCURS list can\'t be null ', 'COGETECV1Response'));
                    // }
                    System.debug(' ************** hasError '+ hasError);
            return !hasError;
    }

    public static COGETECV1Response.MFTCOECO_ELEMENTO gestitoCOGETECV1Service(List<COGETECV1Response.MFTCOECO_ELEMENTO> elements){
      if(elements == null || elements.size() == 0){
        return null;
    }
    else {
         System.debug('********** bef element '+elements);
         List<COGETECVElementoRecent> listRecent = new List<COGETECVElementoRecent>();
         List<COGETECV1Response.MFTCOECO_ELEMENTO> elementos = getElementoWithSoldeZero(elements);
         System.debug('************* elementos '+elementos);
         for(COGETECV1Response.MFTCOECO_ELEMENTO element : elementos){
             listRecent.add(new COGETECVElementoRecent(element) );
         }
         listRecent.sort();
         System.debug('********** sor element '+listRecent);
         COGETECV1Response.MFTCOECO_ELEMENTO recent = listRecent[0].mftCoecoElement;
         dividendoElimina(recent);
        return recent;
    }
}
public static List<COGETECV1Response.MFTCOECO_ELEMENTO> getElementoWithSoldeZero(List<COGETECV1Response.MFTCOECO_ELEMENTO> elemento){
      List<COGETECV1Response.MFTCOECO_ELEMENTO> elementos = new List<COGETECV1Response.MFTCOECO_ELEMENTO>();
      try {
          for( COGETECV1Response.MFTCOECO_ELEMENTO  ele : elemento){
              if(ele.mftcoecoSALDO == 0){
                  elementos.add(ele);
              }
          }
          
      } catch (Exception e) {
           System.debug('***********  getElementoWithSoldeZero erroMessage '+e.getMessage());
           System.debug('***********  getElementoWithSoldeZero erroMessage '+e.getStackTraceString() );
      }
      return elementos;
}

 public static void dividendoElimina(COGETECV1Response.MFTCOECO_ELEMENTO rc){
            if(rc == null){
                return;
            }
            else {
                String importom = (rc.mftcoecoIMPORTO).remove('-');
                Integer montant = Integer.valueOf(importom)/100;
                String   importoString = String.valueOf(montant);
                rc.mftcoecoIMPORTO = importoString;
                Datetime df= CGMWSUtils_1_0.formatStringToDatetime(rc.mftcoecoDATASCADENZA);
                String deteformat = 'dd/MM/yyyy';
                String ds = df.format(deteformat);
                rc.mftcoecoDATASCADENZA = ds;

                
            }
}
}