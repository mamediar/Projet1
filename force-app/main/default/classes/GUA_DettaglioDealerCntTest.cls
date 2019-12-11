/**
*@author 		Moustapha Diouf
*created 		25/10/2019
*descripttion 	test of the GUA_DettaglioDealerCnt class
*/
@isTest
public class GUA_DettaglioDealerCntTest {
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
        
    }
    
    @isTest
    public static void getDealerByCaseTest(){
        Case cse = [select id from Case limit 1];
        Map<String ,Object>  returnValue = GUA_DettaglioDealerCnt.getDealerByCase(cse.id);
        //System.assertEquals(1,cs.size());
    }
    @isTest
    public static void GUA_CSVparsingJSONTest(){
        new GUA_DettaglioDealerCnt.GUA_CSVparsingJSON('val1', 'val2', 'val3', 'val4', 'val5', 'val6', 'val7',
                           'val8', 'val9', 'val10', 'val11', 'val12', 'val13',
                           'val14', 'val15', 'val16', 'val17',  'val18',
                           'val19', 'val20', 'val21',  'val22');
    }
}