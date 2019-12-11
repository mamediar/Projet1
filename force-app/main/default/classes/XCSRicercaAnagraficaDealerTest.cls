@isTest
public class XCSRicercaAnagraficaDealerTest {

    private static String branchRecordTypeId = RecordTypeUtil.getBranchRecordType();
    private static String dealerRecordTypeId = RecordTypeUtil.getDealerRecordType();

    @isTest
    public static void ricercaPerOcsIDTest() {
        final Map<Account, DealerAccount> accountMap = new Map<Account, DealerAccount>();
 
        Account acc1 = new Account(
            RecordTypeID = dealerRecordTypeId,
            OCS_External_Id__c = '82374654',
            Name = 'Nome1',
            BusinessEmail__c = 'mail1@mail.com',
            Telefono_Cellulare__c = '12345'
        );
 
        insert acc1;

        Contact cont1 = getContact(acc1);
        insert cont1;

        Account acc2 = new Account(
            RecordTypeID = dealerRecordTypeId,
            OCS_External_Id__c = 'fake',
            Name = 'Nome3',
            BusinessEmail__c = 'mail3@mail.com'
        );

        // nessun insert

        Account acc3 = new Account(
            RecordTypeID = dealerRecordTypeId,
            OCS_External_Id__c = '4225434',
            Name = 'Nome3',
            BusinessEmail__c = 'mail3@mail.com'
        );

        insert acc3;

        Contact cont3 = getContact(acc3);
        insert cont3;

        Account acc4 = new Account(
            RecordTypeID = branchRecordTypeId,
            OCS_External_Id__c = '123445',
            Name = 'Nome4'
        );

        insert acc4;

        Contact cont4 = getContact(acc4);
        insert cont4;

        accountMap.put(acc1, null);
        accountMap.put(acc2, null);
        accountMap.put(acc3, null);
        accountMap.put(acc4, null);

        XCSRicercaAnagraficaDealer.ricercaPerOcsID(accountMap);

        System.assertEquals(4, accountMap.size());

        System.assert(accountMap.get(acc1) <> null);
        System.assert(accountMap.get(acc2) == null);
        System.assert(accountMap.get(acc3) <> null);
        System.assert(accountMap.get(acc4) == null);

        DealerAccount acc1out = accountMap.get(acc1);
        DealerAccount acc3out = accountMap.get(acc3);

        System.assertEquals('Nome1', acc1out.account.Name);
        System.assertEquals('Nome1', acc1out.contact.LastName);
        System.assertEquals('4225434', acc3out.account.OCS_External_Id__c);
        System.assertEquals('mail3@mail.com', acc3out.contact.Email);
    }


    @isTest
    public static void ricercaPerPIVAoCFTest() {
        final Map<Account, DealerAccount> accountMap = new Map<Account, DealerAccount>();

        // OCS_ID null, P_IVA <> null, Type_Anag__c = null, Tipo_Intermediario__c <> null
        Account acc1 = new Account( 
            RecordTypeID = dealerRecordTypeId,
            Name = 'Nome1',
            BusinessEmail__c = 'mail1@mail.com',
            Partita_IVA__c = 'AAABBBBCC'
        );
 
        insert acc1 ;

        Contact cont1 = getContact(acc1);
        insert cont1;

        // OCS_ID null, P_IVA <> null, Type_Anag__c <> 'A', Tipo_Intermediario__c = 'PV'
        Account acc2 = new Account(
            RecordTypeID = dealerRecordTypeId,
            Name = 'Nome2',
            BusinessEmail__c = 'mail2@mail.com',
            Codice_Fiscale__c = 'EEEFFFBB2344DDD',
            Type_Anag__c = 'F',
            Tipo_Intermediario__c = 'PV'
        );

        insert acc2;

        Contact cont2 = getContact(acc2);
        insert cont2;

        // OCS_ID null, P_IVA <> null, Type_Anag__c = 'A', Tipo_Intermediario__c <> 'PV'
        Account acc3 = new Account(
            RecordTypeID = dealerRecordTypeId,
            Name = 'Nome4',
            BusinessEmail__c = 'mail2@mail.com',
            Codice_Fiscale__c = 'EEEF678BB2344DDD',
            Type_Anag__c = 'A',
            Tipo_Intermediario__c = 'AG'
        );

        insert acc3;

        Contact cont3 = getContact(acc3);
        insert cont3;

        
        Account acc4 = new Account(
            RecordTypeID = dealerRecordTypeId,
            Name = 'Nome2',
            BusinessEmail__c = 'mail2@mail.com',
            Codice_Fiscale__c = 'EEEFFFBB2344DDD',
            Type_Anag__c = 'A',
            Tipo_Intermediario__c = 'AG'
        );

        accountMap.put(acc1, null);
        accountMap.put(acc2, null);
        accountMap.put(acc3, null);

        XCSRicercaAnagraficaDealer.ricercaPerPIVAoCF(accountMap);

        //System.assert(accountMap.get(acc1) == null);
       // System.assert(accountMap.get(acc2) <> null);

        DealerAccount acc2out = accountMap.get(acc2);
       // System.assertEquals('EEEFFFBB2344DDD', acc2out.account.Codice_Fiscale__pc);
    }

    private static Contact getContact(Account acc) {
        return new Contact(
            AccountId = acc.Id,
            LastName = acc.Name,
            Email = acc.BusinessEmail__c,
            MobilePhone = acc.Telefono_Cellulare__c
        );
    }
    
    

    @isTest
    public static void coverageTest() {
        
        Account acc1 = new Account( 
            RecordTypeID = dealerRecordTypeId,
            Name = 'Nome1',
            BusinessEmail__c = 'mail1@mail.com',
            Partita_IVA__c = 'AAABBBBCC'
        );
 
        insert acc1 ;

        Contact cont1 = getContact(acc1);
        insert cont1;
        
        XCSRicercaAnagraficaDealer.ricercaDealerAccount(acc1);
        
        XCSRicercaAnagraficaDealer.ricercaPerOcsID(null);
        XCSRicercaAnagraficaDealer.ricercaPerPIVAoCF(null);
    }

}