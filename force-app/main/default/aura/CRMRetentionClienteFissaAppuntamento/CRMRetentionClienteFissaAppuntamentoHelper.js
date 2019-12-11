({
	initHelper : function(cmp,event,helper) {
		//cmp.set('v.obiezioneOption', helper.helperObiezioneOption(cmp));
        //cmp.set('v.tassoOption', helper.helperTassoOption(cmp));
        //helper.helperHandleChange(cmp);
	},
    helperTassoOption : function(cmp)	{
     	return [
         		{'label' : 'TASSO NON COMUNICATO', 'value' : 'default'},
         		{'label' : '0,5', 'value' : '0,5'},
         		{'label' : '1', 'value' : '1'}
     			];  
    },
    helperObiezioneOption : function(cmp)	{
        return [
           			 {'label' : 'NESSUNA OBIEZIONE', 'value' : 'default'},
         			 {'label' : 'GIA’ TRANSITATO IN FILIALE', 'value' : 'GIA’ TRANSITATO IN FILIALE'},
         			 {'label' : 'NO APPUNTAMENTO SENZA COMUNICAZIONE OFFERTA', 'value' : 'NO APPUNTAMENTO SENZA COMUNICAZIONE OFFERTA'},
            		 {'label' : 'HA OFFERTA COMPETITIVA', 'value' : 'HA OFFERTA COMPETITIVA'}
       			];
    },
    helperHandleChange : function(cmp){
       	 cmp.set("v.tassoSelected",cmp.find("Tasso").get("v.value"));
         cmp.set("v.obiezioneSelected",cmp.find("Obiezione").get("v.value"));
    },
    helperHandleComponentEvent : function(cmp, evt, help){
        var appointment = evt.getParam('appuntamento');
        var action = cmp.get('c.doRetentionSpecificAction');
        action.setParams({
            "caseId": cmp.get("v.recordId"),
            "obiezione" : cmp.get("v.obiezioneSelected"),
            "tasso" : cmp.get("v.tassoSelected"),
            "evento" : appointment
        });
        action.setCallback(this, function(response)
                           {
                               if(response.getState() == 'SUCCESS' ) 
                               {
                                   $A.get('e.force:refreshView').fire()
                               }
                           });
        $A.enqueueAction(action);
    }
})