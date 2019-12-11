global class RecuperaElencoMovWrapper implements Comparable {
 public RecuperaElencoMovimentiResponse.MovimentiEstrattoContoDTO movimentis;

 public RecuperaElencoMovWrapper(RecuperaElencoMovimentiResponse.MovimentiEstrattoContoDTO m){
     this.movimentis = m ;
 }

global Integer compareTo(Object compareTo) {
    RecuperaElencoMovWrapper rwrapper = (RecuperaElencoMovWrapper) compareTo;
    Integer returnValue = 0;
    if(CGMWSUtils_1_0.formatStringToDate(movimentis.dataAcquisto) < CGMWSUtils_1_0.formatStringToDate(rwrapper.movimentis.dataAcquisto) ){
        returnValue = 1;
    }
    else if (CGMWSUtils_1_0.formatStringToDate(movimentis.dataAcquisto) > CGMWSUtils_1_0.formatStringToDate(rwrapper.movimentis.dataAcquisto) ){
        returnValue = -1;
    }

    return returnValue;
    }

}