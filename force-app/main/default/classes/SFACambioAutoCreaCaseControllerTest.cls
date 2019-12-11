@isTest
public class SFACambioAutoCreaCaseControllerTest {

   
    @testSetup
    public static void setUp(){     

            //Branch
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
            insert acc1;
      
        
    }
    
    
    @isTest
    public static void getAzioniFilialeSuDealerTest(){ 
        SFACambioAutoCreaCaseController.getAzioniFilialeSuDealer();
    }    

    @isTest
    public static void creaCaseTest(){ 
        
        Id dealerId = [SELECT Id, Name
                                   FROM Account 
                                   WHERE RecordType.Name = 'Dealer'][0].id;        
        String developerNameAzioneSelezionata=[SELECT Id, DeveloperName, QualifiedApiName, Label FROM AzioniFilialeSuDealer__mdt][0].DeveloperName;
        SFACambioAutoCreaCaseController.creaCase(dealerId,developerNameAzioneSelezionata);
    }     
    
}