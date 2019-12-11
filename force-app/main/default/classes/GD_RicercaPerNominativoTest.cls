@isTest
public class GD_RicercaPerNominativoTest {
    @TestSetup
    static void makeData(){ 
        List<IVASS_Dealer_courses_Iscritti__c> records = new List<IVASS_Dealer_courses_Iscritti__c>();
        IVASS_Dealer_Courses__c corso = new IVASS_Dealer_Courses__c ();
        corso.Name = 'Test Name Corso';
        corso.Codice_Assofin__c = '12345';
        corso.Descrizione_Corso__c = 'description test';
        corso.Attivo__c = true;
        insert corso;
        for (Integer i = 0; i < 5; i++) {
            IVASS_Dealer_courses_Iscritti__c record = new IVASS_Dealer_courses_Iscritti__c(); 
            record.Codice_Fiscale__c= 'FRSMNC74A04B180N';
            record.Corso__c= corso.Id;
            record.Nome__c= generateRandomString(10);
            record.Stato_Corso__c= 'Sospesa';
            records.add(record);
          
        }
        records[0].Nome__c= 'ANTONIO NDIAYE';
        records[1].Codice_Fiscale__c = 'BRGDVD79P26M208A';
        records[1].Nome__c= 'ANTONIO NDIAYE';
        records[2].Codice_Fiscale__c = 'BRLNLT79M51G479T';
        records[2].Nome__c= 'ANTONIO NDIAYE';
        records[3].Codice_Fiscale__c = 'BRNFNC72A11C933O';
        records[4].Codice_Fiscale__c = 'BVCNTN78D11D086W';
        insert records;
    }
    private static String generateRandomString(Integer len) {
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String randStr = '';
        while (randStr.length() < len) {
           Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
           randStr += chars.substring(idx, idx+1);
        }
        return randStr;
	}
    
    @isTest
    static void updateStato(){
        Test.startTest();
        List<IVASS_Dealer_courses_Iscritti__c> records = [SELECT Id, Codice_Intermediario__c, Ragione_Sociale__c, Codice_Fiscale__c, Data_Iscrizione__c, Stato_Corso__c, Note__c, Corso__c, Regione__c, Cognome__c, Nome__c, Name
                                                          FROM IVASS_Dealer_courses_Iscritti__c LIMIT 2];
        records[0].Stato_Corso__c= 'FINITO';
        records[1].Stato_Corso__c= 'FINITO';
        Map<String,Object> response = GD_RicercaPerNominativo.updateStato(records);
        List<IVASS_Dealer_courses_Iscritti__c> results = [SELECT Id, Codice_Intermediario__c, Ragione_Sociale__c, Codice_Fiscale__c, Data_Iscrizione__c, Stato_Corso__c, Note__c, Corso__c, Regione__c, Cognome__c, Nome__c, Name
                                                          FROM IVASS_Dealer_courses_Iscritti__c WHERE Stato_Corso__c='FINITO'];
        System.assertEquals(response.get('error'), false);
        System.assertEquals(results.size(), 2);
        records[0].Stato_Corso__c= 'Bad Stato';
        records[1].Stato_Corso__c= 'Bad Stato';
        Map<String,Object> response2 = GD_RicercaPerNominativo.updateStato(records);
        System.assertEquals(response2.get('error'), true);
        Test.stopTest();
    } 
    @isTest
    static void searchByName(){
        Test.startTest();
        String searchText = '12345';
        Map<String,Object> response = GD_RicercaPerNominativo.searchByName(searchText);
        System.assertEquals(response.get('error'), false);
        Test.stopTest();
    } 
    @isTest
    static void getAllStatus(){
        Test.startTest();
        List<String> pickList = GD_RicercaPerNominativo.getAllStatus();
        System.assert(pickList.size() > 0);
        Test.stopTest();
    } 
}