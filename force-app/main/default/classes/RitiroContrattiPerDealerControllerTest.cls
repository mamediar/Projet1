@isTest
public class RitiroContrattiPerDealerControllerTest {
    //Creo i dati che mi servono per il test
    @TestSetup static void setup() {
        Contract c1 = new Contract();
        Contract c2 = new Contract();
        Contract c3 = new Contract();
        
        Account acc = new Account();
        acc.Name='Stica';
        insert acc;
        
        Case c = new Case();
        c.AccountId = acc.Id;
        c.Status = 'New';
        insert c;
        
        c1.AccountId = acc.Id; c1.WorkStatus__c='402';
        c1.Case__c = c.Id; c1.ContractNumber__c='1'; c1.Procedure__c='CO';
        
        c2.AccountId = acc.Id; c2.WorkStatus__c='404';
        c2.Case__c = c.Id; c2.ContractNumber__c='2'; c2.Procedure__c='CO';
        
        c3.AccountId = acc.Id; c3.WorkStatus__c='403';
        c3.Case__c = c.Id; c3.ContractNumber__c='3'; c3.Procedure__c='CO';
        
        insert c1; insert c2; insert c3;
        
        Documento__c d1=new Documento__c();
        d1.Contract__c=c1.Id;d1.SituazioneDocumento__c='D';d1.CodiceDocumento__c='RIT';
        insert d1;
    }
    
    //Imposto il test per verificare che la mappa riporti i dati corretti
    @isTest static void testGetInfo() {
        Map<String,String> res = RitiroContrattiPerDealerController.getInfo([SELECT Id FROM Case WHERE Account.Name = 'Stica'].Id);
        system.assert(res.get('p').equals('1'));
    }
    
    @isTest static void testCloseCase() {
        system.assert(RitiroContrattiPerDealerController.closeCase([SELECT Id FROM Case WHERE Account.Name = 'Stica'].Id));
        
    }
    
    //Imposto il test perchè mi ritorni True se il caso non è Closed
    @isTest static void testCheckIfClosed() {
        system.assert(!RitiroContrattiPerDealerController.checkIfClosed([SELECT Id FROM Case WHERE Account.Name = 'Stica'].Id));
    }
    
    @isTest static void testCambioStatoDocumenti() {
        List<Contract> cList=[select Id from Contract where ContractNumber__c='1'];
        List<String> cListIds=new List<String>();
        for(Contract c:cList){
            cListIds.add(c.Id);
        }
        
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c='{"resultCode":0,"resultMessage":"Ok","errore":"OK"}',Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.modificaStatoDocumento',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
       	insert test1;
        test.startTest();
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname='ocs.modificaStatoDocumento';
        Test.setMock(HttpCalloutMock.class,UMR);
		List<ContractResult> res=RitiroContrattiPerDealerController.cambioStatoDocumenti(cListIds);
        System.assert(res.size()==1);
        
        test.stopTest();
    }
    
    @isTest static void testWriteNotes(){
        RitiroContrattiPerDealerController.writeNotes([select Id from Case where Status='New'].Id,'Test');
        System.assertEquals('Test',[select Note__c from Case where Status='New'].Note__c);
    }
    
    @isTest
    public static void testRitiraContratto () {
        Contract contr = [SELECT Id, WorkStatus__c FROM Contract WHERE ContractNumber__c='1'][0];
        RitiroContrattiPerDealerController.ritiraContratto(contr);
        System.assert(contr.WorkStatus__c=='403');
        
        List<Documento__c> doc = [SELECT Id, SituazioneDocumento__c FROM Documento__c WHERE Contract__c = :contr.Id];
            for (Documento__c docIt : doc){
                System.assert( docIt.SituazioneDocumento__c.equals('R'));
            }
        
        
        
    }
}