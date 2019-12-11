public class SFALottoUtils {
	@AuraEnabled
    public static SFALotto__c receiveLot(SFALotto__c lot){
        lot.Status__c='4';
        lot.DateReceivedIDM__c=Date.today();
        update lot;
        return lot;
    }
}