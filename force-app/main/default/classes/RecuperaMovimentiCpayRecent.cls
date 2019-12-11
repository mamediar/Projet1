global class RecuperaMovimentiCpayRecent implements Comparable {
  public   RecuperaMovimentiCpayResponse.RecuperaMovimentiCpayRes recuperaCpay ;
    public RecuperaMovimentiCpayRecent(RecuperaMovimentiCpayResponse.RecuperaMovimentiCpayRes  rc) {
      this.recuperaCpay = rc;
    }
    global Integer compareTo(Object compareTo ){
     RecuperaMovimentiCpayRecent recuperaMovimentiCpayRecent = (RecuperaMovimentiCpayRecent) compareTo;
     Integer returnValue = 0;
     if(recuperaCpay.dataCompetenza <  recuperaMovimentiCpayRecent.recuperaCpay.dataCompetenza ){
         returnValue = 1;
     }
     else if(recuperaCpay.dataCompetenza >  recuperaMovimentiCpayRecent.recuperaCpay.dataCompetenza ){
         returnValue = -1;
     }
  return returnValue;
    }
  

}