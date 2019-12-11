@isTest
public class XCSPicklistMapRetrieveServiceTest {

    @isTest
    public static void test() {
        String jsonRequest = '{"OBJ":"Case", "PICKNAMES":[ {"PICKNAME":"Accolto__c"},{"PICKNAME":"Status"}]}';

        final String jsonResponse = XCSPicklistMapRetrieveService.execute(jsonRequest);

        System.debug(jsonResponse);
        
        XCSPicklistMapRetrieveService.execute();
    }
}