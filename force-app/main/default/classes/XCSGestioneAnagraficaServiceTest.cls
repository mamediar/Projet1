@isTest
public class XCSGestioneAnagraficaServiceTest {

    private static final String personRecordTypeId  = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Person Account').getRecordTypeId();

    @TestSetup
    static void makeData() {
        
        Account acc1 = new Account(
            RecordTypeID = personRecordTypeId,
            FirstName = 'Nome1',
            LastName = 'Cognome1',
            PersonEmail = 'mail1@mail.com'
        );
 
        insert acc1 ;

        Account acc2 = new Account(
            RecordTypeID = personRecordTypeId,
            FirstName = 'Nome2',
            LastName = 'Cognome2',
            OCS_External_Id__c = '8899777',
            COD_Ateco__c = 'CBA'
        );
 
        insert acc2 ;
        
    }
    
    @isTest
    public static void test() {
        String jsonRequest = '{"DATA_SOURCE":"Altro","ACCOUNTS":[';
        jsonRequest += '{"FIRSTNAME":"pinco","LASTNAME":"pallo","OCS_ID":"8899777"}]}';
        
        final String jsonResponse = XCSGestioneAnagraficaService.execute(jsonRequest);
        System.debug(jsonResponse);
    }

    @isTest
    public static void testDuplicates() {
        String jsonRequest = '{"DATA_SOURCE":"Altro","ACCOUNTS":[';
        jsonRequest += '{"FIRSTNAME":"nome","LASTNAME":"cognome","EMAIL":"mail@mail.com"},';
        jsonRequest += '{"FIRSTNAME":"nome","LASTNAME":"cognome","EMAIL":"mail@mail.com"}';
        jsonRequest += ']}';
        
        final String jsonResponse = XCSGestioneAnagraficaService.execute(jsonRequest);
        System.debug(jsonResponse);
    }

     @isTest
    public static void testDuplicateOCSIDs() {
        String jsonRequest = '{"DATA_SOURCE":"Altro","ACCOUNTS":[';
        jsonRequest += '{"FIRSTNAME":"nome","LASTNAME":"cognome","EMAIL":"mail@mail.com", "OCS_ID":"12345"},';
        jsonRequest += '{"FIRSTNAME":"nome","LASTNAME":"cognome","EMAIL":"mail@mail.com", "OCS_ID":"12345"}';
        jsonRequest += ']}';
        
        final String jsonResponse = XCSGestioneAnagraficaService.execute(jsonRequest);
        System.debug(jsonResponse);
    }
    
     @isTest
    public static void coverageTest() {
        try { XCSGestioneAnagraficaService.execute(); } catch(Exception e) {}
    }
}