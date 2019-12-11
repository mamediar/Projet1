public class PicklistChangeProfileController 
{
	@AuraEnabled	 
    public static list<Profile> getPickListValuesProfile()
    {
      List<Profile> profilelist = [select name from profile];
      return profilelist; 
    }
     
   @AuraEnabled	 
    public static String changeProfile(String profileid)
   {
   	System.debug('ID DA FLOW:' + profileid);
  	
    User persona = [select firstname,name,profileid from User where id = :UserInfo.getUserId()];
    System.debug('ID ATTUALE:' + persona.ProfileId);
    persona.ProfileId = profileid;
   	System.debug('ID NUOVO:' + persona.ProfileId);
    update persona; 
    return profileid;
   }
}