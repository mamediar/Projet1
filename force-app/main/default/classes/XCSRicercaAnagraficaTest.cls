@isTest
public class XCSRicercaAnagraficaTest {

    @isTest
    public static void ricercaPerOcsIDTest() {
        final Map<Account, Account> accountMap = new Map<Account, Account>();

        String personRecordTypeId  = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        String branchRecordTypeId  = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Branch').getRecordTypeId();
        
        Account acc1 = new Account(
            RecordTypeID = personRecordTypeId,
            OCS_External_Id__c = '82374654',
            FirstName = 'Nome1',
            LastName = 'Cognome1',
            PersonEmail = 'mail1@mail.com'
        );
 
        insert acc1 ;

        Account acc2 = new Account(
            RecordTypeID = personRecordTypeId,
            OCS_External_Id__c = 'fake',
            FirstName = 'Nome3',
            LastName = 'Cognome3',
            PersonEmail = 'mail3@mail.com'
        );

        // nessun insert

        Account acc3 = new Account(
            RecordTypeID = personRecordTypeId,
            OCS_External_Id__c = '4225434',
            FirstName = 'Nome3',
            LastName = 'Cognome3',
            PersonEmail = 'mail3@mail.com'
        );

        insert acc3;

        Account acc4 = new Account(
            RecordTypeID = branchRecordTypeId,
            OCS_External_Id__c = '123445',
            Name = 'Nome4'
        );

        insert acc4;

        accountMap.put(acc1, null);
        accountMap.put(acc2, null);
        accountMap.put(acc3, null);
        accountMap.put(acc4, null);

        XCSRicercaAnagrafica.ricercaPerOcsID(accountMap);

        System.assert(accountMap.get(acc1) <> null);
        System.assert(accountMap.get(acc2) == null);
        System.assert(accountMap.get(acc3) <> null);
        System.assert(accountMap.get(acc4) == null);

        Account acc1out = accountMap.get(acc1);
        Account acc3out = accountMap.get(acc3);

        System.assertEquals('Nome1', acc1out.FirstName);
        System.assertEquals('4225434', acc3out.OCS_External_Id__c);
    }


    @isTest
    public static void ricercaPerCodiceFiscaleTest() {
        final Map<Account, Account> accountMap = new Map<Account, Account>();

        String personRecordTypeId  = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
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
            PersonEmail = 'mail2@mail.com',
            Codice_Fiscale__pc = 'EEEFFFBB2344DDD'
        );

        insert acc2;

        accountMap.put(acc1, null);
        accountMap.put(acc2, null);

        XCSRicercaAnagrafica.ricercaPerCodiceFiscale(accountMap);

        System.assert(accountMap.get(acc1) == null);
        System.assert(accountMap.get(acc2) <> null);

