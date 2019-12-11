@isTest
public with sharing class SFAListaDaSedeGetCaseBatchTest {


    @isTest
    public static void runBatchTest() {
        SFA_TipologiaLista__c tipoAtt = new SFA_TipologiaLista__c();
        insert tipoAtt;
        SFA_ListeCaricate__c listeCaricate = new SFA_ListeCaricate__c(Nome_Lista__c = 'nome_lista',Tipo_Attivita__c = tipoAtt.id);
        insert listeCaricate;
        List<RecordType> rDealer = [Select id  From RecordType  Where sObjectType = 'Account'and RecordType.Name = 'Branch'];
   
        Account acc = new Account(
            Name = 'MARIO ROSSI',                        
            Data_Nascita__c = Date.valueOf('1944-08-23'),
            OCSAreaId__c = 2,
            OCS_External_Id__c ='F5000',
            Codice_Cliente__c ='5000',
            Codice_Fiscale__c ='ABCDEF12C03T769P',
            Region_Name__c = 'RC',
            recordtypeid=rDealer[0].id
        );
        insert acc;
        Group g = [SELECT Id, DeveloperName, Name , Type FROM Group WHERE Type = 'queue' LIMIT 1];
//        insert g;
        XCS_Categoria__c categoria = new XCS_Categoria__c(External_Id__c = '1',Name ='cat');
        insert categoria;  
        List<RecordType> rListaDaSede= [Select id  From RecordType  Where sObjectType = 'Case' and RecordType.Developername = 'Liste_da_Sede'];
 
        Case c = new Case(Subject = 'test', Status = 'New', Priority = 'Medium', Categoria_Riferimento__c = categoria.id, OwnerId = g.id, recordtypeid=rListaDaSede[0].id,SFA_ListeCaricate__c = listeCaricate.id, ParentId = null);
        insert c;


        List<SFAListaDaSedeReadHelper> listInOut = new List<SFAListaDaSedeReadHelper>();
        SFAListaDaSedeReadHelper sfareadHelper = new   SFAListaDaSedeReadHelper();  
        sfareadHelper.accountObj = acc;
        sfareadHelper.codice_filiale = '1';
        listInOut.add(sfareadHelper);
        List<SFAListaDaSedeReadHelper> listInError = new List<SFAListaDaSedeReadHelper>();    
        Map<String, List<Account>> mapBranch = new Map<String, List<Account>>();
        Map<String, Group> mapGroup = new Map<String, Group>();
        mapGroup.put('F1',g);
        List<Account> listAccount = new List<Account>(); 
        listAccount.add(acc);   
        mapBranch.put(AccountUtils.OCSBranchChar+sfareadHelper.codice_filiale,listAccount);

		System.debug('INIZIO BATCH');
        Test.startTest();
        SFAListaDaSedeGetCaseBatch bat = new SFAListaDaSedeGetCaseBatch(tipoAtt.id, listeCaricate.id, Date.today(),  listInOut, listInError,listAccount,mapBranch,mapGroup);
        database.executebatch(bat,10);
        Test.stopTest();
        // verify
        List<SFAListaDaSedeReadHelper> listerror = bat.listInError;
        System.assert(listerror.size()==0);

    }


    @isTest
    public static void runBatchTest2() {
        SFA_TipologiaLista__c tipoAtt = new SFA_TipologiaLista__c();
        insert tipoAtt;
        SFA_ListeCaricate__c listeCaricate = new SFA_ListeCaricate__c(Nome_Lista__c = 'nome_lista',Tipo_Attivita__c = tipoAtt.id);
        insert listeCaricate;
        List<RecordType> rDealer = [Select id  From RecordType  Where sObjectType = 'Account'and RecordType.Name = 'Branch'];
   
        Account acc = new Account(
            Name = 'MARIO ROSSI',                        
            Data_Nascita__c = Date.valueOf('1944-08-23'),
            OCSAreaId__c = 2,
            OCS_External_Id__c ='F5000',
            Codice_Cliente__c ='5000',
            Codice_Fiscale__c ='ABCDEF12C03T769P',
            Region_Name__c = 'RC',
            recordtypeid=rDealer[0].id
        );
        insert acc;
        Group g = [SELECT Id, DeveloperName, Name , Type FROM Group WHERE Type = 'queue' LIMIT 1];
        XCS_Categoria__c categoria = new XCS_Categoria__c(External_Id__c = '1',Name ='cat');
        insert categoria;  
        List<RecordType> rListaDaSede= [Select id  From RecordType  Where sObjectType = 'Case' and RecordType.Developername = 'Liste_da_Sede'];
 
        Case c = new Case(Subject = 'test', Status = 'New', Priority = 'Medium', Categoria_Riferimento__c = categoria.id, OwnerId = g.id, recordtypeid=rListaDaSede[0].id,SFA_ListeCaricate__c = listeCaricate.id, ParentId = null);
        insert c;


        List<SFAListaDaSedeReadHelper> listInOut = new List<SFAListaDaSedeReadHelper>();
        SFAListaDaSedeReadHelper sfareadHelper = new   SFAListaDaSedeReadHelper();  
        sfareadHelper.accountObj = acc;
        sfareadHelper.codice_filiale = acc.OCS_External_Id__c;
        for (integer i=0;i<350;i++) {
            listInOut.add(sfareadHelper);
        }
        List<SFAListaDaSedeReadHelper> listInError = new List<SFAListaDaSedeReadHelper>();    
        Map<String, List<Account>> mapBranch = new Map<String, List<Account>>();
        Map<String, Group> mapGroup = new Map<String, Group>();
        mapGroup.put('F'+acc.OCS_External_Id__c,g);
        List<Account> listAccount = new List<Account>(); 
        listAccount.add(acc);   
        mapBranch.put(AccountUtils.OCSBranchChar+acc.OCS_External_Id__c,listAccount);
  
		System.debug('INIZIO BATCH');
        Test.startTest();
        SFAListaDaSedeGetCaseBatch bat = new SFAListaDaSedeGetCaseBatch(tipoAtt.id, listeCaricate.id, Date.today(),  listInOut, listInError,listAccount,mapBranch,mapGroup);
        database.executebatch(bat,10);
        Test.stopTest();
        // verify
        List<SFAListaDaSedeReadHelper> listerror = bat.listInError;
        System.assert(listerror.size()==0);

    }

    @isTest
    public static void wrapperTest() {
        Test.startTest();
        SFAListaDaSedeGetCaseBatch.SFA_ListaCheckWrapper wrapper = new  SFAListaDaSedeGetCaseBatch.SFA_ListaCheckWrapper();
        SFA_TipologiaLista__c tipoAtt = new SFA_TipologiaLista__c();
        insert tipoAtt;
        SFA_ListeCaricate__c listeCaricate = new SFA_ListeCaricate__c(Nome_Lista__c = 'nome_lista',Tipo_Attivita__c = tipoAtt.id);
        insert listeCaricate;
        for (integer i=0;i<300;i++) {
            //(String idLista, String name,String ocs_code, String piva, String codicefiscale, String errormessaggio)
            String iva = i<10 ? '1234567890'+i : i<100 ? '123456789'+i : '12345678'+i;
            wrapper.addElem(listeCaricate.id, 'name'+i, 'C80'+i, iva, iva, 'error');
        }
        wrapper.insertList();
        Test.stopTest();
        List<SFA_ListaCheck__c> listaCheck = [SELECT ID FROM SFA_ListaCheck__c];
        System.assert(listaCheck.size()==299);
    }  
}