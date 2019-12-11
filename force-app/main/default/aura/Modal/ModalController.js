({
    init: function(cmp, event, helper) {
        cmp.set('v.title', event.getParam('title'));
        console.log(event.getParam('title'));
    },
    
    handleOpenModalEvent: function(cmp, event, helper) {
        cmp.set('v.title', event.getParam('title'));
        var openModal = event.getParam('openModal');
        if (openModal == true) helper.applycss(cmp, event);
        else helper.removecss(cmp, event);
    },
    
    removecss: function(cmp, event, helper) {
        helper.removecss(cmp, event);
    }
})