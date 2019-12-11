@isTest
public with sharing class SFAListaDaSedeBatListaCheckDeleteTest {

    @TestSetup
    static void makeData(){       
        SFA_TipologiaLista__c tipo = new SFA_TipologiaLista__c(Name='tipologia',Descrizione__c = 'desc');
        insert tipo; 
        SFA_ListeCaricate__C lista = new SFA_ListeCaricate__C(Chiuso__c=false,Nome_Lista__c = 'nomeLista',Tipo_Attivita__c = tipo.id);
        insert lista;
        SFA_ListaCheck__c listaCheck = new SFA_ListaCheck__c(SFA_ListeCaricate__c=lista.id);
        insert listaCheck;
    }


    @isTest
    public static void runBatchTest() {
        Test.startTest();
        Id batchJobId = Database.executeBatch(new SFAListaDaSedeBatListaCheckDelete(), 200);
        Test.stopTest();
    }

    @isTest
    public static void testSchedulable() {
        Test.startTest();
        SFAListaDaSedeBatListaCheckDelete bat = new SFAListaDaSedeBatListaCheckDelete();
        bat.execute(null);
        Test.stopTest();
    }
    
}