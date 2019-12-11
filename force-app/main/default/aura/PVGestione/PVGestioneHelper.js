/**
 * @File Name          : PVGestioneHelper.js
 * @Description        : 
 * @Author             : Andrea Vanelli
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 31/10/2019, 14:39:46
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    2019-6-18 11:12:36   Andrea Vanelli     Initial Version
**/
({
    doInitHelper: function (cmp, event, helper) {

        this.showWaitComponent(cmp, helper);


        var action = cmp.get("c.getCaseFields");
        action.setParams({
            "recordId": cmp.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var theCase = response.getReturnValue();
                console.log("ID CAT CASE: "+theCase.Categoria_Riferimento__r.External_Id__c);   
                cmp.set("v.theCase", theCase);
                // decido se deve usare il modulo standard
                var nonStandardPVList = cmp.get("v.nonStandardPVList");
                if (nonStandardPVList.indexOf(theCase.Categoria_Riferimento__r.External_Id__c) > -1) {
                    cmp.set("v.isNonStandardPV", true);
                } else {
                    cmp.set("v.isNonStandardPV", false);
                }
                console.log(nonStandardPVList.indexOf(theCase.Categoria_Riferimento__r.External_Id__c)+" è uno standard pv: "+cmp.get("v.isNonStandardPV")+" step : "+theCase.Step_PV__c);

                //recupero i dati user
                var actionU = cmp.get("c.getUserData");
                actionU.setParams({
                    "queueId": theCase.OwnerId
                });                
                actionU.setCallback(this, function (response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        /*                        setTimeout(function(this)
                                                        {this.doInitHelper2(cmp,response.getReturnValue());},5000
                                                );
                        */
                        cmp.set("v.userData", response.getReturnValue());
                        console.log("***USER  init gestione *** : " + JSON.stringify(cmp.get("v.userData")));

                        // verifico che l'utente possa lavorare il PV in oggetto

                        

                        // Tutto ok 
                       // cmp.set("v.isInitOK", true);

                    } else {
                        console.log("errore chiamata " + actionU);
                    }
                });
                $A.enqueueAction(actionU);


            } else {
                console.log("errore chiamata " + actionU);
            }
            this.hideWaitComponent(cmp, helper);
        });
        $A.enqueueAction(action);
    },
    /*
    onRenderHelper : function(cmp,event,helper) {
        var childComponent = cmp.find('child');
        if ($A.util.isUndefinedOrNull(childComponent)) {
            cmp.set("v.isChildLoaded", false);
        } else  {
            cmp.set("v.isChildLoaded", true);
        }

	},
*/
    callChildMethodHelper: function (cmp, event, helper) {
        console.log("PVGestioneHelper chiama childComponent.save()");
        // controllo i campi comuni
        var isValid = cmp.find('newStatus').checkValidity();
        cmp.find('newStatus').showHelpMessageIfInvalid();
        if (isValid) {
            var childComponent = cmp.find('child');
            cmp.set("v.messaggiErrore", "");
            childComponent.save();
        }

    },


    //funzioni comuni del PV *****************************************************************************
    doShowToast: function (cmp, event) {
        var params = event.getParam('arguments');
        if (params) {
            var response = params.response;
            var header = params.header;
            var message = params.message;
            var duration = 10000;

            var type = "success";
            if (header != '') {
                //messaggio personalizzato senza verifica della response
                type = "info"
            }
            else if (response.getState() == 'SUCCESS') {
                header = "Postvendita";
                message = "Richiesta gestita correttamente. " + message;
            }
            else if (response.getState() === "ERROR") {
                type = "error";
                message = "Errore generico. " + message;
                header = "Postvendita";
                var duration = 60000;
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.error("Error message: " + errors[0].message);
                        message = message + errors[0].message;
                    }
                }
            }
            this.fireToast(header, message, type, duration);

            // gestione uscita
            if (response.getState() == 'SUCCESS') {
                // gestione uscita al termine dell'operatività
                // AV ad oggi facciamo refresh
                var exitMethod = "refresh";

                if (exitMethod == "refresh") {
/*                    $A.get('e.force:refreshView').fire();
                    cmp.set("v.theCase.Status", 'Closed'); */

                    // AV il refresh non ricarica i dati WOW è un open BUG
                    //forzo
                    //location.reload();
                    // AV non va nemmeno il settimout non ricarica il componenete del PV WOW
                    cmp.set("v.theCase.Status", 'Closed'); 
                    setTimeout(() => {
                        $A.get('e.force:refreshView').fire();
                    }, 1000);


                } else if (exitMethod == "") {
                    // nulla scrivo 'gestito correttametne'
                } else {
                    // qualsiasi altro valore signifiva vai a quella pagina
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        'url': exitMethod
                    });
                    urlEvent.fire();
                }


            }

        }
    },

    fireToast: function (header, message, type, duration) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: header,
            message: message,
            duration: duration,
            type: type,
            mode: 'dismissible'
        });
        toastEvent.fire();
    },


    showWaitComponent: function (cmp) {
        //miwaLanciamiRotella: function(cmp,event)
        var spinner = cmp.find('spinnerComponent');
        spinner.incrementCounter();
    },

    hideWaitComponent: function (cmp) {
        var spinner = cmp.find('spinnerComponent');
        spinner.decreaseCounter();
    },
})