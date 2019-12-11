({
	init : function(cmp, event, helper) {
        helper.handleInit(cmp);
		
	},
    
    esita: function(cmp, event, helper) {
        helper.esita(cmp);
		
	},
    
    setSelectedCase : function (cmp,event,helper) {
        var caseTemp = cmp.find('inadempimenti-datatable').getSelectedRows()[0];
        helper.loadCaseHelper(cmp, caseTemp);
    },

    handleUploadFinished: function(cmp,event,helper) {
        cmp.set('v.msg', 'File aggiunto correttamente');
        helper.showSuccessToast(cmp);
        helper.getFiles(cmp);
    },

    handleLoad: function(cmp,event,helper) {
        cmp.set('v.noteValue', null);
        //helper.assignToCentroRecuperoLegale(cmp);
    },

    handleSuccess: function(cmp,event,helper) {
        cmp.set('v.msg', 'valutazione inviata correttamente');
        helper.assignToCentroRecuperoLegale(cmp);
        helper.showSuccessToast(cmp);
        
    },

    handleSubmit: function(cmp,event,helper) {
        helper.showSpinner(cmp);
        helper.saveAttachments(cmp);
    }
})