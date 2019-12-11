@isTest
public class XCSCreazioneAnagraficaTest {
    private static String personRecordTypeId = RecordTypeUtil.getPersonRecordType();
        
    @isTest 
    public static void test1() {

        final Map<Account,Account> accountMap = new Map<Account,Account>();
        
        Account acc1 = new Account(
            RecordTypeID = personRecordTypeId,
            FirstName = 'Nome1',
            LastName = 'Cognome1',
            OCS_External_Id__c = '1234',
            PersonEmail = 'mail1@mail.com'
        );

        Account acc2 = new Account(
            RecordTypeID = personRecordTypeId,
            FirstName = 'Nome2',
            LastName = 'Cognome2',
            OCS_External_Id__c = '5678',
            PersonEmail = 'mail2@mail.com'
        );

        Account acc3 = new Account(
            RecordTypeID = personRecordTypeId,
            FirstName = 'Nome3',
            LastName = 'Cognome3'
        );

        Account acc4 = new Account(
            RecordTypeID = personRecordTypeId,
            FirstName = 'Nome4',
            LastName = 'Cognome4',
            PersonEmail = 'mail#mail.com'
        );

        Account acc5 = new Account(
            RecordTypeID = personRecordTypeId,
            FirstName = 'Nome5',
            LastName = 'Cognome5',
            OCS_External_Id__c = '5678'
        );

        Account acc6 = new Account(
            RecordTypeID = personRecordTypeId,
            FirstName = 'Nome6',
            LastName = 'Cognome6',
            OCS_External_Id__c = '1234'
        );

        Account acc7 = new Account(
            RecordTypeID = personRecordTypeId,
            FirstName = 'Nome7',
            LastName = 'Cognome7',
            OCS_External_Id__c = '1234'
        );

        Account acc8 = new Account(
            RecordTypeID = personRecordTypeId,
            FirstName = 'Nome8',
            LastName = 'Cognom8'
        );

        accountMap.put(acc1, null);
        accountMap.put(acc2, null);
        accountMap.put(acc3, null);
        accountMap.put(acc4, null);
        accountMap.put(acc7, acc7);
        accountMap.put(acc5, null);
        accountMap.put(acc6, null);
        accountMap.put(acc8, acc8);

        XCSCreazioneAnagrafica.crea(accountMap, false);
        
        for (Account accs : accountMap.values()) {
            System.debug('accs: ' + accs);
        }

        System.assertEquals(8, accountMap.values().size());
        Account acc1out = accountMap.get(acc1);
        System.assertNotEquals(null, acc1out);
        Account acc2out = accountMap.get(acc2);
        System.assertNotEquals(null, acc2out);
        Account acc3out = accountMap.get(acc3);
        System.assertNotEquals(null, acc3out);
        Account acc4out = accountMap.get(acc4);
        System.assertNotEquals(null, acc4out);
        Account acc5out = accountMap.get(acc5);
        System.assertNotEquals(null, acc5out);
        Account acc6out = accountMap.get(acc6);
        System.assertNotEquals(null, acc6out);
        Account acc7out = accountMap.get(acc7);
        System.assertEquals(acc7, acc7out);

        System.assertEquals(acc1out.Id, acc6out.Id);
        System.assertEquals('1234', acc1out.OCS_External_Id__c);
        System.assertEquals(acc2out.Id, acc5out.Id);
        System.assertEquals('5678', acc5out.OCS_External_Id__c);
        System.assertEquals(null, acc3out.OCS_External_Id__c);
        System.assertEquals(null, acc4out.PersonEmail);
        System.assertEquals(null, acc4out.PersonEmail);
        System.assertEquals('mail#mail.com', acc4out.EmailNonConforme__c);
        
        String contactId = [SELECT PersonContactId from Account where Id =: acc6out.ID].PersonContactId;
        System.assertEquals(acc6out.PersonContactId, contactId);
    }

    @isTest 
    public static void testDuplicates() {

        final Map<Account,Account> accountMap = new Map<Account,Account>();

        Account acc1 = new Account(
            FirstName = 'Nome1',
            LastName = 'Cognome1',
            OCS_External_Id__c = '1234',
            PersonEmail = 'mail1@mail.com'
        );

        Account acc2 = new Account(
            FirstName = 'Nome1',
            LastName = 'Cognome1',
            OCS_External_Id__c = '1234',
            PersonEmail = 'mail2@mail.com'
        );

        accountMap.put(acc1, null);
        accountMap.put(acc2, null);

        System.debug(LoggingLevel.DEBUG, 'Acc1 prima: ' + acc1);
        System.debug(LoggingLevel.DEBUG, 'Acc2 prima: ' + acc2);

        XCSCreazioneAnagrafica.crea(accountMap, false);

        System.debug(LoggingLevel.DEBUG, 'Acc1 dopo: ' + acc1);
        System.debug(LoggingLevel.DEBUG, 'Acc2 dopo: ' + acc2);

        System.debug(LoggingLevel.DEBUG, 'MAPPA: ' + accountMap);

        //System.assertEquals(1, accountMap.values().size());
        Account acc1out = accountMap.get(acc1);
        System.debug(LoggingLevel.DEBUG, 'acc1out: ' + acc1out);

        System.assertNotEquals(null, acc1out);
        Account acc2out = accountMap.get(acc2);
        System.debug(LoggingLevel.DEBUG, 'acc2out: ' + acc2out);
        System.assertNotEquals(null, acc2out);
        System.assertEquals(acc1out.Id, acc2out.Id);
    }
    
    @isTest 
    public static void coverageTest() {
        XCSCreazioneAnagrafica.crea(null, false);
    }

 

}