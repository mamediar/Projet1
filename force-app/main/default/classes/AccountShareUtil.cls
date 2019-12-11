public class AccountShareUtil {
    
    //metodi per popolare il campo ShareAccount__c sul Account che deve essere usato come parametro di filtro per  la sharing rule
    
    public static void appendStringToAccountShare(String accountId, String str){
        Account a=[SELECT id, ShareAccount__c FROM Account WHERE id=:accountId][0];
        a=appendStringToAccountShare(a,str);
        update a;
    }

    public static Account appendStringToAccountShare(Account a, String str){
        if(!String.isEmpty(a.ShareAccount__c)){
            if(!a.ShareAccount__c.contains(str)){
                a.ShareAccount__c +=str+';';
            }            
        } else {
          a.ShareAccount__c =str+';';  
        }
        return a;
    }  
    
    public static void setStringInAccountShare(String accountId, String str){
        Account a=[SELECT id, ShareAccount__c FROM Account WHERE id=:accountId][0];
        a=setStringInAccountShare(a,str);
        update a;
    }

    public static Account setStringInAccountShare(Account a, String str){
            a.ShareAccount__c =str+';';
        return a;
    }    
    
}