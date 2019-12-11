public class XCSDeskService {
	
  /**
  * @author Mame Diarra    
  * @date 2019/08/21
  * @description search desk by filiale 
  * @param  idFiliale : id filiale
  * @return a list of xcs_Desk__c
  */
    
    public static List<XCS_Desk__c> getListDesk(String idFiliale){
        List<XCS_Desk__c> listDesk = new List<XCS_Desk__c>();
        try {
           	listDesk = [SELECT Id, Branch__c, DeskName__c, Product__c, isActive__c, Name, IsDeleted, RSS_External_Id__c
                        FROM XCS_Desk__c WHERE Branch__c =: idFiliale and isActive__c=true];
        }catch (Exception e) {
        	System.debug('errorMessage getFilialeByName '+e.getMessage());
        }
        return listDesk;
    }
}