@isTest
public class GD_Dealer_Isvap_Update_AssofinTest {
    
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
        System.debug('records to add >>: '+records);
        
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
    static void updateSobject(){
        Test.startTest();
        List<IVASS_Dealer_courses_Iscritti__c> records = new List<IVASS_Dealer_courses_Iscritti__c>();
        IVASS_Dealer_courses_Iscritti__c record1 = new IVASS_Dealer_courses_Iscritti__c(
            Codice_Fiscale__c= 'FRSMNC74A04B180N',
            //Nome_Corso__c= 'Test Name Corso',
            Nome__c= 'ANTONIO NDIAYE',
            Stato_Corso__c= 'Sospesa'); 
        IVASS_Dealer_courses_Iscritti__c record2 = new IVASS_Dealer_courses_Iscritti__c(
            Codice_Fiscale__c= 'BRNFNC72A11C933O',
            //Nome_Corso__c= 'Test Name Corso',
            Nome__c= 'DAVID BERGANTIN',
            Stato_Corso__c= 'Sospesa'); 
        records.add(record1);
        records.add(record2);
        Map<String,Object> response = GD_Dealer_Isvap_Update_Assofin.updateSobject(records);
        System.assertEquals(response.get('error'), false);
        System.assertEquals(response.get('updatedRows'), 0);
        Test.stopTest();
    } 
    private static Set<String> fieldsToExclude = new Set<String>{'OwnerId'};
    @isTest
    static void mergeRecords(){
        Test.startTest();
        IVASS_Dealer_Courses__c corso = [SELECT Id, Name, Codice_Assofin__c, Descrizione_Corso__c FROM IVASS_Dealer_Courses__c LIMIT 1];
        IVASS_Dealer_courses_Iscritti__c record1 = new IVASS_Dealer_courses_Iscritti__c(
            Codice_Fiscale__c= 'FRSMNC74A04B180N',
            Corso__c= corso.Id,
            Nome__c= 'ANTONIO NDIAYE',
            Stato_Corso__c= 'Finito');
        IVASS_Dealer_courses_Iscritti__c record2 = [SELECT Id, Corso__c, Area__c, Codice_Fiscale__c, Codice_Intermediario__c, Cognome__c, Data_Iscrizione__c, Dealer__c, Esito_Outsourcer__c, Filiale__c, 
        Nome__c, Note__c, Note_x_Outsourcer__c, Ragione_Sociale__c, Referente__c, Regione__c, Stato_Corso__c, Invio_all_Outsourcer__c, Dipendenza__c,Name, Corso__r.Name,  
        descrizione__c, Stato__c, Esito_Globale__c, Data_Fine__c, Data_Globale__c, Utenza__c, Password__c, Note_Presidio__c, Email_Referente__c, Anno_di_Riferimento__c,
         Nome_Dealer__c, Nome_Corso__c, Corso__r.Codice_Assofin__c 
        FROM IVASS_Dealer_courses_Iscritti__c LIMIT 1];
        IVASS_Dealer_courses_Iscritti__c recordToMerge = GD_Dealer_Isvap_Update_Assofin.mergeRecords(record1, record2, 'IVASS_Dealer_courses_Iscritti__c');
        System.debug('recordToMerge >>: '+recordToMerge);
        System.assertEquals(recordToMerge.Stato_Corso__c, 'Finito');
        Test.stopTest();
    }
}