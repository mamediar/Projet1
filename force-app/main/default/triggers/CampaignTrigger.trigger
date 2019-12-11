trigger CampaignTrigger on Campaign (before insert,                 
                                     after insert,                                       
                                     before update, 
                                     after update, 
                                     before delete, 
                                     after delete, 
                                     after undelete) {
    System.debug('______CampaignTrigger____START');
    new CampaignHandler().run();
    System.debug('______CampaignTrigger____DONE');
}