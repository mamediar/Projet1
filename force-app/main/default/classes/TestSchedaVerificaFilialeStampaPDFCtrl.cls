@isTest
public with sharing class TestSchedaVerificaFilialeStampaPDFCtrl {
    @TestSetup
    static void makeData(){
        Recordtype r2 = [select id from Recordtype Where sObjectType = 'Account' AND Name ='Branch'];
        Account branch = new Account(Name = 'Alessandria',Recordtypeid = r2.id ,OCS_External_Id__c = 'F32',NameRoleReference__c='Alessandria');
        insert branch;
        Scheda_Verifica_Filiale__c scheda = new Scheda_Verifica_Filiale__c();
        scheda.Filiale__c = branch.ID;
        scheda.periodo_dal__c = System.today();
        insert scheda;
    }

    @isTest 
    static void initStampaPDF(){
        SchedaVerificaFilialeStampaPDFController controller = new SchedaVerificaFilialeStampaPDFController();
        Scheda_Verifica_Filiale__c scheda = [SELECT ID FROM Scheda_Verifica_Filiale__c limit 1];
        PageReference myVfPage = Page.SchedaVerificaFilialeStampaPDF;
        Test.setCurrentPage(myVfPage);

        // Put Id into the current page Parameters
        ApexPages.currentPage().getParameters().put('schedaId',scheda.Id);   
        ApexPages.currentPage().getParameters().put('stampaPDF','true'); 
        controller.init();
        System.assertEquals(true, controller.showIntestazioneScheda);
    }

    @isTest 
    static void initShowQuestionario(){
        SchedaVerificaFilialeStampaPDFController controller = new SchedaVerificaFilialeStampaPDFController();
        Scheda_Verifica_Filiale__c scheda = [SELECT ID FROM Scheda_Verifica_Filiale__c limit 1];
        PageReference myVfPage = Page.SchedaVerificaFilialeStampaPDF;
        Test.setCurrentPage(myVfPage);

        // Put Id into the current page Parameters
        ApexPages.currentPage().getParameters().put('schedaId',scheda.Id);   
        ApexPages.currentPage().getParameters().put('stampaQuestionario','true'); 
        controller.init();
        System.assertEquals(true, controller.showQuestionario);
    }

    @isTest 
    static void initStampaPratiche(){
        SchedaVerificaFilialeStampaPDFController controller = new SchedaVerificaFilialeStampaPDFController();
        Scheda_Verifica_Filiale__c scheda = [SELECT ID FROM Scheda_Verifica_Filiale__c limit 1];
        
        Pratica_Scheda_Filiale__c pratica = new Pratica_Scheda_Filiale__c(Scheda_Verifica_Filiale__c=scheda.ID);
        insert pratica;
        PageReference myVfPage = Page.SchedaVerificaFilialeStampaPDF;
        Test.setCurrentPage(myVfPage);

        // Put Id into the current page Parameters
        ApexPages.currentPage().getParameters().put('schedaId',scheda.Id);   
        ApexPages.currentPage().getParameters().put('stampaPratiche','true'); 
        controller.init();
        System.assertEquals(true, controller.showListaPratiche);
    }

    
}