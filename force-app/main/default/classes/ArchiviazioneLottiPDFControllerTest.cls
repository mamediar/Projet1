@isTest
public class ArchiviazioneLottiPDFControllerTest {
    @testSetup static void setup(){
		Case c=new Case();
        Account a=new Account();
        SFALotto__c lot=new SFALotto__c();
        Contract con1=new Contract();
        Contract con2=new Contract();
        Contract con3=new Contract();
        
        a.Name='Test';
        insert a;
        
        lot.OCSLottoId__c='TESTLOT';
        lot.BranchId__c='TST';
        lot.ShippingDate__c=Date.today();
        insert lot;
        
        con1.Status='LI'; con1.SFALotto__c=lot.Id; con1.AccountId=a.Id;
        con2.Status='RF'; con2.SFALotto__c=lot.Id; con2.AccountId=a.Id;
        con3.Status='RT'; con3.SFALotto__c=lot.Id; con3.AccountId=a.Id;
        
        insert con1;
        insert con2;
        insert con3;
        
        c.SFALotto__c=lot.Id;
        insert c;        
    }
    
    @isTest static void testInit(){
        Case c=[select Id,SFALotto__c
               	from Case
               	where SFALotto__r.OCSLottoId__c='TESTLOT'];
        ApexPages.StandardController std=new ApexPages.StandardController(c);
        ArchiviazioneLottiPDFController ctrl=new ArchiviazioneLottiPDFController(std);
        
        ctrl.init();
        
        System.assert(ctrl.copyCounter.size()==2);
		System.assertEquals('TESTLOT00000001TST',ctrl.lotBarcode);
        System.assert(ctrl.idLiquidati.size()!=0);
        System.assert(ctrl.idResRitStor.size()!=0);
        System.assert(ctrl.liquidati==1);
        System.assert(ctrl.respintiRitiratiStornati==2);
        System.assert(ctrl.tot==3);
    }
    
    @isTest static void testShipDateNull(){
        SFALotto__c lot=[	select Id,ShippingDate__c
                        	from SFALotto__c
                        	where OCSLottoId__c='TESTLOT'];
        lot.ShippingDate__c=null;
        update lot;
        
        Case c=[select Id,SFALotto__c
               	from Case
               	where SFALotto__r.OCSLottoId__c='TESTLOT'];
        ApexPages.StandardController std=new ApexPages.StandardController(c);
        ArchiviazioneLottiPDFController ctrl=new ArchiviazioneLottiPDFController(std);
        
        ctrl.init();
        
        System.assert(ctrl.getShipDate()==' ');
    }
}