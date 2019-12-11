/**
 * @Description        : Class test for GD_Batch_Dealer_Isvap_Courses_Send_Alert
 * @Author             : Khadim R Ndeye
 * @Date               : 01/10/2019
 **/
@isTest
public class GDBatchDealerIsvapCoursesSendAlertTest {
    @TestSetup
    static void makeData(){ 
        Contact c = new Contact(Email='testcontact@email.com', FirstName='FirstName', LastName='LasttName');
        insert c;
        Id rtId = [SELECT Id FROM RecordType WHERE IsPersonType = TRUE AND SObjectType='Account' LIMIT 1].Id;
        List<Account> accts = new List<Account>();
        for(Integer i=0;i<2;i++) {
           // Account a = new Account(Name='TestAccount' + i, PersonEmail='moustapha.diop@enigen.eu');
            Account a = new Account(RecordTypeId=rtId);
            a.FirstName = 'Test ' + i;
			a.LastName = 'Account ' + i;
            a.PersonEmail='moustapha.diop@enigen.eu';
            accts.add(a);
        }
        
        insert accts;
        IVASS_Dealer_courses_type__c typCorso = new IVASS_Dealer_courses_type__c(Active__c=true, Type_Course_Desc__c='BASE', Type_Course_Name__c='tipo_A');
        insert typCorso;
        IVASS_Dealer_Courses__c corso = new IVASS_Dealer_Courses__c( Attivo__c=true, Tipo_Corso__c=typCorso.Id, Name='2019 BASE');
        insert corso;
        List <IVASS_Dealer_courses_Sollecito__c> solleciti = new List <IVASS_Dealer_courses_Sollecito__c>();
        /*IVASS_Dealer_courses_Sollecito__c sollecito = new IVASS_Dealer_courses_Sollecito__c(Ultimo_Invio__c= Date.today(), Intervallo_di_alert__c=2, Destinatari_Sollecito__c='Dealer + Referente	', Tipo_Ricevente__c='Dealer + Ref', Tipo_Corso__c=typCorso.Id, Attivo__c=true);
        solleciti.add(sollecito);
        IVASS_Dealer_courses_Sollecito__c sollecito2 = new IVASS_Dealer_courses_Sollecito__c(Ultimo_Invio__c= Date.today(), Intervallo_di_alert__c=2, Destinatari_Sollecito__c='Referente', Tipo_Ricevente__c='Ref', Tipo_Corso__c=typCorso.Id, Attivo__c=true);
        solleciti.add(sollecito2);
        IVASS_Dealer_courses_Sollecito__c sollecito3 = new IVASS_Dealer_courses_Sollecito__c(Ultimo_Invio__c= Date.today(), Intervallo_di_alert__c=2, Destinatari_Sollecito__c='Dealer', Tipo_Ricevente__c='Dealer', Tipo_Corso__c=typCorso.Id, Attivo__c=true);
        solleciti.add(sollecito3);*/
        insert solleciti;
        IVASS_Dealer_courses_Iscritti__c iscritto = new IVASS_Dealer_courses_Iscritti__c(Corso__c=corso.Id, Cognome__c='Cognome', Nome__c='Nome', Dealer__c=accts[1].Id, Referente__c=accts[0].Id, Stato_Corso__c='IN ITINERE');
        insert iscritto;
        
    }

    @isTest
    static void test() {        
        Test.startTest();
        GD_Batch_Dealer_Isvap_Courses_Send_Alert batchDealer = new GD_Batch_Dealer_Isvap_Courses_Send_Alert();
        Id batchJobId = Database.executeBatch(batchDealer, 200);
        System.debug('batchJobId >>'+batchJobId);
        /*Integer invocations = batchDealer.recordsProcessed;
        Integer invocations = [SELECT Id, JobType, JobItemsProcessed, TotalJobItems FROM AsyncApexJob WHERE Id=:batchJobId].JobItemsProcessed;
        System.assertEquals(3, invocations, '3 emails should be sent');*/
        Test.stopTest();
    }
}