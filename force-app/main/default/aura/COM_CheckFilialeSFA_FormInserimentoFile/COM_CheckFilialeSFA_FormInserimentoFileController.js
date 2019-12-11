({
	closeModal : function(component, event, helper) {
		var evt = $A.get("e.c:COM_CheckFilialeSFACloseModal_Event");
        evt.setParams({
			showModal: false
        });
        evt.fire();
	},
	onFileUploaded:function(component,event,helper){
        var files = component.get("v.fileToBeUploaded");
        if (files && files.length > 0) {
            var file = files[0][0];
            var reader = new FileReader();
            reader.onloadend = function() {
                var dataURL = reader.result;
                var content = dataURL.match(/,(.*)$/)[1];
                helper.readFile(component,file,helper);
            }
            reader.readAsDataURL(file);
            
        }
        else{
          //  helper.show(component,event);
        }
	},
	cancelUploadedFile : function(component,event,helper){
		component.set('v.fileToBeUploaded',[]);
		component.set("v.filename",'');
		component.set("v.TargetFileName",'');
		component.set('v.cancelUploadFile',true);
		component.set('v.showcConfirm',false);
		component.set('v.errorMsg', '');
               
	},
	confirm : function(component,event,helper){
		var files = component.get("v.fileToBeUploaded");
        if (files && files.length > 0) {
			var file = files[0][0];
			console.log('confirm file:'+file);
		    helper.confirmUpload(component,file,helper);
		}
	},
	doInit : function(component,event,helper){
		var headersList = component.get('v.headerList');
		console.log('headers : '+headersList);
	},
})