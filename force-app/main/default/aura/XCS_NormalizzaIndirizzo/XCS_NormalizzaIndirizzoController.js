({
    
    handleIndirizzo : function(cmp,event,helper){
        var selRow=event.getParam('selectedRows')[0];
        cmp.set('v.indirizzoOutput',selRow);  
    },

    handleEvent : function(cmp,event,helper){  
        var indirizzo = event.getParam("indirizzoInput");
        cmp.set("v.indirizzoInput", indirizzo);        
        var isModale = event.getParam("showAlwaysModale");
        cmp.set("v.showAlwaysModale",isModale);
        helper.callOCS(cmp,event,helper);       
    },
    
    closeModale : function(cmp,event,helper){
        cmp.set('v.showModale',false);
        helper.launchEvent(cmp,event,helper);
    },
    
    annullaModale : function(cmp,event,helper){
         cmp.set('v.showModale',false);        
    }
        
})