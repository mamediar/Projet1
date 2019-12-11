@isTest
public class SFACambioAutoRicercaPratCntrollerTest {

    
    public static EmailTemplate getEmail(String name, User user )
    {
        EmailTemplate tempalate = new EmailTemplate();
        tempalate.isActive = true;
        tempalate.Name = name;
        tempalate.DeveloperName = name;
        tempalate.TemplateType = 'text';
        tempalate.FolderId = user.id; 
		return tempalate;        
    }
    
    @testSetup
    public static void setUp(){     
 

            String userId = UserInfo.getUserId(); 
            User currentUser = [SELECT Id, profileId FROM User WHERE Id = :UserInfo.getUserId()][0];
            String currentProfileId = currentUser.profileId;
            String currentProfileName = [SELECT Id, Name FROM Profile WHERE Id = :currentProfileId][0].Name; 
        	//System.debug('°°°°°°°°°°°°°°°°°°°°°°°TEST userId'+userId);
            System.debug('°°°°°°°°°°°°°°°°°°°°°°°TEST currentProfileId'+currentProfileId);
            System.debug('°°°°°°°°°°°°°°°°°°°°°°°TEST currentProfileName'+currentProfileName);
        
        	//User utenteFiliale=null;
        //System.runAs(currentUser) {
            //Profile standard user:
            Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Branch Employee' LIMIT 1];
                
            
            //utente Manager Filiale:
            UserRole utenteUserRoleManagerFiliale = new UserRole();
           	utenteUserRoleManagerFiliale.Name='Filiale_Manager';  
	        utenteUserRoleManagerFiliale.DeveloperName='Filiale_Manager'; 
            //utenteUserRoleManagerFiliale.ParentRoleId=utenteUserRoleCoordinatoreArea.Id;
            insert utenteUserRoleManagerFiliale; 
            User utenteManagerFiliale = new User(LastName = 'LIVESTON',
                                FirstName='JASON',
                                Alias = 'jliv',
                                Email = 'jason.liveston@asssdf.com',
                                Username = 'jason3.liveston@asssdf.com',  
                                ProfileId = profileId.id,
                                TimeZoneSidKey = 'GMT',
                                LanguageLocaleKey = 'en_US',
                                EmailEncodingKey = 'UTF-8',
                                DefaultQueueId__c = 'F32',
                                UserRoleId=utenteUserRoleManagerFiliale.Id,
                                LocaleSidKey = 'en_US'
                               );
            insert utenteManagerFiliale;     
            
            //utente filiale:
            UserRole utenteUserRoleUtenteFiliale = new UserRole();
            utenteUserRoleUtenteFiliale.Name='Filiale';  
            utenteUserRoleUtenteFiliale.ParentRoleId=utenteUserRoleManagerFiliale.Id;
            insert utenteUserRoleUtenteFiliale; 
            User utenteFiliale = new User(LastName = 'UtenteFiliale',
                                FirstName='JASON',
                                Alias = 'jliv',
                                Email = 'jason.liveston@asssdf.com',
                                Username = 'jason4.liveston@asssdf.com',  
                                ProfileId = profileId.id,
                                TimeZoneSidKey = 'GMT',
                                LanguageLocaleKey = 'en_US',
                                EmailEncodingKey = 'UTF-8',
                                DefaultQueueId__c = 'F32',
                                UserRoleId=utenteUserRoleUtenteFiliale.Id,
                                LocaleSidKey = 'en_US'
                               );
            insert utenteFiliale; 
        
        


        //}
                
        System.runAs(currentUser) {
        
       /*    insert getEmail( 'SEND', currentUser );
        insert getEmail( 'SEND_MOD', currentUser );
        insert getEmail( 'DEAL_AV', currentUser );
        insert getEmail( 'GO_AV', currentUser );
        insert getEmail( 'GO_STRN_AV', currentUser );*/
            
            //Branch
            Account branch1 = new Account();
            String idRecordTypeBranch = [Select id from RecordType where name = 'Branch'][0].id;
            branch1.RecordTypeId = idRecordTypeBranch;
            branch1.name = 'BranchDiProva'; 
            branch1.BusinessEmail__c='khadija.masrour@lynxspa.com';
            branch1.OCS_External_Id__c = 'F32';	
            branch1.Customer_Type__c='Compass';
            branch1.OwnerId=utenteFiliale.id;
            insert branch1;     
            System.assert(branch1.id!=null,'branch non inserito');
            
            
            //Dealer 1 associated to branch1
            Account branch =[select id,OCS_External_Id__c from Account where OCS_External_Id__c='F32'][0];
            System.assert(branch.id!=null,'branch non inserita');
            Account dealer1 = new Account();
            String idRecordTypeDealer = [Select id from RecordType where name = 'Dealer'][0].id;
            dealer1.RecordTypeId = idRecordTypeDealer;
            dealer1.name = 'DealerDiProva';   
            dealer1.OCS_External_Id__c = 'D123';
            dealer1.Branch__c=branch.Id;
            //dealer1.Parent=branch1;
            //dealer1.ParentId=branch1.id;
            //dealer1.Branch__r.OCS_External_Id__c='F32'; 
            dealer1.Customer_Type__c='Compass';       	
            dealer1.OwnerId=utenteFiliale.id;
            insert dealer1;
            System.assert(dealer1.id!=null,'dealer non inserito');
            Account dealer =[select id,Branch__r.OCS_External_Id__c from Account where OCS_External_Id__c='D123'][0];
            System.debug('SETUP dealerOcsExternalId:: '+dealer.Branch__r.OCS_External_Id__c);   
        
        
            Case c = new Case();    //ad esso è associata una pratica SFAPraticaCambioAuto__c a sua volta associata a un ticket
			c.ActivityType__c = 'SFA_CAMAUT';    
        	c.Note__c='RecuperaPacchettiAssicurativi';
			c.Status='New';        
        	c.NumeroPratica__c='12057342';
            //c.OwnerId=userId;
        	c.OwnerId=utenteFiliale.id;
            insert c;
        
            Case c2 = new Case();   //ad esso è associata una pratica SFAPraticaCambioAuto__c che non è associata ad alcun ticket
			c2.ActivityType__c = 'SFA_CAMAUT';    
        	c2.Note__c='TestConCaseEPratica';
			c2.Status='New';        
        	c2.NumeroPratica__c='1205734';
        	//c2.OwnerId=userId;
        	c2.OwnerId=utenteFiliale.id;
            insert c2;        
        
            Case c3 = new Case();    //mi serve perche mi servono due case associati allo stesso numero di pratica (c e c3) ed entrambi con stato diverso da closed
			c3.ActivityType__c = 'SFA_CAMAUT';    
        	c3.Note__c='nota';
			c3.Status='New';        
        	c3.NumeroPratica__c=c.NumeroPratica__c;
        	//c3.OwnerId=userId;
            c3.OwnerId=utenteFiliale.id;
            insert c3;         
        
        
            Case ticket = new Case();    //ticket
			ticket.ActivityType__c = 'SFA_CAMAUT_NOTIFICHE';     
        	ticket.Note__c='nota';
			ticket.Status='New';        
        	ticket.NumeroPratica__c='12057342';
        	//ticket.OwnerId=userId;
            ticket.OwnerId=utenteFiliale.id;
            insert ticket;        
        
            SFA_CambioAuto_EsitiConfig__c cambioAuto = new SFA_CambioAuto_EsitiConfig__c();      //SFA_CambioAuto_EsitiConfig__c con IsCaseToBeClosed__c=false (mi serve in processaAttivita)
            cambioAuto.Name=c.NumeroPratica__c;
            cambioAuto.CodNextOutcome__c ='SEND';
            cambioAuto.CodNextOutcomeLabel__c ='CodNextL';   
            cambioAuto.CodOutcome__c ='AV';
        	cambioAuto.ActorProfileName__c=currentProfileName;
        	cambioAuto.Actor__c='AV';
            cambioAuto.NextActor__c='AV';
            cambioAuto.IsCaseToBeClosed__c=false;
            cambioAuto.IsNoteMandatory__c=false;
            cambioAuto.CodNextOutcomeLabel__c='nsb';
        	insert cambioAuto;  
        
            SFA_CambioAuto_EsitiConfig__c cambioAuto2 = new SFA_CambioAuto_EsitiConfig__c();      //SFA_CambioAuto_EsitiConfig__c con IsCaseToBeClosed__c=false (mi serve in processaAttivita)
            cambioAuto2.Name=c.NumeroPratica__c;
            cambioAuto2.CodNextOutcome__c ='RESP_AV';
            cambioAuto2.CodNextOutcomeLabel__c ='CodNextL2';   
            cambioAuto2.CodOutcome__c ='AV';
        	cambioAuto2.ActorProfileName__c=currentProfileName;
        	cambioAuto2.Actor__c='AV';
            cambioAuto2.NextActor__c='AV';
            cambioAuto2.IsCaseToBeClosed__c=false;
            cambioAuto2.IsNoteMandatory__c=false;
            cambioAuto2.CodNextOutcomeLabel__c='nsb';
        	insert cambioAuto2;       
        
            SFA_CambioAuto_EsitiConfig__c cambioAuto3 = new SFA_CambioAuto_EsitiConfig__c();      //SFA_CambioAuto_EsitiConfig__c con IsCaseToBeClosed__c=false (mi serve in processaAttivita)
            cambioAuto3.Name=c.NumeroPratica__c;
            cambioAuto3.CodNextOutcome__c ='RESP_AV_GD';
            cambioAuto3.CodNextOutcomeLabel__c ='CodNextL2';   
            cambioAuto3.CodOutcome__c ='AV';
        	cambioAuto3.ActorProfileName__c=currentProfileName;
        	cambioAuto3.Actor__c='AV';
            cambioAuto3.NextActor__c='AV';
            cambioAuto3.IsCaseToBeClosed__c=false;
            cambioAuto3.IsNoteMandatory__c=false;
            cambioAuto3.CodNextOutcomeLabel__c='nsb';
        	insert cambioAuto3;    
        
            SFA_CambioAuto_EsitiConfig__c cambioAuto4 = new SFA_CambioAuto_EsitiConfig__c();      //SFA_CambioAuto_EsitiConfig__c con IsCaseToBeClosed__c=false (mi serve in processaAttivita)
            cambioAuto4.Name=c.NumeroPratica__c;
            cambioAuto4.CodNextOutcome__c ='SEND_MOD';
            cambioAuto4.CodNextOutcomeLabel__c ='CodNextL2';   
            cambioAuto4.CodOutcome__c ='GDV';
        	cambioAuto4.ActorProfileName__c=currentProfileName;
        	cambioAuto4.Actor__c='AV';
            cambioAuto4.NextActor__c='GDV';
            cambioAuto4.IsCaseToBeClosed__c=false;
            cambioAuto4.IsNoteMandatory__c=false;
            cambioAuto4.CodNextOutcomeLabel__c='nsb';
        	insert cambioAuto4;         
        
        
            SFA_CambioAuto_EsitiConfig__c cambioAuto5 = new SFA_CambioAuto_EsitiConfig__c();      //SFA_CambioAuto_EsitiConfig__c con IsCaseToBeClosed__c=false (mi serve in processaAttivita)
            cambioAuto5.Name=c.NumeroPratica__c;
            cambioAuto5.CodNextOutcome__c ='DEAL_AV';
            cambioAuto5.CodNextOutcomeLabel__c ='CodNextL2';   
            cambioAuto5.CodOutcome__c ='GDV';
        	cambioAuto5.ActorProfileName__c=currentProfileName;
        	cambioAuto5.Actor__c='AV';
            cambioAuto5.NextActor__c='GDV';
            cambioAuto5.IsCaseToBeClosed__c=false;
            cambioAuto5.IsNoteMandatory__c=false;
            cambioAuto5.CodNextOutcomeLabel__c='nsb';
        	insert cambioAuto5;

            SFA_CambioAuto_EsitiConfig__c cambioAuto6 = new SFA_CambioAuto_EsitiConfig__c();      //SFA_CambioAuto_EsitiConfig__c con IsCaseToBeClosed__c=false (mi serve in processaAttivita)
            cambioAuto6.Name=c.NumeroPratica__c;
            cambioAuto6.CodNextOutcome__c ='GO_AV';
            cambioAuto6.CodNextOutcomeLabel__c ='CodNextL2';   
            cambioAuto6.CodOutcome__c ='GDV';
        	cambioAuto6.ActorProfileName__c=currentProfileName;
        	cambioAuto6.Actor__c='AV';
            cambioAuto6.NextActor__c='GDV';
            cambioAuto6.IsCaseToBeClosed__c=false;
            cambioAuto6.IsNoteMandatory__c=false;
            cambioAuto6.CodNextOutcomeLabel__c='nsb';
        	insert cambioAuto6;

            SFA_CambioAuto_EsitiConfig__c cambioAuto7 = new SFA_CambioAuto_EsitiConfig__c();      //SFA_CambioAuto_EsitiConfig__c con IsCaseToBeClosed__c=false (mi serve in processaAttivita)
            cambioAuto7.Name=c.NumeroPratica__c;
            cambioAuto7.CodNextOutcome__c ='GO_STRN_AV';
            cambioAuto7.CodNextOutcomeLabel__c ='CodNextL2';   
            cambioAuto7.CodOutcome__c ='GDV';
        	cambioAuto7.ActorProfileName__c=currentProfileName;
        	cambioAuto7.Actor__c='AV';
            cambioAuto7.NextActor__c='GDV';
            cambioAuto7.IsCaseToBeClosed__c=false;
            cambioAuto7.IsNoteMandatory__c=false;
            cambioAuto7.CodNextOutcomeLabel__c='nsb';
        	insert cambioAuto7;    
            
        	//NextActor__c=COORD
            SFA_CambioAuto_EsitiConfig__c cambioAuto8 = new SFA_CambioAuto_EsitiConfig__c();      //SFA_CambioAuto_EsitiConfig__c con IsCaseToBeClosed__c=false (mi serve in processaAttivita)
            cambioAuto8.Name=c.NumeroPratica__c;
            cambioAuto8.CodNextOutcome__c ='SEND';
            cambioAuto8.CodNextOutcomeLabel__c ='CodNextL2';   
            cambioAuto8.CodOutcome__c ='COORD';
        	cambioAuto8.ActorProfileName__c=currentProfileName;
        	cambioAuto8.Actor__c='AV';
            cambioAuto8.NextActor__c='COORD';
            cambioAuto8.IsCaseToBeClosed__c=false;
            cambioAuto8.IsNoteMandatory__c=false;
            cambioAuto8.CodNextOutcomeLabel__c='nsb';
        	insert cambioAuto8;     
        
        	//NextActor__c=FIL
            SFA_CambioAuto_EsitiConfig__c cambioAuto9 = new SFA_CambioAuto_EsitiConfig__c();      //SFA_CambioAuto_EsitiConfig__c con IsCaseToBeClosed__c=false (mi serve in processaAttivita)
            cambioAuto9.Name=c.NumeroPratica__c;
            cambioAuto9.CodNextOutcome__c ='NEW_ATT_GD';
            cambioAuto9.CodNextOutcomeLabel__c ='CodNextL2';   
            cambioAuto9.CodOutcome__c ='FIL';
        	cambioAuto9.ActorProfileName__c=currentProfileName;
        	cambioAuto9.Actor__c='AV';
            cambioAuto9.NextActor__c='FIL';
            cambioAuto9.IsCaseToBeClosed__c=false;
            cambioAuto9.IsNoteMandatory__c=false;
            cambioAuto9.CodNextOutcomeLabel__c='nsb';
        	insert cambioAuto9; 

            SFA_CambioAuto_EsitiConfig__c cambioAuto10 = new SFA_CambioAuto_EsitiConfig__c();      //SFA_CambioAuto_EsitiConfig__c con IsCaseToBeClosed__c=false (mi serve in processaAttivita)
            cambioAuto10.Name=c.NumeroPratica__c;
            cambioAuto10.CodNextOutcome__c ='RICH_MOD';
            cambioAuto10.CodNextOutcomeLabel__c ='CodNextL2';   
            cambioAuto10.CodOutcome__c ='FIL';
        	cambioAuto10.ActorProfileName__c=currentProfileName;
        	cambioAuto10.Actor__c='AV';
            cambioAuto10.NextActor__c='FIL';
            cambioAuto10.IsCaseToBeClosed__c=false;
            cambioAuto10.IsNoteMandatory__c=false;
            cambioAuto10.CodNextOutcomeLabel__c='nsb';
        	insert cambioAuto10;

            SFA_CambioAuto_EsitiConfig__c cambioAuto11 = new SFA_CambioAuto_EsitiConfig__c();      //SFA_CambioAuto_EsitiConfig__c con IsCaseToBeClosed__c=false (mi serve in processaAttivita)
            cambioAuto11.Name=c.NumeroPratica__c;
            cambioAuto11.CodNextOutcome__c ='NEW_ATT_AV';
            cambioAuto11.CodNextOutcomeLabel__c ='CodNextL2';   
            cambioAuto11.CodOutcome__c ='FIL';
        	cambioAuto11.ActorProfileName__c=currentProfileName;
        	cambioAuto11.Actor__c='AV';
            cambioAuto11.NextActor__c='FIL';
            cambioAuto11.IsCaseToBeClosed__c=false;
            cambioAuto11.IsNoteMandatory__c=false;
            cambioAuto11.CodNextOutcomeLabel__c='nsb';
        	insert cambioAuto11;        
            
            SFA_CambioAuto_EsitiConfig__c cambioAuto12 = new SFA_CambioAuto_EsitiConfig__c();      //SFA_CambioAuto_EsitiConfig__c con IsCaseToBeClosed__c=false (mi serve in processaAttivita)
            cambioAuto12.Name=c.NumeroPratica__c;
            cambioAuto12.CodNextOutcome__c ='NEW_ATT_GD';
            cambioAuto12.CodNextOutcomeLabel__c ='CodNextL2';   
            cambioAuto12.CodOutcome__c ='FIL';
        	cambioAuto12.ActorProfileName__c=currentProfileName;
        	cambioAuto12.Actor__c='AV';
            cambioAuto12.NextActor__c='FIL';
            cambioAuto12.IsCaseToBeClosed__c=false;
            cambioAuto12.IsNoteMandatory__c=false;
            cambioAuto12.CodNextOutcomeLabel__c='nsb';
        	insert cambioAuto12;            
        
        
            SFA_CambioAuto_EsitiConfig__c cambioAutoX = new SFA_CambioAuto_EsitiConfig__c();      //SFA_CambioAuto_EsitiConfig__c con IsCaseToBeClosed__c=true (mi serve in processaAttivita)
            cambioAutoX.Name=c.NumeroPratica__c;
            cambioAutoX.CodNextOutcome__c ='GIA_FATTO';
            cambioAutoX.CodNextOutcomeLabel__c ='CodNextL';   
            cambioAutoX.CodOutcome__c ='AV2';
        	cambioAutoX.ActorProfileName__c=currentProfileName;
        	cambioAutoX.Actor__c='AV';
            cambioAutoX.NextActor__c='GDV';
            cambioAutoX.IsCaseToBeClosed__c=true;
            cambioAutoX.IsNoteMandatory__c=false;
            cambioAutoX.CodNextOutcomeLabel__c='nsb';
        	insert cambioAutoX;     
        
            SFA_CambioAuto_EsitiConfig__c cambioAutoX1 = new SFA_CambioAuto_EsitiConfig__c();      //SFA_CambioAuto_EsitiConfig__c con IsCaseToBeClosed__c=true (mi serve in processaAttivita)
            cambioAutoX1.Name=c.NumeroPratica__c;
            cambioAutoX1.CodNextOutcome__c ='KO_GDVCA';
            cambioAutoX1.CodNextOutcomeLabel__c ='CodNextL';   
            cambioAutoX1.CodOutcome__c ='AV2';
        	cambioAutoX1.ActorProfileName__c=currentProfileName;
        	cambioAutoX1.Actor__c='AV';
            cambioAutoX1.NextActor__c='GDV';
            cambioAutoX1.IsCaseToBeClosed__c=true;
            cambioAutoX1.IsNoteMandatory__c=false;
            cambioAutoX1.CodNextOutcomeLabel__c='nsb';
        	insert cambioAutoX1; 

            SFA_CambioAuto_EsitiConfig__c cambioAutoX2 = new SFA_CambioAuto_EsitiConfig__c();      //SFA_CambioAuto_EsitiConfig__c con IsCaseToBeClosed__c=true (mi serve in processaAttivita)
            cambioAutoX2.Name=c.NumeroPratica__c;
            cambioAutoX2.CodNextOutcome__c ='OK_GDVCA';
            cambioAutoX2.CodNextOutcomeLabel__c ='CodNextL';   
            cambioAutoX2.CodOutcome__c ='GO_AV';
        	cambioAutoX2.ActorProfileName__c=currentProfileName;
        	cambioAutoX2.Actor__c='AV';
            cambioAutoX2.NextActor__c='GDV';
            cambioAutoX2.IsCaseToBeClosed__c=true;
            cambioAutoX2.IsNoteMandatory__c=false;
            cambioAutoX2.CodNextOutcomeLabel__c='nsb';
        	insert cambioAutoX2;      
        
            SFA_CambioAuto_EsitiConfig__c cambioAutoX3 = new SFA_CambioAuto_EsitiConfig__c();      //SFA_CambioAuto_EsitiConfig__c con IsCaseToBeClosed__c=true (mi serve in processaAttivita)
            cambioAutoX3.Name=c.NumeroPratica__c;
            cambioAutoX3.CodNextOutcome__c ='OK_GDVCA';
            cambioAutoX3.CodNextOutcomeLabel__c ='CodNextL';   
            cambioAutoX3.CodOutcome__c ='GO_STRN_AV';
        	cambioAutoX3.ActorProfileName__c=currentProfileName;
        	cambioAutoX3.Actor__c='AV';
            cambioAutoX3.NextActor__c='GDV';
            cambioAutoX3.IsCaseToBeClosed__c=true;
            cambioAutoX3.IsNoteMandatory__c=false;
            cambioAutoX3.CodNextOutcomeLabel__c='nsb';
        	insert cambioAutoX3; 
        

            SFA_CambioAuto_EsitiConfig__c cambioAutoX4 = new SFA_CambioAuto_EsitiConfig__c();      //SFA_CambioAuto_EsitiConfig__c con IsCaseToBeClosed__c=true (mi serve in processaAttivita)
            cambioAutoX4.Name=c.NumeroPratica__c;
            cambioAutoX4.CodNextOutcome__c ='STOP_AV';
            cambioAutoX4.CodNextOutcomeLabel__c ='CodNextL';   
            cambioAutoX4.CodOutcome__c ='AV2';
        	cambioAutoX4.ActorProfileName__c=currentProfileName;
        	cambioAutoX4.Actor__c='AV';
            cambioAutoX4.NextActor__c='GDV';
            cambioAutoX4.IsCaseToBeClosed__c=true;
            cambioAutoX4.IsNoteMandatory__c=false;
            cambioAutoX4.CodNextOutcomeLabel__c='nsb';
        	insert cambioAutoX4;

            SFA_CambioAuto_EsitiConfig__c cambioAutoX5 = new SFA_CambioAuto_EsitiConfig__c();      //SFA_CambioAuto_EsitiConfig__c con IsCaseToBeClosed__c=true (mi serve in processaAttivita)
            cambioAutoX5.Name=c.NumeroPratica__c;
            cambioAutoX5.CodNextOutcome__c ='STOP_COORD';
            cambioAutoX5.CodNextOutcomeLabel__c ='CodNextL';   
            cambioAutoX5.CodOutcome__c ='AV2';
        	cambioAutoX5.ActorProfileName__c=currentProfileName;
        	cambioAutoX5.Actor__c='AV';
            cambioAutoX5.NextActor__c='GDV';
            cambioAutoX5.IsCaseToBeClosed__c=true;
            cambioAutoX5.IsNoteMandatory__c=false;
            cambioAutoX5.CodNextOutcomeLabel__c='nsb';
        	insert cambioAutoX5;        
        
        
            /*SFAPraticaCambioAuto__c p = new SFAPraticaCambioAuto__c();     //SFAPraticaCambioAuto__c associata ad un ticket
            p.NumeroPratica__c =c.NumeroPratica__c;
        	p.CodOutcome__c ='AV';
            p.IdAttivita__c =c.Id;   
            p.Targa__c = '';
            p.Telaio__c = '';
            p.AnnoImmatricolazione__c = '2019';
            p.MeseImmatricolazione__c = '02';
            p.Modello__c = 'tr';
            p.Valore__c = 'vd';
            p.ImportoStorno__c = 'mn';     
            p.ClienteOcs__c='C12';
        	p.Dealer__c='A.M. SERVICE SRL'; 
        	p.DealerOcsExternalId__c=dealer1.OCS_External_Id__c; 
        	insert p; */   
        
        
            SFAPraticaCambioAuto__c p2 = new SFAPraticaCambioAuto__c();      //SFAPraticaCambioAuto__c non associata a nessun ticket
            p2.NumeroPratica__c =c2.NumeroPratica__c;
        	p2.CodOutcome__c ='AV';
            p2.IdAttivita__c =c2.Id;   
            p2.Targa__c = '';
            p2.Telaio__c = '';
            p2.AnnoImmatricolazione__c = '2019';
            p2.MeseImmatricolazione__c = '02';
            p2.Modello__c = 'tr';
            p2.Valore__c = 'vd';
            p2.ImportoStorno__c = 'mn';     
            p2.ClienteOcs__c='C12';
        	p2.Dealer__c='A.M. SERVICE SRL'; 
        	p2.DealerOcsExternalId__c=dealer1.OCS_External_Id__c; 
        	insert p2;                 


            /*string z =[select id from RecordType where Name = 'Person Account'][0].id;
            Account a2 = new Account();
            a2.LastName = 'Dummy';
            a2.FirstName = 'Dummy';
            a2.BusinessEmail__c = 'khadija.masrour@prova.it';
            a2.RecordTypeId = z;
            insert a2; */       
        
        	Account acc = TestMockUtils.getDummyAccount();
            acc.OwnerId=utenteFiliale.id;
        	insert acc;
			        
            Contact cont = TestMockUtils.getDummyContact(acc.id);
            insert cont; 

            
            XCS_CompassParameters__c obj = new XCS_CompassParameters__c();
            obj.Name = 'gdv.mail';
            obj.Value__c ='khadija@prtova.it';
            insert obj;  
            
            XCS_CompassParameters__c obj1 = new XCS_CompassParameters__c();
            obj1.Name = 'av.mail';
            obj1.Value__c ='khadija@prova.it';
            insert obj1;    
        
            XCS_CompassParameters__c obj2 = new XCS_CompassParameters__c();
            obj2.Name = 'ufficiocontabilita.mail';
            obj2.Value__c ='khadija@prova.it';
            insert obj2;
            
            XCS_CompassParameters__c obj3 = new XCS_CompassParameters__c();
            obj3.Name = 'name3';
            obj3.Value__c ='khadija@prova.it';
            obj3.Group__c ='AREA_QUEUE';
            insert obj3;   
            
            XCS_CompassParameters__c obj4 = new XCS_CompassParameters__c();
            obj4.Name = 'inviomail.mock';
            obj4.Value__c ='khadija@prova.it';
            insert obj4;            
    
            
            /*Folder[] folders = [select Id from Folder 
                                where AccessType IN: new list<String>{'Shared','Public'} 
                                AND Type = 'Email'];
            System.assert(!folders.isEmpty(),'test can\'t run wo Email Template folders. Folders can\'t be mocked in Apex');*/ 
        
        
            String responseInfoPratica ='{"recuperaInfoPraticaResponse":{"valoreBene":"1650000","telaio":"","targa":"EP770GD ","ragioneSociale":"CALUAI DENCIL","prodotto":"1U","descrizioneBene":"T","marcaModello":"T","dataLiquidazione":"20190128","annoMeseImmatricolazione":"201210"}}';               
            ApiRest__c test2 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c=responseInfoPratica ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaInfoPratica',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
            insert test2;      

            //String responsePacchettiAssicurativi='{"resultCode":0,"resultMessage":"Ok","recuperaPacchettiServiziResponse":{"elencoPacchettiServizi":[{"codServizio":"1246","codPacchetto":"1245","codFornitore":"1245","dataInizioCopertura":"1245","dataFineCopertura":"1245","durata":"1245","desFornitore":"1245"}]}}';                
            String responsePacchettiAssicurativi='{"resultCode":0,"resultMessage":"Ok","recuperaPacchettiServiziResponse":{"elencoPacchettiServizi":[{"codServizio":"1246","codPacchetto":"12","codFornitore":"13","dataInizioCopertura":"20191023"}]}}';                            
            ApiRest__c test3 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c=responsePacchettiAssicurativi ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaPacchettiServizi',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
            insert test3;  
            
        }
        
    }
    
    
    private class SFAPraticheIrregolariOCSResponse implements HttpCalloutMock{
        public HTTPResponse respond(HTTPRequest req){
            HttpResponse res = new HttpResponse();
            String urlId = req.getEndpoint();
            String apiname='ocs.'+((OCSRequest)JSON.deserialize(req.getBody(),OCSRequest.class)).serviceId;
            res.setHeader('Content-Type', 'application/json');
            ApiRest__c ar = [select Test_Request__c, Test_Response__c from Apirest__c where endpoint__c = :urlId and name = :apiname LIMIT 1];
            system.debug(ar);
            System.assert(ar!= null, 'No rows for endpoint ' + urlId );
            System.assert(ar.Test_response__c != null, 'Missing response on test static resource.'); 
            res.setStatusCode(200);
            res.setBody(ar.Test_Response__c);         
            return res;
        }
    }    

