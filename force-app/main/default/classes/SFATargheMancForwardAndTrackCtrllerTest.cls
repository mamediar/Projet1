@isTest
public class SFATargheMancForwardAndTrackCtrllerTest {

   
    @testSetup
    public static void setUp(){     

            Case c = new Case();
            insert c; 
        
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
        	insert t;
        
            /*//Branch
            Account branch1 = new Account();
            String idRecordTypeBranch = [Select id from RecordType where name = 'Branch'][0].id;
            branch1.RecordTypeId = idRecordTypeBranch;
            branch1.name = 'BranchDiProva'; 
            branch1.BusinessEmail__c='khadija.masrour@lynxspa.com';
            branch1.OCS_External_Id__c = 'F32';		        
            insert branch1;     
                    
            
            //Dealer 1 associated to branch1
            Account acc1 = new Account();
            String idRecordTypeDealer = [Select id from RecordType where name = 'Dealer'][0].id;
            acc1.RecordTypeId = idRecordTypeDealer;
            acc1.name = 'DealerDiProva';   
            acc1.OCS_External_Id__c = 'D123';
            acc1.Branch__r=branch1;
            insert acc1;*/

            string z =[select id from RecordType where Name = 'Person Account'][0].id;
            Account a2 = new Account();
            a2.LastName = 'Dummy';
            a2.FirstName = 'Dummy';
            a2.BusinessEmail__c = 'khadija.masrour@prova.it';
            a2.RecordTypeId = z;
        	a2.OCS_External_Id__c = 'N00000';
            insert a2;        
        
            
            XCS_CompassParameters__c obj = new XCS_CompassParameters__c();
            obj.Name = 'gdv.mail';
            obj.Value__c ='khadija@prtova.it';
            insert obj;  
            
            XCS_CompassParameters__c obj1 = new XCS_CompassParameters__c();
            obj1.Name = 'agenziaitalia.mail';
            obj1.Value__c ='khadija@prova.it';
            insert obj1;         
            
            /*Folder[] folders = [select Id from Folder 
                                where AccessType IN: new list<String>{'Shared','Public'} 
                                AND Type = 'Email'];
            System.assert(!folders.isEmpty(),'test can\'t run wo Email Template folders. Folders can\'t be mocked in Apex');*/        
        
    }
    
    
    @isTest
    public static void getEsitiTest(){ 
        SFATargheMancantiForwardAndTrackCtrller.getEsiti();
    }  
    
    @isTest
    public static void getPraticaTest(){ 
        String praticaId=[SELECT Id FROM SFATargaMancante__c][0].id;
        SFATargheMancantiForwardAndTrackCtrller.getPratica(praticaId);
    }    

    @isTest
    public static void updatePraticaTest(){ 
        String praticaId=[SELECT Id FROM SFATargaMancante__c][0].id;
        SFATargheMancantiForwardAndTrackCtrller.updatePratica(praticaId,'esito','nota');
    }
        
    /*@isTest
    public static void creaCaseTest(){ 
        
        Id dealerId = [SELECT Id, Name
                                   FROM Account 
                                   WHERE RecordType.Name = 'Dealer'][0].id;        
        String developerNameAzioneSelezionata=[SELECT Id, DeveloperName, QualifiedApiName, Label FROM AzioniFilialeSuDealer__mdt][0].DeveloperName;
        SFACambioAutoCreaCaseController.creaCase(dealerId,developerNameAzioneSelezionata);
    }*/     
    
}