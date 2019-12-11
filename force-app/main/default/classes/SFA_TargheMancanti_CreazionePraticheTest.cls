@isTest
public class SFA_TargheMancanti_CreazionePraticheTest {
    @isTest
    public static void executeListaKOTest(){
            
        Case c = new Case();
        insert c;
        
        Account acc = new Account();
		String idRecordTypeDealer = [Select id from RecordType where name = 'Dealer'].id;
		acc.RecordTypeId = idRecordTypeDealer;
		acc.name = 'AccountDiProva';   
        acc.OCS_External_Id__c = 'DS';
		        
        insert acc;
        
        Date oggi = date.today(); 
        ContentVersion file = new ContentVersion();
        file.Title = 'TitoloTest';
        
        file.PathOnClient = 'testodiprova';
        //file.VersionData = Blob.valueOf('ragione_sociale;prodotto\n valoredue\n Dconvenzionato \r RigaDue ' + '\r RigaTre');
        String csvFile = 'ragione_sociale;pratica;prodotto;data_liquidazione;targa;telaio;c_anacli;DESCRIZIONE_BENE;convenzionato;nome_cliente \r srl;1235643;gd4;12/12/2009;bs123po;woptynf85jfiro6y7;bb;descrizione;DDS;giacomo;';
        file.VersionData = Blob.valueOf(csvFile);

        insert file;
	        
        String caseId = c.id;
        String fileId = file.id;
        
        SFA_TargheMancanti_CreazionePratiche t = new SFA_TargheMancanti_CreazionePratiche(fileId,caseId,oggi);
        
        Test.startTest();       
        System.enqueueJob(t);
        Test.stopTest();     
    }
    @isTest
    public static void executeListaOKTest(){
            
        Case c = new Case();
        insert c;
        
        Account acc = new Account();
		String idRecordTypeDealer = [Select id from RecordType where name = 'Dealer'].id;
		acc.RecordTypeId = idRecordTypeDealer;
		acc.name = 'AccountDiProva';   
        acc.OCS_External_Id__c = 'D125';
		        
        insert acc;
        
        Date oggi = date.today(); 
        ContentVersion file = new ContentVersion();
        file.Title = 'TitoloTest';
        
        file.PathOnClient = 'testodiprova';
        //file.VersionData = Blob.valueOf('ragione_sociale;prodotto\n valoredue\n Dconvenzionato \r RigaDue ' + '\r RigaTre');
        String csvFile = 'ragione_sociale;pratica;prodotto;data_liquidazione;targa;telaio;c_anacli;DESCRIZIONE_BENE;convenzionato;nome_cliente \r srl;1235643;1U;12/12/2009;bs123po;woptynf85jfiro6y7;bb;descrizione;125;giacomo';
        file.VersionData = Blob.valueOf(csvFile);

        insert file;
	        
        String caseId = c.id;
        String fileId = file.id;
        
        SFA_TargheMancanti_CreazionePratiche t = new SFA_TargheMancanti_CreazionePratiche(fileId,caseId,oggi);
        
        Test.startTest();       
        System.enqueueJob(t);
        Test.stopTest();     
    }
    @isTest
    public static void executeDealerNotFoundTest(){
            
        Case c = new Case();
        insert c;
        
        Account acc = new Account();
		String idRecordTypeDealer = [Select id from RecordType where name = 'Dealer'].id;
		acc.RecordTypeId = idRecordTypeDealer;
		acc.name = 'AccountDiProva';   
        acc.OCS_External_Id__c = '111';
		        
        insert acc;
        
        Date oggi = date.today(); 
        ContentVersion file = new ContentVersion();
        file.Title = 'TitoloTest';
        
        file.PathOnClient = 'testodiprova';
        //file.VersionData = Blob.valueOf('ragione_sociale;prodotto\n valoredue\n Dconvenzionato \r RigaDue ' + '\r RigaTre');
        String csvFile = 'ragione_sociale;pratica;prodotto;data_liquidazione;targa;telaio;c_anacli;DESCRIZIONE_BENE;convenzionato;nome_cliente \r srl;1235643;1U;12/12/2009;bs123po;woptynf85jfiro6y7;bb;descrizione;125;giacomo;';
        file.VersionData = Blob.valueOf(csvFile);

        insert file;
	        
        String caseId = c.id;
        String fileId = file.id;
        
        SFA_TargheMancanti_CreazionePratiche t = new SFA_TargheMancanti_CreazionePratiche(fileId,caseId,oggi);
        
        Test.startTest();       
        System.enqueueJob(t);
        Test.stopTest();     
    }
    @isTest
    public static void executeGetExeptionTest(){
            
        Case c = new Case();
        insert c;

        
        Date oggi = date.today(); 
        ContentVersion file = new ContentVersion();
        file.Title = 'TitoloTest';
        
        file.PathOnClient = 'testodiprova';
        //file.VersionData = Blob.valueOf('ragione_sociale;prodotto\n valoredue\n Dconvenzionato \r RigaDue ' + '\r RigaTre');
        String csvFile = 'ragione_sociale';
        file.VersionData = Blob.valueOf(csvFile);

        insert file;
	        
        String caseId = c.id;
        String fileId = file.id;
        
        SFA_TargheMancanti_CreazionePratiche t = new SFA_TargheMancanti_CreazionePratiche('',caseId,oggi);
        
        Test.startTest();       
        System.enqueueJob(t);
        Test.stopTest();     
    }
      @isTest
    public static void execute(){
            
        Case c = new Case();
        insert c;
        
        Account acc = new Account();
		String idRecordTypeDealer = [Select id from RecordType where name = 'Dealer'].id;
		acc.RecordTypeId = idRecordTypeDealer;
		acc.name = 'AccountDiProva';   
        acc.OCS_External_Id__c = c.id;
		        
        insert acc;
        
        Date oggi = date.today(); 
        ContentVersion file = new ContentVersion();
        file.Title = 'TitoloTest';
        
        file.PathOnClient = 'testodiprova';
        //file.VersionData = Blob.valueOf('ragione_sociale;prodotto\n valoredue\n Dconvenzionato \r RigaDue ' + '\r RigaTre');
        String csvFile = 'ragione_sociale;pratica;prodotto;data_liquidazione;targa;telaio;c_anacli;DESCRIZIONE_BENE;convenzionato;nome_cliente;\r srl;1235643;1U;12/12/2009;bs123po;woptynf85jfiro6y7;bb;descrizione;125;giacomo;';
        file.VersionData = Blob.valueOf(csvFile);

        insert file;
	        
        String caseId = c.id;
        String fileId = file.id;
        
        SFA_TargheMancanti_CreazionePratiche t = new SFA_TargheMancanti_CreazionePratiche(fileId,caseId,oggi);
        
        Test.startTest();       
        System.enqueueJob(t);
        Test.stopTest();     
    }
    
}