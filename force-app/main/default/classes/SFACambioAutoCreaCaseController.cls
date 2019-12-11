public class SFACambioAutoCreaCaseController {

	private static final String SFA = 'SFA';
    
    @AuraEnabled
    public static List<SelectOption> getAzioniFilialeSuDealer() {
        
        List<AzioniFilialeSuDealer__mdt> lstAzioniFiliale = 
            [SELECT Id, DeveloperName, QualifiedApiName, Label FROM AzioniFilialeSuDealer__mdt];
        
        List<SelectOption> lstSelectOption = new List<SelectOption>();

        SelectOption selectOption = new SelectOption('Seleziona l\'attività', '', 'true');
		lstSelectOption.add(selectOption);
        
        for (AzioniFilialeSuDealer__mdt azioneFiliale : lstAzioniFiliale) {
			SelectOption so = new SelectOption(azioneFiliale.Label, azioneFiliale.DeveloperName, 'false');
			lstSelectOption.add(so);
		}
                                                                                                          
        return lstSelectOption;
    }
    
    @AuraEnabled
	public static String creaCase(String dealerId, String developerNameAzioneSelezionata) {
        
        AzioniFilialeSuDealer__mdt azioneFiliale = [SELECT Id, DeveloperName, QualifiedApiName, CaseActivityType__c, CaseSubject__c, Label 
                                                    FROM AzioniFilialeSuDealer__mdt
                                                    WHERE DeveloperName = :developerNameAzioneSelezionata][0];

		Case case1 = new Case();
		case1.ActivityType__c = azioneFiliale.CaseActivityType__c;
		case1.Subject = azioneFiliale.CaseSubject__c;
		case1.AccountId = dealerId;
		case1.Type = SFA;
		insert case1;

		CaseUtils.assignToParentQueue(case1.Id);
		return case1.Id;
	}

	public class SelectOption {

		public SelectOption(String label, String text, String value) {
			this.label = label;
			this.text = text;
			this.value = value;
		}

		@AuraEnabled
		public String label { get; set; }
		@AuraEnabled
		public String text { get; set; }
		@AuraEnabled
		public String value { get; set; }
	}

}