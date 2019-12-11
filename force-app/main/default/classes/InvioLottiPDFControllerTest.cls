@isTest
public class InvioLottiPDFControllerTest {
    @testSetup static void setup(){
        Case c=new Case();
        Account a=new Account();
        SFALotto__c lot1=new SfaLotto__c();
        SFALotto__c lot2=new SfaLotto__c();
        SFALotto__c lot3=new SfaLotto__c();
        
        a.Name='idm group';
        insert a;
        
        c.ActivityType__c='INVLOT';
        c.Note__c='TEST';
        insert c;
        
        lot1.CaseId__c=c.Id; lot1.Status__c='3'; lot1.OCSLottoId__c='TEST1';
        lot2.CaseId__c=c.Id; lot2.Status__c='3'; lot2.OCSLottoId__c='TEST2';
        lot3.CaseId__c=c.Id; lot3.Status__c='4'; lot3.OCSLottoId__c='TEST3';
        
        insert lot1;
        insert lot2;
        insert lot3;
    }
    
    @isTest static void testInit(){
        Case c=[select Id
               	from Case
               	where ActivityType__c='INVLOT' and Note__c='TEST'];
        InvioLottiPDFController ctrl=new InvioLottiPDFController(new ApexPages.StandardController(c));
        ctrl.init();
        
        System.assert(ctrl.copyCounter.size()==2);
        System.assert(ctrl.idsOCSLotti!=null);
        System.assert(ctrl.nOfBoxes==2);
        System.assert(ctrl.shipDate!=null);
        System.assert(ctrl.idm!=null);
    }
}