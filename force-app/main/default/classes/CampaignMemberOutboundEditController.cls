public without sharing class CampaignMemberOutboundEditController {
    /**
     *          LABEL                               API
     *
     * Chiede di essere richiamato	            --> 01
     * Non risponde al telefono	                --> 04
     * Fissa Appuntamento	                    --> 19
     * Chiede di non essere più chiamato	    --> 06
     * Non risponde al telefono (più tentativi)	--> 15
     * Numero errato/inesistente	            --> 16
     * Interessato in futuro	                --> 20
     * Non interessato	                        --> 21
     */
    
    //public static Set<String> finalStatus =  new Set<String>{'Fissa Appuntamento','Chiede di non essere più chiamato','Non risponde al telefono (più tentativi)','Numero errato/inesistente','Interessato in futuro','Non interessato'};
    public static Set<String> finalStatus =  new Set<String>{'19','06','15','16','20','21'};
    @AuraEnabled
    public static string saveCampaignMember(CampaignMember member){
        System.debug('member:'+member);
        try{
            if(member!=null && '01' != member.Esito__c ){
                member.Richiamare__c = null;
            }

            if(finalStatus.contains(member.Esito__c)){
                member.Status = 'Responded';
            } else {
                member.Status = 'Sent';
            }

            member.Utente__c = UserInfo.getName();

            update member;
        } catch(Exception e){
            System.debug('exception:'+e);
            return e.getMessage();
        }
        return 'SUCCESS';
    }

    @AuraEnabled
    public static String getNextRecord(String campaignMemberId, String campaignId){
        List<CampaignMember> members = [SELECT ID FROM CampaignMember where CampaignId = :campaignId AND Status='Sent' order by Esito__c desc,LastName desc];
        Boolean returnNext = false;
        for(CampaignMember member : members){
            if(returnNext){
                return member.Id;
            }
            if(member.ID.equals(campaignMemberId)){
                returnNext = true;
            }
        }
        return members[0].ID;
    }
}