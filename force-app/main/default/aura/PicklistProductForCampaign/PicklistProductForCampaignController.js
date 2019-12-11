({
	init : function(cmp, event, helper) {
        let prodSelezionato = cmp.get('v.ProdottoSelezionato');
        
       
        var action = cmp.get('c.prod');  
        action.setCallback(this, function(response) { 
            var state = response.getState();
            if (state == 'SUCCESS') {
                var results = response.getReturnValue();
                cmp.set('v.options', results);
                
            }
        }); 
        $A.enqueueAction(action);
		
	},
    handleChange : function(cmp,event,helper) {
        
        let prodSelezionato = cmp.get('v.ProdottoSelezionato');
        console.log('id prodotto ',prodSelezionato);
        let prod = cmp.set('v.Bool',true);
       
        
    },
    saveProdotto : function(cmp,event, helper) {
        let idCampaign = cmp.get('v.recordId');
        let prodSelezionato = cmp.get('v.ProdottoSelezionato');
        let action = cmp.get('c.updates');
        console.log('id campagna ',idCampaign)
        action.setParams({'idcamp':cmp.get('v.recordId'), 'prod':cmp.get('v.ProdottoSelezionato')});
       
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log(state);
            var results = response.getReturnValue();
            if(state == 'SUCCESS'){
                 $A.get("e.force:refreshView").fire();
                helper.toastSucc(cmp);	
            }
            else{
                helper.toastMancante(cmp,event,"Salvataggio prodotto fallito","error","Attenzione!")
            }
        });
        $A.enqueueAction(action);
       
    }
    
    
})