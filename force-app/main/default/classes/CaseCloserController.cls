public class CaseCloserController {
    @AuraEnabled
    public static Boolean isClose(String caseId){
        return CaseUtils.checkStatus(caseId, 'Closed');
    }

	@AuraEnabled
    public static Boolean closeCase(string caseId, Boolean flagAttach){ 
        System.debug('closeCase start');
        Boolean res = false;
        if(flagAttach && !CompassUtils.isThereAttach(caseId)) return res;
        else{
            CaseUtils.closeCase(caseId);
            res = true;
        }
        System.debug('closeCase end');
        return res;
    }
    
}