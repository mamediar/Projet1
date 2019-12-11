public without sharing class CampaignOutboundShareBuilder {
    @InvocableMethod
    public static void shareCampaign (List<Id> sonsCampaign){
        System.debug('PROCESSBUILDER_______CampaignOutboundShareBuilder.shareCampaign____START');
        System.debug('sonsCampaign:'+sonsCampaign);
        //mappa che contiene il codice delle filiali, es. <F222,Account>
        Map<String,Account> mapFilialiByCode = new Map<String,Account>();
        //Mappa che contiene come chiave il nome del ruolo e come valore la campagna a cui sharare
        Map<String,String> roleToShareCampaign = new Map<String,String>();
        //Set di tutte le campagne Padre, devono essere sharate a tutti
        Set<Id> controllingCampaign = new Set<Id>();
        //Le campagne da aggiornare
        List<Campaign> campaignToUpdate = new List<Campaign>();
        //recupero tutte le campagne che possono essere associate ad un ruolo
        List<Campaign> campagne = [SELECT ID,NomeFiliale__c,Name,CodOutsourcer__c,ParentId FROM Campaign
                                    WHERE ID in :sonsCampaign AND CodOutsourcer__c != NULL];
        
        if(campagne!=null && campagne.size()>0){
            System.debug('campagne in lavorazione:'+campagne);
            //ricerca di tutte le filiali associabili
            List<Account> filiali = [select id,RecordType.name,name,OCS_External_Id__c,NameRoleReference__c 
                                        FROM ACCOUNT 
                                            WHERE RecordType.name='Branch' AND OCS_External_Id__c!=NULL AND NameRoleReference__c!=NULL];
            
            for(Account filiale : filiali){
                mapFilialiByCode.put(filiale.OCS_External_Id__c,filiale);
            }

            for(Campaign campagna : campagne){
                if(String.isNotblank(campagna.CodOutsourcer__c)){
                String codiceFiliale = 'F'+Integer.valueOf(campagna.CodOutsourcer__c);
                System.debug('cerco codice filiale:'+codiceFiliale);
                Account filiale = mapFilialiByCode.get(codiceFiliale);
                if(filiale!=null){
                    roleToShareCampaign.put(filiale.NameRoleReference__c.toLowerCase(),campagna.ID);
                    controllingCampaign.add(campagna.ParentId);
                    String nomeFiliale = filiale.Name;
                    campagna.Filiale__c = filiale.Id;
                    campagna.NomeFiliale__c = nomeFiliale;
                    campagna.Name = (campagna.Name+'-'+nomeFiliale).abbreviate(80);
                    campagna.IsActive = true;
                    campaignToUpdate.add(campagna);
                }
                }
            }

        }
        update campaignToUpdate;

        if(roleToShareCampaign!= null && roleToShareCampaign.size()>0 ){
            futureShareCampaign(roleToShareCampaign,controllingCampaign);
        }
        System.debug('PROCESSBUILDER_______CampaignOutboundShareBuilder.shareCampaign____DONE');
    }

    @future
    public static void futureShareCampaign(Map<String,String> roleToShareCampaign,Set<ID> controllingCampaign){
        System.debug('PROCESSBUILDER_______CampaignOutboundShareBuilder.futureShareCampaign____START');
        Map<String,ID> roleNameToId = new Map<String,ID>();
        List<CampaignShare> campaignShareToInsert = new List<CampaignShare>();
        /******************************* SHARE CAMPAGNE FIGLIE PER FILIALE ***********************************/
        List<Group> userRoleList = [select id,DeveloperName,Type FROM GROUP 
                                            WHERE type = 'Role' AND DeveloperName in :roleToShareCampaign.keySet()];
        if(userRoleList!=null && userRoleList.size()>0){
            for(Group role : userRoleList){
                roleNameToId.put(role.DeveloperName.toLowerCase(),role.Id);
            }
        }

        for(String role : roleToShareCampaign.keySet()){
            String roleId = roleNameToId.get(role);
            String idCampaign = roleToShareCampaign.get(role);
            System.debug('share per il ruolo -->'+role+'-->'+roleNameToId.get(role)+' del record -->'+roleToShareCampaign.get(role));
            if(roleId!=null && idCampaign!=null){
                CampaignShare share = new CampaignShare();
                share.CampaignId = idCampaign;
                share.CampaignAccessLevel = 'Edit';
                share.UserOrGroupId = roleId;
                campaignShareToInsert.add(share);
            }
            
        }
        /******************************* SHARE CAMPAGNE PADRI A TUTTE LE FILIALI ***********************************/
        List<Group> groupList = [select id,DeveloperName,Type FROM GROUP 
                                            WHERE DeveloperName = 'Filiali'];
        if(groupList!=null && groupList.size()>0){
            for(Id campaignId : controllingCampaign){
                CampaignShare share = new CampaignShare();
                share.CampaignId = campaignId;
                share.CampaignAccessLevel = 'Read';
                share.UserOrGroupId = groupList[0].ID;
                campaignShareToInsert.add(share);
            }
        }

        System.debug('campaignShareToInsert-->'+campaignShareToInsert);
        if(campaignShareToInsert!=null && campaignShareToInsert.size()>0){
            insert campaignShareToInsert;
        }

        System.debug('PROCESSBUILDER_______CampaignOutboundShareBuilder.futureShareCampaign____DONE');
    }
}