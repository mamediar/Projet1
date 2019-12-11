({
    init : function(component, event, helper) {
        
        helper.setTableError(component);
        var action = component.get("c.listTipiFile");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var listTipiFile = response.getReturnValue();
                component.set("v.tipologia_lista",listTipiFile);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                console.log("ERROR"+errors);
            }
        });
        $A.enqueueAction(action);
    },
    selectedTipoFile : function(component, event, helper) {
		helper.getSelectProdottoByTipoFile(component,event);
    },
    selectedProdotto : function(component, event, helper) {
		helper.showUploadSection(component,event);
    },
    onFileUploaded:function(component,event,helper){
        component.set('v.showSectionError', false);
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
    cancel : function(component,event,helper){
        component.set("v.showMain",false);
        component.set('v.showSectionError', false);
        component.set('v.showConfirm', false);
        component.set('v.disableSelect', false);
        component.set('v.fileToBeUploaded', null);     
    },
    processFileContent : function(component,event,helper){
        var data = component.get("v.fileContentData");
        helper.checkRecords(component,data,helper);
    },
    onDragOver : function(component, event, helper) {
		event.preventDefault();
	},
    
    onDrop : function(component, event, helper) {
        component.set('v.showSectionError', false);
        component.set('v.showConfirm', false);
        component.set('v.disableSelect', false);
		event.stopPropagation();
        event.preventDefault();
        event.dataTransfer.dropEffect='copy';
        var files=event.dataTransfer.files;
        helper.readFile(component,helper,files[0]);
    },
    confirm : function(component,event,helper){
		var files = component.get("v.fileToBeUploaded");
        if (files && files.length > 0) {
			var file = files[0][0];
            console.log('confirm file:'+file);
            component.set('v.disableSelect', false);
		    helper.confirmUpload(component,file,helper);
		}
    },
    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');

        switch (action.name) {
            case 'show_details':
            helper.showModalRow(component,row);    
            break;
        }
    },
    closeModal : function(component, event, helper) {
        component.set('v.showModal',false);
    }
})