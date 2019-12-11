({
	saveRecord : function(component, event, helper) {
        var record = component.get('v.campaignMemberRecord');
        if(record.Esito__c == null || record.Esito__c == ''){
            helper.showToast('','warning','Selezionare un esito');
            return;
        } 
        if( record.Esito__c == 'Chiede di essere richiamato' && component.get('v.richiamare') == null){
            helper.showToast('','warning','Selezionare una data di richiamo');
            return;
        }

        if( record.Campaign.Status != 'In Progress' && record.Campaign.Status != 'Completed' ){
            helper.showToast('','error','Non è possibile lavorare il membro di campagna. La campagna non è in corso.');
            return;
        }
        record.Richiamare__c = component.get('v.richiamare');
        
        
        helper.save(component,helper,record);

        
        
	},
    setTodayOnRichiamare : function(component,event,helper){
        if(component.get('v.campaignMemberRecord.Richiamare__c') != null)
            component.set('v.richiamare',component.get('v.campaignMemberRecord.Richiamare__c'));
        if(component.get('v.richiamare') == null || component.get('v.richiamare') == '') {
            var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-dd");
            component.set('v.richiamare', today);
        }
        if(!component.get('v.idCliente')){
            component.set('v.idCliente',component.get('v.campaignMemberRecord.AccountId__c'));
        }
        component.set('v.newEvent.Note__c',component.get('v.campaignMemberRecord.Note__c'));
        
        
    },
    cancelDialog : function(component,event,helper){

        helper.cancelDialog(component,event,helper);

    },
    changeEsitoAppuntamento : function(component, event, helper){
        component.set('v.campaignMemberRecord.Esito__c','Fissa Appuntamento');
        
    },
    nextRecord : function(component, event, helper){
        var method = component.get('c.getNextRecord');
        method.setParams({
            campaignMemberId : component.get('v.recordId'),
            campaignId       : component.get('v.campaignMemberRecord.CampaignId')
        });

        method.setCallback(this,function(result){
            var state = result.getState();
            if(state == 'SUCCESS'){
                var res = result.getReturnValue();
                console.log('res-->'+res);
                if(res){
                    helper.navigate(component,res)
                }
                
            }else{
                //error
            }

        });

        $A.enqueueAction(method);
    },
    onRecordUpdated : function(component,event,helper){
        component.set('v.visible',false);
        
    },

    handleComponentEvent : function(component,event,helper){
        console.log('evento registrato di fissa appuntamento');
        var evento = event.getParam('appuntamento');
        var dettaglioProdotto = event.getParam('nameDetaglioProdotto');
        

        
        if(evento === undefined){
            helper.showToast('Errore','error','Non è stato possibile salvare l\'appuntamento.');
            component.set('v.campaignMemberRecord.Esito__c','');
            return;
        }
        component.set('v.recap',true);
        evento.ActivityDate = helper.getDate(evento.ActivityDate);
        helper.setHours(component,evento.StartDateTime);
        component.set('v.newEvent',evento);
        if(dettaglioProdotto != undefined)
            component.set('v.nameDetaglioProdotto',dettaglioProdotto);
        var record = component.get('v.campaignMemberRecord');
        helper.save(component,helper,record);
        
    }
})