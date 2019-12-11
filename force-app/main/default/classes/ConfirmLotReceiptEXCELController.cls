public class ConfirmLotReceiptEXCELController {
    private final static List<String> MONTHS=new List<String>{'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'};
    public SFALotto__c[] lotList {get;set;}
    public String filter {get;set;}
    
    
    
    public void init(){
        Date today=Date.today();
        this.filter=ApexPages.currentPage().getParameters().get('filter');
        String[] temp=filter.split(',');
        if(temp.size()==2){
            List<Date> dates=new List<Date>();
            for(String s:temp){
                dates.add(Date.valueOf(s));
        	}
            this.lotList=[	select ocslottoid__c,branchid__c,DateReceivedIDM__c
                            from SFALotto__c
                            where Status__c='4' and DateReceivedIDM__c>=:dates[0] and DateReceivedIDM__c<=:dates[1]];
        }
        else if(filter.equals('TODAY')){
            this.lotList=[	select ocslottoid__c,branchid__c,DateReceivedIDM__c
                            from SFALotto__c
                            where Status__c='4' and DateReceivedIDM__c=TODAY];
        }
        else if(filter.equals('LAST_N_DAYS:7')){
            this.lotList=[	select ocslottoid__c,branchid__c,DateReceivedIDM__c
                            from SFALotto__c
                            where Status__c='4' and DateReceivedIDM__c=LAST_N_DAYS:7];
        }
        else{
            this.lotList=[	select ocslottoid__c,branchid__c,DateReceivedIDM__c
                            from SFALotto__c
                            where Status__c='4' and DateReceivedIDM__c=LAST_N_DAYS:30];
        }
    }
}