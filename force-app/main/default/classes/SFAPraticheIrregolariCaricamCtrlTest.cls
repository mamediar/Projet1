@isTest
public class SFAPraticheIrregolariCaricamCtrlTest {
 
   
    @testSetup
    public static void setUp(){  

        //Profile standard user:
        Profile profileId = [SELECT Id,PermissionsEmailMass, PermissionsEmailSingle FROM Profile WHERE Name =:ProfileUtils.MonitoraggioDealer][0];
        System.assert(profileId.PermissionsEmailMass);
        System.assert(profileId.PermissionsEmailSingle); 
        
               
        //utente Regional Manager:
        /*UserRole utenteUserRoleRegionalManager = new UserRole();
        utenteUserRoleRegionalManager.Name='UserRoleUtente';
        insert utenteUserRoleRegionalManager; 
        User utenteRegionalManager = new User(LastName = 'LIVESTON',
                            FirstName='JASON',
                            Alias = 'jliv',
                            Email = 'jason.liveston@asssdf.com',
                            Username = 'jason1.liveston@asssdf.com',  
                            ProfileId = profileId.id,
                            TimeZoneSidKey = 'GMT',
                            LanguageLocaleKey = 'en_US',
                            EmailEncodingKey = 'UTF-8',
                            DefaultQueueId__c = 'F32',
                            UserRoleId=utenteUserRoleRegionalManager.Id,
                            LocaleSidKey = 'en_US'
                           );
        insert utenteRegionalManager;
        
        
        
        //utente Coordinatore Area:
        UserRole utenteUserRoleCoordinatoreArea = new UserRole();
        utenteUserRoleCoordinatoreArea.Name='UserRoleUtente';  
        utenteUserRoleCoordinatoreArea.ParentRoleId=utenteUserRoleRegionalManager.Id;
        insert utenteUserRoleCoordinatoreArea; 
        User utenteCoordinatoreArea = new User(LastName = 'LIVESTON',
                            FirstName='JASON',
                            Alias = 'jliv',
                            Email = 'jason.liveston@asssdf.com',
                            Username = 'jason2.liveston@asssdf.com',  
                            ProfileId = profileId.id,
                            TimeZoneSidKey = 'GMT',
                            LanguageLocaleKey = 'en_US',
                            EmailEncodingKey = 'UTF-8',
                            DefaultQueueId__c = 'F32',
                            UserRoleId=utenteUserRoleCoordinatoreArea.Id,
                            LocaleSidKey = 'en_US'
                           );
        insert utenteCoordinatoreArea;       
        
        //utente Manager Filiale:
        UserRole utenteUserRoleManagerFiliale = new UserRole();
        utenteUserRoleManagerFiliale.Name='UserRoleUtente';  
        utenteUserRoleManagerFiliale.ParentRoleId=utenteUserRoleCoordinatoreArea.Id;
        insert utenteUserRoleManagerFiliale; 
        User utenteManagerFiliale = new User(LastName = 'LIVESTON',
                            FirstName='JASON',
                            Alias = 'jliv',
                            Email = 'jason.liveston@asssdf.com',
                            Username = 'jason3.liveston@asssdf.com',  
                            ProfileId = profileId.id,
                            TimeZoneSidKey = 'GMT',
                            LanguageLocaleKey = 'en_US',
                            EmailEncodingKey = 'UTF-8',
                            DefaultQueueId__c = 'F32',
                            UserRoleId=utenteUserRoleManagerFiliale.Id,
                            LocaleSidKey = 'en_US'
                           );
        insert utenteManagerFiliale;*/     
        
        //utente filiale:
        UserRole utenteUserRoleUtenteFiliale = new UserRole();
        utenteUserRoleUtenteFiliale.Name='UserRoleUtente';  
        //utenteUserRoleUtenteFiliale.ParentRoleId=utenteUserRoleCoordinatoreArea.Id;
        insert utenteUserRoleUtenteFiliale; 
        User utenteFiliale = new User(LastName = 'LIVESTON',
                            FirstName='JASON',
                            Alias = 'jliv',
                            Email = 'jason.liveston@asssdf.com',
                            Username = 'jason4.liveston@asssdf.com',  
                            ProfileId = profileId.id,
                            TimeZoneSidKey = 'GMT',
                            LanguageLocaleKey = 'en_US',
                            EmailEncodingKey = 'UTF-8',
                            DefaultQueueId__c = 'F32',
                            UserRoleId=utenteUserRoleUtenteFiliale.Id,
                            LocaleSidKey = 'en_US'
                           );
        insert utenteFiliale; 
        
          
        
    
       
        
        System.runAs(utenteFiliale) {
            
        //Insert Dummy Account
            /*Contact a2 = new Contact();
            a2.LastName = 'Dummy';
            a2.FirstName = 'Dummy';
            insert a2;*/

            /*string z =[select id from RecordType where Name = 'Person Account'][0].id;
            Account a2 = new Account();
            a2.LastName = 'Dummy';
            a2.FirstName = 'Dummy';
            a2.BusinessEmail__c = 'khadija.masrour@prova.it';
            a2.RecordTypeId = z;
            a2.OCS_External_Id__c = 'N00000';
            insert a2; */            
            
            Contact con = new Contact();
            con.FirstName = 'firstName';
            con.LastName = 'lastName';
            con.Email = 'email@gmail.com';
            con.Phone = 'phone';
            insert con;            

            Case cPadre = New Case();
            cPadre.ActivityType__c = 'SFA_PRAIRRPARENT';
            cPadre.Status='Closed';
            insert cPadre;  
            
            Case cFiglio = New Case();
            cFiglio.ActivityType__c = 'SFA_PRAIRR';
            cFiglio.Status='Closed';
            cFiglio.ParentId=cPadre.Id;
            insert cFiglio;  
            
            Case cFiglio2 = New Case();
            cFiglio2.ActivityType__c = 'SFA_PRAIRR';
            cFiglio2.Status='Closed';
            cFiglio2.ParentId=cPadre.Id;
            insert cFiglio2; 
            
            //Branch
            Account branch1 = new Account();
            String idRecordTypeBranch = [Select id from RecordType where name = 'Branch'][0].id;
            branch1.RecordTypeId = idRecordTypeBranch;
            branch1.name = 'BranchDiProva'; 
            branch1.BusinessEmail__c='khadija.masrour@lynxspa.com';
            branch1.OCS_External_Id__c = 'F32';		        
            insert branch1;     
                    
            
            //Dealer 1 associated to branch1
            Account acc1 = new Account();
            String idRecordTypeDealer = [Select id from RecordType where name = 'Dealer'][0].id;
            acc1.RecordTypeId = idRecordTypeDealer;
            acc1.name = 'DealerDiProva';   
            acc1.OCS_External_Id__c = 'D123';
            acc1.Branch__r=branch1;
            insert acc1;
            
            //Dealer 2 associated to branch1
            Account d2 = new Account();
            d2.RecordTypeId = idRecordTypeDealer;
            d2.name = 'DealerDiProva';   
            d2.OCS_External_Id__c = 'D124';
            d2.Branch__r=branch1;
            insert d2;            
            
            
            SFA_PraticaIrregolare__c P = new SFA_PraticaIrregolare__c();
            P.EsitoCaricamento__c = 'Pratica caricata';
            //P.IdElaborazione__c = cPadre.id;
            P.Name = '123';
            P.CodiceDealer__c = '123';
            P.ActivityId__c = cFiglio.id;
            P.CodicePv__c = 's';
            P.CodiceStatoDealer__c = 's';
            P.RagioneSociale__c = 'rag';
            P.NumeroPratica__c = '123';
            P.CodiceStatoPratica__c = '50';
            P.Dipendenza__c = 'm';
            P.Status__c = 'Pratica - da Gestire';            
            insert P; 
            
            SFA_PraticaIrregolare__c P2 = new SFA_PraticaIrregolare__c();
            P2.EsitoCaricamento__c = 'Pratica caricata';
            //P2.IdElaborazione__c = cPadre.id;
            P2.Name = '124';
            P2.CodiceDealer__c = '124';
            P2.ActivityId__c = cFiglio2.id;
            P2.CodicePv__c = 's';
            P2.CodiceStatoDealer__c = 's';
            P2.RagioneSociale__c = 'rag';
            P2.NumeroPratica__c = '124';
            P2.CodiceStatoPratica__c = '50';
            P2.Dipendenza__c = 'm';
            P2.Status__c = 'Pratica - da Gestire';            
            insert P2;            

            XCS_CompassParameters__c obj1 = new XCS_CompassParameters__c();
            obj1.Name = 'inviomail.mock';
            obj1.Value__c ='khadija@hotmail.it';
            insert obj1;            
            
            /*Folder[] folders = [select Id from Folder 
                                where AccessType IN: new list<String>{'Shared','Public'} 
                                AND Type = 'Email'];
            System.assert(!folders.isEmpty(),'test can\'t run wo Email Template folders. Folders can\'t be mocked in Apex');*/
            
                  
            
         
            
        }
    }
    
    
    @isTest
    public static void checkFlagInvioEmailTest(){
        string z =[select id from RecordType where Name = 'Person Account'][0].id;
            Account a2 = new Account();
            a2.LastName = 'Dummy';
            a2.FirstName = 'Dummy';
            a2.BusinessEmail__c = 'khadija.masrour@prova.it';
            a2.RecordTypeId = z;
            a2.OCS_External_Id__c = 'N00000';
            insert a2; 
        //setUp();
        SFAPraticheIrregolariCaricamController.checkFlagInvioEmail();
    }
    
