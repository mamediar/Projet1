({
		doInit: function (component, event) {
		this.setOptions(component)  

	},
    
    setOptions : function(component) {
        component.set('v.Tipo', [
            {label:'Selezionare un Valore', value:''},
            {label:'Accollo', value:'Accollo'},
            {label:'Dossier', value:'Dossier'}
            
        ]);
        component.set('v.dossierURL','');
       
    },
    
    TipoChange : function (component){
        
        
        var Tipo = component.find("Tipo").get("v.value");
        console.log('Tipo***: '+Tipo);
        component.set("v.TipoSelez",Tipo);
        if(Tipo=='Accollo')
            component.set("v.titolo",'Cover Accollo Creata:');
        else
            component.set("v.titolo",'Cover Dossier Creata:'); 
        console.log('TipoSelez***: '+ component.get("v.TipoSelez"));
        
    },
    
    CheckDati : function (component,event){
       console.log('CHECKKKKKKKKKK');
       var action = component.get("c.CreaCaseNote");
       var Tipo = component.get("v.TipoSelez");
       
        console.log('CHECKKKKKKKKKK-selez'+Tipo);
        
       var OCScode = component.get("v.OcsExtId");
       var Note = component.get("v.note");
       var caseId = component.get("v.caseId");
        
        if(Tipo == '' || Tipo == undefined || Tipo == null){ 
            this.showToastWarning (component, event, 'Prima di procedere selezionare il Tipo.');
        }
          
        else if(OCScode =='' || OCScode == undefined || OCScode == null){
           this.showToastWarning (component, event, 'Prima di procedere popolare il Codice OCS ');
        }        
        else if(Note =='' || Note == undefined || Note == null){
            this.showToastWarning (component, event, 'Prima di procedere inserire le note');    
        }
        else
        {
           action.setParams({
				Tipo: Tipo ,
            	OCScode: OCScode,
            	Note : Note ,
                CaseId : caseId
           }); 
           
       		 console.log('Tipo2 : ' + Tipo);
       		 console.log('OCScode2 : '+OCScode);
        	 console.log('Note2 : '+Note);
             console.log('caseId PRima:'+caseId);
            
            
            action.setCallback(this, function(response){
                
            if (response.getState() == 'SUCCESS'){
                
                console.log('CHECKKKKKKKKKK3333');
                var result = response.getReturnValue();
                var caseId = result;
                
                console.log('**caseId***** : '+caseId);
                 console.log('**result***** : '+result);
                if(result == '' || result == undefined){
                    this.showToastKO(component, event, 'Riscontrato errore tecnico');
                }
                else if(result == 'Dealer Non trovato'){
                    this.showToastKO(component, event, 'Dealer Non trovato, verificare codice OCS');
                }
				else{   
                	caseId = result;
                    component.set("v.caseId",caseId);
                    
            		this.CreaCover(component,event);
                    this.showToastOK(component,event);
                }
                
           	}
            });  
            $A.enqueueAction(action);
        
        }            
    },
   
    CreaCover : function(component,event){
                
	   var action = component.get("c.CreaCover");
       var tipo = component.get("v.TipoSelez");
       var OCScode = component.get("v.OcsExtId");
       var IdCase = component.get("v.caseId");
        
 	   console.log('TipoCov : ' + tipo);
       console.log('OCScodeCov : '+OCScode);
       console.log('caseId Cov:'+IdCase);
        
       action.setParams({
			"Tipo": tipo,
            "OCScode": OCScode,
            "CaseId" : IdCase
           
		}); 
                
        action.setCallback(this, function(response){
			console.log("*** response.getReturnValue() :: " + response.getReturnValue());
			if (response.getState() == 'SUCCESS'){
				var result = response.getReturnValue();
                component.set("v.dossierURL",response.getReturnValue())
            	console.log("*** response.result() :: " + result);
            }
            else{
            	
            	this.showToastKO(component, event, 'Riscontrato errore tecnico');
            }
       			
                
            });
		
		$A.enqueueAction(action);
    
	},
    RicaricaPaginaInserimento : function(component,event){
         location.reload();
    },
    
    showToastOK: function(component, event) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: "Operazione completata",
			type: "success",
			message: "Salvataggio completato con successo!"
		});
		toastEvent.fire();
	},
	
	showToastKO: function(component, event, message) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: "Errore",
			type: "error",
			message: message
		});
		toastEvent.fire();
	},

	showToastWarning: function(component, event, message) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: "Attenzione",
			type: "warning",
			message: message
		});
		toastEvent.fire();
	},
})