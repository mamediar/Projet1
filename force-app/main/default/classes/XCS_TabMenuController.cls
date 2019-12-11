public class XCS_TabMenuController {
	@auraEnabled
    public static List<XCS_Tab_Menu_Config_Item__mdt> doInitApex(String configurationName){
        List<XCS_Tab_Menu_Config_Item__mdt> configSelectedTabs= [SELECT MasterLabel , DeveloperName , order__c, 
                    (SELECT MasterLabel, Type__c FROM XCS_Tab_Menu_Config_Item_Permissions__r) 
                FROM XCS_Tab_Menu_Config_Item__mdt 
                WHERE XCS_Tab_Menu_Config__r.DeveloperName =: configurationName ORDER BY order__c];  
        List<XCS_Tab_Menu_Config_Item__mdt> tabsToBeReturned=  new List<XCS_Tab_Menu_Config_Item__mdt>();
        id userId= UserInfo.getUserId();
        user u= [select Name, Profile.Name from User where id=:userId];
        for(XCS_Tab_Menu_Config_Item__mdt tab : configSelectedTabs){
            
            if(tab.XCS_Tab_Menu_Config_Item_Permissions__r.isEmpty()){
                tabsToBeReturned.add(tab);
            }
            else{
                for(XCS_Tab_Menu_Config_Item_Permission__mdt permission: tab.XCS_Tab_Menu_Config_Item_Permissions__r){
                    System.debug(u.Profile.name.equalsIgnoreCase(permission.MasterLabel) + ' ____ ' + permission.MasterLabel);
                    if('Profile'.equalsIgnoreCase(permission.Type__c) && (u.Profile.name.equalsIgnoreCase(permission.MasterLabel)||u.Profile.name.equalsIgnoreCase('System Administrator'))){
                        tabsToBeReturned.add(tab);
                        break;
                    }
                    else if('Custom_Permissions'.equalsIgnoreCase(permission.Type__c) && FeatureManagement.checkPermission(permission.MasterLabel)||u.Profile.name.equalsIgnoreCase('System Administrator')){
                        tabsToBeReturned.add(tab);
                        break;
                    }
                }
            }
        }
        return tabsToBeReturned;
    }
}