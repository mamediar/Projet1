@isTest
public class SFAPratIrregAllegatiGDVControllerTest {
    @testSetup
    public static void setUp(){
        
        Case cPadre = New Case();
        cPadre.ActivityType__c = 'SFA_PRAIRRPARENT';
        cPadre.Status='Closed';
        insert cPadre;    
        
        Case cFiglio = New Case();
        cFiglio.ActivityType__c = 'SFA_PRAIRR';
        cFiglio.Status='Closed';
        cFiglio.ParentId=cPadre.Id;
        insert cFiglio;         
        
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User utente = new User(LastName = 'LIVESTON',
                            FirstName='JASON',
                            Alias = 'jliv',
                            Email = 'jason.liveston@asssdf.com',
                            Username = 'jason1.liveston@asssdf.com',  
                            ProfileId = profileId.id,
                            TimeZoneSidKey = 'GMT',
                            LanguageLocaleKey = 'en_US',
                            EmailEncodingKey = 'UTF-8',
                            DefaultQueueId__c = 'F32',
                            LocaleSidKey = 'en_US'
                           );        
        insert utente;
        
        
        
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
        //P.OwnerId=utente.Id;
        P.DataTermineLavoro__c=scadenzaDate;
        P.DataInserimento__c=Date.today()+1;
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
        //P2.OwnerId=utente.Id;
        P2.DataTermineLavoro__c=scadenzaDate;
        P2.DataInserimento__c=Date.today()-1;
        insert P2;       
        
        //Inserisci file
        ContentVersion contentVersion1 = new ContentVersion(
          Title = 'Penguins',
          PathOnClient = 'Penguins.jpg',
          VersionData = Blob.valueOf('Test Content'),
          IsMajorVersion = true
        );
        insert contentVersion1;                
        
        //Inserisci file 2
        ContentVersion contentVersion2 = new ContentVersion(
          Title = 'Penguins',
          PathOnClient = 'Penguins2.jpg',
          VersionData = Blob.valueOf('Test Content'),
          IsMajorVersion = true
        );
        insert contentVersion2;  
        
        
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
      
        
        
    }
    
    
    @isTest
    public static void getFilesTest(){ 
        Id praticaId=[Select id from SFA_PraticaIrregolare__c where Status__c='Pratica - da Gestire'][0].id;
        SFAPraticheIrregAllegatiGDVController.getFiles(praticaId);   
        Id praticaId2=[Select id from SFA_PraticaIrregolare__c where Status__c='Pratica - Gestita filiale'][0].id;
        SFAPraticheIrregAllegatiGDVController.getFiles(praticaId2);        
    }
    
    @isTest
    public static void UpdateFilesTest(){       
        Id praticaId=[Select id from SFA_PraticaIrregolare__c where Status__c='Pratica - da Gestire'][0].id;
        Id ContentDocumentIdFile=[Select id, ContentDocumentId from ContentDocumentLink where LinkedEntityId=:praticaId][0].ContentDocumentId;
        SFAPraticheIrregAllegatiGDVController.UpdateFiles(ContentDocumentIdFile,praticaId);   
    
    }       

    @isTest
    public static void eliminaFilePassatoTest(){       
        Id praticaId=[Select id from SFA_PraticaIrregolare__c where Status__c='Pratica - da Gestire'][0].id;
        Id ContentDocumentIdFile=[Select id, ContentDocumentId from ContentDocumentLink where LinkedEntityId=:praticaId][0].ContentDocumentId;
        SFAPraticheIrregAllegatiGDVController.eliminaFilePassato(ContentDocumentIdFile,praticaId);   
        
    }     
    
}