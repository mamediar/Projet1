@isTest
public with sharing class SFAListaDaSedeGestListeCaricateCtrlTest {


    @TestSetup
    static void makeData(){       
        SFA_TipologiaLista__c tipo = new SFA_TipologiaLista__c(Name='tipologia',Descrizione__c = 'desc');
        insert tipo; 
        SFA_ListeCaricate__C lista = new SFA_ListeCaricate__C(Chiuso__c=false,Nome_Lista__c = 'nomeLista',Tipo_Attivita__c = tipo.id);
        insert lista;
    }


    @isTest
     public static void test1(){
        Test.startTest();
        List<SFA_ListeCaricate__c>  listResult = SFAListaDaSedeGestListeCaricateCtrl.getListeCaricate(1,true);
        System.assertEquals(1,listResult.size());
        listResult = SFAListaDaSedeGestListeCaricateCtrl.getListeCaricate(1,false);
        System.assertEquals(1,listResult.size());
        Test.stopTest();
     }


    @isTest
     public static void test2(){
        Test.startTest();
        Integer tot = SFAListaDaSedeGestListeCaricateCtrl.totalListeCaricate(true);
        System.assertEquals(1,tot);
        tot= SFAListaDaSedeGestListeCaricateCtrl.totalListeCaricate(false);
        System.assertEquals(1,tot);
        Test.stopTest();
     }

    @isTest
     public static void test3(){
        Test.startTest();
        List<SFA_ListeCaricate__c> lista = [SELECT ID FROM SFA_ListeCaricate__c];
        Boolean res = SFAListaDaSedeGestListeCaricateCtrl.closeAllRelatedCase(lista);
        System.assertEquals(true,res);
        Test.stopTest();
     }

    @isTest
     public static void test4(){
        Test.startTest();
        List<SFA_ListeCaricate__c> lista = [SELECT ID FROM SFA_ListeCaricate__c];
        Integer res = SFAListaDaSedeGestListeCaricateCtrl.updateListeCaricate(lista);
        System.assertEquals(1,res);
        Test.stopTest();
     }

}