@isTest
public class XCSAggiornaAnagraficaTest {

    private static String personRecordTypeId  = RecordTypeUtil.getPersonRecordType();
        
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
            Codice_Fiscale__pc = 'AABB456CCDD00F',
            COD_Ateco__c = 'CBA'
        );
 
        insert acc2 ;
        
    }

    @isTest
    public static void aggiornaOCSAccountTest() {
        final Map<Account,Account> accountMap = new Map<Account,Account>();
        Account foundAcc1 = [SELECT FirstName, LastName, PersonEmail, Codice_Fiscale__pc FROM Account where FirstName = 'Nome1'];

        Account acc1 = new Account( 
            RecordTypeID = personRecordTypeId,
            FirstName = 'Nome_1',
            LastName = 'Cognome_1',
            PersonEmail = 'newmail1@mail.com',
            Codice_Fiscale__pc = 'AABB123CCDD00F'
        );

        Account foundAcc2 = [SELECT FirstName, LastName, PersonEmail, Codice_Fiscale__pc FROM Account where FirstName = 'Nome2'];

        Account acc2 = new Account( 
            RecordTypeID = personRecordTypeId,
            FirstName = 'Nome2',
            LastName = 'Cognome2',
            COD_Ateco__c = 'ABC',
            Desc_Ateco__c = 'ATECO'
        );

        Account acc3 = new Account( 
            RecordTypeID = personRecordTypeId,
            FirstName = 'Nome3',
            LastName = 'Cognome3',
            Codice_Fiscale__pc = 'CCBB456CCDD00F'
        );
        
        accountMap.put(acc1, foundAcc1);
        accountMap.put(acc2, foundAcc2);
        accountMap.put(acc3, null);

        XCSAggiornaAnagrafica.aggiorna(accountMap, true, false);

        System.assert(accountMap.get(acc3) == null);
        Account accOut1 = accountMap.get(acc1);
        Account accOut2 = accountMap.get(acc2);

        System.assertEquals('Nome_1', accOut1.FirstName);
        System.assertEquals('mail1@mail.com', accOut1.PersonEmail);

        System.assertEquals('Nome2', accOut2.FirstName);
        System.assertEquals('AABB456CCDD00F', accOut2.Codice_Fiscale__pc);
        System.assertEquals('ABC', accOut2.COD_Ateco__c);
        System.assertEquals('ATECO', accOut2.Desc_Ateco__c);
    }


    @isTest
    public static void aggiornaAltroAccountTest() {
        final Map<Account,Account> accountMap = new Map<Account,Account>();
        Account foundAcc1 = [SELECT FirstName, LastName, PersonEmail, Codice_Fiscale__pc FROM Account where FirstName = 'Nome1'];

        Account acc1 = new Account( 
            RecordTypeID = personRecordTypeId,
            FirstName = 'Nome_1',
            LastName = 'Cognome_1',
            PersonEmail = 'newmail1@mail.com',
            Codice_Fiscale__pc = 'AABB123CCDD00F'
        );

        Account foundAcc2 = [SELECT FirstName, LastName, PersonEmail, Codice_Fiscale__pc FROM Account where FirstName = 'Nome2'];

        Account acc2 = new Account( 
            RecordTypeID = personRecordTypeId,
            FirstName = 'NOME2',
            LastName = 'Cognome2',
            PersonEmail = 'fakemail#mail.com'
        );

        Account acc3 = new Account( 
            RecordTypeID = personRecordTypeId,
            FirstName = 'Nome3',
            LastName = 'Cognome3',
            Codice_Fiscale__pc = 'CCBB456CCDD00F'
        );
        
        accountMap.put(acc1, foundAcc1);
        accountMap.put(acc2, foundAcc2);
        accountMap.put(acc3, null);

        XCSAggiornaAnagrafica.aggiorna(accountMap, false, false);

        System.assert(accountMap.get(acc3) == null);
        Account accOut1 = accountMap.get(acc1);
        Account accOut2 = accountMap.get(acc2);

        System.assertEquals('Nome1', accOut1.FirstName);
        System.assertEquals('newmail1@mail.com', accOut1.PersonEmail);

        System.assertEquals('Nome2', accOut2.FirstName);
        System.assertEquals('AABB456CCDD00F', accOut2.Codice_Fiscale__pc);
        System.assertEquals(null, accOut2.PersonEmail);
        System.assertEquals('fakemail#mail.com', accOut2.EmailNonConforme__c);
    }
    
    @isTest
    public static void coverageTest() {
        XCSAggiornaAnagrafica.aggiorna(null, false, false);
    }
    
}