public class CRMReclamiInserimentoMittentiFilUffCtrl {
	@AuraEnabled
    public static List<mittenti__mdt> getMittenti(String societa){
        List<mittenti__mdt> res=[select DeveloperName,Email__c,First_Name__c,Last_Name__c
                                from mittenti__mdt
                                where Societa__c=:societa];
        return res;
    }
    
    @AuraEnabled
    public static XCS_Mittente__c makeMittente(mittenti__mdt m){
        return XCS_MittenteUtils.makeMittente(m);
    } 
     @AuraEnabled
    public static XCS_Mittente__c makeMittentePrincipale(mittenti__mdt m){
        return XCS_MittenteUtils.makeMittentePrincipale(m);
    } 
}