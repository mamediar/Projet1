trigger SetSemaforoInCampaign on XCS_Script__c (after Insert, after Update) {
    List<XCS_Script__c> scriptOld = trigger.old;
    List<XCS_Script__c> scriptModified = trigger.new;
    List<string> codiceProdottoPadre = new List<String>();
    List<string> codiceProdottoFiglio = new List<String>();
    List<string> codiceProdottoTelemarketing = new List<String>();
    List<string> codiceAzione = new List<String>();
    Set<Id> idprodotti = new Set<Id>();
    Set<Id> idScriptNew = new Set<Id>();
    Boolean controlloSuperato = false;
    Date dataAttuale = Date.today();
    if(trigger.isUpdate){
        System.debug('sono dentro is update del trigger dello script');
        for (XCS_Script__c icampiModif: scriptModified) {
            idScriptNew.add(icampiModif.Id);

            for (XCS_Script__c icampiVecchi: scriptOld) {
                if(icampiModif.Active__c == false && icampiModif.Active__c == icampiVecchi.Active__c){
                    controlloSuperato = false;
                }
                else {
                    controlloSuperato = true;
                }
                if(icampiModif.CodProd__c != icampiVecchi.CodProd__c){
                    codiceProdottoPadre.add(icampiModif.CodProd__c);
                }
                if(icampiModif.CodProdLvl2__c != icampiVecchi.CodProdLvl2__c){
                    codiceProdottoFiglio.add(icampiModif.CodProdLvl2__c);
                }
                
                if(icampiModif.ActionCode__c != icampiVecchi.ActionCode__c){
                    codiceAzione.add(icampiModif.ActionCode__c); 
                }
                if (icampiModif.ActionCodeLvl2__c != icampiVecchi.ActionCodeLvl2__c) {
                    codiceProdottoTelemarketing.add(icampiModif.ActionCodeLvl2__c);
                }
            }
        }
    }
    else if(trigger.isInsert ){
        System.debug('sono dentro is isert del trigger dello script');
        for (XCS_Script__c iCampiCheServono: scriptModified) {
            idScriptNew.add(iCampiCheServono.Id);       
            codiceProdottoPadre.add(iCampiCheServono.CodProd__c);
            codiceProdottoFiglio.add(iCampiCheServono.CodProdLvl2__c);
            codiceProdottoTelemarketing.add(iCampiCheServono.ActionCodeLvl2__c);
            codiceAzione.add(iCampiCheServono.ActionCode__c);    
            
        }
    }
    if(trigger.isInsert && String.isNotEmpty(scriptModified[0].TipoCampagna__c)==true||trigger.isUpdate && String.isNotEmpty(scriptModified[0].TipoCampagna__c)==true){
        List<Product2> prodo = Product2Util.prodottiInCampagneDaAgg(codiceProdottoFiglio, codiceProdottoPadre);
        for (Product2 IdProdo: prodo) {
            idprodotti.add(IdProdo.Id);
        }
        List<Campaign> campagn = campaignUtils.campagneDaAggiornare(idprodotti, codiceProdottoTelemarketing, codiceAzione);
        List<AggregateResult> DateStriptNew = XCSScriptUtil.listScriptForCampaign(idScriptNew);
        if(campagn.size() > 0) {
            System.debug('numero campagne '+campagn.size());
            for(campaign t : campagn) {
                for(AggregateResult dateScript:DateStriptNew){
                    if(Date.valueOf(dateScript.get('startDate')) <= t.StartDate && Date.valueOf(dateScript.get('endDate')) >= t.EndDate ){
                        System.debug('controllo date nel trigger dello script superato');
                        t.FlagScriptAssociati__c = true;}
                }
            }
        }
        System.debug('numero campagne da aggiornare in set semaforo in campaign::::: '+ campagn.size());
        System.debug('script nuovi   in set semaforo in campaign' + scriptModified.size() );
        System.debug('prodotti in set semaforo in campaign  ' + prodo.size());
   
        update campagn;
    
    }

}