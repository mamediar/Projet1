({
    doInit : function(cmp, event, helper) {
       //get ritorno postale id
        var action=cmp.get('c.getRitornoPostale');
        action.setParams({ caseId:cmp.get("v.recordId")})
        action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    // Alert the user with the value returned 
                    // from the server
                    //alert("From server: " + response.getReturnValue());
    				cmp.set("v.ritornoPostaleId",response.getReturnValue())
                    // You would typically fire a event here to trigger 
                    // client-side notification that the server-side 
                    // action is complete
                }
                else if (state === "INCOMPLETE") {
                    // do something
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                     errors[0].message);
                            alert("Error message: " + errors[0].message)
                        }
                    } else {
                        console.log("Unknown error");
                        alert("GENERIC ERROR on INIT");
                    }
                }
            });
    
            // optionally set storable, abortable, background flag here
    
            // A client-side action could cause multiple events, 
            // which could trigger other events and 
            // other server-side action calls.
            // $A.enqueueAction adds the server-side action to the queue.
            $A.enqueueAction(action);   
            

            //determino se utente è filiale
        var action2=cmp.get('c.isFiliale');        
        action2.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    // Alert the user with the value returned 
                    // from the server
                    //alert("From server: " + response.getReturnValue());
                    cmp.set("v.isFiliale",response.getReturnValue());
                                        
                    var options = cmp.get("v.radioGroupPhoneResultOption");
                    if(response.getReturnValue()){
                        
                        cmp.set("v.radioGroupCallTypeValue","Outbound");
                        options.length = options.length - 1;
                        cmp.set("v.radioGroupPhoneResultOption", options);
                        
                    } else {
                        //se non è filiale deve richiamare RitorniPostaliEventsManager x determinare cosa mostrare
                        helper.eventManager(cmp);
                    }
                    // You would typically fire a event here to trigger 
                    // client-side notification that the server-side 
                    // action is complete
                }
                else if (state === "INCOMPLETE") {
                    // do something
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                     errors[0].message);
                            alert("Error message: " + errors[0].message)
                        }
                    } else {
                        console.log("Unknown error");
                        alert("GENERIC ERROR on INIT");
                    }
                }
            });
    
            // optionally set storable, abortable, background flag here
    
            // A client-side action could cause multiple events, 
            // which could trigger other events and 
            // other server-side action calls.
            // $A.enqueueAction adds the server-side action to the queue.
            $A.enqueueAction(action2);    
                         
        
    },
    doNext:function (cmp,evt,helper){
        var isError=false
        console.log("doNext");    
        if(Array.isArray(cmp.find("radioGroupRequired")))  {          
            cmp.find("radioGroupRequired").forEach(function(value){ 
                if(!isError) isError=!value.checkValidity(); 
                value.reportValidity() 
            })     
        }
        else {
            var cmpValue=cmp.find("radioGroupRequired");
            if(!isError) isError=!cmpValue.checkValidity(); 
            cmpValue.reportValidity() 
        }
         if(isError) helper.showToast("Dati incompleti" ,'error');
         else {
             //save address
             helper.handleAddressSubmit(cmp);
             //alert( cmp.get("v.reasonValue"));
             // procedi con aggiornamento note
             var action=cmp.get('c.CreateNote');
             
             var esito=(cmp.get("v.radioGroupCallTypeValue")=="Inbound" || cmp.get("v.radioGroupResultValue")=='Appointment' ) ? cmp.get("v.radioGroupResultValue") : cmp.get("v.radioGroupResultValue1") ;

             console.log('ESITO value1 '+cmp.get("v.radioGroupResultValue")+' value2 '+cmp.get("v.radioGroupResultValue1")+ ' FINAL '+esito);
             action.setParams({ caseId : cmp.get("v.recordId"),
                                ritornoPostaleId: cmp.get("v.ritornoPostaleId"),
                               esito: esito,
                               esitoPositive: cmp.get("v.reasonValue"),
                               //sendCopy: cmp.get("v.caseRecord.Categoria_Riferimento__r.External_Id__c")=='2272'
                               sendCopy: cmp.get("v.radioGroupDocCopyValue"),
                               note: cmp.get("v.note"),
                               interlocutore: cmp.get("v.radioGroupCallPersonValue"),
                               interlocutoreAltro: cmp.get("v.interlocutoreAltro"),
                               tipoChiamata: cmp.get("v.radioGroupCallTypeValue"),
                               userDateTime: cmp.get("v.userDateTime")                               
                              });

             action.setCallback(this, function(response) {
                 console.log('enter in callback');
                var state = response.getState();
                console.log('state request '+state);
                if (state === "SUCCESS") {
                    console.log('SUCCESS');
                    // Alert the user with the value returned 
                    // from the server
                   // alert("From server: " + response.getReturnValue());
                    cmp.set("v.finalResultMessage",response.getReturnValue());
                    // You would typically fire a event here to trigger 
                    // client-side notification that the server-side 
                    // action is complete
                }
                else if (state === "INCOMPLETE") {
                    // do something
                    alert("request status INCOMPLETE");
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    console.log('ERRORS '+JSON.stringify(errors));
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                     errors[0].message);
                            alert("Error message: " + errors[0].message)
                        }
                    } else {
                        console.log("Unknown error");
                        alert("GENERIC ERROR on NEXT Button");
                    }
                }
            });
    
            // optionally set storable, abortable, background flag here
    
            // A client-side action could cause multiple events, 
            // which could trigger other events and 
            // other server-side action calls.
            // $A.enqueueAction adds the server-side action to the queue.
            $A.enqueueAction(action);
            console.log('called');
 
         }
    },
    checkDate: function (component, event, helper) {
        var target = event.getSource();       
        try {
            var enteredValue = target.get("v.value");
            enteredValue = Date.parse(enteredValue);
            var g = new Date();
            g = g.setMinutes(g.getMinutes() + 10 );
            if ( enteredValue < g ) {
                helper.showToast(
                  "L'appuntamento deve essere fissato dopo l'ora attuale",
                  "ERROR"
                );
                //component.set("v.showSave",true);

            } else {
                //component.set("v.showSave",false);
            }
            // }
        } catch (e) {
            console.error('error '+ e);
        }
    }    

})