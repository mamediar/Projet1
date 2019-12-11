({
    doInit : function(component, event) {
        
        var idRecord = component.get('v.recordId');
        var action = component.get('c.getComunicazione');      
        action.setParams({
			idCase: idRecord
        });   
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            console.log('doInit state: '+state);
            if (state === "SUCCESS") {              
                var caseSel = response.getReturnValue();
                console.log('caseSel: '+caseSel);                   
                component.set('v.comunicazioneSelected',caseSel);
                if (caseSel!=null && caseSel.Status == 'Closed') {
                    // le attività chiuse non possono essere riprocessate
                    component.set('v.disableCompleta',true);  
                }
            }         
        }));       
        $A.enqueueAction(action);
    },
    listUtenze : function(component, event){

        var idRecord = component.get('v.recordId');
        component.set('v.showSuccessInsert',false);     
        var action = component.get('c.listUtenzeNominative'); 
        action.setParams({
			caseId: idRecord
        });                
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            console.log('listUtenze state: '+state);
            if (state === "SUCCESS") {     
                var utenzeNomList = response.getReturnValue();
                component.set('v.utenzeNominaliList',utenzeNomList);   
            }         
        }));       
        $A.enqueueAction(action);

    },  
    processActivity : function(component, event){
        var action = component.get('c.process'); 
        var idRecord = component.get('v.recordId');
        console.log('processActivity idRecord: '+idRecord);
        component.set("v.showSpinner", true);
        action.setParams({
			caseId: idRecord
        });                
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            console.log('processActivity state: '+state);
            component.set("v.showSpinner", false);
            if (state === "SUCCESS") {               
                var erroreDematerializzazione = response.getReturnValue();
                // check errore dematerializzazione da mostrare
                if (erroreDematerializzazione!=null && erroreDematerializzazione!='') {
                    component.set('v.errormsg', ' Errore Dematerialiazzazione:'+erroreDematerializzazione);
                    this.showErrorToast(component);
                } else {
                    component.set('v.showSuccessInsert',true);   
                    component.set('v.disableCompleta',true);     
                }
            }         
        }));       
        $A.enqueueAction(action);
    },
    showSuccessToast : function(component) {
        component.find('notifLib').showToast({
            "variant": "success",
            "title": "Success!",
            "message": component.get('v.msg')
        });
    },
    showErrorToast : function(cmp) {
        cmp.find('notifLib').showToast({
            "variant": "error",
            "title": "Error!",
            "message": cmp.get('v.errormsg')
        });
    },   
    loadPDFUtenze : function(component, event){
        var idRecord = component.get('v.recordId');
        component.set("v.showSpinner", true);
        var action = component.get('c.getBase64PDFUtenzeNominative'); 
        action.setParams({
			IdCase: idRecord
        });                
        action.setCallback(this, $A.getCallback(function (response) {
            component.set("v.showSpinner", false);
            var state = response.getState();
            console.log('loadPDFUtenze state: '+state);
            if (state === "SUCCESS") {     
                var bodyPDF = response.getReturnValue();
                component.set('v.bodybase',bodyPDF);   
            }         
        }));       
        $A.enqueueAction(action);

    } 


})