({
    validateUserInput: function(component) {
        console.log('[PV3255InserimentoAnnulloBlocco - validateUserInput]');
        var message = this.checkClienteSelezionato(component);

        if($A.util.isEmpty(message)) {
            message = this.checkPraticaSelezionata(component);
        }

        if($A.util.isEmpty(message)) {
           message = this.checkBloccoSelezionato(component);
        }

        return $A.util.isEmpty(message) ? "" : message;
    },

    onSubtypeSelected: function (component) {
        console.log('[PV3255InserimentoAnnulloBlocco - onSubtypeSelected]');
        this.clearErrors(component);
        this.getBlocchiCarte(component);
    },

    onReasonSelected: function (component) {
        console.log('[PV3255InserimentoAnnulloBlocco - onReasonSelected]');
        this.clearErrors(component);
        this.getBlocchiCarte(component);
    },

    onClienteSelected: function (component) {
        console.log('[PV3255InserimentoAnnulloBlocco - onClienteSelected]');
        this.clearErrors(component);
        this.getBlocchiCarte(component);
    },

    onPraticaSelected: function (component) {
        console.log('[PV3255InserimentoAnnulloBlocco - onPraticaSelected]');
        this.clearErrors(component);
        this.getBlocchiCarte(component);
    },

    inserisciCase: function (component, event) {
        console.log('[PV3255InserimentoAnnulloBlocco - inserisciCase]');
        var errorMessage = this.replaceNtoBR(this.validateUserInput(component, event));

        if ($A.util.isEmpty(errorMessage)) {
            this.bloccoSbloccoCarta(component, event);
        }
        else {
            this.mostraErrori(component,errorMessage);
        }
    },

    completaPVForm: function (component, event, helper, PVForm) {
        console.log('[PV3255InserimentoAnnulloBlocco - completaPVForm] PVForm:', PVForm);
        var listaBlocchi = component.get("v.blocchiCarte");
        var bloccoSelezionatoKeyCode = component.find('blocchiCarte').get("v.value");

        if(!$A.util.isEmpty(listaBlocchi)) {
            PVForm.bloccoCarta = listaBlocchi.find(function (item) { return item.keyCode === bloccoSelezionatoKeyCode;});
        }
        else {
            PVForm.bloccoCarta = {'keyCode': null, 'descrizione': null, 'valore': null};
        }

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

    checkBloccoSelezionato: function(component) {
        var message = "";
        var blocchiCarte = component.find('blocchiCarte');

        if($A.util.isEmpty(component.get("v.blocchiCarte"))) {
            message = 'Non sono presenti blocchi'
        }
        else if(blocchiCarte == null || blocchiCarte.checkValidity() !== true || $A.util.isEmpty(blocchiCarte.get("v.value"))) {
            message = 'Selezionare un blocco'
        }

        return message;
    },

    getBlocchiCarte: function (component) {
        console.log('[PV3255InserimentoAnnulloBlocco - getBlocchiCarte]');
        component.set("v.blocchiCarte", []);

        if (this.isValid(component))
        {
            component.set("v.showDetails", true);
            this.mostraClessidra(component);

            var action = component.get("c.getBlocchiCarte");
            var numeroCarta = component.get("v.PVForm.pratica.numPratica");
            var sottoTipologia = component.get('v.PVForm.sottotipologiaMdt.uniqueId__c');

            action.setParams({
                'numeroCarta': numeroCarta,
                'filtroBlocchi': '',
                'sottoTipologia': sottoTipologia
            });

            action.setCallback(this, function(response) {
                console.log('[PV3255InserimentoAnnulloBlocco - getBlocchiCarte] action state:', response.getState());

                if (component.isValid() && response.getState() === "SUCCESS" && response.getReturnValue()) {
                    component.set("v.blocchiCarte", response.getReturnValue());
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

    bloccoSbloccoCarta: function (component, event) {
        console.log('[PV3255InserimentoAnnulloBlocco - bloccoSbloccoCarta]');
        this.mostraClessidra(component);

        var action = component.get("c.bloccoSbloccoCarta");
        var numeroCarta = component.get("v.PVForm.pratica.numPratica");
        var tipoOperazione = component.get('v.PVForm.sottotipologiaMdt.uniqueId__c') === 116 ? 'I' : component.get('v.PVForm.sottotipologiaMdt.uniqueId__c') === 117 ? 'A' : null;
        var bloccoCarta = component.find('blocchiCarte').get("v.value");
        var utente = '';

        action.setParams({
            'numeroCarta': numeroCarta,
            'tipoOperazione': tipoOperazione,
            'bloccoCarta': bloccoCarta,
            'utente': utente
        });

        action.setCallback(this, function(response) {
            console.log('[PV3255InserimentoAnnulloBlocco - bloccoSbloccoCarta] action state:', response.getState());

            if (component.isValid() && response.getState() === "SUCCESS" && response.getReturnValue()) {
                var result = response.getReturnValue();
                console.log('[PV3255InserimentoAnnulloBlocco - bloccoSbloccoCarta] result:', result);

                if(result && $A.util.isEmpty(result.as400Errore) && result.as400Status !== 'KO') {
                    //this.mostraToast(component, tipoOperazione === 'I' ? ('Inserimento blocco ' + result.bloccoCarta) : 'Annullo blocco', 'Operazione completata', 'success', 10000);
                    //this.getBlocchiCarte(component);
                    this.conferma(component, event);
                }
                else {
                    this.mostraToast(component, 'Attenzione', result.as400Errore, 'warning', 10000);
                }
            }
            else {
                this.handleErrors(component, response);
            }

            this.nascondiClessidra(component);
        });

        $A.enqueueAction(action);
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