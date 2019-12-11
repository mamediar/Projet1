({
    init : function(component, event, helper) {
        helper.getData(component);
    },

    refresh: function(component, event, helper) {
        helper.getData(component);
    },

    handleRedirect: function(component,event,helper) {
        var sourceId = event.target.getAttribute('id');
        if (sourceId == 'inadempimenti') {
            if (component.get('v.inadempimentiCount') != 0) {
                window.open('/lightning/n/Verifica_inadempimento','_self');
            }else{
                component.set('v.msg', 'non sono presenti inadempimenti da lavorare');
                helper.showInfoToast(component);
            }
        }
        //TODO: aggiungere gestione degli altri link
    }
})