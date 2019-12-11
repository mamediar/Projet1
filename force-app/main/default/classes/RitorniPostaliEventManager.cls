public class RitorniPostaliEventManager {
    
    public static Boolean queryOpen (Case currentRPCase) {
        
        String strCaseID = currentRPCase.Id;
        //recupero via relazione inversa del record RitorniPostali__c collegato al Case
        List<RitorniPostali__c> ritorni = [Select PreviousLetterId__c from RitorniPostali__c where CasoCorrispondente__c = :strCaseID];
        
        return false;
    }

}