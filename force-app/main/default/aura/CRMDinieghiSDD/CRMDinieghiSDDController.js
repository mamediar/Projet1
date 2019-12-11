({
    init : function(component, event, helper) {
        helper.doUser(component);
    },

    showModal: function(component, event, helper) {
           
        var index = event.currentTarget.getAttribute('data-index');
        var dinieghi = component.get('v.elencoDinieghi');
        component.set('v.selectedDiniego', dinieghi[index]);
        console.log(dinieghi[index]);

      
        var cABI = helper.controllaABICAB(dinieghi[index].Abi__c);
        var cCAB = helper.controllaABICAB(dinieghi[index].Cab__c);
        component.set('v.codiceABI', cABI);
        component.set('v.codiceCAB', cCAB);
      
        if(dinieghi[index].Numero_Tentativi__c != null){
            component.set('v.numeroT', dinieghi[index].Numero_Tentativi__c);
        }else{
            component.set('v.numeroT', '0');
        }        

       
        var dataRientro = dinieghi[index].Data_Rientro__c;
        if(dataRientro==undefined){
	        var dataR = ''; 
        }else{
	        var dataR = dataRientro.substring(8,10) + '-' + dataRientro.substring(5,7) + '-' + dataRientro.substring(0,4); 
        }
        component.set('v.dataRientro', dataR);
        
        helper.searchNotes(component, dinieghi[index].Id);
        helper.searchAccount(component, dinieghi[index].Codice_Cliente__c);
        helper.searchContact(component, dinieghi[index].Codice_Cliente__c);
        helper.searchFiliale(component, dinieghi[index].Filiale__c);
        helper.handleGetFile(component, event, dinieghi[index].Caseid__c);
        helper.searchUser(component);

       
        if(dinieghi[index] && dinieghi[index].Caseid__r && dinieghi[index].Caseid__r.RecallDate__c != undefined){
            component.set('v.recallDataTime', dinieghi[index].Caseid__r.RecallDate__c);
        }else{
            component.set('v.recallDataTime',  ' ');
        }        

        var inter = dinieghi[index].Caseid__r.Interlocutore__c;
        var altr = dinieghi[index].Caseid__r.InterlocutoreAltro__c;
      
        if(dinieghi[index] && dinieghi[index].Caseid__r && dinieghi[index].Caseid__r.Interlocutore__c != 'Altro'){
            if(inter == null || inter == undefined){
                component.set('v.interlocutoreValue', 'selezionare');
                component.set('v.altroValue', '');
            }else{
                if(inter=='Cliente - Coobbligato'){
                    inter = 'Cliente';
                }
                component.set('v.interlocutoreValue', inter.toLowerCase());
                component.set('v.altroValue', '');
            }
        }else{
            component.set('v.interlocutoreValue', 'altro');
            component.set('v.altroValue', altr);
        }        
        

       
        if(dinieghi[index].Disposition__c != null){
	        helper.getDispositions(component,dinieghi[index].Disposition__c,dinieghi[index].Ausilio__c);
        }else{
            component.set('v.disposition', null);
        }
        
        if(dinieghi[index].Ausilio__c=='contattoAvvenuto'){

        }

        if(dinieghi[index].Caseid__r.Owner_User__c == null){
            component.set('v.userId', "Select an User");
        }else{
            component.set('v.userId', dinieghi[index].Caseid__r.Owner_User__c);
        }

        helper.doShowModal(component);

    },

    hideModal: function(component, event, helper) {
           
        helper.resetModalValues(component);
        helper.doHideModal(component);
    },

    changeInterlocutore: function(component, event, helper) {
        console.log('------------------------------------------------------------------------');
        console.log('-- Controller JS: CRMDinieghiSDDController - Method: changeInterlocutore');         
        helper.handleChangeInterlocutore(component);
    },

    changeEsitoTelefonata: function(component, event, helper) {
        console.log('--------------------------------------------------------------------------');
        console.log('-- Controller JS: CRMDinieghiSDDController - Method: changeEsitoTelefonata');         
        var esitoTelef = component.get('v.esitoTelefonataValue');
        helper.handleChangeInterlocutore(component);
        helper.handleChangeEsitoTelefonata(component,esitoTelef);
    },

    aggiornaTelefono: function(component, event, helper) {
        var diniego = component.get('v.selectedDiniego');
        helper.handleAggiornaTelefono(component, diniego); //TODO: decommentare quando il servizio sarà funzionante
    },

    aggiornaDiniego: function(component, event, helper) {
        var diniego = component.get('v.selectedDiniego');
        helper.handleAggiornaDiniego(component, diniego); 
    },

    handleDinRis: function (component, event) {
        // This will contain the string of the "value" attribute of the selected option
        var selectedOptionValue = event.getParam("value");
//        alert("Option selected with value: '" + selectedOptionValue + "'");
    },
    
    handleNonDinRis: function (component, event) {
        // This will contain the string of the "value" attribute of the selected option
        var selectedOptionValue = event.getParam("value");
//        alert("Option selected with value: '" + selectedOptionValue + "'");
    },
    
    handleAssegna: function (component, event) {
        // This will contain the string of the "value" attribute of the selected option
        var userId = event.getParam("value");
        component.set('v.userId',userId);
//        alert('id Value : ' + userId);
    },    
   
    handleUploadFinished: function (component, event, helper) {

        helper.handleUploadFinished(component, event);
//        helper.handleGetFile(component, event);
    },
    
    downloadfile: function (component, event, helper){                 
		helper.handleDownloadFile(component, event);
    },

    filtraLista: function (component, event, helper){                 
		helper.filtraListaMandati(component, event);
    },

    riassegna: function (component, event, helper){ 
        var diniego = component.get('v.selectedDiniego.Id');
        var idU = component.get('v.userId');
		helper.handleRiassegna(component, event, diniego, idU);
    },
    
    cancellafile: function (component, event, helper){                 
		helper.handleCancellaFile(component, event);
        var sCaseId = component.get('v.selectedDiniego.Caseid__c');
        helper.handleGetFile(component, event, sCaseId);
    }

})