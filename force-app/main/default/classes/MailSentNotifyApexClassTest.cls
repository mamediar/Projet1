//----------------------------------------------------------------------
//-- - Author       : SANA BADJI
//-- - Date         : 29/07/2019
//-- - Description  : Handle MailSentNotifyApexClassTest
//----------------------------------------------------------------------
@isTest
public  class MailSentNotifyApexClassTest {

        public static EmailMessage thisEmailMessage;
        @TestSetup
        static void makeData(){
                
                Account[] accts = new List < Account > ();

                Account a1 = new Account(
                Name = 'test1', DEM_Da_Inviare__c = false,  BillingCity = 'San Francisco', OCS_External_Id__c = 'C11911134');

                Account a2 = new Account(
                Name = 'test2', DEM_Da_Inviare__c = true, BillingCity = 'San Francisco', OCS_External_Id__c = 'C11911135');

                Account a3 = new Account(
                Name = 'test3', DEM_Da_Inviare__c = false,  BillingCity = 'San Francisco', OCS_External_Id__c = 'C11911136');

                Account a4 = new Account(
                Name = 'test4', DEM_Da_Inviare__c = false,  BillingCity = 'San Francisco', OCS_External_Id__c = 'C11911137');

                Account a5 = new Account(
                Name = 'test5', DEM_Da_Inviare__c = true,  BillingCity = 'San Francisco', OCS_External_Id__c = 'C11911138');

                accts.add(a1);
                accts.add(a2);
                accts.add(a3);
                accts.add(a4);
                accts.add(a5);

                insert accts;

                System.debug(' listAccount '+ accts );


                Contact[] contacts = new List < Contact > ();
                Contact con1 = new Contact(
                FirstName = 'Joe', LastName = 'Smith', Phone = '415.555.1212', DEM_Da_Inviare__c = false, Ultima_DEM_Inserita__c = DateTime.now(), AccountId = a1.ID);
                Contact con2 = new Contact(
                FirstName = 'Ahmet', LastName = 'CISSE', Phone = '415.655.1312', DEM_Da_Inviare__c = false, Ultima_DEM_Inserita__c = DateTime.newInstance(2019, 5, 8, 10, 8, 16), AccountId = a2.ID);

                Contact con3 = new Contact(
                FirstName = 'Joe', LastName = 'Smith', Phone = '415.555.1212', DEM_Da_Inviare__c = true, Ultima_DEM_Inserita__c = DateTime.newInstance(2019, 5, 8, 10, 8, 16), AccountId = a3.ID);
                Contact con4 = new Contact(
                FirstName = 'Ahmet', LastName = 'CISSE', Phone = '415.655.1312', DEM_Da_Inviare__c = true, Ultima_DEM_Inserita__c = DateTime.now(), AccountId = a4.ID);

                Contact con5 = new Contact(
                FirstName = 'Joe', LastName = 'Smith', Phone = '415.555.1212', DEM_Da_Inviare__c = true, Ultima_DEM_Inserita__c = null, AccountId = a5.ID);

                contacts.add(con1);
                contacts.add(con2);
                contacts.add(con3);
                contacts.add(con4);
                contacts.add(con5);

                insert contacts;


                List<Product2> listproduit = new List<Product2>{
                        new Product2(Name='Produit1', Family='PP_ONLINE_COMPASS_DS',DEMAnomalie__c='2072'),
                        new Product2(Name='Produit2', Family='PP_ONLINE_PARTNER_DS',DEMAnomalie__c='2072'),
                        new Product2(Name='Produit3', Family='PP_ONLINE_COMPASS_DS',DEMAnomalie__c='2072'),
                        new Product2(Name='Produit4', Family='PF_ECOMMERCE_STANDARD',DEMAnomalie__c='2072'),
                        new Product2(Name='Produit5', Family='PP_ONLINE_PARTNER_DS',DEMAnomalie__c='2072'),
                        new Product2(Name='Produit6', Family='PP_ONLINE_COMPASS_DS',DEMAnomalie__c='2072'),
                        new Product2(Name='Produit7', Family='PP_ONLINE_COMPASS_DS',DEMAnomalie__c='2072'),
                        new Product2(Name='Produit8', Family='PP_ONLINE_COMPASS_DS',DEMAnomalie__c='2072'),
                        new Product2(Name='Produit9', Family='PP_ONLINE_COMPASS_DS',DEMAnomalie__c='2072'),
                        new Product2(Name='Produit10', Family='PF_ECOMMERCE_STANDARD',DEMAnomalie__c='2072'),
                        new Product2(Name='Produit11', Family='PF_ECOMMERCE_STANDARD',DEMAnomalie__c='2072')
                };
                insert listproduit;
                System.debug(' listproduit '+ listproduit );

                Id recordType=CGMWSUtils_1_0.getRecordTypeId('Case','CRM_RichiestaOnline');

                Case v1 = new Case (Stato_Pratica__c='20',AccountId=accts[0].Id,NumeroPratica__c='18866725',
                Attributi_Pratica__c ='SD',stato_ocs__c='20SD',RO_Vecchio_Cellulare__c='773528750',
                Product__c=listproduit[0].Id,RecordTypeId=recordType,Subject='This is a test case for testCaseForForum');
                insert v1;
                // System.debug(' caseNumberv1 '+ v1[0].caseNumber );

                thisEmailMessage= new EmailMessage(
                        CcAddress='vi@gmail.com',
                        FromName='Sanadev',
                        HtmlBody='<html><body><b>Hello</b></body></html>',
                        Subject='Prestito Online Compass: conferma inserimento richiesta',
                        TextBody='Pratica caricata Gentile ripalta gasbarro',
                        ToAddress='ass@gmail.com',
                        RelatedToId=a1.Id,
                        BccAddress='20190301120702_vivacity.dibiase@gmail.com_GSBRLT49A51C514S_20442189__3105541',
                        ParentId=V1.Id);
                upsert thisEmailMessage;
        }

