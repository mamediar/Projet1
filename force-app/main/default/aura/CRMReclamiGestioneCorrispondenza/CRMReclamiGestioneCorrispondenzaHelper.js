({
	setHeaderColumns: function(component, event, helper) {
        component.set("v.headerColumns", ['Data', 'Utente', 'Testo', 'Allegati']);
    },
    
	getAllNote: function(component, event, helper) {

		var action = component.get('c.getNote'); 
        action.setParams({
        	caseId: component.get("v.recordId")
        });   
        action.setCallback(this, $A.getCallback(function (response) {
			var state = response.getState();
			
            if (state === "SUCCESS") {
				var noteList = response.getReturnValue();
				
                console.log('@@@ noteList: '+noteList.length);
                if(noteList.length>0){
					//component.set("v.noteList", noteList);
					for(var j=0; j<noteList.length; j++){

                        var s = noteList[j].Body;
                        var lngth = [];
                        lngth = s.split(' ');

                        if(lngth.length>25){
                            var finalStr = '';
                            //var ptint = parseInt((lngth.length/2));
                            var ptint = 10;
                            for(var i = 0; i < lngth.length; i++){
                            
                                if(i < ptint){
                                    finalStr+= lngth[i] +' ';
                                }else if(i == (ptint*(i+1))){
                                    finalStr+= lngth[i] +'\n';
                                }else{
                                    finalStr+= lngth[i] +' ';
                                }
                            }

							noteList[j].Body =  finalStr; 
							
                        }
                        
                    }
					component.set("v.noteList", noteList);
					
                }
            } 
        }));
        	
        $A.enqueueAction(action);  

    },
    
	setfileList: function(component, event, helper) {

		var action = component.get('c.getFileNote'); 
        action.setParams({
        	caseId: component.get("v.recordId")
        });   
        action.setCallback(this, $A.getCallback(function (response) {
			var state = response.getState();
			
            if (state === "SUCCESS") {
				var fileNoteList = response.getReturnValue();
				
                console.log('@@@ fileNoteList: '+fileNoteList.length);
                if(fileNoteList.length>0){
					component.set("v.fileList", fileNoteList);
                }
            } 
        }));
        	
        $A.enqueueAction(action);

    },

    insertNewNote: function(component, event, helper) {
        var testoNota = component.find('newTextNote').get('v.value');

        if(testoNota!=null && testoNota!='' && testoNota!=undefined){

            var action = component.get('c.insertNote');

            this.loadSpinner(component);

            action.setParams({
                caseId : component.get("v.recordId"),
                testo : testoNota
            });

            action.setCallback(this, $A.getCallback(function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    component.set("v.toastMsg", "Nota inserita correttamente");
                    this.showToastSuccess(component);
                    
                    console.log('@@@ nota inserita');
                    component.set('v.showInternalModal',false);
                    this.getAllNote(component, event, helper);
                }
                this.hideSpinner(component);
            }));
        	
            $A.enqueueAction(action); 

        }else{
            component.set("v.toastMsg", "Non può essere inserita una nota vuota.");
            this.showToastError(component);
        }
    },

    showToastSuccess: function(component) {
        component.find('notifLib').showToast({
            "title": "Success",
            "message": component.get("v.toastMsg"),
            "variant": "success"
        });
    },
    
    showToastError: function(component) {
        component.find('notifLib').showToast({
            "title": "Errore",
            "message": component.get("v.toastMsg"),
            "variant": "error"
        });
    },

    loadSpinner : function(component, event, helper) {
        console.log('showSpinner');
        component.set("v.showSpinner", true);
    },
    
    hideSpinner : function(component, event, helper) {
        component.set("v.showSpinner", false);
        console.log('hideSpinner');
    }
})