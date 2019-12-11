@isTest
public class SFAListaDaSedeChiusuraListe_Test {
    testMethod public static void test1(){

        Case c = new Case();
        c.Status = 'New';
        c.Subject = 'Test';
        c.Esito__c='Esit';
        
        Group g = new Group();
        g.Name = 'TestName';
        g.DeveloperName = 'devTest';
        g.Type = 'queue';
        insert g; 
        
        User u = new User(); 
        u.DefaultQueueId__c = g.DeveloperName;
        u.Username = 'Giu@k.k';
        u.LastName='Seppe';
        u.Email='sij@iol.io';
        u.CommunityNickname='sid';
        u.TimeZoneSidKey='Europe/Rome';
        u.LocaleSidKey='it';
        u.EmailEncodingKey='UTF-8';
        u.ProfileId=[SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
        u.LanguageLocaleKey='it';
        u.Alias='df';
        insert u;
 
        System.runAs(u){

            SFA_TipologiaLista__c tl = new SFA_TipologiaLista__c(Name='nome_attivita_test');
            insert tl;

            SFA_ListeCaricate__c lst = new SFA_ListeCaricate__c();
            lst.Nome_Lista__c = 'lista_test';
            lst.Tipo_Attivita__c = tl.Id;
            insert lst;

            List<SFA_ListeCaricate__c> liste = new List<SFA_ListeCaricate__c>();
            liste.add(lst);

            c.SFA_ListeCaricate__c = lst.Id;
            insert c; 

            system.assertEquals(true, SFAListaDaSedeGestListeCaricateCtrl.closeAllRelatedCase(liste));
            
        }
    }
}