public class XCS_DispositionForAppBuilderApex {
    
    @AuraEnabled  
    public static Map<String, List<XCS_Disposition__c>> getDispositionApex(String rootExternalId){
        Map<String, List<XCS_Disposition__c>> result = new Map<String, List<XCS_Disposition__c>>();
        
        List<XCS_Disposition__c> AllDispositions= [SELECT Id , Name , CaseStatus__c , DispositionScript__c, External_Id__c, Parent__r.External_Id__c, Visibility__c FROM XCS_Disposition__c WHERE External_Id__c=: rootExternalId OR Parent__r.External_Id__c=: rootExternalId  OR Parent__r.Parent__r.External_Id__c=: rootExternalId OR Parent__r.Parent__r.Parent__r.External_Id__c=: rootExternalId OR Parent__r.Parent__r.Parent__r.Parent__r.External_Id__c=: rootExternalId OR Parent__r.Parent__r.Parent__r.Parent__r.Parent__r.External_Id__c=: rootExternalId];

        for(XCS_Disposition__c disposition:AllDispositions){
            if(result.containsKey(disposition.Parent__r.External_Id__c)){
                result.get(disposition.Parent__r.External_Id__c).add(disposition);
            }
            else{
                result.put(disposition.Parent__r.External_Id__c, new List<XCS_Disposition__c>{disposition});
            }
        }
        return result;
    }

    @AuraEnabled
    public static void updateObject(Id sObjectId, String esito, String note, String status, String lastDisposition){

        sObject sObj = sObjectId.getSobjectType().newSObject(sObjectId);
        String utenteId = UserInfo.getUserId();

        XCS_Disposition__c disposition = XCS_DispositionUtils.findDispositionByExternalID( lastDisposition );
        
        sObj.put('Esito__c',esito);
        sObj.put('Note__c',note);
        sObj.put('Owner_User__c', utenteId);
        sObj.put('Disposition__c', disposition.id);
        if(String.isNotBlank(status)){
            String StatusFieoldName = hasSObjectField('Status',sObj) ? 'Status' : hasSObjectField('Status__c',sObj) ? 'Status' : '';
            if(String.isNotBlank(StatusFieoldName)){
                sObj.put(StatusFieoldName,status);
            }
        }

        update sObj;
    }

    private static boolean hasSObjectField(String fieldName, SObject so){
            return so.getSobjectType().getDescribe().fields.getMap().keySet().contains(fieldName.toLowerCase());
    }
}