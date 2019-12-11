({
    validateUserInput: function (cmp, event, helper) {
        var messaggi = "";
        messaggi += this.checkClienteSelezionato(cmp);
        if (messaggi == "") {
            var dest = cmp.get("v.value");
            if ($A.util.isUndefinedOrNull(dest)) {
                messaggi += "Selezionare un'opzione di carta sostitutiva";
            }
        }
        return messaggi;
    },

    completaPVForm: function (cmp, event, helper, PVForm) {
        // arricchisco il PVForm con dati specifici del PV
        var indirizzo = '';
        indirizzo = PVForm.cliente.indirizzo + " " + PVForm.cliente.cap + " " + PVForm.cliente.provincia + " " + PVForm.cliente.localita + " ";
        console.log("indirizzo " + indirizzo);
        PVForm.indirizzo = indirizzo;
        return PVForm;
    }
})