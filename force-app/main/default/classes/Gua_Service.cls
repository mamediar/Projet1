/**
 * @File Name          : Gua_Service
 * @Description        : Class for Managing generic function
 * @Author             : Abdoulaye DIOP (AD)
 * @CreatedDate        : 18/09/2019
**/
public with sharing class Gua_Service {
    
    /**
     * @author AD
     * @date  16/09/2019
     * @description Method used to get picklist values
     * @param sObject objObject the object which the field belong
     * @param String fld the name of the field.
     **/
    public static List<String> getSelectOptions(SObject objObject, String fld){
        List<String> allOpts = new List<String>();
        // Get the object type of the SObject.
        Schema.SObjectType objType = objObject.getSObjectType();
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        // Get a map of fields for the SObject
        Map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();

        // Get the list of picklist values for this field.
        list <Schema.PicklistEntry> values = fieldMap.get(fld).getDescribe().getPickListValues();
        
        // Add these values to the selectoption list.
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        }
        allOpts.sort();
        return allOpts;
    }

    /**
     * @author AD
     * @date  18/09/2019
     * retrieves a RecordType id by developer name
     * @param  developerName API name of the a record type of the sObject
     * @param  sObjectType   API name of the sObject 
     * @return               the id of the recordtype
     */
    public static Id getRecordTypeId(String developerName, String sObjectType) {
        return Schema.getGlobalDescribe().get(sObjectType).getDescribe()
               .getRecordTypeInfosByDeveloperName()                                             
               .get(developerName)
               .getRecordTypeId();
    }

    /**
     * @author AD
     * @date  10/11/2019
     */
    private static boolean handleRun = true;
    public static boolean handleRunOnce(){
        if(handleRun) {
            handleRun = false;
            return true;
        } else {
            return handleRun;
        }
    }
}