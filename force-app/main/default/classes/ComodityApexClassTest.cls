@isTest
public with sharing class ComodityApexClassTest {
    
    @testSetup
    static void setup(){
        Account testComFiliale= new Account(Name='test account', 
                                            OCS_External_Id__c='ocs test',
                                            COM_NumeroTotali_Pratiche__c='10',
                                            COM_PraticheChiuse_Conforme__c='5',
                                            COM_ChiusoNon_Conforme__c='2',
                                            RecordtypeId = getAccountRecordTypeId());
        insert testComFiliale;
        Account PersonAccount= new Account( FirstName='FirstName',RecordtypeId = getPAccountRecordTypeId(),
                                            LastName='LastName'
                                            );
        insert PersonAccount;
        COM_Intervista__c testObject=new COM_Intervista__c(COM_MD_Filiale__c=testComFiliale.Id,
                                                           COM_Stato_Avanzamento_Intervista__c='Nuovo',
                                                           COM_Intervista_Non_Utile__c=true,
                                                           COM_Current_Period_Filiale__c=true,
                                                           Com_Current_Period_Assicurativo__c=true,
                                                           Name='000001',COM_C_Serv1__c='AB01',
                                                           COM_C_Serv2__c='AB02',COM_C_serv3__c='AB03',
                                                           COM_C_serv4__c='AB04',COM_C_serv5__c='AB05',
                                                           COM_NomeCliente__c = PersonAccount.Id,COM_C_prod__c='EV');
        insert testObject;
        system.debug('17/09/2019 tesObject::::'+testObject.COM_NomeCliente__r.FirstName);
        COM_CRMComodity_Check_Asc_Desc__c comCrmCommodity= new COM_CRMComodity_Check_Asc_Desc__c(COM_CRMTipo__c='CREDITOR PROTECTION',
                                                                COM_CRMDefinizione__c='Polizza a copertura del credito - contratta con Metlife',
                                                                COM_CRMflag_prod_sani_non_conn__c='test flag post sani',
                                                                Descrizione__c='Test descrizione',
                                                                COM_CRMTermini_Recesso__c='test Termini recesso',
                                                                COM_CRMEstinzione__c='test estinzione',
                                                                Name = 'AIIB2');
        insert comCrmCommodity;
    
        COM_Comodity_Questionario__c CSInstance = new COM_Comodity_Questionario__c(Name='1F',Filiale_Domanda__c='1F',COM_Limite_Cin_Z__c='20');
        insert CSInstance;
    
    
    }
    static Id getAccountRecordTypeId() 
    {
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Branch').getRecordTypeId();
        return RecordTypeId;
    }
    static Id getPAccountRecordTypeId()
    {
        Id recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        return recordTypeId;
    }
    
    static testMethod void testGetAllFiliale(){
        List<Account> accounts= ComodityApexClass.getAllFiliale();
        System.debug('la liste: '+accounts);
        System.assert(accounts.size()>0);
        
    }
    
    static testMethod void testExecQueryFiltered(){
        Test.startTest();
        List<Account> accounts= ComodityApexClass.execQueryFiltered('test account','ocs test','10','5','2');
        Test.stopTest();
        //System.assert(accounts.size()>0);
        
    }
    
    static testMethod void testGetAllInterviews(){
        /*
        COM_Comodity_Questionario__c CSInstance = new COM_Comodity_Questionario__c(Name='1F',Filiale_Domanda__c='1F',COM_Limite_Cin_Z__c='20');
        insert CSInstance;*/
        Test.startTest(); 
        List<COM_Intervista__c> interviews= ComodityApexClass.getAllInterviews();
        List<COM_Intervista__c> interviewsRichiamare= ComodityApexClass.getAllInterviewDaRichiamare();
        List<COM_Intervista__c> interviewsWithoutFilter= ComodityApexClass.getAllInterviewsWithoutFilter();
        
        Test.stopTest();
        
    } 
    
    
    /*static testMethod void testGetAllInterviewsOrderBy(){
        Test.startTest();
        List<COM_Intervista__c> interviews= ComodityApexClass.getAllInterviewsOrderBy('COM_NomeCliente__c','desc');
        Test.stopTest();
        
    }*/
    static testMethod void testExecQueryFilteredEmpty(){
        Test.startTest();
        List<Account> accounts= ComodityApexClass.execQueryFiltered('FilialeName','001','10','7','3');
        Test.stopTest();
        //System.assert(accounts.size()>0);
        
    }
    
    static testMethod void testExecQueryFilteredPratiche(){
        Test.startTest();
        List<COM_Intervista__c> ListInt = [ SELECT Id , COM_NomeCliente__r.Name , COM_NomeCliente__c ,
                                                   COM_Current_Period_Filiale__c , COM_Stato_Avanzamento_Intervista__c , 
                                                   COM_MD_Filiale__r.Name , COM_CRMRichiamare_il__c
                             FROM COM_Intervista__c ];
        
                           
        system.debug('-->'+  ListInt[0].COM_NomeCliente__r.Name);
        List<COM_Intervista__c> Intervist= ComodityApexClass.execQueryFilteredPratiche('test account',ListInt[0].COM_NomeCliente__r.Name);
                //System.assert(!(Intervist.size()>0));

        Test.stopTest();
        
    }
    
    static testMethod void testExecQueryFilteredPraticheNotEmpty(){
        
        Test.startTest();
        
        List<COM_Intervista__c> Intervist= ComodityApexClass.execQueryFilteredPratiche('test account',''); 
        ComodityApexClass.getAllInterviewsOrderBy('COM_Stato_Avanzamento_Intervista__c','ASC');
        ComodityApexClass.getAllInterviewsOrderBy('COM_CRMRichiamare_il__c','ASC');
        ComodityApexClass.getInterviewTuttiContatti();
        ComodityApexClass.getAllInterviewsForAssicurativos();
        ComodityApexClass.getPraticheFiltrate('NN');
        ID FilialeID = [SELECT ID FROM ACCOUNT WHERE RecordtypeId =: getPAccountRecordTypeId()].Id;
        
        ComodityApexClass.getSUMProdottoEV(FilialeID,'EV');
        ComodityApexClass.getSUMProdottoEVInProgress(FilialeID,'EV');
        Test.stopTest();
        System.assert(Intervist.size()>0);
        
    }
    
    static testMethod void testGetDettagliIntervista(){
        COM_Intervista__c interview=[select Id FROM COM_Intervista__c Limit 1];
        Test.startTest();
        COM_Intervista__c intervista= ComodityApexClass.getDettagliIntervista(''+interview.Id);
        Test.stopTest();
    }
    
    static testMethod void testGetassicurativoDetail(){
        COM_Intervista__c interview=[select Id FROM COM_Intervista__c Limit 1];
        Test.startTest();
        COM_Intervista__c intervista= ComodityApexClass.getassicurativoDetail(''+interview.Id);
        Test.stopTest();
    }
    
    static testMethod void testGetRisposta(){
        COM_Intervista__c interview=[select Id FROM COM_Intervista__c Limit 1];
        Test.startTest();
        Risposte__c risposte1= ComodityApexClass.getRisposta(''+interview.Id);
        Test.stopTest();
    }
    
    
    static testMethod void testGetRispostaAssicurativo(){
        COM_Intervista__c interview=[select Id FROM COM_Intervista__c Limit 1];
        Test.startTest();
        Risposte__c risposte1= ComodityApexClass.getRispostaAssicurativo(''+interview.Id);
        Test.stopTest();
    }
    
     static testMethod void testGetCommodityCheck(){
        Test.startTest();
        COM_Intervista__c interview=[SELECT Id,
                                            COM_C_Serv1__c,
                                            COM_C_Serv2__c,
                                            COM_C_serv3__c,
                                            COM_C_serv4__c,
                                            COM_C_serv5__c 
                                     FROM COM_Intervista__c Limit 1];
        Map<String,Object>  crmCommodity= ComodityApexClass.getCommodityCheck(interview);
        Test.stopTest();
    }
    
    static testMethod void testUpdateIntervista(){
        Account acc=new Account(Name='test');
        Test.startTest();
        SObject result= ComodityApexClass.updateIntervista(acc);
        Test.stopTest();
    }
    
    static testMethod void testAddResponseAssicurativo(){
        Risposte__c rispost=new Risposte__c();
        Test.startTest();
        Risposte__c risposte= ComodityApexClass.addResponseAssicurativo(rispost);
        Test.stopTest();
    }
    
}