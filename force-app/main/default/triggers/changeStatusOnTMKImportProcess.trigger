trigger changeStatusOnTMKImportProcess on Campaign (after update) {
    
    static final string errorForDateBlank = 'Date di Inizio e Fine Campagna da definire';
    static final string errorForProdCodBlank = 'Codice Prodotto da associare';
    static final string errorForCodPromBlank = 'Codice promozione da associare';
    static final string changeStatus = 'READY';
    Boolean booleano = false;
    List<Campaign> campaignOld = trigger.old;
    List<Campaign> campaignModified = Trigger.new;
    Set<Id> idTMKProc = new Set<Id>();
    Set<Id> idTelemarketing = new Set<Id>();
    Map<String,Boolean> config = new Map<String,Boolean>();
    for(Campaign campi:campaignModified){idTelemarketing.add(campi.TMKImportProcess__c);}
    List<CRMTelemarketingImportProcess__c> filedaAggiornare = campaignUtils.fileCampaign(idTelemarketing);
    List<AggregateResult> listDiConfig = campaignUtils.campaignForUpdateImportProcess(idTelemarketing);
    List<CRMTelemarketingImportProcess__c> filedaAggiornareInElse = campaignUtils.fileCampaign(idTelemarketing);
    List<AggregateResult> listDiConfigInElse = campaignUtils.campaignForUpdateImportProcess(idTelemarketing);
    for(Campaign CampiNew: campaignModified){
        
            for (Campaign CampiOld: campaignOld) {
                if (CampiOld.StartDate == null && CampiNew.StartDate != null  ||CampiOld.EndDate == null &&  CampiNew.EndDate != null){
                    system.debug('vediamo se entra o non entra nel controllo di change status delle date');
                   booleano = true;
                }
                if(String.isBlank(CampiNew.TMKProductCode__c)){
                    booleano = true;
                }
                if(CampiNew.RecordType.Name == 'CC'){
                    if(CampiNew.CodPromotion__c != null){
                        booleano = true;
                    }
                }
                
                if(!CampiNew.FlagScriptAssociati__c){
                    
                        for(AggregateResult controllCheck: listDiConfig ){
                            config.put(String.valueOf(controllCheck.get('filename')), 
                            boolean.valueOf(controllCheck.get('flagscriptassociati__c')));
                        }    
                        for(CRMTelemarketingImportProcess__c CampiDelFiledaAgg : filedaAggiornare) {
                            System.debug('flag nel file nel primo controllo'+config.get(CampiDelFiledaAgg.FileName__c));
                            CampiDelFiledaAgg.isAllCampaignHaveScript__c = config.get(CampiDelFiledaAgg.FileName__c);
                        }
                    
                        
                }
                else{
                    
                        for(AggregateResult controllCheck: listDiConfigInElse ){
                            config.put(String.valueOf(controllCheck.get('filename')), 
                            boolean.valueOf(controllCheck.get('flagscriptassociati__c')));
                        }    
                        for(CRMTelemarketingImportProcess__c CampiDelFiledaAgg : filedaAggiornare) {
                            System.debug('flag nel file nell else'+config.get(CampiDelFiledaAgg.FileName__c));
                            CampiDelFiledaAgg.isAllCampaignHaveScript__c = config.get(CampiDelFiledaAgg.FileName__c);
                        }
                        
                        
                }
            }
    }
    update filedaAggiornare;
    if(booleano == true){
    
    
    List<CRMTelemarketingImportProcess__c> fileCampaign = campaignUtils.fileCampaigne(idTelemarketing);
    for(CRMTelemarketingImportProcess__c f:fileCampaign){ idTMKProc.add(f.Id);}
    List<Campaign> campaignAssociated = campaignUtils.campaignlist(idTMKProc);

    String errorMessage;
    
            for(Campaign i:campaignAssociated) {
                if (i.StartDate == null || i.EndDate == null) {
                    errorMessage = errorForDateBlank;
                    break;
                }
                if (string.isBlank(i.TMKProductCode__c)) {
                    errorMessage = errorForProdCodBlank;
                    break;
                }
                if(i.RecordType.Name == 'CC'){
                    if(i.CodPromotion__c == null){
                        errorMessage = errorForCodPromBlank;
                    }
                    break;
                }
            }
    
    for(CRMTelemarketingImportProcess__c d:fileCampaign){
        if (errorMessage == null) {
            d.Status__c = changeStatus;
            d.ErrorDescription__c = '';
        }
        else {
            d.ErrorDescription__c = errorMessage;
        }
    }
    
    System.debug('file da agg in change status  ' + fileCampaign.size());
    System.debug('campagne associate ' + campaignAssociated.size());
    
        update fileCampaign;
    }
    
}