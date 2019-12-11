@isTest
public  class CGMWSUtils_1_0_Test {
    
  	@testSetup static void makeData() {
       
       List<XCS_Template__c> templateTesto = new  List<XCS_Template__c>{
       new  XCS_Template__c (Name='SMSAbbandonoNONForzPreSecci', Body__c='template test'),
       new  XCS_Template__c (Name='SMSAbbandonoWEBPreSecci', Body__c='template test'),
       new  XCS_Template__c (Name='SMSAbbandonoWEBPostSecci', Body__c='template test'),
       new  XCS_Template__c (Name='SMSAbbandonoForz', Body__c='template test'),
       new  XCS_Template__c (Name='SMSAbbandonoPostSecci', Body__c='template test'),
       new  XCS_Template__c (Name='DEMAbbandonoNONForzPreSecci', Body__c='template test')
       };
       insert templateTesto;
    /*   List<EmailTemplate> emailTemplate = new List<EmailTemplate>{  SMSAbbandonoNONForzPreSecci
           new emailTemplate(Name='DEMAbbandonoNONForzPreSecci'),
           new EmailTemplate (Name ='DEMAbbandonoWEBPostSecci'),
           new EmailTemplate (Name ='DEMAbbandonoForz'),
           new EmailTemplate (Name ='DEMAnomalieContratto_DS'),
           new EmailTemplate (Name ='DEMAnomalieDoc_DS')
       };
       insert emailTemplate; */
        List<Case> v1 = new List<Case>{
            new Case (RO_Link_Bozza__c='link', Codice_Cliente__c='54412587', Status='On Hold'),
            new Case ( RO_Link_Bozza__c= 'test', Codice_Cliente__c='544587'),
            new Case (Codice_Cliente__c ='5425')
        };
      insert v1;    
        
                
	}
  
   	@isTest static void comparedDateTimeTest(){
       
       Test.startTest();
       Datetime d1 = Datetime.now();
       Datetime d2 = Datetime.newInstance(2019, 6, 28, 12, d1.minute(), d1.second());
       System.debug('************* d1'+d1);
       System.debug('************* d2'+d2);
           if(d1 == d2){
            System.debug('************ Yesy');
        }
        else {
             System.debug('************ No');
        }
        Boolean t = CGMWSUtils_1_0.comparedDateTime(d1, d2);
        System.debug('******  test '+t);
        CGMWSUtils_1_0.CGMWSRException Exc = new CGMWSUtils_1_0.CGMWSRException('MESSAGE','ADDITIONAL_INFO');
       Test.stopTest();
   }
    
    @isTest static void getRecordTypeIdTest(){
        
        String developerName ='CRM_RichiestaOnline';
        String objectName = 'Case';
        
        test.startTest();
        	Id recTypeId = CGMWSUtils_1_0.getRecordTypeId(objectName ,developerName);
        test.stopTest();
        System.debug('#######RecTypeID###### '+recTypeId);
        System.assert(recTypeId != null);
    }  
    
    @isTest static void getTemplateByDeveloperNameTest(){
        
        String developerName ='CRM_RichiestaOnline';

        List<EmailTemplate> emailTemplates = new List<EmailTemplate>();
		EmailTemplate emailTemplate = new EmailTemplate(Name='Test',
                                                        TemplateType='text',
                                                        Subject='',
                                                        HtmlValue='',
                                                        FolderId=UserInfo.getUserId(),
                                                        DeveloperName='CRM_RichiestaOnline');
        emailTemplates.add(EmailTemplate);
        insert emailTemplates;
        
        test.startTest();
        	List<EmailTemplate> eTemplates = CGMWSUtils_1_0.getTemplateByDeveloperName(developerName);
        test.stopTest();
        
        System.debug('#######eTemplates###### '+eTemplates);
        System.assert(eTemplates[0].Id != null);
    }      
    
   	@isTest static void formatDateTest(){
        
        test.startTest();
        	String newDate = CGMWSUtils_1_0.formatDate(Datetime.newInstance(Date.newInstance(Date.Today().Year(), Date.Today().Month(), Date.Today().Day()),Time.newInstance(18, 30, 2, 20)),5);
        test.stopTest();
       
        System.debug('#######newDate###### '+newDate);
        System.assert(newDate != '');
    }          

