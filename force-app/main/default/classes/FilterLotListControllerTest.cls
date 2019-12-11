@isTest
public class FilterLotListControllerTest {
   @isTest static void test0(){
        Case c=new Case();
        c.Note__c='TEST';
        insert c;
        
        SFALotto__c lot1=new SFALotto__c();
        SFALotto__c lot2=new SFALotto__c();
        lot1.CaseId__c=c.Id;
        lot2.CaseId__c=c.Id;
        insert lot1; insert lot2;
        
        List<SFALotto__C> l=FilterLotListController.getLotList(c.Id);
        
        System.assert(l!=null);
    }
    @isTest static void test1(){
        Case c=new Case();
        c.Note__c='TEST';
        insert c;
        
        SFALotto__c lot1=new SFALotto__c();
        SFALotto__c lot2=new SFALotto__c();
        lot1.CaseId__c=c.Id;
        lot2.CaseId__c=c.Id;
        insert lot1; insert lot2;
        
        List<SFALotto__C> l=FilterLotListController.getFilteredLotList(c.Id,'TODAY');
        
        System.assert(l!=null);
    }
    @isTest static void test2(){
        Case c=new Case();
        c.Note__c='TEST';
        insert c;
        
        SFALotto__c lot1=new SFALotto__c();
        SFALotto__c lot2=new SFALotto__c();
        lot1.CaseId__c=c.Id;
        lot2.CaseId__c=c.Id;
        insert lot1; insert lot2;
        
        List<SFALotto__C> l=FilterLotListController.getFilteredLotList(c.Id,'LAST_N_DAYS:7');
        
        System.assert(l!=null);
    }
    @isTest static void test3(){
        Case c=new Case();
        c.Note__c='TEST';
        insert c;
        
        SFALotto__c lot1=new SFALotto__c();
        SFALotto__c lot2=new SFALotto__c();
        lot1.CaseId__c=c.Id;
        lot2.CaseId__c=c.Id;
        insert lot1; insert lot2;
        
        List<SFALotto__C> l=FilterLotListController.getFilteredLotList(c.Id,'LAST_N_DAYS:30');
        
        System.assert(l!=null);
    }
    @isTest static void test4(){
        Case c=new Case();
        c.Note__c='TEST';
        insert c;
        
        SFALotto__c lot1=new SFALotto__c();
        SFALotto__c lot2=new SFALotto__c();
        lot1.CaseId__c=c.Id;
        lot2.CaseId__c=c.Id;
        insert lot1; insert lot2;
        
        List<SFALotto__C> l=FilterLotListController.getFilteredLotList(c.Id,'2018-11-13,2018-11-14');
        
        System.assert(l!=null);
    }
}