    @isTest 
    public static void getPraticaTest(){
        String caseId=[SELECT Id FROM Case where Note__c='TestConCaseEPratica'][0].id;
        SFACambioAutoRicercaPraticaController.getPratica(caseId);
    }  
    
    @isTest  
    public static void getEsitiTest(){ 
        String caseId=[SELECT Id FROM Case where Note__c='TestConCaseEPratica'][0].id;
        SFACambioAutoRicercaPraticaController.getEsiti(caseId);
    }    

    @isTest 
    public static void recuperaPraticaTest(){ 
        String response = '{"resultCode":0,"resultMessage":"Ok","recuperaInfoPraticaResponse":null}';
        List<Case> c=[SELECT Id, NumeroPratica__c FROM Case where Note__c='TestConCaseEPratica'];
        String caseId=c[0].id;   
        String numeroPratica=c[0].NumeroPratica__c;
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaInfoPratica',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute',Ref__c='CompassInternal');      
        insert test1;
        ApiUtil__c test2 = new ApiUtil__c(Name = 'CompassInternal', EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute', User__c = 'CDSLF00', Password__c = 'P00FLSDC', Ref__c = 'CompassInternal');
        insert test2;   
        Test.startTest(); 
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname='ocs.recuperaInfoPratica';
        Test.setMock(HttpCalloutMock.class,UMR);        
        SFACambioAutoRicercaPraticaController.recuperaPratica(numeroPratica,caseId);
        Test.stopTest();

    } 
    
