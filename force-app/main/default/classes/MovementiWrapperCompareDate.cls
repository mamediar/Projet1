global  class MovementiWrapperCompareDate implements Comparable {
    public RecuperaMovAutViaggiantiResponse.MovimentoViaggianteDTO movementi;
    public MovementiWrapperCompareDate(RecuperaMovAutViaggiantiResponse.MovimentoViaggianteDTO m) {
         this.movementi = m;
    }
    global Integer compareTo (Object compareTo){
      MovementiWrapperCompareDate movimentiWrapper = (MovementiWrapperCompareDate) compareTo;
      Integer returnValue = 0;
      if(CGMWSUtils_1_0.formatStringToDate (movementi.dataOperazione)  < CGMWSUtils_1_0.formatStringToDate(movimentiWrapper.movementi.dataOperazione) ){
          returnValue = 1;
      }
      else if(CGMWSUtils_1_0.formatStringToDate (movementi.dataOperazione)  > CGMWSUtils_1_0.formatStringToDate(movimentiWrapper.movementi.dataOperazione) ){
          returnValue = -1;
      }
      return returnValue;
    }
}