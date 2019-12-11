public class MenuComposingController {
    
    @AuraEnabled
    public static MenuConfigMatrix__mdt[] loadMenuItems(String menuItem, String viewName){
		Set<String> exclude = new Set<String>();
        exclude.add('CRMReclamiInserimentoContainer');
        MenuConfigMatrix__mdt[] mcm = [SELECT Label, Destination__c, Sort_Order__c from MenuConfigMatrix__mdt WHERE Parent__c =: menuItem AND View_Name__c =: viewName ORDER BY Sort_Order__c ASC];
        for(Integer i=0; i<mcm.size();){
            MenuConfigMatrix__mdt temp = mcm[i];
            if(exclude.contains(temp.Destination__c)) mcm.remove(i);
            else i++;
        }      
        return mcm;
        
    }
}