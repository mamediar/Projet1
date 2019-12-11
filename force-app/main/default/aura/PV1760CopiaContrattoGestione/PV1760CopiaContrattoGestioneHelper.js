/**
 * @File Name          : PV1760CopiaContrattoGestioneHelper.js
 * @Description        : 
 * @Author             : Lorenzo Marzocchi
 * @Group              : 
 * @Last Modified By   : Lorenzo Marzocchi
 * @Last Modified On   : 2019-9-20 15:21:38
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    2019-9-17   Lorenzo Marzocchi     Initial Version
**/
({

    init: function (cmp, event, helper) {

        this.mostraAnomalie(cmp, event, helper);
        this.mostraComunicazioniOCS(cmp, event, helper);

    },

    save: function (cmp, event, helper) {

        // controllo di aver selezionato il nuovo stato
        var isValid = this.validateUserInput(cmp, event, helper);

        if (isValid) {
            cmp.set("v.errorMessage", "");
            cmp.get("v.parent").methodShowWaitComponent();
            var action = cmp.get('c.saveCase');
            action.setParam('form',
                {
                    "newStatus": cmp.get('v.newStatus'),
                    "note": cmp.get("v.note"),
                    "attachmentList": cmp.get('v.allegati'),
                    "userData": cmp.get("v.parent").get('v.userData'),

                }
            );
            action.setParam('theCase', cmp.get("v.theCase"));
            // Imposto la Callback
            action.setCallback(this, function (response, helper) {
                if (response.getState() == 'SUCCESS') {
                    //qui mettere Codice se c'è altro da fare in caso di SUCCESS
                }
                else if (response.getState() === "ERROR") {
                }
                cmp.get("v.parent").showToast(response, "", "");
                cmp.get("v.parent").methodHideWaitComponent();
            });
            $A.enqueueAction(action);
        }
    },

    validateUserInput: function (cmp, event, helper) {

        return true;

    },

    mostraAnomalie: function (cmp, event, helper) {

        if (cmp.get("v.theCase.pv_ctr_esiste__c") == '0') {
            cmp.set("v.disabler", true);
        }
        else {
            cmp.set("v.disabler", false);
        }

    },

    mostraComunicazioniOCS: function (cmp, event, helper) {

        //popolo la matrice delle comunicazioni OCS sulla base del prodotto CO\CA altrimenti vuota
        //cmp.set("v.dataList", "");
        var dataList = cmp.get("v.dataList");
        var Tipologia = "";
        var Codice = "";

        if (cmp.get("v.theCase.Tipo_Pratica__c") == 'CO') {

            Tipologia = "Lettera copia contratto non trovata – prestito finalizzato";
            Codice = "5001";
            dataList.push({
                Tipologia: Tipologia,
                Codice: Codice
            });

            Tipologia = "Lettera copia contratto non trovata – prestito personale";
            Codice = "5002";
            dataList.push({
                Tipologia: Tipologia,
                Codice: Codice
            });

            Tipologia = "Mail copia contratto non trovata – prestito finalizzato";
            Codice = "M501";
            dataList.push({
                Tipologia: Tipologia,
                Codice: Codice
            });

            Tipologia = "Mail copia contratto non trovata – prestito personale";
            Codice = "M502";
            dataList.push({
                Tipologia: Tipologia,
                Codice: Codice
            });

        }
        else if (cmp.get("v.theCase.Tipo_Pratica__c") == 'CA') {

            Tipologia = "lettera copia contratto non trovata – carta (bi-contratto)";
            Codice = "KC50";
            dataList.push({
                Tipologia: Tipologia,
                Codice: Codice
            });
            Tipologia = "Lettera copia contratto non trovata – carta";
            Codice = "KC51";
            dataList.push({
                Tipologia: Tipologia,
                Codice: Codice
            });

            Tipologia = "Mail copia contratto non trovata – carta (bi-contratto)";
            Codice = "MC50";
            dataList.push({
                Tipologia: Tipologia,
                Codice: Codice
            });
            Tipologia = "Mail copia contratto non trovata – carta";
            Codice = "MC51";
            dataList.push({
                Tipologia: Tipologia,
                Codice: Codice
            });
        }
        else {
            console.log("matrice vuota");
        }
        cmp.set("v.dataList", dataList);
    },

    handleRowAction: function (cmp, event, helper) {   
        var row = event.getParam('selectedRows')[0];
        cmp.set("v.codOCS",row.Codice);

}


})