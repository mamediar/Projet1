@isTest
public class SFAPratIrregDataPostFILIALECntrollerTest {
    
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
        
        
        User u = [select DefaultQueueId__c from user where id=:userinfo.getuserid()][0];
        //Branch
        Account acc2 = new Account();
		String idRecordTypeBranch = [Select id from RecordType where name = 'Branch'][0].id;
		acc2.RecordTypeId = idRecordTypeBranch;
		acc2.name = 'BranchDiProva';   
        acc2.OCS_External_Id__c =u.DefaultQueueId__c;	
        acc2.BusinessEmail__c='prova@gmail.it';
        insert acc2; 

        string z =[select id from RecordType where Name = 'Person Account'][0].id;
        Account a2 = new Account();
        a2.LastName = 'Dummy';
        a2.FirstName = 'Dummy';
        a2.BusinessEmail__c = 'khadija.masrour@prova.it';
        a2.OCS_External_Id__c = 'N00000';
        a2.RecordTypeId = z;
        insert a2;
        
        
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
        insert P2;        
        
        XCS_CompassParameters__c obj = new XCS_CompassParameters__c();
        obj.Name = 'gdv.mail';
        obj.Value__c ='khadija@prtova.it';
        insert obj;  
        
        XCS_CompassParameters__c obj1 = new XCS_CompassParameters__c();
        obj1.Name = 'inviomail.mock';
        obj1.Value__c ='khadija@prova.it';
        insert obj1;         
        
        /*Folder[] folders = [select Id from Folder 
                            where AccessType IN: new list<String>{'Shared','Public'} 
                            AND Type = 'Email'];
        System.assert(!folders.isEmpty(),'test can\'t run wo Email Template folders. Folders can\'t be mocked in Apex');  */      
        
        
    }
    
    @isTest
    public static void disabilitaBottoneTest(){ 
        Id praticaId=[Select id from SFA_PraticaIrregolare__c where Status__c='Pratica - da Gestire'][0].id;
        SFAPraticheIrregDataPostFILIALECntroller.disabilitaBottone(praticaId);
        
    }
    
    @isTest
    public static void salvaDataPosticipoRichiestaFilialeTest(){ 
        Date posticipoDate=Date.today()+1;
        string dataPosticipoRichiestaString = string.valueOfGmt(posticipoDate);       
        //String dataPosticipoRichiestaString=scadenzaDate.toString(); 
        Id praticaId=[Select id from SFA_PraticaIrregolare__c where Status__c='Pratica - da Gestire'][0].id;
        SFAPraticheIrregDataPostFILIALECntroller.salvaDataPosticipoRichiestaFiliale(praticaId,dataPosticipoRichiestaString);
        
    }    
    
}