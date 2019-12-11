@isTest
public class OCSRientroDocumentiPraticaInvokerTest {
    @isTest static void test(){
        Account a=new Account();
        a.Name='TEST';
        insert a;
        
        List<Contract> contracts=new List<Contract>();
        
        Contract c1=new Contract();
        c1.ContractNumber__c='176347';c1.Procedure__c='CO';c1.AccountId=a.id;
        insert c1;
        Documento__c d1=new Documento__c();d1.SituazioneDocumento__c='D';d1.CodiceDocumento__c='RID';d1.Contract__c=c1.Id;
        Documento__c d2=new Documento__c();d2.SituazioneDocumento__c='D';d2.CodiceDocumento__c='RID';d2.Contract__c=c1.Id;
        insert d1;
        insert d2;
        
        Contract c2=new Contract();
        c2.ContractNumber__c='1766347';c2.Procedure__c='CO';c2.AccountId=a.id;
        insert c2;
        Documento__c d3=new Documento__c();d3.SituazioneDocumento__c='D';d3.CodiceDocumento__c='RID';d3.Contract__c=c2.Id;
        Documento__c d4=new Documento__c();d4.SituazioneDocumento__c='D';d4.CodiceDocumento__c='RID';d4.Contract__c=c2.Id;
        insert d3;
        insert d4;
        
        Contract c3=new Contract();
        c3.ContractNumber__c='17447';c3.Procedure__c='CO';c3.AccountId=a.id;
        insert c3;
        Documento__c d5=new Documento__c();d5.SituazioneDocumento__c='D';d5.CodiceDocumento__c='RID';d5.Contract__c=c3.Id;
        Documento__c d6=new Documento__c();d6.SituazioneDocumento__c='D';d6.CodiceDocumento__c='RID';d6.Contract__c=c3.Id;
        insert d5;
        insert d6;
        
        contracts.add(c1);
        contracts.add(c2);
        contracts.add(c3);
        
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c='{"resultCode":0,"resultMessage":"Ok","errore":"OK"}',Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.modificaStatoDocumento',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
       	insert test1;
        test.startTest();
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname='ocs.modificaStatoDocumento';
        Test.setMock(HttpCalloutMock.class,UMR);
		OCSRientroDocumentiPraticaInvoker.cambioStatoDocumenti(contracts);
        test.stopTest();
    }
}