({
    doInit: function(component, event, helper) {
        helper.doInit(component);
    },
    handleChange: function(component, event) {
        var value = event.getParam('value');
        console.log('value selected', value);
    },
    send: function(component, event, helper) {
        helper.sendMail(component);
    },
    annula: function(component, event, helper) {
        console.log('Cancel send mail');
    },
})