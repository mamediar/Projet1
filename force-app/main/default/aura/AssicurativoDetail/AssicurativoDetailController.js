({
  //Get intervista Details
    getIntervistaDettagli: function (component, event, helper) {
        var indexNumeroAssicurazioni = 0;
        var idintervista = component.get("v.Id");
        console.log("idintervista" + idintervista);
        var ResponseObj = null;
        //call apex class method
        var action = component.get("c.getassicurativoDetail");
        // pass the apex method parameters to action
        action.setParams({
            idintervista: idintervista
        });
        action.setCallback(this, function (response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                ResponseObj = response.getReturnValue();
                component.set("v.nuovaIntervista", ResponseObj);
                /********************************************************************************/
                if( ResponseObj.COM_C_Serv1__c !== undefined && ResponseObj.COM_C_Serv1__c !== "")
                {
                    indexNumeroAssicurazioni++;
                }
                if( ResponseObj.COM_C_Serv2__c !== undefined && ResponseObj.COM_C_Serv2__c !== "")
                {
                    indexNumeroAssicurazioni++;
                }
                if( ResponseObj.COM_C_Serv3__c !== undefined && ResponseObj.COM_C_Serv3__c !== "")
                {
                    indexNumeroAssicurazioni++;
                }
                if( ResponseObj.COM_C_Serv4__c !== undefined && ResponseObj.COM_C_Serv4__c !== "")
                {
                    indexNumeroAssicurazioni++;
                }
                if( ResponseObj.COM_C_Serv5__c !== undefined && ResponseObj.COM_C_Serv5__c !== "")
                {
                    indexNumeroAssicurazioni++;
                }
                component.set("v.NumeroAssicurazioni",indexNumeroAssicurazioni);
                if( indexNumeroAssicurazioni > 1 )
                {
                    component.set("v.NumeroAssicurazioniStr"," ai pacchetti assicurativi facoltativi ");
                    component.set("v.NumeroAssicurazioneStr1"," delle assicurazioni facoltative ");
                    component.set("v.NumeroAssicurazioneStr2"," delle assicurazioni ");
                }else{ 
                    component.set("v.NumeroAssicurazioniStr"," al pacchetto assicurativo facoltativo ");
                    component.set("v.NumeroAssicurazioneStr1"," dell'assicurazione facoltativa ");
                    component.set("v.NumeroAssicurazioneStr2"," dell'assicurazione ");
                }
                //alert('20_06_2019 indexNumeroAssicurazioni->'+indexNumeroAssicurazioni+'-v.NumeroAssicurazioni-'+component.get("v.NumeroAssicurazioni") );
                /********************************************************************************/
                if(ResponseObj.COM_AC_SESSO__c!="M"){
                    component.set("v.status"," Sig.ra ");
                }
                // Check Sesso
                if (ResponseObj.COM_AC_SESSO__c !== undefined && ResponseObj.COM_AC_SESSO__c !== "") {
                    component.set("v.SessoIntervista", ResponseObj.COM_AC_SESSO__c);
                }
                if (ResponseObj.COM_Stato_Avanzamento_IntervistaASS__c === "Richiamare") {
                    component.set("v.Richiamare", true);
                    component.set("v.Nuova", true);
                    var NumNonRisponde = ResponseObj.COM_count_non_rispASS__c;
                    if (NumNonRisponde !== undefined) {
                        //alert('10_05_2019 RespondeObj->'+ResponseObj.COM_count_non_rispASS__c);
                        component.set("v.numNonRisponde", ResponseObj.COM_count_non_rispASS__c);
                    }
                } else if (ResponseObj.COM_Stato_Avanzamento_IntervistaASS__c === "Non accetta") {
                    component.set("v.NonAccetta", true);
                    component.set("v.Nuova", false);
                } else if (ResponseObj.COM_Stato_Avanzamento_IntervistaASS__c === "Conclusa") {
                    component.set("v.Conclusa", true);
                    component.set("v.Nuova", false);
                } else if (ResponseObj.COM_Stato_Avanzamento_IntervistaASS__c === "Irreperibile") {
                    component.set("v.Irreperibile", true);
                    component.set("v.Nuova", false);
                }
                //alert('result'+JSON.stringify(response.getReturnValue()));
                //ResponseObj.COM_Provenienza__c='F';
                component.set("v.nuovaIntervista", ResponseObj);
                if (ResponseObj.COM_Provenienza__c == "F" && ResponseObj.COM_Provenienza__c !== undefined) {
                    var selectedRisponde = "Disponibile";
                    helper.getIntervistaDomande(component, selectedRisponde);
                    helper.getDomandaAdessoSi(component);
                }
                helper.getComodityCheck(component);
            } else {
                console.log("error");
            }
        });
        $A.enqueueAction(action);
        //check if risposta of intervista exist
        var action2 = component.get("c.getRispostaAssicurativo");
        action2.setParams({ idIntervista: idintervista });
        action2.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.risposta", response.getReturnValue());
                if (component.get("v.risposta") != null) {
                    component.set("v.nonRisposta", false);
                    component.set("v.isRispostaExist", true);
                    component.set("v.toggleSpinner", false);
                    component.set("v.SpinnerSearch", false);
                }
            }
        });
        $A.enqueueAction(action2);
        //check if statos=New and update to Progressin
        var intervista = component.get("v.nuovaIntervista");
        if (intervista.COM_Status_ASS__c === "New") {
            intervista.COM_Status_ASS__c = "Processing";
            var action3 = component.get("c.updateIntervista");
            action3.setParam("param", intervista);
            action3.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    console.log("update COM_Status_ASS__c=Processing success");
                }
            });
            $A.enqueueAction(action3);
        }
          
    
    },
    
    redirect: function (component, event, helper) 
    {
             var intervista = component.get("v.nuovaIntervista");
             if( intervista.COM_Provenienza__c === 'A' )
             {
                 //alert('--1--');
                 var eventGoAssicurativo = $A.get("e.c:eventNavigateToAssicurativo");
                 eventGoAssicurativo.fire();
             }else if( intervista.COM_Provenienza__c === 'F' )
             {
                 //alert('--2--');
                 var eventRefreshIntervista = $A.get("e.c:eventGetIntervista");
                 eventRefreshIntervista.fire();
             }
    },
    
    redirectF: function (component, event, helper) {
    var eventRefreshIntervista = $A.get("e.c:eventGetIntervista");
    eventRefreshIntervista.fire();
    },
    
    // Appuntamento
    nonRisponde: function (component, event, helper) {
        helper.salvareAppuntamento(component);
        component.set("v.nonRisposta", false);
        component.set("v.responde", false);
        component.set("v.isrispondeNo", true);
    },
    
    risponde: function (component, event, helper) {
        component.set("v.responde", true);
    },
    
    getIntervistaDomande: function (component, event, helper) {
        //check if risponde is Si
        var source = event.getSource();
        var selectedRisponde = source.get("v.value");
        helper.getIntervistaDomande(component, selectedRisponde);
    },
    
    refreshResponse: function (component, event) {
        component.set("v.responde", false);
        var idintervista = component.get("v.Id");
        //call apex class method
        var action = component.get("c.getDettagliIntervista");
        // pass the apex method parameters to action
        action.setParams({
            idintervista: idintervista
        });
        action.setCallback(this, function (response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                //set response value in paginationList attribute on component.
                component.set("v.nuovaIntervista", response.getReturnValue());
                //alert('result'+JSON.stringify(response.getReturnValue()));
            } else {
                console.log("error");
            }
        });
        $A.enqueueAction(action);
        //check if risposta if intervista exist
        var action2 = component.get("c.getRisposta");
        action2.setParams({ idIntervista: idintervista });
        action2.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.risposta", response.getReturnValue());
                component.set("v.isRispostaExist", true);
                component.set("v.toggleSpinner", false);
                component.set("v.SpinnerSearch", false);
                component.set("v.nonRisposta", false);
                component.set("v.responde", false);
                component.set("v.isrispondeNo", false);
                component.set("v.isrispondeSi", false);
            }
        });
        $A.enqueueAction(action2);
    },
    
    showSpinnerDomanda: function (component, event, helper) {
        console.log("show spinner");
        //  component.set("v.toggleSpinner", true);
        //  component.set("v.SpinnerSearch", true);
    },
    
    modificaDomanda: function (component, event, helper) {
        var risposta = event.getParam("rispostaObject");
        component.set("v.risposta", risposta);
        //console.log("risposta of domande=", JSON.stringify(risposta));
        component.set("v.isRispostaExist", false);
        component.set("v.isupdateResponse", true);
    },

    irreperibile: function (component, event, helper) {
        helper.changeStato(component, "Irreperibile");
    },
    
    nonAccetta: function (component, event, helper) {
        helper.changeStato(component, "Non Accetta");
    },
    
    getDomandaAdessoSi: function (component, event, helper) {
        helper.getDomandaAdessoSi(component);
    },
    
    getDomandaAdessoNo: function (component, event, helper) {
        //var val = component.find('idAdesso').get('v.value');
        //console.log('value',val);
        if (component.get("v.risposta")) {
            var risposte = component.get("v.risposta");
        } else {
            var risposte = component.get("v.rispondeQuezione");
        }
        //console.log("Response", JSON.stringify(risposte));
        risposte.D1__c = "No";
        //console.log("response", risposte.D1__c);
        component.set("v.rispondeQuezione", risposte);
        component.set("v.risposta", risposte);
        //console.log("Response", component.get("v.rispondeQuezione"));/
        //-------------------------------------------------------------------------------------------//
        var intervista = component.get("v.nuovaIntervista");
        var dateIlSrting = helper.convertDateBeforeToString(intervista.COM_Data_Scadenza_Recesso__c, 1);
        component.set("v.quezione", "Nessun problema "+component.get("v.status")+ " " + intervista.COM_NomeCliente__r.Name + ";quando posso richiamarla? (entro il " + dateIlSrting + " )");
        component.set("v.responde", false);
        component.set("v.disponibileNonAdesso", true);
        component.set("v.disponibile", false);
        component.set("v.disponibileSi", false);
        component.set("v.isrispondeSi", false);
        component.set("v.isRispostaExist", false);
        component.set("v.nonRisposta", false);
    },

    //method for check if risponde is  Si Perche
    getDomandaDispoSiPerche: function (component, event, helper) {
        var comodityChecklist=component.get("v.comodityCheklist")[0]; 
        /*
        if(comodityChecklist.length>0)
           comodityChecklist=component.get("v.comodityCheklist")[0]; */
        if (component.get("v.risposta")) {
            var risposte = component.get("v.risposta");
        } else {
            var risposte = component.get("v.rispondeQuezione");
        }
        risposte.D2__c = "SI, PERCHE' NON MI E' MOLTO CHIARO/NON HO ANCORA LETTO LE CONDIZIONI DI POLIZZA";
        component.set("v.rispondeQuezione", risposte);
        component.set("v.risposta", risposte);
        component.set("v.FlussoDomanda","1");
        //console.log("Response", component.get("v.rispondeQuezione"));
        //-------------------------------------------------------------------------------------------//
        component.set(
            "v.quezione", "Non si preoccupi "+component.get("v.status")
            + " " + component.get("v.nuovaIntervista").COM_NomeCliente__r.Name 
            + ", " + "la chiamo proprio per farle un breve riepilogo \n" 
            +"delle caratteristiche"+component.get("v.NumeroAssicurazioneStr1")+"che ha sottoscritto. In questo modo, \n" + "saprà come comportarsi se mai dovesse averne bisogno.");
        
         
        var name = component.get("v.nuovaIntervista").COM_NomeCliente__r.Name;
        
        component.set("v.quezione2",'Un\'ultima domanda '+component.get("v.status")+' ' + name + ': si ritiene soddisfatto delle modalità di proposizione e vendita della copertura assicurativa facoltativa?');
        component.set("v.assicurativoPerche", true);
        component.set("v.disponibilenonProdotto", false);
        component.set("v.showButton", true);
        component.set("v.responde", false);
        component.set("v.disponibileNonAdesso", false);
        component.set("v.disponibile", false);
        component.set("v.isrispondeSi", false);
        component.set("v.isRispostaExist", false);
        component.set("v.nonRisposta", false);
        component.set("v.disponibilenonProdotto", false);
        
                
        component.set("v.assicurativoTracciaturaRecesso", false);
 
        var cmpVar = component.get("v.indexFlag");
        //alert('30_08_2019 cmpVar->'+cmpVar);
        if( cmpVar !== undefined && cmpVar > 0 )
        {
             component.set("v.NonConnessa", true);
             component.set(
            "v.quezione1",
            "Vedo, inoltre, che il suo finanziamento ha una durata pari a " + component.get("v.nuovaIntervista").COM_PLC_NUM_RATE__c + " mesi; " +
             "si ricorda che la polizza denominata "+TipoConcat/*comodityChecklist*/+" da Lei sottoscritta, ha una durata pari a "+ component.get("v.nuovaIntervista").COM_Durata_Sanitarie__c+" mesi?");
                           component.set("v.isOpen", true);

        }
        
        //alert('04_06_2019 component.get()->'+component.get('v.indexFlag') );
        if (component.get('v.indexFlag') ==  0) 
        {
             //alert('----');
             //alert(JSON.stringify(comodityChecklist));
             var TipoConcat = '';
             component.get("v.comodityCheklist").forEach( function(element) {
				  TipoConcat += element.COM_CRMTipo__c + ' ';
             });
            
             component.set(
            "v.quezione1",
            "Vedo, inoltre, che il suo finanziamento ha una durata pari a " + component.get("v.nuovaIntervista").COM_PLC_NUM_RATE__c + " mesi; " +
             "si ricorda che la polizza denominata "+TipoConcat/*comodityChecklist*/+" da Lei sottoscritta, ha una durata pari a "+ component.get("v.nuovaIntervista").COM_Durata_Sanitarie__c+" mesi?");
              component.set("v.isOpen", true);
         }else{
       
             component.set("v.assicurativoTracciaturaRecesso", false);
             component.set("v.isOpen", false);

        }
        
        
    },
    
    // method for check if risponde is Non/Non Mi Servi
    getDomandaDispoNoMiServi: function(component, event, helper) {
        
        if (component.get("v.risposta")) {
            var risposte = component.get("v.risposta");
        } else {
            var risposte = component.get("v.rispondeQuezione");
        }
        var name = component.get("v.nuovaIntervista").COM_NomeCliente__r.Name;
        component.set("v.quezione2",'Un\'ultima domanda '+component.get("v.status")+' ' + name + ': si ritiene soddisfatto delle modalità di proposizione e vendita della copertura assicurativa facoltativa?');
        component.set("v.rispondeQuezione", risposte);
        component.set("v.risposta", risposte);
        //console.log("Response", JSON.stringify(risposte));
        risposte.D2__c = "NO/NON MI SERVE";
        component.set("v.assicurativoTracciaturaRecesso", true);
        component.set("v.assicurativoPerche", false);
        component.set("v.showButton", false);
        component.set("v.disponibilenonProdotto", false);
        
        component.set("v.FlussoDomanda","2");
        //Update Interview
        /*
        var intervista = component.get("v.nuovaIntervista");
        intervista.COM_Stato_Avanzamento_IntervistaASS__c = "Conclusa";
        intervista.COM_Status_ASS__c = "Archived";
        intervista.COM_Data_Esito_ASS__c = new Date();

        var action = component.get("c.updateIntervista");
        action.setParam("param", intervista);
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.nuovaIntervista", response.getReturnValue());
                //console.log("in success", response.getReturnValue());
                //helper.showToast('Stato aggiornato in "Conclusa".Salvataggio con successo', 'SUCCESS');
                component.set("v.nonRisposta", false);
            } else {
                helper.showToast("Salvataggio non successo", "ERROR");
            }
        });
        $A.enqueueAction(action);
        risposte.Intervista__c = intervista.Id;
        //console.log("risposte", risposte);
        //console.log("Intervista Id", intervista.Id);
        var action1 = component.get("c.addResponseAssicurativo");
        action1.setParams({ respdomanda: risposte });
        action1.setCallback(this, function (response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                // component.set('v.risposta', JSON.stringify(response.getReturnValue()));
                console.log("response.getReturnValue()" + JSON.stringify(response.getReturnValue())
                );
                helper.showToast("Salvataggio Risposta con successo!", "SUCCESS");
                // component.set('v.isRispostaExist',true);
                var eventGoFiliali = $A.get("e.c:eventNavigationAssicurativoPratiche");
                eventGoFiliali.fire();
            } else {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        //console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action1);
        */
        
        
    },
    
    // method for check if risponde is  Non Prodotto Assicurativo
    getDomandaDispoNonProdotto: function (component, event, helper) {
        if (component.get("v.risposta")) {
            var risposte = component.get("v.risposta");
        } else {
            var risposte = component.get("v.rispondeQuezione");
        }
        component.set(
            "v.quezione1", "Vedo, inoltre, che il suo finanziamento ha una durata pari a " +
            component.get("v.nuovaIntervista").COM_PLC_NUM_RATE__c + " mesi; " +
            "si ricorda che la polizza denominata FAMILY PROTECTION da Lei sottoscritta, ha una durata pari a "+component.get("v.nuovaIntervista").COM_Durata_Sanitarie__c+" mesi?"
        );
        
         
          var name = component.get("v.nuovaIntervista").COM_NomeCliente__r.Name;
        component.set("v.quezione2",'Un\'ultima domanda '+component.get("v.status")+' ' + name + ': si ritiene soddisfatto delle modalità di proposizione e vendita della copertura assicurativa facoltativa?');
  
        //console.log("Response", JSON.stringify(risposte));
        risposte.D2__c = "NON HO SOTTOSCRITTO/NON RICORDO DI AVER SOTTOSCRITTO ALCUN PRODOTTO ASSICURATIVO";
        //console.log("response", risposte.D2__c);
        component.set("v.rispondeQuezione", risposte);
        component.set("v.risposta", risposte);
        //console.log("Response", component.get("v.rispondeQuezione"));
        //-------------------------------------------------------------------------------------------//
        component.set("v.disponibilenonProdotto", true);
        var commCheckListLength = component.get("v.comodityCheklist").length; 
        console.log('10_10_2019 commCheckListLength->'+commCheckListLength);
        if( commCheckListLength > 1 )component.set("v.NumeroModuliStr"," appositi moduli");
        else component.set("v.NumeroModuliStr"," apposito modulo");
        component.set("v.responde", false);
        component.set("v.disponibileNonAdesso", false);
        component.set("v.assicurativoTracciaturaRecesso", false);
        component.set("v.assicurativoPerche", false);
        component.set("v.disponibile", false);
        component.set("v.isrispondeSi", false);
        component.set("v.isRispostaExist", false);
        component.set("v.nonRisposta", false);
        component.set("v.FlussoDomanda","3");
        
        var cmpVar = component.get("v.indexFlag");
        //alert('30_08_2019 cmpVar->'+cmpVar);
        if( cmpVar !== undefined && cmpVar > 0 )
        {
                    component.set("v.NonConnessa", true);
        }
        
    }
});