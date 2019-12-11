@isTest
public class SFA_VisualizzaRegistriClassApexTest {
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
            Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
            Account theAccount= new Account(
                LastName = 'test',
				OCS_External_id__c = 'F00-TEST',
				FirstName = 'test',
				Data_Nascita__c = Date.newInstance(2019,4,3),
				Luogo_Nascita__pc = 'test',
				Provincia_Nascita__pc = 'test',
				Sesso__pc = 'M',
				Codice_Fiscale__pc = 'tsttst',
				Partita_IVA__pc = 'test',
				PersonMailingStreet = 'test',
				PersonMailingPostalCode = '00010',
				PersonMailingCity = 'test',
				PersonMailingCountry = 'test',
				PersonEmail = 'test@test.com',
				Data_Rilascio__pc = Date.today(),
				Data_Scadenza__pc = Date.today(),
				Telefono_Casa__c = '001234500',
				Telefono_Cellulare__c = '3300123',
				Fax = '3300123',
				Ma_Opt_In__pc = true,
				Privacy_SMS__pc = true,
				Data_Depennamento__c = Date.today(),
				InvestFlag__pc = true,
				Qualitydetectionflag__pc = true,
				Interncommoffer__pc = true,
				Privacy_Profilazione__pc = true,
				Extcommoffer__pc = true,
				OtherService__pc = true,
            	RecordTypeId = recordTypeId);
            insert theAccount;
        }

        if([SELECT Id FROM SFA_NotaSpese__c WHERE ManagerApprovazione__r.Alias ='test'].size()==0){
            Account theAccount=[SELECT Id FROM Account WHERE OCS_External_id__c = 'F00-TEST'];
            User utenteMaster = [SELECT Id FROM User WHERE LastName = 'Test'];
            SFA_NotaSpese__c ns=new SFA_NotaSpese__c(
                Date__c=Date.today(),
                Time__c='AM',
                Branch__c=theAccount.Id,
                Status__c='Approvata',
                User__c=utenteMaster.Id,
                Tratta__c='test',
                OraInizioUscita__c=Time.newInstance(14, 30, 2, 20),
                OraFineUscita__c=Time.newInstance(15, 30, 2, 20),
                KmInizioUscita__c=1.00,
                KmFineUscita__c=2.00,
                TargaVeicolo__c='11TEST11',
                DataApprovazione__c=Date.today(),
                Note__c='test',
                KmRifornimento__c=2.00,
                LuogoRifornimento__c='test',
                ImportoRifornimento__c=1.00,
                ManagerApprovazione__c=utenteMaster.Id
            );
            insert ns;
        }

        if(([SELECT Id FROM SFA_Slot__c]).size()==0){
            User utenteMaster = [SELECT Id FROM User WHERE LastName = 'Test'];
            Account theAccount=[SELECT Id FROM Account WHERE OCS_External_id__c = 'F00-TEST'];
            SFA_Slot__c testSlot= new SFA_Slot__c(
                Type__c = 'B',
                Status__c = 'Valido',
                Date__c = Date.today(),
                Time__c = 'AM',
                User__c = utenteMaster.Id
            );
            testSlot.Branch__c = theAccount.Id;
            insert testSlot;
        }

        if([SELECT Id FROM SFA_PianificaAttivita__c].size()==0){
            SFA_Slot__c slot=[SELECT Id FROM SFA_Slot__c where Status__c='Valido'];
            Account theAccount=[SELECT Id FROM Account WHERE OCS_External_id__c = 'F00-TEST'];
            SFA_NotaSpese__c ns=[SELECT Id FROM SFA_NotaSpese__c WHERE ManagerApprovazione__r.Alias ='test'];
            SFA_PianificaAttivita__c pa=new SFA_PianificaAttivita__c(
                Dealer__c=theAccount.Id,
                SFA_Nota_Spese__c=ns.Id,
                SFA_Slot__c=slot.Id
            );
            insert pa;
        }
    }

    @isTest
    public static void initApexTest(){
        User u = [SELECT Id FROM User WHERE LastName = 'Test'];
        SFA_VisualizzaRegistriClassApex.initWrapper Iw;
        Test.startTest();
        System.runAs(u) {
            Iw=SFA_VisualizzaRegistriClassApex.initapex();
        }
        Test.stopTest();
        System.assertEquals(Date.today(),Iw.today);
        System.assertEquals(1,Iw.noteSpese.size());
        System.assertEquals(u.Id,Iw.actualUser.Id);
    }

    @isTest
    public static void searchNoteSpeseApexTest(){
        User u = [SELECT FirstName, LastName,Id,Name,DefaultQueueId__c FROM User WHERE LastName = 'Test'];
        List<SFA_NotaSpese__c> lista;
        Test.startTest();
        System.runAs(u){
            lista=SFA_VisualizzaRegistriClassApex.searchNoteSpeseApex(Date.today(),'11TEST11',u);
        }
        Test.stopTest();
        System.assertEquals(1,lista.size());
        System.assertEquals('test',lista[0].Note__c);
        }

    @isTest
    public static void updateNoteSpeseTest(){
        User u = [SELECT FirstName, LastName,Id,Name,DefaultQueueId__c FROM User WHERE LastName = 'Test'];
        List<SFA_NotaSpese__c> lista=[SELECT Id,Date__c,Time__c,Branch__c,Status__c,User__c,User__r.Alias, User__r.Name,Tratta__c,OraInizioUscita__c,OraFineUscita__c,KmInizioUscita__c,KmFineUscita__c,TargaVeicolo__c,DataApprovazione__c,Note__c,KmRifornimento__c,LuogoRifornimento__c,ImportoRifornimento__c,ManagerApprovazione__r.Alias,(SELECT Id,Dealer__c FROM Pianifica_Attivita__r) FROM SFA_NotaSpese__c];
        Test.startTest();
        System.runAs(u){
            lista=SFA_VisualizzaRegistriClassApex.updateNoteSpese(lista,u);
        }
        Test.stopTest();
        System.assertEquals(1,lista.size());
        System.assertEquals('Approvata',lista[0].Status__c);
    }
}