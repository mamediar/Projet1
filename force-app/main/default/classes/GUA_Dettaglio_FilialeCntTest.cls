/**
*@author 		Khadim R Ndeye
*created 		29/10/2019
*descripttion 	test of GUA_Dettaglio_FilialeCnt class
*/
@isTest
public class GUA_Dettaglio_FilialeCntTest {
    @TestSetup
    static void makeData(){
        Id recordType=CGMWSUtils_1_0.getRecordTypeId('Case','GUA_Contact');
        Id recordTypeDealer=CGMWSUtils_1_0.getRecordTypeId('Account','Branch');
        Account acc = new Account(Name='Account Test', RecordTypeId=recordTypeDealer);
        insert acc;
        Case c = new Case(Status='New', AccountId= acc.Id, RecordTypeId=recordType, Branch__c=acc.Id);
        insert c;
    }
	@isTest
    static void testGetRecuperaUtenzeIntermediario(){
        String codiceIntermediario='60757';
        Test.startTest();
        Map<String ,Object> response = GUA_Dettaglio_FilialeCnt.getRecuperaUtenzeIntermediario(codiceIntermediario);
   		Test.stopTest();
        //System.assertEquals(response.get('erreur'), false);      
    }
    
    @isTest
    public static void getCase(){
        Account acc = [SELECT id, Name FROM Account WHERE Name='Account Test' LIMIT 1];
        Case caseRecord = [SELECT Id FROM Case WHERE AccountId=:acc.Id LIMIT 1];
        Test.startTest();
        Map<String ,Object> response = GUA_Dettaglio_FilialeCnt.getCase(caseRecord.Id);
        Map<String ,Object> response2 = GUA_Dettaglio_FilialeCnt.getCase('xxxxx');
   		Test.stopTest();
        System.assertEquals(response.get('erreur'), false);
        //System.assertEquals(response2.get('erreur'), true);
    }
}