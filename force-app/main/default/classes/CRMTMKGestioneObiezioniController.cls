public class CRMTMKGestioneObiezioniController {
    @AuraEnabled
    public static String scriptObiezioni(String filterCampType, String filterCampCQS) {
        if(filterCampCQS != 'CQS'){
        return [select text__c from xcs_script__c where tipocampagna__c =:filterCampType and ActionCode__c != 'CQS' and sectiontype__c = 'OBI'].text__c;
        }
        else {
            return [select text__c from xcs_script__c where ActionCode__c =:filterCampCQS  and sectiontype__c = 'OBI'].text__c;
        }
    }
}