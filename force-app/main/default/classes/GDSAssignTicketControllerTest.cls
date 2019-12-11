@isTest
public class GDSAssignTicketControllerTest 
{
    @testSetup
    static void setup(){
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c='{"resultCode":0,"resultMessage":"Ok",OCSGestioneNoteResponse":{"as400Status":"Ok","as400Errore":""}}',Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.gestioneNote',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
        insert test1;
       	ApiRest__c test2 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c='{"resultCode":0,"resultMessage":"Ok","flagEsito":"Ok"}',Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.inviaSMS',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
       	insert test2; 
        XCS_Template__c templateTesto = new XCS_Template__c();
        templateTesto.body__c = 'Testo';
        templateTesto.Name = 'SMS.AUI_EsitoKO';
        insert templateTesto;
        String recordType = [select id,Name from Recordtype where name = 'Person Account' limit 1].id;
        String recordTypeCase = [select id,Name from Recordtype where name = 'CRM Master' limit 1].id;
        Account	a = new Account();	        
        a.RecordTypeId = recordType;
        a.FirstName = 'Marco';
        a.LastName = 'Rossi';
        a.Codice_Fiscale__pc = 'mrcrss121212r1r1';
        a.Data_nascita__c = date.valueOf('1993-12-12');
        a.OCS_External_Id__c = 'C100';
        a.Telefono_Cellulare__c ='3333333333';
        insert a;
        Case c = new Case();
        c.Subject = 'Case Figlio';
        c.RecordTypeId = recordTypeCase;
        c.ActivityType__c = 'CRM_POSTVENDITA';
        c.Categoria__c = 'Gestione Post Vendita';
        c.Sottocategoria__C = 'AUI Recupero documenti scaduti';
        c.SuppliedMobilePhone__c = '333333';
        c.AccountId = a.id;
        Case c2 = new Case();
        c2.Subject = 'Case Padre';
        c2.RecordTypeId = recordTypeCase;
        c2.ActivityType__c = 'AUI_FAX_MAIL_RICEVUTE';
        c2.Type = 'CRM';
        c2.SuppliedMobilePhone__c = '333333';
        insert c;
        insert c2;
        XCS_Disposition__c disp = new XCS_Disposition__c(External_Id__c = 'DP5619',name = 'Documento ricevuto/lavorato');
        XCS_Disposition__c disp2 = new XCS_Disposition__c(External_Id__c = 'DP5620',name = 'Documento doppio/illeggibile');
        insert disp;
        insert disp2;
    }
    @isTest()
    static void returnfilterTicketnoDate()
    {
        List<Case> lCase = GDSAssignTicketController.returnTicket('','',null,'');
        system.assert(lCase.size() == 1);
    }
    @isTest()
    static void returnfilterTicket()
    {
        List<Case> lCase = GDSAssignTicketController.returnTicket('Marco','Rossi','1993-12-12','mrcrss121212r1r1');
        system.assert(lCase.size() == 1);
    }
    @isTest()
    static void testAbbinaFunctionEsitoNegativo()
    {
        Case cPadre = [Select id from case where Subject ='Case Padre'];
        Case cFiglio = [Select id from case where Subject ='Case Figlio'];
        XCS_Disposition__c disp = [Select id,External_Id__c,Name from XCS_Disposition__c where External_Id__c = 'DP5620'];
        List<String> lString = GDSAssignTicketController.abbinaContatto(cPadre.Id, cFiglio.Id,disp, '');
        Case cPadre2 = [Select id,Status from case where Subject ='Case Padre'];
        Case cFiglio2 = [Select id,Status from case where Subject ='Case Figlio'];
        system.assert(cPadre2.Status == 'Closed');
        system.assert(cFiglio2.Status == 'New');
    }    
    @isTest()
    static void testAbbinaFunctionEsitoPositivo()
    {
        Case cPadre = [Select id from case where Subject ='Case Padre'];
        Case cFiglio = [Select id from case where Subject ='Case Figlio'];
        XCS_Disposition__c disp = [Select id,External_Id__c,Name from XCS_Disposition__c where External_Id__c = 'DP5619'];
        List<String> lString = GDSAssignTicketController.abbinaContatto(cPadre.Id, cFiglio.Id,disp, '');
        Case cPadre2 = [Select id,Status from case where Subject ='Case Padre'];
        Case cFiglio2 = [Select id,Status from case where Subject ='Case Figlio'];
        system.assert(cPadre2.Status == 'Closed');
        system.assert(cFiglio2.Status == 'Closed');
    }
	@isTest()
	static void testChiamaServizio()
    {
        Case cPadre = [Select id from case where Subject ='Case Padre'];
        Case cFiglio = [Select id from case where Subject ='Case Figlio'];
        XCS_Disposition__c disp = [Select id,External_Id__c,Name from XCS_Disposition__c where External_Id__c = 'DP5619'];
        List<String> lString = GDSAssignTicketController.abbinaContatto(cPadre.Id, cFiglio.Id,disp, '');     
        test.startTest();
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname='ocs.gestioneNote';
        Test.setMock(HttpCalloutMock.class,UMR);

        GDSAssignTicketController.chiamaServizio(lString);
        GDSAssignTicketController.callWebService('C100', 'SMS.AUI_EsitoKO',cFiglio.Id);
    }
    
      @isTest()
    static void testAbbinaFunctionIDFiglioVuoto()
    {
        Case cPadre = [Select id from case where Subject ='Case Padre'];
        Case cFiglio = [Select id from case where Subject ='Case Figlio'];
        XCS_Disposition__c disp = [Select id,External_Id__c,Name from XCS_Disposition__c where External_Id__c = 'DP5619'];
        List<String> lString = GDSAssignTicketController.abbinaContatto(cPadre.Id, '',disp, '');
        Case cPadre2 = [Select id,Status from case where Subject ='Case Padre'];
        Case cFiglio2 = [Select id,Status from case where Subject ='Case Figlio'];
        system.assert(cPadre2.Status == 'Closed');
        system.assert(cFiglio2.Status == 'New');
    }    

    //res= [
    //        SELECT Id,caseNumber,Subject, AccountId,Account.Firstname,Account.Lastname,Account.Data_nascita__c,Account.Codice_Fiscale__pc, Status,  ActivityType__c, Categoria__c, Sottocategoria__c , Account.OCS_External_Id__c
    //        FROM Case 
    //        WHERE
    //        Account.FirstName like :nome AND
    //        Account.LastName like :cognome AND
    //        Account.Codice_Fiscale__pc like : Codicefiscale AND
    //        Status ='New' AND 
    //        ActivityType__c ='CRM_POSTVENDITA' AND 
    //        Categoria__c = 'Gestione Post Vendita' AND 
    //          Sottocategoria__c ='AUI Recupero documenti scaduti'
    
    
    
}