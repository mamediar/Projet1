@isTest
public class SFA_PraticheIrregolari_CreazPraticheTest {


	@isTest
    public static id setUp(){
        
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
     	User usr = new User(LastName = 'LIVESTON',
                           FirstName='JASON',
                           Alias = 'jliv',
                           Email = 'jason.liveston@gdv.com',
                           Username = 'jason1.liveston@gdv.com',  
                           ProfileId = profileId.id,
                           TimeZoneSidKey = 'GMT',
                           LanguageLocaleKey = 'en_US',
                           EmailEncodingKey = 'UTF-8',
                           LocaleSidKey = 'en_US'
                           );
        insert usr;      
        
        //case padre di elaborazione precedente
        Case cPrecedente = new Case();
        cPrecedente.ActivityType__c='SFA_PRAIRRPARENT';
		cPrecedente.Subject = 'Elaborazione Pratiche Irregolari';
		cPrecedente.status = 'Closed';        
        insert cPrecedente;        
        
        //case padre di elaborazione
        Case c = new Case();
        c.ActivityType__c='SFA_PRAIRRPARENT';
		c.Subject = 'Elaborazione Pratiche Irregolari';
		c.status = 'Closed';         
        insert c;
        
                

        //case padre di elaborazione
        Case cTargaMancantePadre = new Case();
        cTargaMancantePadre.ActivityType__c='SFA_TARMANPARENT';
        insert cTargaMancantePadre;
        
        //case figlio di targhe mancanti
        Case cTargaMancante = new Case();
        cTargaMancante.Status='New';
        cTargaMancante.ActivityType__c='SFA_TARMAN';
        insert cTargaMancante;  
        
        //case figlio di pratiche irregolari
        Case cPraticaIrregolare = new Case();
        cPraticaIrregolare.Status='Closed';
        cPraticaIrregolare.ActivityType__c='SFA_PRAIRR';
        cPraticaIrregolare.ParentId=c.Id;
        insert cPraticaIrregolare;        

        //Branch
        Account acc2 = new Account();
		String idRecordTypeBranch = [Select id from RecordType where name = 'Branch'][0].id;
		acc2.RecordTypeId = idRecordTypeBranch;
		acc2.name = 'BranchDiProva';   
        acc2.OCS_External_Id__c = 'BS';		        
        insert acc2;     
                
        
        //Dealer associated to a branch
        Account acc1 = new Account();
		String idRecordTypeDealer = [Select id from RecordType where name = 'Dealer'][0].id;
		acc1.RecordTypeId = idRecordTypeDealer;
		acc1.name = 'DealerDiProva';   
        acc1.OCS_External_Id__c = 'D123';
        acc1.Branch__r=acc2;
        insert acc1;
        
        //Dealer not associated to any branch
        Account d2 = new Account();
		//String idRecordTypeDealer = [Select id from RecordType where name = 'Dealer'][0].id;
		d2.RecordTypeId = idRecordTypeDealer;
		d2.name = 'DealerDiProva';   
        d2.OCS_External_Id__c = 'D1234';
        insert d2;        


        //pratica irregolare precedente
        SFA_PraticaIrregolare__c P = new SFA_PraticaIrregolare__c();
        P.EsitoCaricamento__c = 'Pratica caricata';
        //P.IdElaborazione__c = cPrecedente.id;
        P.ActivityId__c = cPraticaIrregolare.id;
        P.Name = '125';
        P.IdIncident__c=1000;
        P.CodiceDealer__c = 'd';
        P.CodicePv__c = 's';
        P.CodiceStatoDealer__c = 's';
        P.RagioneSociale__c = 'rag';
        P.NumeroPratica__c = '125';
        P.CodiceStatoPratica__c = '50';
        P.Dipendenza__c = 'm';
        P.Status__c = 'Pratica - da Gestire';   
        //P.OwnerId=usr.Id; //vedere se va bene
        insert P;
        
        
        
        //Targa mancante con stesso codice pratica nel nuovo csv di inserimento
        SFATargaMancante__c t = new SFATargaMancante__c();
        t.IdAttivita__c=cTargaMancante.id;
        t.IdElaborazione__c=cTargaMancantePadre.id;
        t.CodiceCliente__c = '1234';
        t.OcsCode__c = 'd';
        t.RagioneSociale__c = 'ad';
        t.Dipendenza__c = 'dip';
        t.NumeroPratica__c = '125';
        t.Name = '125';
        t.IdUploadList__c = 11;
        t.OwnerId=usr.Id;
        t.DataTermineLavoro__c = date.today();       
        insert t;        
        
        return c.id;
    }

