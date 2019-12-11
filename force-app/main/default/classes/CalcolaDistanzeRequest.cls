public with sharing class CalcolaDistanzeRequest extends OCSRequest{
	
	@AuraEnabled
	public CalcolaDistanzeRequestInner calcolaDistanzeRequest{get;set;}

	public CalcolaDistanzeRequest(){
		this.serviceId='calcolaDistanze';
  	}

	public class CalcolaDistanzeRequestInner{

		@AuraEnabled	
		public String indirizzoFiliale{get;set;}
		@AuraEnabled
		public List<String> elencoIndirizziIntermedi{get;set;}
	}


}