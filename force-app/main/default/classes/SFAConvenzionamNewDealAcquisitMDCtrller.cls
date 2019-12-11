public class SFAConvenzionamNewDealAcquisitMDCtrller {
	private static final String SFA_NEW_DEALER_ACQUISITION = 'SFA_NEW_DEALER_ACQUISITION';

    @AuraEnabled
    public static Dati getDealerAcquisition(String caseId ) {
        String dispositionExternalId='';
		Dati dati = new Dati();
        
		Case caseAttivita = 
			[SELECT Id, AccountId, Disposition__c, OCSExternalFilialeConvenzionato__c 
			FROM Case 
			WHERE Id = :caseId][0];
        
        dati.dealerAcquisitionId=caseAttivita.AccountId;
		dati.OCSExternalFiliale=caseAttivita.OCSExternalFilialeConvenzionato__c;
        
        XCS_Disposition__c disposition = new XCS_Disposition__c();
        if(!String.isEmpty(caseAttivita.Disposition__c)){
            disposition = [SELECT Id, Name, External_Id__c FROM XCS_Disposition__c WHERE Id = :caseAttivita.Disposition__c][0];                 
            dispositionExternalId=disposition.External_Id__c;
            System.debug('###dati.disposition 1:: '+dati.disposition);            
        }        
        dati.disposition=disposition;        
        
        
        List<ReportCerved__c> report=	[SELECT Id 
			FROM ReportCerved__c 
			WHERE DealerId__c = :dati.dealerAcquisitionId AND IsReportValido__c = true ORDER BY CreatedDate DESC];        //recupero solo il report valido, dovrebbe essercene uno solo ma per sicurezza li ordino in maniera decrescente e prendo solo l'ultimo generato valido
			
        if(report.size()>0){
            dati.reportCervedId = report[0].Id;
        }

        String genericMessage='Attività di convenzionamento già esitata e consegnata all\'ufficio Acquisizione e Valutazione.'; 
        SFAConvenzionamento.DatiMessage datiMessage=SFAConvenzionamento.getFinalMessageToVisualize(caseId,SFAConvenzionamento.queueMD,dispositionExternalId,'Monitoraggio Dealer',genericMessage);
		dati.IsAttivitaInManoAdMD=datiMessage.queueOwnerActivity;
        dati.message=datiMessage.message;
        return dati;
		
	}

    @AuraEnabled
    public static void assignCase(String caseId) {
        Case caseDealer=SFAConvenzionamento.utenteLavorazione(caseId,SFAConvenzionamento.queueAV,false);
        caseDealer=CaseShareUtil.setStringInCaseShare(caseDealer,SFAConvenzionamento.sharingToAV);
        SFAConvenzionamento.stepLavorazione(caseDealer,SFAConvenzionamento.NDA_FormInizialeAV,true);    //update step lavorazione
		System.debug('step Aggiornato');
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
        public Boolean IsAttivitaInManoAdMD {get; set;}        
        @AuraEnabled
        public XCS_Disposition__c disposition {get; set;}        
    }    
    
 
    
    
}