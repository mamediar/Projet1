public class SFATargheMancantiScadenziarioController {
	
	@AuraEnabled
	public static Scadenziario init(String caseId){
		Case case1 = [SELECT Id, CreatedDate, Status, DataTermineLavoro__c FROM Case WHERE Id = :caseId][0];
		Scadenziario scadenziario = new Scadenziario();
		scadenziario.caseStatus = case1.Status;
		scadenziario.dataCaricamento = case1.CreatedDate;
		scadenziario.dataTermineLavoro = case1.DataTermineLavoro__c;
		List<SFAConfigurazioneDecadeTargheMancanti__c> lstSFAcdtm = 
			[SELECT Id, InizioDecade__c, FineDecade__c, DataLimite__c
			FROM SFAConfigurazioneDecadeTargheMancanti__c 
			WHERE IdElaborazione__c = :caseId
			ORDER BY InizioDecade__c ASC];

		if (lstSFAcdtm.size() == 3) {
			scadenziario.inizioDecade1 = Integer.valueOf(lstSFAcdtm[0].InizioDecade__c);
			scadenziario.fineDecade1 = Integer.valueOf(lstSFAcdtm[0].FineDecade__c);
			scadenziario.dataTermineScadenziarioDecade1 = lstSFAcdtm[0].DataLimite__c;

			scadenziario.inizioDecade2 = Integer.valueOf(lstSFAcdtm[1].InizioDecade__c);
			scadenziario.fineDecade2 = Integer.valueOf(lstSFAcdtm[1].FineDecade__c);
			scadenziario.dataTermineScadenziarioDecade2 = lstSFAcdtm[1].DataLimite__c;

			scadenziario.inizioDecade3 = Integer.valueOf(lstSFAcdtm[2].InizioDecade__c);
			scadenziario.fineDecade3 = Integer.valueOf(lstSFAcdtm[2].FineDecade__c);
			scadenziario.dataTermineScadenziarioDecade3 = lstSFAcdtm[2].DataLimite__c;
		}

		
		/*for (SFATargaMancante__c pratica: lstPratica) {
			if (pratica.DataLiquidazione__c.day() >= 1 && pratica.DataLiquidazione__c.day() <= 10) {
				scadenziario.dataTermineScadenziarioDecade1 = pratica.DataTermineScadenziario__c;
			}
			else if (pratica.DataLiquidazione__c.day() >= 11 && pratica.DataLiquidazione__c.day() <= 20) {
				scadenziario.dataTermineScadenziarioDecade2 = pratica.DataTermineScadenziario__c;
			}
			else if (pratica.DataLiquidazione__c.day() >= 21 && pratica.DataLiquidazione__c.day() <= Date.daysInMonth(pratica.DataLiquidazione__c.year(), pratica.DataLiquidazione__c.month())) {
				scadenziario.dataTermineScadenziarioDecade3 = pratica.DataTermineScadenziario__c;
			}
		}*/
		return scadenziario;
	}

	@AuraEnabled
	public static void updateScadenze(String caseId, Integer inizioDecade1, Integer fineDecade1, String dataTermineDecade1, Integer inizioDecade2, Integer fineDecade2, String dataTermineDecade2, Integer inizioDecade3, Integer fineDecade3, String dataTermineDecade3){

		List<SFAConfigurazioneDecadeTargheMancanti__c> lstSFAcdtm = 
			[SELECT Id, InizioDecade__c, FineDecade__c, DataLimite__c
			FROM SFAConfigurazioneDecadeTargheMancanti__c 
			WHERE IdElaborazione__c = :caseId
			ORDER BY InizioDecade__c ASC];

		lstSFAcdtm[0].InizioDecade__c = Integer.valueOf(inizioDecade1);
		lstSFAcdtm[0].FineDecade__c = Integer.valueOf(fineDecade1);
		Date dataTermineScadenziarioDecade1 = Date.valueOf(dataTermineDecade1);
		lstSFAcdtm[0].DataLimite__c = dataTermineScadenziarioDecade1;

		lstSFAcdtm[1].InizioDecade__c = Integer.valueOf(inizioDecade2);
		lstSFAcdtm[1].FineDecade__c = Integer.valueOf(fineDecade2);
		Date dataTermineScadenziarioDecade2 = Date.valueOf(dataTermineDecade2);
		lstSFAcdtm[1].DataLimite__c = dataTermineScadenziarioDecade2;

		lstSFAcdtm[2].InizioDecade__c = Integer.valueOf(inizioDecade3);
		lstSFAcdtm[2].FineDecade__c = Integer.valueOf(fineDecade3);
		Date dataTermineScadenziarioDecade3 = Date.valueOf(dataTermineDecade3);
		lstSFAcdtm[2].DataLimite__c = dataTermineScadenziarioDecade3;

		update lstSFAcdtm;

		List<SFATargaMancante__c> lstPratica = 
			[SELECT Id, DataTermineScadenziario__c, DataLiquidazione__c
			FROM SFATargaMancante__c 
			WHERE IdElaborazione__c = :caseId];

		for (SFATargaMancante__c pratica: lstPratica) {
			if (pratica.DataLiquidazione__c.day() >= 1 && pratica.DataLiquidazione__c.day() <= 10) {
				pratica.DataTermineScadenziario__c = dataTermineScadenziarioDecade1;
			}
			else if (pratica.DataLiquidazione__c.day() >= 11 && pratica.DataLiquidazione__c.day() <= 20) {
				pratica.DataTermineScadenziario__c = dataTermineScadenziarioDecade2;
			}
			else if (pratica.DataLiquidazione__c.day() >= 21 && pratica.DataLiquidazione__c.day() <= Date.daysInMonth(pratica.DataLiquidazione__c.year(), pratica.DataLiquidazione__c.month())) {
				pratica.DataTermineScadenziario__c = dataTermineScadenziarioDecade3;
			}
		}

		update lstPratica;
	}

	public class Scadenziario {
		@AuraEnabled
        public String caseStatus {get; set;}
        @AuraEnabled
        public DateTime dataCaricamento {get; set;}
        @AuraEnabled
        public Date dataTermineLavoro {get; set;}
		@AuraEnabled
        public Integer inizioDecade1 {get; set;}
		@AuraEnabled
        public Integer fineDecade1 {get; set;}
        @AuraEnabled
        public Date dataTermineScadenziarioDecade1 {get; set;}
		@AuraEnabled
        public Integer inizioDecade2 {get; set;}
		@AuraEnabled
        public Integer fineDecade2 {get; set;}
		@AuraEnabled
        public Date dataTermineScadenziarioDecade2 {get; set;}
		@AuraEnabled
        public Integer inizioDecade3 {get; set;}
		@AuraEnabled
        public Integer fineDecade3 {get; set;}
		@AuraEnabled
        public Date dataTermineScadenziarioDecade3 {get; set;}
    }  
}