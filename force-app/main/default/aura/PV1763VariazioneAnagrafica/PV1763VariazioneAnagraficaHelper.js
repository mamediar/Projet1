/**
 * @File Name          : PV1763VariazioneAnagraficaHelper.js
 * @Description        : 
 * @Author             : Andrea Vanelli
 * @Group              : 
 * @Last Modified By   : Andrea Vanelli
 * @Last Modified On   : 4/7/2019, 11:08:12
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    2019-6-19 14:55:11   Andrea Vanelli     Initial Version
**/
({
    init: function (cmp, event, helper) {
        this.showMarkup(cmp, false);
       	cmp.set('v.today', $A.localizationService.formatDate(new Date(), "YYYY-MM-DD"));
        cmp.set('v.todayPlus15Y', $A.localizationService.formatDate(new Date().setFullYear(new Date().getFullYear() + 15), "YYYY-MM-DD"));
    },
    
    /********************/
    /* EVENTI           */
    /********************/

    //checkClienteSelected: function (cmp, event, helper) {
    onClienteSelected: function (cmp, event, helper) {
        console.log('reson: ' + JSON.stringify(cmp.get("v.PVForm.reasonMdt")));
        this.clearFields(cmp);
        if(this.checkClienteSelezionato(cmp) == "" && !$A.util.isUndefinedOrNull(cmp.get('v.PVForm.sottotipologiaMdt'))){
            var sottotipologiaMdt = cmp.get('v.PVForm.sottotipologiaMdt');
            //vado a verificare i dati del cliente in base ai suoi dati attuali e alla selezione della subtype
            var action=cmp.get('c.doCheck');
            action.setParams({
                "cliente" : cmp.get("v.PVForm.cliente"),
                "sottotipologiaInput" : sottotipologiaMdt.Descrizione__c
            });   
            action.setCallback(this,function(response){
                if(response.getState()=='SUCCESS'){
                    if(response.getReturnValue().isErroreBloccante){
                        this.showMarkup(cmp,false);
                    }else{
                        //setto l'obbligatorietà dell'allegato dal subtype
                        /*if(sottotipologiaMdt.uniqueId__c==144){
                            //remmo altrimenti non passa alla validazione del PV
                            //cmp.set("v.PVForm.categoriaPV.Flag_Mostra_Allegati__c","REQUIRED");
                            cmp.set("v.PVForm.categoriaPV.Flag_Mostra_Allegati__c", "OPTIONAL");
                        }else{
                            cmp.set("v.PVForm.categoriaPV.Flag_Mostra_Allegati__c", "OPTIONAL");
                        }*/

                        //setto i valori originali
                        cmp.set("v.denominazioneAziendaOrig",cmp.get("v.PVForm.cliente.denominazioneAzienda"));
                        cmp.set("v.formaGiuridicaOrig",cmp.get("v.PVForm.cliente.formaGiuridica"));
                        cmp.set("v.cognomeOrig",cmp.get("v.PVForm.cliente.cognome"));
                        cmp.set("v.nomeOrig",cmp.get("v.PVForm.cliente.nome"));
                        cmp.set("v.codFiscaleOrig",cmp.get("v.PVForm.cliente.codFiscale"));
                        cmp.set("v.sessoOrig",cmp.get("v.PVForm.cliente.sesso"));
                        cmp.set("v.dataNascitaOrig",cmp.get("v.PVForm.cliente.dataNascitaDate"));
                        cmp.set("v.provNascitaOrig",cmp.get("v.PVForm.cliente.provNascita"));
                        cmp.set("v.luogoNascitaOrig",cmp.get("v.PVForm.cliente.luogoNascita"));
                        cmp.set("v.pivaOrig",cmp.get("v.PVForm.cliente.piva"));
                        cmp.set("v.tipoAnagraficaOrig",cmp.get("v.PVForm.cliente.tipoAnagrafica"));
                        cmp.set("v.tipoDocumentoOrig",cmp.get("v.PVForm.cliente.tipoDocumento"));
                        cmp.set("v.numDocumentoOrig",cmp.get("v.PVForm.cliente.numDocumento"));        
                        cmp.set("v.dataRilascioOrig",cmp.get("v.PVForm.cliente.dataRilascioDate"));        
                        cmp.set("v.dataScadenzaOrig",cmp.get("v.PVForm.cliente.dataScadenzaDate"));  
                        cmp.set("v.provRilascioOrig",cmp.get("v.PVForm.cliente.provRilascio"));        
                        cmp.set("v.luogoRilascioOrig",cmp.get("v.PVForm.cliente.luogoRilascio")); 
                    }
                    this.mostraErrori(cmp, response.getReturnValue().messaggiErrore);
                }else{
                    this.mostraToast(cmp, '', response.getError(), 'error', '');
                }
            });
            $A.enqueueAction(action);
        }
    },    

    onSubtypeSelected: function (cmp, event, helper) {
        this.onClienteSelected(cmp, event, helper);
    },    


    /************************/
    /* Gestione Inserimento */
    /************************/

    validateUserInput: function(cmp, event, helper) {
        this.clearFields(cmp);
        var messaggi = ''; 
        messaggi = this.checkClienteSelezionato(cmp);
        if(messaggi == "" && cmp.get("v.PVForm.reasonMdt.uniqueId__c") != 30){
            //this.checkErrors(cmp, event, helper);
            //verifico i dati inseriti
            if(cmp.get("v.tipoAnagraficaOrig") =='A' && cmp.get("v.PVForm.cliente.tipoAnagrafica") !='P'){ 
                messaggi += "E' necessario selezionare la tipologia anagrafica -Privato- per continuare.\n";
            }    
            else if(cmp.get("v.tipoAnagraficaOrig") =='A' && cmp.get("v.PVForm.cliente.tipoAnagrafica") =='P'){ 
                if ($A.util.isUndefinedOrNull(cmp.get('v.ruoloTipoAnagrafica'))){
                    messaggi += "Selezionare il ruolo che il cliente avrà nell'anagrafica.\n";
                }    
                if ($A.util.isUndefinedOrNull(cmp.get('v.PVForm.cliente.tipoDocumento')) || cmp.get('v.PVForm.cliente.tipoDocumento') == ""){
                    messaggi += "Non è possibile richiedere la modifica del tipo anagrafica a Privato in assenza di un documento d'identità associato.\n";
                }
            }        
            //se check su data scadenza (tipologia 145), la data deve essere valorizzata
            if(cmp.get("v.viewScadenza") && (cmp.get("v.PVForm.cliente.dataScadenzaDate") == "" || cmp.get("v.PVForm.cliente.dataScadenzaDate") == "0")){
                messaggi += "Inserire la nuova data di scadenza.\n";
            }
            //allegato obbligatorio se (solo per tipologia cliente):
            if(cmp.get("v.PVForm.sottotipologiaMdt.uniqueId__c") == 144){
                if(cmp.get('v.PVForm.attachmentList').length == 0  && !cmp.get('v.PVForm.isCheckFax') 
                        /*&& cmp.get("v.PVForm.sottotipologiaMdt.uniqueId__c") == 144*/ && cmp.get('v.dataScadenzaOrig') < cmp.get('v.today')){
                    //la data scadenza originale è scaduta
                    messaggi += "La data del documento associato risulta scaduta o non valida. Si prega di allegare un documento valido alla richiesta.\n";
                }
                //validazione data scadenza documento
                if(/*cmp.get("v.PVForm.sottotipologiaMdt.uniqueId__c") == 144 &&*/ !cmp.find("dataScadenza").checkValidity()){	//auraMethod checkValidity
                    cmp.find("dataScadenza").showHelpMessageIfInvalid();
                    messaggi += "Data di scadenza documento errata.\n";
                }
               if(cmp.get('v.PVForm.attachmentList').length == 0 && !cmp.get('v.PVForm.isCheckFax')){
                //variato un dato per cui è necessario allegare doc identità
                    if(cmp.get("v.cognomeOrig") != cmp.get("v.PVForm.cliente.cognome") ||
                    cmp.get("v.nomeOrig") != cmp.get("v.PVForm.cliente.nome") || 
                    cmp.get("v.sessoOrig") != cmp.get("v.PVForm.cliente.sesso") || 
                    cmp.get("v.dataNascitaOrig") != cmp.get("v.PVForm.cliente.dataNascitaDate") || 
                    cmp.get("v.provNascitaOrig") != cmp.get("v.PVForm.cliente.provNascita") || 
                    cmp.get("v.luogoNascitaOrig") != cmp.get("v.PVForm.cliente.luogoNascita") || 
                    cmp.get("v.tipoDocumentoOrig") != cmp.get("v.PVForm.cliente.tipoDocumento") || 
                    cmp.get("v.numDocumentoOrig") != cmp.get("v.PVForm.cliente.numDocumento") || 
                    cmp.get("v.dataRilascioOrig") != cmp.get("v.PVForm.cliente.dataRilascioDate") || 
                    cmp.get("v.provRilascioOrig") != cmp.get("v.PVForm.cliente.provRilascio") || 
                    cmp.get("v.dataScadenzaOrig") != cmp.get("v.PVForm.cliente.dataScadenzaDate") || 
                    cmp.get("v.luogoRilascioOrig") != cmp.get("v.PVForm.cliente.luogoRilascio")){
                        messaggi += "Inviare obbligatoriamente: - certificato d'identità\n";
                    }
                    //variato un dato per cui è necessario allegare codice fiscale
                    if(cmp.get("v.cognomeOrig") != cmp.get("v.PVForm.cliente.cognome") ||
                    cmp.get("v.nomeOrig") != cmp.get("v.PVForm.cliente.nome") || 
                    cmp.get("v.sessoOrig") != cmp.get("v.PVForm.cliente.sesso") || 
                    cmp.get("v.dataNascitaOrig") != cmp.get("v.PVForm.cliente.dataNascitaDate") || 
                    cmp.get("v.provNascitaOrig") != cmp.get("v.PVForm.cliente.provNascita") || 
                    cmp.get("v.luogoNascitaOrig") != cmp.get("v.PVForm.cliente.luogoNascita") || 
                    cmp.get("v.codFiscaleOrig") != cmp.get("v.PVForm.cliente.codFiscale")){
                        messaggi += "Inviare obbligatoriamente: - tessera sanitaria o codice fiscale\n";
                    }
                    //variato un dato per cui è necessario allegare visura camerale
                    if(cmp.get("v.denominazioneAziendaOrig") != cmp.get("v.PVForm.cliente.denominazioneAzienda") ||
                    cmp.get("v.formaGiuridicaOrig") != cmp.get("v.PVForm.cliente.formaGiuridica") || 
                    cmp.get("v.pivaOrig") != cmp.get("v.PVForm.cliente.piva")){
                        if(cmp.get("v.tipoAnagrafica") == "F"){
                            messaggi += "Inviare obbligatoriamente: - Visura Camerale o certificato di attribuzione della P.iva\n";
                        }else{
                            messaggi += "Inviare obbligatoriamente: - Visura Camerale o delibera di assemblea\n";
                        }                         
                    }
                }
                //allegato obbligatorio se tipologia Cliente
                if(cmp.get('v.PVForm.attachmentList').length == 0  && !cmp.get('v.PVForm.isCheckFax') /*&& cmp.get("v.PVForm.sottotipologiaMdt.uniqueId__c") == 144*/){
                    messaggi += "E' necessario inviare almeno un allegato.\n";
                }
            }
            if(messaggi == ""){
                //preparo i dati da passare al form
                var modificheAUI = "";
                var ritiroCarte = "";
                var variazioni = "";   
                if(cmp.get("v.denominazioneAziendaOrig") != cmp.get("v.PVForm.cliente.denominazioneAzienda")){
                    variazioni = variazioni  + "Denominazione variata da " + cmp.get("v.denominazioneAziendaOrig") + " a " + cmp.get("v.PVForm.cliente.denominazioneAzienda") + "\n";
                    modificheAUI = "N";
                }
                if(cmp.get("v.formaGiuridicaOrig") != cmp.get("v.PVForm.cliente.formaGiuridica")){
                    variazioni = variazioni  + "Forma Giuridica variata da " + cmp.get("v.formaGiuridicaOrig") + " a " + cmp.get("v.PVForm.cliente.formaGiuridica") + "\n";
                    modificheAUI = "N";
                }
                if(cmp.get("v.cognomeOrig") != cmp.get("v.PVForm.cliente.cognome")){
                    variazioni = variazioni  + "Cognome variato da " + cmp.get("v.cognomeOrig") + " a " + cmp.get("v.PVForm.cliente.cognome") + "\n";
                    modificheAUI = "N";
                    ritiroCarte = "S";
                }
                if(cmp.get("v.nomeOrig") != cmp.get("v.PVForm.cliente.nome")){
                    variazioni = variazioni  + "Nome variato da " + cmp.get("v.nomeOrig") + " a " + cmp.get("v.PVForm.cliente.nome") + "\n";
                    modificheAUI = "N";
                    ritiroCarte = "S";
                }
                if(cmp.get("v.codFiscaleOrig") != cmp.get("v.PVForm.cliente.codFiscale")){
                    variazioni = variazioni  + "Codice Fiscale variato da " + cmp.get("v.codFiscaleOrig") + " a " + cmp.get("v.PVForm.cliente.codFiscale") + "\n";
                    modificheAUI = "N";
                }
                if(cmp.get("v.sessoOrig") != cmp.get("v.PVForm.cliente.sesso")){
                    variazioni = variazioni  + "Sesso variato da " + cmp.get("v.sessoOrig") + " a " + cmp.get("v.PVForm.cliente.sesso") + "\n";
                    modificheAUI = "N";
                }
                if(cmp.get("v.dataNascitaOrig") != cmp.get("v.PVForm.cliente.dataNascitaDate")){
                    variazioni = variazioni  + "Data di nascita variata da " + cmp.get("v.dataNascitaOrig") + " a " + cmp.get("v.PVForm.cliente.dataNascitaDate") + "\n";
                    modificheAUI = "N";
                }
                if(cmp.get("v.provNascitaOrig") != cmp.get("v.PVForm.cliente.provNascita")){
                    variazioni = variazioni  + "Provincia di nascita variata da " + cmp.get("v.provNascitaOrig") + " a " + cmp.get("v.PVForm.cliente.provNascita") + "\n";
                    modificheAUI = "N";
                }
                if(cmp.get("v.luogoNascitaOrig") != cmp.get("v.PVForm.cliente.luogoNascita")){
                    variazioni = variazioni  + "Luogo di nascita variato da " + cmp.get("v.luogoNascitaOrig") + " a " + cmp.get("v.PVForm.cliente.luogoNascita") + "\n";
                    modificheAUI = "N";
                }
                if(cmp.get("v.pivaOrig") != cmp.get("v.PVForm.cliente.piva")){
                    variazioni = variazioni  + "Partita IVA variata da " + cmp.get("v.pivaOrig") + " a " + cmp.get("v.PVForm.cliente.piva") + "\n";
                    modificheAUI = "N";
                } 
                if(cmp.get("v.tipoAnagraficaOrig") != cmp.get("v.PVForm.cliente.tipoAnagrafica")){
                    variazioni = variazioni  + "Tipo Anagrafica variata da " + cmp.get("v.tipoAnagraficaOrig") + " a " + cmp.get("v.PVForm.cliente.tipoAnagrafica") + "\n";
                    modificheAUI = "N";
                }
                if(cmp.get("v.tipoAnagraficaOrig") =='A' && cmp.get("v.PVForm.cliente.tipoAnagrafica") =='P'){
                    variazioni = variazioni  + "Ruolo dell'anagrafica: " + cmp.get('v.ruoloTipoAnagrafica') + "\n";
                }
                if(cmp.get("v.tipoDocumentoOrig") != cmp.get("v.PVForm.cliente.tipoDocumento")){
                    variazioni = variazioni  + "Tipo Documento variato da " + cmp.get("v.tipoDocumentoOrig") + " a " + cmp.get("v.PVForm.cliente.tipoDocumento") + "\n";
                }
                if(cmp.get("v.numDocumentoOrig") != cmp.get("v.PVForm.cliente.numDocumento")){
                    variazioni = variazioni  + "Numero Documento variato da " + cmp.get("v.numDocumentoOrig") + " a " + cmp.get("v.PVForm.cliente.numDocumento") + "\n";
                }

                if(cmp.get("v.dataRilascioOrig") != cmp.get("v.PVForm.cliente.dataRilascioDate")){
                    variazioni = variazioni  + "Data di rilascio Documento variata da " + cmp.get("v.dataRilascioOrig") + " a " + cmp.get("v.PVForm.cliente.dataRilascioDate") + "\n";
                }
                if(cmp.get("v.dataScadenzaOrig") != cmp.get("v.PVForm.cliente.dataScadenzaDate")){
                    variazioni = variazioni  + "Data di scadenza Documento variata da " + cmp.get("v.dataScadenzaOrig") + " a " + cmp.get("v.PVForm.cliente.dataScadenzaDate") + "\n";
                    console.log("AUI: " + modificheAUI);
                    if(modificheAUI == ""){
                        modificheAUI = "S";  
                    }
                }
                if(cmp.get("v.provRilascioOrig") != cmp.get("v.PVForm.cliente.provRilascio")){
                    variazioni = variazioni  + "Provincia di rilascio Documento variata da " + cmp.get("v.provRilascioOrig") + " a " + cmp.get("v.PVForm.cliente.provRilascio") + "\n";
                }
                if(cmp.get("v.luogoRilascioOrig") != cmp.get("v.PVForm.cliente.luogoRilascio")){
                    variazioni = variazioni  + "Luogo di rilascio Documento variato da " + cmp.get("v.luogoRilascioOrig") + " a " + cmp.get("v.PVForm.cliente.luogoRilascio") + "\n";
                }  
                console.log("variazioni : " + variazioni);    
                if(variazioni == ""){
                    messaggi = "Eseguire almeno una variazione.\n";
                }else{
                    cmp.set("v.modificheAUI",modificheAUI);
                    cmp.set("v.ritiroCarte",ritiroCarte);
                    cmp.set("v.variazioni",variazioni);
                } 
            }
        }
       return messaggi;
    },
    
    completaPVForm: function(cmp, event, helper, PVForm) {
        PVForm.variazioni = "Lista variazioni: \n" + cmp.get("v.variazioni");
        PVForm.modificheAUI = cmp.get("v.modificheAUI");
        PVForm.ritiroCarte = cmp.get("v.ritiroCarte");
        return PVForm;
    },
    
    verifyCheckScadenza: function (cmp, event, helper) {
        cmp.set("v.viewScadenza",false);
        if(cmp.find('checkboxScadenza').get("v.checked")){
            cmp.set("v.viewScadenza",true);
        }
    },
    
    /*********************************/
	/* metodi CUSTOM del singolo PV */
    /*********************************/

    clearFields: function (cmp) {
        this.mostraErrori(cmp, "");
        this.showMarkup(cmp, true);
    },
  
    
})