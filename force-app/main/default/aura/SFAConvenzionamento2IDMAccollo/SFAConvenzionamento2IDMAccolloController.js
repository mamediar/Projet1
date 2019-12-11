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
            component.set("v.isDocCreato",false);
        helper.getAttachments(component,event);    
        component.set("v.openModale",true);     
	},
            
   UploadFinished : function(component, event, helper) {  
     component.set("v.isDocCreato",true);
   
     helper.getAttachments(component, event);
     helper.doInit(component, event); 
   },            
            
    
   	OpenFile :function(component,event,helper){  
         var rec_id = event.currentTarget.id;  
         $A.get('e.lightning:openFiles').fire({ //Lightning Openfiles event    
           recordIds: [rec_id] //file id  
         });  
   	},
	actionButtonAnnulla : function(component,event,helper){
 		helper.AnnullaAccollo(component,event);
    },     
            
    closeModal : function(component,event,helper){
        component.set("v.openModale",false);
        component.set("v.filesDossierDocumentSelezionato","");
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
    
})