    @isTest    
    public static void checkPacchettiAssicurativiDaEscludereTest(){ 
        OCSRecuperaPacchettiServiziResponse rp = new OCSRecuperaPacchettiServiziResponse();
        OCSRecuperaPacchettiServiziResponse.RecuperaPacchettiServiziResponseDTO rpdto = new OCSRecuperaPacchettiServiziResponse.RecuperaPacchettiServiziResponseDTO();
        
        OCSRecuperaPacchettiServiziResponse.PacchettoServizioDTO pa = new   OCSRecuperaPacchettiServiziResponse.PacchettoServizioDTO();
        pa.codServizio ='124';
        pa.codPacchetto ='';
        pa.codFornitore ='';
        pa.dataInizioCopertura ='20090815';
        pa.dataFineCopertura ='20250815';
        pa.assicurazioneAttivaFinanziata ='';
        pa.durata='';
        pa.desFornitore ='';        
        List<OCSRecuperaPacchettiServiziResponse.PacchettoServizioDTO> lstElencoPacchetti = new List<OCSRecuperaPacchettiServiziResponse.PacchettoServizioDTO>();
        lstElencoPacchetti.add(pa);
        SFACambioAutoRicercaPraticaController.checkPacchettiAssicurativiDaEscludere(lstElencoPacchetti);
        
        
        
    }
    
