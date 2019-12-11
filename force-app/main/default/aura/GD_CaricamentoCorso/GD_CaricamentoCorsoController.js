({

    /**
     * @description : To show Toast
     * @author: Mady COLY
     * @date: 30/07/2019
     * @param :message
     * @param :type
     */
    showToast: function(message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            message: message,
            type: type
        });
        toastEvent.fire();
    },
    /**
     * @description : init a data of component
     * @author: Mady COLY
     * @date: 30/07/2019
     */
    doInit: function(component, event, helper) {
        helper.getAllAggiungiCorso(component, event);
        helper.getAllTipologiaCorso(component, event);
        helper.getAnnoRiferimento(component, event);
        helper.getAllDealerCourses(component, event);
        helper.getQueueIVASS(component, event);
    },
    /**
     * @description : init a data of component
     * @author: Mady COLY
     * @date: 30/07/2019
     */
    avviaCaricamento: function(component, event, helper) {
        var validExpense = component.find('caricamentoCorso').reduce(function(validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        // If we pass error checking, do some real work
        if (validExpense) {
            var dealerCorso = component.get("v.dealerCorso");
            console.log("17_10_2019(---) dealerCorso : " + JSON.stringify(dealerCorso));
            helper.saveRecords(component, helper, event);
        }

    },
    fetchSelectAggiguinti: function(component, event, helper) {
        var selectedItem = event.getSource().get("v.value");
        if (selectedItem == "Nuovo corso") {
            component.set("v.dealerCorso", {
                'sobjectype': 'IVASS_Dealer_Courses__c',
                'Name': '',
                'Anno_di_Riferimento__c': '',
                'Attivo__c': '',
                'Caricate__c': '',
                'Codice_Assofin__c': '',
                'Descrizione_Corso__c': '',
                'Percentuale_Terminata__c': '',
                'Tipo_Corso__c': '',
            });
            component.set("v.nuovoCorso", true);
            component.set("v.showRequired", true);
        } else {
            component.set("v.nuovoCorso", false);
            component.set("v.showRequired", false);
            var dealerCoursesList = component.get("v.dealerCoursesList");
            dealerCoursesList.forEach(function(element) {
                if (element.Id == selectedItem) {
                    component.set("v.dealerCorso", element);
                    console.log('element : ' + JSON.stringify(element));
                    component.set("v.labelTipologiaCorso", element.Tipo_Corso__r.Type_Course_Name__c);
                    component.set("v.selectAnnoRiferimento", element.Anno_di_Riferimento__c);

                }
                //alert("element : "+JSON.stringify(element));
            });
        }
    },
    fetchSelectTipologia: function(component, event, helper) {
        var selectedItem = event.getSource().get("v.value");
        var IDQueue = component.get("v.IDQueueIVASS");
        var dealerCorso = component.get("v.dealerCorso");
        dealerCorso.Tipo_Corso__c = selectedItem;
        dealerCorso.OwnerId = IDQueue;
        component.set("v.dealerCorso", dealerCorso);
    },
    fetchSelectAnnoRiferimento: function(component, event, helper) {
        var selectedItem = event.getSource().get("v.value");
        component.set('v.selectAnnoRiferimento', selectedItem);
        var dealerCorso = component.get("v.dealerCorso");
        dealerCorso.Anno_di_Riferimento__c = selectedItem;
        component.set("v.dealerCorso", dealerCorso);
    },
    handleFilesChange: function(component, event, helper) {
        var fileName = 'No File Selected..';
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];

        }
        component.set("v.fileName", fileName);
    },
    onFileUploaded: function(component, event, helper) {
        var files = component.get("v.fileToBeUploaded");
        if (files && files.length > 0) {
            var file = files[0][0];
            var reader = new FileReader();
            reader.onloadend = function() {
                var dataURL = reader.result;
                var content = dataURL.match(/,(.*)$/)[1];
                helper.readFileCorsi(component, helper, file);
            }
            reader.readAsDataURL(file);

        } else {
            helper.show(component, event);
        }
    },
    onFileUploadCorsi: function(component, event, helper) {
        var files = component.get("v.fileCorsi");
        if (files && files.length > 0) {
            var file = files[0][0];
            var reader = new FileReader();
            reader.onloadend = function() {
                var dataURL = reader.result;
                var content = dataURL.match(/,(.*)$/)[1];
                helper.readFileCorsi(component, helper, file);
            }
            reader.readAsDataURL(file);

        } else {
            helper.show(component, event);
        }
    },
})