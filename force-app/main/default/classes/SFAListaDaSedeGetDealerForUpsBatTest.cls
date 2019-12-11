@isTest
public with sharing class SFAListaDaSedeGetDealerForUpsBatTest {


   @isTest
    public static void runBatchTest() {
        SFA_TipologiaLista__c tipoAtt = new SFA_TipologiaLista__c();
        insert tipoAtt;
        SFA_ListeCaricate__c listeCaricate = new SFA_ListeCaricate__c(Nome_Lista__c = 'nome_lista',Tipo_Attivita__c = tipoAtt.id);
        insert listeCaricate;
        List<RecordType> rDealer = [Select id  From RecordType  Where sObjectType = 'Account'and RecordType.Name = 'Dealer'];
   
        Account acc = new Account(
            Name = 'MARIO ROSSI',                        
            Data_Nascita__c = Date.valueOf('1944-08-23'),
            OCSAreaId__c = 2,
            OCS_External_Id__c ='C5000',
            Codice_Cliente__c ='5000',
            Codice_Fiscale__c ='ABCDEF12C03T769P',
            Region_Name__c = 'RC',
            recordtypeid=rDealer[0].id
        );
        insert acc;
        List<SFAListaDaSedeReadHelper> listInOut = new List<SFAListaDaSedeReadHelper>();
        SFAListaDaSedeReadHelper sfareadHelper = new   SFAListaDaSedeReadHelper();  
        sfareadHelper.accountObj = acc;
        listInOut.add(sfareadHelper);
        List<SFAListaDaSedeReadHelper> listInError = new List<SFAListaDaSedeReadHelper>();    
        Map<String, List<Account>> mapBranch = new Map<String, List<Account>>();
        Test.startTest();
        SFAListaDaSedeGetDealerForUpsertBatch bat = new SFAListaDaSedeGetDealerForUpsertBatch(tipoAtt.id, listeCaricate.id, Date.today(),  listInOut, listInError,mapBranch);
        database.executebatch(bat,10);
        Test.stopTest();
        // verify
        List<SFAListaDaSedeReadHelper> listerror = bat.listInError;
        System.assert(listerror.size()==0);

    }


    @isTest
    public static void wrapperTest() {
        Test.startTest();
        SFAListaDaSedeGetDealerForUpsertBatch.SFA_ListaCheckWrapper wrapper = new  SFAListaDaSedeGetDealerForUpsertBatch.SFA_ListaCheckWrapper();
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