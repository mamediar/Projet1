({
    calcolaIBAN : function(cmp, event) {
        cmp.find("messaggioIban").set("v.value","");
        console.log("*"+cmp.find('ABI__c').get("v.value")+"*");
        console.log("*"+cmp.find('CAB__c').get("v.value")+"*");
        console.log("*"+cmp.find('ContoCorrente__c').get("v.value")+"*");
        if(cmp.find('ABI__c').get("v.value") != "" && cmp.find('CAB__c').get("v.value") != "" && cmp.find('ContoCorrente__c').get("v.value") != ""
            && cmp.find('ABI__c').get("v.value") != null && cmp.find('CAB__c').get("v.value") != null && cmp.find('ContoCorrente__c').get("v.value") != null){
            var action = cmp.get("c.calcolaIBAN");
            action.setParams({
                abi: cmp.find('ABI__c').get('v.value'),
                cab: cmp.find('CAB__c').get('v.value'),
                numConto: cmp.find('ContoCorrente__c').get('v.value')
                
            }); 
            console.log('calcolaIBAN action');
            action.setCallback(this, function(response){
                if (response.getState() == 'SUCCESS'){
                    console.log('CALCOLA IBAN SUCCESS');
                    console.log('response.getReturnValue() : ' + JSON.stringify(response.getReturnValue()));
                    var datiChiamataOCS=response.getReturnValue();
                    
                    if(datiChiamataOCS.chiamataOK){
                        console.log("**"+datiChiamataOCS.iban+"**");
                        if(!$A.util.isUndefinedOrNull(datiChiamataOCS.iban)){
                            console.log("1");
                            //cmp.set("v.praticaSelezionata.iban",datiChiamataOCS.iban);
                            cmp.find('IBAN__c').set('v.value', datiChiamataOCS.iban);
                        }else{
                            console.log("2");
                            cmp.find('IBAN__c').set('v.value', "");
                        }
                    } else {
                        cmp.find("messaggioIban").set("v.value",datiChiamataOCS.message);
                    }
                } else {
                    console.log('CALCOLA IBAN NOT SUCCESS');
                }
            });		
            $A.enqueueAction(action);
        }       
        
	},
    
    verificaIBAN : function(cmp, event) {
        cmp.find("messaggioIban").set("v.value","");
		var action = cmp.get("c.verificaIBAN");
        var iban = cmp.find('IBAN__c').get('v.value');
        console.log("verifica IBAN log: " + cmp.find('IBAN__c').get('v.value'));
        if(iban!=null){
            action.setParams({
                iban: iban            
            }); 
            action.setCallback(this, function(response){
                if (response.getState() == 'SUCCESS'){
                    var ibanValido=response.getReturnValue();
                    if(ibanValido){ 
                        cmp.set("v.isIBANvalido",true);
                        cmp.find("messaggioIban").set("v.value","Formato IBAN valido.");
                    } else {
                        cmp.set("v.isIBANvalido",false);
                        cmp.find("messaggioIban").set("v.value","Formato IBAN NON valido.");
                    }
                }
            });		
            $A.enqueueAction(action);
        } else {
            cmp.set("v.isIBANvalido",false);
            cmp.find("messaggioIban").set("v.value","Formato IBAN NON valido.");
        }
    },
    
/*
	showToast : function(cmp,event,type,message,duration){
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
				"message":message,
                "type":type,
                "duration":duration
			}
		);
		toastEvent.fire();
	},
*/

	doValidityCheck : function(cmp, event){
        var errori = "";
        cmp.set("v.note","");
        if(!cmp.find("modalitaPagamento").checkValidity()){
			cmp.find("modalitaPagamento").showHelpMessageIfInvalid();
			errori += "Selezionare la modalità di rimborso/pagamento.\n";
        }else if (cmp.get("v.modalitaPagamentoSelected")=='Bonifico'){
            cmp.set("v.note", cmp.get("v.note") + "\n" + "Modalità rimborso: " + cmp.get("v.modalitaPagamentoSelected")); 
            cmp.set("v.note", cmp.get("v.note") + "\n" + "Dati bancari: "); 
            if(!cmp.find("intestatario").checkValidity() || cmp.find("intestatario").get("v.value") == ""){	//auraMethod checkValidity
                cmp.find("intestatario").showHelpMessageIfInvalid();
                errori += "Indicare l'intestatario del conto.\n";
            }else{
                cmp.set("v.note", cmp.get("v.note") + "\n" + "Intestatario: " + cmp.find("intestatario").get("v.value")); 
            }	
            if(!cmp.find("ABI__c").checkValidity() || cmp.find("ABI__c").get('v.value') == '0'){	//auraMethod checkValidity
                cmp.find("ABI__c").showHelpMessageIfInvalid();
                errori += "Indicare l'ABI.\n";
            }else{
                cmp.set("v.note", cmp.get("v.note") + "\n" + "ABI: " + cmp.find("ABI__c").get("v.value")); 
            }	
            if(!cmp.find("CAB__c").checkValidity() || cmp.find("CAB__c").get('v.value') == '0'){	//auraMethod checkValidity
                cmp.find("CAB__c").showHelpMessageIfInvalid();
                errori += "Indicare il CAB.\n";
            }else{
                cmp.set("v.note", cmp.get("v.note") + "\n" + "CAB: " + cmp.find("CAB__c").get("v.value")); 
            }	
            if(!cmp.find("ContoCorrente__c").checkValidity() || cmp.find("ContoCorrente__c").get('v.value') == '0'){	//auraMethod checkValidity
                cmp.find("ContoCorrente__c").showHelpMessageIfInvalid();
                errori += "Indicare il C/C.\n";
            }else{
                cmp.set("v.note", cmp.get("v.note") + "\n" + "C/C: " + cmp.find("ContoCorrente__c").get("v.value")); 
            }	
            if(!cmp.find("IBAN__c").checkValidity() || cmp.find("IBAN__c").get('v.value') == '0'){	//auraMethod checkValidity
                cmp.find("IBAN__c").showHelpMessageIfInvalid();
                errori += "Indicare l'IBAN.\n";
            }else{
                this.verificaIBAN(cmp, event);
                if(!cmp.get("v.isIBANvalido")){
                    errori += "Formato IBAN NON valido.\n";
                }else{
                    cmp.set("v.note", cmp.get("v.note") + "\n" + "IBAN: " + cmp.find("IBAN__c").get("v.value")); 
                }
            }	
        }else if(cmp.get("v.modalitaPagamentoSelected")=='Assegno'){
            cmp.set("v.note", cmp.get("v.note") + "\n" + "Modalità rimborso: " + cmp.get("v.modalitaPagamentoSelected")); 
            cmp.set("v.note", cmp.get("v.note") + "\n" + "Di seguito è riportato l'indirizzo di spedizione eventualmente modificato su richiesta del cliente.");
            cmp.set("v.note", cmp.get("v.note") + "\n" + cmp.get("v.OCSClienteSelezionato.denominazioneAzienda")); 
            if(!cmp.find("address").checkValidity()){	//auraMethod checkValidity
                cmp.find("address").showHelpMessageIfInvalid();
                errori += "Indicare l'indirizzo.\n";
            }else{
                cmp.set("v.note", cmp.get("v.note") + "\n" + cmp.find("address").get("v.value")); 
            }	
            if(!cmp.find("cap").checkValidity()){	//auraMethod checkValidity
                cmp.find("cap").showHelpMessageIfInvalid();
                errori += "Indicare il cap.\n";
            }else{
                cmp.set("v.note", cmp.get("v.note") + "\n" + cmp.find("cap").get("v.value")); 
            }	
            if(cmp.get("v.OCSClienteSelezionato.localita") == "" || cmp.get("v.OCSClienteSelezionato.localita") == undefined){
                errori += "Indicare la località.\n";
            }else{
                cmp.set("v.note", cmp.get("v.note") + " " + cmp.get("v.OCSClienteSelezionato.localita")); 
            }	
            if(cmp.get("v.OCSClienteSelezionato.provincia") == "" || cmp.get("v.OCSClienteSelezionato.provincia") == undefined){
                errori += "Indicare la provincia.\n";
            }else{
                cmp.set("v.note", cmp.get("v.note") + " " + cmp.get("v.OCSClienteSelezionato.provincia")); 
            }	
        }
        cmp.set("v.errori",errori);
	},

})