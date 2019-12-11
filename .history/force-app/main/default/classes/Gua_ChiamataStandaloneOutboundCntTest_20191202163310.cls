/**
*@author 		Moustapha Diouf
*created 		25/10/2019
*descripttion 	test of the GUA_DettaglioDealerCnt class
*/
@isTest
public class Gua_ChiamataStandaloneOutboundCntTest {

    @TestSetup
    static void makeData(){
        //create disposition
        XCS_Disposition__c gp = new XCS_Disposition__c(Name='CTI OUTBOUND');
        insert gp;        
        XCS_Disposition__c parent = new XCS_Disposition__c(Name='Affari@Phone',Parent__c = gp.Id);
        XCS_Disposition__c child = new XCS_Disposition__c(Name='Test Disposition');
        // List<XCS_Disposition__c> listDispo = new List<XCS_Disposition__c>();
        insert parent;

        insert child;

        child.Parent__c = parent.Id;
        update child;

        // create case 
        Case cs = new Case();
        cs.Status = 'Open';
        cs.Subject = 'TestSubject';
        cs.Description = 'TestDescription';
        cs.Tentativo__c = 2;
        cs.RO_Vecchio_Cellulare__c ='1234567890';
        cs.RO_Link_Bozza__c  = '111111';
        insert cs;
    }
	@isTest
    public static void getFilialesTest(){
        Id recordTypeBranch=CGMWSUtils_1_0.getRecordTypeId('Account','Branch');
        Account branch = new Account(Name='name', RecordTypeId=recordTypeBranch);
        insert branch;
        Account branch2 = new Account(Name='tapha', RecordTypeId=recordTypeBranch);
        insert branch2;
      
        Map<String ,Object> response = Gua_ChiamataStandaloneOutboundCnt.getFilialeByNameOrCodiceFiliale('tapha');
        Map<String ,Object> response2 = Gua_ChiamataStandaloneOutboundCnt.getFilialeByNameOrCodiceFiliale('xxx');
        List<Account> filials = (List<Account>)response.get('resultat');
        List<Account> filials2 = (List<Account>)response.get('resultat');
        System.assertEquals(1,filials.size());
    }
    
    @isTest
    public static void getFilialesKOTest(){
      
        Map<String ,Object> response = Gua_ChiamataStandaloneOutboundCnt.getFilialeByNameOrCodiceFiliale(null);
        List<Account> filials = (List<Account>)response.get('resultat');
        System.assertEquals(0,filials.size());
    }
    @isTest
    public static void retrieveDispositionValuesTest(){
        Case cs = [SELECT ID FROM Case LIMIT 1];

        Test.startTest();
            Map<String ,Object> response = Gua_ChiamataStandaloneOutboundCnt.retrieveDispositionValues(cs.Id+'');
        Test.stopTest();
        List<XCS_Disposition__c> dispo = (List<XCS_Disposition__c>) response.get('data');
        System.debug('dispo '+dispo);

        // System.assertEquals(1,dispo.size());
    }

    @isTest
    public static void createTaskOKTest(){
        List<XCS_Disposition__c> dsp = [SELECT ID,NAME FROM XCS_Disposition__c WHERE PARENT__r.Name = 'Affari@Phone' AND PARENT__r.PARENT__r.Name='CTI OUTBOUND'];
        Case cs = [SELECT ID FROM Case LIMIT 1];

        Test.startTest();
        	Map<String ,Object> response2 = Gua_ChiamataStandaloneOutboundCnt.createTasks(new List<String>{dsp[0].id},'Test Note',''+cs.Id,new Map<String,String>(),true);
        Test.stopTest();
        System.debug('## response ##'+response);
    }
}