({
    handleChange: function (cmp, event, helper) {
        let selezione = event.getParam('value');
        const opzione1 = 'option1';
        const opzione2 = 'option2';
        const opzione3 = 'option3';
        const opzione4 = 'option4';
        let param1;
        let param2;
        let param3;
        let param4;
        let param5;
        let param6;
        let param7;
        let prod = cmp.get('v.Prod');
        let Nome = cmp.get('v.Nome');
        let dispScript = cmp.get('v.dispMa');
        let dispSA = cmp.get('v.dispSascript');
        let fido = cmp.get('v.fido');
        let fidoSA = cmp.get('v.fidoSAscript');
        let fidoPR = cmp.get('v.fidoPRscript');
        cmp.set('v.uscript',selezione == opzione1);
        cmp.set('v.showPreScript', selezione == opzione1);
        let obj = cmp.get('v.CaseRecord');
        let actioncode;
        obj.ActivityType__c == 'TMKCC'? actioncode = obj.CampaignId__r.TMKTarget__c:actioncode= obj.CampaignId__r.ActionCode__c;
        let campone = obj.ScriptParameters__c;
        let boolcampone = campone != null;
        console.log(boolcampone, campone )
        if(boolcampone){
        let arr = campone.split(";");
        param1 = arr[0]
        param2 = arr[1]
        param3 = arr[2]
        param4 = arr[3]
        param5 = arr[4]
        param6 = arr[5]
        param7 = arr[6]}
        if(selezione == opzione1){
           
            let action = cmp.get('c.Script');
            action.setParams({'option':opzione1, 'campa': obj.CampaignId__r.ProductCode__c, 
                                'actioncode': actioncode, 
                              'codTMK': obj.CampaignId__r.TMKProductCode__c, 'startDate':obj.CampaignId__r.StartDate, 'endDate': obj.CampaignId__r.EndDate,'tipoCamp': obj.ActivityType__c });
            action.setCallback(this, function(response) { 
                let state = response.getState();
                console.log('stato in script chiamata ',state, obj.CampaignId__r.ProductCode__c,actioncode, obj.CampaignId__r.TMKProductCode__c,obj.CampaignId__r.StartDate, obj.CampaignId__r.EndDate );
                if (state == 'SUCCESS') {
                    let results = response.getReturnValue();
                    let forname = results.replace("NOME/COGNOME", Nome);
                    let forprod = forname.replace("#PROD#", prod );
                    let forDisp = forprod.replace('#DISP#', dispScript);
                    let forDispSa = forDisp.replace('#DISP_SA#', dispSA);
                    let forfido = forDispSa.replace('#FIDO#', fido);
                    let forfidoSa = forfido.replace('#FIDO_SA#', fidoSA);
                    let forfidoPR = forfidoSa.replace('#FIDO_PR#', fidoPR);
                    
                    if(boolcampone){
                        
                    let forParam1 = forfidoPR.replace('[parametro1]',param1);
                    let forParam2 = forParam1.replace('[parametro2]',param2);
                    let forParam3 = forParam2.replace('[parametro3]',param3);
                    let forParam4 = forParam3.replace('[parametro4]',param4);
                    let forParam5 = forParam4.replace('[parametro5]',param5);
                    let forParam6 = forParam5.replace('[parametro6]',param6);
                    let forParam7 = forParam6.replace('[parametro7]',param7);
                     
                    cmp.set('v.uscript', true);
                    cmp.set('v.script',forParam7);
                }
                    else {cmp.set('v.uscript', true); cmp.set('v.script',forfidoPR);}
                    
                   
                }
            });
            $A.enqueueAction(action);
            helper.prescript(cmp);
             
            
               
        }
       
        if(obj.ActivityType__c == 'TMKCC'){
                
                if(selezione==opzione2){ cmp.set('v.checkboxAttribute', 'nonDisponibile');cmp.set('v.idTab', "esitaChiamata");cmp.set('v.rifiutaChiamata',false);cmp.set('v.dispPresel1', 'DP1200');cmp.set('v.dispPresel2', 'DP1216'); cmp.set('v.dispPresel3','DP1528')}
                if(selezione==opzione3){cmp.set('v.checkboxAttribute', 'nonRichiamare');cmp.set('v.idTab', "esitaChiamata");cmp.set('v.rifiutaChiamata',false);cmp.set('v.dispPresel1', 'DP1200');cmp.set('v.dispPresel2', 'DP1216');cmp.set('v.dispPresel3','DP1222')}
            	if(selezione==opzione4){cmp.set('v.checkboxAttribute', 'rifiutaChiamata');cmp.set('v.rifiutaChiamata',true); cmp.set('v.idTab', "esitaChiamata");  cmp.set('v.dispPresel1','DP1228');cmp.set('v.dispPresel2', 'DP1243'); } 
 
        } 
        if(obj.ActivityType__c == 'TMKPP'){    
                if(selezione==opzione2){cmp.set('v.dispPresel1','DP1179');cmp.set('v.rifiutaChiamata',false);cmp.set('v.checkboxAttribute', 'nonDisponibile');cmp.set('v.idTab', "esitaChiamata");cmp.set('v.dispPresel2','DP1188');}
                if(selezione==opzione3){cmp.set('v.dispPresel1','DP1179');cmp.set('v.rifiutaChiamata',false);cmp.set('v.checkboxAttribute', 'nonRichiamare');cmp.set('v.idTab', "esitaChiamata");cmp.set('v.dispPresel2','DP1189');}
        		 if(selezione==opzione4){cmp.set('v.checkboxAttribute', 'rifiutaChiamata');cmp.set('v.rifiutaChiamata',true); cmp.set('v.idTab', "esitaChiamata");  cmp.set('v.dispPresel1','DP1228');cmp.set('v.dispPresel2', 'DP1243'); } 
        }
        if(obj.ActivityType__c == 'TMKPP' && obj.CampaignId__r.ActionCode__c == 'CQS'){
                               
                if(selezione==opzione2){cmp.set('v.checkboxAttribute', 'nonDisponibile');cmp.set('v.rifiutaChiamata',false);cmp.set('v.idTab', "esitaChiamata");cmp.set('v.dispPresel1','DP1228');cmp.set('v.dispPresel2', 'DP1230');}
                if(selezione==opzione3){cmp.set('v.checkboxAttribute', 'nonRichiamare');cmp.set('v.rifiutaChiamata',false);cmp.set('v.idTab', "esitaChiamata");cmp.set('v.dispPresel1','DP1228');cmp.set('v.dispPresel2', 'DP1239'); cmp.set('v.dispPresel3','DP1240');}
        		if(selezione==opzione4){ cmp.set('v.checkboxAttribute', 'rifiutaChiamata');cmp.set('v.rifiutaChiamata',true); cmp.set('v.idTab', "esitaChiamata");  cmp.set('v.dispPresel1','DP1228');cmp.set('v.dispPresel2', 'DP1243'); } 

        }
            

        
        
    },
    
    init : function(cmp, event, helper) {
        let obj = cmp.get('v.CaseRecord');
        const activitiCC = 'TMKCC'; 
       let Nome = cmp.get('v.Nome');
       let Cognome = cmp.get('v.Cognome');
        let action = cmp.get('c.Name');  
        action.setCallback(this, function(response) { 
            let state = response.getState(); 
            if (state == 'SUCCESS') { 
                var results = response.getReturnValue();
                cmp.set('v.Nome', results.Name);
                cmp.set('v.Cognome', results.LastName);
                
            }
            helper.dispAdistanzaDi(cmp);
        }); 
        $A.enqueueAction(action);
        
    },
   
    block : function(cmp,event,helper) {
        const bloccata = 'BLOCCATA';
        let prod = event.getParam('NomeProd');
        let statoNum = event.getParam('stato');
        let dispManc = event.getParam('disp');
        let statoCarta = event.getParam('statoCarta');
        let dispSA = event.getParam('dispSA');
        console.log("questa è la disponibilità sal " + dispSA);
        let fido = event.getParam('fido');
        let fidoSA = event.getParam('fidoSA');
        let fidoPR = event.getParam('fidoPR');
        console.log('stato carta ',statoCarta);
        let bool = Boolean(statoCarta != bloccata ||statoCarta != "");
        cmp.set('v.Prod', prod);
       
        cmp.set('v.dispScript', dispManc);
        cmp.set('v.dispSascript', dispSA);
        cmp.set('v.fido', fido);
        cmp.set('v.fidoSAscript', fidoSA);
        cmp.set('v.fidoPRscript', fidoPR);
        switch(statoCarta){
            case bloccata:
                cmp.set('v.block', true);
                cmp.set('v.uscript', false);
                cmp.set('v.stato', statoNum);
                cmp.find('check').set('v.disabled', statoCarta == bloccata);
                break;
            case !bloccata: 
                cmp.set('v.block', false);
                cmp.set('v.uscript', true);
                cmp.find('check').set('v.disabled', statoCarta == bloccata);
                break;
        }
        if(dispManc != '' && dispManc < 300){
            cmp.set('v.dispManc',true);
        }
    }
})