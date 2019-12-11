({
    doInit: function(component, event, helper) {
        var action = component.get('c.getArea');
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                var result = response.getReturnValue();
                console.log('resultat', JSON.stringify(result));
                if (result.error == false) {
                    console.log('result', JSON.stringify(result));
                    var regions = result.regions;
                    var existedAreaAffari = result.existedQueueAssignement;
                    component.set('v.regions', regions);
                    component.set('v.existedAreaAffari', existedAreaAffari);
                    helper.initList(component);
                }
            }
        });
        $A.enqueueAction(action);
    },

    setQueue: function(component, event, helper) {
        helper.handleSetQueue(component);
    },

    getAreas: function(component, event, helper) {
        helper.handleGetZone(component);
    },

    selectArea: function(component, event, helper) {
        var selectedValues = event.getParam("value");
        //Update the Selected Values  
        component.set("v.selectedAreaList", selectedValues);
    },

    addZoneToQueue: function(component, event, helper) {
        //Get selected Genre List on button click 
        var exist = false;
        var area = '';
        var selectedAreaList = component.get("v.selectedAreaList");
        console.log('selectedAreaList ', JSON.stringify(selectedAreaList));
        var unitaAffari = component.get('v.unitaAffari');
        console.log('unitaAffari ', unitaAffari);
        var attributeName = 'v.' + unitaAffari;
        console.log('attributeName', attributeName);
        var listAreas = component.get(attributeName);
        var unitaAffarisSelected = component.get('v.unitaAffarisSelected');
        selectedAreaList.forEach(element => {
            console.log('element', element);
            if (unitaAffarisSelected.indexOf(element) != -1) {
                exist = true;
                area = element;
            }
        });

        if (exist) {
            helper.showToast("Avvertimento !", "warning", "l'aree " + area + " è già stata aggiunta");
        } else {
            unitaAffarisSelected = unitaAffarisSelected.concat(selectedAreaList);
            component.set('v.unitaAffarisSelected', unitaAffarisSelected);
            console.log('unitaAffarisSelected ', JSON.stringify(unitaAffarisSelected));
            listAreas = listAreas.concat(selectedAreaList);
            component.set(attributeName, listAreas);
            console.log('listAreas ', JSON.stringify(listAreas));

            var areaAffari = component.get('v.areaAffari');
            var fieldName = unitaAffari + '__c';
            areaAffari[fieldName] = listAreas;
            component.set('v.areaAffari', areaAffari);
        }


    },

    saveZoneToQueue: function(component, event, helper) {
        var areaAffari = component.get('v.areaAffari');
        console.log('areaAffari', JSON.stringify(areaAffari));

        var unitaAffarisSelected = component.get('v.unitaAffarisSelected');
        if (unitaAffarisSelected.length < 30) {
            helper.showToast("Errore !", "error", "Assegnare tutte le area prima di confermare");
        } else {
            var action = component.get('c.saveQueueAssigment');
            action.setParam('myQueueAssig', areaAffari);
            action.setCallback(this, function(response) {
                if (response.getState() == 'SUCCESS') {
                    var resultat = response.getReturnValue();
                    console.log('resultat', JSON.stringify(resultat));
                    if (resultat.error == false) {
                        helper.showToast("Successo !", "success", "Unita Affari aggiunto con successo");
                        var existedAreaAffari = resultat.data;
                        component.set('v.existedAreaAffari', existedAreaAffari);
                        component.set('v.Q281', []);
                        component.set('v.Q285', []);
                        component.set('v.Q286', []);
                        component.set('v.Q287', []);
                    } else {
                        helper.showToast("Errore !", "error", "Qualcosa non ha funzionato, potrebbe essere necessario aggiornare la pagina");
                    }
                }
            });
            $A.enqueueAction(action);
        }

    }
})