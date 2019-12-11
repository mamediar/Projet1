({
    helperMethod : function(cmp,row) {
        let tipologia;
        let actionCode;
        let codTMK;
        let codProd;
        let descrizione;
        row.map((attScript)=>{tipologia=attScript.TipoCampagna__c,actionCode=attScript.ActionCode__c,
            codProd = attScript.CodProdLvl2__c, 
            codTMK=attScript.ActionCodeLvl2__c,
            descrizione=attScript.descrizione;});
            let action = cmp.get('c.codProdPadre');
            action.setParams({'codProdFiglio':codProd});
            action.setCallback(this, (response)=>{
                let state = response.getState();
                console.log(state);
                if (state == 'SUCCESS') {
                    let codProdPadre = response.getReturnValue();
                    cmp.set('v.showNewDate', true);
                    cmp.set('v.openForm', true);
                    cmp.set('v.tipologiaSelForNew', tipologia);
                    cmp.set('v.codiceAzioneSelForNew', actionCode);
                    cmp.set('v.codiceProdottoSelForNew',codProd);
                    cmp.set('v.codiceProdottoPadreSelForNew', codProdPadre);
                    cmp.set('v.codiceTMKSelForNew',codTMK);
                    cmp.set('v.descrizioneSelForNew', descrizione);

                }
            });
            $A.enqueueAction(action);

            
    }
})