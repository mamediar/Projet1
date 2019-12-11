public class XCS_TownUtils {
    
    @AuraEnabled
    public static XCS_Town__c[] loadTowns() {
        
        XCS_Town__c[] towns = [SELECT Id,Provincia__c,Comune__c,CAP__c,Soppresso__c,Provincia_Desc__c,Catastale__c FROM XCS_Town__c WHERE Catastale__c!=null AND Soppresso__c=false]; 
        
        return towns;
    }
    
    @AuraEnabled
    public static GroupProvinceOutput groupProvince() { 
        
        GroupProvinceOutput innerClassObject = new GroupProvinceOutput();
        
        innerClassObject.townList = loadTowns(); 
        
        for (XCS_Town__c town : innerClassObject.townList) { 
            if( !town.Soppresso__c && !String.isEmpty(town.Provincia_Desc__c) ) {
                
                if(!innerClassObject.mapProvince.keySet().contains(town.Provincia_Desc__c)){
                    innerClassObject.mapProvince.put(town.Provincia_Desc__c, new List<String>{town.Comune__c});  
                } 
                else{
                    List<String> comuniList = innerClassObject.mapProvince.get(town.Provincia_Desc__c);
                    comuniList.add(town.Comune__c);
                    innerClassObject.mapProvince.put( town.Provincia_Desc__c, comuniList);
                }
            } 
         }
        
        //innerClassObject.townList = [SELECT Provincia_Desc__c,Provincia__c FROM XCS_Town__c];
        System.debug('TOWNLIST::::::> ' + innerClassObject.townList);
        
        return innerClassObject;
    }
    
    
    public class GroupProvinceOutput {
        
        @AuraEnabled
        public Map<String, List<String>> mapProvince {get;set;}
        
        @AuraEnabled
        public List<XCS_Town__c> townList {get;set;} 
        
     
        public GroupProvinceOutput () {
            
            mapProvince = new Map<String, List<String>>();
        }
        
    }
    
}