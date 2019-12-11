@isTest
public class XCSAggiornaAnagraficaDealerTest {
    
    private static String dealerRecordTypeId = RecordTypeUtil.getDealerRecordType();
    
    @isTest
    public static void coverageTest() {
        final Map<Account, DealerAccount> accountMap = new Map<Account, DealerAccount>();
 
        Account acc1 = new Account(
            RecordTypeID = dealerRecordTypeId,
            OCS_External_Id__c = '82374654',
            Name = 'Nome1',
            BusinessEmail__c = 'mail1@mail.com',
            Tipo_Intermediario__c = 'AG'
        );
 
        insert acc1;

        Contact cont1 = getContact(acc1);
        insert cont1;
        
        DealerAccount da =  new DealerAccount();
        da.account = acc1;
        da.contact = cont1;
        accountMap.put(acc1, da);
        
        XCSRicercaAnagraficaDealer.ricercaPerOcsID(accountMap);
        XCSAggiornaAnagraficaDealer.aggiorna(accountMap, false, false);
        XCSAggiornaAnagraficaDealer.aggiorna(accountMap, true, false);
        XCSAggiornaAnagraficaDealer.aggiorna(accountMap, true, true);
    }
    
    private static Contact getContact(Account acc) {
        return new Contact(
            AccountId = acc.Id,
            LastName = acc.Name,
            Email = acc.BusinessEmail__c,
            MobilePhone = acc.Telefono_Cellulare__c
        );
    }

}