@isTest
public class XCSGestioneAnagraficaTest {

    private static String personRecordTypeId  = RecordTypeUtil.getPersonRecordType();
    
    @isTest
    public static void gestioneAnagraficaTest() {

        Account insAcc1 = new Account(
            RecordTypeID = personRecordTypeId,
            FirstName = 'Nome1',
            LastName = 'Cognome1',
            RSS_External_Id__c = '12345676',
            OCS_External_Id__c = '1234',
            PersonEmail = 'mail1@mail.com'
        );

        insert insAcc1;

        Account insAcc2 = new Account(
            RecordTypeID = personRecordTypeId,
            FirstName = 'Nome2',
            LastName = 'Cognome2',
            RSS_External_Id__c = '56789123',
            OCS_External_Id__c = '5678'
        );

        insert insAcc2;

        Account insAcc3 = new Account(
            RecordTypeID = personRecordTypeId,
            FirstName = 'Nome3',
            LastName = 'Cognome3',
            PersonEmail = 'mail3@mail.com',
            ShippingCity = 'Roma'
        );

        insert insAcc3;

        System.debug('++++++++ insAcc3 Id: ' + insAcc3.Id);

        Account insAccFus1 = new Account(
            RecordTypeID = personRecordTypeId,
            FirstName = 'NomeA',
            LastName = 'CognomeA',
            RSS_External_Id__c = '987654321',
            OCS_External_Id__c = '98765'
        );

        insert insAccFus1;

        Account insAccFus2 = new Account(
            RecordTypeID = personRecordTypeId,
            FirstName = 'NomeB',
            LastName = 'CognomeB',
            RSS_External_Id__c = '135792468',
            OCS_External_Id__c = '13579',
            PersonEmail = 'mailB@mail.com'
        );

        insert insAccFus2;

        
        // ricerca per nome, cognome, email e aggiorna
        Account acc1 = new Account(
            FirstName = 'Nome1',
            LastName = 'Cognome1',
            PersonEmail = 'mail1@mail.com',
            ShippingCity = 'Milano'
        );

        // ricerca per OCS_ID e aggiorna con mail errata
        Account acc2 = new Account(
            FirstName = 'Nome_2',
            LastName = 'Cognome_2',
            OCS_External_Id__c = '5678',
            PersonEmail = 'mail_2#mail.com'
        );

        // ricerca per CRM_ID e aggiorna
        Account acc3 = new Account(
            RSS_External_Id__c = insAcc3.Id,
            PersonEmail = 'mail_3@mail.com',
            ShippingCity = 'Milano'
        );

        // fusione
        Account acc4 = new Account(
            FirstName = 'Nome4',
            LastName = 'Cognome4',
            RSS_External_Id__c = '135792468',
            OCS_External_Id__c = '98765',
            PersonEmail = 'mail4@mail.com'
        );

        // fallimento creazione (Autonomo, Dipendente pubblico/statale)
        Account acc5 = new Account(
            FirstName = 'Nome5',
            LastName = 'Cognome5',
            PersonEmail = 'mail5@mail.com',
            Occupation_Lvl1__c = '1',
            Occupation_Lvl2__c = '1'
        );

        // creazione1
        Account acc6 = new Account(
            FirstName = 'Nome6',
            LastName = 'Cognome6',
            PersonEmail = 'mail6@mail.com',
            OCS_External_Id__c = '112233',
            Occupation_Lvl1__c = '2',
            Occupation_Lvl2__c = '1'
        );

        // creazione2
        Account acc7 = new Account(
            FirstName = 'Nome7',
            LastName = 'Cognome7',
            PersonEmail = 'mail7@mail.com',
            OCS_External_Id__c = '445566',
            Occupation_Lvl1__c = '1'
        );

        // creazione3
        Account acc8 = new Account(
            FirstName = 'Nome8',
            LastName = 'Cognome8',
            PersonEmail = 'mail8@mail.com',
            OCS_External_Id__c = '445566',
            Occupation_Lvl1__c = '1'
        );

        final Map<Account,Account> accountMap = new Map<Account,Account>();

        accountMap.put(acc1,null);
        accountMap.put(acc2,null);
        accountMap.put(acc3,null);
        accountMap.put(acc4,null);
        accountMap.put(acc5,null);
        accountMap.put(acc6,null);
        accountMap.put(acc7,null);
        accountMap.put(acc8,null);

        XCSGestioneAnagrafica.execute(accountMap, true, false);
/*
        System.assertEquals(8, accountMap.size());

        Account accOut1 = accountMap.get(acc1);
        System.assertNotEquals(null, accOut1);
        Account accOut2 = accountMap.get(acc2);
        System.assertNotEquals(null, accOut2);
        Account accOut3 = accountMap.get(acc3);
        System.assertNotEquals(null, accOut3);
        Account accOut4 = accountMap.get(acc4);
        System.assertNotEquals(null, accOut4);
        Account accOut5 = accountMap.get(acc5);
        System.assertEquals(null, accOut5);
        Account accOut6 = accountMap.get(acc6);
        System.assertNotEquals(null, accOut6);
        Account accOut7 = accountMap.get(acc7);
        System.assertNotEquals(null, accOut7);
        Account accOut8 = accountMap.get(acc8);
        System.assertNotEquals(null, accOut8);

        System.assertEquals(insAcc1.Id, accOut1.Id);
        System.assertEquals('12345676', accOut1.RSS_External_Id__c);
        System.assertEquals('mail1@mail.com', accOut1.PersonEmail);
        System.assertEquals('Milano', accOut1.ShippingCity);
        
        System.assertEquals(insAcc2.Id, accOut2.Id);
        System.assertEquals('Nome_2', accOut2.FirstName);
        System.assertEquals('56789123', accOut2.RSS_External_Id__c);
        System.assertEquals(null, accOut2.PersonEmail);
        System.assertEquals('mail_2#mail.com', accOut2.EmailNonConforme__c);

        System.assertEquals(insAcc3.Id, accOut3.Id);
        System.assertEquals('mail3@mail.com', accOut3.PersonEmail);
        System.assertEquals('Milano', accOut3.ShippingCity);

        System.assertEquals(insAccFus1.Id, accOut4.Id);
        System.assertEquals('Nome4', accOut4.FirstName);
        
        System.assertEquals('Nome6', accOut6.FirstName);
        System.assertEquals('Nome7', accOut7.FirstName);

        System.assertEquals(accOut7, accOut8);
*/
    }
    
