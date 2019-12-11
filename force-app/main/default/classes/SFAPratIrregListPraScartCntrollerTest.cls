@isTest
public class SFAPratIrregListPraScartCntrollerTest {
    
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
        
        SFA_PraticaIrregolare__c P = new SFA_PraticaIrregolare__c();
        P.EsitoCaricamento__c = 'Pratica scaricata';
        //P.IdElaborazione__c = cPadre.id;
        P.ActivityId__c=cFiglio.Id;
        P.Name = 'pratica_uno';
        P.CodiceDealer__c = 'd';
        P.CodicePv__c = 's';
        P.CodiceStatoDealer__c = 's';
        P.RagioneSociale__c = 'rag';
        P.NumeroPratica__c = '123';
        P.CodiceStatoPratica__c = '50';
        P.Dipendenza__c = 'm';
        P.Status__c = 'Pratica - da Gestire'; 
        //P.OwnerId=utente.Id;
        insert P;        
    }
    
    
    @isTest
    public static void getAllPraticheTest(){
   
  
        Id caseId=[Select id from Case where ActivityType__c = 'SFA_PRAIRRPARENT'][0].id;
        SFAPraticheIrregListPraScartateCntroller.getAllPratiche(caseId);
    }   
    
}