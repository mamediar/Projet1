({
	initHelper : function(cmp,event,helper) {
		cmp.set('v.obiezioneOption', helper.helperObiezioneOption(cmp));
        cmp.set('v.tassoOption', helper.helperTassoOption(cmp));
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
    helperHandleChange : function(cmp, event, helper)	{
        cmp.set("v.tassoSelected",cmp.find("Tasso").get("v.value"));
        cmp.set("v.obiezioneSelected",cmp.find("Obiezione").get("v.value"));
    }
})