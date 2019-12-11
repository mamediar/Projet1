global class AuthorizzaWrapperCompareDate implements Comparable {
    public RecuperaMovAutViaggiantiResponse.AutorizzazioneViaggianteDTO authori;
 
  public AuthorizzaWrapperCompareDate(RecuperaMovAutViaggiantiResponse.AutorizzazioneViaggianteDTO a ){
      this.authori = a;
  }
  global Integer compareTo (Object compareTo ){
    AuthorizzaWrapperCompareDate compareAuthDate = (AuthorizzaWrapperCompareDate) compareTo;
    Integer returnValue = 0;
    if(  CGMWSUtils_1_0.formatStringToDate(authori.data)  < CGMWSUtils_1_0.formatStringToDate(compareAuthDate.authori.data)  ){
        returnValue = 1;
    }
    else if( CGMWSUtils_1_0.formatStringToDate(authori.data)   > CGMWSUtils_1_0.formatStringToDate(compareAuthDate.authori.data) ){
        returnValue = -1;
    }
    return returnValue;
  }

}