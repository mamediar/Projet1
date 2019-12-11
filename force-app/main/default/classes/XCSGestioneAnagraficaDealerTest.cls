@IsTest
public class XCSGestioneAnagraficaDealerTest {

    private static String dealerRecordTypeId = RecordTypeUtil.getDealerRecordType();
        
    @isTest 
    public static void test1() {

        // Ricerca per OCS ID e EMAIL non valida
        Account insAcc1 = new Account(
            RecordTypeID = dealerRecordTypeId,
            Name = 'Ragione Sociale 1',
            OCS_External_Id__c = '12345'
        );
        insert insAcc1;

        Contact cont1 = new Contact(
            AccountId = insAcc1.Id,
            LastName = insAcc1.Name,
            MobilePhone = insAcc1.Telefono_Cellulare__c
        );
        insert cont1;

        Account acc1 = new Account(
            RecordTypeID = dealerRecordTypeId,
            Name = 'Ragione Sociale 1',
            OCS_External_Id__c = '12345',
            BusinessEmail__c = 'fakemail'
        );

        // ricerca per P_IVA o CF
        Account insAcc2 = new Account(
           RecordTypeID = dealerRecordTypeId,
            Name = 'Ragione Sociale 2',
            Partita_IVA__c = 'ABC123',
            BusinessEmail__c = 'mail2@mail.com',
            Type_Anag__c = 'F',
            Tipo_Intermediario__c = 'CV'
        );
        insert insAcc2;

        Contact cont2 = new Contact(
            AccountId = insAcc2.Id,
            LastName = insAcc2.Name,
            Email = insAcc2.BusinessEmail__c,
            MobilePhone = insAcc2.Telefono_Cellulare__c
        );
        insert cont2;

        Account acc2 = new Account(
           RecordTypeID = dealerRecordTypeId,
            Name = 'Ragione Sociale 2',
            Partita_IVA__c = 'ABC123',
            BusinessEmail__c = 'mail2@mail.com',
            Type_Anag__c = 'F',
            Tipo_Intermediario__c = 'CV'
        );

        // nuovo
        Account acc3 = new Account(
           RecordTypeID = dealerRecordTypeId,
            Name = 'Ragione Sociale 3',
            Partita_IVA__c = 'ABC123456',
            BusinessEmail__c = 'mail3@mail.com'
        );

        final Map<Account, DealerAccount> accountMap = new Map<Account, DealerAccount>();
        accountMap.put(acc1, null);
        accountMap.put(acc2, null);
        accountMap.put(acc3, null);

        XCSGestioneAnagraficaDealer.execute(accountMap, true);

        for (Account acc : accountMap.keySet()) {
            System.debug('acc: ' + acc);
            System.debug('DealerAcc: ' + accountMap.get(acc));
        }

        System.assertEquals(3, accountMap.values().size());

        DealerAccount dealAccOut1 = accountMap.get(acc1);

        

        XCSGestioneAnagraficaDealer.execute(null, true);
        XCSGestioneAnagraficaDealer.executeFromWS(null, true);
        XCSRicercaAnagraficaDealer.ricercaPerOcsID(null); 
        XCSRicercaAnagraficaDealer.ricercaPerPIVAoCF(null);
        XCSAggiornaAnagraficaDealer.aggiorna(null, false, false);
        XCSCreazioneAnagraficaDealer.crea(null, false);
        
        Account acc0 = new Account(
            RecordTypeID = dealerRecordTypeId,
            OCS_External_Id__c = '82374654',
            Name = 'Nome0',
            BusinessEmail__c = 'mail0@mail.com',
            Telefono_Cellulare__c = '3674367239'
        );
        
        insert acc0;
        
        try { XCSGestioneAnagraficaDealer.ricercaOCSUpdateCRM('82374654'); } catch(Exception e) {}

        final Map<Account, DealerAccount> accountMap2 = new Map<Account, DealerAccount>();

        Account acc_1 = new Account(
            RecordTypeID = dealerRecordTypeId,
            OCS_External_Id__c = '82374654',
            Name = 'Nome1',
            BusinessEmail__c = 'mail1@mail.com',
            Telefono_Cellulare__c = '344367239'
        );

        Account acc_2 = new Account(
            RecordTypeID = dealerRecordTypeId,
            Name = 'Nome2',
            BusinessEmail__c = 'mail2@mail.com',
            Telefono_Cellulare__c = '3456675434'
        );

        Account acc_3 = new Account(
            RecordTypeID = dealerRecordTypeId,
            OCS_External_Id__c = '5237462',
            Name = 'Nome__3',
            BusinessEmail__c = 'mail__3@mail.com',
            Telefono_Cellulare__c = '30067239'
        );

        insert acc_3;

        Contact cont_3 = getContact(acc_3);
        insert cont_3;

        accountMap2.put(acc_1, null);
        accountMap2.put(acc_2, null);
        accountMap2.put(acc_3, null);

        XCSGestioneAnagraficaDealer.executeFromWS(accountMap2, true);
        XCSGestioneAnagraficaDealer.executeFromWS(accountMap2, false);
        
        
        
        System.assertNotEquals(null, dealAccOut1);
        System.assertNotEquals(null, dealAccOut1.account);
        System.assertNotEquals(null, dealAccOut1.contact);
        System.assertEquals('Ragione Sociale 1', dealAccOut1.account.Name);
        System.assertEquals('D12345', dealAccOut1.account.OCS_External_Id__c);
        System.assertEquals(null, dealAccOut1.account.BusinessEmail__c);
        System.assertEquals('fakemail', dealAccOut1.account.EmailNonConforme__c);
        System.assertNotEquals(null, dealAccOut1.contact.Id);
        System.assertEquals('Ragione Sociale 1', dealAccOut1.contact.LastName);

        DealerAccount dealAccOut2 = accountMap.get(acc2);
        System.assertNotEquals(null, dealAccOut2);
        System.assertNotEquals(null, dealAccOut2.account);
        System.assertNotEquals(null, dealAccOut2.contact);
        System.assertEquals('ABC123', dealAccOut2.account.Partita_IVA__c);
        System.assertEquals('mail2@mail.com', dealAccOut2.account.BusinessEmail__c);
        System.assertNotEquals(null, dealAccOut2.contact.Id);
        System.assertEquals('Ragione Sociale 2', dealAccOut2.contact.LastName);

        DealerAccount dealAccOut3 = accountMap.get(acc3);
        System.assertNotEquals(null, dealAccOut3);
        System.assertNotEquals(null, dealAccOut3.account);
        System.assertNotEquals(null, dealAccOut3.contact);
        System.assertEquals('Ragione Sociale 3', dealAccOut3.account.Name);
        System.assertNotEquals(null, dealAccOut3.account.Id);
        System.assertNotEquals(null, dealAccOut3.contact.Id);
        System.assertEquals('Ragione Sociale 3', dealAccOut3.contact.LastName);
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
        ApiRest__c apiRest = new ApiRest__c (
            Name = 'ocs.recuperaDatiPostvendita',
            EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute', 
            Method__c = 'POST', 
            Mock__c = false, 
            Password__c = 'P00FLSDC',
            Ref__c = 'CompassInternal', 
            User__c = 'CDSLF00'
        );
        insert apiRest;

        ApiUtil__c apiUti = new ApiUtil__c(
            Name = 'CompassInternal', 
            EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute', 
            Password__c = 'P00FLSDC', 
            Ref__c = 'CompassInternal', 
            User__c = 'CDSLF00'
        );
        insert apiUti;
        
        test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new OCSRecuperaDatiInvokerHttpCalloutMock());
        XCSGestioneAnagraficaDealer.ricercaOCSUpdateCRM('12345');
    }
    
    public class OCSRecuperaDatiInvokerHttpCalloutMock implements HttpCalloutMock {
        
        public HTTPResponse respond(HTTPRequest request) {
            // Create a fake response
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"resultCode": 0,"resultMessage": "Ok","OCSRecuperaDatiPostvenditaResponse": {"cliente":[{"codCliente":"12345","cognome":"lastname"}]}}');
			response.setStatusCode(200);
            return response; 
        }
    }

}