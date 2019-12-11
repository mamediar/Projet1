@isTest 
public with sharing class TestSchedaVerificaFilialeSharingRecalc {
    @TestSetup
    static void makeData(){
        Recordtype r2 = [select id from Recordtype Where sObjectType = 'Account' AND Name ='Branch'];
        Account branch = new Account(Name = 'Alessandria',Recordtypeid = r2.id ,OCS_External_Id__c = 'F32',NameRoleReference__c='Alessandria',OCSAreaId__c=3);
        insert branch;
        Scheda_Verifica_Filiale__c scheda = new Scheda_Verifica_Filiale__c();
        scheda.Filiale__c = branch.ID;
        scheda.periodo_dal__c = System.today();
        insert scheda;
    }

    @isTest     
    static void startJob(){
        Test.startTest();
        SchedaVerificaFilialeSharingRecalc ctrl = new SchedaVerificaFilialeSharingRecalc();
        Id batchId = Database.executeBatch(ctrl);
        Test.stopTest();
    }

    @isTest     
    static void startJobWithDate(){
        Test.startTest();
        SchedaVerificaFilialeSharingRecalc ctrl = new SchedaVerificaFilialeSharingRecalc(System.today(),System.today().addDays(1));
        Id batchId = Database.executeBatch(ctrl);
        Test.stopTest();
    }
}