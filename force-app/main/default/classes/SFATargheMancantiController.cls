public class SFATargheMancantiController {
    
    @AuraEnabled
    public static DatiCase insertFile(String fileContents, String fileName, String fileExtension, String dataScadenzaString) {
        
        try {
            Date dataScadenza = Date.valueOf(dataScadenzaString);
            Id fileId = CompassUtils.fileNewInstance(fileContents, fileName, fileExtension);
            DatiCase datiCase = createCases(fileId, dataScadenza);
            return datiCase;
            
        } catch (Exception ex) {
            System.debug('Il file non è stato inserito');
            System.debug('Eccezione: ' + ex);
            return null;
        }
        
    }
    
    @AuraEnabled
    public static DatiCase createCases(String fileId, Date dataScadenza) {
        
        Case case1 = new Case();
        case1.ActivityType__c = 'SFA_TARMANPARENT';
        case1.Subject = 'Elaborazione Targhe Mancanti';
        case1.Status = 'Pending';
        case1.dataTermineLavoro__c = dataScadenza;
        
        insert case1;
        
        DatiCase datiCase = new DatiCase();
        
        datiCase.caseNumber = [SELECT Id, CaseNumber FROM Case WHERE Id = :case1.Id][0].CaseNumber;
        datiCase.caseId = case1.Id;
        
        CompassUtils.attachFile(fileId, case1.Id);
        
        SFA_TargheMancanti_CreazionePratiche sfa_tm_cp = new SFA_TargheMancanti_CreazionePratiche(fileId, case1.Id, dataScadenza);
        Id jobId = System.enqueueJob(sfa_tm_cp);
        
        return datiCase;
        
    }
    
    @AuraEnabled
    public static DatiCase checkLoadingStatus() {
        
        List<Case> lstCase = [
            SELECT Id, Status, CaseNumber, CreatedDate, Description
            FROM Case 
            WHERE ActivityType__c = 'SFA_TARMANPARENT'
            ORDER BY CreatedDate DESC
        ];
        
        if (lstCase.size() > 0) {
            DatiCase datiCase = new DatiCase();
            datiCase.caseNumber = lstCase[0].CaseNumber;
            datiCase.caseId = lstCase[0].Id;
            datiCase.caseStatus = lstCase[0].Status;
            datiCase.caseDescription = lstCase[0].Description;
            
            return datiCase;
        }
        else
            return null;
    }

    @AuraEnabled
	public static Boolean chiudiCasoConErrore(String caseId) {	
        
		try {

            Case case1 = [SELECT Id, Status FROM Case WHERE Id = :caseId AND activitytype__c='SFA_TARMANPARENT'][0];
            case1.Status='Errore nella creazione dell\'attività';
            update case1;
            return true;
			
		} catch (Exception ex) {
			System.debug('Eccezione: ' + ex);
			return false;
		}

	}  
    
    public class DatiCase {
        @AuraEnabled
        public String caseNumber {get; set;}
        @AuraEnabled
        public String caseId {get; set;}
        @AuraEnabled
        public String caseStatus {get; set;}
        @AuraEnabled
        public String caseDescription {get; set;}
    } 
}