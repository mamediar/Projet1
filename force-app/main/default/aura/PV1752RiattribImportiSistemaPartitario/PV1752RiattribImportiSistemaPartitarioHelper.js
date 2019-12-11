/**
 * @File Name          : PV1752RiattribImportiSistemaPartitarioHelper.js
 * @Description        : 
 * @Author             : Andrea Vanelli
 * @Group              : 
 * @Last Modified By   : Andrea Vanelli
 * @Last Modified On   : 4/7/2019, 11:07:04
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    4/7/2019, 11:07:04   Andrea Vanelli     Initial Version
**/
({
	initHelper : function(cmp, event, helper) {
		cmp.set('v.today', $A.localizationService.formatDate(new Date(), "YYYY-MM-DD"));
	},





   /************************/
    /* Gestione Inserimento */
    /************************/

    validateUserInput: function(cmp, event, helper) {
		var messaggi = "";
        messaggi = this.checkPraticaSelezionata(cmp);
        if(messaggi == ""){
			if(cmp.find("importo").get("v.value") == 0 || !cmp.find("importo").checkValidity()){
				cmp.find("importo").showHelpMessageIfInvalid();
				messaggi += "Inserire in importo.\n";
			}		
			if(!cmp.find("dataIncasso").checkValidity()){
				cmp.find("dataIncasso").showHelpMessageIfInvalid();
				messaggi += "Inserire la data di incasso.\n";
			}		
			if(!cmp.find("rataOrigine").checkValidity()){
				cmp.find("rataOrigine").showHelpMessageIfInvalid();
				messaggi += "Inserire la rata di origine.\n";
			}		
			if(!cmp.find("rataDestinazione").checkValidity()){
				cmp.find("rataDestinazione").showHelpMessageIfInvalid();
				messaggi += "Inserire la rata di destinazione.\n";
			}		
			if(!cmp.find("rimborso").checkValidity()){
				cmp.find("rimborso").showHelpMessageIfInvalid();
				messaggi += "Selezionare se necessario un rimborso.\n";
			}	
			else if(cmp.get("v.rimborso") == 'true'){
				if(!$A.util.isUndefinedOrNull(cmp.get("v.modalitaRimborso"))){
					var child = cmp.find("modRimborso");
					child.doValidityCheck();
					messaggi += cmp.get("v.erroriModRimborso");
				}		
			}
		}
		return messaggi;
	},

    completaPVForm: function(cmp, event, helper, PVForm) {
        // arricchisco il PVForm con dati specifici del PV
		PVForm.modalitaRimborso = cmp.get("v.modalitaRimborso");
		PVForm.noteRimborso = cmp.get("v.notaModalitaRimborso");
		PVForm.dataIncasso = cmp.find("dataIncasso").get("v.value");
		PVForm.importo = cmp.find("importo").get("v.value");
		PVForm.hasRimborso = cmp.get("v.rimborso");
		PVForm.rataOrigine = cmp.find("rataOrigine").get("v.value");
		PVForm.rataDestinazione = cmp.find("rataDestinazione").get("v.value");
        return PVForm;
    },

})