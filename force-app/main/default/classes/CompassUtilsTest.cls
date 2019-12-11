@isTest
public class CompassUtilsTest {
    @isTest static void testIsThereAttach(){
        Account acct = new Account(Name='TEST_ACCT');
        insert acct;
        
        ContentVersion contentVersion = new ContentVersion(
          Title = 'Penguins',
          PathOnClient = 'Penguins.jpg',
          VersionData = Blob.valueOf('Test Content'),
          IsMajorVersion = true
        );
        insert contentVersion;    
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = acct.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        insert cdl;
        
        CompassUtils.isThereAttach(acct.id);
    }
    
    @isTest static void testFileNewInstanceBase64(){
        CompassUtils.fileNewInstance('testBase', 'TestFile','txt');
    }
    
    @isTest static void testFileNewInstance(){
        PageReference pr=Page.ConfirmLotReceiptEXCEL;
        Test.setCurrentPage(pr);
        CompassUtils.fileNewInstance('ConfirmLotReceiptEXCEL',pr.getParameters().get('Id'),'TestFile','txt');
    }

    @isTest static void testFileNewInstanceBlob(){
        PageReference pr=Page.ConfirmLotReceiptEXCEL;
        Test.setCurrentPage(pr);
        CompassUtils.fileNewInstance('ConfirmLotReceiptEXCEL','TestFile','txt');
    }
    
    @isTest static void testAttachFile(){
        Account acct = new Account(Name='TEST_ACCT');
        insert acct;
        
        ContentVersion contentVersion = new ContentVersion(
          Title = 'Penguins',
          PathOnClient = 'Penguins.jpg',
          VersionData = Blob.valueOf('Test Content'),
          IsMajorVersion = true
        );
        insert contentVersion;    
        
        CompassUtils.attachFile(contentVersion.Id,acct.Id);
    }
    
    @isTest static void testCopyFiles(){
        Account acct = new Account(Name='TEST_ACCT');
        insert acct;
        
        ContentVersion contentVersion = new ContentVersion(
          Title = 'Penguins',
          PathOnClient = 'Penguins.jpg',
          VersionData = Blob.valueOf('Test Content'),
          IsMajorVersion = true
        );
        insert contentVersion;
        List<ContentVersion> attachs=new List<ContentVersion>();
        attachs.add(contentVersion);
        CompassUtils.copyFiles('TestId', attachs);
    }
    
    @isTest static void testGeneraFile(){
        CompassUtils.generaFile('','Test');
    }
}