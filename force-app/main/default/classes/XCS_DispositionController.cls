public class XCS_DispositionController {
    
    @AuraEnabled
    public static Map<Id,XCS_Disposition__c> getDispositions(String parentExternalId, String visibilityOption) {
        
        Id dispositionParentId = [SELECT Id FROM XCS_Disposition__c WHERE External_Id__c=:parentExternalId][0].Id;
        
        if(!String.isEmpty(visibilityOption)){
            visibilityOption= '%'+visibilityOption+'%';
            Map<Id,XCS_Disposition__c> mapDisposition = new Map<Id,XCS_Disposition__c>([SELECT Id,Visibility__c ,Name, External_Id__c,CaseStatus__c,Azione__c FROM XCS_Disposition__c WHERE Visibility__c LIKE :visibilityOption AND Parent__c=:dispositionParentId AND isDeleted=false ]);                                
            return mapDisposition;
        } 
        else {
            Map<Id,XCS_Disposition__c> mapDisposition = new Map<Id,XCS_Disposition__c>([SELECT Id,Visibility__c, Name, External_Id__c,CaseStatus__c,Azione__c FROM XCS_Disposition__c WHERE Parent__c=:dispositionParentId AND isDeleted=false ]);
            return mapDisposition;
        }
        
    } 

    @AuraEnabled
    public static Map<Id,XCS_Disposition__c> getDispositions(String parentExternalId, String visibilityOption, Boolean usesCategory) {

        if (usesCategory) {
        
            if(!String.isEmpty(visibilityOption)){
                visibilityOption= '%'+visibilityOption+'%';
                Map<Id,XCS_Disposition__c> mapDisposition = new Map<Id,XCS_Disposition__c>([SELECT Id, Name, External_Id__c,CaseStatus__c FROM XCS_Disposition__c WHERE Visibility__c LIKE :visibilityOption AND isDeleted=false AND Categoria__r.External_Id__c = :parentExternalId]); 
                return mapDisposition;
            } 
            else {
                Map<Id,XCS_Disposition__c> mapDisposition = new Map<Id,XCS_Disposition__c>([SELECT Id, Name, External_Id__c,CaseStatus__c FROM XCS_Disposition__c WHERE isDeleted=false AND Categoria__r.External_Id__c = :parentExternalId ]);                                
                return mapDisposition;
            }

        }
        else {
            return getDispositions(parentExternalId, visibilityOption);
        }
        
    } 
    
    @AuraEnabled
    public static void handleCase(XCS_Disposition__c disposition,String recordId,String note){
        System.debug('DispositionSelezionata' + disposition + 'dispositionstatus:' + disposition.CaseStatus__c);           
        if(String.isEmpty(note)){
            CaseUtils.aggiornaDispositionCase(recordId,disposition);
        } 
        else {
            CaseUtils.aggiornaDispositionCase(recordId,disposition,note);
            XCSNoteUtils.postANote(recordId,'Nota - '+disposition.Name,!String.isEmpty(note)?note:'');
        }        
        
    }
	@AuraEnabled
    public static XCSDispositionResult doDispositionAction(SObject obj,XCS_Disposition__c disposition)
    {
        XCSDispositionResult res = null;
        if(String.isNotBlank(disposition.Azione__c))
        {
            XCSDispositionAction action = (XCSDispositionAction)Type.forName(disposition.Azione__c).newInstance();
            action.setSObject(obj);
            action.setDisposition(disposition);
            res = action.execute();
        }
        return res;
    }    
    
    
    
}