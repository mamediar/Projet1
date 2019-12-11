({
    handleDetailEvent : function(component,event,helper) {
        var detailEvent = event.getParam("detailEvent");
        component.set("v.detailEvent", detailEvent);
        component.set("v.showDetail", true);
        component.set("v.dateActuel",detailEvent.ActivityDateTime);
        console.log("nav " + detailEvent);
        if(detailEvent.Desk__c){
           helper.getFiliale(component); 
        }
        helper.getValuesProduct(component);
        helper.getValueFotocopieAllegare(component,event,helper);
    },
    
    changeEvent: function(component,event,helper){
        helper.choiceValueSelect(component);
    },
    aggiornaAppuntamento : function(component,event,helper) {
       helper.aggiornaAppuntamento(component,event,helper);
    },
    openModel: function(component, event, helper) {
 
        var isExist=false;
        var dateActuel=component.get("v.dateActuel"); 
        var newDate=component.get("v.detailEvent.ActivityDateTime");
        helper.checkDatetime(component,event,isExist);

        if(newDate<=dateActuel){
            helper.showToast("data corrente superiore alla vecchia data","warning");
        }else if(isExist===true){
            helper.showToast("questa data è già stata scelta","warning");
        }else{
      	    component.set("v.isOpen" ,true);
        }
    },
   closeModel: function(component) {
       component.set("v.isOpen", false);
   },
   likenClose: function(component) {
      component.set("v.isOpen", false);
   },
   uploadRiepilogo: function(component, event, helper) {
       helper.uploadRiepilogo(component,event,helper);
   },
   getvalueEsitoSelected : function (component,event,helper){
       helper.getValueList3(component,event,helper);
   },
   getvalueMotivazioneSelected : function (component,event,helper){
        helper.getValueMotivazione(component);
    },
    choiceHoure : function (component,event,helper){
    	var timeEvent = document.getElementById("idListTime");
        var valtime = timeEvent.options[timeEvent.selectedIndex].value;
        component.set('v.timeEvent',valtime);
        console.log('timeEvent '+valtime);
        //getDateTime
        var detailEvent = component.get("v.detailEvent");
        console.log("detailEvent" + JSON.stringify(detailEvent));
        var action = component.get('c.getDateTime'); 
        action.setParams({"timeEvent":valtime,
                        "event": detailEvent}); 
        action.setCallback(this, function (response) {
            if (response.getState() == "SUCCESS") {
                var resultat = response.getReturnValue();
                console.log('detail event '+resultat);
                if (resultat.erreur==false) {
                    component.set("v.detailEvent.ActivityDateTime",resultat.data);
                }else {
                    console.log('detail event '+response.getError());
                }
            }
            else{
            console.log(response.getError());
            }
        });
        $A.enqueueAction(action); 
    },
    controlDateEvent : function(component,event,helper){
        component.set('v.timeEvent','');
        helper.controldateEvent(component,event,helper);
    },
    closeMessageError : function(component,event,helper){
        component.set('v.alertMessage',false);
        helper.showToast(' Modifica l\'appuntamento annullato','error');
    },
    saveAnnulato : function(component,event,helper){
        helper.saveAnnulato(component,event,helper);
    }
    
})