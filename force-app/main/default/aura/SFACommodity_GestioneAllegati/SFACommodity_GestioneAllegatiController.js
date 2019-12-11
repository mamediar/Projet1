({
	init : function(component, event, helper) {
		 helper.doinit(component, event);
	},
	handleUploadFinished : function(component, event, helper) {
        var uploadedFiles = event.getParam("files");
        alert("Files uploaded : " + uploadedFiles.length);
//        helper.handleUploadFinished(component, event);
	}


})