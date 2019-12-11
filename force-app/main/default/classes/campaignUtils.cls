public class campaignUtils {
    
    public static List<Campaign> campaignlist(set<Id> idCampaignModified){
        return [SELECT Id, StartDate, EndDate, TMKImportProcess__c, 
    									Channel__c, TMKProductCode__c, CodOutsourcer__c, RecordType.Name, CodPromotion__c FROM Campaign where TMKImportProcess__c in : idCampaignModified ];
    
    }
    static final string inseritaKo = 'NOT READY';
    public static List<CRMTelemarketingImportProcess__c> fileCampaign(Set<Id> idFileInCampaignUpdated){
        
        return [SELECT id , (select TMKImportProcess__r.filename__c from Campaigns__r), isAllCampaignHaveScript__c, FileName__c,ErrorDescription__c, Status__c FROM CRMTelemarketingImportProcess__c where id in: idFileInCampaignUpdated ];
    }
    public static List<CRMTelemarketingImportProcess__c> fileCampaigne(Set<Id> idFileInCampaignUpdated){
        
        return [SELECT id , (select TMKImportProcess__r.filename__c from Campaigns__r), isAllCampaignHaveScript__c, FileName__c,ErrorDescription__c, Status__c FROM CRMTelemarketingImportProcess__c where id in: idFileInCampaignUpdated and Status__c =: inseritaKo ];
    }
    public static CRMTelemarketingImportProcess__c fileCampaign(){
        
        return [SELECT id FROM CRMTelemarketingImportProcess__c where Status__c =: inseritaKo ];
    }
    public static List<Map<String,String>> listScriptInTable(Id ProdId, String actionCode,String codTMK, String tipoCamp){
        Product2 prodottoCampaign = Product2Util.prodForCampaign(ProdId); 
        System.debug(prodottoCampaign.RSS_External_Id__c +' '+prodottoCampaign.Parent__r.RSS_External_Id__c + ' '+ actionCode+' '+ codTMK+' '+ prodottoCampaign.Name);
        return XCSScriptUtil.listScriptForCampaign(prodottoCampaign.RSS_External_Id__c,prodottoCampaign.Parent__r.RSS_External_Id__c, actionCode, codTMK, prodottoCampaign.Name, tipoCamp );  
    }
    public static List<AggregateResult> campaignForUpdateImportProcess(Set<Id> idFileInCampaignUpdated){
        return [select flagscriptassociati__c, tmkimportprocess__r.filename__c filename , count(id) cnt from campaign where tmkimportprocess__c in: idFileInCampaignUpdated group by flagscriptassociati__c, tmkimportprocess__r.filename__c order by 
                tmkimportprocess__r.filename__c, flagscriptassociati__c desc];
    }
    public static List<Campaign> campagneDaAggiornare(Set<Id> idprodotti, List<String> codiceProdottoTelemarketing, List<String> codiceAzione){
        System.debug(idprodotti+ ' '+codiceProdottoTelemarketing+ ' '+ codiceAzione);
        List<Campaign> listAll = new List<Campaign>();
        List<Campaign> listPP = [SELECT StartDate,EndDate,TMKProductCode__c,ActionCode__c, ProductCode__c, FlagScriptAssociati__c, TMKImportProcess__c FROM Campaign 
                                where ProductCode__c in: idprodotti and TMKProductCode__c in:codiceProdottoTelemarketing 
                                and ActionCode__c in: codiceAzione ];

        List<Campaign> listCC = [SELECT StartDate,EndDate,TMKProductCode__c,ActionCode__c, ProductCode__c, FlagScriptAssociati__c, TMKImportProcess__c FROM Campaign 
                                where ProductCode__c in: idprodotti 
                                and TMKTarget__c in: codiceAzione];
            for(Campaign PP:listPP){
                listAll.add(PP);
            }
            for(Campaign CC:listCC){
                listAll.add(CC);
            }
            return listAll;
    }

    public static void setSonsStatus(Set<Id>campaignFather,String status) {
        System.debug('______CampaignUtils.setSonsStatus____START');
        List<Campaign> campaignToUpdate = new List<Campaign>();
        for(Campaign campaign : [SELECT ID FROM Campaign   
                            WHERE Campaign.ParentId in :campaignFather]){
            campaign.Status = status;
            campaignToUpdate.add(campaign);
            }
        update campaignToUpdate; 
        System.debug('______CampaignUtils.setSonsStatus____DONE');
    }

    public static void isAllCampaignCompleted (Set<Id>campaignFather){
        System.debug('______CampaignUtils.isAllCampaignCompleted____START');
        List<Campaign> campaignToUpdate = new List<Campaign>();

        for(Campaign c : [SELECT ID, HierarchyNumberOfContacts, HierarchyNumberOfResponses 
                                        FROM Campaign 
                                        WHERE ID in :campaignFather]){
            if(c.HierarchyNumberOfContacts == c.HierarchyNumberOfResponses){
                c.Status = 'Completed';
                c.EndDate = System.today();
                c.IsActive = false;
                campaignToUpdate.add(c);
            }
        }
        update campaignToUpdate;
        System.debug('______CampaignUtils.isAllCampaignCompleted____DONE');
    }

    public static void setSonsStatusAborted(Set<Id>campaignFather) {
        System.debug('______CampaignUtils.setSonsStatusAborted____START');
        System.debug('campaignFather:'+campaignFather);
        List<Campaign> campaignToUpdate = new List<Campaign>();
        for(Campaign campaign : [SELECT ID FROM Campaign   
                            WHERE Campaign.ParentId in :campaignFather AND Status != 'Completed']){
            campaign.Status = 'Aborted';
            campaign.IsActive = false;
            campaign.EndDate = System.today();
            campaignToUpdate.add(campaign);
            }
        update campaignToUpdate; 
        System.debug('______CampaignUtils.setSonsStatusAborted____DONE');
    }
}