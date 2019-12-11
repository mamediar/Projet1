@isTest
public class XCSFusioneAnagraficaTest {

    private static String personRecordTypeId  = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    

    @isTest
    public static void fondiTest() {

        final Map<Account,Account> accountMap = new Map<Account,Account>();
        
        Account acc0 = new Account(
            RecordTypeID = personRecordTypeId,
            FirstName = 'Nome0',
            LastName = 'Cognome0',
            RSS_External_Id__c = '12345676',
            OCS_External_Id__c = '8899777',
            PersonEmail = 'mail0@mail.com'
        );

        insert acc0;

        Account acc1 = new Account(
            RecordTypeID = personRecordTypeId,
            FirstName = 'Nome1',
            LastName = 'Cognome1',
            RSS_External_Id__c = '98784736',
            PersonEmail = 'mail1@mail.com'
        );

        insert acc1;

        String acc1Id = acc1.Id;

        Account accIn = new Account(
            RecordTypeID = personRecordTypeId,
            FirstName = 'NomeIN',
            LastName = 'CognomeIN',
            RSS_External_Id__c = '98784736',
            OCS_External_Id__c = '8899777',
            PersonEmail = 'mailIN@mail.com'
        );

        accountMap.put(accIn, acc0);

        XCSFusioneAnagrafica.fondi(accountMap);

        Account accOUT = accountMap.get(accIn);
        System.assertEquals(acc0, accOUT);
        
        System.assertEquals(0, [SELECT count() from Account where Id = :acc1Id]);
    }
    
    @isTest
    public static void coverageTest() {
        XCSFusioneAnagrafica.fondi(null);
    }

}