    @isTest     
    public static void recuperaPacchettiAssicurativiTest(){ 
        String response = '{"resultCode":0,"resultMessage":"Ok","recuperaPacchettiServiziResponse":{"elencoPacchettiServizi":[]}}';
        Case c=[SELECT Id,NumeroPratica__c FROM Case where Note__c='RecuperaPacchettiAssicurativi'][0];
        String caseId=c.id;
        String numeroPratica=c.NumeroPratica__c;
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaPacchettiServizi',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute',Ref__c='CompassInternal');      
        insert test1;
        ApiUtil__c test2 = new ApiUtil__c(Name = 'CompassInternal', EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute', User__c = 'CDSLF00', Password__c = 'P00FLSDC', Ref__c = 'CompassInternal');
        insert test2;       
        Test.startTest(); 
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname='ocs.recuperaPacchettiServizi';
        Test.setMock(HttpCalloutMock.class,UMR);        
        SFACambioAutoRicercaPraticaController.recuperaPacchettiAssicurativi(numeroPratica,caseId);
        Test.stopTest();

    }   
    
    @isTest    //OK
    public static void calcolaIsDataLiquidazioneRedTest(){ 
        Date strDataLiquidazione = Date.today()+1;
        string strDataLiquidazioneString = string.valueof(strDataLiquidazione);
        SFACambioAutoRicercaPraticaController.calcolaIsDataLiquidazioneRed('20190123');
        SFACambioAutoRicercaPraticaController.calcolaIsDataLiquidazioneRed('20180123');
    }     
    