    @isTest static void sendEmailByInvioDEMTest(){
        
        List<Case> cases = new List<Case>{
        	new Case(NumeroPratica__c='10000008',RO_Vecchio_Cellulare__c='773739676'),
        	new Case(NumeroPratica__c='100')
    	};
    	insert cases;
   		List<Anomalie_Doc__c> anomalies = new List<Anomalie_Doc__c>{
        	new Anomalie_Doc__c(CaseId__c= Cases[0].Id),
        	new Anomalie_Doc__c(CaseId__c= cases[1].Id)
    	};
    	insert anomalies;
        
        test.startTest();
        	CGMWSUtils_1_0.sendEmailByInvioDEM(anomalies);
        test.stopTest();
    }

    @isTest static void sendInvioDemAndSMSTest(){
      

        List<Account> accounts = new List<Account>{
            new Account(LastName='BALDE'),
            new Account(LastName='Madicke')
        };
        insert accounts;
          List<Contact> contacts  = new List<Contact>{
            new Contact(LastName='contact1'),
            new Contact(LastName='contact2')
        };
        insert contacts;

      	List<Case> cases = new List<Case>{
        	new Case(NumeroPratica__c='10000008',RO_Vecchio_Cellulare__c='773739676', AccountId= accounts[0].Id),
        	new Case(NumeroPratica__c='100', AccountId= accounts[1].Id)
    	};

    	insert cases;
        Map<Id,Case> caseMap = new Map<Id,Case>{cases[0].id => cases[0]};
        test.startTest();
        //	CGMWSUtils_1_0.sendInvioDemAndSMS(caseMap, 'SMSAbbandonoNONForzPreSecci')  ;
        CGMWSUtils_1_0.sendInvioDemAndSMS(caseMap, 'DEMAbbandonoNONForzPreSecci', '2061','SMSAbbandonoNONForzPreSecci', '[first_name], fissa un appuntamento per il tuo Prestito Compass!', 'richiesta@compass.it', 'Compass Banca S.p.A ');
        test.stopTest();
    }
    
    @isTest static void formatedDatimeToStringSchedulableTest(){
        test.startTest();
        	CGMWSUtils_1_0.formatedDatimeToStringSchedulable(Datetime.newInstance(2019, 03, 02));
        test.stopTest();
    }  
    
    @isTest static void DatetimeWithin30mnTest(){
        Datetime dt1 = Datetime.newInstance(2019, 03, 05, 11, 10, 00);
        Datetime dt2 = Datetime.newInstance(2019, 03, 05, 11, 40, 00);   
        test.startTest();
        	Boolean result = CGMWSUtils_1_0.DatetimeWithin30mn(dt1,dt2);
        test.stopTest();
    }  
    
    @isTest static void dividendoEliminaTest(){
        String dateString = '20190802';
        String importoString = '233-122';
        
        test.startTest();
        	CGMWSUtils_1_0.dividendoElimina( dateString , importoString);
        test.stopTest();
    } 

    @isTest static void checkIfMovementIsInLast30daysTest(){
        String formatedString = '20190707';
        test.startTest();
        	CGMWSUtils_1_0.checkIfMovementIsInLast30days(formatedString);
        test.stopTest();
    } 
    
    @isTest static void DateoStringTest(){
        
        Date value = Date.newInstance(2019, 03, 02);
        test.startTest();
        	String dateString = CGMWSUtils_1_0.ToString(value);
        test.stopTest();
       	System.assert(dateString != '');
    } 
    
    @isTest static void timeToStringTest(){
        
        Time value = Time.newInstance(19, 00, 00, 00); 
        
        test.startTest();
        	String dateString = CGMWSUtils_1_0.ToString(value);
        test.stopTest();
       	System.assert(dateString != '');
    } 
    
    @isTest
    static void convertTimeToStringtest(){
        Time t = Time.newInstance(2, 10, 30, 0);
        Test.startTest();
        String ch = CGMWSUtils_1_0.convertTimeToString(t);
        System.debug('############### ch '+ch);
        Test.stopTest();
    }
    @isTest
    static void schedulableJobexecutetest(){
        Map<Id, Case> mapCase = new Map<Id, Case>([SELECT Id, LastModifiedDate FROM Case]);
        Test.startTest();
        CGMWSUtils_1_0.schedulableJobexecute(mapCase, 'AFTER_THIRTY_MINUTES');
        Test.stopTest();
    }
    
}