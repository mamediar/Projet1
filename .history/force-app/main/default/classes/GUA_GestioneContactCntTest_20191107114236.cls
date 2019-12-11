/**
*@author 		Mame bousso kane
*created 		25/09/2019
*descripttion 	test of the GUA_GestioneContactCnt class
*/
@isTest
public class GUA_GestioneContactCntTest {
    
   @testSetup 
    static void testSetup() {
        Date dates =  date.newInstance(2019, 10, 13);
        Campaign campaign = new Campaign(Name='Free', UAF_DatiAggiuntivi__c='test 1');
        insert campaign;
        User user = new User(LastName='Mols', Username='MolsBob1@gmail.com', Email='mols1@gmail.com', Alias='test', TimeZoneSidKey='GMT', LocaleSidKey='it_IT', EmailEncodingKey='ISO-8859-1', ProfileId='00e0Q000000LufuQAC', LanguageLocaleKey='en_US');
        insert user;
        Contact contact = new Contact(LastName='Dieng');
        insert contact;
        Id recordTypeDealer =CGMWSUtils_1_0.getRecordTypeId('Account','Dealer');
        Account dealer = new Account(Name='Drame',  RecordTypeId=recordTypeDealer);
        insert dealer;
         Case cas = new Case(CodiceDealer__c='dev', UAF_DatiAggiuntiviFile__c='test 1', Status='New', Esito__c='test 2', Scadenza__c= dates, Priority='Medium', Tentativo__c=123, TipoChiamata__c='Inbound',
                             F_Indirizzo_Filiale__c='test', SuppliedIdContract__c='test1', SuppliedMobilePhone__c='775654215',
                            Assegnatario__c= user.Id, ContactId=contact.Id, CampaignId__c=campaign.Id, Dealer__c = dealer.Id);
       	insert cas;
        System.debug('id case '+ cas.Id);
		Group grp1 = new Group(DeveloperName='Q2814',Type='Queue',Name='Mame test 1');
        Group grp2 = new Group(DeveloperName='Q2856',Type='Queue',Name='test 2');
        Group grp3 = new Group(DeveloperName='Q2868',Type='Queue',Name='Mame test 3');
        Group grp4 = new Group(DeveloperName='Q2879',Type='Queue',Name='Mame 4');
        Group grp5 = new Group(DeveloperName='Q2871',Type='Queue',Name='Mame 5');
        List<Group> grps = new List<Group>{grp1,grp2,grp3,grp4,grp5};
        insert grps;
        
	}
    
	@isTest
    static void testGetContactCaseByQueue(){
        Group grp= [select Id from Group limit 1];
        Test.startTest();
    	Map<String ,Object> result= GUA_GestioneContactCnt.getContactCaseByQueue(grp,'2','2');
   		Test.stopTest();        
    }
    
    @isTest
    static void getLastContactCaseByQueue(){
        Group grp= [select Id from Group limit 1];
        Test.startTest();
    	Map<String ,Object> result= GUA_GestioneContactCnt.getLastContactCaseByQueue(grp,'2');
   		Test.stopTest();        
    }
    
     @isTest
    static void getInformazioniDealerByCodeOCS(){
        Test.startTest();
    	Map<String ,Object> result= GUA_GestioneContactCnt.getInformazioniDealerByCodeOCS('dev');
   		Test.stopTest();        
    }
    
    @isTest
    static void testFilterContactCaseByCampagna(){
        Group grp= [select Id from Group limit 1];
        String nameCampagna='' ;
        String orderCriter='';
        Test.startTest();
    	Map<String ,Object> result= GUA_GestioneContactCnt.filterContactCaseByCampagna(grp,nameCampagna,orderCriter);
   		Test.stopTest();        
    }
    
    @isTest
    static void testfilterCaseByNomeOcsCF(){
        String nome=''; 
        String codiceOcs=''; 
        String utenzoCF='';
        String pageSize='';
        String pageNumber='';
        Test.startTest();
    	Map<String ,Object> result= GUA_GestioneContactCnt.filterCaseByNomeOcsCF(nome,codiceOcs,utenzoCF,pageSize,pageNumber);
   		Test.stopTest();
    }
    @isTest
    static void testfilterCaseByNomeOcsCF1(){
        String nome=''; 
        String codiceOcs='dev'; 
        String utenzoCF='';
        String pageSize='';
        String pageNumber='';
        Test.startTest();
    	Map<String ,Object> result= GUA_GestioneContactCnt.filterCaseByNomeOcsCF(nome,codiceOcs,utenzoCF,pageSize,pageNumber);
   		Test.stopTest();
    }
    @isTest
    static void testgetQueus(){
        Test.startTest();
    	Map<String ,Object> result= GUA_GestioneContactCnt.getQueus();
   		Test.stopTest();
    }
    
     @isTest
    public static void GUA_CSVparsingJSONTest(){
        new GUA_GestioneContactCnt.UtenZaDealer('5005E000005qXFaQAM','val1', 'val2', 'val3', 'val4', 'val5', 'val6', 'val7');
    }
}