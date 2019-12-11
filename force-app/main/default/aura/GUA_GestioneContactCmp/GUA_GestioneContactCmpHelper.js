({
    getQueus: function(component, event, _helper) {
        /*var pageSize = component.get("v.pageSize");
        var end=component.get("v.end");
        var action = component.get('c.getQueus'); 
        var resultat;
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                resultat = response.getReturnValue();
                console.log('### resultat ', JSON.stringify(resultat));
                if (resultat.erreur===false) {
                    //var inputs = component.find('inputSelectQueue');
                    var inputs =resultat.resultat;
                    console.log('inputs', JSON.stringify(inputs));
                    console.log('listQueus', JSON.stringify(resultat.resultat));
                    inputs[0].checked = true;
                    component.set('v.listQueus',inputs);
                    console.log('inputs[0]', JSON.stringify(inputs[0]));
                    this.handleManageContact(component, resultat.resultat[0],pageSize,end);
                }else {
                    this.showToast("","error");
                }
            }else{alert('error'+response.getError());
            console.log(JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);*/

        var action = component.get('c.getListViews');
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var resultat = response.getReturnValue();
                console.log('### resultat ', JSON.stringify(resultat));
                if (resultat.error === false) {
                    var listViews = resultat.listview;
                    listViews.forEach((element, idx) => {
                        if (idx == 0) {
                            element['isVisible'] = true;
                            element['checked'] = true;
                        } else {
                            element['isVisible'] = false;
                            element['checked'] = false;
                        }
                    });
                    console.log('listviews', JSON.stringify(listViews));
                    var defaultListView = listViews[0];
                    component.set('v.listViews', listViews);
                    component.set('v.selectedListView', defaultListView);
                } else {
                    this.showToast("", "error");
                }
            } else {
                alert('error' + response.getError());
                console.log(JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);

    },

    queuSelected: function(component, event, helper) {
        var qSelected = event.getSource().get('v.value');
        var listViews = component.get('v.listViews');
        listViews.forEach(element => {
            if (element.Id == qSelected.Id) {
                element['isVisible'] = true;
            } else {
                element['isVisible'] = false;
                element['checked'] = false;
            }
        });
        component.set('v.listViews', listViews)
        //component.set('v.queueContact', qSelected);
        /*var pageSize = component.get("v.pageSize");
        component.set('v.paginationList', []);
        component.set('v.start', 1);
        component.set('v.end', 1);*/
        //component.set('v.listViewCase', qSelected.DeveloperName+'_Case');
        console.log('name liste view', JSON.stringify(qSelected));
        //this.listeValueCase(component, qSelected.Name);
        //this.handleManageContact(component, qSelected,pageSize,'1');

    },

    listeValueCase: function(component, nameValue) {
        //listViewCase
        var actionListView = component.get('c.getListViews');
        actionListView.setCallback(this, function(resp) {
            if (resp.getState() == 'SUCCESS') {
                var resultat = resp.getReturnValue();
                console.log('resultat ' + JSON.stringify(resultat));
                if (resultat.error == false) {

                    var listviews = resultat.listview;
                    for (var i = 0; i < listviews.length; i++) {
                        if (listviews[i].Name == nameValue) {
                            component.set('v.listViewCase', listviews[i].DeveloperName);
                            break;
                        }
                    }
                    //component.set('v.listViewId',resultat.listview.Id);
                    /*
                    var navEvent = $A.get("e.force:navigateToList");
                    navEvent.setParams({
                        "listViewId": resultat.listview.Id,
                        "listViewName": null,
                        "scope": "Case"
                    });
                    navEvent.fire();
                    */
                }
            }
        });
        $A.enqueueAction(actionListView);
    },
    handleManageContact: function(component, queueContact, pageSize, pageNumber) {
        //var queueContact = event.getParam("queueContact");
        component.set('v.queueContact', queueContact);
        console.log('queueContact ' + JSON.stringify(queueContact));
        var action = component.get('c.getContactCaseByQueue');
        var end = component.get("v.end");
        var resultat;
        var contactsCaseList;
        action.setParams({
            "grp": queueContact,
            "pageSize": pageSize,
            "pageNumber": pageNumber
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                resultat = response.getReturnValue();
                if (!resultat.erreur) {
                    contactsCaseList = resultat.resultat;
                    var paginationList = [];
                    component.set("v.contactsCaseList", contactsCaseList);
                    component.set("v.initialListContactsCase", contactsCaseList);
                    component.set("v.totalSize", contactsCaseList.length);
                    component.set("v.start", end);
                    var last = component.get('v.start') + contactsCaseList.length;
                    component.set("v.end", last);
                    if (pageSize > contactsCaseList.length) {
                        pageSize = contactsCaseList.length;
                    }
                    for (var i = 0; i < pageSize; i++) {
                        paginationList.push(contactsCaseList[i]);
                    }
                    component.set('v.paginationList', paginationList);
                    console.log('paginationList : ' + JSON.stringify(paginationList));
                    this.getElementToFilter(component);
                } else {
                    console.log('message', "Error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    first: function(component, event, helper) {
        var pageSize = component.get("v.pageSize");
        var queueContact = component.get('v.queueContact');
        component.set('v.start', 1);
        component.set('v.end', 1);
        this.handleManageContact(component, queueContact, pageSize, '1');
        /*var paginationList = [];
        for(var i=0; i< pageSize; i++){
            paginationList.push(contactsCaseList[i]);
        }
        component.set('v.paginationList', paginationList);
        */
    },
    next: function(component, event, helper) {
        var queueContact = component.get('v.queueContact');
        var end = component.get("v.end");
        var start = component.get("v.start");
        var pageSize = component.get("v.pageSize");
        var totalSize = component.get("v.totalSize");
        var action = component.get('c.getContactCaseByQueue');
        var resultat;
        var counter = 0;
        var contactsCaseList;
        console.log(pageSize + 'S/ ' + start + ' E/' + end);
        action.setParams({
            "grp": queueContact,
            "pageSize": pageSize,
            "pageNumber": end
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                resultat = response.getReturnValue();
                if (!resultat.erreur) {
                    contactsCaseList = resultat.resultat;
                    var paginationList = [];
                    component.set("v.contactsCaseList", contactsCaseList);
                    component.set("v.initialListContactsCase", contactsCaseList);
                    component.set("v.totalSize", totalSize + contactsCaseList.length);
                    if (pageSize > contactsCaseList.length) {
                        pageSize = contactsCaseList.length;
                    }
                    for (var i = 0; i < pageSize; i++) {
                        paginationList.push(contactsCaseList[i]);
                        counter++;
                    }
                    start = start + counter;
                    end = end + counter;
                    component.set("v.start", start);
                    component.set("v.end", end);
                    component.set('v.paginationList', paginationList);
                    this.getElementToFilter(component);
                } else {
                    console.log('message', "Error");
                }
            }
        });
        $A.enqueueAction(action);

    },
    previous: function(component, event, helper) {
        var queueContact = component.get('v.queueContact');
        var end = component.get("v.end");
        var start = component.get("v.start");
        var pageSize = component.get("v.pageSize");
        var totalSize = component.get("v.totalSize");
        var action = component.get('c.getContactCaseByQueue');
        var resultat;
        var counter = 0;
        var contactsCaseList;
        //component.set('v.start',start+pageSize);
        console.log(pageSize + 'S/ ' + start + ' E/' + end);
        action.setParams({
            "grp": queueContact,
            "pageSize": pageSize,
            "pageNumber": start
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                resultat = response.getReturnValue();
                if (!resultat.erreur) {
                    contactsCaseList = resultat.resultat;
                    var paginationList = [];
                    component.set("v.contactsCaseList", contactsCaseList);
                    component.set("v.initialListContactsCase", contactsCaseList);
                    component.set("v.totalSize", totalSize + contactsCaseList.length);
                    if (pageSize > contactsCaseList.length) {
                        pageSize = contactsCaseList.length;
                    }
                    for (var i = 0; i < pageSize; i++) {
                        if (i > -1) {
                            paginationList.push(contactsCaseList[i]);
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
                    this.getElementToFilter(component);
                } else {
                    console.log('message', "Error");
                }
            }
        });
        $A.enqueueAction(action);

    },
    last: function(component, event, helper) {
        var queueContact = component.get('v.queueContact');
        var end = component.get("v.end");
        var start = component.get("v.start");
        var pageSize = component.get("v.pageSize");
        var totalSize = component.get("v.totalSize");
        var action = component.get('c.getLastContactCaseByQueue');
        var resultat;
        var counter = 0;
        var contactsCaseList;
        action.setParams({ "grp": queueContact, "pageSize": pageSize });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                resultat = response.getReturnValue();
                if (!resultat.erreur) {
                    contactsCaseList = resultat.resultat;
                    var paginationList = [];
                    component.set("v.contactsCaseList", contactsCaseList);
                    component.set("v.initialListContactsCase", contactsCaseList);
                    component.set("v.totalSize", contactsCaseList.length);
                    if (pageSize > contactsCaseList.length) {
                        pageSize = contactsCaseList.length;
                    }
                    for (var i = 0; i < pageSize; i++) {
                        paginationList.push(contactsCaseList[i]);
                        counter++;
                    }
                    component.set("v.start", '0');
                    component.set("v.end", pageSize);
                    component.set('v.paginationList', paginationList);
                    this.getElementToFilter(component);
                } else {
                    console.log('message', "Error");
                }
            }
        });
        $A.enqueueAction(action);

    },
    filterContactCase: function(component, event, helper) {
        component.set("v.isOpenModel", true);
    },
    closeModel: function(component, event, helper) {
        component.set("v.isOpenModel", false);
        component.set('v.criterion', "");
        component.set('v.campagna', "");
    },
    showFilter: function(component, event, helper) {
        var initialListContactsCase = [];
        var listFilter = [];
        initialListContactsCase = component.get("v.initialListContactsCase");
        var pageSize = component.get("v.pageSize");
        var campagna = '' + component.get('v.campagna');
        var criter = component.get('v.criterion');
        var listfilter = [];
        if (campagna == 'tutti') {
            listfilter = initialListContactsCase;
        } else {
            listfilter = initialListContactsCase.filter(object => object.CampaignId__r.Name.toLowerCase().includes(campagna.toLowerCase()));
        }
        console.log('criter ' + criter);
        this.elementListFilter(component, criter);
        /*
        //listfilter.sort(this.sortBy(criter, true));
        var paginationList = [];
        var contactsCaseList = component.get('v.contactsCaseList');
        component.set('v.contactsCaseList',listfilter);
        component.set("v.totalSize", contactsCaseList.length);
        component.set("v.start",0);
        component.set("v.end",pageSize-1);
        for(var j=0; j< pageSize; j++) {
            paginationList.push(contactsCaseList[j]); 
        }
        component.set('v.paginationList', paginationList);
        this.closeModel(component,event,helper);
        this.first(component, event, helper);*/
    },
    getCampagna: function(component, event, helper) {
        var listCampagn = [];
        var cmpagn = document.getElementById("campagnaSelected");
        if (cmpagn.selectedIndex) {
            for (var i = 0; i < cmpagn.options.length; i++) {
                if (cmpagn.options[i].selected) {
                    listCampagn.push(cmpagn.options[i].value);
                }
            }
            component.set('v.campagna', listCampagn);
            console.log('campagna ' + component.get('v.campagna'));
        }
    },
    getCriterion: function(component, event, helper) {
        var criter = document.getElementById("criterionSelected");
        if (criter.selectedIndex) {
            component.set('v.criterion', criter.options[criter.selectedIndex].value);
            console.log('criterion ' + component.get('v.criterion'));
        }
    },
    getElementToFilter: function(component) {
        component.set('v.campagnList', []);
        component.set('v.criterionList', []);
        var listeContCase = component.get('v.contactsCaseList');
        var campagnList = component.get('v.campagnList');
        var criterionList = component.get('v.criterionList');

        var i = 0;
        for (i; i < listeContCase.length; i++) {
            var contCase = '';
            if (listeContCase[i].hasOwnProperty('CampaignId__r')) {
                var campagna = listeContCase[i].CampaignId__r;
                if (campagna.hasOwnProperty('Name')) {
                    contCase = campagna.Name;
                }
            }
            //var contCase = listeContCase[i].CampaignId__r.Name;
            var ind = campagnList.indexOf(contCase);
            if (ind == -1) {
                campagnList.push(contCase);
                //console.log('contCase ','/'+ind+' '+contCase);
            }
        }
        criterionList = [
            { 'val': 'Scadenza__c', 'label': 'Scadenza' },
            { 'val': 'Tentativo__c', 'label': 'Numero tentativi' },
            { 'val': 'Priority', 'label': 'Priorità' }
        ]
        component.set('v.criterionList', criterionList);

    },
    sortBy: function(field, reverse, primer) {
        var key = primer ?
            function(x) {
                return primer(x[field])
            } :
            function(x) {
                return x[field]
            };
        //checks if the two rows should switch places
        reverse = !reverse ? 1 : -1;
        return function(a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    },
    cntSelected: function(component, event, qSelected) {

        var eventContact = $A.get("e.force:navigateToComponent");
        eventContact.setParams({
            componentDef: "c:GUA_DettaglioContactCmp",
            componentAttributes: {
                contactDetail: qSelected,
                queueContact: component.get('v.queueContact')
            }
        });
        eventContact.fire();
    },
    handleCaseSearchDealer: function(component, event) {
        console.log('############# debug ');
        alert('######### ');
        console.log('########## caseList ' + JSON.stringify(event.getParam('caseDealer')));
        var casesContact = event.getParam('caseDealer');
        alert('################### ');
        console.log('################  casesContact ' + casesContact);
        component.set("v.paginationList", casesContact);
    },

    showToast: function(message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            message: message,
            type: type
        });
        toastEvent.fire();
    },

    elementListFilter: function(component, criter) {
        var pageSize = component.get("v.pageSize");
        var queueContact = component.get('v.queueContact');
        console.log('queueContact ' + JSON.stringify(queueContact));
        var action = component.get('c.getContactCaseFilter');
        var end = component.get("v.end");
        var resultat;
        var contactsCaseList;
        action.setParams({
            "grp": queueContact,
            "pageSize": pageSize,
            "pageNumber": '1',
            "elementFilter": criter
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                resultat = response.getReturnValue();
                if (!resultat.erreur) {
                    contactsCaseList = resultat.resultat;
                    var paginationList = [];
                    component.set("v.contactsCaseList", contactsCaseList);
                    component.set("v.initialListContactsCase", contactsCaseList);
                    component.set("v.totalSize", contactsCaseList.length);
                    component.set("v.start", end);
                    var last = component.get('v.start') + contactsCaseList.length;
                    component.set("v.end", last);
                    if (pageSize > contactsCaseList.length) {
                        pageSize = contactsCaseList.length;
                    }
                    for (var i = 0; i < pageSize; i++) {
                        paginationList.push(contactsCaseList[i]);
                    }
                    component.set('v.paginationList', paginationList);
                    console.log('paginationList : ' + JSON.stringify(paginationList));
                    this.getElementToFilter(component);
                } else {
                    console.log('message', "Error");
                }
            }
            this.closeModel(component);
        });
        $A.enqueueAction(action);
    }

})