/**
*@author 		Moustapha Diouf
*created 		25/10/2019
*descripttion 	test of the GUA_DettaglioDealerCnt class
*/
@isTest
public class Gua_ChiamataStandaloneOutboundCntTest {
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
    public static void createTaskTest(){
      
        Test.startTest();
        Map<String ,Object> response = Gua_ChiamataStandaloneOutboundCnt.createTasks(new List<String>{'a0P0Q000000z0eTUAQ'},'Test Note', '', Datetime.newInstanceGmt(12, 12, 2019), '');
        Test.stopTest();
        System.debug('## response ##'+response);
    }
}