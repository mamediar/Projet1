public class CampaignHandler extends TriggerHandler{
    Id campaignMemberRecordTypeId;
    CampaignOutboundTriggerUtils campaignOutbound;
    public CampaignHandler (){
        campaignOutbound = new CampaignOutboundTriggerUtils();
        campaignMemberRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaign Outbound').getRecordTypeId();
    }
    public override void afterInsert() {   
        System.debug('_______CampaignHandler.afterInsert____START');       
        /*Id campaignOutboundRT = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaign Outbound').getRecordTypeId();        
        List<CampaignMemberStatus> cms2Delete = new List<CampaignMemberStatus>();
	    List<CampaignMemberStatus> cms2Insert = new List<CampaignMemberStatus>();
        for(Campaign c : (List<Campaign>)Trigger.new){
            CampaignMemberStatus cms1 = new CampaignMemberStatus(CampaignId=c.ID, Label='Contattato1', HasResponded=true, IsDefault = True, SortOrder=1);	        
            CampaignMemberStatus cms2 = new CampaignMemberStatus(CampaignId=c.ID, Label='Da Contattare2', HasResponded=false, SortOrder=2);
            cms2Insert.add(cms1);
            cms2Insert.add(cms2);
        }
        insert cms2Insert;*/
        System.debug('_______CampaignHandler.afterInsert____DONE');  
    }

    public override void beforeInsert() {
        System.debug('_______CampaignHandler.beforeInsert____START'); 
        
        System.debug('_______CampaignHandler.beforeInsert____DONE');  
    }

    public override void beforeUpdate() {
        System.debug('_______CampaignHandler.beforeUpdate____START');       
        
        for(Campaign campagna:(List<Campaign>)Trigger.New){
            //logica Campagne Outbound
            if(CampaignMemberRecordTypeId == campagna.RecordTypeId ){
                campaignOutbound.checkCampaignIsCompleted(campagna);
            }    
        }
        
        System.debug('_______CampaignHandler.beforeUpdate____DONE'); 
    }

    public override void afterUpdate() {
        System.debug('_______CampaignHandler.afterUpdate____START');       
        Boolean isCampaignOutboud = false;
        for(Campaign campagna:(List<Campaign>)Trigger.New){
            isCampaignOutboud = true;
            //logica Campagne Outbound
            if(CampaignMemberRecordTypeId == campagna.RecordTypeId ){
                campaignOutbound.changeStatusCampaign(campagna);
            }

        }
        if(isCampaignOutboud){
            campaignOutbound.changeStatusCampaignUPDATE();
        }
        

        System.debug('_______CampaignHandler.afterUpdate____DONE'); 
    }

    public override void beforeDelete() {
        System.debug('_______CampaignHandler.beforeDelete____START');       
                
        
        System.debug('_______CampaignHandler.beforeDelete____DONE'); 
    }
}