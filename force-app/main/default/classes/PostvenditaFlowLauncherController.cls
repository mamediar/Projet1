public class PostvenditaFlowLauncherController {
	@AuraEnabled
    public static List<PostvenditaConfig__mdt> loadListaTipologia(){

        List<PostvenditaConfig__mdt> listpg = [SELECT Label FROM PostvenditaConfig__mdt WHERE TipoPicklist__c = 'Tipologia'];
        
        return listpg;
    }
    
    @AuraEnabled
    public static List<PostvenditaConfig__mdt> loadListaSottotipologia(String tipologiaSelezionata){

        List<PostvenditaConfig__mdt> listpg = [SELECT Id, Label,FlowName__c, QueueName__c, RecordType__c, Subject__c FROM PostvenditaConfig__mdt WHERE TipoPicklist__c = 'Sottotipologia' AND Dipendenza__c =: tipologiaSelezionata];
        
        return listpg;
    }
    
    @AuraEnabled
    public static Sottotipologia loadSottotipologiaAttribute(PostvenditaConfig__mdt pvc){
        
        RecordType record = [SELECT Id FROM RecordType WHERE Name =: pvc.RecordType__c AND SobjectType = 'Case'];
        Group gruppo = [SELECT Id FROM Group WHERE Name=: pvc.QueueName__c];
        
        Sottotipologia sottotipologia = new Sottotipologia();
        sottotipologia.Id = pvc.Id;
        sottotipologia.Label = pvc.Label;
        sottotipologia.QueueNameId = gruppo.Id;
        sottotipologia.RecordTypeId = record.Id;
        sottotipologia.Subject = pvc.Subject__c;
        sottotipologia.FlowName = pvc.FlowName__c;
        
        return sottotipologia;
    }
    
    public class Sottotipologia{
        @AuraEnabled
        public String Id{get; set;}
        @AuraEnabled
        public String Label{get; set;}
        @AuraEnabled
        public String QueueNameId{get; set;}
        @AuraEnabled
        public String RecordTypeId{get; set;}
        @AuraEnabled
        public String Subject{get; set;}
        @AuraEnabled
        public String FlowName{get;set;}
        
    }
}