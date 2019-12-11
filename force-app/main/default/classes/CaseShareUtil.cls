public class CaseShareUtil {
    
    //metodi per popolare il campo ShareCase__c sul Case che deve essere usato come parametro di filtro per  la sharing rule
    
    //appende al CaseShare__c la string passata
    public static void appendStringToCaseShare(String caseId, String str){
        Case c=[SELECT id, ShareCase__c FROM Case WHERE id=:caseId][0];
        c=appendStringToCaseShare(c,str);
        update c;
    }

    public static Case appendStringToCaseShare(Case c, String str){
        if(!String.isEmpty(c.ShareCase__c)){
            if(!c.ShareCase__c.contains(str)){
                c.ShareCase__c +=str+';';
            }            
        } else {
          c.ShareCase__c =str+';';  
        }
        return c;
    }  
    
    //imposta nel CaseShare__c la string passata
    public static void setStringInCaseShare(String caseId, String str){
        Case c=[SELECT id, ShareCase__c FROM Case WHERE id=:caseId][0];
        c=setStringInCaseShare(c,str);
        update c;
    }

    public static Case setStringInCaseShare(Case c, String str){
            c.ShareCase__c =str+';';
        return c;
    }  
    
    //svuota il case share
    public static void emptyCaseShare(String caseId){
        Case c=[SELECT id, ShareCase__c FROM Case WHERE id=:caseId][0];
        c=emptyCaseShare(c);
        update c;
    }

    public static Case emptyCaseShare(Case c){
            c.ShareCase__c =null;
        return c;
    }     
    
}