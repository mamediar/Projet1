({
	avviaCaricamento : function(component, event, helper) 
    {
        
        var files             = component.get("v.fileToBeUploaded");
        var NoteOutsourcer    = component.get("v.attachment.Note_Outsourcer__c");
        var AnnoDiRiferimento = component.get("v.caricamentoAttachment");
        if( files == null  )
        {
            helper.showToast('Errore', 
                             'Inserire il file obbligatoriamente!', 
                             'errore', null);
            //helper.showToast('Indicare la data e riempire il campo note!','error');
            return;
                
        }
        /*
        if( NoteOutsourcer === undefined || NoteOutsourcer === '' )
        {
            helper.showToast('Errore', 
                             'Inserire le note obbligatoriamente!', 
                             'errore', null);
            return;
        }*/
        
        //alert('------');
        //alert(files.length);
        //alert('NoteOutsourcer->'+NoteOutsourcer);
        //alert('AnnoDiRiferimento->'+AnnoDiRiferimento);return;
        /*
        if( files && files.length > 0 )
        {
        
        /*
        alert('1');
          var validExpense = component.find('caricamentoAttachment').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        // If we pass error checking, do some real work
        if (validExpense) {
            alert('2');*/
            var Attach = component.get("v.attachment");
            //Attach.Note_Outsourcer__c = component.get("v.caricamentoAttachment");
          //  console.log("17_10_2019(---) dealerCorso : "+JSON.stringify(dealerCorso));
            helper.saveRecords(component,helper,event);
        //}
		
	},
    
    doInit : function(component, event, helper) 
    {
        helper.getAnnoRiferimento(component, event);
        helper.setAttachmentObj(component,event);
    },
    fetchSelectAnnoRiferimento: function(component,event,helper){
        var selectedItem = event.getSource().get("v.value");
        console.log('selectedItem->'+selectedItem);
        var AttachmentIVASS = component.get("v.attachment");
        AttachmentIVASS.Anno_di_riferimento__c=selectedItem;
        component.set("v.attachment",AttachmentIVASS);

    },
    onFileUploaded:function(component,event,helper)
    {
        
        var files = component.get("v.fileToBeUploaded");
        if( files && files.length > 0 )
        {
            var file = files[0][0];
            var reader = new FileReader();
            reader.onloadend = function() 
            {
                var dataURL = reader.result;
                var content = dataURL.match(/,(.*)$/)[1];
                helper.readFile(component,helper,file);
            }
            reader.readAsDataURL(file);    
        }else{
            helper.show(component,event);
        } 
    },
    
    UploadFinished : function(component, event, helper) 
    {  
        var uploadedFiles = event.getParam("files");  
        //var documentId = uploadedFiles[0].documentId;  
        //var fileName = uploadedFiles[0].name; 
        helper.getuploadedFiles(component);         
        component.find('notifLib').showNotice({
            "variant": "info",
            "header": "Success",
            "message": "File Uploaded successfully!!",
            closeCallback: function() {}
        });
    }
    
    
})