    @isTest   //OK
    public static void checkDoppiaAttivitaTest(){    
        Case c=[SELECT Id,NumeroPratica__c FROM Case where NumeroPratica__c='12057342'][0];
        String caseId=c.id;
        String numeroPratica=c.NumeroPratica__c;       
        SFACambioAutoRicercaPraticaController.checkDoppiaAttivita('1',caseId);
        SFACambioAutoRicercaPraticaController.checkDoppiaAttivita('12057342',caseId);       
    }
    
    @isTest   //OK
    public static void chiudiAttivitaTest(){    
        Case c=[SELECT Id FROM Case where Note__c='TestConCaseEPratica'][0];           
        String caseId=c.id;
        SFACambioAutoRicercaPraticaController.chiudiAttivita(caseId,'ATTIVO'); 
    																	
        
    }  
    
    @isTest   //OK
    public static void creaTicketNotificaTest(){    
        Case c=[SELECT Id,NumeroPratica__c FROM Case where Note__c='TestConCaseEPratica'][0];  
        String numeroPratica=c.NumeroPratica__c;          
        SFACambioAutoRicercaPraticaController.creaTicketNotifica(numeroPratica,'SFA_CAMAUT','STOP_COORD'); 
        SFACambioAutoRicercaPraticaController.creaTicketNotifica(numeroPratica,'SFA_CAMAUT','KO_GDVCA');   
        SFACambioAutoRicercaPraticaController.creaTicketNotifica(numeroPratica,'SFA_CAMAUT','GIA_FATTO'); 
        SFACambioAutoRicercaPraticaController.creaTicketNotifica(numeroPratica,'SFA_CAMAUT','OK_GDVCA_STORNO');
    																	
        
    }    
    
