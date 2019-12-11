public class XCSDeskItemService {  
  /**
  * @author Mame Diarra    
  * @date 2019/08/21
  * @description search DeskItem by desk 
  * @param  idDesk : id XCS_Desk
  * @return a DeskItem
  */
    
    public static XCS_DeskItem__c getDeskItem(String idDesk){
        XCS_DeskItem__c deskItem = new XCS_DeskItem__c();
        try {
           	deskItem = [SELECT Id, Desk__c, StartTime__c, EndTime__c, Monday__c, Tuesday__c, Wednesday__c, Thursday__c,
                        Friday__c, Saturday__c, Sunday__c, Name FROM XCS_DeskItem__c WHERE Desk__c =: idDesk];
        }catch (Exception e) {
        	System.debug('errorMessage getFilialeByName '+e.getMessage());
        }
        return deskItem;
    }
}