@isTest
public class InvioLottiControllerTest {
    @isTest static void testSetData(){
        Case c=new Case();
        SFALotto__c lot1=new SfaLotto__c();
        SFALotto__c lot2=new SfaLotto__c();
        SFALotto__c lot3=new SfaLotto__c();
        
        insert c;
        
        lot1.CaseId__c=c.Id;
        lot2.CaseId__c=c.Id;
        lot3.CaseId__c=c.Id;
        
        insert lot1;
        insert lot2;
        insert lot3;
        
        List<SFALotto__c> l=InvioLottiController.setTableLotData(c.Id);
        
        System.assert(l!=null);
        System.assert(l.size()==3);
    }
}