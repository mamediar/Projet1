public class CRMReclamiGestioneRispostaApprCtrl {
    
    @AuraEnabled
    public static String getProfileLevelUser(String societa){
        Id userId = UserInfo.getUserId();
        List<User> uId = [SELECT rnt_profile_id__c FROM User WHERE Id=:userId];
        String idProfile = uId[0].rnt_profile_id__c;
        List<profile_level__mdt> pList = [SELECT Level__c FROM profile_level__mdt where societa__c = :societa AND id_profilo__c = :idProfile limit 1];
        if(pList==null ||pList.size()==0) return '0';
        return pList[0].Level__c;
    }
    
    
    @AuraEnabled
    public static String getCase(String idCase){
        Id ident = Id.valueOf(idCase);
        Case c = [Select Livello_Autorizzazione__c, toLabel(Tipo_Autorizzazione__c), Autorizzazione_Livello_1__c, Autorizzazione_Livello_2__c From Case Where id = :ident];
        return Json.serialize(c);
    }
    
    @AuraEnabled
    public static String autorizzaRespingiCtrl(String caseObj, String lbl){
        System.debug(caseObj);
        Case c = (Case)Json.deserialize(caseObj, Case.class);
        Case temp = new Case(ID = c.Id);
        System.debug(lbl);
        switch on lbl{ 
            when 'Richiedi Autorizzazione' {
                if(c.Autorizzazione_Livello_1__c.equals('Nessuno') || c.Autorizzazione_Livello_1__c.equals('4154')) temp.Autorizzazione_Livello_1__c = '4152';
                else if(c.Autorizzazione_Livello_2__c.equals('Nessuno') || c.Autorizzazione_Livello_2__c.equals('4157')) temp.Autorizzazione_Livello_2__c = '4155';
                insert XCSReclamiUtils.createFeedItem(c.id, Datetime.now(), 'sent for authorization', UserInfo.getName(), true);
            }
            when 'Autorizza Lv.1' {
                temp.Autorizzazione_Livello_1__c = '4153';
                temp.Livello_Autorizzazione__c = 1;
                insert XCSReclamiUtils.createFeedItem(c.id, Datetime.now(), 'date authorized', UserInfo.getName(), true);
            }
            when 'Respingi Lv.1' {
                temp.Autorizzazione_Livello_1__c = '4154';
                insert XCSReclamiUtils.createFeedItem(c.id, Datetime.now(), 'date not authorized o rejected', UserInfo.getName(), true);
                
            }
            when 'Autorizza Lv.2' {
                temp.Autorizzazione_Livello_2__c = '4156';
                temp.Livello_Autorizzazione__c = 2;
                insert XCSReclamiUtils.createFeedItem(c.id, Datetime.now(), 'date authorized', UserInfo.getName(), true);
            }
            when 'Respingi Lv.2' {
                temp.Autorizzazione_Livello_2__c = '4157';
                insert XCSReclamiUtils.createFeedItem(c.id, Datetime.now(), 'date not authorized o rejected', UserInfo.getName(), true);
            }
        }
            
        update temp;
        return getCase(temp.id);
    }
}