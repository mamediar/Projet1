public class ProvaConvenzionamentoCtroller {

    @AuraEnabled
    public static Dati getDealerAcquisition(String caseId ) {
        String dispositionExternalId='';
		Dati dati = new Dati();

		Case caseAttivita = 
			[SELECT Id, AccountId, Disposition__c, OCSExternalFilialeConvenzionato__c, OwnerId 
			FROM Case 
			WHERE Id = :caseId][0];
        
        dati.dealerAcquisitionId=caseAttivita.AccountId;

        List<ReportCerved__c> report=	[SELECT Id 
			FROM ReportCerved__c 
			WHERE DealerId__c = :dati.dealerAcquisitionId AND IsReportValido__c = true ORDER BY CreatedDate DESC];        //recupero solo il report valido, dovrebbe essercene uno solo ma per sicurezza li ordino in maniera decrescente e prendo solo l'ultimo generato valido
			
        if(report.size()>0){
            dati.reportCervedId = report[0].Id;
        }

		return dati;
		
	}    
    
 	public class Dati {
        @AuraEnabled
        public Id dealerAcquisitionId {get; set;}
        @AuraEnabled
        public Id reportCervedId {get; set;}     
        @AuraEnabled
        public String OCSExternalFiliale {get; set;} 
        @AuraEnabled
        public String message {get; set;}        
        @AuraEnabled
        public Boolean IsAttivitaInManoAdAV {get; set;}         
        @AuraEnabled
        public XCS_Disposition__c disposition {get; set;}        
    }  
    
}