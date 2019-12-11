({
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
        clearErrors: function (component) {
            this.mostraErrori(component, "");
            this.showMarkup(component, true);
        }

    
})