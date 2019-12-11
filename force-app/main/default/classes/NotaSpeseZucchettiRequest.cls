public with sharing class NotaSpeseZucchettiRequest extends OCSRequest {

	@AuraEnabled
	public String codiceUtente{get;set;}
	@AuraEnabled
	public String pcodestrdl{get;set;}
	@AuraEnabled
	public String pcodestsub{get;set;}
	@AuraEnabled
	public String pcodfiscale{get;set;}
	@AuraEnabled
	public String panno{get;set;}
	@AuraEnabled
	public String pmese{get;set;}
	@AuraEnabled
	public String pidstateini{get;set;}
	@AuraEnabled
	public String pidcityini{get;set;}
	@AuraEnabled
	public String pdataini{get;set;}
	@AuraEnabled
	public String poraini{get;set;}
	@AuraEnabled
	public String pidstatefin{get;set;}
	@AuraEnabled
	public String pidcityfin{get;set;}
	@AuraEnabled
	public String pdatafin{get;set;}
	@AuraEnabled
	public String porafin{get;set;}
	@AuraEnabled
	public String pmotitr{get;set;}
	@AuraEnabled
	public String pdefore{get;set;}
	@AuraEnabled
	public String pannotazioni{get;set;}
	@AuraEnabled
	public String pitinerario{get;set;}
	@AuraEnabled
	public String ptipoauto{get;set;}
	@AuraEnabled
	public String pmodauto{get;set;}
	@AuraEnabled
	public String ptiporimb{get;set;}
	@AuraEnabled
	public String pantarga{get;set;}
	@AuraEnabled
	public String pdistanza{get;set;}
	@AuraEnabled
	public String pnotekm{get;set;}

	public NotaSpeseZucchettiRequest(){
		this.serviceId='creaNotaSpeseZucchetti';
  }

}