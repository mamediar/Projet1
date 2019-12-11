({
    init : function(cmp, event, helper) { 
        helper.setOptions(cmp);
        var action = cmp.get("c.doInit");
        action.setParam("caseId", cmp.get("v.recordId") );  
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                var result = response.getReturnValue(); 
                cmp.set("v.client", result.client);
                cmp.set("v.statusBadge", result.statusBadge);
                cmp.set("v.textBadge", result.textBadge);                                
                cmp.set("v.codCliente", result.codCliente); 
                cmp.set("v.isUserEnabled", result.isUserEnabled);                                                                
                cmp.set('v.flagPianificazioneVenditaContainer', !result.utils.showVenditaProdottoContainer);
                cmp.set('v.formattedProfileName', result.formattedProfileName);
                
                //$A.get("e.force:refreshView").fire();
            }
        });
        $A.enqueueAction(action);
    },
    
    interestChanged : function(cmp, event, helper){
        var intOutcome = cmp.find('interestOutcome');
        var dataGathering = cmp.find("dataGathering").getElement();
        var interestValue = event.getSource().get('v.value'); 
        if(interestValue == 'interessato') {
            helper.show(dataGathering);
            //var intOutcome = cmp.find('interestOutcome').getElement();
            $A.util.addClass(intOutcome, 'visible');
        }
        else{
            helper.hide(dataGathering);
            //var intOutcome = cmp.find('interestOutcome').getElement();
            $A.util.removeClass(intOutcome, 'visible');      
        }
    },
    
    checkData : function(cmp, event, helper){
        var value = event.getSource().get('v.value');                    
        var calendar = cmp.find("schedulingDateContainer").getElement();
        if(value == 'schedula') helper.show(calendar);
        else helper.hide(calendar);
    },
    
    next : function(cmp, event, helper){
        //var PianificazioneVenditaContainer = cmp.find('PianificazioneVenditaContainer').getElement();
        //var VenditaProdottoContainer = cmp.find('VenditaProdottoContainer').getElement();        
        var interestValue = cmp.find('interest').get('v.value');
        var dataPreferenceValue = cmp.find("dataPreference").get("v.value");
        var schedulingDate = cmp.find('schedulingDate').get('v.value');  
        //console.log(schedulingDate);
        var note = cmp.find('note').get('v.value');
        
        if(!interestValue || (interestValue == 'interessato' && !dataPreferenceValue) || (dataPreferenceValue == 'schedula' && !schedulingDate)){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "warning",
                "title": !interestValue ? "Selezionare l'interesse del cliente" :
                		 (interestValue == 'interessato' && !dataPreferenceValue) ? "Gestire l'interesse o fissare una data di ricontatto?" :
                						  "Selezionare la data e l'ora di ricontatto",
                "message": " "
            });
            toastEvent.fire();
        } else {
            var action = cmp.get('c.goNext');
            action.setParams({
                'caseId' : cmp.get('v.recordId'),
                'interestValue' : interestValue,
                'dataPreferenceValue' : dataPreferenceValue,
                'schedulingDate' : schedulingDate,
                'isUserEnabled' : cmp.get('v.isUserEnabled'),
                'note' : note
            });
            action.setCallback(this, function(response){
                if(response.getState() == 'SUCCESS'){
                    var result = response.getReturnValue();
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type"    : result.message.type,
                        "title"   : result.message.title,
                        "message" : result.message.message
                    });                                        
                    cmp.set('v.flagPianificazioneVenditaContainer', !result.showVenditaProdottoContainer);
                    
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                }
            });
            $A.enqueueAction(action);
        }
    }
})