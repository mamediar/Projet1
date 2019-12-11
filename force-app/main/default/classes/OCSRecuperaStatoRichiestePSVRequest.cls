public class OCSRecuperaStatoRichiestePSVRequest extends OCSRequest
{
	public recuperaStatoRichiestePSVRequestClass recuperaStatoRichiestePSVRequest{get;set;}

    public OCSRecuperaStatoRichiestePSVRequest(){
		  this.serviceId='recuperaStatoRichiestePSV';
          this.recuperaStatoRichiestePSVRequest = new recuperaStatoRichiestePSVRequestClass();
    }
    
    public class recuperaStatoRichiestePSVRequestClass{
        public String tipoPratica{get;set;}
        public String numPratica {get;set;}
        public String codAzione {get;set;}
        public String dataAzione {get;set;}
    }
    
}