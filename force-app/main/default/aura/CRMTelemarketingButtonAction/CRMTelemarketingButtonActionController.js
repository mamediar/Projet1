({
    init : function(cmp,event,helper){
        let ilcase = cmp.get('v.CaseRecord');
        console.log(ilcase.ActivityType__c)
        let changeType = event.getParams().changeType;
        if(changeType === 'ERROR'){
            console.log('oh noo');
            }
        switch(changeType){
                case 'LOADED':    
                cmp.set('v.activiti', ilcase.ActivityType__c == 'TMKPP');
                    break;
        }
        
    },
    
    AttviazioneCarta : function(cmp, event, helper) {
        let comEDI;
        let caso = cmp.get('v.CaseRecord');
        caso.CampaignId__r.CodPromotion__c == 'EDI0C'? comEDI = 0: comEDI=1;
        let evento = $A.get("e.c:eventTelemarketingForPV");
        evento.setParams({'TabSel':'esitaChiamata'});
        evento.setParams({'dispPresel1': 'DP1200'});
        evento.setParams({'dispPresel2':'DP1201'});
        evento.setParams({'dispPresel3':'DP1203'});
        evento.setParams({'checkboxAttribute':'nonDisponibile'});
        evento.fire();
        let mappa = {};
        mappa.codCategoria ="3481"
        mappa.codPraticaOCS = caso.NumeroPratica__c
        mappa.commissioneEDI0C = comEDI
        mappa.codClienteOCS =  caso.Account.getCodice_Cliente__c
        cmp.set('v.parametriEsterni',mappa);
        let objPV = cmp.get('v.parametriEsterni');
        var urlEvent = $A.get("e.force:navigateToComponent");
                 urlEvent.setParams({
                    componentDef: "c:CRMTelemarketingPVWrapper",
                    componentAttributes : {
                      
                        caseId : cmp.get('v.recordId'),
                        parametriEsterni : objPV
                    }
                 
                });
               urlEvent.fire();	
       
	},
    FissAppuntamento : function(cmp, event, helper) {
        let comEDI;
        let caso = cmp.get('v.CaseRecord');
        caso.CampaignId__r.CodPromotion__c == 'EDI0C'? comEDI = 0: comEDI=1;
        let evento = $A.get("e.c:eventTelemarketingForPV");
        evento.setParams({'TabSel':'esitaChiamata'});
        let dispPresel1;
        let dispPresel2;
        caso.ActivityType__c == 'TMKPP' ? 
            (dispPresel1 = 'DP1179', dispPresel2 = 'DP1180' ):  (dispPresel1 = 'DP1161',dispPresel2 = 'DP2346' )? 
            caso.CampaignId__r.ActionCode__c == 'CQS' : (dispPresel1 = 'DP1228',dispPresel2 = 'DP1229');
        evento.setParams({'dispPresel1': dispPresel1});
        evento.setParams({'dispPresel2':dispPresel2});
        
        evento.setParams({'checkboxAttribute':'FissaApp'});
        evento.fire();
        let mappa = {};
        mappa.codCategoria ="3256"
        mappa.codPraticaOCS = caso.NumeroPratica__c
        mappa.commissioneEDI0C = comEDI
        mappa.codClienteOCS =  caso.Account.getCodice_Cliente__c
       
        cmp.set('v.parametriEsterni',mappa);
        let objPV = cmp.get('v.parametriEsterni');
      
        var urlEvent = $A.get("e.force:navigateToComponent");
                 urlEvent.setParams({
                    componentDef: "c:creaAppuntamento",
                    componentAttributes : {
                   
                        caseId : cmp.get('v.recordId'),
                        
                       
                    }
                 
                });

               urlEvent.fire();
	},
    RimoPri : function(cmp, event, helper) {
        let comEDI;
        let caso = cmp.get('v.CaseRecord');
        caso.CampaignId__r.CodPromotion__c == 'EDI0C'? comEDI = 0: comEDI=1;
        let evento = $A.get("e.c:eventTelemarketingForPV");
        evento.setParams({'TabSel':'esitaChiamata'});
        evento.setParams({'dispPresel1': 'DP1200'});
        evento.setParams({'dispPresel2':'DP1205'});
        evento.setParams({'dispPresel3':'DP1211'});
        evento.fire();
        let mappa = {};
        mappa.codCategoria ="1762"
        mappa.codPraticaOCS = caso.NumeroPratica__c
        mappa.commissioneEDI0C = comEDI
        mappa.codClienteOCS =  caso.Account.getCodice_Cliente__c
        console.log('la mappa',mappa);
        cmp.set('v.parametriEsterni',mappa);
        let objPV = cmp.get('v.parametriEsterni');
       console.log(JSON.stringify(objPV))
        var urlEvent = $A.get("e.force:navigateToComponent");
                 urlEvent.setParams({
                    componentDef: "c:CRMTelemarketingPVWrapper",
                    componentAttributes : {
                      
                        caseId : cmp.get('v.recordId'),
                        parametriEsterni : objPV
                    }
                 
                });

               urlEvent.fire();
        //$A.get("e.force:refreshView").fire();
        
	},
    EDI : function(cmp, event, helper) {
        let comEDI;
        let caso = cmp.get('v.CaseRecord');
        caso.CampaignId__r.CodPromotion__c == 'EDI0C'? comEDI = 0: comEDI=1;
        let evento = $A.get("e.c:eventTelemarketingForPV");
        evento.setParams({'TabSel':'esitaChiamata'});
        evento.setParams({'dispPresel1': 'DP1200'});
        evento.setParams({'dispPresel2':'DP1201'});
        evento.setParams({'dispPresel3':'DP1204'});
        evento.setParams({'checkboxAttribute':'nonRichiamare'});
        evento.fire();
        let mappa = {};
        mappa.codCategoria ="3256"
        mappa.codPraticaOCS = caso.NumeroPratica__c
        mappa.commissioneEDI0C = comEDI
        mappa.codClienteOCS =  caso.Account.getCodice_Cliente__c
      
        cmp.set('v.parametriEsterni',mappa);
        let objPV = cmp.get('v.parametriEsterni');
        var urlEvent = $A.get("e.force:navigateToComponent");
                 urlEvent.setParams({
                    componentDef: "c:CRMTelemarketingPVWrapper",
                    componentAttributes : {
                      
                        caseId : cmp.get('v.recordId'),
                        parametriEsterni : objPV
                    }
                 
                });
               urlEvent.fire();	
	},
    hideButton: function(cmp,event, helper){
        let activity = event.getParam('activity');
        let param = event.getParam('statoCarta');
        let bool = param !='' && param != 'BLOCCATA' && param != 'DA ATTIVARE';
        let bool2 = param !='' && param != 'BLOCCATA' && param != 'RESPINTA' && param != 'ATTIVATA' && param != 'UTILIZZATA' && param != 'RESPINTA' && param != 'ESAURITA';
        console.log(bool, bool2)
        let disp = event.getParam('disp');
        console.log(disp, param, activity)
        cmp.set('v.attCarta',bool2);
        cmp.set('v.visibleEDI',disp != ''&&disp > 300 && bool == true)
        
       
    }
    
   
})