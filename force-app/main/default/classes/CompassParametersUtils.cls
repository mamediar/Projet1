public class CompassParametersUtils {
    
    public static String getLabelFromService(String service, String field, String fieldValue) {        
        String res = '';
        if(String.isNotBlank(fieldValue)){
            String groupName = 'WS.' + service +'.' + field;        
            res = [SELECT Label__c FROM XCS_CompassParameters__c WHERE Group__c =: groupName AND Value__c =: fieldValue].Label__c;  
        }
        return res; 
    }
        
    public static String getValue(String name) {            
        XCS_CompassParameters__c res = XCS_CompassParameters__c.getValues(name);
        return res == null ? null : res.Value__c;            
    }
    
    public static List<String> getListValues(String name){
        List<String> res = new List<String>();            
        String valueCSV = getValue(name);
        res = valueCSV.split(';');
        return res;
    }

    public static Map<String, String> getParameterByGroup(String groupName) {
        List<XCS_CompassParameters__c> lstCompassParameters = [SELECT Name, Label__c, Value__c FROM XCS_CompassParameters__c WHERE Group__c = :groupName];

        Map<String, String> mapCompassParameters = new Map<String, String>();

        for (XCS_CompassParameters__c cp : lstCompassParameters) {
            mapCompassParameters.put(cp.Label__c, cp.Value__c);
        }

        return mapCompassParameters;
    }
       
}