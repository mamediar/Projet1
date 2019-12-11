public  class RecuperaMovimentiCpayRequest  extends OCSAPIRequest{
    public RecuperaMovimentiCpayRequestDTO   recuperaMovimentiCpayRequest;
    public RecuperaMovimentiCpayRequest() {
        this.recuperaMovimentiCpayRequest = new RecuperaMovimentiCpayRequestDTO ();

    }

    public class RecuperaMovimentiCpayRequestDTO  {
      public String numPratica {get;set;}
      public String dataCompetenzaDa {get;Set;}
      public String dataCompetenzaA {get;Set;}

    }

}