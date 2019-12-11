public class CRMReclamiFormIDMController {
    
    @AuraEnabled
    public static Map<String,Object> loadObjects (String recordId) {
        Map<String,Object> objMap = new Map<String,Object>();
        Case caseChild = [SELECT ParentId,Status,OwnerId FROM Case WHERE Id = : recordId LIMIT 1];
        Case caseParent = [SELECT Id,Status FROM Case WHERE Id = : caseChild.ParentId LIMIT 1];
        List<Attachment> listaAllegati = [SELECT Id, Name, Body, Description FROM Attachment WHERE ParentId = : recordId ];
        Group queueSelezionata = [SELECT Id, Type, Email, OwnerId, Name, DeveloperName FROM Group WHERE Type = 'Queue' AND Id = : caseChild.OwnerId LIMIT 1];
        objMap.put('caseChild', caseChild);
        objMap.put('caseParent',caseParent);
        objMap.put('allegatiSelezionati', listaAllegati);
        objMap.put('codaIDM',queueSelezionata);
        
        return objMap;
    }
    
    @AuraEnabled
    public static void gestisciReclamo(String recordId){
        Case caseChild = [SELECT ParentId,Status FROM Case WHERE Id = : recordId LIMIT 1];
        caseChild.Status = 'Gestito'; //TODO con DISPOSITION
        update caseChild;
        
        Case caseParent = [SELECT Id,Status FROM Case WHERE Id = : caseChild.ParentId ];
        
        caseParent.Status = 'Gestito'; //TODO con DISPOSITION
        update caseParent;
    }
}