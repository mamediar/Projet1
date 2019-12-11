public class CRMReclamiInserimentoAllegatiCTRL {

    /*@AuraEnabled
    public static List <ContentDocument> getFiles(String caseId) {
        System.debug('Boris '+caseId);
        return [SELECT Id, Title, OwnerId FROM ContentDocument WHERE parentId =: caseId];
    }*/

    @AuraEnabled
    public static List <Attachment> getFiles(String caseId) {
        System.debug('MS_ATTACHMENT '+caseId);
        List <Attachment> att = XCSReclamiUtils.documentToAttachment(caseId);
        System.debug('MS_ATTACHMENT: '+att);
        return att;
    }
    
}