@isTest
public with sharing class SFAListaDaSedeAttivitaFilialeContrTest {



    private static void setup()
    {
        Case c = new Case();
        c.Status = 'New';
        c.Subject = 'Test1';
        c.Esito__c='Esit';
        c.ParentId = null;
        c.Totale__c = 0;
        
        Group g = new Group();
        g.Name = 'TestName';
        g.DeveloperName = 'devTest';
        g.Type = 'queue';
        
        insert g; 
        
        User u = new User(); 
        
        u.DefaultQueueId__c = g.DeveloperName;
        /*TimeZoneSidKey, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey*/
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
 
        System.runAs(u)
        {      
            
            insert c;  
            
            Case c1 = new Case();
            c1.Status = 'New';
            c1.Subject = 'Test';
            c1.Esito__c='Esit';
            c1.ParentId = c.Id;
            c1.Totale__c = 0;
            insert c1;
        }
        QueuesObject queObj = new QueueSObject(QueueId = g.id, SObjectType = 'Case');
        System.runAs(new User(Id=UserInfo.getUserId()))
        {      
            insert queObj;  
        }
    }

    testmethod public static void test(){
        setup();
        Test.startTest();
        Case c = [Select Id,ParentId,Status,Esito__c,OwnerId,Totale__c from Case Where Subject ='Test1'];
        Case c1 = [Select Id,ParentId,Status,Esito__c,OwnerId,Totale__c from Case Where ParentId !=null];
        Id parentCaseId = c.ParentId;
        
        XCS_Disposition__c disposition1 = new XCS_Disposition__c(Name='Positivo');
        insert disposition1;
        
        XCS_Disposition__c disposition2 = new XCS_Disposition__c(Name='Ancora_Positivo',Parent__c=disposition1.Id);
        insert disposition2;
        
        SFA_TipologiaLista__c lista = new SFA_TipologiaLista__c(Name='nome_lista');
        insert lista;    
        
        XCS_dealers_conv_activity_disp__c dealers = new XCS_dealers_conv_activity_disp__c();
        dealers.Codice_Attivita_Lista_da_Sede__c = lista.Id;
        dealers.Esito_1__c = disposition1.Id;
        dealers.Esito_2__c = disposition2.Id;
        
        List<Case> caseList = SFAListaDaSedeAttivitaFilialeController.getCaseList();
        system.assertEquals(0,caseList.size());
        List<Case> caseChildList = SFAListaDaSedeAttivitaFilialeController.getCaseChildList(parentCaseId);
        system.assertEquals(1,caseChildList.size());
        SFAListaDaSedeAttivitaFilialeController.getCaseChildInfo(c1);
        system.assertEquals(0, c.Totale__c);
        //SFAListaDaSedeAttivitaFilialeController.getCaseEsitiList(lista.Id);
        system.assertEquals(new List<XCS_dealers_conv_activity_disp__c>(), SFAListaDaSedeAttivitaFilialeController.getCaseEsitiList(lista.Id));  
        
        //SFAListaDaSedeAttivitaFilialeController.getfilialeFromOwnerId(c.OwnerId);  
        String note = 'nota del case';
        system.assertEquals(true,SFAListaDaSedeAttivitaFilialeController.setEsitoCase(c, dealers, note));
        
        Test.stopTest();
        
    }    

   @isTest
    public static void testAccollo() { 


        XCS_Categoria__c  cat = new XCS_Categoria__c(External_Id__c = XCS_CategoriaUtil.SFA_CONVENZIONAMENTO_GESTIONE_ACCOLLO_DEALER);
        insert cat;
        XCS_Disposition__c disposition = new XCS_Disposition__c(External_Id__c = XCS_DispositionUtils.NUOVO_ACCOLLO);
        insert disposition;
        Accolli_Type_List__c accTy = new  Accolli_Type_List__c(Accollo_Type_Code__c ='ACC_GDO');
        insert accTy;
        SFAConvenzDealerDocumentsTipoConvCO__c doc = new SFAConvenzDealerDocumentsTipoConvCO__c(IdxDocument__c = '12',TipoConv__c = 'ACC_GDO', DocumentType__c = 'mandatory' , DateStart__c = date.today(), DateEnd__c= date.today());
        insert doc;
        Test.startTest();
        Case caseSelected = new Case();
        caseSelected.Status = 'New';
        caseSelected.Subject = 'Test';
        caseSelected.Esito__c='Esito';
        caseSelected.ParentId = null;
        Group g = new Group();
        g.Name = 'TestName';
        g.DeveloperName = 'devTest';
        g.Type = 'queue';
        insert g; 
        SFA_TipologiaLista__c tl = new SFA_TipologiaLista__c(Name='nome_attivita_test2');
        tl.RSS_External_Id_act_code__c = '50';
        insert tl;

        SFA_ListeCaricate__c lst = new SFA_ListeCaricate__c();
        lst.Nome_Lista__c = 'lista_test2';
        lst.Tipo_Attivita__c = tl.Id;
        insert lst;

        caseSelected.SFA_ListeCaricate__c = lst.Id; 
         User u = new User(); 
        
        u.DefaultQueueId__c = g.DeveloperName;
        /*TimeZoneSidKey, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey*/
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
        System.runAs(u)
        {      
            insert caseSelected;
            
        }
        QueuesObject queObj = new QueueSObject(QueueId = g.id, SObjectType = 'Case');
        System.runAs(new User(Id=UserInfo.getUserId()))
        {      
            insert queObj;  
        }
 
        caseSelected = [SELECT Id, AccountId, ParentId, OwnerId, Account.OCS_External_Id__c, SFA_ListeCaricate__r.Tipo_Attivita__r.RSS_External_Id_act_code__c FROM Case WHERE ID=:caseSelected.id];
        caseSelected.OwnerId = g.id;
         Group queue2 = [SELECT Id, DeveloperName FROM Group WHERE ID=:caseSelected.OwnerId];
        String note = 'noteTest';
        XCS_dealers_conv_activity_disp__c esito = new XCS_dealers_conv_activity_disp__c();
        XCS_Disposition__c disp = new XCS_Disposition__c();
        disp.Name = SFAListaDaSedeAttivitaFilialeController.POSITIVO;
        insert disp;
        esito.Esito_1__c =disp.Id;
        insert esito;
        esito = [SELECT Id, Esito_1__r.name, Esito_2__c FROM XCS_dealers_conv_activity_disp__c WHERE ID=:esito.id];
        Boolean res = SFAListaDaSedeAttivitaFilialeController.setEsitoCase(caseSelected, esito, note);
        System.assert(res);
        Test.stopTest();
    }

}