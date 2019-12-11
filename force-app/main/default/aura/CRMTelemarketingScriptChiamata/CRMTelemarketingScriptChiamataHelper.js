({
    
    prescript : function (cmp, event){
        const EDI0C = 'EDI0C';
        let obj = cmp.get('v.CaseRecord');
        let prescript = cmp.get('v.prescript');
        let script = cmp.get('v.script');
        if(obj.CampaignId__r.RecordType.Name == 'CC'){
            let action = cmp.get('c.preScript');
            action.setParams({'codPromotion': obj.CampaignId__r.CodPromotion__c});
            action.setCallback(this, function(response){
                var state = response.getState();                
                if(state == 'SUCCESS'){
                    let prescri = response.getReturnValue();
                    if(obj.CampaignId__r.CodPromotion__c != EDI0C){ 
                        cmp.set('v.preScript', prescri); 
                        cmp.set('v.showPreScript', obj.CampaignId__r.codPromotion__c != EDI0C);
                    }
                    else{ 
                        
                        cmp.set('v.preScript', prescri)
                        cmp.set('v.uscript', false);
                        console.log('vediamooo ',cmp.get('v.uscript'));

                    }
                    
                }
            });
            $A.enqueueAction(action); 
        }
    },

    dispAdistanzaDi: function(cmp,event){
        let obj = cmp.get('v.CaseRecord');
        console.log(obj.CampaignId__c);
        let mapForDisp = {'DP1999': '6 mesi',
                            'DP2000': '6 mesi',
                            'DP6255': '2 mesi',
                            'DP6256': '3 mesi',
                            'DP6257': '4 mesi',
                            'DP6258': '5 mesi',
                            'DP6259': '6 mesi'};
        
        let action = cmp.get('c.dispositionControllForAccount');
        action.setParams({'idAcc': obj.AccountId, 'typeRecord':obj.CampaignId__r.RecordTypeId, 
        'mapForDisp':Object.keys(mapForDisp)});
        action.setCallback(this, (response) => {
            let state = response.getState();
            console.log('lo stato ',state);
            if(state == 'SUCCESS'){
                
                let dispPrecedente = response.getReturnValue();
                
                cmp.set('v.dispTrovata', mapForDisp[dispPrecedente]);
                cmp.set('v.forblock', dispPrecedente != null);
            }
        });
        $A.enqueueAction(action);
                            
    }
	
})