({

    
	doInit:	function(component, event, helper) {
        console.log('***********DOINIT');
        
		var action = helper.getRowActions.bind(this, component);                      
        component.set('v.columns', [
            {label: 'OCS', fieldName: 'OCS_External_Id__c', type: 'text'},
            {label: 'Cognome', fieldName: 'LastName', type: 'text'},
            {label: 'Nome', fieldName: 'FirstName', type: 'text'},
            {label: 'Sesso', fieldName: 'Sesso__c', type: 'text'},
            {label: 'Luogo di nascita', fieldName: 'Luogo_Nascita__c', type: 'text'},
            {label: 'Data di nascita', fieldName: 'Birthdate', type: 'text'},
            {label: 'Codice Fiscale', fieldName: 'Codice_Fiscale__c', type: 'text'},
            {label: 'Partita Iva', fieldName: 'Partita_IVA__c', type: 'text'},
            {label: 'Indirizzo', fieldName: 'MailingAddress', type: 'text'},
            {label: 'Mail', fieldName: 'Email', type: 'text'},
            {label: 'Ruolo', fieldName: 'Roles', type: 'text'},
            {label: 'Rimosso', fieldName: 'Rimosso', type: 'text'},   
            {type: 'action', typeAttributes: { rowActions: action } },
        ]); 
        

        component.set('v.columnsIndirizzo', [
            {label: 'Indirizzo', fieldName: 'Indirizzo', type: 'text'},
            {label: 'Località', fieldName: 'Localita', type: 'text'},
            {label: 'CAP', fieldName: 'CAP', type: 'text'},
            {label: 'Provincia', fieldName: 'Provincia', type: 'text'},
        ]);   
		helper.callGetDealerAcquisition(component, event);
	},   

    salvaDatiCollegato : function(component, event, helper) {
        helper.aggiornaDatiCollegato(component, event);
	},  


    handleRowAction : function(component,event,helper){            
       var action = event.getParam('action');
       var row = event.getParam('row');
          
       switch (action.name) {
            case 'edit':   
               if(row.TipoAnagrafica=='G'){   
                   component.set("v.isCollegatoSelezionatoGiuridico",true);
               } else {
                   component.set("v.isCollegatoSelezionatoGiuridico",false);           
               }    
               
               component.set("v.provinciaCollegato","");  
               component.set("v.cittaCollegato",""); 
               component.set("v.cittaNascitaCollegato","");
               component.set("v.provinciaNascitaCollegato","");
               component.set("v.provinciaCollegato", row.MailingState);  
               component.set("v.cittaCollegato", row.MailingCity); 
               component.set("v.cittaNascitaCollegato", row.Luogo_Nascita__c);
               component.set("v.provinciaNascitaCollegato", row.Provincia_Nascita__c);             
               component.set("v.isOpen",true);    
               component.set("v.selectedAccountId",row.Id);
               component.set("v.selectedcontactRelationId",row.contactRelationId);
               component.set("v.selectedRow",row);
               component.set("v.isCollegatoFirmatario",row.isCollegatoFirmatario);
               component.set("v.isCollegatoRappresentante",row.isCollegatoRappresentante);
               component.set("v.showTableMutipleAddressesCollegati",false);
               component.set("v.disableButtonAggiornaDatiCollegati",false);
               /*var picklistProvinceCollegato=component.find("ProvincePicklistCollegato"); 
                    picklistProvinceCollegato.inizializza();    */                   
               break;
            case 'delete':
               helper.handleDeleteCollegato(component,row); 
               break;   

       }
            
    },
        
    handleSelectionIndirizzoCollegati : function(component,event,helper){
        var selRow=event.getParam('selectedRows')[0];
        component.set('v.selectedIndirizzoCollegati',selRow);  
        component.set('v.disableButtonAggiornaDatiCollegati',false);
        helper.salvaIndirizzoCollegatoDaDatatable(component,event);
    },

    handleSelectionIndirizzoDealer : function(component,event,helper) {
        var selRow=event.getParam('selectedRows')[0];
        component.set('v.selectedIndirizzoDealer',selRow);  
        helper.salvaIndirizzoDealerDaDatatable(component,event);
    },
     
    closeModel : function(component,event,helper){
        component.set("v.isOpen",false);
        helper.callGetDealerAcquisition(component,event,helper);
        component.set("v.provinciaNascitaCollegato","");
        component.set("v.cittaNascitaCollegato","");
        component.set("v.provinciaCollegato","");
        component.set("v.cittaCollegato","");        
    },
    
    closeModelIndirizzoDealer : function(component,event,helper){
        component.set("v.openModaleIndirizzoDealer",false);
        helper.callGetDealerAcquisition(component,event,helper);
    },
    
	closeModelIndirizzoCollegato  : function(component,event,helper){
        component.set("v.showTableMutipleAddressesCollegati",false);         
        helper.callGetDealerAcquisition(component,event,helper);       
    }, 

    actionButtonSalvaEContinua : function(component, event, helper) {
        component.set("v.isChiamataOCSNotOK",false);
    
        helper.controllaSeAndareAvantiPossibile(component, event);

	}, 

    actionButtonTravasaSuOCS : function(component, event, helper) {
        component.set("v.showSpinner",true);
        helper.travasaSuOCS(component, event);
	}, 
            

	handleError: function(component, event, helper) {
        this.showToast(component,event,"","error","Si è verificato un errore durante il salvataggio.","500");                            
		helper.showToastKO(component, event);
    },
    
})