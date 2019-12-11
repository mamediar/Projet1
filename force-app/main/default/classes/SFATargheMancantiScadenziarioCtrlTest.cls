@isTest
public class SFATargheMancantiScadenziarioCtrlTest {
    
    @isTest
    public static void initTest(){
        Case c = new Case();
        insert c;
        
        SFAConfigurazioneDecadeTargheMancanti__c uno = new SFAConfigurazioneDecadeTargheMancanti__c();
        uno.IdElaborazione__c = c.id;
        SFAConfigurazioneDecadeTargheMancanti__c due = new SFAConfigurazioneDecadeTargheMancanti__c();
        due.IdElaborazione__c = c.id;
        SFAConfigurazioneDecadeTargheMancanti__c tre = new SFAConfigurazioneDecadeTargheMancanti__c();
        tre.IdElaborazione__c = c.id;
        
        insert uno;
        insert due;
        insert tre;
        
        SFATargheMancantiScadenziarioController.init(c.id);
    }
    @isTest
    public static void updateScadenzeTest(){
        Case c = new Case();
        insert c;
        
        String data_uno = '2019-03-03';
        String data_due = '2019-04-09';
        String data_tre = '2020-10-12';
        
        SFAConfigurazioneDecadeTargheMancanti__c uno = new SFAConfigurazioneDecadeTargheMancanti__c();
        uno.IdElaborazione__c = c.id;        
        SFAConfigurazioneDecadeTargheMancanti__c due = new SFAConfigurazioneDecadeTargheMancanti__c();
        due.IdElaborazione__c = c.id;     
        SFAConfigurazioneDecadeTargheMancanti__c tre = new SFAConfigurazioneDecadeTargheMancanti__c();
        tre.IdElaborazione__c = c.id;
        
        insert uno;
        insert due;
        insert tre;
        
        SFATargaMancante__c t = new SFATargaMancante__c();
        t.IdElaborazione__c = c.id;       
        Date oggi = date.today();        
        t.DataLiquidazione__c = oggi;
        t.ActivityId__c = 12345;
        t.CodiceCliente__c = '1234';
        t.OcsCode__c = 'd';
        t.RagioneSociale__c = 'ad';
        t.Dipendenza__c = 'dip';
        t.NumeroPratica__c = '564';
        t.IdUploadList__c = 11;
        
        SFATargaMancante__c t2 = new SFATargaMancante__c();
        t2.IdElaborazione__c = c.id;       
        Date oggi2 = date.today().addDays(10);    
        t2.DataLiquidazione__c = oggi2;
        t2.ActivityId__c = 123445;
        t2.CodiceCliente__c = '12234';
        t2.OcsCode__c = 'de';
        t2.RagioneSociale__c = 'ead';
        t2.Dipendenza__c = 'dipr';
        t2.NumeroPratica__c = '5r64';
        t2.IdUploadList__c = 112;
        
        SFATargaMancante__c t3 = new SFATargaMancante__c();
        t3.IdElaborazione__c = c.id;       
        Date oggi3 = date.today().addDays(20);    
        t3.DataLiquidazione__c = oggi3;
        t3.ActivityId__c = 1123445;
        t3.CodiceCliente__c = '112234';
        t3.OcsCode__c = '1de';
        t3.RagioneSociale__c = '1ead';
        t3.Dipendenza__c = '1dipr';
        t3.NumeroPratica__c = '15r64';
        t3.IdUploadList__c = 1112;
        
        insert t;
        insert t2;
        insert t3;
        
        SFATargheMancantiScadenziarioController.updateScadenze(c.id,1,2,data_uno,3,4,data_due,5,6,data_tre);
    }  
}