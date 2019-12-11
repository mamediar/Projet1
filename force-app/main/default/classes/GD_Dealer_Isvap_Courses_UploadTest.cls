@isTest
public class GD_Dealer_Isvap_Courses_UploadTest {

    @testSetup 
    static void setup(){
        RecordType rt = [Select Id,Name FROM RecordType WHERE Name ='Dealer'];
        RecordType rtBr = [Select Id,Name FROM RecordType WHERE Name ='Branch'];
        IVASS_Dealer_Courses__c corsoTest = new IVASS_Dealer_Courses__c(Name = 'Test corso');
        insert corsoTest;
        List<Account> accountsTesT = new List<Account>();
        Account a1 = new Account(Name ='test Account 1',OCS_External_Id__c='14579807',RecordTypeId = rt.Id);
        Account a2 = new Account(Name ='test Account 2',OCS_External_Id__c='14525528',RecordTypeId = rt.Id);
        Account a3 = new Account(Name ='test Account 3',OCS_External_Id__c='145255845',RecordTypeId = rt.Id);
        Account a4 = new Account(Name ='test Account 4',OCS_External_Id__c='3792533');
        Account a5 = new Account(Name ='test Account 5',OCS_External_Id__c='145798412');
        Account a6 = new Account(Name ='test Account 6',OCS_External_Id__c='144',RecordTypeId = rtBr.Id);
        Account a7 = new Account(Name ='test Account 7',OCS_External_Id__c='183',RecordTypeId = rtBr.Id);
        Account a8 = new Account(Name ='test Account 8',OCS_External_Id__c='46845465',RecordTypeId = rtBr.Id);

        accountsTesT.add(a1);
        accountsTesT.add(a2);
        accountsTesT.add(a3); 
        accountsTesT.add(a4); 
        accountsTesT.add(a5); 
        accountsTesT.add(a6); 
        accountsTesT.add(a7); 
        accountsTesT.add(a8); 
        insert accountsTesT;
        
    }
    @isTest
    static void testBatch(){
        IVASS_Dealer_Courses__c corsoTest = [Select Id,Name FROM IVASS_Dealer_Courses__c];
        String dataFile = 'REGIONE;AREA;FILIALE;COD. OCS CONV.;RAGIONE SOCIALE;MAIL CONV.;COD. OCS REF.;COGNOME;NOME;CODICE FISCALE;MAIL REFERENTE;DATA ISCRIZIONE;UTENZA;PASSWORD;generic_field_1;generic_field_2;generic_field_3;INVIO OUTSOURCER;NOTE\r\nRT;1;144;14579807;MPA AUTO DI MARCO PEZZOTTA DIN;marco.capece@lynx.com;3792533;PEZZOTTA;MARCO;PZZMRC79E10A246E;;19/10/2018;CMP18PEZZ79E;MARCO;;;;N;\r\nRT;4;183;14525528;AUTOFFICINA F.LLI RAPACIOLI SRL;cmarcom.84@gmail.com;14525551;RAPACIOLI;MAURO;RPCMRA67B28G535W;;19/10/2018;CMP18RAPA67B;MAURO;;;;N;\r\nRT;18;214;63464;AUTOINCONTRO DI SANAVIA LORIS & C. SAS;marco.capece@lynx.com;18731735;SANAVIA;DANIEL;SNVDNL91M12L049W;;19/10/2018;CMP18SANA91M;DANIE;;;;N;';
    	Test.startTest();
        GD_Dealer_Isvap_Courses_Upload cu = new GD_Dealer_Isvap_Courses_Upload(dataFile, corsoTest);
          Id batchId = Database.executeBatch(cu);
        Test.stopTest();
    }
    
}