    private class SFAPraticheIrregolariOCSResponse implements HttpCalloutMock{
        public HTTPResponse respond(HTTPRequest req){
            HttpResponse res = new HttpResponse();
            String urlId = req.getEndpoint();
            String apiname='ocs.'+((OCSRequest)JSON.deserialize(req.getBody(),OCSRequest.class)).serviceId;
            res.setHeader('Content-Type', 'application/json');
            ApiRest__c ar = [select Test_Request__c, Test_Response__c from Apirest__c where endpoint__c = :urlId and name = :apiname LIMIT 1];
            system.debug(ar);
            System.assert(ar!= null, 'No rows for endpoint ' + urlId );
            System.assert(ar.Test_response__c != null, 'Missing response on test static resource.'); 
            res.setStatusCode(200);
            res.setBody(ar.Test_Response__c);         
            return res;
        }
    }    
    
    
	@isTest
    public static void executeBranchDealerFoundTest(){
        
        
       String caseId=setUp();

        //file elaborazione attuale
        ContentVersion file = new ContentVersion();
        file.Title = 'TitoloTest';        
        file.PathOnClient = 'testodiprova';        
        String csvFile = 'Cod Dealer;Cod Punto vendita;Stato Dealer;Ragione Sociale;Codice Pratica;Stato Prat;Saldo Totale;CURDEL;Data Liquidaz;Dipend;Riscont Agenzia;Riscont Definit;Data Estrazione;Data Ricezione;Targa restituita;Telaio;Irregolarita;NOTE AGENZIA ITALIA;WARNING;'+
            '\r\n 123;0;AT;AUTOMERCATO ITALIA SRL;123;40;6349.84;0;;16 147 Acireale;E20;;;;EJ726XE;;S22 Aperta;GIA RICICLATA -;warn2;'+    //non scartata IRR 1
            '\r\n 1234;0;AT;AUTOMERCATO ITALIA SRL;122;40;6349.84;0;;16 147 Acireale;S22;;;;EJ726XE;;S22 Aperta;GIA RICICLATA -;warn1;'+   // scartata branch not found
            '\r\n 123;0;AT;AUTOMERCATO ITALIA SRL;125;40;6349.84;3;;16 147 Acireale;S22;;;;EJ726XE;;S22 Aperta;GIA RICICLATA -;warn3;'+    //non scartata IRR 2
            '\r\n 1234;0;AT;AUTOMERCATO ITALIA SRL;127;40;6349.84;0;;16 147 Acireale;S22;;;;EJ726XE;;S22 Aperta;GIA RICICLATA -;warn5;'+  // scartata branch not found
            '\r\n 123478;0;AT;AUTOMERCATO ITALIA SRL;128;40;6349.84;0;;16 147 Acireale;S22;;;;EJ726XE;;S22 Aperta;GIA RICICLATA -;warn6;'+   //scartata dealer not found     
            '\r\n 123;0;AT;AUTOMERCATO ITALIA SRL;126;40;6349.84;0;;16 147 Acireale;S22;;;;EJ726XE;;S22 Aperta;GIA RICICLATA -;warn4;';    //non scartata IRR 3
			                
        file.VersionData = Blob.valueOf(csvFile);
        insert file;
        

	    Date oggi = date.today();     
        String fileId = file.id;
        
        String responseDatiPostVendita = '{"resultCode":0,"resultMessage":"Ok","pratiche":[{"elencoCoobbligati":[{"provNascita":"BA"}]}],"cliente":[{"cognome":"PIPPO","nome":"LEIO", "dataNascita": "19801010" }]}';        
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= responseDatiPostVendita ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaDatiPostvendita',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
        insert test1;
    
        
        String responseInfoPratica ='{"resultMessage":"Ok","resultCode":0,"recuperaInfoPraticaResponse":{"telaio":"","targa":"EP770GD ","prodotto":"1U","marcaModello":"AF A29","descrizioneBene":"GIULIETTA","annoMeseImmatricolazione":"20121001"}}'; 
        ApiRest__c test2 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c=responseInfoPratica ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaInfoPratica',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
        insert test2;       
     
            
        SFA_PraticheIrregolari_CreazionePratiche creazionePratiche = new SFA_PraticheIrregolari_CreazionePratiche(fileId,caseId,oggi);
        
        Test.startTest(); 
        SFAPraticheIrregolariOCSResponse UMR = new SFAPraticheIrregolariOCSResponse();
        Test.setMock(HttpCalloutMock.class,UMR);       
        System.enqueueJob(creazionePratiche);
        Test.stopTest();     
    }    
    
    
    

}