        @IsTest
        static void mailSentNotifyTest(){
                Test.startTest();
                List<Case> listCase = [SELECT Id,LastModifiedDate ,caseNumber,AccountId  FROM Case ];
                List<EmailMessage> listEmailMessage = 
                [SELECT Id, ParentId,RelatedToId,CcAddress,FromName,HtmlBody,Subject,TextBody,ToAddress,
                BccAddress  FROM  EmailMessage ];
                EmailMessage emailMessage = new  EmailMessage(
                        CcAddress=null,
                        FromName=null,
                        HtmlBody=null,
                        Subject=null,
                        TextBody=null,
                        ToAddress=null,
                        RelatedToId=null,
                        BccAddress=null,
                        ParentId=null);
                insert emailMessage;
                MailSentNotifyApexClass.EmailMessageWrapper emM = new MailSentNotifyApexClass.EmailMessageWrapper(emailMessage);
                emM.destionatariCC='';
                emM.mittente='';
                emM.utenteEsternoOrInterno='';
                emM.corpoHtml='';
                emM.corpoText='';
                emM.template='';
                emM.allegati='';
                emM.destinatario='';
                emM.oggetto='';
                emM.mailId='';
                emM.crmIncidentId='';
                emM.accountId='';

                //ID thisEmailMess
                MailSentNotifyApexClass.MailSentNotifyResponse mailSentNotifyResponse = new MailSentNotifyApexClass.MailSentNotifyResponse(1L,'');
                mailSentNotifyResponse = MailSentNotifyApexClass.mailSentNotify(listEmailMessage[0].CcAddress,
                'Compass Banca S.p.a,richiesta@compass.it', 
                listEmailMessage[0].FromName, listEmailMessage[0].HtmlBody,listEmailMessage[0].TextBody,
                '3105541', 'Low', listEmailMessage[0].Subject,  listEmailMessage[0].ToAddress, 
                listEmailMessage[0].BccAddress, 
                listEmailMessage[0].ParentId, listEmailMessage[0].RelatedToId);
                // Verify new record was created
                System.assertEquals(mailSentNotifyResponse.resultCode, 0L);  
                System.assertEquals(1, listCase.size(), 'listCase.size()==1');
                Test.stopTest();
        }
}