@isTest
public class SFAPratIrregAllegatiFILIALECntrollerTest {

    @testSetup
    public static void setUp(){
        
   
        
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
            
            
            Date scadenzaDate=Date.today()+1;
            SFA_PraticaIrregolare__c P = new SFA_PraticaIrregolare__c();
            P.EsitoCaricamento__c = 'Pratica caricata';
            //P.IdElaborazione__c = cPadre.id;
            P.ActivityId__c=cFiglio.Id;
            P.Name = 'pratica_uno';
            P.CodiceDealer__c = 'd';
            P.CodicePv__c = 's';
            P.CodiceStatoDealer__c = 's';
            P.RagioneSociale__c = 'rag';
            P.NumeroPratica__c = 'pratica_uno';
            P.CodiceStatoPratica__c = '50';
            P.Dipendenza__c = 'm';
            P.Status__c = 'Pratica - da Gestire'; 
            //P.OwnerId=utenteFilialeTestConCoda.Id;
            P.DataTermineLavoro__c=scadenzaDate;
            P.DataInserimento__c=Date.today()+1;
            P.RiscontroFinale__c='occ';
            insert P; 
            
            SFA_PraticaIrregolare__c P2 = new SFA_PraticaIrregolare__c();
            P2.EsitoCaricamento__c = 'Pratica caricata';
            //P2.IdElaborazione__c = cPadre.id;
            P2.ActivityId__c=cFiglio.Id;
            P2.Name = 'pratica_due';
            P2.CodiceDealer__c = 'd';
            P2.CodicePv__c = 's';
            P2.CodiceStatoDealer__c = 's';
            P2.RagioneSociale__c = 'rag';
            P2.NumeroPratica__c = 'pratica_due';
            P2.CodiceStatoPratica__c = '50';
            P2.Dipendenza__c = 'm';
            P2.Status__c = 'Pratica - Gestita filiale'; 
            //P2.OwnerId=utenteFilialeTestConCoda.Id;
            P2.DataTermineLavoro__c=scadenzaDate;
            P2.DataInserimento__c=Date.today()-1;
            insert P2;       
            
            //Inserisci file 1 per pratica 1
            ContentVersion contentVersion1 = new ContentVersion(
              Title = 'Penguins',
              PathOnClient = 'Penguins.jpg',
              VersionData = Blob.valueOf('Test Content'),
              IsMajorVersion = true
            );
            insert contentVersion1;                
            
            //Inserisci file 2 per pratica 1
            ContentVersion contentVersion2 = new ContentVersion(
              Title = 'Penguins',
              PathOnClient = 'Penguins2.jpg',
              VersionData = Blob.valueOf('Test Content'),
              IsMajorVersion = true
            );
            insert contentVersion2; 
            
            //Inserisci file 1 per pratica 2
            ContentVersion contentVersion3 = new ContentVersion(
              Title = 'Penguins',
              PathOnClient = 'Penguins2.jpg',
              VersionData = Blob.valueOf('Test Content'),
              IsMajorVersion = true
            );
            insert contentVersion3;         
            //Inserisci file 2 per pratica 2
            ContentVersion contentVersion4 = new ContentVersion(
              Title = 'Penguins',
              PathOnClient = 'Penguins2.jpg',
              VersionData = Blob.valueOf('Test Content'),
              IsMajorVersion = true
            );
            insert contentVersion4;         
            
            List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId,CreatedDate FROM ContentDocument ORDER BY CreatedDate DESC];        
            //create ContentDocumentLink  record 
            ContentDocumentLink cdl = New ContentDocumentLink();
            cdl.LinkedEntityId = P.id;
            cdl.ContentDocumentId = documents[0].Id;
            cdl.shareType = 'I';
            insert cdl;
            //create ContentDocumentLink  record 
            ContentDocumentLink cdl2 = New ContentDocumentLink();
            cdl2.LinkedEntityId = P.id;
            cdl2.ContentDocumentId = documents[1].Id;
            cdl2.shareType = 'I';
            insert cdl2; 
            //create ContentDocumentLink  record 
            ContentDocumentLink cdl3 = New ContentDocumentLink();
            cdl3.LinkedEntityId = P2.id;
            cdl3.ContentDocumentId = documents[2].Id;
            cdl3.shareType = 'I';
            insert cdl3; 
            //create ContentDocumentLink  record 
            ContentDocumentLink cdl4 = New ContentDocumentLink();
            cdl4.LinkedEntityId = P2.id;
            cdl4.ContentDocumentId = documents[3].Id;
            cdl4.shareType = 'I';
            insert cdl4;  
            
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
    public static void getFilesTest(){ 
        Id praticaId=[Select id from SFA_PraticaIrregolare__c where Status__c='Pratica - da Gestire'][0].id;
        SFAPraticheIrregAllegatiFILIALECntroller.getFiles(praticaId);   
        Id praticaId2=[Select id from SFA_PraticaIrregolare__c where Status__c='Pratica - Gestita filiale'][0].id;
        SFAPraticheIrregAllegatiFILIALECntroller.getFiles(praticaId2);        
    }
    
    @isTest
    public static void UpdateFilesTest(){       
        /*User utenteFilialeTestConCoda=[SELECT id FROM User where LastName='UtenteFilialeTestConCoda'];
        User utenteFilialeTestSenzaCoda=[SELECT id FROM User where LastName='UtenteFilialeTestSenzaCoda']; */               
        Id praticaId=[Select id from SFA_PraticaIrregolare__c where Status__c='Pratica - da Gestire'][0].id;
        Id ContentDocumentIdFile=[Select id, ContentDocumentId from ContentDocumentLink where LinkedEntityId=:praticaId][0].ContentDocumentId;
        SFAPraticheIrregAllegatiFILIALECntroller.UpdateFiles(ContentDocumentIdFile,praticaId);   

    }       

    @isTest   
    public static void eliminaFilePassatoTest(){       
        Id praticaId=[Select id from SFA_PraticaIrregolare__c where Status__c='Pratica - Gestita filiale'][0].id;
        Id ContentDocumentIdFile=[Select id, ContentDocumentId from ContentDocumentLink where LinkedEntityId=:praticaId][0].ContentDocumentId;
        SFAPraticheIrregAllegatiFILIALECntroller.eliminaFilePassato(ContentDocumentIdFile,praticaId);
        Id praticaId2=[Select id from SFA_PraticaIrregolare__c where Status__c='Pratica - da Gestire'][0].id;
        Id ContentDocumentIdFile2=[Select id, ContentDocumentId from ContentDocumentLink where LinkedEntityId=:praticaId2][0].ContentDocumentId;
        SFAPraticheIrregAllegatiFILIALECntroller.eliminaFilePassato(ContentDocumentIdFile2,praticaId2);        
        
    }     

    @isTest   
    public static void disabilitaBottoneEliminaTest(){       
        String praticaId=[Select id from SFA_PraticaIrregolare__c where Status__c='Pratica - da Gestire'][0].id;
        SFAPraticheIrregAllegatiFILIALECntroller.disabilitaBottoneElimina(praticaId);   
        
    } 
    
    @isTest   
    public static void verificaSeFileCaricabileTest(){       
        String praticaId=[Select id from SFA_PraticaIrregolare__c where Status__c='Pratica - da Gestire'][0].id;
        SFAPraticheIrregAllegatiFILIALECntroller.verificaSeFileCaricabile(praticaId);   
        
    }     
    
}