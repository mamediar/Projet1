({
    onInit : function(component) {
        var pageSize = component.get("v.pageSize").toString();
        var pageNumber = component.get("v.pageNumber").toString();
        var action = component.get('c.getRegionNameValues');
        action.setParams({'pageSize': pageSize, 'pageNumber': pageNumber});
        action.setCallback(this, function (response) {
            if (response.getState() == 'SUCCESS') {
                var result = response.getReturnValue();
                console.log('result', JSON.stringify(result));
                if (result.error == false) {
                    component.set('v.regions', result.regions);
                    var oldAreasAffari = result.oldAreasAffari;
                    component.set('v.oldAreasAffari', oldAreasAffari);
                    if(oldAreasAffari.length < component.get("v.pageSize")){
                        component.set("v.isLastPage", true);
                    } else {
                        component.set("v.isLastPage", false);
                    }
                    component.set("v.dataSize", oldAreasAffari.length);
                    this.initList(component);
                }
                console.log('result', JSON.stringify(result.regions));
            }
        });
        $A.enqueueAction(action);
    },

    initList : function (component) {
        // list of area
        var listZoneRO = ['01','02','03','04','05'];
        var listZoneRE = ['06','07','08','09','10'];
        var listZoneRC = ['11','12','13','14','15'];
        var listZoneRA = ['16','17','18','19','20'];
        var listZoneRT = ['21','22','23','24','25'];
        var listZoneRS = ['26','27','28','29','30'];

        // list of unita affari
        var listAffari = ['Affari e Delibere 1','Affari e Delibere 2',
            'Affari e Delibere 3','Affari e Delibere 4'
        ];

        component.set('v.listZoneRO', listZoneRO);
        component.set('v.listZoneRE', listZoneRE);
        component.set('v.listZoneRC', listZoneRC);
        component.set('v.listZoneRA', listZoneRA);
        component.set('v.listZoneRT', listZoneRT);
        component.set('v.listZoneRS', listZoneRS);
        component.set('v.listAffari', listAffari);

        component.set('v.assegnazioniColumns', [            
            {
                label: 'Regione', fieldName: 'Region_Name__c', type: 'text'
            },
            {
                label: 'Aree', fieldName: 'OCSAreaId__c', type: 'number'
            },
            {
                label: 'Unita Affari', fieldName: 'Name', type: 'text'
            },
            {
                label:'Cancel', type: 'button', typeAttributes: {
                    label: {fieldName: 'actionLabel'},
                    title: 'Delete',
                    name: 'deleteAreaAffari',
                    iconName: 'action:close',
                    disabled: {fieldName: 'actionDisabled'},
                    class: '',
                    size: 'XX-small'
                }
            }
        ]);
        
        component.set('v.esitiColumns', [            
            {
                label: 'Regione', fieldName: 'Region_Name__c', type: 'text'
            },
            {
                label: 'Aree', fieldName: 'OCSAreaId__c', type: 'number'
            },
            {
                label: 'Unita Affari', fieldName: 'Name', type: 'text'
            },
            {   type: 'button', typeAttributes: {
                    label: 'Edit',
                    title: 'Edit',
                    name: 'actionEdit',
                    iconName: 'action:edit',
                    disabled:false,
                    size: 'XX-small',
                    class: 'column-button',
                    minColumnWidth: 80,
                    maxColumnWidth: 100
                }
            },
            {   type: 'button', typeAttributes: {
                    label: 'Delete',
                    title: 'Delete',
                    name: 'actionDelete',
                    iconName: 'action:delete',
                    disabled: false,
                    size: 'XX-small',
                    class: 'column-button',
                    minColumnWidth: 80,
                    maxColumnWidth: 100
                }
            }
        ]);
    },

    handleGetZone : function (component) {
        var regione = component.find("region").get("v.value");
        var areaAffari = component.get('v.areaAffari');
        areaAffari.Region_Name__c = regione;
        var attributeName = 'v.listZone'+regione;
        var listAreas = component.get(attributeName);
        component.set('v.listZones', listAreas);
        component.set('v.areaAffari', areaAffari);
    },

    handleSetArea : function (component){
        var area = component.find("area").get("v.value");
        var areaAffari = component.get('v.areaAffari');
        areaAffari.OCSAreaId__c = area;
        component.set('v.areaAffari', areaAffari);
    },

    handleSetQueue : function (component){
        var queue = component.find("unitaAffari").get("v.value");
        var areaAffari = component.get('v.areaAffari');
        areaAffari.Name = queue;
        component.set('v.areaAffari', areaAffari);
    },

    handleAddZoneToQueue : function (component) {
        var areasAffari = component.get('v.areasAffari');
        var areaAffari = component.get('v.areaAffari');
        var cmpt = new Number(0);
        if (areasAffari.length > 0) {
            areasAffari.forEach(function (item) {
                if (item.Name == areaAffari.Name && item.Region_Name__c == areaAffari.Region_Name__c && item.OCSAreaId__c == areaAffari.OCSAreaId__c) {
                    cmpt++;
                } 
            });
        }
        if (cmpt > 0) {
            this.showToast('warning', 'the region '+ areaAffari.Region_Name__c +' with the area '+
                    areaAffari.OCSAreaId__c +' and the Queue '+ areaAffari.Name +' already added', 'warning');
        } else {
            areasAffari.push(areaAffari);
            component.set('v.areaAffari', {
                'SObjectype':'Account', 
                'Name': '',
                'Region_Name__c': '',
                'OCSAreaId__c': null
            });
        }
        component.set('v.areasAffari', areasAffari);
        console.log('areasAffari', areasAffari);
    },

    handleSaveZoneToQueue : function (component) {
        var areasAffari = component.get('v.areasAffari');
        var action = component.get('c.saveZonesToQueue');
        action.setParams({'areasAffari': areasAffari});
        action.setCallback(this, function (response) {
            var state = response.getState();
            var result = response.getReturnValue();
            console.log('result',JSON.stringify(result));
            if (state == 'SUCCESS') {
                if (result.error == false) {
                    this.showToast('success', 'unita affari added successfuly', 'success');
                    var oldAreasAffari = component.get('v.oldAreasAffari');
                    //oldAreasAffari.push.apply(oldAreasAffari, result.areasAffari);
                    component.set('v.areasAffari', []);
                    this.handleGetAreaAffari(component);
                    //component.set('v.oldAreasAffari', oldAreasAffari);
                } else {
                    this.showToast('error', result.message, 'error');
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                this.showToast('error', 'some errors was accurated, you may refresh the page', 'error');
            } else {
                this.showToast('error', 'some errors was accurated, you may refresh the page', 'error');
            }
        });
        $A.enqueueAction(action);
    },

    showToast : function(title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type,
            "duration": 3000
        });
        toastEvent.fire();
    },

    handleRemoveZoneToQueue : function (component, event) {
        var areasAffari = component.get('v.areasAffari');
        var areaAffari = event.getParam('row');
        areasAffari.forEach(function (item, index) {
            if (item.Name == areaAffari.Name && item.Region_Name__c == areaAffari.Region_Name__c && item.OCSAreaId__c == areaAffari.OCSAreaId__c) {
                areasAffari.splice(index,1);
            }
        });
        component.set('v.areasAffari', areasAffari);
    },

    hadleEditUnitaAffari : function (component) {
        var editAreaAffari = component.get('v.editAreaAffari');
        var rowIndex = component.get('v.rowIndex');
        var areasAffari = [];
        areasAffari.push(editAreaAffari);
        var action = component.get('c.saveZonesToQueue');
        action.setParam('areasAffari',areasAffari);
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                var result = response.getReturnValue();
                if (result.error == false) {
                    component.set('v.isEditUnitaAffari', false);
                    this.showToast('success', 'unita affari added successfuly', 'success');
                    var areasAffari = result.areasAffari;
                    var rows = component.get('v.oldAreasAffari');
                    rows[rowIndex] = areasAffari[0];
                    component.set('v.oldAreasAffari', rows);                    
                } else {
                    this.showToast('error', result.message, 'error');
                }
                console.log('result', JSON.stringify(result));
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                this.showToast('error', 'some errors was accurated, you may refresh the page', 'error');
            } else {
                this.showToast('error', 'some errors was accurated, you may refresh the page', 'error');
            }
        });
        $A.enqueueAction(action); 
    },

    handleConfirmDelete : function (component) {
        var rowIndex = component.get('v.rowIndex');
        var rows = component.get('v.oldAreasAffari');
        var action = component.get('c.deleteZoneToQueue');
        action.setParam('id', rows[rowIndex].Id);
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                var result = response.getReturnValue();
                if (result.error == false) {
                    rows.splice(rowIndex, 1);
                    component.set('v.oldAreasAffari', rows);
                    component.set('v.isOpenDelete', false);
                    this.showToast('success', 'The record has been delete successfully.', 'success');
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                this.showToast('error', 'some errors was accurated, you may refresh the page', 'error');
            } else {
                this.showToast('error', 'some errors was accurated, you may refresh the page', 'error');
            }
        });
        $A.enqueueAction(action);
    },

    handleGetAreaAffari : function (component){
        var pageSize = component.get("v.pageSize").toString();
        var pageNumber = component.get("v.pageNumber").toString();
        var action = component.get('c.getAreaAffari');
        action.setParams({'pageSize': pageSize, 'pageNumber': pageNumber});
        action.setCallback(this, function (response) {
            if (response.getState() == 'SUCCESS') {
                var result = response.getReturnValue();
                console.log('result', JSON.stringify(result));
                if (result.error == false) {
                    var oldAreasAffari = result.oldAreasAffari;
                    component.set('v.oldAreasAffari', oldAreasAffari);
                    if(oldAreasAffari.length < component.get("v.pageSize")){
                        component.set("v.isLastPage", true);
                    } else {
                        component.set("v.isLastPage", false);
                    }
                    component.set("v.dataSize", oldAreasAffari.length);
                }
                console.log('result', JSON.stringify(result.regions));
            }
        });
        $A.enqueueAction(action);
    }
})