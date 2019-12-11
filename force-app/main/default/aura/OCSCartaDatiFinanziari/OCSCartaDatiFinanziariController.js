({
	init : function(cmp, event, helper) {
        let Ucase = cmp.get('v.CaseRecord');
        console.log(Ucase.ActivityType__c);
        if(Ucase.ActivityType__c == 'TMKCC'){
            let action = cmp.get('c.cartaDati');
            action.setParam('numeroPrat',Ucase.NumeroPratica__c);
            action.setCallback(this, function(response) { 
                let state = response.getState(); 
                if (state == 'SUCCESS') {
                    var results = response.getReturnValue(); 
                    console.log(results);
                    cmp.set('v.Numero' , results.datiCartaDatiFinanziariResponse.numeroPratica);
                    cmp.set('v.Disponibilita', results.datiCartaDatiFinanziariResponse.disponibilitaCustom);
                    cmp.set('v.Iban', results.datiCartaDatiFinanziariResponse.iban);
                    cmp.set('v.Prodotto', results.datiCartaDatiFinanziariResponse.desProdotto);
                    cmp.set('v.DataScadenza', results.datiCartaDatiFinanziariResponse.dataScadenzaSlashed);
                    cmp.set('v.ModalitaPagamento', results.datiCartaDatiFinanziariResponse.pagamento);
                    cmp.set('v.Statocarta', results.datiCartaDatiFinanziariResponse.statoCustom);
                    cmp.set('v.ModalitaCalcoloRata', results.datiCartaDatiFinanziariResponse.modCalcoloRataCustom);
                    cmp.set('v.Fido', results.datiCartaDatiFinanziariResponse.fidoCustom);
                    cmp.set('v.StatoRinnovo', results.datiCartaDatiFinanziariResponse.statoRinnovoCustom);
                    let event = $A.get("e.c:eventTelemarketing");
                    event.setParams({'statoCarta': results.datiCartaDatiFinanziariResponse.statoCustom, 
                                        'disp': results.datiCartaDatiFinanziariResponse.disponibilitaCustom,
                                        'stato':results.datiCartaDatiFinanziariResponse.stato,
                                        'NomeProd':results.datiCartaDatiFinanziariResponse.desProdotto,
                                    'fido': results.datiCartaDatiFinanziariResponse.fidoCustom,
                                    'fidoPR': results.datiCartaDatiFinanziariResponse.riservaPrincipaleFido,
                                    'fidoSA': results.datiCartaDatiFinanziariResponse.riservaSalvadanaioFido,
                                    'dispSA': results.datiCartaDatiFinanziariResponse.riservaSalvadanaioDisp    });
                    
                    event.fire();
                
                }

                var sendMsgEvent = $A.get("e.ltng:sendMessage"); 
               
                sendMsgEvent.setParams({
                         "message": "Refresh", 
                         "channel": "TMKTG" 
                }); 
                sendMsgEvent.fire(); 
                console.log("msgEvent FIRE");
               
            }); 
            $A.enqueueAction(action);
        }
    }
})