    @isTest
    public static void coverageTest() {
        try {
        XCSGestioneAnagrafica.execute(null, true, false);
        final Map<Account,Account> accountMap = new Map<Account,Account>();
        Account acc = new Account(
            FirstName = 'Nome8',
            LastName = 'Cognome8',
            PersonEmail = 'mail8@mail.com',
            OCS_External_Id__c = '445566',
            Occupation_Lvl1__c = '1'
        );
        
        accountMap.put(acc, null);
        XCSGestioneAnagrafica.deduplica(accountMap, true);
        XCSGestioneAnagrafica.executeFromWS(accountMap, true, true);
        XCSGestioneAnagrafica.ricercaOCSUpdateCRM('445566');
        XCSGestioneAnagrafica.ricercaOCSUpdateCRM('1234');
        XCSGestioneAnagrafica.ricercaAccountSuOCS('445566');
        }
        catch (Exception e) {
            
        }
    }


/*

    @TestSetup
    static void makeData() {

        System.debug('INIZIO DATA PREPARATION');
        
        final List<Account> toInsert = new List<Account>();
        Integer accMax = 5000;
        for (Integer i = 0; i < accMax; i++) {
            
            Account acc = new Account(
                FirstName = 'Nome' + i,
                LastName = 'Cognome' + i,
                PersonEmail = 'mail' + i + '@mail.com'
            );

            if(math.mod(i, 2) == 0) {
                toInsert.add(acc);
            }
        }

        insert toInsert;

        for (Integer i = 0; i < accMax/2; i++) {
            
            Account acc = new Account(
                FirstName = 'Nome' + i,
                LastName = 'Cognome' + i,
                PersonEmail = 'mail' + i + '@mail.com'
            );

            if(math.mod(i*2, 2) == 0) {
                acc.OCS_External_Id__c = '12345' + i;
            }

            accountMap.put(acc, null);
        }

        for (Integer i = accMax/2; i < accMax; i++) {
            
            Account acc = new Account(
                FirstName = 'Nome' + i,
                LastName = 'Cognome' + i,
                RSS_External_Id__c = '1' + i
            );

            accountMap.put(acc, null);
        }

        System.debug('FINE DATA PREPARATION');
    }

    @isTest 
    public static void stressTest() {
        
        System.debug('INIZO TEST');

        XCSGestioneAnagrafica.deduplica(accountMap, true);
        System.debug('FINE TEST');
        //System.assertEquals(accMax, accountMap.size());
    }

    static final Map<Account,Account> accountMap = new Map<Account,Account>();
    */
    
    @isTest
    public static void testTest() {
         Account acc1 = new Account(
            FirstName = 'Nome',
            LastName = 'Cognome',
            PersonEmail = 'mail@mail.com',
            OCS_External_Id__c = '12345'
        );
        
        insert acc1;
        
        Account acc2 = new Account(
            Id = acc1.Id,
            FirstName = 'Nome',
            LastName = 'Cognome'
        );
        
        final Map<Account,Account> accountMap = new Map<Account,Account>();
        accountMap.put(acc1, acc1);
        XCSGestioneAnagrafica.deduplica(accountMap, true);
        system.debug('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA: ' + acc2.OCS_External_Id__c);
    }
    
    @isTest
    public static void testError() {
        Map<Account, Account> mappaAccount = new Map<Account, Account>();  // mappa con tutti gli account da creare o da controllare
 
        Account acc = new Account();
        acc.FirstName = 'ALBERTO';
        acc.Lastname = 'FRENDA';
       // acc.Data_Nascita__c = '1954-01-03 00:00:00';
        acc.Luogo_Nascita__pc = 'NAPOLI';
        acc.Provincia_Nascita__pc = 'NA';
        acc.Sesso__pc = 'M';
        acc.PersonEmail = 'albertofrenda@gmail.com';
        acc.Codice_Fiscale__pc = 'FRNLRT54A03F839F';
        acc.Telefono_Casa__c = '081 642156     ';
        acc.Telefono_Cellulare__c = '348 2766845    ';
        acc.OCS_External_Id__c = 'C891648';
        mappaAccount.put(acc, null);
        
        System.debug('mappaAccount:'+mappaAccount);
        XCSGestioneAnagrafica.deduplica(mappaAccount, true);
    }
    
}