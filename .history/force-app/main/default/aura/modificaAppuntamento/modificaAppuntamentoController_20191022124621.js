({
    addScheduledDate : function(component, event, helper) {
        helper.getAddScheduledDate(component);
    },
    Eventselected: function (component, event, helper) {
        var eventSelectecd = event.getSource().get('v.value');
        helper.checkTypeClient(eventSelectecd, component);
    }
})