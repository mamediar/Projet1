/**
 * @File Name          : PV1757RimborsoClienteSaldoRossoHelper.js
 * @Description        : 
 * @Author             : Andrea Vanelli
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 22/10/2019, 10:09:19
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    4/7/2019, 11:07:20   Andrea Vanelli     Initial Version
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
			//Indicizzo le variabili necessarie al test di validazione
			if(!cmp.find("importo").checkValidity() || cmp.find("importo").get('v.value') == '0'){	//auraMethod checkValidity
				cmp.find("importo").showHelpMessageIfInvalid();
				messaggi += "Inserire un importo.\n";
			}	
			//if(cmp.find("provenienzaSaldo").get("v.value") == undefined){
			if(!cmp.find("provenienzaSaldo").checkValidity()){	
				cmp.find("provenienzaSaldo").showHelpMessageIfInvalid();
				messaggi += "Indicare se il saldo rosso è stato generato da un incasso rid.\n";
			}else if(cmp.find("provenienzaSaldo").get("v.value") == "true"){
				//verifico data del rid
				/*if(cmp.get("v.dataRid") == "" || cmp.get("v.dataRid") == null){
					errori += "Indicare la data del rid.\n";
				}*/			
				if(!cmp.find("dataRid").checkValidity()){
					cmp.find("dataRid").showHelpMessageIfInvalid();
					messaggi += "Indicare la data del rid.\n";
				}		
			}
			var child = cmp.find("modRimborso");
			child.doValidityCheck();
			messaggi += cmp.get("v.erroriModRimborso");
        }    
		return messaggi;
    },

    completaPVForm: function(cmp, event, helper, PVForm) {
		// arricchisco il PVForm con dati specifici del PV
		PVForm.modalitaRimborso = cmp.get("v.modalitaRimborso");
		PVForm.noteRimborso = cmp.get("v.notaModalitaRimborso");
		if(!$A.util.isUndefinedOrNull(cmp.find("dataRid"))){
			PVForm.dataRid = cmp.find("dataRid").get("v.value");
		}else{
			//PVForm.dataRid = "";
		}
		PVForm.importo = cmp.find("importo").get("v.value");
        return PVForm;
	},
})