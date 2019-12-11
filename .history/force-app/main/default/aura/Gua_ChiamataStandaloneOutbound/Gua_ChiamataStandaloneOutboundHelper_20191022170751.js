({
    chiamateOutboundDealer : function(component, event, helper) {

    },
    chiamateOutboundFiliale : function(component, event, helper) {
        component.set('v.isOpenModel',true);
    },
    closeModel : function(component,event,helper){
        component.set('v.isOpenModel',false);
    },
    cercaFiliale : function(component,event,helper){
        
    }
})