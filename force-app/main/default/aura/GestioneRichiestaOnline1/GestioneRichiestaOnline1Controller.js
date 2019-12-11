({
    /**
     * @Modified by Abdoulaye 19/06/2019
     * @param {*} component 
     * @param {*} event  
     * @param {*} helper 
     */
    doInit: function(component, event, helper) {

        var idCase = component.get('v.recordId');
        var pageSize = component.get("v.pageSize");

        var action = component.get('c.getCase');
        action.setParam('idCase', idCase);
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var resultat = response.getReturnValue();
                if (resultat.error == false) {
                    component.set("v.codeQueue", resultat.developerName);
                    var caseObject = resultat.case;
                    component.set('v.case', caseObject);
                    console.log('#l resultat ', JSON.stringify(resultat));
                    var anomalies = resultat.anomalies; // caseObject.Anomalie_Doc__r;
                    var paginationList = [];
                    if (typeof anomalies != 'undefined') {
                        component.set('v.anomalies', anomalies);
                        component.set("v.totalSize", anomalies.length);
                        component.set("v.start", 0);
                        component.set("v.end", pageSize - 1);

                        for (var i = 0; i < pageSize; i++) {
                            paginationList.push(anomalies[i]);
                        }
                    }
                    console.log('#l paginationList', JSON.stringify(paginationList));
                    component.set('v.paginationList', paginationList);
                    helper.helperGetValues1(component);
                    component.set('v.showListValues1', true);
                    //call method to get list values 1
                    /*                    
                    var handleList1 = new Promise(function(resolve, reject){
                        helper.helperGetValues1(component);
                        resolve(component);
                    });
                    handleList1.then(function(cmp){
                        var parents = cmp.get("v.listValues");
                        if (parents.length > 0) {
                            cmp.set('v.showListValues1', true);
                            var parent = parents[0];
                            cmp.set("v.firstLevel", parent);
                            var listValues2 = helper.helperGetValues2(cmp, parent);
                            cmp.set('v.listValues2', listValues2);
                            if (listValues2.length > 0) {
                                var defaultChoiceSecondLevel = listValues2[0];
                                cmp.set("v.secondLevel", defaultChoiceSecondLevel.label);
                                if (defaultChoiceSecondLevel.label.toUpperCase() == 'CHIEDE DI ESSERE RICHIAMATO') {
                                    component.set('v.openRichiami', true);
                                }
                                cmp.set("v.showListValues2", true);
                                cmp.set('v.dispositionName', defaultChoiceSecondLevel.value);
                                helper.handleOpenAppuntamento(cmp);
                                helper.handleOpenQuestion(cmp);
                                var listValues3 = helper.helperGetValues3(cmp, defaultChoiceSecondLevel.label);
                                if (listValues3.length > 0) {
                                    var newOption = {"code":"[]", "label":"", "value":"","stati":"[]","families":[],"fea":true};
                                    listValues3.unshift(newOption);
                                    component.set('v.listValues3', listValues3);
                                    var defaultChoicethirdLevel = listValues3[0];
                                    var defaultChoiceThirdLabel = defaultChoicethirdLevel.label;
                                    cmp.set("v.thirdLevel", defaultChoiceThirdLabel);
                                    cmp.set("v.showListValues3", true);
                                    cmp.set('v.dispositionName', defaultChoicethirdLevel.value);
                                }
                            } 
                        }                        
                    });
                    */

                    helper.handleQuestions(component, caseObject.stato_ocs__c);
                    helper.handleGetRichiamiLimiteTemporel(component);
                } else {
                    console.log('message', resultat.message);
                }
            }
        });
        $A.enqueueAction(action);
    },

    onSelectChange: function(component, event, helper) {
        var selected = component.find("records").get("v.value");
        var paginationList = [];
        var anomalies = component.get("v.anomalies");
        for (var i = 0; i < selected; i++) {
            paginationList.push(anomalies[i]);
        }
        component.set('v.paginationList', paginationList);
    },

    /**
     * @Modified by Abdoulaye 19/06/2019
     * @param {*} component 
     * @param {*} event 
     * @param {*} helper 
     */
    searchGetValues2: function(component, event, helper) {
        console.log('### searchGetValues2 ###');
        var select = document.getElementById("categoryPicklist");
        var firstLevel = select.options[select.selectedIndex].value;
        component.set("v.firstLevel", firstLevel);
        var developerName = component.get('v.codeQueue');
        var caseObject = component.get('v.case');
        var listeValues2 = helper.helperGetValues2(component, firstLevel);
        var linkBozza = '';
        if (caseObject.hasOwnProperty('RO_Link_Bozza__c')) {
            linkBozza = caseObject.RO_Link_Bozza__c;
        }
        listeValues2 = helper.removeInvioLinkRiprezaBozza(listeValues2, linkBozza);
        component.set('v.listValues2', listeValues2);
        if (listeValues2.length > 0) {
            var defaultChoice = listeValues2[0];
            component.set("v.showListValues2", true);
            component.set("v.secondLevel", defaultChoice.label);
            if (defaultChoice.label.toUpperCase() == 'CHIEDE DI ESSERE RICHIAMATO') {
                component.set('v.openRichiami', true);
            }
            helper.handleOpenAppuntamento(component);
            helper.handleOpenQuestion(component);

            var roVecchioCellulare = caseObject.hasOwnProperty('RO_Vecchio_Cellulare__c') ? caseObject.RO_Vecchio_Cellulare__c : null;

            var listValues3 = helper.helperGetValues3(component, defaultChoice.label);
            if (listValues3.length > 0) {
                var newOption = { "code": "[]", "label": "", "value": "", "stati": "[]", "families": [], "fea": true };
                listValues3.unshift(newOption);
                component.set('v.listValues3', listValues3);
                var defaultChoiceThirdLevel = listValues3[0];
                component.set("v.showListValues3", true);
                component.set("v.thirdLevel", defaultChoiceThirdLevel.label);
                component.set('v.dispositionName', defaultChoiceThirdLevel.value);
                component.set("v.listValues3", listValues3);
            } else {
                component.set("v.showListValues3", false);
                component.set("v.thirdLevel", "");
                component.set('v.dispositionName', defaultChoice.value);
                component.set("v.listValues3", []);
            }
            if (firstLevel.toUpperCase() == 'CONTATTO NON ESEGUITO' && defaultChoice.label.toUpperCase() == 'NUMERO INESISTENTE') {
                if (developerName == 'Q337' || developerName == 'Q338') {
                    component.set('v.isOpen', true);
                } else if ((developerName == 'Q339' || developerName == 'Q376') && roVecchioCellulare != null && roVecchioCellulare != '') {
                    component.set('v.isOpen', true);
                }
            }
        } else {
            component.set("v.showListValues2", false);
            component.set("v.secondLevel", "");
        }
    },

    /**
     * @Modified by Abdoulaye 19/06/2019
     * @param {*} component 
     * @param {*} event 
     * @param {*} helper 
     */
    searchGetValues3: function(component, event, helper) {
        console.log('### searchGetValues3 ###');
        var developerName = component.get('v.codeQueue');
        var select = document.getElementById("categoryPicklist2");
        var secondLevelArray = select.options[select.selectedIndex].value.split('-');
        var secondLevelVAlue = secondLevelArray[0];
        var secondLevelLabel = secondLevelArray[1];
        component.set("v.secondLevel", secondLevelLabel);
        helper.handleOpenAppuntamento(component);
        helper.handleOpenQuestion(component);

        var caseObject = component.get('v.case');
        var roVecchioCellulare = caseObject.hasOwnProperty('RO_Vecchio_Cellulare__c') ? caseObject.RO_Vecchio_Cellulare__c : null;

        if (secondLevelLabel.toUpperCase() == 'NUMERO INESISTENTE') {
            if (developerName == 'Q337' || developerName == 'Q338') {
                component.set('v.isOpen', true);
            } else if ((developerName == 'Q339' || developerName == 'Q376') && roVecchioCellulare != null && roVecchioCellulare != '') {
                component.set('v.isOpen', true);
            }
        } else if (secondLevelLabel.toUpperCase().toUpperCase() == 'CHIEDE DI ESSERE RICHIAMATO') {
            component.set('v.openRichiami', true);
        }

        var listeValues3 = helper.helperGetValues3(component, secondLevelLabel);
        var linkBozza = '';
        if (caseObject.hasOwnProperty('RO_Link_Bozza__c')) {
            linkBozza = caseObject.RO_Link_Bozza__c;
        }
        listeValues3 = helper.removeInvioLinkRiprezaBozza(listeValues3, linkBozza);
        console.log('#l linkBozza ', linkBozza);
        console.log('#l listeValues3 ', JSON.stringify(listeValues3));

        if (listeValues3.length > 0) {
            if (developerName == 'Q338' && secondLevelLabel.toUpperCase() == 'CONFERMA NUOVO RECAPITO') {
                listeValues3 = listeValues3.filter(item => item.label == '');
            } else if (developerName == 'Q338' && (secondLevelLabel.toUpperCase() == 'Caricherà la documentazione'.toUpperCase() ||
                    secondLevelLabel.toUpperCase() == 'Ha già caricato la documentazione'.toUpperCase())) {
                listeValues3 = listeValues3.filter(item => item.label == '');
            }
            var newOption = { "code": "[]", "label": "", "value": "", "stati": "[]", "families": [], "fea": true };
            listeValues3.unshift(newOption);
            component.set('v.listValues3', listeValues3);

            var defaultChoice = listeValues3[0];
            component.set("v.showListValues3", true);
            //component.set("v.thirdLevel", defaultChoice);            
            component.set("v.thirdLevel", defaultChoice.label);
            component.set('v.dispositionName', defaultChoice.value);
        } else {
            component.set('v.dispositionName', secondLevelVAlue);
            component.set("v.showListValues3", false);
            component.set("v.listValues3", []);
            component.set("v.thirdLevel", "");
        }
    },

    /**
     * @Modified by Abdoulaye 19/06/2019
     * @param {*} component 
     * @param {*} event 
     * @param {*} helper 
     */
    searchGetValues4: function(component, event, helper) {
        var select = document.getElementById("categoryPicklist3");
        //var categorie = select.options[select.selectedIndex].value;
        var thirdLevelArray = select.options[select.selectedIndex].value.split('-');
        var thirdLevelLabel = thirdLevelArray[1];
        var thirdLevelValue = thirdLevelArray[0];
        component.set('v.dispositionName', thirdLevelValue);
        component.set("v.thirdLevel", thirdLevelLabel);
    },

    /**
     * @author Abdoulaye AD
     * @param {*} component 
     * @param {*} event 
     * @param {*} helper 
     */
    rejectSecondNumero: function(component, event, helper) {
        component.set('v.isOpen', false);
    },

    /**
     * @author Abdoulaye AD
     * @param {*} component 
     * @param {*} event 
     * @param {*} helper 
     */
    confirmSecondNumero: function(component, event, helper) {
        component.set('v.showLink', true);
        component.set('v.isOpen', false);
    },

    /**
     * @author Abdoulaye
     * @param {*} component 
     * @param {*} event 
     * @param {*} helper 
     */
    navigateToLinkEvo: function(component, event, helper) {
        try {
            var evt = $A.get("e.force:navigateToComponent");
            evt.setParams({
                componentDef: "c:LinkEvo",
                componentAttributes: {
                    task: 'TK000004B9',
                    infoPre: 'WFL',
                    infoPost: 'CO_DIS_CEL',
                    numeroPratica: 'CO'
                }
            });
            evt.fire();

        } catch (error) {
            console.error('error', error);
        }
    },

    /**
     * @Created by Abdoulaye 19/06/2019
     * @param {*} component 
     * @param {*} event 
     * @param {*} helper 
     */
    update: function(component, event, helper) {
        //var note = component.find('note').get('v.value');
        var caseObject = component.get('v.case');
        var dispositionName = component.get('v.dispositionName');
        var firstLevel = component.get('v.firstLevel');
        var secondLevel = component.get('v.secondLevel');
        var thirdLevel = component.get('v.thirdLevel');
        //caseObject.Note__c = note;
        console.log('levels', firstLevel + ' ' + secondLevel + ' ' + thirdLevel);

        var nuovoCellulare = caseObject.hasOwnProperty('RO_Nuovo_Cellulare__c') ? caseObject.RO_Nuovo_Cellulare__c : null;
        var vecchioCellulare = caseObject.hasOwnProperty('RO_Vecchio_Cellulare__c') ? caseObject.RO_Vecchio_Cellulare__c : null;
        caseObject.RO_Nuovo_Cellulare__c = nuovoCellulare;
        caseObject.RO_Vecchio_Cellulare__c = vecchioCellulare;

        if (secondLevel.toUpperCase() == 'CHIEDE DI ESSERE RICHIAMATO' || thirdLevel.toUpperCase() == 'CHIEDE DI ESSERE RICHIAMATO') {
            caseObject.RecallDate__c = component.get('v.recallDate');
        }

        var action = component.get('c.updateCase');
        action.setParams({
            'caseObject': caseObject,
            'code': dispositionName,
            'firstLevel': firstLevel,
            'secondLevel': secondLevel,
            'thirdLevel': thirdLevel,
            'showLinkEvo': component.get('v.showLink')
        });
        action.setCallback(this, function(response) {
            if (response.getState() == 'SUCCESS') {
                var data = response.getReturnValue();
                console.log('#l data ', JSON.stringify(data));
                var showLinkEvo = data.linkevo;
                component.set('v.showLinkEvo', showLinkEvo);
                component.set('v.case', data.case);
                component.set('v.isOpenDomanda', data.isOpenDomanda);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Successo!",
                    "message": "Il record è stato aggiornato con successo.",
                    "type": "success"
                });
                toastEvent.fire();
                var codeQueue = component.get("v.codeQueue");
                if (firstLevel.toUpperCase() == 'CONTATTO ESEGUITO' &&
                    secondLevel.toUpperCase() == 'INVIO LINK RIPRESA BOZZA' &&
                    (component.get("v.queues3").indexOf(codeQueue) != -1 || codeQueue == 'Q375')) {
                    showLinkEvo = true;
                    component.set('v.showLinkBozza', showLinkEvo);
                }
                if (!showLinkEvo) {
                    var devName = data.devName;
                    helper.backToListView(component, devName);
                }
            } else {
                console.log('response.getState() == ', response.getState());
            }
        });
        $A.enqueueAction(action);
    },

    /**
     * @Created by Abdoulaye
     * @param {*} component 
     * @param {*} event 
     * @param {*} helper 
     */
    cancelDomanda: function(component, event, helper) {
        component.set('v.isOpenDomanda', false);
    },

    /**
     * @Created by Abdoulaye
     * @param {*} component 
     * @param {*} event 
     * @param {*} helper 
     */
    saveDomanda: function(component, event, helper) {
        var caseObject = component.get('v.case');
        var questions = component.get('v.questions');
        if (Array.isArray(questions)) {
            questions.forEach(function(question, index) {
                if (question.num != 3) {
                    question.response = component.get('v.importoCliente');
                } else {
                    question.response = component.get('v.modalitaRimborso');
                }
                questions[index] = question;
            });
        }
        var questionManagement = {
            'questions': questions,
            'products': component.get('v.prodotti')
        };
        var action = component.get('c.sendDomanda');
        action.setParams({ 'caseObject': caseObject, 'questionManagement': questionManagement });
        action.setCallback(this, function(response) {
            if (response.getState() == 'SUCCESS') {
                var result = response.getReturnValue();
                console.log('#l ### result ' + JSON.stringify(result));
                var importo = null;
                if (result.error == false) {
                    var data = result.data;
                    var tipoPratica = data.tipoPratica;
                    if (tipoPratica == 'CA') {
                        if (data.hasOwnProperty('movimenti')) {
                            importo = data.movimenti.importo;
                        } else {
                            importo = 0;
                        }
                    } else if (tipoPratica == 'CP') {
                        if (data.hasOwnProperty('recuperaCpay')) {
                            importo = data.recuperaCpay.importo;
                        } else {
                            importo = 0;
                        }
                    } else if (tipoPratica == 'CO') {
                        if (data.hasOwnProperty('mftcoecoElemento')) {
                            importo = data.mftcoecoElemento.mftcoecoIMPORTO;
                        }
                    }
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "The response has been confirmed",
                        "type": "success"
                    });
                    toastEvent.fire();
                    component.set('v.tipoPratica', tipoPratica);
                    component.set('v.importo', importo);
                    console.log('data', JSON.stringify(data));
                    console.log('tipoPratica', tipoPratica);
                    console.log('importo', importo);
                } else {
                    console.log('message', JSON.stringify(result.message));
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Some error was occurated, you may refresh the page",
                        "type": "error"
                    });
                    toastEvent.fire();
                }
            }
        });
        $A.enqueueAction(action);
        component.set('v.questionManagement', questionManagement);
        component.set('v.isOpenDomanda', true);
        component.set('v.questions', questions);
    },

    /**
     * @Created by Abdoulaye 29/07/2019
     * @param {*} component 
     * @param {*} event 
     * @param {*} helper 
     */
    closeAppuntamento: function(component) {
        component.set('v.isOpenAppuntamento', false);
    },

    /**
     * @Created by Abdoulaye 30/07/2019
     * @param {*} component 
     * @param {*} event 
     * @param {*} helper 
     */
    handleChange: function(component, event, helper) {
        var inputChecked = event.getSource();
        var checked = event.getSource().get('v.checked');
        var value = event.getSource().get('v.value');

        var myCheckboxes = component.find('mygroupRisposta');
        var chk = (myCheckboxes.length == null) ? [myCheckboxes] : myCheckboxes;
        chk.forEach(function(checkbox) {
            checkbox.set('v.checked', false);
        });
        inputChecked.set('v.checked', checked);
        if (checked) {
            component.set('v.openConfermaRisposta', true);
        }
        component.set('v.valueConfermaRisposta', value);
        component.set('v.checkedConfermaRisposta', checked);
    },

    /**
     * @Created by Abdoulaye 31/07/2019
     * @param {*} component 
     * @param {*} event 
     * @param {*} helper 
     */
    cancelConfermaRisposta: function(component, event, helper) {
        component.set('v.openConfermaRisposta', false);
    },

    /**
     * @Created by Abdoulaye 31/07/2019
     * @param {*} component 
     * @param {*} event 
     * @param {*} helper 
     */
    saveConfermaRisposta: function(component, event, helper) {
        var value = component.get('v.valueConfermaRisposta');
        var checked = component.get('v.checkedConfermaRisposta');
        if (value == 'OK') {
            if (checked) {
                component.set('v.showLinkEvo', checked);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "You may now clik to the link evo!",
                    "type": "success"
                });
                toastEvent.fire();
                helper.handleSaveNote(component);
            }
        } else if (value == 'KO') {
            if (checked) {
                /*  var caseObject = component.get('v.case');
                    var action = component.get('c.updateNoteCase');
                    action.setParam('caseObject', caseObject);
                    action.setCallback(this, function(response) {
                        if(response.getState() == 'SUCCESS'){
                            var result = response.getReturnValue();
                            component.set('v.case', result.case);
                            component.set('v.showLinkEvo', result.linkevo);
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "Success!",
                                "message": "The record has been updated successfully, you may now clik to the link evo!",
                                "type": "success"
                            });
                            toastEvent.fire();
                        } else {                        
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "Error!",
                                "message": "Some error was occurated, you may refresh the page",
                                "type": "error"
                            });
                            toastEvent.fire();
                        }
                    });
                    $A.enqueueAction(action);
                */
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Info!",
                    "message": "You may now choose Identità non confermata to resolve the discrepancy in evo!",
                    "type": "info"
                });
                toastEvent.fire();
                helper.handleSaveNote(component);
            }
        } else if (value == 'NON RICORDA') {
            if (checked) {
                component.set('v.openRichiami', true);
                helper.handleSaveNote(component);
            }
        }
        component.set('v.openConfermaRisposta', false);
    },

    cancelRichiami: function(component, event, helper) {
        component.set('v.openRichiami', false);
    },

    saveRichiami: function(component, event, helper) {
        var caseObject = component.get('v.case');
        console.log('caseObject', JSON.stringify(caseObject));
        var recallDate = component.get('v.recallDate');
        console.log('recallDate', recallDate);
        var tentativoNonRicorda = caseObject.hasOwnProperty('TentativoNonRicorda__c') ? caseObject.TentativoNonRicorda__c : null;
        caseObject.TentativoNonRicorda__c = tentativoNonRicorda;
        caseObject.RecallDate__c = recallDate;
        var action = component.get('c.updateNoteCase');
        var sendEmail = false;
        /*if (component.get('v.codeQueue') == 'Q338') {
            sendEmail = true;
        }*/
        action.setParams({ 'caseObject': caseObject, 'developerName': '', 'sendEmail': sendEmail });
        action.setCallback(this, function(response) {
            if (response.getState() == 'SUCCESS') {
                var result = response.getReturnValue();
                component.set('v.case', result.case);
                component.set('v.showLinkEvo', result.linkevo);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "The record has been updated successfully, you may now clik to the link evo!",
                    "type": "success"
                });
                toastEvent.fire();
            } else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Some error was occurated, you may refresh the page",
                    "type": "error"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
        component.set('v.openRichiami', false);
    },

    dateUpdate: function(component, event, helper) {

        var recallDate = component.get("v.recallDate");
        console.log('recallDate', recallDate);
        if (recallDate != null) {
            //var limit = component.get('v.richiamiTempLimit') * 1;

            if (helper.isRecallDateInPast(component, recallDate)) {
                return;
            }

            if (helper.isDateInWeekEndOrToday(component, recallDate)) {
                return;
            }

            if (helper.isTimeIsCorrect(component, recallDate)) {
                return;
            }
            helper.isRecallDateIsCorrect(component, recallDate);
        }
    },

    /**
     * @author Abdoulaye
     * @param {*} component 
     * @param {*} event 
     * @param {*} helper 
     */
    first: function(component, event, helper) {
        var anomalies = component.get("v.anomalies");
        var pageSize = component.get("v.pageSize");
        var paginationList = [];
        for (var i = 0; i < pageSize; i++) {
            paginationList.push(anomalies[i]);
        }
        component.set('v.paginationList', paginationList);
    },

    /**
     * @author Abdoulaye
     * @param {*} component 
     * @param {*} event 
     * @param {*} helper 
     */
    last: function(component, event, helper) {
        var anomalies = component.get("v.anomalies");
        var pageSize = component.get("v.pageSize");
        var totalSize = component.get("v.totalSize");
        var paginationList = [];
        for (var i = totalSize - pageSize + 1; i < totalSize; i++) {
            paginationList.push(anomalies[i]);
        }
        component.set('v.paginationList', paginationList);
    },

    /**
     * @author Abdoulaye
     * @param {*} component 
     * @param {*} event 
     * @param {*} helper 
     */
    next: function(component, event, helper) {
        var anomalies = component.get("v.anomalies");
        var end = component.get("v.end");
        var start = component.get("v.start");
        var pageSize = component.get("v.pageSize");
        var paginationList = [];
        var counter = 0;
        for (var i = end + 1; i < end + pageSize + 1; i++) {
            if (anomalies.length > end) {
                paginationList.push(anomalies[i]);
                counter++;
            }
        }
        start = start + counter;
        end = end + counter;
        component.set("v.start", start);
        component.set("v.end", end);
        component.set('v.paginationList', paginationList);
    },

    /**
     * @author Abdoulaye
     * @param {*} component 
     * @param {*} event 
     * @param {*} helper 
     */
    previous: function(component, event, helper) {
        var anomalies = component.get("v.anomalies");
        var end = component.get("v.end");
        var start = component.get("v.start");
        var pageSize = component.get("v.pageSize");
        var paginationList = [];
        var counter = 0;
        for (var i = start - pageSize; i < start; i++) {
            if (i > -1) {
                paginationList.push(anomalies[i]);
                counter++;
            } else {
                start++;
            }
        }
        start = start - counter;
        end = end - counter;
        component.set("v.start", start);
        component.set("v.end", end);
        component.set('v.paginationList', paginationList);
    },
})