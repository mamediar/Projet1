trigger updateDateInCampaignFromTMKImportProcess on CRMTelemarketingImportProcess__c (after update) {
    List<CRMTelemarketingImportProcess__c> fileOld = trigger.old;
    List<CRMTelemarketingImportProcess__c> fileModif = trigger.new;
    Set<Id> idfileTMK = new Set<Id>();
    Date startDateNew;
    Date endDateNew;
    Date startDateOld;
    Date endDateOld;
    for(CRMTelemarketingImportProcess__c a: fileModif){
        idfileTMK.add(a.Id);
        startDateNew = a.StartDate__c;
        endDateNew = a.EndDate__c;
    }
    for(CRMTelemarketingImportProcess__c b:fileOld){
        startDateOld = b.StartDate__c;
        endDateOld = b.EndDate__c;
    }
    List<Campaign> campaignAssociated = campaignUtils.campaignlist(idfileTMK);
    System.debug('sono nel trigger di aggiornamento date dal file alle campange');
    if(startDateNew != startDateOld || endDateNew != endDateOld){
        System.debug('ho superato il controllo delle date nel trigger di aggiornamento date dal file alle campagne');
        for(Campaign campUpdate : campaignAssociated){
            campUpdate.StartDate = startDateNew;
            campUpdate.EndDate = endDateNew;
        }
        update campaignAssociated;
        
    }
    

}