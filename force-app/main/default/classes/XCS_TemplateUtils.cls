public class XCS_TemplateUtils {
    
    //constant
    public static final String SMS_RECORDTYPE_NAME = 'SMS';
    public static final String SMS_Name = 'SMS';
    
    //methods
    public static String getBody(String templateName){
       String res=[select Body__c from XCS_Template__c where name=:templateName].Body__c;
       return res!=null?res:'';

    }
    
	public static Map<String,XCS_Template__c> getMapFromList(List<XCS_Template__c> listTemplate)
    {
        Map<String,XCS_Template__c> mapTemplate = new Map<String,XCS_Template__c>();
        for(XCS_Template__c t : listTemplate)
        {
            mapTemplate.put(t.ExternalCode__c, t);
        }
        return mapTemplate;
    }
	    
    public static List<XCS_Template__c> getRecordByExternalIdList(List<String> listExternalId)
    {
    	return [SELECT APEXLogic__c, ExternalCode__c, Body__c, Id, Name FROM XCS_Template__c Where ExternalCode__c IN :listExternalId];
    }
    public static XCS_Template__c getRecordByName(String nameTemplate)
    {
        return [SELECT APEXLogic__c, ExternalCode__c, Body__c, Id, Name,Subject__c FROM XCS_Template__c Where Name = :nameTemplate][0];
    }
    
    public static List<XCS_Template__c> getListRecordByRecordtypeAndName(String recordtypeDevelopername,String likeName)
    {
        String lName = likeName + '%';
        String q = 'SELECT APEXLogic__c, ExternalCode__c, Body__c, Id, Name,subject__c FROM XCS_Template__c Where Name like :lName AND recordtype.developerName = :recordtypeDevelopername';
        return Database.query(q);
    }
    
    public static String buildTemplate(String body,List<String> fillers){
        return String.format(body,fillers);
    }
    
    public static String buildTemplateByName(String templateName) {
        return getBody(templateName);
    }
    
    public static String buildTemplateByName(String templateName,List<String> fillers){
        return buildTemplate(getBody(templateName),fillers);

    }
    
    public static String buildTemplatePVByName(List<String> fillers,String body){
        return buildTemplate(body,fillers);
    }
    
}