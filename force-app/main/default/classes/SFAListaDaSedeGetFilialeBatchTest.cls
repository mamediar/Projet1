@isTest
public with sharing class SFAListaDaSedeGetFilialeBatchTest {

    @isTest
    public static void runBatchTest() {
        SFA_TipologiaLista__c tipoAtt = new SFA_TipologiaLista__c();
        insert tipoAtt;
        SFA_ListeCaricate__c listeCaricate = new SFA_ListeCaricate__c(Nome_Lista__c = 'nome_lista',Tipo_Attivita__c = tipoAtt.id);
        insert listeCaricate;
        Group g = new Group(DeveloperName = 'Devname',type = 'queue',Name = 'CodaName');
        insert g;
        List<Account> accounts = new List<Account>();
        List<SFAListaDaSedeReadHelper> listInOut = new List<SFAListaDaSedeReadHelper>();
        SFAListaDaSedeReadHelper sfareadHelper = new   SFAListaDaSedeReadHelper();  
        sfareadHelper.codice_filiale = '762934';
        listInOut.add(sfareadHelper);
        List<SFAListaDaSedeReadHelper> listInError = new List<SFAListaDaSedeReadHelper>();    
        Map<String, List<Account>> mapBranch = new Map<String, List<Account>>();
        Test.startTest();
        SFAListaDaSedeGetFilialeBatch bat = new SFAListaDaSedeGetFilialeBatch(tipoAtt.id, listeCaricate.id, Date.today(),  listInOut, listInError,accounts, mapBranch);
        database.executebatch(bat,1000);
        Test.stopTest();
        // verify
        List<SFAListaDaSedeReadHelper> listerror = bat.listInError;
        System.assert(listerror.size()==0);

    }


    @isTest
    public static void wrapperTest() {
        Test.startTest();
        SFAListaDaSedeGetFilialeBatch.SFA_ListaCheckWrapper wrapper = new  SFAListaDaSedeGetFilialeBatch.SFA_ListaCheckWrapper();
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