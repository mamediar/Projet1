public class SitesTokenUtil {
    public static String generateToken(Id objectId, datetime expirationDate , String componentName , String componentApp) {
        
        if(null == objectId ||String.isBlank(componentName)){
            throw new SitesTokenException('Invalid Input for Method generateToken');
        }
        Blob b = Crypto.GenerateAESKey(128);
        String h = EncodingUtil.ConvertTohex(b);
        String guid = h.SubString(0,8)+ '-' + h.SubString(8,12) + '-' + h.SubString(12,16) + '-' + h.SubString(16,20) + '-' + h.substring(20);
        
        
        
        insert new XCS_Sites_Token__c(token__c = guid , Expiration_Date__c = expirationDate , ObjectId__c = objectId , ComponentName__c = componentName ,ComponentApp__c = componentApp);
        return guid;
    }
    
    public static String generateToken(Id objectId, datetime expirationDate , String componentName , String componentApp, String Name) {
        
        if(null == objectId ||String.isBlank(componentName)){
            throw new SitesTokenException('Invalid Input for Method generateToken');
        }
        Blob b = Crypto.GenerateAESKey(128); 
        String h = EncodingUtil.ConvertTohex(b);
        String guid = h.SubString(0,8)+ '-' + h.SubString(8,12) + '-' + h.SubString(12,16) + '-' + h.SubString(16,20) + '-' + h.substring(20);
        
        
        
        insert new XCS_Sites_Token__c(name = Name,token__c = guid , Expiration_Date__c = expirationDate , ObjectId__c = objectId , ComponentName__c = componentName ,ComponentApp__c = componentApp);
        return guid;
    }
    
     public static String generateToken( datetime expirationDate , String componentName , String componentApp, Id objectId, String messaggio) {
        
        if(null == objectId ||String.isBlank(componentName)){
            throw new SitesTokenException('Invalid Input for Method generateToken');
        }
        Blob b = Crypto.GenerateAESKey(128);
        String h = EncodingUtil.ConvertTohex(b);
        String guid = h.SubString(0,8)+ '-' + h.SubString(8,12) + '-' + h.SubString(12,16) + '-' + h.SubString(16,20) + '-' + h.substring(20);
        
        
        
        insert new XCS_Sites_Token__c(messaggio__c = messaggio,token__c = guid , Expiration_Date__c = expirationDate , ObjectId__c = objectId , ComponentName__c = componentName ,ComponentApp__c = componentApp);
        return guid;
    }
    
    
    public static String verifyToken(List<XCS_Sites_Token__c> sttList) {
      
        if(!sttList.isEmpty() && sttList.size() == 1 && !sttList.get(0).Burned__c){
            if(sttList.get(0).Expiration_Date__c > datetime.now()){
                return 'ok';
            }else{
                return 'expired';
            }
        }
        return 'ko';
    }
    
    public static String burnToken(List<XCS_Sites_Token__c> sttList) {
        String response = 'ko';
        
        Map<String, XCS_Sites_Token__c> openTokenMap = new Map<String, XCS_Sites_Token__c>([SELECT ID , token__c FROM XCS_Sites_Token__c WHERE Burned__c = false AND Expiration_Date__c >: DateTime.now()]);
        if(openTokenMap.containsKey(sttList.get(0).Id)){
            //sttList.get(0).Response__c = inputValue;
            sttList.get(0).Burned__c = true;
            update sttList;
           
            response = 'finish';
        }
        
        return response;
    }

    public static void burnToken(id objectId) {
        if(objectId!=null){
            delete[SELECT Id FROM XCS_Sites_Token__c WHERE objectId__c =:objectId];
        }
    }
    
    
    public class SitesTokenException extends Exception {}


}