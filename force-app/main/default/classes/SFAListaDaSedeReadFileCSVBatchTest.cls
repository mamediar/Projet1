@isTest
public with sharing class SFAListaDaSedeReadFileCSVBatchTest {

   @testSetup
   public static void setup() {
   }


    @isTest
    public static void runBatchBadTest() {
        SFA_TipologiaLista__c tipoAtt = new SFA_TipologiaLista__c();
        insert tipoAtt;
        SFA_ListeCaricate__c listeCaricate = new SFA_ListeCaricate__c(Nome_Lista__c = 'nome_lista',Tipo_Attivita__c = tipoAtt.id);
        insert listeCaricate;
        List<String> fields = new List<String>();
        String filedata = '\n1;2\n';
        Test.startTest();
        ID jobID = System.enqueueJob(new SFAListaDaSedeReadFileCSVBatch(filedata,fields, tipoAtt.id,'nome_lista', listeCaricate.id, Date.today()));
        Test.stopTest();
          // verify
        SFA_ListeCaricate__c listaCaricate = [SELECT Id, Nome_Lista__c, Data_Caricamento__c, Data_Visibilita__c,Numero_righe__c FROM SFA_ListeCaricate__c WHERE Id = :listeCaricate.id];
        System.assert(listaCaricate.Numero_righe__c==0);
       
    }


    @isTest
    public static void runBatchTest2() {
        SFA_TipologiaLista__c tipoAtt = new SFA_TipologiaLista__c();
        insert tipoAtt;
        SFA_ListeCaricate__c listeCaricate = new SFA_ListeCaricate__c(Nome_Lista__c = 'nome_lista',Tipo_Attivita__c = tipoAtt.id);
        insert listeCaricate;
        List<String> fields = new List<String>();
        String filedata = '\n1;2;3;4;5;6;7;8;9;10;11;12;13;14;15;16;17;18;19;20;21;22;23;24;25;26;27\n';
        Test.startTest();
        ID jobID = System.enqueueJob(new SFAListaDaSedeReadFileCSVBatch(filedata,fields, tipoAtt.id,'nome_lista', listeCaricate.id, Date.today()));
        Test.stopTest();
          // verify
        SFA_ListeCaricate__c listaCaricate = [SELECT Id, Nome_Lista__c, Data_Caricamento__c, Data_Visibilita__c,Numero_righe__c FROM SFA_ListeCaricate__c WHERE Id = :listeCaricate.id];
        System.assert(listaCaricate.Numero_righe__c==0);
       
    }

    
    @isTest
    public static void wrapperTest() {
        Test.startTest();
        SFAListaDaSedeReadFileCSVBatch.SFA_ListaCheckWrapper wrapper = new  SFAListaDaSedeReadFileCSVBatch.SFA_ListaCheckWrapper();
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