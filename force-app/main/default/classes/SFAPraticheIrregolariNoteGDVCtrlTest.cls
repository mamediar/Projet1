@isTest
public class SFAPraticheIrregolariNoteGDVCtrlTest {

    
    @testSetup
    static void setup(){

        Case cPadre = New Case();
        cPadre.ActivityType__c = 'SFA_PRAIRRPARENT';
        cPadre.Status='Closed';
        insert cPadre;    
        
        Case cFiglio = New Case();
        cFiglio.ActivityType__c = 'SFA_PRAIRR';
        cFiglio.Status='Closed';
        cFiglio.ParentId=cPadre.Id;
        insert cFiglio;        
        
        SFA_PraticaIrregolare__c pra = new SFA_PraticaIrregolare__c();
        pra.UltimaNotaInseritaDaFiliale__c = ('ciao');
        pra.EsitoCaricamento__c = 'Pratica caricata';
        pra.ActivityId__c=cFiglio.Id;
        pra.CodiceDealer__c = ('33'); 
        pra.CodicePv__c = ('33');
        pra.CodiceStatoDealer__c = ('33');
        pra.RagioneSociale__c = ('33');
        pra.NumeroPratica__c = ('33');
        pra.CodiceStatoPratica__c = ('33');
        pra.Dipendenza__c= ('33');
        pra.DataTermineLavoro__c = date.today()+1;
        pra.Status__c =('Pratica - Gestita filiale');
        insert pra;        
        
        
        XCS_CompassParameters__c obj = new XCS_CompassParameters__c();
        obj.Name = 'gdv.mail';
        obj.Value__c ='luca@prtova.it';
        insert obj;
        
                
        XCS_CompassParameters__c obj1 = new XCS_CompassParameters__c();
        obj1.Name = 'inviomail.mock';
        obj.Value__c ='luca@prtova.it';
        insert obj1;         
        

        
        string z =[select id from RecordType where Name = 'Person Account'][0].id;
        Account a2 = new Account();
        a2.LastName = 'Dummy';
        a2.FirstName = 'Dummy';
        a2.BusinessEmail__c = 'lucacragno@prova.it';
        a2.RecordTypeId = z;
        insert a2;  
        
          
        
        //Inserisci file
        ContentNote contentNote1 = new ContentNote(
          Title = 'Penguins',
          Content = Blob.valueOf('Penguins.jpg')
        );
        insert contentNote1;

        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId,CreatedDate FROM ContentDocument ORDER BY CreatedDate DESC];        
        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = pra.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'I';
        insert cdl;        
        
        
    }
    
    @isTest
    public static void test (){
        

        Id praId=[SELECT id from SFA_PraticaIrregolare__c where EsitoCaricamento__c='Pratica caricata'][0].id;
        
        SFAPraticheIrregolariNoteGDVController.getIfFlagVisible(praId);
        SFAPraticheIrregolariNoteGDVController.getAllNotes(praId);
        SFAPraticheIrregolariNoteGDVController.insertNote('',praId,true);
        
    }   
 
}