        Account acc2out = accountMap.get(acc2);
        System.assertEquals('EEEFFFBB2344DDD', acc2out.Codice_Fiscale__pc);
    }

    @isTest
    public static void ricercaPerCrmIdTest() {
        final Map<Account, Account> accountMap = new Map<Account, Account>();

        String personRecordTypeId  = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
        Account acc1 = new Account( 
            RecordTypeID = personRecordTypeId,
            RSS_External_Id__c = '12345',
            FirstName = 'Nome1',
            LastName = 'Cognome1',
            PersonEmail = 'mail1@mail.com'
        );

        insert acc1;

        Account acc2 = new Account( 
            RecordTypeID = personRecordTypeId,
            FirstName = 'Nome2',
            LastName = 'Cognome2',
            PersonEmail = 'mail2@mail.com'
        );

        insert acc2;

        String acc2Id = [SELECT Id FROM Account WHERE FirstName = 'Nome2'].Id;
        acc2.RSS_External_Id__c = acc2Id;

        Account acc3 = new Account( 
            RecordTypeID = personRecordTypeId,
            RSS_External_Id__c = 'fake',
            FirstName = 'Nome3',
            LastName = 'Cognome3',
            PersonEmail = 'mail3@mail.com'
        );

        insert acc3;

        Account acc4 = new Account( 
            RecordTypeID = personRecordTypeId,
            RSS_External_Id__c = 'fake2',
            FirstName = 'Nome4',
            LastName = 'Cognome4',
            PersonEmail = 'mail4@mail.com'
        );

        accountMap.put(acc1, null);
        accountMap.put(acc2, null);
        accountMap.put(acc3, null);
        accountMap.put(acc4, null);

        XCSRicercaAnagrafica.ricercaPerCrmId(accountMap);

        System.assertNotEquals(null, accountMap.get(acc1));
        System.assertNotEquals(null, accountMap.get(acc2));
        System.assertNotEquals(null, accountMap.get(acc3));
        System.assertEquals(null, accountMap.get(acc4));

        Account acc1out = accountMap.get(acc1);
        System.assertEquals('12345', acc1.RSS_External_Id__c);

        Account acc2out = accountMap.get(acc2);
        System.assertEquals(acc2Id, acc2.RSS_External_Id__c);

        Account acc3out = accountMap.get(acc3);
        System.assertEquals('fake', acc3.RSS_External_Id__c);
    }

    @isTest
    public static void ricercaPerEmailNomeCognomeTest() {
        final Map<Account, Account> accountMap = new Map<Account, Account>();

        String personRecordTypeId  = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
        Account acc1Ins = new Account( 
            RecordTypeID = personRecordTypeId,
            FirstName = 'Nome1',
            LastName = 'Cognome1',
            PersonEmail = 'mail1@mail.com'
        );

        insert acc1Ins;

        Account acc1 = new Account(
            FirstName = 'Nome1',
            LastName = 'Cognome1',
            PersonEmail = 'mail1@mail.com'
        );

        Account acc2Ins = new Account( 
            RecordTypeID = personRecordTypeId,
            LastName = 'Cognome2',
            PersonEmail = 'mail2@mail.com'
        );

        insert acc2Ins;

        Account acc2 = new Account(
            FirstName = 'Nome2',
            LastName = 'Cognome2',
            PersonEmail = 'mail2@mail.com'
        );

        Account acc3Ins = new Account(
            FirstName = 'Nome3',
            LastName = 'Cognome3',
            PersonEmail = 'mail3@mail.com'
        );

        insert acc3Ins;

        Account acc3 = new Account(
            FirstName = 'NOME3',
            LastName = 'COGNOME3',
            PersonEmail = 'mail3@mail.com'
        );

        accountMap.put(acc1, null);
        accountMap.put(acc2, null);
        accountMap.put(acc3, null);

        XCSRicercaAnagrafica.ricercaPerEmailNomeCognome(accountMap);

        System.assertNotEquals(null, accountMap.get(acc1));
        System.assertEquals(null, accountMap.get(acc2));
        System.assertNotEquals(null, accountMap.get(acc3));

        Account acc1out = accountMap.get(acc1);
        System.assertEquals('Nome1', acc1out.FirstName);

        Account acc3out = accountMap.get(acc3);
        System.assertEquals('Nome3', acc3out.FirstName);
    }
    
    @isTest
    public static void coverageTest() {
        XCSRicercaAnagrafica.ricercaPerOcsID(null);
        XCSRicercaAnagrafica.ricercaPerCodiceFiscale(null);
        XCSRicercaAnagrafica.ricercaPerCrmId(null);
        XCSRicercaAnagrafica.ricercaPerEmailNomeCognome(null);
        String personRecordTypeId  = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Person Account').getRecordTypeId();

        Account acc2Ins = new Account( 
            RecordTypeID = personRecordTypeId,
            FirstName = 'NOME3',
            LastName = 'Cognome2',
            PersonEmail = 'mail2@mail.com'
        );
        
        XCSRicercaAnagrafica.ricercaAccount(acc2Ins);
        insert acc2Ins;
        XCSRicercaAnagrafica.ricercaAccount(acc2Ins);
    }
}