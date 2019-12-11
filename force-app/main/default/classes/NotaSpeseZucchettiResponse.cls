public with sharing class NotaSpeseZucchettiResponse extends OCSResponse {
	
	@AuraEnabled
	public String resultCode{get;set;}
	@AuraEnabled
	public String resultMessage{get;set;}
}