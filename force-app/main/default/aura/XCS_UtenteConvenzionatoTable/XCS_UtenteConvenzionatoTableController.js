({
    handleMessage : function(cmp, event, helper) {
        var message = event.getParam("message");
        var channel = event.getParam("channel");
        cmp.set('v.channel',channel);
        cmp.set('v.data',message);
        var data = cmp.get('v.data');
        helper.setDataTable(cmp,data,channel);        
    }
})