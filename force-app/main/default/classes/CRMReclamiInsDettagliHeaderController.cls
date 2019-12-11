public class CRMReclamiInsDettagliHeaderController {
    @AuraEnabled
    public static Map<String,List<Object>> getInitValues(String societa){
        societa=(societa.equals(XCSCompassConstants.COMPASS)?'C':societa.equals(XCSCompassConstants.FUTURO)?'F':'R');
        Map<String,List<Object>> res=new Map<String,List<Object>>();
        List<String> modalita=new List<String>();
        Schema.DescribeFieldResult fieldResultMod=Case.Modalita_Invio__c.getDescribe();
        List<Schema.PicklistEntry> ple=fieldResultMod.getPicklistValues();
        for(Schema.PicklistEntry pickListVal:ple){
            modalita.add(pickListVal.getLabel());
        }
        List<CRM_RCL_Tipologia_Reclamo__mdt> tipi=[select DeveloperName,Area__c,Auth__c,Descrizione__c,External_Id__c,Rule_Id__c
                                                   from CRM_RCL_Tipologia_Reclamo__mdt
                                                   where Societa__c=:societa and Visibile__c=true];
        res.put('modList',modalita);
        res.put('tipiList',tipi);
        return res;
    }
    
       
}