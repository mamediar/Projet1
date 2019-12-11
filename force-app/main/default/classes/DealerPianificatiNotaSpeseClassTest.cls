@isTest
private class DealerPianificatiNotaSpeseClassTest {
	
	@TestSetup
    static void setup(){   
        if(([SELECT Id FROM User WHERE DefaultQueueId__c = 'F00-TEST']).size()==0){
            Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
            User utenteMaster = new User(
                FirstName= 'Test',
                LastName= 'Test',
                Username= 'test@compass.com.test',
                Email= 'test@lynxspa.com',
                Alias= 'test',
                TimeZoneSidKey= 'Europe/Rome',
                LocaleSidKey= 'it_IT',
                EmailEncodingKey= 'ISO-8859-1',
                ProfileId= p.Id,
                LanguageLocaleKey= 'en_US',
                DefaultQueueId__c= 'F00-TEST'
            );
            insert utenteMaster;
        }


        if(([SELECT Id FROM Account WHERE OCS_External_Id__c = 'F00-TEST']).size()==0){
            Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Branch').getRecordTypeId();
            
            Account Venezia= new Account(
                Name= 'VENEZIA', 
                OCS_External_Id__c = 'F00-TEST',
                RecordTypeId = recordTypeId,
                Type = 'FIL'
            );
            insert Venezia;
        }

        if(([SELECT Id FROM Zone__c WHERE Name= 'Venezia']).size()==0){
            Zone__c zona = new Zone__c(
                Name= 'Venezia'
            );
            zona.Branch__r  = new Account(OCS_External_Id__c= 'F00-TEST');
            insert zona;
        }

		//dealer
		if(([SELECT Id FROM Account WHERE OCS_External_Id__c = '00DEALER']).size()==0){
            Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId();
            Zone__c zona = [SELECT Id FROM Zone__c WHERE Name= 'Venezia'];

            Account dealer = new Account(
                Name = 'Dealer', 
                OCS_External_Id__c = '00DEALER',
                RecordTypeId = recordTypeId,
				Vat_Code__c = '0000000000',
				Zone__c = zona.Id
            );

            insert dealer;
        }
        
        if(([SELECT Id FROM SFA_Slot__c]).size()==0){
            Account branch = [SELECT Id FROM Account WHERE OCS_External_Id__c = 'F00-TEST'];
            User utente = [SELECT Id FROM User WHERE LastName= 'Test'];
            Zone__c zona = [SELECT Id FROM Zone__c WHERE Name= 'Venezia'];
            SFA_Slot__c slot = new SFA_Slot__c(
                Date__c= Date.Today(),
                Time__c= 'PM',
                Status__c= 'Valido',
				Branch__c = branch.Id,
           		User__c = utente.Id,
				XCS_Zone__c = zona.Id
            );
            
			SFA_Slot__c slot1 = new SFA_Slot__c(
                Date__c= Date.Today().addDays(10),
                Time__c= 'AM',
                Status__c= 'Valido',
				Branch__c = branch.Id,
				User__c = utente.Id,
				XCS_Zone__c = zona.Id
            );

			SFA_Slot__c slot2 = new SFA_Slot__c(
                Date__c= Date.Today().addDays(20),
                Time__c= 'AM',
                Status__c= 'Valido',
				Branch__c = branch.Id,
				User__c = utente.Id,
				XCS_Zone__c = zona.Id,
				Type__c = 'B'
            );
            
            
            insert new List<SFA_Slot__c>{slot,slot1,slot2};
        }
        
        if(([SELECT Id FROM SFA_NotaSpese__c]).size()==0){
            Account branch = [SELECT Id FROM Account WHERE OCS_External_Id__c = 'F00-TEST'];
            User utente = [SELECT Id FROM User WHERE LastName= 'Test'];
            SFA_NotaSpese__c notaSpese = new SFA_NotaSpese__c(
                Date__c= Date.today(),
                Time__c= 'PM',
                Status__c= 'Aperta',
				Branch__c = branch.Id,
				User__c = utente.Id
            );

            SFA_NotaSpese__c notaSpese2 = new SFA_NotaSpese__c(
                Date__c= Date.today(),
                Time__c= 'AM',
                Status__c= 'Aperta',
				Branch__c = branch.Id,
				User__c = utente.Id
            );
            
            insert new List<SFA_NotaSpese__c>{notaSpese,notaSpese2};
        }
        
        if(([SELECT Id FROM SFA_PianificaAttivita__c]).size()==0){
            Account dealer = [SELECT Id FROM Account WHERE Name = 'Dealer'];
            List<SFA_NotaSpese__c> notaSpese = [SELECT Id FROM SFA_NotaSpese__c WHERE Status__c= 'Aperta'];
            SFA_Slot__c slot = [SELECT Id FROM SFA_Slot__c WHERE Time__c = 'PM'];
            
            SFA_PianificaAttivita__c pa1 = new SFA_PianificaAttivita__c(
				SFA_Nota_Spese__c = notaSpese[0].Id,
				SFA_Slot__c = slot.Id,
				Dealer__c = dealer.Id
			);
            
            SFA_PianificaAttivita__c pa2 = new SFA_PianificaAttivita__c(
				SFA_Nota_Spese__c = notaSpese[1].Id,
				SFA_Slot__c = slot.Id,
				Dealer__c = dealer.Id
			);
            
            insert new List<SFA_PianificaAttivita__c>{pa1,pa2};
        }
        
    }

