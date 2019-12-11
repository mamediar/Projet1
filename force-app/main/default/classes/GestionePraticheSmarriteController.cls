//BackUp No.13
public class GestionePraticheSmarriteController {
    
    @AuraEnabled
    public static List<Contract> selectContract(String caseId, Boolean isAccollo){
        List<Contract> res = new List<Contract>();
        if(String.isNotBlank(caseId)){
            String query = 'SELECT Id, WorkStatus__c,WorkStatusFormula__c,ContractNumber__c, AccountName__c,StartDate ' +
                'FROM Contract ' +
                'WHERE WorkStatus__c in (\'404\',\'400\',\'3\') ' +
                'AND isAccollo__c = ' + isAccollo + ' ' +
                'AND Case__c =\''+ String.escapeSingleQuotes(caseId) +'\'';
            res = Database.query(query);
        }
        return res;
    }
    
    @AuraEnabled
    public static Boolean updateStatus(String statusName, List<Contract> contractSelected){
        Boolean res = false;
        if(String.isNotBlank(statusName) && !contractSelected.isEmpty()){
            for(Contract c : contractSelected)
                c.WorkStatus__c = (statusName.equalsIgnoreCase('Trovato')) ? '400' : statusName.equalsIgnoreCase('Smarrito') ? '3' : c.WorkStatus__c;
            
            update contractSelected;
            res = true;
        }
        return res;
    }
    
    @AuraEnabled
    public static void closeCaseApex(String caseId){
        CaseUtils.closeCase(caseId);
    }
    
    @AuraEnabled
    public static Boolean closeCaseIf(List<Contract> contractList, String value, String caseId, String note){
        Boolean res = false;
        // La lista a questo punto è perfoza popolata, ma la prudenza non è mai troppa.
        if(!contractList.isEmpty() && !value.equals(null)){
            for(Contract c : contractList) if(c.WorkStatus__c == value) return res;
            //Giunto a questo punto è possibile chiudere il case dato che non esistono pratiche mancanti
            Case caseToClose = [select Id, Status, Note__c from Case where Id =: caseId];
            caseToClose.Status = 'Closed';
            caseToClose.Note__c = note;
            update caseToClose;
            System.debug(caseToClose);
            
            res = true;
        }
        return res;
    }
}