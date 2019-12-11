({
    salvareAppuntamento: function (component, dateRichiamre) {
        var noteRichiamare = component.get("v.richiamarenote");
        var intervista = component.get('v.clienteFuturo');
        intervista.Ultimo_Esito__c = "Richiamare";
        intervista.richiamare_il__c = dateRichiamre;
        intervista.Data_Ultimo_Esito__c = new Date();
        intervista.Note__c = noteRichiamare;
        if (intervista.Ultimo_Esito__c=="Richiamare") {
            var action = component.get('c.updateSobject');
            action.setParam('mySobject', intervista);
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === 'SUCCESS') {
                    var data = response.getReturnValue();
                    component.set("v.clienteFuturo", data);
                    this.showToast("Appuntamento salvato con successo!", "SUCCESS");
                    var eventRefreshIntervista = $A.get("e.c:eventFuturoClientePaginazione");
                    eventRefreshIntervista.setParams({
                        "loadData": true
                    });
                    eventRefreshIntervista.fire();
                } else {
                    this.showToast('Salvataggio non effettuato!', 'ERROR');
                }
            });
            $A.enqueueAction(action);
        }
        else
            this.showToast('Salvataggio non effettuato!', 'ERROR');
    },
    showToast: function (message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            message: message,
            type: type
        });
        toastEvent.fire();
    },
    checkDate: function (component, myDate) {
        try {
            var enteredValue = Date.parse(myDate) / 60000;
            var g = new Date();
            var valueDate = Date.parse(g) / 60000;
            var currentMns = Math.floor(valueDate);
            if (enteredValue < currentMns) {
                this.showToast(
                    "L'appuntamento deve essere fissato dopo l'ora attuale",
                    "ERROR"
                );
                component.set("v.showSave", true);
            } else {
                this.salvareAppuntamento(component, myDate);
            }
            // }
        } catch (e) {
            console.error('error ' + e);
        }
    },
    getNotInterested: function (component) {
        var intervista = component.get('v.clienteFuturo');
        intervista.Ultimo_Esito__c = "Non accetta";
        intervista.COM_Status_FUTURO__c = "Archived";
        intervista.Data_Ultimo_Esito__c = new Date();
        intervista.COM_PraticheChiuse_Conforme__c = 0;
        intervista.COM_ChiusoNon_Conforme__c = 1;
        var action = component.get('c.updateSobject');
        action.setParam('mySobject', intervista);
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var data = response.getReturnValue();
                this.showToast("Appuntamento salvato con successo!", "SUCCESS");
                var eventRefreshIntervista = $A.get("e.c:eventFuturoClientePaginazione");
                eventRefreshIntervista.setParams({
                    "loadData": true
                });
                eventRefreshIntervista.fire();
                component.set('v.clienteFuturo', data);
            } else {
                this.showToast('Salvataggio non effettuato!', 'ERROR');
            }
        });
        $A.enqueueAction(action);
    }
})