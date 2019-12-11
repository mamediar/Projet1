@isTest
public class ConfirmLotReceiptControllerTest {
    @isTest static void testSetLotData(){
        Case c=new Case();
        SFALotto__c lot1=new SfaLotto__c();
        
        c.ActivityType__c='CONLOTREC';
        c.Note__c='TEST';
        insert c;
        
        lot1.CaseId__c=c.Id; lot1.Status__c='3'; lot1.OCSLottoId__c='TEST1';
        insert lot1;
        
        List<SFALotto__c> l=ConfirmLotReceiptController.setLotData();
        
        System.assert(l!=null);
        System.assert(l.size()==1);
    }
    
    @isTest static void testReceiveLot(){
        SFALotto__c lot1=new SfaLotto__c();
        lot1.Status__c='3'; lot1.OCSLottoId__c='TEST1';
        insert lot1;
        
        ConfirmLotReceiptController.receiveLot(lot1);
        
        lot1=[	select Status__c,DateReceivedIDM__c
             	from SFALotto__c
             	where OCSLottoId__c='TEST1'];
        System.assert(lot1!=null);
        System.assert(lot1.Status__c=='4');
        System.assert(lot1.DateReceivedIDM__c!=null);
    }
    
    @isTest static void testGenerateURL(){
        System.assertEquals('/apex/ConfirmLotReceiptEXCEL?filter=test', ConfirmLotReceiptController.generateURL('test'));
    }
    
    @isTest static void testCloseCase(){
        Case c=new Case();
        c.ActivityType__c='CONLOTREC';
        c.Status='New';
        c.Note__c='TEST';
        insert c;
        
        ConfirmLotReceiptController.closeCase();
        
        String status=[select id,Status from Case where ActivityType__c='CONLOTREC' and Note__c='TEST'].Status;
        
        System.assertEquals('Closed',status);
    }
}