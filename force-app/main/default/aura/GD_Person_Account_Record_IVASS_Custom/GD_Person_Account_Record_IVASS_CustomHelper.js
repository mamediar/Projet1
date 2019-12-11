({

    showToast: function(message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            message: message,
            type: type
        });
        toastEvent.fire();
    },
    getPersonAccountById: function(component) {
        var action1 = component.get("c.getPersonAccountById");
        action1.setParam('personAccountId', component.get('v.recordId'));
        action1.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var responseValue = response.getReturnValue();
                if (responseValue.error == false) {
                    component.set('v.personAccountObj', responseValue.data);
                    component.set('v.personAccountObjClone', responseValue.data);
                    this.getIscrittiByReferente(component, false);
                }
            } else {

            }
        });
        $A.enqueueAction(action1);
    },
    getAllRisposta: function(component) {
        var action = component.get("c.getAllRisposta");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var responseValue = response.getReturnValue();
                if (responseValue.error == false) {
                    var data = responseValue.data;
                    var ripostaList = [];
                    component.set('v.optionRisposta', data);
                    data.forEach(element => {
                        var myObject = {
                            'label': element.Risposta__c,
                            'value': element.Risposta__c
                        };
                        ripostaList.push(myObject);
                    });
                    component.set('v.ripostaList', ripostaList)
                }
            } else {

            }
        });
        $A.enqueueAction(action);
    },
    getDoInit: function(component, event) {
        this.getPersonAccountById(component);
        this.getAllRisposta(component);
    },
    getHandleRisposta: function(component, event) {
        var selectedOptionValue = event.getParam("value");
        component.set('v.selectOpt', selectedOptionValue);
        if (selectedOptionValue == 'Sono io') {
            this.getIscrittiByReferente(component, true);
            component.set('v.showTextArea', true);
            component.set('v.showTable', true)
        } else {
            component.set('v.showTextArea', true);
            component.set('v.showTable', false);
        }
    },
    getIscrittiByReferente: function(component, applyLogic) {
        var action = component.get("c.getIscrittiByReferente");
        action.setParam('referente', component.get('v.recordId'));
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var responseValue = response.getReturnValue();
                if (responseValue.error == false) {
                    var courseIscritti = responseValue.data;
                    if (applyLogic == true) {
                        component.set('v.courseIscritti', courseIscritti);
                        console.log('courseIscritti : ' + JSON.stringify(courseIscritti));
                        if (courseIscritti.length > 0 && this.getVerifyIfStatusAllCouresIsIscritto(courseIscritti) == true) {
                            console.log('Is iscritto');
                            this.getLogicForAllCoursesIsIscritto(component, courseIscritti)
                        } else {
                            console.log('Is not iscritto');
                            this.getIscrittiByReferenteIsStatoNotIscritto(component);
                        }
                    } else {
                        component.set('v.courseIscritti', courseIscritti);
                        console.log('courseIscritti : ' + JSON.stringify(courseIscritti));
                    }
                } else
                    component.set('v.courseIscritti', []);
            } else {

            }
        });
        $A.enqueueAction(action);
    },
    getIscrittiByReferenteIsStatoNotIscritto: function(component) {
        var action = component.get("c.getIscrittiByReferenteIsStatoNotIscritto");
        action.setParam('referente', component.get('v.recordId'));
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var responseValue = response.getReturnValue();
                if (responseValue.error == false) {
                    var data = responseValue.data;
                    if (data.length > 0) {
                        component.set('v.courseIscritti', data);
                        this.getLogicForAllCoursesIsNotIscritto(component, data);
                    }

                } else {
                    this.showToast('Errore', 'Error');
                }
            } else {
                this.showToast('Errore', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    getVerifyIfStatusAllCouresIsIscritto: function(coursesList) {
        var status = true;
        coursesList.forEach(element => {
            if (element.Stato_Corso__c != 'ISCRITTO' && status == true) {
                status = false;
            }
        });
        return status;
    },
    getVerifyIfStatusAllCouresIsFINITO: function(coursesList) {
        var status = true;
        coursesList.forEach(element => {
            if (element.Stato_Corso__c != 'FINITO' && status == true) {
                status = false;
            }
        });
        return status;
    },
    getVerifyIfCoursesHaveNotInNameStringCSIorCSP: function(coursesList) {
        var status = true;
        coursesList.forEach(element => {
            if ((element.Corso__r.Name.includes("CIS") || element.Corso__r.Name.includes("CSP")) && status == true) {
                status = false;
            }
        });
        return status;
    },
    getVerifyIfCoursesHaveInNameStringCSI: function(coursesList) {
        var status = true;
        coursesList.forEach(element => {

            if (!element.Corso__r.Name.includes("CIS") && status == true) {
                status = false;
            }
        });
        return status;
    },
    getVerifyIfCoursesHaveInNameStringCSIandCSP: function(coursesList) {
        var status = true;
        coursesList.forEach(element => {
            if ((!element.Corso__r.Name.includes("CIS") && !element.Corso__r.Name.includes("CSP")) || (element.Corso__r.Name.includes("CIS") && !element.Corso__r.Name.includes("CSP")) || (!element.Corso__r.Name.includes("CIS") && element.Corso__r.Name.includes("CSP")) && status == true) {
                status = false;
            }
        });
        return status;
    },
    getLogicForAllCoursesIsIscritto: function(component, courseIscritti) {
        if (this.getVerifyIfCoursesHaveNotInNameStringCSIorCSP(courseIscritti) == true) {
            console.log('ALL THE COURSES HAVE NOT IN THE NAME THE STRING CSI OR CSP');
            this.getCoursesScriptOptionForMyType(component, 'NOCSI_ISCR');
        } else if (this.getVerifyIfCoursesHaveInNameStringCSI(courseIscritti) == true) {
            console.log('ALL THE COURSES HAVE IN THE NAME THE STRING CSI');
            this.getCoursesScriptOptionForMyType(component, 'ALL_ISCR');
        } else if (this.getVerifyIfCoursesHaveInNameStringCSIandCSP(courseIscritti) == true) {
            console.log('ALL THE COURSES HAVE IN THE NAME THE STRING CSI AND CSP');
            this.getCoursesScriptOptionForMyType(component, 'CSI_ISCR');
        } else {
            console.log('autre');
        }
    },
    getLogicForAllCoursesIsNotIscritto: function(component, courseNotIscritti) {
        if (this.getVerifyIfCoursesHaveNotInNameStringCSIorCSP(courseNotIscritti) == true && this.getVerifyIfStatusAllCouresIsFINITO(courseNotIscritti) == true) {
            console.log(' ALL THE COURSES HAVE NOT IN THE NAME THE STRING CSI OR CSP');
            this.getCoursesScriptOptionForMyType(component, '1_NO_ISCR_NOCSI');
        } else if (this.getVerifyIfCoursesHaveInNameStringCSI(courseNotIscritti) == true && this.getVerifyIfStatusAllCouresIsFINITO(courseNotIscritti) == true) {
            console.log('ALL THE COURSES HAVE IN THE NAME THE STRING CSI AND THE STATUS IS FINITO');
            this.getCoursesScriptOptionForMyType(component, '1_CSI_END');
        } else if (this.getVerifyIfCoursesHaveInNameStringCSI(courseNotIscritti) == true && this.getVerifyIfStatusAllCouresIsFINITO(courseNotIscritti) == false) {
            console.log('ALL THE COURSES HAVE IN THE NAME THE STRING CSI AND THE STATUS IS NOT FINITO');
            this.getCoursesScriptOptionForMyType(component, '1_CSI_END');
        } else if (this.getVerifyIfCoursesHaveInNameStringCSIandCSP(courseNotIscritti) == true && this.getVerifyIfStatusAllCouresIsFINITO(courseNotIscritti) == true) {
            console.log('ALL THE COURSES HAVE IN THE NAME THE STRING CSI AND CSP Mixed AND STATUS ');
            this.getCoursesScriptOptionForMyType(component, 'NOCSI_ISCR');
        } else {
            console.log('autre');
        }
    },
    getCoursesScriptOptionForMyType: function(component, myType) {
        var action = component.get("c.getCoursesAnswerInTypeForMyType");
        action.setParam('myType', myType);
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var responseValue = response.getReturnValue();
                if (responseValue.error == false) {
                    var data = responseValue.data;
                    var iscritto = component.get('v.courseIscritti')[0];
                    console.log('iscrittoScript : ' + JSON.stringify(iscritto));
                    if (iscritto.Filiale__c != '' && iscritto.Filiale__c != undefined) {
                        this.getFilialeById(component, iscritto.Filiale__c);
                    } else {
                        this.replaceWordFILByCodeFiliale(data, "");
                    }
                    this.replaceWordMailByMailCompass(data, "Formazione.IVASS@compass.it");
                    component.set('v.courseScriptOptList', data);
                } else {
                    component.set('v.courseScriptOptList', []);
                }
            } else {

            }
            console.log(JSON.stringify(component.get('v.courseScriptOptList')));
        });
        $A.enqueueAction(action);
    },
    setIsritti: function(component, iscritti) {
        var action = component.get("c.setIsritti");
        console.log('iscritti :' + JSON.stringify(iscritti));
        action.setParam('iscritti', iscritti);
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var responseValue = response.getReturnValue();
                if (responseValue.error == false) {
                    var data = responseValue.data;
                    this.showToast('salvata correttamente', 'Success');
                    component.set('v.requiredSavePA', true);
                    document.location.reload(true);
                } else {
                    this.showToast('Errore', 'Error');
                }
            } else {
                alert('Error');
            }
        });
        $A.enqueueAction(action);
    },
    getSaveRispostaSelected: function(component, event) {
        var myText = component.get('v.selectOpt');
        var iscrittiList = component.get('v.courseIscritti');
        var myIscritti = iscrittiList[0];
        var myOptions = component.get('v.optionRisposta');
        console.log('myOptions : ' + JSON.stringify(myOptions));
        var myId = this.researchIdDealerCoursesScript(myOptions, myText);
        console.log('myId : ' + myId);
        if (myId != '') {
            myIscritti.Esito_Outsourcer__c = myId;
            this.setIsritti(component, myIscritti);
        }
    },
    createNoteForPersonAccount: function(component) {
        var personAccountObj = component.get('v.personAccountObj');
        var contentNote = component.get('v.myText');
        var action = component.get("c.createNoteForPersonAccount");
        action.setParams({
            'account': personAccountObj,
            'contentNote': contentNote
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var responseValue = response.getReturnValue();
                if (responseValue.error == false) {
                    var data = responseValue.data;
                    this.showToast('la nota è stata registrata correttamente', 'Success');
                    component.set('v.showModal1', false);
                    component.set('v.myText', '');
                } else {
                    this.showToast('Errore', 'Error');
                }
            } else {
                this.showToast('Errore', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    getNotesByPersonAccount: function(component) {
        component.set('v.showModal2', true);
        var personAccountObj = component.get('v.personAccountObj');
        var action = component.get("c.getNotesByPersonAccount");
        action.setParams({ 'account': personAccountObj });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var responseValue = response.getReturnValue();
                if (responseValue.error == false) {
                    var data = responseValue.data;
                    component.set('v.notesForPA', data);
                } else {
                    this.showToast('Errore', 'Error');
                }
            } else {
                this.showToast('Errore', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    researchIdDealerCoursesScript: function(dataList, tmp) {
        console.log('dataList :' + dataList);
        var result = '';
        dataList.forEach(element => {
            if (element.Risposta__c != '' && element.Risposta__c == tmp) {
                result = element.Id;
            }
        });
        return result;
    },
    replaceString: function(myText, toReplace, replaceWith) {
        var myText = myText.replace(toReplace, replaceWith);
        return myText;
    },
    replaceWordFILByCodeFiliale: function(data, codeFiliale) {
        data.forEach(element => {
            if (element.Answer__c != '') {
                element.Answer__c = this.replaceString(element.Answer__c, "#FIL#", codeFiliale);
            }
        });
    },
    replaceWordMailByMailCompass: function(data, mailCompass) {
        data.forEach(element => {
            if (element.Answer__c != '') {
                element.Answer__c = this.replaceString(element.Answer__c, "#MAILOUT#", mailCompass);
            }
        });
    },
    getFilialeById: function(component, idFiliale) {
        var action = component.get("c.getFilialeById");
        action.setParam('idFiliale', idFiliale);
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var responseValue = response.getReturnValue();
                if (responseValue.error == false) {
                    var data = responseValue.data;
                    console.log(' dataFiliale : ' + JSON.stringify(data));
                    var dataList = component.get('v.courseScriptOptList');
                    this.replaceWordFILByCodeFiliale(dataList, data.Name);
                    component.set('v.courseScriptOptList', dataList);
                } else {
                    // component.set('v.courseScriptOptList', []);
                }
            } else {

            }
        });
        $A.enqueueAction(action);
    },
})