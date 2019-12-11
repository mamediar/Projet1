/**
*@author 		Mame bousso kane
*created 		25/09/2019
*descripttion 	test of the GUA_DettaglioContactCnt class
*/

@isTest
public class GUA_DettaglioContactCntTest {
    
   @testSetup 
    static void testSetup() {
        Date dates =  date.newInstance(2019, 10, 12);
        Date date1 =  date.newInstance(2019, 04, 12);
		Account acc = new Account(FirstName='mame Diarra', LastName='Kane', Data_Depennamento__c= dates);
        insert acc;
        Id recordTypeDealer =CGMWSUtils_1_0.getRecordTypeId('Account','Dealer');
        Account dealer = new Account(Name='Bass', Region_Name__c='RS', Address_Abbr_Sms__c='Drand Standing', Telefono_Casa__c='339654215',
                           Telefono_Cellulare__c='772589632', Phone='338501236' , RecordTypeId=recordTypeDealer);
        insert dealer;
        Id recordTypeBranch =CGMWSUtils_1_0.getRecordTypeId('Account','Branch');
        Account branch = new Account(Name='Bassirou', Address_Abbr_Sms__c='Mbour',
                          Phone='779863521', Telefono_Casa__c='778523641', DataInizioAttivita__c=date1, RecordTypeId=recordTypeBranch);
        insert branch;
        Contact contact = new Contact(LastName='Diouf');
        insert contact;
        Campaign campaign = new Campaign(Name='Free', UAF_DatiAggiuntivi__c='test');
        insert campaign;
        Profile profil = [Select Id From Profile Limit 1];
        User user = new User(LastName='Sy', Username='MolsBob@gmail.com', Email='mols@gmail.com', Alias='test', TimeZoneSidKey='GMT', LocaleSidKey='it_IT', EmailEncodingKey='ISO-8859-1', ProfileId=profil.Id, LanguageLocaleKey='en_US');
        insert user;
        Case cas = new Case(CodiceDealer__c='dev', Pratica_Codice_Attributo_PM__c='test', UAF_DatiAggiuntiviFile__c='test 1', Status='New', Esito__c='test 2',
                             AccountId=acc.Id, Dealer__c=dealer.Id, Assegnatario__c= user.Id, ContactId=contact.Id, Branch__c=branch.Id, CampaignId__c=campaign.Id);
        insert cas;
	}
    
	@isTest
    static void getTest(){
        Campaign Camp = [Select Id From Campaign Limit 1];
    	Map<String ,Object> cse = GUA_DettaglioContactCnt.getCase(camp.Id);
   		    
    }
    
    @isTest
    public static void GUA_CSVparsingJSONTest(){
        new GUA_DettaglioContactCnt.GUA_CSVparsingJSON('val1', 'val2', 'val3', 'val4', 'val5', 'val6', 'val7',
                           'val8', 'val9', 'val10', 'val11', 'val12', 'val13',
                           'val14', 'val15', 'val16', 'val17',  'val18',
                           'val19', 'val20', 'val21',  'val22');
    }
    
}