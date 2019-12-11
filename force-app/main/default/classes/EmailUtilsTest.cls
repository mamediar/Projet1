@isTest
public class EmailUtilsTest {
    
    @testSetup
    static void setup(){
 
             
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        User UtenteMAIL= null;
        System.runAs (thisUser) {
            //Profile standard user:
            Profile profileId = [SELECT Id,PermissionsEmailMass, PermissionsEmailSingle FROM Profile WHERE Name =:ProfileUtils.MonitoraggioDealer LIMIT 1];
            UserRole userRoleId = [SELECT Id FROM UserRole WHERE Name =:RoleUtils.MonitoraggioDealer LIMIT 1];
            System.assert(profileId.PermissionsEmailMass);
            System.assert(profileId.PermissionsEmailSingle);
            //utente Regional Manager:
            UtenteMAIL = new User(LastName = 'UtenteMAIL',
                                FirstName='JASON',
                                Alias = 'jliv',
                                Email = 'jason.liveston@asssdf.com',
                                Username = 'jason1.liveston@asssdf.com',  
                                ProfileId = profileId.id,
                                TimeZoneSidKey = 'GMT',
                                LanguageLocaleKey = 'en_US',
                                EmailEncodingKey = 'UTF-8',
                                DefaultQueueId__c = 'F32',
                                UserRoleId=userRoleId.id,
                                LocaleSidKey = 'en_US'
                               );
            insert UtenteMAIL;   
            
            
        }
 
        XCS_CompassParameters__c obj = new XCS_CompassParameters__c();
            obj.Name = 'inviomail.mock';
            obj.Value__c ='inviomail@mock.it';
            insert obj;  
         
			
        	Account acc = TestMockUtils.getDummyAccount();
        	acc.OwnerId=UtenteMAIL.id;
        	insert acc;
        	Contact cont = TestMockUtils.getDummyContact( acc.id );
            insert cont;       
        
             

    }
    
    @isTest
    public static void generateEmailTest(){   
        
        User utenteMAIL=[SELECT id FROM User where LastName='UtenteMAIL'];    
        
        Contact cont=[SELECT id FROM Contact where LastName='Dummy'];
        
        String devName = 'SFA_PraticaIrregolare_MailArea';
        List<String> listEmail = new List<String>();
        listEmail.add('emilio@gmail.com');
        listEmail.add('vitali_alvaro@gmail.com');
        List<String> ccAddress = new List<String>();
        ccAddress.add('prova@hotmail.it');
        List<String> bccAddress = new List<String>();
        bccAddress.add('bccProva@hotmail.it');        
        List<id> attachment = new List<id>();      
        Messaging.SingleEmailMessage[] messageToSend = new Messaging.SingleEmailMessage[]{};
            Messaging.SingleEmailMessage  m = new   Messaging.SingleEmailMessage ();
        m.setPlainTextBody('ciao');
        messageToSend.add(m);        
        
        
        System.runAs(utenteMAIL) {
            EmailUtils.generateEmail(devName, listEmail); 
            EmailUtils.generateEmail(devName, listEmail, cont.id);
            EmailUtils.generateEmail(devName, listEmail,ccAddress);
            EmailUtils.generateEmail(devName, listEmail,ccAddress, cont.id);
            EmailUtils.generateEmail(devName, listEmail,attachment);
            EmailUtils.generateEmail(devName, listEmail,attachment,ccAddress); 
            EmailUtils.generateEmailReclami(listEmail, ccAddress, bccAddress, 'Email body', attachment, 'Email Subject');
            EmailUtils.generateEmailReclamiFandT(listEmail, 'Email body', 'Email Subject'); 
            EmailuTils.sendEmail(messageToSend);
            EmailuTils.sendEmail(m);
        }
    }
}