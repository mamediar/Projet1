public class FilterLotListController {
	@AuraEnabled
    public static SFALotto__c[] getLotList(String status){
        List<SFALotto__c> res= [	select OCSLottoId__c,LotBarcode__c,Status__c,DateReceivedIDM__c
                                    from SFALotto__c
                                    where Status__c=:status ORDER BY DateReceivedIDM__c desc];
        return res;
    }
    
    @AuraEnabled
    public static SFALotto__c[] getFilteredLotList(String status,String filter){
        List<SFALotto__c> res;
        if(filter.split(',').size()==1){
            if(filter.equals('TODAY')){
           		res=[select OCSLottoId__c,LotBarcode__c,Status__c,DateReceivedIDM__c
                    from SFALotto__c
                    where Status__c=:status and DateReceivedIDM__c= TODAY];
            }
            else if(filter.equals('LAST_N_DAYS:7')){
                res=[select OCSLottoId__c,LotBarcode__c,Status__c,DateReceivedIDM__c
                    from SFALotto__c
                    where Status__c=:status and DateReceivedIDM__c= LAST_N_DAYS:7];
            }
            else{
                res=[select OCSLottoId__c,LotBarcode__c,Status__c,DateReceivedIDM__c
                    from SFALotto__c
                    where Status__c=:status and DateReceivedIDM__c= LAST_N_DAYS:30];
            }
        }
        else{
            List<Date> dates=new List<Date>();
            for(String s:filter.split(',')){
                dates.add(Date.valueOf(s));
        	}
            res=[	select OCSLottoId__c,LotBarcode__c,Status__c,DateReceivedIDM__c
                    from SFALotto__c
                    where Status__c=:status and DateReceivedIDM__c>=:dates[0] and DateReceivedIDM__c<=:dates[1]];
        }
        
        return res;
    }
}