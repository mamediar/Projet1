@isTest
public class ConfirmLotReceiptEXCELControllerTest {
    @testSetup static void setup(){
        Case c=new Case();
        SFALotto__c lot1=new SFALotto__c();
        SFALotto__c lot2=new SFALotto__c();
        SFALotto__c lot3=new SFALotto__c();
        
        c.Note__c='TEST';
        insert c;
        
        lot1.CaseId__c=c.Id; lot1.OCSLottoId__c='TEST1'; lot1.BranchId__c='TST'; 
        lot1.DateReceivedIDM__c=Date.today(); lot1.Status__c='4';
        
        lot2.CaseId__c=c.Id; lot2.OCSLottoId__c='TEST2'; lot2.BranchId__c='TST'; 
        lot2.DateReceivedIDM__c=Date.today();lot2.Status__c='3';
        
        lot3.CaseId__c=c.Id; lot3.OCSLottoId__c='TEST3'; lot3.BranchId__c='TST'; 
        lot3.DateReceivedIDM__c=null;lot3.Status__c='4';
        
        insert lot1;
        insert lot2;
        insert lot3;
    }
    
    @isTest static void testInit(){
        PageReference pr=Page.ConfirmLotReceiptEXCEL;
        Test.setCurrentPage(pr);
        List<String> filters=new List<String>{'TODAY','LAST_N_DAYS:7','LAST_N_DAYS:30','2018-10-3,2018-11-10'};
        for(String f:filters){
            pr.getParameters().put('filter',f);
        
            ConfirmLotReceiptEXCELController ctrl=new ConfirmLotReceiptEXCELController();
            
            ctrl.init();
            System.assert(ctrl.lotList!=null);
            //System.assert(ctrl.lotList.size()==1);
        }
    }
}