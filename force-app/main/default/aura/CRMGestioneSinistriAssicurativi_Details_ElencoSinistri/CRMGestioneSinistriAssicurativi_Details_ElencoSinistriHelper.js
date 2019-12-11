({
	doFilter : function(component, event) {
	  var stato= component.find('stato').get('v.value');
	  var pratica= component.find('numPratica').get('v.value');
        if(  stato === undefined || stato ===''){
            stato = 'openLast15';
        }
        if(  pratica === undefined || pratica ===''){
            pratica = -1;
        }
		
		
			var action=component.get('c.ricerca');
			action.setParams({ stato : stato,
                              pratica : pratica});
			action.setCallback(this,function(resp){
				if(resp.getState()=='SUCCESS'){
					var responseWrapper= JSON.parse(resp.getReturnValue());
                     var spinner = component.find("spinnerSearch");
					component.set('v.sinistriList', responseWrapper);
                      $A.util.removeClass(spinner, "slds-show");
                   $A.util.addClass(spinner, "slds-hide" );
					if(responseWrapper.length==0){
						this.showToast("Errore: nessuna corrispondenza trovata",'error');
					}
					
                }else{
                     $A.util.removeClass(spinner, "slds-show");
                   $A.util.addClass(spinner, "slds-hide" );
                }
				
				
			});
			$A.enqueueAction(action);
          
		},
    
    	showToast : function(message, type){
		var toastEvent = $A.get("e.force:showToast");
        console.log(' message, type '+message+ ' - '+type);
		toastEvent.setParams({
			message: message,
			type : type
		});
		toastEvent.fire();
	}
		
			
	
})