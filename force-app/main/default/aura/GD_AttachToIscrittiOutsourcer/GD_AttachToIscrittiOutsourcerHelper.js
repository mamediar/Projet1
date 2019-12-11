({
    
    MAX_FILE_SIZE: 45000000000, /* 6 000 000 * 3/4 to account for base64 */
    CHUNK_SIZE: 950000, /* Use a multiple of 4 */


    getAnnoRiferimento : function(component,event) 
    {
    
        var annoRiferimento=[];
        var dateToday = new Date();
        var datelastYear = new Date();
        var dateNextYear = new Date();
        dateNextYear.setFullYear(dateNextYear.getFullYear()+1);
        datelastYear.setFullYear(datelastYear.getFullYear()-1);
        annoRiferimento.push(datelastYear.getFullYear());
        annoRiferimento.push(dateToday.getFullYear());
        annoRiferimento.push(dateNextYear.getFullYear());
        component.set("v.annoRiferimento",annoRiferimento);    
    },
    
    setAttachmentObj : function(component,event)
    {
        var AttObj = component.get("v.attachment");
        AttObj.Anno_di_riferimento__c     = '2018';
        component.set("v.attachment",AttObj);
    },
    
    readFile : function(component,helper,file) 
    {
        if (!file) return;
        console.log('25_10_2019 file'+file.name);
     
        var reader = new FileReader();
            reader.onerror =function errorHandler(evt) 
            {
                switch(evt.target.error.code) 
                {
                    case evt.target.error.NOT_FOUND_ERR:
                        console.log('File Not Found!');
                        break;
                    case evt.target.error.NOT_READABLE_ERR:
                        console.log('File is not readable');
                        break;
                    case evt.target.error.ABORT_ERR:
                        break; // noop
                    default:
                        console.log('An error occurred reading this file.');
                };
            }
            //reader.onprogress = updateProgress;
            reader.onabort = function(e) {
                console.log('File read cancelled');
            };
             
                var output = '<ui type=\"disc\"><li><strong>'+file.name +'</strong> '+file.size+'bytes</li></ui>';
                console.log('25_10_2019 output'+output);
                component.set("v.filename",file.name);
                component.set("v.TargetFileNameCorsi",output);
               
           
            
         //   reader.readAsText(file);
        
       
       // reader.readAsDataURL(file);

        
    },
    
    saveRecords : function(component,helper,event)
    {
        
        
        //tachmentIVassObject.Status__c     = '';
        //sert AttachmentIVassObject;
        
       // var fileInput = component.find("file").getElement();
        var att = component.get("v.attachment");
        //alert(JSON.stringify(att));
        //return;
        
        var fileInput = component.get("v.fileToBeUploaded");
        var file = fileInput[0][0];

        var fr = new FileReader();

        var self = this;
        fr.onload = function () {
            var fileContents = fr.result;
         var base64Mark = 'base64,';
        var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;

        fileContents = fileContents.substring(dataStart);

            self.upload(component, file, fileContents,att);
        };

        fr.readAsDataURL(file);
        
        
        
        /*
        var action = component.get("c.processData");
            action.setParams({ processData : component.get("v.fileContentData"),
                                 AttachmentIscritto : component.get("v.attachment")});
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    alert('--1');
                    
                }
                else if (state === "INCOMPLETE") {
                    //console.log('saved successfully');
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                     errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
               // var status=false;
            });
            $A.enqueueAction(action);
            */
    } ,
    
     upload: function (component, file, fileContents,att) {
        var fromPos = 0;
        var toPos = Math.min(fileContents.length, fromPos + this.CHUNK_SIZE);

        // start with the initial chunk
        this.uploadChunk(component, file, fileContents, fromPos, toPos, '', att);
    },
    uploadChunk: function (component, file, fileContents, fromPos, toPos, attachId,att) {
        console.log('uploadChunk');
        var action = component.get("c.saveTheChunk");
        var chunk = fileContents.substring(fromPos, toPos);

        action.setParams({
            parentId: component.get("v.recordId"),
            fileName: file.name,
         base64Data: encodeURIComponent(chunk),
    //      base64Data: chunk,
            contentType: file.type,
            fileId: attachId,
            AttachmentIscritto: att
        });

        var self = this;
        action.setCallback(this, function (a) {

            console.log('uploadChunk: Callback');
            attachId = a.getReturnValue();

            fromPos = toPos;
            toPos = Math.min(fileContents.length, fromPos + self.CHUNK_SIZE);

            if (fromPos < toPos) {
                self.uploadChunk(component, file, fileContents, fromPos, toPos, attachId);
            } else {
                console.log('uploadChunk: done');
                self.showToast('Upload Complete', 'You file has successfully uploaded, please upload another now.', 'success', null);
                $A.get('e.force:refreshView').fire();

            }
        });

        $A.getCallback(function () {
            $A.enqueueAction(action);
        })();
    },
    showToast: function (title, message, type, icon) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: title,
            message: message,
            duration: '2000',
            key: icon,
            type: type,
            mode: 'dismissible'
        });
        toastEvent.fire();
    },
    
    getuploadedFiles:function(component){
        var action = component.get("c.getFiles");  
        action.setParams({  
            "recordId":component.get("v.recordId")  
        });      
        action.setCallback(this,function(response){  
            var state = response.getState();  
            if(state=='SUCCESS'){  
                var result = response.getReturnValue();           
                component.set("v.files",result);  
            }  
        });  
        $A.enqueueAction(action);  
    }
})