    @isTest
    public static void insertFileTest(){
        string z =[select id from RecordType where Name = 'Person Account'][0].id;
            Account a2 = new Account();
            a2.LastName = 'Dummy';
            a2.FirstName = 'Dummy';
            a2.BusinessEmail__c = 'khadija.masrour@prova.it';
            a2.RecordTypeId = z;
            a2.OCS_External_Id__c = 'N00000';
            insert a2; 
        string data = '2001-04-05'; 
        SFAPraticheIrregolariCaricamController.insertFile('testo','titolo','txt',data);
        SFAPraticheIrregolariCaricamController.insertFile('testo','titolo','txt',null);
    }
    
    @isTest
    public static void chiudiCasoConErroreTest(){
        string z =[select id from RecordType where Name = 'Person Account'][0].id;
            Account a2 = new Account();
            a2.LastName = 'Dummy';
            a2.FirstName = 'Dummy';
            a2.BusinessEmail__c = 'khadija.masrour@prova.it';
            a2.RecordTypeId = z;
            a2.OCS_External_Id__c = 'N00000';
            insert a2; 
        //setUp();
        Id caseId=[Select id from Case where ActivityType__c = 'SFA_PRAIRRPARENT'][0].id;
        System.debug('TEST @@@@@@@@@@@@@@@@@@@@ caseId:'+caseId);
        SFAPraticheIrregolariCaricamController.chiudiCasoConErrore(caseId);
        SFAPraticheIrregolariCaricamController.chiudiCasoConErrore(null);
    }    
    
