global class COGETECVElementoRecent implements Comparable {
    public COGETECV1Response.MFTCOECO_ELEMENTO mftCoecoElement;
    public COGETECVElementoRecent(COGETECV1Response.MFTCOECO_ELEMENTO mft) {
     this.mftCoecoElement = mft;
    }
    global Integer compareTo(Object compareTo){
        COGETECVElementoRecent  cogeteElem = (COGETECVElementoRecent) compareTo;
        Integer returnValue = 0;
        if(mftCoecoElement.mftcoecoDATASCADENZA < 
           cogeteElem.mftCoecoElement.mftcoecoDATASCADENZA ){
                returnValue = 1;
         
        }
        else if(mftCoecoElement.mftcoecoDATASCADENZA > cogeteElem.mftCoecoElement.mftcoecoDATASCADENZA && mftCoecoElement.mftcoecoSALDO != 0){
              returnValue = -1;
        }
        System.debug('********* returnValue '+returnValue);
        return returnValue;
    }
}