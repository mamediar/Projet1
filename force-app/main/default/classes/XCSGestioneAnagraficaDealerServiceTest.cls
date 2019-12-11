@IsTest
public class XCSGestioneAnagraficaDealerServiceTest {
    
    private static String dealerRecordTypeId  = RecordTypeUtil.getDealerRecordType();
    
    @isTest
    public static void coverageTest() {
        try {
        	XCSGestioneAnagraficaDealerService.execute();
        }
        catch (Exception e) {}
        String jsonRequest = '{"DATA_SOURCE":"Altro","ACCOUNTS":[{"OCS_ID":"234533","FISCALCODE":"RSSMRR78P04C205S","P_IVA":"RSSMRR78P04C205S","RAGIONE_SOC":"MarioRossi"},{"OCS_ID":"578591","FISCALCODE":"FRNPZZ90K12C639D","P_IVA":"FRNPZZ90K12C639D","RAGIONE_SOC":"FrancescaFumagalli"}]}';
        XCSGestioneAnagraficaDealerService.executeService(jsonRequest);
    }

}