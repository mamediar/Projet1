/**
 * @File Name          : PV2564AzzeramentoSpeseListaHelper.js
 * @Description        : 
 * @Author             : Andrea Vanelli
 * @Group              : 
 * @Last Modified By   : Andrea Vanelli
 * @Last Modified On   : 21/10/2019, 11:27:19
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    3/8/2019, 22:59:20   Andrea Vanelli     Initial Version
**/
({
    init: function (cmp, event, helper) {
//        this.loadSpese(cmp, event, helper);
        var modalita = cmp.get('v.modalita');
        if (modalita == 'gestione') {
            cmp.set("v.mostraSpeseSelezionato", 'SEL');
        }

    },
	showToast : function(message, type){
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			message: message,
			type : type
		});
		toastEvent.fire();
	},    
    svuotaSpese: function (cmp, event, helper) {
        cmp.set('v.speseListCompleta', []);
        this.aggiornaSpeseMostrate(cmp);
    },

    loadSpese: function (cmp, event, helper) {
        var pratica = cmp.get("v.praticaSelezionata");

        if (!$A.util.isUndefinedOrNull(pratica) && pratica.numPratica != '') {

            //cmp.get("v.parent").mostraClessidra();
            var action = cmp.get('c.recuperaSpeseAzzeramentoRecupero');
            action.setParams({
                "numPratica": pratica.numPratica,
                "tipoPratica": pratica.tipoPratica,
                "caseId": cmp.get("v.caseId")
            });
            // Imposto la Callback
            action.setCallback(this, function (response, helper) {
                console.log("recuperaSpeseAzzeramentoRecupero : result : " + JSON.stringify(response.getReturnValue()));
                if (response.getState() == 'SUCCESS') {
                    var result = response.getReturnValue();
                    cmp.set('v.speseListCompleta', result.elencoSpese);
                    this.aggiornaSpeseMostrate(cmp);

                }
                else if (response.getState() === "ERROR") {
                    this.showToast('Errore chiamata recuperaSpeseAzzeramentoRecupero', 'error');
                }
                //cmp.get("v.parent").nascondiClessidra();
            });
            $A.enqueueAction(action);
        } else {
            this.svuotaSpese(cmp,event,helper);
        }

    },



    aggiornaSpeseMostrate: function (cmp, event, helper) {
        var modalita = cmp.get('v.modalita');
        
        var elencoSpese = cmp.get("v.speseListCompleta");
        var filtro = cmp.get("v.mostraSpeseSelezionato");
        var isOK = false;
        // AV TODO prendere ed applicare il filtro
        var speseListFiltrata = [];
        var speseListSelezionate = [];
        elencoSpese.forEach(spesa => {
            /*<option text="tutte le spese" value="ALL" />
            <option text="le spese Azzerabili" value="AZZ" />
            <option text="le spese Annullate" value="ANN" />
            <option text="le spese Selezionate" value="SEL" />            */

            // mi assicuro che se sono in azzeramento totale seleziono quelle buone
            if (modalita == "AZZTOT") {
                if (spesa.statoRecord != "A" && spesa.saldo > 0) {
                    spesa.selezioneOriginale = 'S';
                }
            }

            isOK = false;
            if (filtro == "ALL") {
                isOK = true;
            } else if (filtro == "SEL") {
                if (spesa.selezioneOriginale == 'S') {
                    isOK = true;
                }
            } else if (filtro == "ANN") {
                if (spesa.statoRecord == 'A') {
                    isOK = true;
                }
            } else if (filtro == "AZZ") {
                if (spesa.statoRecord != "A" && spesa.saldo > 0) {
                    isOK = true;
                }
            } else {
    
            }
            if (isOK) {
                if (spesa.selezioneOriginale == 'S') {
                    spesa.showClass = this.coloraCella(spesa.selezioneOriginale );
                    spesa.buttonIcon = "action:delete";
                } else {
                    spesa.buttonIcon = "action:approval";
                    spesa.showClass = "";
                }
                speseListFiltrata = speseListFiltrata.concat(spesa);
            }

            // mostro le selezionate


                if (spesa.selezioneOriginale == 'S') {
                    speseListSelezionate = speseListSelezionate.concat(spesa);
    
                }
    


        });
        cmp.set('v.speseListCompleta', elencoSpese);
        cmp.set('v.speseListFiltrata', speseListFiltrata);
        cmp.set('v.speseListSelezionate', speseListSelezionate);

    },
    coloraCella: function (valore) {
        if (valore == 'S') {
            return 'spesa-selezionata';
        } else {
            return '';
        }

    },


/*
    speseListSelezionateClick :function (cmp, event, helper) {
        var spesaOrigine = event.getParam('selectedRows')[0];
        if (!$A.util.isUndefinedOrNull(spesaOrigine) ) {

            var elencoSpese = cmp.get("v.speseListCompleta");
            // var spesaOrigine = cmp.get("v.speseListFiltrataSelezione");
            elencoSpese.forEach(spesa => {
                if (spesa.customID == spesaOrigine.customID) {
                    spesa.selezioneOriginale = '';
                }
            });
            cmp.set('v.speseListCompleta', elencoSpese);
            this.aggiornaSpeseMostrate(cmp, event, helper);
        }
    },*/

    
    speseListFiltrataClick: function (cmp, event, helper, spesaOrigine) {

        // se siamo in azzeramento totale non fa nulla
        var modalita = cmp.get('v.modalita');
        if (modalita == "AZZTOT") {
            return;
        }


        //var spesaOrigine = event.getParam('selectedRows')[0];
        if (!$A.util.isUndefinedOrNull(spesaOrigine) ) {
            var isOK = true;
            var messaggio = "";
            // verifico se la spesa è selezionabile

            // se stato == A 
            // messaggio errore: le annullate non possono essere selezionate
            if (spesaOrigine.selezioneOriginale == "S") {
                // deseleziono
               spesaOrigine.selezioneOriginale = '';
            } else if (spesaOrigine.statoRecord == "A") {
                isOK = false;
                messaggio = "Le spese annullate non possono essere selezionate";
            } else if (!(spesaOrigine.saldo > 0)) {
                isOK = false;
                messaggio = "Le spese con saldo a 0 non possono essere selezionate";
            } else {
                spesaOrigine.selezioneOriginale = 'S';
            }


            if (isOK) {
                //verifico se la pratica non è già presente in lista
                var elencoSpese = cmp.get("v.speseListCompleta");
                // var spesaOrigine = cmp.get("v.speseListFiltrataSelezione");
                elencoSpese.forEach(spesa => {
                    if (spesa.customID == spesaOrigine.customID) {
                        spesa.selezioneOriginale = spesaOrigine.selezioneOriginale;
                    }
                });
                cmp.set('v.speseListCompleta', elencoSpese);
                this.aggiornaSpeseMostrate(cmp, event, helper);
            } else {
                this.showToast(messaggio, 'error');
            }
        }
    },



    handleRowAction: function (cmp, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'selRecord':
                this.speseListFiltrataClick(cmp, event, helper, row);
                    //  trovo e seleziono/deseleziono (come il clik)
                break;
        }
    }


})