({
	init: function (component, event, helper) {
        //helper.initForm(component, event);
        helper.preventInit(component, event);
        
        component.set('v.columns', [
            {label: 'Nome Lista', fieldName: 'nome_lista', type: 'text'},
            {label: 'Tipo Attività', fieldName: 'tipo_attivita', type: 'text'},
            {label: 'Name', fieldName: 'Name', type: 'text'},
            {label: 'OCS Code', fieldName: 'OCS_Code__c', type: 'text'},
            {label: 'Partita IVA', fieldName: 'P_IVA__c', type: 'text'},
            {label: 'Codice Fiscale', fieldName: 'CodiceFiscale__c', type: 'text'},
            {label: 'Message Error', fieldName: 'ErrorMessage__c', type: 'text'},
            {label: 'Data Caricamento', fieldName: 'LastModifiedDate', type: 'text'}
        ]);
        component.set("v.data_visibilita", new Date());
        //helper.getListaCheck(component, helper);
    },
    onNext : function(component, event, helper) {        
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber+1);
        helper.getListaCheck(component, helper);
    },
    
    onPrev : function(component, event, helper) {        
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber-1);
        helper.getListaCheck(component, helper);
    },
    onDragOver : function(component, event, helper) {
		event.preventDefault();
	},
    
    onDrop : function(component, event, helper) {
		event.stopPropagation();
        event.preventDefault();
        event.dataTransfer.dropEffect='copy';
        var files=event.dataTransfer.files;
        helper.readFile(component,helper,files[0]);
	},
    
    processFileContent : function(component,event,helper){
        helper.saveRecords(component,event);
    },
    
    cancel : function(component,event,helper){
        component.set("v.showMain",false);
    },
    onFileUploaded:function(component,event,helper){
        var files = component.get("v.fileToBeUploaded");
        if (files && files.length > 0) {
            var file = files[0][0];
            var reader = new FileReader();
            reader.onloadend = function() {
                var dataURL = reader.result;
                var content = dataURL.match(/,(.*)$/)[1];
                helper.readFile(component,helper,file);
            }
            reader.readAsDataURL(file);
            
        }
        else{
            helper.show(component,event);
        }
    },
    onChangeAttivita: function(component,event,helper) {
        var action = component.get("c.getTipologiaAttivitaFromLista");
        component.set('v.tipo_attivita_selezionata', '');
        action.setParams({
            tipo_lista : component.find('tipo_lista').get("v.value")
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //$('.selDiv option[value="'.response.getReturnValue().'"]')
                var x = response.getReturnValue();
            	component.set('v.tipo_attivita_selezionata', response.getReturnValue());
                helper.checkEnableElabora(component);
            }
        });
        var requestInitiatedTime = new Date().getTime();
        $A.enqueueAction(action);
    },
    onCheckEnableElabora: function(component,event,helper) {
        console.log('onCheckEnableElabora');
        helper.checkEnableElabora(component);
    }
})