@isTest
public with sharing class SFAListaDaSedeCHeckFilialeBatchTest {



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
            OCS_External_Id__c ='C5000',
            Codice_Cliente__c ='5000',
            Codice_Fiscale__c ='ABCDEF12C03T769P',
            Region_Name__c = 'RC',
            Partita_IVA__c = '12345678901',
            recordtypeid=rDealer[0].id
        );
        insert acc;

        List<SFAListaDaSedeReadHelper> listInExam = new List<SFAListaDaSedeReadHelper>();
        SFAListaDaSedeReadHelper sfareadHelper = new   SFAListaDaSedeReadHelper();  
        sfareadHelper.accountObj = acc;
        listInExam.add(sfareadHelper);
        Test.startTest();
        List<SFAListaDaSedeReadHelper> listInError = new List<SFAListaDaSedeReadHelper>();    
        SFAListaDaSedeCHeckFilialeBatch bat = new SFAListaDaSedeCHeckFilialeBatch(tipoAtt.id, listeCaricate.id, Date.today(),  listInExam, listInError);
        database.executebatch(bat,10);
        Test.stopTest();
        // verify
        SFA_ListeCaricate__c listaCaricate = [SELECT Id, Nome_Lista__c, Data_Caricamento__c, Data_Visibilita__c,Numero_righe__c FROM SFA_ListeCaricate__c WHERE Id = :listeCaricate.id];
        System.assert(listaCaricate.Numero_righe__c==0);

    }

	
    @isTest
    public static void wrapperTest() {
        Test.startTest();
        SFAListaDaSedeCHeckFilialeBatch.SFA_ListaCheckWrapper wrapper = new  SFAListaDaSedeCHeckFilialeBatch.SFA_ListaCheckWrapper();
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