public class GPS_ContrattiSmarritiController {

    public class CaseInfo{
        @InvocableVariable(required = true label = 'Categoria External Id')
        public String CategoriaExternalId;
        @InvocableVariable(required = true)
        public String sourceId;
        @InvocableVariable(required = true)
        public String recordTypeDeveloperName;
        @InvocableVariable(required = true)
        public String subject;
        @InvocableVariable(required = true label = 'Developer Name Owner')
        public String ownerDeveloperName;
    }

    @InvocableMethod
    public static void copyFilesToNewCase(List<CaseInfo> data) {
        for(CaseInfo c : data){
            List<Id> cDsIds = new List<Id>();
            String ownerId = GroupUtils.getQueue(c.ownerDeveloperName).Id;
            String recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName =: c.recordTypeDeveloperName].Id;
            
            for(ContentDocumentLink cdl : [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =: c.sourceId]) cDsIds.add(cdl.ContentDocumentId);
            
            List<ContentVersion> contentVersions = [SELECT Id,ContentLocation,PathOnclient,Title,VersionData FROM ContentVersion WHERE ContentDocumentId in: cDsIds];
            List<Contract> contractsToCopy = [SELECT Id, Case__c FROM Contract WHERE Case__c =: c.sourceId];
            
            Case tempCase = new Case(categoria_riferimento__r = new XCS_Categoria__c(External_Id__c = c.CategoriaExternalId), RecordTypeId = recordTypeId, Subject = c.subject, OwnerId = ownerId);
            insert tempCase;
            
            List<ContentVersion> filesCopied = CompassUtils.copyFiles(tempCase.Id, contentVersions);
            for(ContentVersion cv : filesCopied) CompassUtils.attachFile(cv.Id, tempCase.Id);
            for(Contract cnt : contractsToCopy) cnt.Case__c = tempCase.Id;
            update contractsToCopy;
        }
    }
}