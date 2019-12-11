public without sharing class SFACancellazioneFile {

	@AuraEnabled
    public static void deleteFile(String fileId)
    {   
		System.debug('*** fileId :: ' + fileId);
        ContentDocument cd = [select id,Description from ContentDocument where Id=:fileId]; 
        try{
            delete cd;                
        }
        catch (Exception ex) {
            system.debug('Exception has occurred! ' +ex.getMessage());  
        }
	}

}