	@isTest static void initApexTest() {
        User u = [SELECT Id,DefaultQueueId__c FROM User WHERE LastName = 'Test'];
		Zone__c zona = [SELECT Id FROM Zone__c WHERE Name= 'Venezia'];
		DealerPianificatiNotaSpeseClass.InitWrapper Wr;
		SFA_NotaSpese__c notaSpese = [SELECT Id FROM SFA_NotaSpese__c WHERE Status__c= 'Aperta' AND Time__c= 'AM'];
        Test.startTest();
		System.runAs(u) {
            Wr = DealerPianificatiNotaSpeseClass.initApex(notaSpese,null);
		}
		Test.stopTest();
        System.assertEquals(1,Wr.dealers.size());   
		System.assertEquals(2,Wr.otherSlotsMap.get(zona.Id).size());   
	}

	@isTest static void ripianificaDealerApexTest() {
        User u = [SELECT Id,DefaultQueueId__c FROM User WHERE LastName = 'Test'];
		SFA_Slot__c newSlot = [SELECT Id,Date__c,Time__c,Branch__c,Status__c,User__c,XCS_Zone__c,(SELECT Id , Dealer__c FROM Attivita_Pianificate__r ORDER BY CreatedDate DESC) FROM SFA_Slot__c WHERE Time__c = 'AM' AND Type__c = 'B'];
		List<Account> dealerList = [SELECT Id FROM Account WHERE OCS_External_Id__c = '00DEALER'];
		SFA_NotaSpese__c notaSpese = [SELECT Id FROM SFA_NotaSpese__c WHERE Status__c= 'Aperta' AND Time__c= 'AM'];
		SFA_PianificaAttivita__c newPA;
		Test.startTest();
		System.runAs(u) {
			DealerPianificatiNotaSpeseClass.InitWrapper Wr = DealerPianificatiNotaSpeseClass.initApex(notaSpese,null);
			Map<String,SFA_PianificaAttivita__c> attivitaPerDealer = Wr.pianificaAttivitaPerDealer;
			DealerPianificatiNotaSpeseClass.ripianificaDealerApex(attivitaPerDealer,newSlot,dealerList);
			newPA = [SELECT Id,Dealer__c,Dealer__r.OCS_External_Id__c FROM SFA_PianificaAttivita__c WHERE SFA_Slot__c =: newSlot.Id];
		}
		Test.stopTest();
        System.assertEquals('00DEALER',newPA.Dealer__r.OCS_External_Id__c);     
	}

    @isTest static void addDealerApexTest() {
        User u = [SELECT Id,DefaultQueueId__c FROM User WHERE LastName = 'Test'];
		Account theDealer = [SELECT Id FROM Account WHERE OCS_External_Id__c = '00DEALER'];
        SFA_NotaSpese__c theNotaSpese = [SELECT Id FROM SFA_NotaSpese__c WHERE Status__c= 'Aperta' AND Time__c= 'AM'];
        List<SFA_PianificaAttivita__c> newPA;
        Test.startTest();
		System.runAs(u) {
            DealerPianificatiNotaSpeseClass.addDealerApex(theDealer,theNotaSpese);
            newPA = [SELECT Id,Dealer__c FROM SFA_PianificaAttivita__c WHERE SFA_Nota_Spese__c =: theNotaSpese.Id AND Dealer__c =: theDealer.Id];
        }
		Test.stopTest();
        System.assertEquals(theDealer.Id,newPA[1].Dealer__c);     
	}

    @isTest static void deleteAttivitaDealerNonVisitatiTest() {
        User u = [SELECT Id,DefaultQueueId__c FROM User WHERE LastName = 'Test'];
        Account theDealer = [SELECT Id FROM Account WHERE OCS_External_Id__c = '00DEALER'];
        SFA_NotaSpese__c theNotaSpese = [SELECT Id FROM SFA_NotaSpese__c WHERE Status__c= 'Aperta' AND Time__c= 'AM'];
        List<SFA_PianificaAttivita__c> paList = [SELECT Id,Dealer__c FROM SFA_PianificaAttivita__c WHERE SFA_Nota_Spese__c =: theNotaSpese.Id AND Dealer__c =: theDealer.Id];
        Test.startTest();
		System.runAs(u) {
            DealerPianificatiNotaSpeseClass.deleteAttivitaDealerNonVisitati(paList);
            paList = [SELECT Id,Dealer__c FROM SFA_PianificaAttivita__c WHERE SFA_Nota_Spese__c =: theNotaSpese.Id AND Dealer__c =: theDealer.Id];
        }
		Test.stopTest();
        System.assertEquals(0,paList.size());     
	}
}