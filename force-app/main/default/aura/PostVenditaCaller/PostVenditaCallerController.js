({

    init : function(cmp, event, helper) {
        var mappa = {};
        var caso = cmp.get('v.CaseRecord');
        console.log('Case: ', JSON.stringify(caso));
        if (caso == null)
            alert("Impossibile recuperare il Case");
        else {
            if (caso.Account != null)
                mappa.codClienteOCS = caso.Account.getCodice_Cliente__c;
            // mappa.codPraticaOCS = caso.NumeroPratica__c;
            
            
            mappa.parentId = caso.Id;
        }
        console.log('mappa: ', JSON.stringify(mappa));
        
        var urlEvent = $A.get("e.force:navigateToComponent");
        urlEvent.setParams({
            componentDef: "c:PVInserimento",
            componentAttributes : {
                parametriEsterni : { 
                    "codClienteOCS" : mappa.codClienteOCS,
                    // "codPraticaOCS" : mappa.codPraticaOCS,
                    "parentId" : mappa.parentId
                }
            }
        });
        urlEvent.fire();
	}
})