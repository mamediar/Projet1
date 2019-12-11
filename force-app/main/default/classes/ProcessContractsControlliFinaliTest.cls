@isTest
public class ProcessContractsControlliFinaliTest 
{
	@testSetup
    static void setup(){
        SFALotto__c lotto1 = new SFALotto__c();
     	lotto1.Name = 'FILIALE';
        lotto1.BranchId__c = '700';
        insert lotto1;
        SFALotto__c lotto2 = new SFALotto__c();
     	lotto2.Name = 'OUTSOURCER';
        lotto2.BranchId__c = '800';
        insert lotto2;
        Account acc = new Account();
        acc.Name = 'FOSCOLO';
        insert acc;
        Contract con1 = new Contract();
        Contract con2 = new Contract();
        con1.SFALotto__c = lotto1.id;
        con1.AccountId = acc.Id;
        con1.ContractNumber__c = '000000000001';
        con1.FlagAccollo__c = 0;
        con1.Procedure__c = 'CO';
        con2.SFALotto__c = lotto1.id;
        con2.AccountId = acc.Id;
        con2.ContractNumber__c = '000000000002';
        con2.FlagAccollo__c = 1; 
        con2.Procedure__c = 'CO';
        insert con1 ;
        insert con2 ;
    }
    @isTest
    public static void testOutsourcer()
    {
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c='{"resultCode":0,"resultMessage":"Ok","ebavaradpv1Response":{"msfres_STATUS":"OK","mfterr_OMSFERR_OCCURS":[{"msferr_DESCRIZIONE":"4044","msferr_CODICE":"0"}],"msfologon_SESSION_ID":"788ec2e42093697fc3bcfaf45050f174"}}',Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ricerca.ocs.cambioStatoPratica',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
       	insert test1;
        test.startTest();
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname='ricerca.ocs.cambioStatoPratica';
        Test.setMock(HttpCalloutMock.class,UMR);
        List<ProcessContractsControlliFinali.Input> ListPCCF = new List<ProcessContractsControlliFinali.Input>();
        ProcessContractsControlliFinali.Input inp = new ProcessContractsControlliFinali.Input(); 
        inp.lotto = [select id,BranchId__c FROM SFALotto__c where Name = 'OUTSOURCER'];
        List<Contract> ListContract = [select Id,SFALotto__c,Barcode__c,FlagAccollo__c,AccountId,ContractNumber__c,Procedure__c from Contract where Procedure__c ='CO'] ;
        inp.contracts = ListContract ;
        ListPCCF.add(inp);
       	List<ProcessContractsControlliFinali.FlagControlli> LPCCFFlagControlli = ProcessContractsControlliFinali.ControlliFinali(ListPCCF);
      	test.stopTest();
    }
    @isTest
    public static void testFiliale()
    {
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c='{"resultCode":0,"resultMessage":"Ok","ebavaradpv1Response":{"msfres_STATUS":"KO","mfterr_OMSFERR_OCCURS":[{"msferr_DESCRIZIONE":"4044","msferr_CODICE":"0"}]}}',Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ricerca.ocs.cambioStatoPratica',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
       	insert test1;
        test.startTest();
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname='ricerca.ocs.cambioStatoPratica';
        Test.setMock(HttpCalloutMock.class,UMR);
        List<ProcessContractsControlliFinali.Input> ListPCCF = new List<ProcessContractsControlliFinali.Input>();
        ProcessContractsControlliFinali.Input inp = new ProcessContractsControlliFinali.Input(); 
        inp.lotto = [select id,BranchId__c FROM SFALotto__c where Name ='FILIALE'];
        List<Contract> ListContract = [select Id,SFALotto__c,FlagAccollo__c,Barcode__c,AccountId,ContractNumber__c,Procedure__c from Contract where Procedure__c ='CO'] ;
        inp.contracts = ListContract ;
        ListPCCF.add(inp);
       	List<ProcessContractsControlliFinali.FlagControlli> LPCCFFlagControlli = ProcessContractsControlliFinali.ControlliFinali(ListPCCF);
      	test.stopTest();

    }
    @isTest
    public static void testFilialeKO()
    {
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c='{"resultCode":0,"resultMessage":"Ok","ebavaradpv1Response":{"msfres_STATUS":"OK","mfterr_OMSFERR_OCCURS":[{"msferr_DESCRIZIONE":"4044","msferr_CODICE":"4044"}]}}',Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ricerca.ocs.cambioStatoPratica',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
       	insert test1;
        test.startTest();
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname='ricerca.ocs.cambioStatoPratica';
        Test.setMock(HttpCalloutMock.class,UMR);
        List<ProcessContractsControlliFinali.Input> ListPCCF = new List<ProcessContractsControlliFinali.Input>();
        ProcessContractsControlliFinali.Input inp = new ProcessContractsControlliFinali.Input(); 
        inp.lotto = [select id,BranchId__c FROM SFALotto__c where Name ='FILIALE'];
        List<Contract> ListContract = [select Id,SFALotto__c,FlagAccollo__c,Barcode__c,AccountId,ContractNumber__c,Procedure__c from Contract where Procedure__c ='CO'] ;
        inp.contracts = ListContract ;
        ListPCCF.add(inp);
       	List<ProcessContractsControlliFinali.FlagControlli> LPCCFFlagControlli = ProcessContractsControlliFinali.ControlliFinali(ListPCCF);
      	test.stopTest();

    }
}