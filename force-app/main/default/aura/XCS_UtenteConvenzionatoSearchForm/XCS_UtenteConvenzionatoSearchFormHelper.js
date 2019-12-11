({
    checkInput : function(cmp) {
        var check = 0;
        if(cmp.get('v.codiceIntermediario') && cmp.get('v.utenza')) {
            check = 1;
        }
        
        if((cmp.get('v.codiceIntermediario') == null || cmp.get('v.codiceIntermediario') == undefined || cmp.get('v.codiceIntermediario') == '') && 
           (cmp.get('v.utenza') == null || cmp.get('v.utenza') == undefined || cmp.get('v.utenza') == '')){
            check = 2;
        }
        return check;
    },
    
    setToast : function(cmp,check){
        var mess = '';
        var toast = $A.get('e.force:showToast');
        
        if(check == 1)
            mess = cmp.get('v.toastMessage')['dueParametriInsieme'];
        else if(check == 2)
            mess = cmp.get('v.toastMessage')['dueParametriMancanti'];
        else
            mess = cmp.get('v.toastMessage')['utenzaOIntermediarioNonTrovato'];
        
        toast.setParams({
            'title' : mess,
            'type' : 'error',
            'message' : ' '                   
        });                       
        toast.fire(); 
    },
    
    
    sendMessage: function(cmp,helper) {       
        var sendMsgEvent = $A.get("e.ltng:sendMessage"); 
        var channel = helper.setChannel(cmp,helper);
        sendMsgEvent.setParams({
            "message": cmp.get('v.response'),
            "channel" : channel
        }); 
        sendMsgEvent.fire(); 
    },
    
    setChannel : function(cmp,helper){
        if(cmp.get('v.codiceIntermediario'))
            return 'codiceIntermediario';
        else
            return 'utenze';
    }        
})