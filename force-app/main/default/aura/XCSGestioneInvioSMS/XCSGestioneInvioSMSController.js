({
    init : function(cmp, event, helper) 
    {
        var action = cmp.get('c.Inizializzazione');
        action.setParams({
            'allTemplate' : cmp.get('v.isVisibleAllSMS'), 
            'recordId' : cmp.get('v.recordId'),
            'SMSTemplateName' : cmp.get('v.SMSTemplateName'),
            'onlyByName' : cmp.get('v.onlyByName')
        });
        action.setCallback(this, function(response) 
                           {
                               if ( response.getState() == 'SUCCESS' ) 
                               {
                                   var obj = response.getReturnValue();
                                   cmp.set('v.listaTemplate',obj.listTemplate);
                                   cmp.set('v.customerCellulare',obj.customerCellulare);
                                   cmp.set('v.account',obj.account);
                                   console.log('Lista Template*****' + JSON.stringify(obj.listTemplate));
                               }
                           });
        $A.enqueueAction(action);
    },
    sendSMS : function(cmp,event,helper)
    {
        var action = cmp.get('c.InviaSMS');
        action.setParams({
            'caseId': cmp.get('v.recordId'),
            'account': cmp.get('v.account'),
            'customerCellulare' : cmp.get('v.customerCellulare'),
            'testoTemplate' : cmp.get('v.template')
        });
        action.setCallback(this, function(response) 
                           {
                               if ( response.getState() == 'SUCCESS' ) 
                               {
                                   var obj = response.getReturnValue();
                                   var toastEvent = $A.get("e.force:showToast");
                                   var check = obj.res;
                                   var messToast = obj.messToast;
                                   console.log('********* : ' + check);
                                   if(check == true)
                                   {
                                       console.log('********** DENTRO IF' + check);
                                       toastEvent.setParams({
                                           "title": "Successo",
                                           "message": messToast,
                                           "type" : "Success"	
                                       });
                                       toastEvent.fire();
									   cmp.set('v.checkModale',false);
                                       console.log('SPARO l EVENTO');
                                       var compEvent = cmp.getEvent("XCSInvioSMSEvent");
									   compEvent.fire();
                                   }
                                   else
                                   {
                                       toastEvent.setParams({
                                           "title": "Attenzione",
                                           "message": messToast,
                                           "type" : "Warning"	
                                       });
                                       toastEvent.fire();
                                   }
                               }
                               });
                               $A.enqueueAction(action);
                           },
                           selectSMS : function(cmp,event,helper)
        {
            console.log('************ EXECUTE');
            var template = cmp.find("SMSDaInviare").get("v.value");
            cmp.set('v.template', template);
            console.log("*** fascia selezionata :: " + template);    
        }
    })