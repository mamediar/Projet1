/**
 * @File Name          : Gua_ManageUnitaAffariQueryTest.cls
 * @Description        : 
 * @Author             : Mame Bousso kane
 * @CreatedDate        : 09/09/2019
**/
@isTest
public class Gua_ManageUnitaAffariQueryTest {

    @testSetup 
    static void testSetup() {
        Date myDate = Date.newInstance(1960, 2, 17);
        Id recordTypeBranch=CGMWSUtils_1_0.getRecordTypeId('Account','Branch');
        Id recordTypeDealer=CGMWSUtils_1_0.getRecordTypeId('Account','Dealer');
        Account branch = new Account(Name='name', RecordTypeId=recordTypeBranch);
        insert branch;
        Account dealer = new Account(Name='name', RecordTypeId=recordTypeDealer);
        insert dealer;
        System.debug('#l acc '+ JSON.serialize(branch));
        
        Campaign cp = new Campaign( name ='name');
        insert cp;
        Contact ct = new Contact( LastName ='lastname');
        insert ct;
        Id recordType=CGMWSUtils_1_0.getRecordTypeId('Case','GUA_Contact');
        User us = [select id from User limit 1];
        Case cs = new Case( Scadenza__c = myDate, Priority ='Medium', Assegnatario__c = us.id,
                           Status ='Chiuso', Esito__c = 'dddddd',UAF_DatiAggiuntiviFile__c='dddddddsdfsfq', 
                           CampaignId__c = cp.Id, ContactId = ct.Id,  Dealer__c = dealer.id,Branch__c = branch.id);
        insert cs;
        //Group grp= new Group(Name='Affari e Delibere 1',Type='Queue',DeveloperName='Q281');
       // insert grp;
       
    }
    
    @isTest
    public static void getAccountTest(){
        List<Account> accounts = Gua_ManageUnitaAffariQuery.getAccount();
    }
    
    @isTest
    public static void getQueusTest(){
        List<Group> queus = Gua_ManageUnitaAffariQuery.getQueus();
    }
    
    @isTest
    public static void getContactsCaseByQueueTest(){
        Group gr = [SELECT Id, Name, Type, LastModifiedById, DeveloperName FROM Group where Type like 'Queue' and 
                     		(DeveloperName='Q281' or DeveloperName='Q285' 
                             or DeveloperName ='Q286' or DeveloperName='Q287') limit 1];
        
        List<Case> cs = Gua_ManageUnitaAffariQuery.getContactsCaseByQueue(gr,'10','1');
        //System.assertEquals(1,cs.size());
    }
    @isTest
    public static void filterCaseByCampagna1Test(){
        Group gr = [SELECT Id, Name, Type, LastModifiedById, DeveloperName FROM Group where Type like 'Queue' and 
                     		(DeveloperName='Q281' or DeveloperName='Q285' 
                             or DeveloperName ='Q286' or DeveloperName='Q287') limit 1];
        List<Case> cs = Gua_ManageUnitaAffariQuery.filterCaseByCampagna(gr,'name','Scadenza');
        //System.assertEquals(1,cs.size());
    }
    @isTest
    public static void filterCaseByCampagna2Test(){
        Group gr = [SELECT Id, Name, Type, LastModifiedById, DeveloperName FROM Group where Type like 'Queue' and 
                     		(DeveloperName='Q281' or DeveloperName='Q285' 
                             or DeveloperName ='Q286' or DeveloperName='Q287') limit 1];
        List<Case> cs = Gua_ManageUnitaAffariQuery.filterCaseByCampagna(gr,'name','Numero tentativi');
        //System.assertEquals(1,cs.size());
    }
    @isTest
    public static void filterCaseByCampagna3Test(){
        Group gr = [SELECT Id, Name, Type, LastModifiedById, DeveloperName FROM Group where Type like 'Queue' and 
                     		(DeveloperName='Q281' or DeveloperName='Q285' 
                             or DeveloperName ='Q286' or DeveloperName='Q287') limit 1];
        List<Case> cs = Gua_ManageUnitaAffariQuery.filterCaseByCampagna(gr,'name','Priorità');
        //System.assertEquals(1,cs.size());
    }
    @isTest
    public static void filterCaseByCodiceOcsNomeTest(){
        List<Case> cs = Gua_ManageUnitaAffariQuery.filterCaseByCodiceOcsNome('codiceOcs','nome','utenza');
        //System.assertEquals(1,cs.size());
    }
    @isTest
    public static void filterCaseByCodiceOcsNome2Test(){
        List <Case> cs = Gua_ManageUnitaAffariQuery.filterCaseByCodiceOcsNome('codiceOcs','nome','utenza');
        //System.assertEquals(1,cs.size());
    }
    @isTest
    public static void getCaseTest(){
        Campaign cp = [select id from Campaign limit 1];
        Case cs = Gua_ManageUnitaAffariQuery.getCase(cp.id);
        //System.assertEquals(1,cs.size());
    }
    
    @isTest
    public static void getFilialesTest(){
        List<Account> acct = Gua_ManageUnitaAffariQuery.getFiliales('tapha');
        //System.assertEquals(1,acct.size());
    }
    
     @isTest
    public static void getDealerByCaseTest(){
        Case cse = [select id from Case limit 1];
        Case cs = Gua_ManageUnitaAffariQuery.getDealerByCase(cse.id);
        //System.assertEquals(1,cs.size());
    }
    
    @isTest
    public static void getFilaliByCaseTest(){
        Case cse = [select id from Case limit 1];
        Case cs = Gua_ManageUnitaAffariQuery.getFilaliByCase(cse.id);
        //System.assertEquals(1,cs.size());
    }

    //getLastContactCaseByQueue
    @isTest
    public static void getLastContactCaseByQueueTest(){
        Group grp = [SELECT Id, Name, Type, LastModifiedById, DeveloperName FROM Group where Type like 'Queue' and 
                     		(DeveloperName='Q281' or DeveloperName='Q285' 
                             or DeveloperName ='Q286' or DeveloperName='Q287') limit 1];
        List<Case> cs = Gua_ManageUnitaAffariQuery.getLastContactCaseByQueue(grp, '1');
    }
}