    @isTest     //OK
    public static void completaPraticaTest(){    
        Case c=[SELECT Id,NumeroPratica__c FROM Case where Note__c='TestConCaseEPratica'][0];
        String numeroPratica=c.NumeroPratica__c;          
    	SFACambioAutoRicercaPraticaController.completaPratica(numeroPratica,'XS345VC','TERFS','2019','06','nb','D4','21','note');       																	
    }    
    
        
    @isTest     
    public static void processaAttivitaNextActorAVTest1(){    
        Case c=[SELECT Id,NumeroPratica__c FROM Case where Note__c='TestConCaseEPratica'][0];
        String numeroPratica=c.NumeroPratica__c;  
        //1) SFA_CambioAuto_EsitiConfig__c con IsCaseToBeClosed__c=false:   
        //2) nextActor == AV             
        //4) in questo caso devo entrare in diverse opzioni di email template    
    	SFACambioAutoRicercaPraticaController.processaAttivita(numeroPratica, 'AV', 'SEND',  'targaNew',  'telaioNew',  '2018',  '06',  'modelloNew',  'valoreNew',  'hd',  'note3');       																	
    	SFACambioAutoRicercaPraticaController.processaAttivita(numeroPratica, 'AV', 'RESP_AV',  'targaNew',  'telaioNew',  '2018',  '06',  'modelloNew',  'valoreNew',  'hd',  'note3');       																	
    	SFACambioAutoRicercaPraticaController.processaAttivita(numeroPratica, 'AV', 'RESP_AV_GD',  'targaNew',  'telaioNew',  '2018',  '06',  'modelloNew',  'valoreNew',  'hd',  'note3');       																	
    }  
    
