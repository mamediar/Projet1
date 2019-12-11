@isTest
public class SFAPraticheIrregNoteFILIALECtrlTest {
    
    @testSetup
    static void setup(){
        
            String userId = UserInfo.getUserId(); 
            User currentUser = [SELECT Id, profileId FROM User WHERE Id = :UserInfo.getUserId()][0];

            //Profile standard user:
            Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Branch Employee' LIMIT 1];
            User utenteFilialeTestConCoda = new User(LastName = 'UtenteFilialeTestConCoda',
                                FirstName='JASON',
                                Alias = 'jliv',
                                Email = 'jason.liveston@asssdf.com',
                                Username = 'jason1.liveston@asssdf.com',  
                                ProfileId = profileId.id,
                                TimeZoneSidKey = 'GMT',
                                LanguageLocaleKey = 'en_US',
                                EmailEncodingKey = 'UTF-8',
                                DefaultQueueId__c='F32',                     
                                //UserRoleId=utenteUserRoleRegionalManager.Id,
                                LocaleSidKey = 'en_US'
                               );
            insert utenteFilialeTestConCoda;   
        
            User utenteFilialeTestSenzaCoda = new User(LastName = 'UtenteFilialeTestSenzaCoda',
                                FirstName='JASON',
                                Alias = 'jliv',
                                Email = 'jason.liveston@asssdf.com',
                                Username = 'jason2.liveston@asssdf.com',  
                                ProfileId = profileId.id,
                                TimeZoneSidKey = 'GMT',
                                LanguageLocaleKey = 'en_US',
                                EmailEncodingKey = 'UTF-8',
                                //UserRoleId=utenteUserRoleRegionalManager.Id,
                                LocaleSidKey = 'en_US'
                               );
            insert utenteFilialeTestSenzaCoda;  
        
        System.runAs(utenteFilialeTestConCoda) {
            Case cPadre = New Case();
            cPadre.ActivityType__c = 'SFA_PRAIRRPARENT';
            cPadre.Status='Closed';
            insert cPadre;    
            
            Case cFiglio = New Case();
            cFiglio.ActivityType__c = 'SFA_PRAIRR';
            cFiglio.Status='Closed';
            cFiglio.ParentId=cPadre.Id;
            insert cFiglio;         
        
        
            SFA_PraticaIrregolare__c pra = new SFA_PraticaIrregolare__c();
            pra.UltimaNotaInseritaDaFiliale__c = ('ciao');
            pra.EsitoCaricamento__c='Pratica caricata';
        	pra.ActivityId__c=cFiglio.Id;
            pra.CodiceDealer__c = ('32'); 
            pra.CodicePv__c = ('32');
            pra.CodiceStatoDealer__c = ('32');
            pra.RagioneSociale__c = ('32');
            pra.NumeroPratica__c = ('32');
            pra.CodiceStatoPratica__c = ('32');
            pra.Dipendenza__c= ('32');
            pra.DataTermineLavoro__c = date.today()+1;
            pra.Status__c =('Pratica - da Gestire');
            insert pra;            
        }
        
        System.runAs(utenteFilialeTestSenzaCoda) {
            Case cPadre = New Case();
            cPadre.ActivityType__c = 'SFA_PRAIRRPARENT';
            cPadre.Status='Closed';
            insert cPadre;    
            
            Case cFiglio = New Case();
            cFiglio.ActivityType__c = 'SFA_PRAIRR';
            cFiglio.Status='Closed';
            cFiglio.ParentId=cPadre.Id;
            insert cFiglio;         
        
        
            SFA_PraticaIrregolare__c pra = new SFA_PraticaIrregolare__c();
            pra.UltimaNotaInseritaDaFiliale__c = ('ciao');
            pra.EsitoCaricamento__c='Pratica caricata';
        	pra.ActivityId__c=cFiglio.Id;
            pra.CodiceDealer__c = ('33'); 
            pra.CodicePv__c = ('33');
            pra.CodiceStatoDealer__c = ('33');
            pra.RagioneSociale__c = ('33');
            pra.NumeroPratica__c = ('33');
            pra.CodiceStatoPratica__c = ('33');
            pra.Dipendenza__c= ('33');
            pra.DataTermineLavoro__c = date.today()+1;
            pra.Status__c =('Pratica - da Gestire');
            insert pra;             
            
        }
        
        System.runAs(currentUser) {
            
            Case cPadre = New Case();
            cPadre.ActivityType__c = 'SFA_PRAIRRPARENT';
            cPadre.Status='Closed';
            insert cPadre;    
            
            Case cFiglio = New Case();
            cFiglio.ActivityType__c = 'SFA_PRAIRR';
            cFiglio.Status='Closed';
            cFiglio.ParentId=cPadre.Id;
            insert cFiglio;         
        
        
            SFA_PraticaIrregolare__c pra = new SFA_PraticaIrregolare__c();
            pra.UltimaNotaInseritaDaFiliale__c = ('ciao');
            pra.EsitoCaricamento__c='Pratica caricata';
        	pra.ActivityId__c=cFiglio.Id;
            pra.CodiceDealer__c = ('31'); 
            pra.CodicePv__c = ('31');
            pra.CodiceStatoDealer__c = ('31');
            pra.RagioneSociale__c = ('31');
            pra.NumeroPratica__c = ('31');
            pra.CodiceStatoPratica__c = ('31');
            pra.Dipendenza__c= ('31');
            pra.DataTermineLavoro__c = date.today()+1;
            pra.Status__c =('Pratica - da Gestire');
            insert pra;

            
            //Inserisci file
            ContentNote contentNote1 = new ContentNote(
              Title = 'Penguins',
              Content = Blob.valueOf('Penguins.jpg')
            );
            insert contentNote1;
    
            List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId,CreatedDate FROM ContentDocument ORDER BY CreatedDate DESC];        
            //create ContentDocumentLink  record 
            ContentDocumentLink cdl = New ContentDocumentLink();
            cdl.LinkedEntityId = pra.id;
            cdl.ContentDocumentId = documents[0].Id;
            cdl.shareType = 'I';
            insert cdl;            
            
            
            
            XCS_CompassParameters__c obj = new XCS_CompassParameters__c();
            obj.Name = 'gdv.mail';
            obj.Value__c ='luca@prtova.it';
            insert obj;
            
                    
            XCS_CompassParameters__c obj1 = new XCS_CompassParameters__c();
            obj1.Name = 'inviomail.mock';
            obj.Value__c ='luca@prtova.it';
            insert obj1;         
            
            
        	Account acc = new Account();
        	acc.Name='Dummy1 Dummy1';
       	 	acc.Customer_Type__c='Compass';
        	acc.OwnerId=utenteFilialeTestConCoda.id;
            acc.OCS_External_Id__c = 'N00000';
        	insert acc;
        
            Contact cont = new Contact();
            cont.LastName = 'Dummy1';
            cont.FirstName = 'Dummy1';
        	cont.AccountId=acc.id;
            cont.email = 'luca@prova.it';
            insert cont; 
            
        	/*Account acc2 = new Account();
        	acc2.Name='Dummy2 Dummy2';
       	 	acc2.Customer_Type__c='Compass';
        	acc2.OwnerId=utenteFilialeTestSenzaCoda.id;
            acc2.OCS_External_Id__c = 'N00000';
        	insert acc2;
        
            Contact cont2 = new Contact();
            cont2.LastName = 'Dummy2';
            cont2.FirstName = 'Dummy2';
        	cont2.AccountId=acc2.id;
            insert cont2;*/  
            
            //Branch
            Account branch1 = new Account();
            String idRecordTypeBranch = [Select id from RecordType where name = 'Branch'][0].id;
            branch1.RecordTypeId = idRecordTypeBranch;
            branch1.name = 'BranchDiProva'; 
            branch1.BusinessEmail__c='khadija.masrour@lynxspa.com';
            branch1.OCS_External_Id__c = 'F32';	
            branch1.Customer_Type__c='Compass';
            branch1.OwnerId=utenteFilialeTestConCoda.id;
            insert branch1;     
            System.assert(branch1.id!=null,'branch non inserito');            
            
            
        }
        
    }
    
    @isTest
    public static void test (){
        
            //User currentUser = [SELECT Id, profileId FROM User WHERE Id = :UserInfo.getUserId()][0];
            User utenteFilialeTestConCoda=[SELECT id FROM User where LastName='UtenteFilialeTestConCoda'];
            User utenteFilialeTestSenzaCoda=[SELECT id FROM User where LastName='UtenteFilialeTestSenzaCoda'];
        
        
                   

        System.runAs(utenteFilialeTestConCoda) {  
            Id praId=[SELECT id from SFA_PraticaIrregolare__c where CodiceDealer__c='32'][0].id;
            SFAPraticheIrregNoteFILIALEController.getAllNotes(praId);
            
            User u = [select firstname, lastname, DefaultQueueId__c from user where id=:userinfo.getuserid()][0];
            List<Account> filialeUser = [SELECT id, Name, OCS_External_Id__c, RecordType.Name, BusinessEmail__c 
                           				 FROM Account WHERE RecordType.Name = 'Branch' AND OCS_External_Id__c = :u.DefaultQueueId__c];
            System.assert(!string.isEmpty(u.DefaultQueueId__c),'User non associato ad alcuna coda');
            System.assert(filialeUser.size()>0,'Nessuna filiale trovata associata alla coda di utente');        
            
            SFAPraticheIrregNoteFILIALEController.insertNote('', praId);    
            SFAPraticheIrregNoteFILIALEController.disabilitaBottone(praId);
        }
        
        Account acc = [SELECT Id, OwnerId FROM Account WHERE OCS_External_Id__c = 'N00000'][0];
        acc.OwnerId = utenteFilialeTestSenzaCoda.Id;
        update acc;
        
        System.runAs(utenteFilialeTestSenzaCoda) {  
            Id praId=[SELECT id from SFA_PraticaIrregolare__c where CodiceDealer__c='33'][0].id;
            SFAPraticheIrregNoteFILIALEController.getAllNotes(praId);
            User u = [select firstname, lastname, DefaultQueueId__c from user where id=:userinfo.getuserid()][0];
            List<Account> filialeUser = [SELECT id, Name, OCS_External_Id__c, RecordType.Name, BusinessEmail__c 
                           				 FROM Account WHERE RecordType.Name = 'Branch' AND OCS_External_Id__c = :u.DefaultQueueId__c];
            System.assert(string.isEmpty(u.DefaultQueueId__c),'User associato ad una coda');
            SFAPraticheIrregNoteFILIALEController.insertNote('', praId);            
            SFAPraticheIrregNoteFILIALEController.disabilitaBottone(praId);
        }        
                    
   

    }   
}