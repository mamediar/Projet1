/**
*@author 		Mame bousso kane
*created 		25/09/2019
*descripttion 	test of the GUA_GestioneQueueCnt class
*/
@isTest
public class GUA_GestioneQueueCntTest {
	//@testSetup 
    static void testSetup() {
		Group grp1 = new Group(DeveloperName='Q281',Type='Queue',Name='mame test 1');
        Group grp2 = new Group(DeveloperName='Q285',Type='Queue',Name='mame test 2');
        Group grp3 = new Group(DeveloperName='Q286',Type='Queue',Name='mame test 3');
        Group grp4 = new Group(DeveloperName='Q287',Type='Queue',Name='mame test 4s');
        List<Group> grps = new List<Group>{grp1,grp2,grp3,grp4};
        insert grps;
       	}
    
    @isTest
    static void test(){
        Test.startTest();
    	Map<String ,Object> result = GUA_GestioneQueueCnt.getQueus();
   		Test.stopTest();        
    }
}