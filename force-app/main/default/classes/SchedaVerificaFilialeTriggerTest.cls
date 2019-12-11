@isTest
public class SchedaVerificaFilialeTriggerTest {

    @TestSetup
    static void makeData(){
        Recordtype r2 = [select id from Recordtype Where sObjectType = 'Account' AND Name ='Branch'];
        Account branch = new Account(Name = 'Alessandria',Recordtypeid = r2.id ,OCS_External_Id__c = 'F32',NameRoleReference__c='Alessandria');
        insert branch;
    }

    @isTest
    static void insertRecord(){
        Account acc = [SELECT ID FROM ACCOUNT WHERE Recordtype.developername = 'Branch' limit 1];
        Scheda_Verifica_Filiale__c scheda = new Scheda_Verifica_Filiale__c();
        scheda.Filiale__c = acc.id;
        scheda.Periodo_dal__c = System.today();
        insert scheda;

    }

    @isTest
    static void updateRecord(){
        Account acc = [SELECT ID FROM ACCOUNT WHERE Recordtype.developername = 'Branch' limit 1];
        Scheda_Verifica_Filiale__c scheda = new Scheda_Verifica_Filiale__c();
        scheda.Filiale__c = acc.id;
        scheda.Periodo_dal__c = System.today();
        insert scheda;

        scheda.Periodo_dal__c = System.today().addDays(1);
        update scheda;

    }

    @isTest
    static void deleteRecord(){
        Account acc = [SELECT ID FROM ACCOUNT WHERE Recordtype.developername = 'Branch' limit 1];
        Scheda_Verifica_Filiale__c scheda = new Scheda_Verifica_Filiale__c();
        scheda.Filiale__c = acc.id;
        scheda.Periodo_dal__c = System.today();
        insert scheda;

        delete scheda;

    }
}