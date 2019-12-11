@istest
public with sharing class CRMBatChiuAutAttFilTest {


    @TestSetup
    static void makeData(){
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
 
        Id queueId = [SELECT Id FROM Group WHERE DeveloperName =:CRMBatChiuAutAttFil.QUEUE_DINIEGHI LIMIT 1].Id;
        Case caso = new Case(Subject = 'Diniego', Status = 'New',NumeroPratica__c ='2342342',ownerId=queueId);
        insert caso;    
        Date date15= date.today().adddays(-15);
        Mandati_SDD__c mandato1 = new Mandati_SDD__c(ProgreMan__c = '1', Progressivo__c = '7890', Codice_Cliente__c = acc.id, Mandato__c='M1',Caseid__c =caso.id, Stato_Mandato__c=CRMBatLoadDinieghi.STATO_RICEVUTO,Filiale__c = 'Fil',Motivo_Diniego__c = 'MOt', Data_Inserimento__c = date15,Tipo_Messaggio__c='T',PraticaNum__c='92734');
        List<Mandati_SDD__c> listaMandati = new  List<Mandati_SDD__c>();
        listaMandati.add(mandato1);
        insert listaMandati;
        String response = '{"resultCode":0,"resultMessage":"Ok","variazioneDatiPagamentoResponse":{"as400Status":"KO","as400Errore":"0532 Procedura non gestita"}}';
        ApiRest__c rest = new ApiRest__c(Method__c = 'POST' ,Test_Response__c=response,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,ref__c = 'CompassInternal',Name ='ocs.variazioneDatiPagamento',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
        insert rest;
        ApiUtil__c uti = new ApiUtil__c(Name = 'CompassInternal' ,EndPoint__c ='https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute' ,Password__c = 'P00FLSDC',User__c = 'CDSLF00');      
        insert uti;
        XCS_Template__c templateNote = new XCS_Template__c(Name = 'NOTE.CRMBatChiuAutAttFil', Body__c ='Diniego mandato num {numeroMandato} - pratica: {tipoPratica} {numPratica}: {messaggio}');
        insert templateNote;
       
    }


     @isTest
    public static void runBatchTest1() {

        XCS_Disposition__c disposition = new XCS_Disposition__c(External_Id__c = 'DP3505');
        insert disposition;
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname='ocs.variazioneDatiPagamento';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class,UMR);
        try {
        database.executebatch(new  CRMBatChiuAutAttFil(), 10);
        } catch (System.AsyncException ex) {
            // manage exception job is already scheduled
        }
        Test.stopTest();
         List<Mandati_SDD__c> lista = [SELECT ID, Stato_Mandato__c FROM Mandati_SDD__c ];
        for (Mandati_SDD__c man:lista) {
            System.assert(man.Stato_Mandato__c==CRMBatChiuAutAttFil.STATO_GESTITO);
        }
       
    }
}