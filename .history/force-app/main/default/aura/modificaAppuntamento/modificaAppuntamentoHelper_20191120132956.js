({
    getAddScheduledDate : function(component) {
        var date=component.get("v.dateAppointment");
        var action = component.get('c.getEventByDateActivity');
        action.setParam('activityDate',date)
        action.setCallback(this, function (response) {
            if (response.getState() == "SUCCESS") {
                var resultat = response.getReturnValue();
                console.log('### resultat ', JSON.stringify(resultat));
             
                if (resultat.erreur == false) {
                    if (resultat.events.length>0){
                        console.log('### events ', JSON.stringify(resultat.events));
                        component.set("v.listEvent", resultat.events);
                    }else{
                        component.set("v.listEvent",null);
                        this.showToast("Non ci sono appuntamento fissati per la data scelta");
                        /*var eventGoCreaAppuntamento = $A.get("e.c:creaAppuntamento");
                        eventGoCreaAppuntamento.fire();*/
                    }
                } else {
                    console.log('message', "Error");
                    component.set("v.listEvent",null);
                }
            }
        });
        $A.enqueueAction(action);
    },

    checkTypeClient: function (eventSelectecd,component){
        if (eventSelectecd.Customer__c){
            if (eventSelectecd.Customer__r.Type == "C") {
                console.log("type C");
            } else {
                console.log("type not C"); 
            }
        }else{
            console.log("null cliente");
            //genere link evo
        }
        var cmpEvent = $A.get("e.c:EventToDetail"); 
        //var cmpEvent =component.getEvent("EventDetail");
        cmpEvent.setParams({
            "detailEvent": eventSelectecd,
            "showEsito":false,
            "ModifyEvent":false
        });
        console.log("cmpEvent.getSourceEvent");
        cmpEvent.fire();
        console.log("cmpEvent.getSourceEvent");
    },
    showToast: function (message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            message: message,
            type: type
        });
        toastEvent.fire();
    },
   
})