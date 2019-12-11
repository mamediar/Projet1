public class VenditaAssicurazioniController {   
    
    @TestVisible
    private class InitVariables{  
        @TestVisible @AuraEnabled private Account client {get; set;}
        @TestVisible @AuraEnabled private Boolean statusBadge {get; set;}
        @TestVisible @AuraEnabled private String textBadge {get; set;}  
        @TestVisible @AuraEnabled private String codCliente {get; set;}                 
        @TestVisible @AuraEnabled private Boolean isUserEnabled {get; set;}
        @TestVisible @AuraEnabled private UtilVariables utils {get; set;}
        @TestVisible @AuraEnabled private String formattedProfileName {get; set;}        
    }
    @TestVisible
    private class UtilVariables{
		@TestVisible @AuraEnabled private Boolean showVenditaProdottoContainer {get; set;}
        @TestVisible @AuraEnabled private MessageToShow message {get; set;}
        
        @TestVisible
        UtilVariables(){
            message = new MessageToShow();
        }
    }
    @TestVisible
    private class MessageToShow {                
        @TestVisible @AuraEnabled private String type {get; set;}
        @TestVisible @AuraEnabled private String title {get; set;}
        @TestVisible @AuraEnabled private String message {get; set;}
    }    
    
    @AuraEnabled
    public static InitVariables doInit(String caseId){
        InitVariables res = new InitVariables();
       
        Case currentCase = [SELECT AccountId, Account.getCodice_Cliente__c, Esito__c, PrivacyAccount__c FROM Case WHERE Id =: caseId];                   
        //String profileName = [SELECT Profile.Name FROM User WHERE Id =: UserInfo.getUserId()].Profile.Name;

        res.client = [SELECT FirstName, LastName FROM Account WHERE Id =: currentCase.AccountId];       
        res.statusBadge = ('Richiesta doppia'.equalsIgnoreCase(currentCase.Esito__c)) ? false : currentCase.PrivacyAccount__c;
        res.textBadge = ('Richiesta doppia'.equalsIgnoreCase(currentCase.Esito__c)) ? 'E\' già stata inserita una richiesta negli ultimi 30 giorni.' : 
        (currentCase.PrivacyAccount__c) ? 'Privacy OK' : 'Privacy KO';
        res.codCliente = currentCase.Account.getCodice_Cliente__c;
        res.isUserEnabled = PermissionUtils.isAbilitatoVendita();
        res.utils = processBehaviour(currentCase.Esito__c, res.isUserEnabled);  
        res.formattedProfileName = PermissionUtils.getPermissionName();      
        
        return res;
    }   
    
    @AuraEnabled
    public static UtilVariables goNext(String caseId, String interestValue, String dataPreferenceValue, Datetime schedulingDate, Boolean isUserEnabled, String note){                                       
        UtilVariables res = new UtilVariables();
        /*******MC 20190621 REMOVED because error in build********
        Group assignedQueue = null;
        Case currentCase = [SELECT Id FROM Case WHERE Id =: caseId];
        //String profileName = [SELECT Profile.Name from User WHERE Id =: UserInfo.getUserId()].Profile.Name;
        
        if('interessato'.equalsIgnoreCase(interestValue) ){
            if('schedula'.equalsIgnoreCase(dataPreferenceValue)){
                if(PermissionUtils.isNET()) assignedQueue = CaseUtils.assignToQueue(currentCase, 'Q313');
                else assignedQueue = CaseUtils.assignToQueue(currentCase, 'Q360');
            }            
            else if(!isUserEnabled)  assignedQueue = CaseUtils.assignToQueue(currentCase, 'Q360');                            
        }
        
        currentCase.Status = ('interessato'.equalsIgnoreCase(interestValue)) ? 'New' : 'Closed';
        currentCase.Esito__c = ('non_interessato'.equalsIgnoreCase(interestValue)) ? 'Non interessato' : 
        					   ('irreperibile'.equalsIgnoreCase(interestValue)) ? 'Irreperibile' : 
        					   ('interessato'.equalsIgnoreCase(interestValue)) ? ('Richiesta inserita' + ('schedula'.equalsIgnoreCase(dataPreferenceValue) ? ' con recall' : '')) : '';
        currentCase.RecallDate__c = ('interessato'.equalsIgnoreCase(interestValue) && 
            						'schedula'.equalsIgnoreCase(dataPreferenceValue)) ? schedulingDate : null;
        currentCase.Note__c = note;
        update currentCase;                  
		res = processBehaviour(currentCase.Esito__c, isUserEnabled); 
        res.message.type = 'success';
        res.message.title = 'Closed'.equalsIgnoreCase(currentCase.Status) ? 'Il caso è stato chiuso correttamente' : ('schedula'.equalsIgnoreCase(dataPreferenceValue)) ? 
        'La richiesta è stata inserita con data e ora di ricontatto' : (!isUserEnabled) ? ('Il caso è stato assegnato alla coda del call center ' + assignedQueue.Name) : 'Procedere con la parte di vendita';        
        res.message.message = ('schedula'.equalsIgnoreCase(dataPreferenceValue)) ? schedulingDate.format() : ' ';
******/
        return res;
    }
	    
    @AuraEnabled    
    public static UtilVariables processBehaviour(String outcome, Boolean isUserEnabled){
        UtilVariables res = new UtilVariables();
        
        res.showVenditaProdottoContainer = (('Richiesta inserita'.equalsIgnoreCase(outcome) || 'Richiesta inserita con recall'.equalsIgnoreCase(outcome) ||'Inviata doc precontrattuale'.equalsIgnoreCase(outcome)) &&
            									 isUserEnabled); 
        
        return res;
    }        
  

}