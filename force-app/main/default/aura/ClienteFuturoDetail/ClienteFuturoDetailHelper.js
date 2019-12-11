({
    /**
	 * @description : To show Toast
	 * @author: Mady COLY
	 * @date: 27/05/2019
	 * @param :message
	 * @param :type
	 */
    showToast: function (message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            message: message,
            type: type
        });
        toastEvent.fire();
    },
    /**
	* @description: find a Com_Commodity_Survey__c by IdCom_Commodity_Survey__c
	* @date::27/05/2019
	* @author:Mady COLY
	* dateLastModification: none
	*/
    getClienteDetailFuturo: function (component) {
        var id = component.get("v.Id");
        var fromAmministrazione = component.get("v.fromAmministrazione");
        var action = component.get('c.getCommoditySurveyDetail');
        action.setParam('commodity_SurveyId', id);
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                component.set("v.loading", false);
                var dataResponse = response.getReturnValue();
                if (dataResponse.error == false) {
                    var dataCliente = dataResponse.data;
                    console.log('data cliente: ' + JSON.stringify(dataCliente));
                    component.set("v.clienteFuturo", dataCliente);
                    dataCliente.Ultimo_Esito__c = '';
                    if (dataCliente.COM_SESSO_CEDENTE__c == 'F') {
                        component.set("v.status", " Sig.ra ");
                    }
                    var clienteFuturo = component.get("v.clienteFuturo");
                    if (fromAmministrazione == false) {
                        //update a status to dataCliente
                        if (clienteFuturo.COM_Status_FUTURO__c === "New") {
                            clienteFuturo.COM_Status_FUTURO__c = "Processing";
                            if (clienteFuturo.Interviste_Utili__c === undefined || clienteFuturo.Interviste_Utili__c === '')
                                clienteFuturo.Interviste_Utili__c = 1;
                            else
                                clienteFuturo.Interviste_Utili__c = intervista.Interviste_Utili__c + 1;
                            var action3 = component.get("c.updateSobject");
                            action3.setParam("mySobject", clienteFuturo);
                            action3.setCallback(this, function (response) {
                                var state = response.getState();
                                if (state === "SUCCESS") {
                                    component.set("v.clienteFuturo", clienteFuturo);
                                }
                            });
                            $A.enqueueAction(action3);
                        }
                    }
                    else {
                        var action3 = component.get("c.getRisposteByCommoditySurveyId");
                        action3.setParam("idIntervista", id);
                        action3.setCallback(this, function (response) {
                            var state = response.getState();
                            if (state === "SUCCESS") {
                                var dataResponse = response.getReturnValue();
                                if (dataResponse.error == false) {
                                    var data = dataResponse.data;
                                    console.log('data: ' + JSON.stringify(data));
                                    if (data.COM_Note_Contratto__c == undefined)
                                        data.COM_Note_Contratto__c = '';
                                    if (data.COM_Note_Contratto_Assicurazione__c == undefined)
                                        data.COM_Note_Contratto_Assicurazione__c = '';
                                    if (data.COM_Note_Documenti_Assicurazione__c == undefined)
                                        data.COM_Note_Documenti_Assicurazione__c = '';
                                    if (data.COM_Note_Motivazione_Recesso__c == undefined)
                                        data.COM_Note_Motivazione_Recesso__c = '';
                                    if (data.COM_Note_Precontratto__c == undefined)
                                        data.COM_Note_Precontratto__c = '';
                                    if (data.COM_Note_Questionario_Assicurativo__c == undefined)
                                        data.COM_Note_Questionario_Assicurativo__c = '';
                                    if (data.COM_Note_Secci__c == undefined)
                                        data.COM_Note_Secci__c = '';
                                    if (data.COM_Note_Soddisfazione_Cliente__c == undefined)
                                        data.COM_Note_Soddisfazione_Cliente__c = '';
                                    if (data.COM_Note9__c == undefined)
                                        data.COM_Note9__c = '';
                                    if (data.COM_Note_10__c == undefined)
                                        data.COM_Note_10__c = '';
                                    if (data.COM_Note_11__c == undefined)
                                        data.COM_Note_11__c = '';
                                    component.set("v.rispondeIntervista", data);
                                }
                                else {
                                    this.showToast('Non successo', 'ERROR');
                                }
                            }
                        });
                        $A.enqueueAction(action3);
                    }
                }
            } else {
                this.showToast('Non successo', 'ERROR');
            }
        });
        $A.enqueueAction(action);

    },
    /**
   * @description: go to step of quezione 1
   * @dateCreate:22/05/2019
   * @author:Mady COLY
   */
    selectStepQuezionze1: function (component) {
        var risponde = component.get("v.rispondeQuezione1");
        component.set("v.btnLeftDisabled", false);
        if(risponde!=""){
            component.set("v.btnRightDisabled", true);
        }
        else
        component.set("v.btnRightDisabled", false);
        component.set("v.selectedStep", "stepQuezione1");
    },
    /**
   * @description: go to step if the response of quezione is SI
   * @dateCreate:22/05/2019
   * @author:Mady COLY
   */
    selectStepRisponde1SI: function (component) {
        component.set("v.btnLeftDisabled", true);
        component.set("v.startIntervista",false);
        component.set("v.concludiIntervista",false);
        var risponde = component.get("v.rispondeQuezione2");
        if(risponde!=""){
            if(risponde == "SI")
            {
            component.set("v.startIntervista",true);
            component.set("v.btnRightDisabled", true);
            }
            else{
            component.set("v.concludiIntervista",true);
            component.set("v.btnRightDisabled", false);
            }
        }else
        component.set("v.btnRightDisabled", false);
        component.set("v.selectedStep", "stepRisponde1SI");
    },
    /**
   * @description: go to step if the response of quezione is NO
   * @dateCreate:22/05/2019
   * @author:Mady COLY
   */
    selectStepRisponde1NO: function (component) {
        component.set("v.iniziaIntervista", false);
        component.set("v.selectedStep", "stepRisponde1NO");
    },
    /**
   * @description: go to next step 
   * @dateCreate:22/05/2019
   * @author:Mady COLY
   */
    handleNext: function (component) {
        var getselectedStep = component.get("v.selectedStep");
        if (getselectedStep == "stepQuezione1") {
                    this.selectStepRisponde1SI(component);
        }
      else if (getselectedStep == "stepRisponde1SI") {
                component.set("v.startIntervista",false);
               component.set("v.concludiIntervista",false);
               component.set("v.iniziaIntervista",true);
                    this.selectStepintervistaDomanda1(component);
        }
        else if (getselectedStep == "stepIntervistaDomanda1") {
            var risponde = component.get("v.rispondeIntervista").D1_Futuro__c;
            var validExpense = component.find('intervistaDomande1').reduce(function (validSoFar, inputCmp) {
                inputCmp.showHelpMessageIfInvalid();
                return validSoFar && inputCmp.get('v.validity').valid;
            }, true);
            // If we pass error checking, do some real work
            if (validExpense) {
                    this.selectStepintervistaDomanda2(component);
            }
        }
        else if (getselectedStep == "stepIntervistaDomanda2") {
            var risponde = component.get("v.rispondeIntervista").D2_Futuro__c;
            var validExpense = component.find('intervistaDomande2').reduce(function (validSoFar, inputCmp) {
                inputCmp.showHelpMessageIfInvalid();
                return validSoFar && inputCmp.get('v.validity').valid;
            }, true);
            // If we pass error checking, do some real work
            if (validExpense) {
                if (risponde != "") {
                    this.selectStepintervistaDomanda3(component);
                }
            }
        }
        else if (getselectedStep == "stepIntervistaDomanda3") {
            var risponde = component.get("v.rispondeIntervista").D3_Futuro__c;
            var validExpense = component.find('intervistaDomande3').reduce(function (validSoFar, inputCmp) {
                inputCmp.showHelpMessageIfInvalid();
                return validSoFar && inputCmp.get('v.validity').valid;
            }, true);
            // If we pass error checking, do some real work
            if (validExpense) {
                if (risponde != "") {
                    this.selectStepintervistaDomanda4(component);
                }
            }
        }
        else if (getselectedStep == "stepIntervistaDomanda4") {
            var risponde = component.get("v.rispondeIntervista").D4_Futuro__c;
            var validExpense = component.find('intervistaDomande4').reduce(function (validSoFar, inputCmp) {
                inputCmp.showHelpMessageIfInvalid();
                return validSoFar && inputCmp.get('v.validity').valid;
            }, true);
            // If we pass error checking, do some real work
            if (validExpense) {
                if (risponde != "") {
                    this.selectStepintervistaDomanda5(component);
                }
            }
        }
        else if (getselectedStep == "stepIntervistaDomanda5") {
            var risponde = component.get("v.rispondeIntervista").D5_Futuro__c;
            var validExpense = component.find('intervistaDomande5').reduce(function (validSoFar, inputCmp) {
                inputCmp.showHelpMessageIfInvalid();
                return validSoFar && inputCmp.get('v.validity').valid;
            }, true);
            // If we pass error checking, do some real work
            if (validExpense) {
                if (risponde != "") {
                    this.selectStepintervistaDomanda6(component);
                }

            }
        }
        else if (getselectedStep == "stepIntervistaDomanda6") {
            var risponde = component.get("v.rispondeIntervista").D6_Futuro__c;
            var validExpense = component.find('intervistaDomande6').reduce(function (validSoFar, inputCmp) {
                inputCmp.showHelpMessageIfInvalid();
                return validSoFar && inputCmp.get('v.validity').valid;
            }, true);
            // If we pass error checking, do some real work
            if (validExpense) {
                if (risponde != "") {
                    if (component.get("v.rispondeIntervista").COM_TipoRinnovo__c != '') {
                        this.selectStepintervistaDomanda6bis(component);
                    }
                    else
                         this.selectStepintervistaDomanda7(component);
                }
            }
        }
        else if (getselectedStep == "stepIntervistaDomanda6bis") {
            var risponde = component.get("v.rispondeIntervista").D6bis_Futuro__c;
            var validExpense = component.find('intervistaDomande6bis').reduce(function (validSoFar, inputCmp) {
                inputCmp.showHelpMessageIfInvalid();
                return validSoFar && inputCmp.get('v.validity').valid;
            }, true);
            // If we pass error checking, do some real work
            if (validExpense) {
                if (risponde != "") {
                    this.selectStepintervistaDomanda7(component);
                }
            }
        }
        else if (getselectedStep == "stepIntervistaDomanda7") {
            var risponde = component.get("v.rispondeIntervista").D7_Futuro__c;
            var validExpense = component.find('intervistaDomande7').reduce(function (validSoFar, inputCmp) {
                inputCmp.showHelpMessageIfInvalid();
                return validSoFar && inputCmp.get('v.validity').valid;
            }, true);
            // If we pass error checking, do some real work
            if (validExpense) {
                if (risponde != "") {
                    this.selectStepintervistaDomanda8(component);
                }
            }
        }
        else if (getselectedStep == "stepIntervistaDomanda8") {
            var risponde = component.get("v.rispondeIntervista").D8_Futuro__c;
            var validExpense = component.find('intervistaDomande8').reduce(function (validSoFar, inputCmp) {
                inputCmp.showHelpMessageIfInvalid();
                return validSoFar && inputCmp.get('v.validity').valid;
            }, true);
            // If we pass error checking, do some real work
            if (validExpense) {
                if (risponde != "") {
                    this.selectStepintervistaDomanda9(component);
                }
            }
        }
        else if (getselectedStep == "stepIntervistaDomanda9") {
            var risponde = component.get("v.rispondeIntervista").D9_Futuro__c;
            var validExpense = component.find('intervistaDomande9').reduce(function (validSoFar, inputCmp) {
                inputCmp.showHelpMessageIfInvalid();
                return validSoFar && inputCmp.get('v.validity').valid;
            }, true);
            // If we pass error checking, do some real work
            if (validExpense) {
                if (risponde != "") {
                    this.selectStepintervistaDomanda10(component);
                }
            }
        }
        else {
            var risponde = component.get("v.rispondeIntervista").D10_Futuro__c;
            var validExpense = component.find('intervistaDomande10').reduce(function (validSoFar, inputCmp) {
                inputCmp.showHelpMessageIfInvalid();
                return validSoFar && inputCmp.get('v.validity').valid;
            }, true);
            // If we pass error checking, do some real work
            if (validExpense) {
                if (risponde != "") {
                    this.selectStepintervistaDomanda11(component);
                }
            }
        }

    },
    /**
   * @description: go to previous step 
   * @dateCreate:22/05/2019
   * @author:Mady COLY
   */
    handlePrev: function (component, event) {
        var getselectedStep = component.get("v.selectedStep");
        if (getselectedStep == "stepRisponde1SI") {
            component.set("v.btnLeftDisabled", true);
            component.set("v.startIntervista",false);
            component.set("v.concludiIntervista",false);
            this.selectStepQuezionze1(component);
        }
        else if (getselectedStep == "stepRisponde1NO") {
            this.selectStepQuezionze1(component);
        }
        else if (getselectedStep == "stepIntervistaDomanda11") {
            this.selectStepintervistaDomanda10(component);
        }
        else if (getselectedStep == "stepIntervistaDomanda10") {
            this.selectStepintervistaDomanda9(component);
        }
        else if (getselectedStep == "stepIntervistaDomanda9") {
            this.selectStepintervistaDomanda8(component);
        }
        else if (getselectedStep == "stepIntervistaDomanda8") {
            this.selectStepintervistaDomanda7(component);
        }
        else if (getselectedStep == "stepIntervistaDomanda7") {
            if (component.get("v.rispondeIntervista").COM_TipoRinnovo__c != '') {
                this.selectStepintervistaDomanda6bis(component);
            }
            else {
                this.selectStepintervistaDomanda6(component);
            }
        }
        else if (getselectedStep == "stepIntervistaDomanda6") {
            this.selectStepintervistaDomanda5(component);
        }
        else if (getselectedStep == "stepIntervistaDomanda6bis") {
            this.selectStepintervistaDomanda6(component);
        }
        else if (getselectedStep == "stepIntervistaDomanda5") {
            this.selectStepintervistaDomanda4(component);
        }
        else if (getselectedStep == "stepIntervistaDomanda4") {
            this.selectStepintervistaDomanda3(component);
        }
        else if (getselectedStep == "stepIntervistaDomanda3") {
            this.selectStepintervistaDomanda2(component);
        }
        else if (getselectedStep == "stepIntervistaDomanda2") {
            this.selectStepintervistaDomanda1(component);
        }
        else if (getselectedStep == "stepIntervistaDomanda1") { 
            component.set("v.iniziaIntervista",false);
            this.selectStepRisponde1SI(component);
        }
    },
    /**
   * @description: select a internista
   * @dateCreate:28/05/2019
   * @author:Mady COLY
   */
    selectStepintervistaDomanda1: function (component) {
        var risponde = component.get("v.rispondeIntervista").D1_Futuro__c;
        if(risponde!="")
            component.set("v.btnRightDisabled", true);
        else
        component.set("v.btnRightDisabled", false);
        component.set("v.selectedStep", "stepIntervistaDomanda1");
    },
    selectStepintervistaDomanda2: function (component) {
        var risponde = component.get("v.rispondeIntervista").D2_Futuro__c;
        if(risponde!="")
            component.set("v.btnRightDisabled", true);
        else
        component.set("v.btnRightDisabled", false);
        component.set("v.selectedStep", "stepIntervistaDomanda2");
    },
    selectStepintervistaDomanda3: function (component) {
        var risponde = component.get("v.rispondeIntervista").D3_Futuro__c;
        if(risponde!="")
            component.set("v.btnRightDisabled", true);
        else
        component.set("v.btnRightDisabled", false);
        component.set("v.selectedStep", "stepIntervistaDomanda3");
    },
    selectStepintervistaDomanda4: function (component) {
        var risponde = component.get("v.rispondeIntervista").D4_Futuro__c;
        if(risponde!="")
            component.set("v.btnRightDisabled", true);
        else
        component.set("v.btnRightDisabled", false);
        component.set("v.selectedStep", "stepIntervistaDomanda4");
    },
    selectStepintervistaDomanda5: function (component) {
        var risponde = component.get("v.rispondeIntervista").D5_Futuro__c;
        if(risponde!="")
            component.set("v.btnRightDisabled", true);
        else
        component.set("v.btnRightDisabled", false);
        component.set("v.selectedStep", "stepIntervistaDomanda5");
    },
    selectStepintervistaDomanda6: function (component) {
        var risponde = component.get("v.rispondeIntervista").D6_Futuro__c;
        if(risponde!="")
            component.set("v.btnRightDisabled", true);
        else
        component.set("v.btnRightDisabled", false);
        component.set("v.selectedStep", "stepIntervistaDomanda6");
    },
    selectStepintervistaDomanda6bis: function (component) {
        var risponde = component.get("v.rispondeIntervista").D6bis_Futuro__c;
        if(risponde!="")
            component.set("v.btnRightDisabled", true);
        else
        component.set("v.btnRightDisabled", false);
        component.set("v.selectedStep", "stepIntervistaDomanda6bis");
    },
    selectStepintervistaDomanda7: function (component) {
        var risponde = component.get("v.rispondeIntervista").D7_Futuro__c;
        if(risponde!="")
            component.set("v.btnRightDisabled", true);
        else
        component.set("v.btnRightDisabled", false);
        component.set("v.selectedStep", "stepIntervistaDomanda7");
    },
    selectStepintervistaDomanda8: function (component) {
        var risponde = component.get("v.rispondeIntervista").D8_Futuro__c;
        if(risponde!="")
            component.set("v.btnRightDisabled", true);
        else
        component.set("v.btnRightDisabled", false);
        component.set("v.selectedStep", "stepIntervistaDomanda8");
    },
    selectStepintervistaDomanda9: function (component) {
        var risponde = component.get("v.rispondeIntervista").D9_Futuro__c;
        if(risponde!="")
            component.set("v.btnRightDisabled", true);
        else
        component.set("v.btnRightDisabled", false);
        component.set("v.selectedStep", "stepIntervistaDomanda9");
    },
    selectStepintervistaDomanda10: function (component) {
        var risponde = component.get("v.rispondeIntervista").D10_Futuro__c;
        if(risponde!="")
            component.set("v.btnRightDisabled", true);
        else
        component.set("v.btnRightDisabled", false);
        component.set("v.selectedStep", "stepIntervistaDomanda10");
    },
    selectStepintervistaDomanda11: function (component) {
        var risponde = component.get("v.rispondeIntervista").D11_Futuro__c;
        if(risponde!="")
            component.set("v.btnRightDisabled", true);
        else
        component.set("v.btnRightDisabled", false);
        component.set("v.selectedStep", "stepIntervistaDomanda11");
    },
    /**
   * @description: answer of the first question
   * @dateCreate:28/05/2019
   * @author:Mady COLY
   */
    getRespondeQuezione1: function (component, event) {
        var source = event.getSource();
        var selectedRisponde = source.get("v.value");
        component.set("v.rispondeQuezione1",selectedRisponde);
        if (selectedRisponde == 'SI') {
            this.selectStepRisponde1SI(component);
        } else {
            this.selectStepRisponde1NO(component);
        }
    },
    /**
   * @description: start a intervista
   * @dateCreate:24/05/2019
   * @author:Mady COLY
   */
    getIniziaIntervista: function (component, event) {
        component.set("v.startIntervista", false);
        component.set("v.iniziaIntervista", true);
        this.selectStepintervistaDomanda1(component);
    },
    /**
   * @description: choice 
   * @dateCreate:29/05/2019
   * @author:Mady COLY
   */
    getChoice: function (component, status, stato) {
        var clienteFuturo = component.get("v.clienteFuturo");
        clienteFuturo.Ultimo_Esito__c = stato;
        clienteFuturo.COM_Status_FUTURO__c = status;
        clienteFuturo.Data_Ultimo_Esito__c = new Date();
        if (status === "Archived") {
            clienteFuturo.COM_PraticheChiuse_Conforme__c = 0;
            clienteFuturo.COM_ChiusoNon_Conforme__c = 1;
        }
        var action = component.get("c.updateSobject");
        action.setParam("mySobject", clienteFuturo);
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                clienteFuturo.Data_Ultimo_Esito__c = clienteFuturo.Data_Ultimo_Esito__c.toLocaleDateString();
                var data = response.getReturnValue();
                component.set('v.clienteFuturo', clienteFuturo);
                if (status === "Archived") {
                    var eventRefreshIntervista = $A.get("e.c:eventFuturoClientePaginazione");
                    eventRefreshIntervista.setParams({
                        "loadData": true
                    });
                    eventRefreshIntervista.fire();
                }
            } else {
                this.showToast('Salvataggio non effettuato!', 'ERROR');
            }
        });
        $A.enqueueAction(action);
    },
    /**
   * @description: answer of the first intervista
   * @dateCreate:29/05/2019
   * @author:Mady COLY
   */
    getRispondeIntervista1: function (component, event) {
        component.set("v.btnRightDisabled", true);
        var rispondeIntervista = component.get("v.rispondeIntervista");
        var source = event.getSource();
        var selectedRisponde = source.get("v.value");
        rispondeIntervista.D1_Futuro__c = selectedRisponde;
    },
    /**
   * @description: answer of the second question
   * @dateCreate:29/05/2019
   * @author:Mady COLY
   */
    getRispondeIntervista2: function (component, event) {
        component.set("v.btnRightDisabled", true);
        var rispondeIntervista = component.get("v.rispondeIntervista");
        var source = event.getSource();
        var selectedRisponde = source.get("v.value");
        component.set("v.noteToIntervista2Required", false);
        if (selectedRisponde == "NO")
            component.set("v.noteToIntervista2Required", true);
        component.set("v.rispondeIntervista", rispondeIntervista);
        rispondeIntervista.D2_Futuro__c = selectedRisponde;
    },
    /**
   * @description: answer of the third question
   * @dateCreate:29/05/2019
   * @author:Mady COLY
   */
    getRispondeIntervista3: function (component, event) {
        component.set("v.btnRightDisabled", true);
        var rispondeIntervista = component.get("v.rispondeIntervista");
        var source = event.getSource();
        var selectedRisponde = source.get("v.value");
        component.set("v.noteToIntervista3Required", false);
        if (selectedRisponde == "NO") {
            component.set("v.noteToIntervista3Required", true);
        }
        component.set("v.rispondeIntervista", rispondeIntervista);
        rispondeIntervista.D3_Futuro__c = selectedRisponde;
    },
    /**
   * @description: answer of the fourth question
   * @dateCreate:29/05/2019
   * @author:Mady COLY
   */
    getRispondeIntervista4: function (component, event) {
        component.set("v.btnRightDisabled", true);
        var rispondeIntervista = component.get("v.rispondeIntervista");
        var source = event.getSource();
        var selectedRisponde = source.get("v.value");
        component.set("v.noteToIntervista4Required", false);
        if (selectedRisponde == "RICHIESTA E NON OTTENUTA") {
            component.set("v.noteToIntervista4Required", true);
        }
        rispondeIntervista.D4_Futuro__c = selectedRisponde;
        component.set("v.rispondeIntervista", rispondeIntervista);
    },
    /**
   * @description: answer of the fifth question
   * @dateCreate:29/05/2019
   * @author:Mady COLY
   */
    getRispondeIntervista5: function (component, event) {
        component.set("v.btnRightDisabled", true);
        var rispondeIntervista = component.get("v.rispondeIntervista");
        var source = event.getSource();
        var selectedRisponde = source.get("v.value");
        component.set("v.noteToIntervista5", '');
        component.set("v.noteToIntervista5RequiredSI", false);
        component.set("v.noteToIntervista5RequiredNO", false);
        if (selectedRisponde == "SI") {
            component.set("v.noteToIntervista5RequiredSI", true);
        }
        else if (selectedRisponde == "NO") {
            component.set("v.noteToIntervista5RequiredNO", true);
        }
        rispondeIntervista.D5_Futuro__c = selectedRisponde;
        component.set("v.rispondeIntervista", rispondeIntervista);
    },
    /**
   * @description: answer of the sixth question
   * @dateCreate:29/05/2019
   * @author:Mady COLY
   */
    getRispondeIntervista6: function (component, event) {
        component.set("v.btnRightDisabled", true);
        var rispondeIntervista = component.get("v.rispondeIntervista");
        var source = event.getSource();
        var selectedRisponde = source.get("v.value");
        component.set("v.noteToIntervista6Required", false);
        if (selectedRisponde == "RICHIESTA E NON OTTENUTA") {
            component.set("v.noteToIntervista6Required", true);
        }
        rispondeIntervista.D6_Futuro__c = selectedRisponde;
        component.set("v.rispondeIntervista", rispondeIntervista);
    },
    /**
   * @description: answer of the sixth bis question
   * @dateCreate:14/06/2019
   * @author:Mady COLY
   */
    getRispondeIntervista6bis: function (component, event) {
        component.set("v.btnRightDisabled", true);
        var rispondeIntervista = component.get("v.rispondeIntervista");
        var source = event.getSource();
        var selectedRisponde = source.get("v.value");
        component.set("v.noteToIntervista6bisRequired", false);
        if (selectedRisponde == "SI") {
            component.set("v.noteToIntervista6bisRequired", true);
        }
        rispondeIntervista.D6bis_Futuro__c = selectedRisponde;
        component.set("v.rispondeIntervista", rispondeIntervista);
    },
    /**
   * @description: answer of the seventh question
   * @dateCreate:29/05/2019
   * @author:Mady COLY
   */
    getRispondeIntervista7: function (component, event) {
        component.set("v.btnRightDisabled", true);
        var rispondeIntervista = component.get("v.rispondeIntervista");
        var source = event.getSource();
        var selectedRisponde = source.get("v.value");
        component.set("v.noteToIntervista7Required", false);
        if (selectedRisponde == "RICHIESTA E NON OTTENUTA") {
            component.set("v.noteToIntervista7Required", true);
        }
        rispondeIntervista.D7_Futuro__c = selectedRisponde;
        component.set("v.rispondeIntervista", rispondeIntervista);
    },
    /**
   * @description: answer of the eight question
   * @dateCreate:06/06/2019
   * @author:Mady COLY
   */
    getRispondeIntervista8: function (component, event) {
        component.set("v.btnRightDisabled", true);
        var rispondeIntervista = component.get("v.rispondeIntervista");
        var source = event.getSource();
        var selectedRisponde = source.get("v.value");
        component.set("v.noteToIntervista8Required", false);
        if (selectedRisponde == "NO") {
            component.set("v.noteToIntervista8Required", true);
        }
        rispondeIntervista.D8_Futuro__c = selectedRisponde;
        component.set("v.rispondeIntervista", rispondeIntervista);
    },
    /**
   * @description: answer of the night question
   * @dateCreate:06/06/2019
   * @author:Mady COLY
   */
    getRispondeIntervista9: function (component, event) {
        component.set("v.btnRightDisabled", true);
        var rispondeIntervista = component.get("v.rispondeIntervista");
        var source = event.getSource();
        var selectedRisponde = source.get("v.value");
        component.set("v.noteToIntervista9Required", false);
        if (selectedRisponde == "SI") {
            component.set("v.noteToIntervista9Required", true);
        }
        rispondeIntervista.D9_Futuro__c = selectedRisponde;
        component.set("v.rispondeIntervista", rispondeIntervista);
    },
    /**
   * @description: answer of the ten question
   * @dateCreate:06/06/2019
   * @author:Mady COLY
   */
    getRispondeIntervista10: function (component, event) {
        component.set("v.btnRightDisabled", true);
        var rispondeIntervista = component.get("v.rispondeIntervista");
        var source = event.getSource();
        var selectedRisponde = source.get("v.value");
        component.set("v.noteToIntervista10Required", false);
        if (selectedRisponde == "NO") {
            component.set("v.noteToIntervista10Required", true);
        }
        rispondeIntervista.D10_Futuro__c = selectedRisponde;
        component.set("v.rispondeIntervista", rispondeIntervista);
    },
    /**
   * @description: answer of the eleven question
   * @dateCreate:06/06/2019
   * @author:Mady COLY
   */
    getRispondeIntervista11: function (component, event) {
        component.set("v.btnRightDisabled", false);
        var rispondeIntervista = component.get("v.rispondeIntervista");
        var source = event.getSource();
        var selectedRisponde = source.get("v.value");
        rispondeIntervista.D11_Futuro__c = selectedRisponde;
        component.set("v.noteToIntervista11Required", false);
        if (selectedRisponde == "NO") {
            component.set("v.noteToIntervista11Required", true);
        }
        component.set("v.rispondeIntervista", rispondeIntervista);
        component.set("v.terminataIntervista", true);
    },
    /**
   * @description: answer of the third question
   * @dateCreate:02/06/2019
   * @author:Mady COLY
   */
    getTerminataIntervista: function (component) {
        var risponde = component.get("v.rispondeIntervista").D11_Futuro__c;
        var validExpense = component.find('intervistaDomande11').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        // If we pass error checking, do some real work
        if (validExpense) {
            if (risponde != "") {
                var intervista = component.get('v.clienteFuturo');
                var risponde = component.get('v.rispondeIntervista');
                risponde.Intervista_Futuro__c = intervista.Id;
                risponde.Name = intervista.Name;
                var result = this.getValutazioneIntervista(component);
                risponde.Valutazione__c = result;
                try {
                    var action = component.get('c.upsertRisposta');
                    action.setParam('risposta', risponde);
                    action.setCallback(this, function (response) {
                        var state = response.getState();
                        if (state === 'SUCCESS') {
                            var dataRisposta = response.getReturnValue();
                            if (dataRisposta.error == false) {
                                intervista.COM_PraticheChiuse_Conforme__c = 1;
                                intervista.COM_ChiusoNon_Conforme__c = 0;
                                intervista.Ultimo_Esito__c = "Conclusa";
                                intervista.COM_Status_FUTURO__c = "Archived";
                                intervista.Data_Ultimo_Esito__c = new Date();
                                var action1 = component.get('c.updateSobject');
                                action1.setParam('mySobject', intervista);
                                action1.setCallback(this, function (response) {
                                    var state = response.getState();
                                    if (state === 'SUCCESS') {
                                        var data = response.getReturnValue();
                                        component.set('v.clienteFuturo', data);
                                        var eventRefreshIntervista = $A.get("e.c:eventFuturoClientePaginazione");
                                        eventRefreshIntervista.setParams({
                                            "loadData": true
                                        });
                                        eventRefreshIntervista.fire();
                                    } else {
                                        this.showToast('Salvataggio non effettuato!', 'ERROR');
                                    }
                                });
                                $A.enqueueAction(action1);
                            }
                            else {
                                this.showToast('Fallire quando si salvano le interviste!', 'ERROR');
                            }

                        } else {
                            this.showToast('Salvataggio non effettuato!', 'ERROR');
                        }
                    });
                    $A.enqueueAction(action);
                }
                catch (error) {
                    console.log(error);

                }
            }
        }

    },
    /**
   * @description: answer of the third question
   * @dateCreate:04/06/2019
   * @author:Mady COLY
   */
    getRispondeQuezioneIntervista: function (component, event) {
        var source = event.getSource();
        var selectedRisponde = source.get("v.value");
        component.set("v.rispondeQuezione2",selectedRisponde);
        if (selectedRisponde == 'SI') {
            component.set("v.concludiIntervista", false);
            component.set("v.startIntervista", true);
        } else {
            component.set("v.startIntervista", false);
            component.set("v.concludiIntervista", true);
        }
        component.set("v.btnRightDisabled", false);
    },
    /**
   * @description: evaluation of intervista
   * @dateCreate:06/06/2019
   * @author:Mady COLY
   */
    getValutazioneIntervista: function (component) {
        var rispondeIntervista = component.get('v.rispondeIntervista');
        var clienteFuturo = component.get("v.clienteFuturo");
        var result;
        if (this.getNumberIntervistaNonRicorda(component) >= 2) {
            result = ''
        }
        else if (rispondeIntervista.D5_Futuro__c == 'NO') {
            result = 'NEGATIVO';
        }
        else if (clienteFuturo.COM_TipoRinnovo__c != '' && rispondeIntervista.D6bis_Futuro__c == 'SI') {
            result = 'NEGATIVO';
        }
        else if (rispondeIntervista.D10_Futuro__c == 'SI') {
            result = 'NEGATIVO';
        }
        else if (this.getNumberIntervistaNegativa(component) == true) {
            result = 'NEGATIVO';
        } else {
            result = 'POSITIVO';
        }
        return result;
    },
    /**
   * @description: count the number of risponde Non utile in intervista
   * @dateCreate:06/06/2019
   * @author:Mady COLY
   */
    getNumberIntervistaNonRicorda: function (component) {
        var rispondeIntervista = component.get('v.rispondeIntervista');
        var count = 0;
        if (rispondeIntervista.D2_Futuro__c == "NON RICORDA")
            count += 1;
        if (rispondeIntervista.D3_Futuro__c == "NON RICORDA")
            count += 1;
        if (rispondeIntervista.D4_Futuro__c == "NON RICORDA")
            count += 1;
        if (rispondeIntervista.D5_Futuro__c == "NON RICORDA")
            count += 1;
        if (rispondeIntervista.D6_Futuro__c == "NON RICORDA")
            count += 1;
        if (rispondeIntervista.D7_Futuro__c == "NON RICORDA")
            count += 1;
        if (rispondeIntervista.D8_Futuro__c == "NON RICORDA")
            count += 1;
        return count;
    },
    /**
   * @description: count the number of risponde Negativo in intervista
   * @dateCreate:06/06/2019
   * @author:Mady COLY
   */
    getNumberIntervistaNegativa: function (component) {
        var rispondeIntervista = component.get('v.rispondeIntervista');
        var clienteFuturo = component.get("v.clienteFuturo");
        var valutazioneRisposte5 = this.interpretareRisposta("D5_Futuro__c", rispondeIntervista);
        if (clienteFuturo.COM_TipoRinnovo__c != '')
            var valutazioneRisposte6bis = this.interpretareRisposta("D6bis_Futuro__c", rispondeIntervista);
        var valutazioneRisposte10 = this.interpretareRisposta("D10_Futuro__c", rispondeIntervista);
        var countNegativa = 0;
        if (valutazioneRisposte5 == 'NEGATIVO')
            countNegativa++;
        if (valutazioneRisposte6bis == 'NEGATIVO')
            countNegativa++;
        if (valutazioneRisposte10 == 'NEGATIVO')
            countNegativa++;
        if (countNegativa >= 2)
            return true;
        return false;
    },
    /**
  * @description: concludi a intervista
  * @dateCreate:06/06/2019
  * @author:Mady COLY
  */
    getConcludiIntervista: function (component) {
        var intervista = component.get('v.clienteFuturo');
        intervista.COM_PraticheChiuse_Conforme__c = 0;
        intervista.COM_ChiusoNon_Conforme__c = 1;
        intervista.Ultimo_Esito__c = "Non accetta";
        intervista.COM_Status_FUTURO__c = "Archived";
        intervista.Data_Ultimo_Esito__c = new Date();
        var action = component.get('c.updateSobject');
        action.setParam('mySobject', intervista);
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var data = response.getReturnValue();
                component.set('v.clienteFuturo', data);
                var eventRefreshIntervista = $A.get("e.c:eventFuturoClientePaginazione");
                eventRefreshIntervista.setParams({
                    "loadData": true
                });
                eventRefreshIntervista.fire();
            } else {
                this.showToast('Salvataggio non effettuato!', 'ERROR');
            }
        });
        $A.enqueueAction(action);
    },
    /**
 * @description: interpretare la risposta
 * @dateCreate:13/06/2019
 * @author:Mady COLY
 */
    interpretareRisposta: function (Di_Futuro__c, rispondeIntervista) {
        if (Di_Futuro__c == 'D1_Futuro__c')
            var risponde = rispondeIntervista.D1_Futuro__c;
        else if (Di_Futuro__c == 'D2_Futuro__c')
            var risponde = rispondeIntervista.D2_Futuro__c;
        else if (Di_Futuro__c == 'D3_Futuro__c')
            var risponde = rispondeIntervista.D3_Futuro__c;
        else if (Di_Futuro__c == 'D4_Futuro__c')
            var risponde = rispondeIntervista.D4_Futuro__c;
        else if (Di_Futuro__c == 'D5_Futuro__c')
            var risponde = rispondeIntervista.D5_Futuro__c;
        else if (Di_Futuro__c == 'D6_Futuro__c')
            var risponde = rispondeIntervista.D6_Futuro__c;
        else if (Di_Futuro__c == 'D6bis_Futuro__c')
            var risponde = rispondeIntervista.D6bis_Futuro__c;
        else if (Di_Futuro__c == 'D7_Futuro__c')
            var risponde = rispondeIntervista.D7_Futuro__c;
        else if (Di_Futuro__c == 'D8_Futuro__c')
            var risponde = rispondeIntervista.D8_Futuro__c;
        else if (Di_Futuro__c == 'D9_Futuro__c')
            var risponde = rispondeIntervista.D9_Futuro__c;
        else if (Di_Futuro__c == 'D10_Futuro__c')
            var risponde = rispondeIntervista.D10_Futuro__c;
        else
            var risponde = rispondeIntervista.D11_Futuro__c;
        if (Di_Futuro__c == 'D2_Futuro__c' || Di_Futuro__c == 'D3_Futuro__c' || Di_Futuro__c == 'D5_Futuro__c' || Di_Futuro__c == 'D8_Futuro__c'
            || Di_Futuro__c == 'D9_Futuro__c' || Di_Futuro__c == 'D11_Futuro__c' || Di_Futuro__c == 'D6bis_Futuro__c') {
            if (risponde != '') {
                if ((risponde == 'SI' && (Di_Futuro__c != 'D6bis_Futuro__c' || Di_Futuro__c != 'D9_Futuro__c')) || (risponde == 'NO' && (Di_Futuro__c == 'D6bis_Futuro__c' || Di_Futuro__c == 'D9_Futuro__c')))
                    var result = 'POSITIVO';
                else
                    var result = 'NEGATIVO';
                if ((Di_Futuro__c == 'D6bis_Futuro__c' || Di_Futuro__c == 'D9_Futuro__c') && risponde == 'NON RICORDA')
                    var result = '';
            }
        }
        else if (Di_Futuro__c == 'D4_Futuro__c' || Di_Futuro__c == 'D6_Futuro__c' || Di_Futuro__c == 'D7_Futuro__c') {
            if (risponde != '') {
                if (risponde == 'NON RICHIESTA' || risponde == 'RICHIESTA E OTTENUTA')
                    var result = 'POSITIVO';
                else
                    var result = 'NEGATIVO';
            }
        }
        else
            var result = '';
        return result;
    },

})