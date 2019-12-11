({
	doInit:	function(component, event, helper) {
        console.log('Form MD INIT');
        
        var action = helper.getRowActions.bind(this, component);
        component.set('v.columnsDocumenti', [
            {label: 'Tipo', fieldName: 'Tipo', type: 'text'},
            {label: 'Documento', fieldName: 'Documento', type: 'text'},
            {label: 'Risposta', fieldName: 'Risposta', type: 'text'},
            {label: 'Nome contatto', fieldName: 'NomeContatto', type: 'text'},
            {label: 'Numero allegati', fieldName: 'NumeroAllegati', type: 'text'},
            {type: 'action', typeAttributes: { rowActions: action } },
        ]);   
            
		helper.doInit(component, event); 
	},

    recordLoaded: function(component, event, helper) {
        console.log('recordLoaded');
        component.find("OCS_External_Id").set("v.value",component.get("v.OCSExternalDealer"));   //NON CANCELLARE
        console.log('dealerId: '+component.find("OCS_External_Id__c").get("v.OCS_External_Id__c")); 
	},
            
	handleRowActionDocumenti: function(component, event, helper) {
        var row = event.getParam('row');
        component.set("v.selectedDossierDocumentId",row.Id);
        helper.getAttachments(component,event);    
        component.set("v.openModale",true);     
	},
            
    handleChangeGDO : function(component, event, helper){
        var Rientro = component.find("GDO").get("v.value");
        component.set("v.RientroGDO",Rientro);
        console.log('RientroGDO!!!!!'+Rientro)
    },
    
   	OpenFile :function(component,event,helper){  
         var rec_id = event.currentTarget.id;  
         $A.get('e.lightning:openFiles').fire({ //Lightning Openfiles event    
           recordIds: [rec_id] //file id  
         });  
	   },
	   
	cancellaFile :function(component,event,helper){  
		var rec_id = event.currentTarget.id;
		helper.callDeleteFile(component, event, rec_id);
	},   
            
    closeModal : function(component,event,helper){
        component.set("v.openModale",false);
        component.set("v.filesDossierDocumentSelezionato","");
        //helper.doInit(component, event); 
    },
    
    actionButtonSalva : function(component,event,helper){
        var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();        
        component.find('FormDossierCheckbox').submit();
        if(component.find("IsDocumentiCompleti__c").get("v.value") && component.find("IsDocumentiNonManipolati__c").get("v.value")){
            component.set("v.disableButtonConferma",false);
        } else {
            component.set("v.disableButtonConferma",true);
        }
		spinner.decreaseCounter();        
    },
    
    actionButtonDocumentiNonCompleti : function(component,event,helper){
        helper.actionButtonDocumentiNonCompleti(component,event);
    }, 
    
    actionButtonConferma : function(component,event,helper){
        if(component.find("IsDocumentiCompleti__c").get("v.value") && component.find("IsDocumentiNonManipolati__c").get("v.value")){
        	helper.actionButtonConferma(component,event);
        } else {
            component.set("v.disableButtonConferma",true);
        }
    }, 
    
    actionButtonApprova : function(component,event,helper){
        var PresenzaGDO =component.get("v.PresenzaGDO");
        console.log('PresenzaGDO : '+PresenzaGDO);
        if(PresenzaGDO)
        {
        	var GDOSelezionato = component.get("v.RientroGDO");
             console.log('GDOSelezionatoCTR : '+GDOSelezionato);
            if(GDOSelezionato != null)
            {
                helper.approva(component,event); 
            }
            else{  
                helper.showToast(component,event,'Errore','error','Selezionare Firma GDO per poter procedere');
            }    
        }
        else
			helper.approva(component,event);
    }, 
    
    actionButtonRichiediMaggioriInformazioni : function(component,event,helper){
		helper.richiediMaggioriInformazioni(component,event);
    },    
    
    actionButtonSospendi : function(component,event,helper){
		helper.sospendi(component,event);
    },
    
    actionButtonRespingi : function(component,event,helper){
		helper.respingi(component,event);
    }, 
     actionButtonAnnulla : function(component,event,helper){
 		helper.AnnullaAccollo(component,event);
    }, 
    
    actionButtonCambiaStato : function(component,event,helper){
        var showDispositionsSelection=component.get("v.showDispositionsSelection");
        component.set("v.showDispositionsSelection",!showDispositionsSelection);
		//helper.cambiaStato(component,event);
    }, 
    
    actionButtonVisualizzaStoricoEventi : function(component,event,helper){
        var showStoricoEventi=component.get("v.showStoricoEventi");
        component.set("v.showStoricoEventi",!showStoricoEventi);
    },     
    
	handleDispositionReadyEvent: function(component, event, helper) {
        console.log('***handleDispositionReadyEvent');
        location.reload();         
        
	},

	actionButtonDettaglioConvenzionato: function(component, event, helper) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get('v.dealerId')
        });
        navEvt.fire();        
	},
    
    actionButtonVisualizzaMotivo: function(component,event,helper){
        var showStoricoMotivi=component.get("v.showStoricoMotivi");
        component.set("v.showStoricoMotivi",!showStoricoMotivi);
    },     
    
    actionButtonPrendiCase: function(component,event,helper){
        helper.prendiCase(component,event);
    },                
})