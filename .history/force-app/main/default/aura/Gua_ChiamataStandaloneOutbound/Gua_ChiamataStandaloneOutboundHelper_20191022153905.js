({
    chiamateOutboundDealer : function(component, event, helper) {

    },
    chiamateOutboundFiliale : function(component, event, helper) {
        component.set('isOpenModel',true);
    },
    closeModel : function(component,event,helper){
        component.set('isOpenModel',false);
    }
})