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
                 //TODO
                 //update ritorno postale viewd FlagBranchViewed__c


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
    },
    doNext : function(cmp, event, helper) {
        var isError=false
        cmp.find("checkboxRequired").forEach(function(value){ 
            if(!isError) isError=!value.checkValidity(); 
            value.reportValidity() 
         })     
         if(isError) helper.showToast("Dati incompleti" ,'error');
         else {
             //get tipo chiamata
             /*
             if(cmp.get("v.IDMSentValue") ) tipoChiamata="Documentazione reinviata al Cliente" ;
             else if(cmp.get("v.IDMSentValue") ) tipoChiamata="Documentazione Archiviata" ;
             */
            
            //alert( cmp.get("v.reasonValue"));
            // procedi con aggiornamento note            
            var action=cmp.get('c.IDMProcessEsito');
            action.setParams({ caseId : cmp.get("v.recordId"),
                               ritornoPostaleId: cmp.get("v.ritornoPostaleId"),
//                               esito: cmp.get("v.caseRecord.Disposition__r.External_Id__c"),
                                //tipoChiamata:  tipoChiamata,                                    
                               note:cmp.get("v.note")                              
                             });

            action.setCallback(this, function(response) {
               var state = response.getState();
               console.log("STATE "+state);
               if (state === "SUCCESS") {
                   // Alert the user with the value returned 
                   // from the server
                   //alert("From server: " + response.getReturnValue());
                    cmp.set("v.finalResultMessage",response.getReturnValue());
                   // You would typically fire a event here to trigger 
                   // client-side notification that the server-side 
                   // action is complete
               }
               else if (state === "INCOMPLETE") {
                   // do something
               }
               else if (state === "ERROR") {
                   var errors = response.getError();
                   console.log(JSON.stringify(errors));
                   if (errors) {
                       console.log(JSON.stringify(errors));
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
           $A.enqueueAction(action);   
        }

    }

})