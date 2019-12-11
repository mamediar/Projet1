({
    validateUserInput: function(component) {
        console.log('[PV2871DuplicatoCarta - validateUserInput]');
        var message = this.checkClienteSelezionato(component);

        if($A.util.isEmpty(message)) {
            message = this.checkPraticaSelezionata(component);
        }

        if($A.util.isEmpty(message)) {
            message = this.checkIndirizzo(component);
        }

        return $A.util.isEmpty(message) ? "" : message;
    },

    onSubtypeSelected: function (component) {
        console.log('[PV2871DuplicatoCarta - onSubtypeSelected]');
        this.clearErrors(component);
        this.setIndirizzoCliente(component);
        this.setDatiDuplicatoCarta(component);
    },

    onReasonSelected: function (component) {
        console.log('[PV2871DuplicatoCarta - onReasonSelected]');
        this.clearErrors(component);
        this.setIndirizzoCliente(component);
        this.setDatiDuplicatoCarta(component);
    },

    onClienteSelected: function (component) {
        console.log('[PV2871DuplicatoCarta - onClienteSelected]');
        this.clearErrors(component);
        this.setIndirizzoCliente(component);
        this.setDatiDuplicatoCarta(component);
    },

    onPraticaSelected: function (component) {
        console.log('[PV2871DuplicatoCarta - onPraticaSelected]');
        this.clearErrors(component);
        this.setIndirizzoCliente(component);
        this.setDatiDuplicatoCarta(component);
    },

    inserisciCase: function (component, event) {
        console.log('[PV2871DuplicatoCarta - inserisciCase]');
        var errorMessage = this.replaceNtoBR(this.validateUserInput(component, event));

        if ($A.util.isEmpty(errorMessage)) {
            //TODO sblocco carta, operazione pre furto, inserisci Case
        }
        else {
            this.mostraErrori(component,errorMessage);
        }
    },

    completaPVForm: function (component, event, helper, PVForm) {
        console.log('[PV2871DuplicatoCarta - completaPVForm] PVForm:', PVForm);
        return PVForm;
    },

    isValid: function(component) {
        var PVForm = component.get("v.PVForm");
        return !$A.util.isEmpty(PVForm)
            && !$A.util.isEmpty(PVForm.sottotipologiaMdt)
            && !$A.util.isEmpty(PVForm.sottotipologiaMdt.uniqueId__c)
            && !$A.util.isEmpty(PVForm.cliente)
            && !$A.util.isEmpty(PVForm.cliente.codCliente)
            && !$A.util.isEmpty(PVForm.pratica)
            && !$A.util.isEmpty(PVForm.pratica.numPratica)
            && PVForm.cliente.codCliente === PVForm.pratica.codCliente;
    },

    checkIndirizzo: function(component) {
        var isValidAddress = component.find("isValidAddress");
        return ($A.util.isEmpty(isValidAddress) || isValidAddress.get("v.value") !== 'YES') ? "Verificare l'indirizzo" : "";
    },

    setIndirizzoCliente: function (component) {
        console.log('[PV2871DuplicatoCarta - setIndirizzoCliente]');

        if (this.isValid(component))
        {
            component.set("v.showDetails", true);
            this.mostraClessidra(component);

            var action = component.get("c.getIndirizziCliente");
            var codCliente = component.get("v.PVForm.cliente.codCliente");

            action.setParams({
                'codiceCliente': codCliente
            });

            action.setCallback(this, function(response) {
                console.log('[PV2871DuplicatoCarta - setIndirizzoCliente] action state:', response.getState());

                if (component.isValid() && response.getState() === "SUCCESS" && response.getReturnValue()) {

                    if(!$A.util.isEmpty(response.getReturnValue())) {
                        var indirizzo = response.getReturnValue().find(function (item) {
                            return !$A.util.isEmpty(item) && item.tipoIndirizzo === 'D' && !$A.util.isEmpty(item.indirizzo);
                        });

                        if($A.util.isEmpty(indirizzo)) {
                            indirizzo = response.getReturnValue().find(function (item) {
                                return !$A.util.isEmpty(item) && item.tipoIndirizzo === 'R' && !$A.util.isEmpty(item.indirizzo);
                            });
                        }

                        console.log('[PV2871DuplicatoCarta - setIndirizzoCliente] indirizzoCliente:', indirizzo);
                        component.set("v.indirizzoCliente", indirizzo);
                    }
                }
                else {
                    this.handleErrors(component, response);
                }

                this.nascondiClessidra(component);
            });

            $A.enqueueAction(action);
        }
        else {
            component.set("v.showDetails", false);
        }
    },

    setDatiDuplicatoCarta: function (component) {
        console.log('[PV2871DuplicatoCarta - setDatiDuplicatoCarta]');

        if (this.isValid(component))
        {
            component.set("v.showDetails", true);
            this.mostraClessidra(component);

            var action = component.get("c.getDatiDuplicatoCarta");
            var numeroCarta = component.get("v.PVForm.pratica.numPratica");

            action.setParams({
                'numeroCarta': numeroCarta
            });

            action.setCallback(this, function(response) {
                console.log('[PV2871DuplicatoCarta - setDatiDuplicatoCarta] action state:', response.getState());

                if (component.isValid() && response.getState() === "SUCCESS" && response.getReturnValue()) {
                    var datiDuplicatoCarta = response.getReturnValue();
                    console.log('[PV2871DuplicatoCarta - setDatiDuplicatoCarta] datiDuplicatoCarta:', datiDuplicatoCarta);

                    if(datiDuplicatoCarta.errore !== true && $A.util.isEmpty(datiDuplicatoCarta.as400Errore) && datiDuplicatoCarta.as400Status === 'OK') {
                        component.set("v.datiDuplicatoCarta", datiDuplicatoCarta);
                    }
                    else {
                        if(!$A.util.isEmpty(datiDuplicatoCarta.as400Errore)) {
                            this.mostraToast(component, 'Attenzione', datiDuplicatoCarta.as400Errore, 'warning', 10000);
                        }
                        else {
                            this.mostraToast(component, 'Attenzione', "E' stato riscontrato un problema con la funzionalità richiesta, contattare l'amministratore.", 'error', 10000);
                        }
                    }
                }
                else {
                    this.handleErrors(component, response);
                }

                this.nascondiClessidra(component);
            });

            $A.enqueueAction(action);
        }
        else {
            component.set("v.showDetails", false);
        }
    },

    clearErrors: function (component) {
        this.mostraErrori(component, "");
        this.showMarkup(component, true);
    },

    handleErrors: function(component, response) {
        if (response && response.getState() === "ERROR") {
            if (response.getError() && Array.isArray(response.getError()) && response.getError().length > 0) {
                console.error(response.getError()[0].message);
            }
        }

        this.mostraErrori(component, "E' stato riscontrato un problema con la funzionalità richiesta, contattare l'amministratore.");
    }
});