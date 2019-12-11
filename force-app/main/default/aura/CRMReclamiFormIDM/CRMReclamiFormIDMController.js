({
    init : function(cmp, event, helper) {
        helper.setColumns(cmp);
        helper.loadAllegati(cmp);
       // cmp.set('v.vfpURL', 'https://compass--dev--c.cs109.visual.force.com/apex/CRMReclamiFrodePage?id=' + cmp.get('v.recordId'));
       
        cmp.set('v.vfpURL', 'URLFOR($Action.Attachment.Download,' + '00P0Q0000014ousUAA' + ')' );
        console.log('VFPURL_-_-_-_-_-_-_-_-_-_-_-_-> ' + cmp.get('v.vfpURL') );
    },
    
    salvaReclamoGestito : function (cmp, event, helper) {
        var action = cmp.get('c.gestisciReclamo');
        action.setParam('recordId', cmp.get('v.recordId'));
        action.setCallback(this,function(response){
            if(response.getReturnValue() == 'SUCCESS');
            
        });
        $A.enqueueAction(action);
    }
    
    /*  apriFile : function (cmp, event, helper) {
        var rec_id = event.currentTarget.id; 
        console.log('BODY ' + event.currentTarget.Name);

        console.log('RECID ' + rec_id);
        $A.get('e.lightning:openFiles').fire({ 
            recordIds: [rec_id]  
        });  
    },*/
    
   /* apriFile: function(cmp, event, helper) {
        var navService = cmp.find("navService");
        // Uses the pageReference definition in the init handler
        console.log('event CURRENT ID ::::> ' + event.currentTarget.id);
        var pageReference = {    
            type: "standard__webPage",
            attributes: {
                url: "https://compass--dev--c.cs109.content.force.com/servlet/servlet.FileDownload?file="+event.currentTarget.id+"&operationContext=S1"
            }
        };
        var defaultUrl = "#";
        navService.generateUrl(pageReference)
        .then($A.getCallback(function(url) {
            cmp.set("v.url", url ? url : defaultUrl);
        }), $A.getCallback(function(error) {
            cmp.set("v.url", defaultUrl);
        }));
        event.preventDefault();
        navService.navigate(pageReference);
    }*/
})