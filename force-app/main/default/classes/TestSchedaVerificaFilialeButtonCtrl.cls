@isTest 
public with sharing class TestSchedaVerificaFilialeButtonCtrl {
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
    static void checkRequiredQuestionarioNull(){
        Scheda_Verifica_Filiale__c scheda =  [select id from Scheda_Verifica_Filiale__c limit 1];
        String result = SchedaVerificaFilialeButtonComponentCtrl.checkRequired(scheda.Id);
        System.assertEquals('questionario', result);
    }

    @isTest 
    static void checkRequiredWithQuestionario(){
        Scheda_Verifica_Filiale__c scheda =  [select id from Scheda_Verifica_Filiale__c limit 1];
        //list questionario
        List<Questionario_Scheda_Filiale__c> questionari = [SELECT ID FROM Questionario_Scheda_Filiale__c where Scheda_Verifica_Filiale__c=:scheda.Id];
        for(Questionario_Scheda_Filiale__c q : questionari){
            q.Esito_controllo_Attuale__c = 'OK';
        }
        update questionari;
        
        String result = SchedaVerificaFilialeButtonComponentCtrl.checkRequired(scheda.Id);
        
    }

    @isTest 
    static void sendApprovalUser(){
        Scheda_Verifica_Filiale__c scheda =  [select id from Scheda_Verifica_Filiale__c limit 1];
        
        String result = SchedaVerificaFilialeButtonComponentCtrl.sendApprovalUser(scheda.Id);
        System.assertEquals(null, result);
    }


     @isTest 
    static void getSchedaFilialePrecedente(){
        Scheda_Verifica_Filiale__c scheda = [SELECT ID FROM Scheda_Verifica_Filiale__c limit 1];
        scheda.Stato__c = '4'; //scheda chiusa
        update scheda;
        Account branch = [SELECT ID FROM ACCOUNT LIMIT 1];
        Scheda_Verifica_Filiale__c scheda1 = new Scheda_Verifica_Filiale__c();
        scheda1.Filiale__c = branch.ID;
        scheda1.periodo_dal__c = System.today();
        insert scheda1;
        String result = SchedaVerificaFilialeButtonComponentCtrl.getSchedaFilialePrecedente(branch.Id,scheda1.Id);
        System.assertEquals(scheda.Id, result);
    }

    @isTest 
    static void getSchedaFilialePrecedenteNoScheda(){
        Scheda_Verifica_Filiale__c scheda = [SELECT ID FROM Scheda_Verifica_Filiale__c limit 1];
        Account branch = [SELECT ID FROM ACCOUNT LIMIT 1];

        String result = SchedaVerificaFilialeButtonComponentCtrl.getSchedaFilialePrecedente(branch.Id,scheda.Id);
        System.assertEquals(null, result);
    }

}