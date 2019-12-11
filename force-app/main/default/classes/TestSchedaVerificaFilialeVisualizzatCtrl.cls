@isTest
public with sharing class TestSchedaVerificaFilialeVisualizzatCtrl {

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
    public static void updateLettaOk(){
        Scheda_Verifica_Filiale__c schedaBefore = [SELECT ID,Letta_Responsabile__c FROM Scheda_Verifica_Filiale__c LIMIT 1];
        SchedaVerificaFilialeVisualizzatoCtrl.updateLetta(schedaBefore.ID, 'Letta_Responsabile__c');
        Scheda_Verifica_Filiale__c schedaAfter = [SELECT ID,Letta_Responsabile__c FROM Scheda_Verifica_Filiale__c LIMIT 1];
        System.assertEquals(true, schedaAfter.Letta_Responsabile__c);
        System.assertEquals(false, schedaBefore.Letta_Responsabile__c);
    }

    @isTest 
    public static void updateLettaKO(){
        Scheda_Verifica_Filiale__c schedaBefore = [SELECT ID,Letta_Responsabile__c FROM Scheda_Verifica_Filiale__c LIMIT 1];
        String returnValue = SchedaVerificaFilialeVisualizzatoCtrl.updateLetta(schedaBefore.ID, 'Filiale__c');
        System.assert(returnValue!=null);
    }
}