    //@isTest      
    public static void processaAttivitaNextActorGDVTest2(){    
        Case c=[SELECT Id,NumeroPratica__c FROM Case where Note__c='TestConCaseEPratica'][0];
        String numeroPratica=c.NumeroPratica__c;  
        //1) SFA_CambioAuto_EsitiConfig__c con IsCaseToBeClosed__c=false:   
		//2) nextActor == GDV    
    	SFACambioAutoRicercaPraticaController.processaAttivita(numeroPratica, 'GDV', 'GO_AV',  'targaNew',  'telaioNew',  '2018',  '06',  'modelloNew',  'valoreNew',  'hd',  'note3');       																	
    	SFACambioAutoRicercaPraticaController.processaAttivita(numeroPratica, 'GDV', 'GO_STRN_AV',  'targaNew',  'telaioNew',  '2018',  '06',  'modelloNew',  'valoreNew',  'hd',  'note3');       																	
        

    } 
    
    @isTest      
    public static void processaAttivitaNextActorGDVTest22(){    
        Case c=[SELECT Id,NumeroPratica__c FROM Case where Note__c='TestConCaseEPratica'][0];
        String numeroPratica=c.NumeroPratica__c;  
        //1) SFA_CambioAuto_EsitiConfig__c con IsCaseToBeClosed__c=false:   
		//2) nextActor == GDV    (deve inviare diversi email template)
    	SFACambioAutoRicercaPraticaController.processaAttivita(numeroPratica, 'GDV', 'SEND_MOD',  'targaNew',  'telaioNew',  '2018',  '06',  'modelloNew',  'valoreNew',  'hd',  'note3');       																	
    	SFACambioAutoRicercaPraticaController.processaAttivita(numeroPratica, 'GDV', 'DEAL_AV',  'targaNew',  'telaioNew',  '2018',  '06',  'modelloNew',  'valoreNew',  'hd',  'note3');       																	
        

    }    
 
    //@isTest      
    public static void processaAttivitaNextActorCOORTest3(){    
        Case c=[SELECT Id,NumeroPratica__c FROM Case where Note__c='TestConCaseEPratica'][0];
        String numeroPratica=c.NumeroPratica__c;  
        //1) SFA_CambioAuto_EsitiConfig__c con IsCaseToBeClosed__c=false:   
        //2) nextActor == FIL
    	SFACambioAutoRicercaPraticaController.processaAttivita(numeroPratica, 'COORD', 'SEND',  'targaNew',  'telaioNew',  '2018',  '06',  'modelloNew',  'valoreNew',  'hd',  'note3');       																	
    }    
    
