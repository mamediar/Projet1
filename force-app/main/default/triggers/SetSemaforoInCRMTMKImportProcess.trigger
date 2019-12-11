trigger SetSemaforoInCRMTMKImportProcess on Campaign (after Insert, before Update) {
    List<Campaign> campOld = trigger.old;
    List<Campaign> campNew = trigger.new;
    set<Id> idcampa = new set<Id>();
    Boolean CC;
    Boolean PP;
    List<Campaign> campinIsUp = new List<Campaign>();
    List<Campaign> campinIsInsert = new List<Campaign>();
    List<Campaign> campaDaAggiornare = new List<Campaign>();
    Set<Id> productId = new Set<Id>();
    List<string> codiceProdottoTelemarketing = new List<String>();
    List<string> codiceAzione = new List<String>();
    List<string> codiceProdottoPadre = new List<String>();
    List<string> codiceProdottoFiglio = new List<String>();
    Set<Id> idImportProcess = new Set<Id>();
    List<Campaign> campaDaProcessare = new List<Campaign>();
    Map<String,Boolean> config = new Map<String,Boolean>();
    Boolean esecuzione = false;
    Boolean flagForDateNull = false;
    boolean isCC = false;
    String recIdCC;
    String recIdPP;
    Set<Id> recId = new Set<Id>();
    List<RecordType> recCamp = [SELECT Id,Name From RecordType where Name = 'CC' or Name = 'PP'];
    for(RecordType g:recCamp){ if(g.Name == 'CC')recIdCC= g.Id; else recIdPP = g.Id;}
    System.debug('esecuzione associazione script');
    
        for(Campaign cam:campNew){
            recId.add(cam.RecordTypeId);
            idImportProcess.add(cam.TMKImportProcess__c);
            System.debug(cam.RecordTypeId);
            if(trigger.isUpdate &&(cam.RecordTypeId == recIdCC || cam.RecordTypeId == recIdPP)){
                System.debug('sono nel primo controllo per update campagne');
                    for(Campaign camOld:campOld){
                        System.debug('start data nuova:: '+cam.StartDate + 'start data vecchia:: '+ camOld.StartDate + ' end data nuova :: '+ cam.EndDate+ ' end data vecchia:: '+ camOld.EndDate);
                        if(   cam.StartDate == camOld.StartDate && cam.EndDate == camOld.EndDate && cam.ProductCode__c == camOld.ProductCode__c){
                            System.debug('non ho superato il controllo?!??!?');
                            
                            
                        }
                        else {
                            System.debug('ho passato il controllo delle date');
                            idcampa.add(cam.id);
                            esecuzione = true;
                        }
                    }    
            }
   
            if(trigger.isInsert &&(cam.RecordTypeId == recIdCC || cam.RecordTypeId == recIdPP)) {
                System.debug('sono nel secondo controllo per per insert');
                    esecuzione = true;
            }
        }

            List<CRMTelemarketingImportProcess__c> filedaAggiornare = campaignUtils.fileCampaign(idImportProcess); 
            System.debug('file '+ filedaAggiornare);
            System.debug(recIdCC +' '+ recIdPP); 
    if(esecuzione == true){
        System.debug('sto eseguento effettivamente il triggerr');
        campaDaAggiornare = [Select StartDate,EndDate,ProductCode__c, TMKProductCode__c, ActionCode__c,TMKTarget__c, RecordTypeId, 
        TMKImportProcess__c, FlagScriptAssociati__c From Campaign where id in:idcampa ];
    
        for(Campaign c:campaDaAggiornare ){
        productId.add(c.ProductCode__c);
        codiceProdottoTelemarketing.add(c.TMKProductCode__c);
        
        if(c.RecordTypeId == recIdPP){codiceAzione.add(c.ActionCode__c);}else {codiceAzione.add(c.TMKTarget__c);}         
        
        }
        List<Product2> prod = Product2Util.prodForCampaign(productId);
        for(Product2 p: prod){
            codiceProdottoPadre.add(p.Parent__r.RSS_External_Id__c);
            codiceProdottoFiglio.add(p.RSS_External_Id__c);
        }
        List<AggregateResult> scriptAssociati = XCSScriptUtil.listScriptInCampaign(codiceProdottoFiglio,codiceAzione,codiceProdottoTelemarketing,recId);
        List<XCS_Script__c> secondCtrl = XCSScriptUtil.listScriptForSecondCtrl(codiceProdottoFiglio, codiceAzione, codiceProdottoTelemarketing, recId);
        for(AggregateResult d:scriptAssociati ){
            if(Date.valueOf(d.get('startDate'))!= null && Date.valueOf(d.get('endDate')) != null)
            flagForDateNull = true;
        }
        System.debug('vediamo se questo controllo vale:: '+ flagForDateNull +' ');
        if(flagForDateNull){
            System.debug('flag nel file');
                for(Campaign daAggiornare: campNew){
                    if(trigger.isUpdate){
                        for(AggregateResult datescript:scriptAssociati){
                            if(Date.valueOf(datescript.get('startDate')) <= daAggiornare.StartDate && Date.valueOf(datescript.get('endDate')) >= daAggiornare.EndDate){
                                system.debug('ho passato il controllo min e max?');
                                for(XCS_Script__c ctrl:secondCtrl){
                                    if(String.isNotBlank(ctrl.ActionCodeLvl2__c)){
                                        system.debug('sono nel is not blank det tmkcode?');
                                          
                                        if(ctrl.ActionCode__c == daAggiornare.ActionCode__c && 
                                           ctrl.ActionCodeLvl2__c == daAggiornare.TMKProductCode__c && 
                                           codiceProdottoFiglio.contains(ctrl.CodProdLvl2__c) && ctrl.StartDate__c <= daAggiornare.StartDate && ctrl.EndDate__c >= daAggiornare.EndDate ){
                                               campinIsUp.add(daAggiornare);
                                                system.debug('quante campagne sono '+campinIsUp.size());
                                               daAggiornare.FlagScriptAssociati__c = true;
                                           }
                                        
                                        
                                    }
                                    else{if(ctrl.ActionCode__c == daAggiornare.TMKTarget__c &&  
                                           codiceProdottoFiglio.contains(ctrl.CodProdLvl2__c) && ctrl.StartDate__c <= daAggiornare.StartDate && ctrl.EndDate__c >= daAggiornare.EndDate)
                                        system.debug('sono nel is blank det tmkcode?');
                                        daAggiornare.FlagScriptAssociati__c = true;
                                        
                                    }
                                }
                                    

                            }
                            else{
                                
                                daAggiornare.FlagScriptAssociati__c = false;
                                    campinIsUp.add(daAggiornare);
                            }
                        }
                        
                    }
                    
                  
                        
                    
                    else {
                        for(AggregateResult datescript:scriptAssociati){
                            if(Date.valueOf(datescript.get('startDate')) <= daAggiornare.StartDate && Date.valueOf(datescript.get('endDate')) >= daAggiornare.EndDate){
                               for(XCS_Script__c ctrl:secondCtrl){
                                    if(String.isNotBlank(ctrl.ActionCodeLvl2__c)){
                                        system.debug('sono nel is not blank det tmkcode?');
                                          
                                        if(ctrl.ActionCode__c == daAggiornare.ActionCode__c && 
                                           ctrl.ActionCodeLvl2__c == daAggiornare.TMKProductCode__c && 
                                           codiceProdottoFiglio.contains(ctrl.CodProdLvl2__c) && ctrl.StartDate__c <= daAggiornare.StartDate && ctrl.EndDate__c >= daAggiornare.EndDate){
                                             
                                               daAggiornare.FlagScriptAssociati__c = true;
                                           }
                                        
                                        
                                    }
                                    else{if(ctrl.ActionCode__c == daAggiornare.TMKTarget__c &&  
                                           codiceProdottoFiglio.contains(ctrl.CodProdLvl2__c) && ctrl.StartDate__c <= daAggiornare.StartDate && ctrl.EndDate__c >= daAggiornare.EndDate)
                                        system.debug('sono nel is blank det tmkcode?');
                                        daAggiornare.FlagScriptAssociati__c = true;
                                        
                                    }
                                }
                            }
                            else {
                                daAggiornare.FlagScriptAssociati__c = false;
                                campinIsInsert.add(daAggiornare);
                            }
                        }
                    }
                }
            
           
        }
        else {
            System.debug('sono nell else degli script < 1');
            for(Campaign daAggiornare: campaDaAggiornare){
             daAggiornare.FlagScriptAssociati__c = false;
            
            }
            
        }
    
        System.debug('campagna aggiornata '+campaDaAggiornare);
        System.debug('file da agg in set semaforo CRMTMK ' + filedaAggiornare);
        System.debug('Mappa in set semaforo CRMTMK di config ' + config);
    
    }
    
}