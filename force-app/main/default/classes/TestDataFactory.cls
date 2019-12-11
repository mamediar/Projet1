@isTest
public class TestDataFactory 
{

    public static List<SObject> loadBranchAccount()
    {
        return Test.loadData(Account.sObjectType, 'TestBranchAccount');
    }

    //insert account
    public static Account insertAccount(){
        
        Account acc = new Account(
            Name = 'MARIO ROSSI',                        
            Data_Nascita__c = Date.valueOf('1944-08-23'),
            Utilizzato_per_Reclami__c = false,           
            COM_NumeroTotali_Pratiche__c = '0',          
            Customer_Type__c = 'Compass',
            OCS_External_Id__c ='C10963362',
            Codice_Cliente__c ='10963362'
            
        );
        insert acc;
        return acc;
    }

    //insert account
    public static Account insertAccount(String OCS_External_Id, String Codice_Cliente){
        
        Account acc = new Account(
            Name = 'MARIO ROSSI',                        
            Data_Nascita__c = Date.valueOf('1944-08-23'),
            Utilizzato_per_Reclami__c = false,           
            COM_NumeroTotali_Pratiche__c = '0',          
            Customer_Type__c = 'Compass',
            OCS_External_Id__c = OCS_External_Id,
            Codice_Cliente__c = Codice_Cliente
            
        );
        insert acc;
        return acc;
    }

    //insert case
    public static Case insertCase(){

        Case c = new Case();
        c.Status = 'New';
        c.Subject = 'Test';
        c.Esito__c='Esito';
        
        Group g = new Group();
        g.Name = 'TestName';
        g.DeveloperName = 'devTest';
        g.Type = 'queue';
        insert g; 
        
        User u = new User(); 
        u.DefaultQueueId__c = g.DeveloperName;
        u.Username = 'Giu@k.k';
        u.LastName='Seppe';
        u.Email='sij@iol.io';
        u.CommunityNickname='sid';
        u.TimeZoneSidKey='Europe/Rome';
        u.LocaleSidKey='it';
        u.EmailEncodingKey='UTF-8';
        u.ProfileId=[SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
        u.LanguageLocaleKey='it';
        u.Alias='df';
        insert u;
 
        System.runAs(u){

            SFA_TipologiaLista__c tl = new SFA_TipologiaLista__c(Name='nome_attivita_test');
            insert tl;

            SFA_ListeCaricate__c lst = new SFA_ListeCaricate__c();
            lst.Nome_Lista__c = 'lista_test';
            lst.Tipo_Attivita__c = tl.Id;
            insert lst;

            c.SFA_ListeCaricate__c = lst.Id;
            insert c; 
        }
        return c;
    }


    //insert Mandati_SDD__c
    public static List<Mandati_SDD__c> insertMandati_SDD(){
        Account acc = new Account(
            Name = 'ROBERTO VERZA',                        
            Data_Nascita__c = Date.valueOf('1944-08-23'),
            Utilizzato_per_Reclami__c = false,           
            COM_NumeroTotali_Pratiche__c = '0',          
            Customer_Type__c = 'Compass',
            OCS_External_Id__c = 'F66666',
            Codice_Cliente__c = '66666'
            
        );
        insert acc;
 
        Case caso = new Case(Subject = 'Diniego', Status = 'New',NumeroPratica__c ='2342342');
        insert caso;    
        Mandati_SDD__c mandato1 = new Mandati_SDD__c(ProgreMan__c = '1', Progressivo__c = '7890', Codice_Cliente__c = acc.id, Mandato__c='M1',Caseid__c =caso.id, Data_Inserimento__c = Date.today(), Stato_Mandato__c=CRMBatLoadDinieghi.STATO_RICEVUTO,Filiale__c = 'Fil',Motivo_Diniego__c = 'MOt');
        Mandati_SDD__c mandato2 = new Mandati_SDD__c(ProgreMan__c = '2', Progressivo__c = '7890', Codice_Cliente__c = acc.id, Mandato__c='M2',Caseid__c =caso.id, Data_Inserimento__c = Date.today(), Stato_Mandato__c=CRMBatLoadDinieghi.STATO_RICEVUTO,Filiale__c = 'Fil',Motivo_Diniego__c = 'MOt');
        List<Mandati_SDD__c> listaMandati = new  List<Mandati_SDD__c>();
        listaMandati.add(mandato1);
        listaMandati.add(mandato2);
        insert listaMandati;
        return listaMandati;
    }



    //insert apirest
    public static void setApiRest(String method,String fakeResponseJSON, String serviceName){
        //Parameter Example:
        //method: POST/GET
        //fakeResponseJSON: {"resultCode": 0,"resultMessage": "Ok","recuperaDatiRetentionResponse": {"elencoPratiche": [{"tipoPratica": "CO","numPratica": "16132993","dataUltimaScadenza": "20210515","codProdotto": "PE","codCliente": "10963362"}]}}'
        //serviceName: ocs.recuperaDatiRetention
        
        ApiRest__c rest1 = new ApiRest__c(Method__c = method , Test_Response__c = fakeResponseJSON, Name = serviceName, Test_Request__c = 'testRequest', Mock__c = false, User__c = 'CDSLF00', Password__c = 'P00FLSDC', ref__c = 'CompassInternal',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
        ApiUtil__c uti = new ApiUtil__c(Name = 'CompassInternal' ,EndPoint__c ='https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute' ,Password__c = 'P00FLSDC',User__c = 'CDSLF00');      
        insert rest1;
        insert uti;	
    }


    public static Account insertAccountForEmail() {
         Account acc = new Account(
            Name = 'FAKE EMAIL',                        
            Data_Nascita__c = Date.valueOf('1944-08-23'),
            Utilizzato_per_Reclami__c = false,           
            COM_NumeroTotali_Pratiche__c = '0',          
            Customer_Type__c = 'Compass',
            OCS_External_Id__c = 'N00000',
            Codice_Cliente__c = '00000'
            
        );
        insert acc;
        Contact contac = new Contact();
        contac.FirstName = 'Anil';
        contac.LastName = 'Dutt';
        contac.Email = 'anil@swiftsetup.com';
        contac.AccountId = acc.id;
        insert contac;
        return acc;      
    }
 

   public static Account insertDealer() {
 		Account dealer = new Account(
            Name = 'MARIO ROSSI',                        
            Data_Nascita__c = Date.valueOf('1944-08-23'),
            Utilizzato_per_Reclami__c = false,               
            Customer_Type__c = 'Compass',
			OCS_External_Id__c ='D16342975', 
			Codice_Cliente__c ='16342975');
		dealer.RecordTypeId = RecordTypeUtil.getDealerRecordType();
        insert dealer;
        return dealer;
   }

    
}