    @isTest      
    public static void processaAttivitaNextActorFILTest4(){    
        Case c=[SELECT Id,NumeroPratica__c FROM Case where Note__c='TestConCaseEPratica'][0];
        String numeroPratica=c.NumeroPratica__c;   
        //1) SFA_CambioAuto_EsitiConfig__c con IsCaseToBeClosed__c=false:   
        //2) nextActor == FIL
    	SFACambioAutoRicercaPraticaController.processaAttivita(numeroPratica, 'FIL', 'NEW_ATT_GD',  'targaNew',  'telaioNew',  '2018',  '06',  'modelloNew',  'valoreNew',  'hd',  'note3');       																	
    	SFACambioAutoRicercaPraticaController.processaAttivita(numeroPratica, 'FIL', 'RICH_MOD',  'targaNew',  'telaioNew',  '2018',  '06',  'modelloNew',  'valoreNew',  'hd',  'note3');       																	
    	SFACambioAutoRicercaPraticaController.processaAttivita(numeroPratica, 'FIL', 'NEW_ATT_AV',  'targaNew',  'telaioNew',  '2018',  '06',  'modelloNew',  'valoreNew',  'hd',  'note3');       																	
    } 
    
    
    @isTest      
    public static void processaAttivitaTest4(){    
        Case c=[SELECT Id,NumeroPratica__c FROM Case where Note__c='TestConCaseEPratica'][0];
        String numeroPratica=c.NumeroPratica__c; 
        //1) SFA_CambioAuto_EsitiConfig__c con IsCaseToBeClosed__c=true:   
        SFACambioAutoRicercaPraticaController.processaAttivita(numeroPratica, 'AV2', 'GIA_FATTO',  'targaNew',  'telaioNew',  '2018',  '06',  'modelloNew',  'valoreNew',  'hd',  'note3');       																	
        SFACambioAutoRicercaPraticaController.processaAttivita(numeroPratica, 'AV2', 'KO_GDVCA',  'targaNew',  'telaioNew',  '2018',  '06',  'modelloNew',  'valoreNew',  'hd',  'note3');       																	
        SFACambioAutoRicercaPraticaController.processaAttivita(numeroPratica, 'GO_AV', 'OK_GDVCA',  'targaNew',  'telaioNew',  '2018',  '06',  'modelloNew',  'valoreNew',  'hd',  'note3');       																	
	       

    }
     
    
    @isTest      
    public static void processaAttivitaTest5(){    
        Case c=[SELECT Id,NumeroPratica__c FROM Case where Note__c='TestConCaseEPratica'][0];
        String numeroPratica=c.NumeroPratica__c;   
        
        
        //1) SFA_CambioAuto_EsitiConfig__c con IsCaseToBeClosed__c=true:   
        SFACambioAutoRicercaPraticaController.processaAttivita(numeroPratica, 'GO_STRN_AV', 'OK_GDVCA',  'targaNew',  'telaioNew',  '2018',  '06',  'modelloNew',  'valoreNew',  'hd',  'note3');       																	
        SFACambioAutoRicercaPraticaController.processaAttivita(numeroPratica, 'AV2', 'STOP_AV',  'targaNew',  'telaioNew',  '2018',  '06',  'modelloNew',  'valoreNew',  'hd',  'note3');       																	
        SFACambioAutoRicercaPraticaController.processaAttivita(numeroPratica, 'AV2', 'STOP_COORD',  'targaNew',  'telaioNew',  '2018',  '06',  'modelloNew',  'valoreNew',  'hd',  'note3');       																	
		       

    }    
    
    
    
    
    @isTest
    public static void getCapoFilialeEmailByDealerTest(){    
        User currentUser = [SELECT Id, profileId FROM User WHERE Id = :UserInfo.getUserId()][0];
        User utenteMAIL=[SELECT id, UserRole.name, UserRole.parentRoleId FROM User where LastName='UtenteFiliale'];    
        System.runAs(utenteMAIL) {
            Case c=[SELECT Id,NumeroPratica__c FROM Case][0];
            String numeroPratica=c.NumeroPratica__c;   
            Account dealer=[SELECT Id, Name, RecordType.Name, OCS_External_Id__c, Branch__r.OCS_External_Id__c 
                                            FROM Account 
                                            WHERE RecordType.Name = 'Dealer' AND  OCS_External_Id__c='D123'][0];
            Account branch=[SELECT Id, Name, RecordType.Name, OCS_External_Id__c, Branch__r.OCS_External_Id__c 
                                            FROM Account 
                                            WHERE RecordType.Name = 'Branch' AND  OCS_External_Id__c='F32'][0];            
            
            Map<Id, UserRole> UserRoleMap = new Map<Id, UserRole>([Select Id, Name, ParentRoleId,  DeveloperName From UserRole Limit 10000]);
            
            String dealerOcsExternalId=dealer.OCS_External_Id__c;
            System.debug('TEST branch:: '+branch);
             System.assert(branch!=null,'Branch non trovata');
            System.assert(dealer.Branch__r!=null,'Branch non collegata');
            System.assert(dealerOcsExternalId!=null,'OCS_External_Id__c Dealer non trovato');
            String ParentdealerOcsExternalId=dealer.Branch__r.OCS_External_Id__c;
    
            
            System.debug('dealerOcsExternalId:: '+dealerOcsExternalId);
            System.debug('ParentdealerOcsExternalId:: '+ParentdealerOcsExternalId);
            
            SFACambioAutoRicercaPraticaController.getRegionalManagerEmailByDealer(dealerOcsExternalId);
            SFACambioAutoRicercaPraticaController.getCoordinatoreQueueByDealer(dealerOcsExternalId);
            SFACambioAutoRicercaPraticaController.getCoordinatoreEmailByDealer(dealerOcsExternalId);
            SFACambioAutoRicercaPraticaController.getCapoFilialeEmailByDealer(dealerOcsExternalId);
            SFACambioAutoRicercaPraticaController.getFilialeQueueByDealer(dealerOcsExternalId);
            SFACambioAutoRicercaPraticaController.getFilialeEmailByDealer(dealerOcsExternalId);
        }           																	


    }    
    
            

        
   

            

    
    
}