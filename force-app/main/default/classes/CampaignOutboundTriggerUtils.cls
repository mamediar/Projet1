public without sharing class CampaignOutboundTriggerUtils {
    Set<ID> campagnePadriInProgress = new Set<ID>();
    Set<ID> campagnePadriCompleted = new Set<ID>();
    Set<ID> campagnePadriAborted = new Set<ID>();
    public void checkCampaignIsCompleted (Campaign campagna){
        System.debug('_______CampaignOutboundTriggerUtils.checkCampaignIsCompleted____START'); 
        System.debug('campagna.HierarchyNumberOfContacts:'+campagna.HierarchyNumberOfContacts);
        System.debug('campagna.HierarchyNumberOfResponses:'+campagna.HierarchyNumberOfResponses);
        
        if(campagna.HierarchyNumberOfContacts>0 && campagna.HierarchyNumberOfContacts == campagna.HierarchyNumberOfResponses){
            campagna.Status = 'Completed';  
            campagna.EndDate = System.today();            
        }
        System.debug('_______CampaignOutboundTriggerUtils.checkCampaignIsCompleted____DONE');
    }

    public void changeStatusCampaign (Campaign campagna){
        System.debug('_______CampaignOutboundTriggerUtils.changeStatusCampaign____START');
        System.debug('campagnaNew.Status:'+campagna.status);
            System.debug('campagnaOld.Status:'+((Campaign)Trigger.oldMap.get(campagna.Id)).Status);
            //quando il WF time-dependent "Campagne Outbound Attivazione" attiva la campagna padre, tutte le campagne figlie vengono attivate
            if(campagna != null && campagna.Status!=null && campagna.ParentId==null && !campagna.status.equals(((Campaign)Trigger.oldMap.get(campagna.Id)).Status) && campagna.status=='In Progress'){
                System.debug('Modifico campagne figlie per la campagna:'+campagna.Id);
                campagnePadriInProgress.add(campagna.Id);
            } else {
                //quando una campagna figlia passa in completed, controllo se tutte le campagne figlie sono completed, allora porta in completata la campagna Padre
                if(campagna != null && String.isNotBlank(campagna.Status) && campagna.ParentId!=null && !campagna.status.equals(((Campaign)Trigger.oldMap.get(campagna.Id)).Status) && campagna.status=='Completed'){
                    System.debug('Modifico campagne figlie per la campagna:'+campagna.Id);
                    campagnePadriCompleted.add(campagna.ParentId);
                } else {
                    //quando una campagna padre viene portata a terminata tramite WF time-dependent "Campagne Outbound Disattivazione", aggiorno tutte le campagne figlie aperto in terminato
                    if(campagna != null && String.isNotBlank(campagna.Status) && campagna.ParentId==null && !campagna.status.equals(((Campaign)Trigger.oldMap.get(campagna.Id)).Status) && campagna.status=='Aborted'){
                        System.debug('Modifico campagne figlie per la campagna:'+campagna.Id);
                        campagnePadriAborted.add(campagna.Id);
                    }   
                }
            }
        System.debug('_______CampaignOutboundTriggerUtils.changeStatusCampaign____DONE');
    }

    public void changeStatusCampaignUPDATE (){
        System.debug('_______CampaignOutboundTriggerUtils.changeStatusCampaignUPDATE____START');
        if(campagnePadriInProgress.size()>0){
            CampaignUtils.setSonsStatus(campagnePadriInProgress,'In Progress');
        }

        if(campagnePadriCompleted.size()>0){
            CampaignUtils.isAllCampaignCompleted(campagnePadriCompleted);
        }
        
        if(campagnePadriAborted.size()>0){
            CampaignUtils.setSonsStatusAborted(campagnePadriAborted);
        }
        System.debug('_______CampaignOutboundTriggerUtils.changeStatusCampaignUPDATE____DONE');
    }
}