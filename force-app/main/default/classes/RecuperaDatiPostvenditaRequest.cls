public  class RecuperaDatiPostvenditaRequest extends OCSAPIRequest {
    public String numPratica{get;set;}
    public String flagInfoCliente {get;set;}
    public String filtroTipoPratica {get;set;}
    public String codCliente {get;set;}
    public String cognomeCliente {get;set;}
    public String nomeCliente {get;set;}
    public String dataNascitaCliente {get;set;}
    public String codFiscaleCliente {get;set;}
    public String pan {get;set;}
    public String telefonoCliente {get;set;}
    public String faxCliente {get;set;}
    public String emailCliente {get;set;}
    public String provinciaCliente {get;set;}
    public String ragioneSociale {get;set;}
    public RecuperaDatiPostvenditaRequest(){
      super();
    }
    public RecuperaDatiPostvenditaRequest(String codCliente, String filtroTipoPratica, String flagInfoCliente) {
     super();
    this.codCliente = codCliente;
    this.filtroTipoPratica = filtroTipoPratica;
    this.flagInfoCliente = flagInfoCliente;
    } 

}