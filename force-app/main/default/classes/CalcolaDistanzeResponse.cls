public with sharing class CalcolaDistanzeResponse extends OCSResponse {

	@AuraEnabled
	public distanzeResponse calcolaDistanzeResponse{get;set;}

	public class distanzeResponse{

		public String esitoCalcolo{get;set;}
        public String distanzaTotale{get;set;}
		public List<distanzaParziale> elencoParziali{get;set;}
		
	}

	public class distanzaParziale{

		public String partenza{get;set;}
        public String arrivo{get;set;}
		public String distanza{get;set;}

	}

	

}