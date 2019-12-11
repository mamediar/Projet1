({
    
    redirect: function (component, event, helper) {

        var eventGoFiliali = $A.get("e.c:eventGetIntervista");
        eventGoFiliali.fire();
    },
    clickCreate: function(component, event, helper) {
        var validExpense = component.find('richiamare').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        // If we pass error checking, do some real work
        if(validExpense){
            var date= component.get("v.richiamareDate");
            var time=component.get("v.richiamareTime");
            var charsDate = date.split('-');
            var charsTime = time.split(':');
            var dateTime= new Date(charsDate[0],(charsDate[1]-1),charsDate[2],charsTime[0],charsTime[1]);
            helper.checkDate(component, dateTime);
        }
    },
    notInterested : function(component,event, helper){
        helper.getNotInterested(component);
    }
})