    @isTest
    public static void createCasesTest(){      
        string z =[select id from RecordType where Name = 'Person Account'][0].id;
            Account a2 = new Account();
            a2.LastName = 'Dummy';
            a2.FirstName = 'Dummy';
            a2.BusinessEmail__c = 'khadija.masrour@prova.it';
            a2.RecordTypeId = z;
            a2.OCS_External_Id__c = 'N00000';
            insert a2; 
        Date data = date.today();     
        ContentVersion file = new ContentVersion();
        file.Title = 'Test';
        file.ContentUrl = 's';
        insert file;  
        String fileId=file.Id;
        SFAPraticheIrregolariCaricamController.createCases(fileId,data);
    }
    
    @isTest
    public static void checkLoadingStatusTest(){
        string z =[select id from RecordType where Name = 'Person Account'][0].id;
            Account a2 = new Account();
            a2.LastName = 'Dummy';
            a2.FirstName = 'Dummy';
            a2.BusinessEmail__c = 'khadija.masrour@prova.it';
            a2.RecordTypeId = z;
            a2.OCS_External_Id__c = 'N00000';
            insert a2; 
                
        //setUp();        
        SFAPraticheIrregolariCaricamController.checkLoadingStatus();
    }
    
    
    @isTest
    public static void recuperaIndirizziEmailTest(){
        string z =[select id from RecordType where Name = 'Person Account'][0].id;
            Account a2 = new Account();
            a2.LastName = 'Dummy';
            a2.FirstName = 'Dummy';
            a2.BusinessEmail__c = 'khadija.masrour@prova.it';
            a2.PersonEmail = 'khadija.masrour@prova.it';
            a2.RecordTypeId = z;
            a2.OCS_External_Id__c = 'N00000';
            insert a2;
        
        /*Contact con = new Contact();
            con.FirstName = 'Dummy';
            con.LastName = 'Dummy';
            con.Email = 'email@gmail.com';
            //con.Phone = 'phone';
            con.AccountId = a2.Id;
            insert con; */

        //setUp();
        SFAPraticheIrregolariCaricamController.recuperaIndirizziEmail();
    }    
    
    
    
    @isTest
    
    public static void assegnaPraticheEAttivitaAllaCodaeInviaEmail(){
        
        string z =[select id from RecordType where Name = 'Person Account'][0].id;
            Account a2 = new Account();
            a2.LastName = 'Dummy';
            a2.FirstName = 'Dummy';
            a2.BusinessEmail__c = 'khadija.masrour@prova.it';
            a2.RecordTypeId = z;
            a2.OCS_External_Id__c = 'N00000';
            insert a2; 
        
        //setUp();
        Map<String,String> emailFiliali = new Map<String,String>();
        emailFiliali.put('Name1','Email1');
        Map<String,String> emailCoordinatoriArea = new Map<String,String>();
        emailCoordinatoriArea.put('Name1','Email1');
        Map<String,String> emailRegionalManager = new Map<String,String>();
        emailRegionalManager.put('Name1','Email1');              
        SFAPraticheIrregolariCaricamController.assegnaPraticheEAttivitaAllaCodaeInviaEmail(emailFiliali,emailCoordinatoriArea,emailRegionalManager);

 
    }


}