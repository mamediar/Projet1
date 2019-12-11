({
    modaleSMS : function(cmp,event,helper)
    {
        cmp.set('v.checkModale',true);  
    },
    chiudiModale : function(cmp,event,helper)
    {
        cmp.set('v.checkModale',false);
    },
    sendSMSwithChildComponent : function(cmp,event,helper)
    {  
    	var mainInvioSMS = cmp.find('MainInvioSMS');
        mainInvioSMS.doSendSMS();
    }
    })