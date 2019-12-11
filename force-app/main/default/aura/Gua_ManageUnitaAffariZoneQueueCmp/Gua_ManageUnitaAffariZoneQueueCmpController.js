({
    doInit : function(component, event, helper) {
        helper.onInit(component);
    },

    getAreas : function (component, event, helper) {
        helper.handleGetZone(component);
    },

    setArea : function (component, event, helper) {
        helper.handleSetArea(component);
    },

    setQueue : function (component, event, helper) {
        helper.handleSetQueue(component);
    },

    addZoneToQueue : function (component, event, helper) {        
        helper.handleAddZoneToQueue(component);
    },

    removeZoneToQueue: function (component, event, helper) {
        helper.handleRemoveZoneToQueue(component, event);
    },

    saveZoneToQueue : function (component, event, helper) {
        helper.handleSaveZoneToQueue(component);
    },

    handleRowEsitiAction : function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        component.set('v.editAreaAffari', row);
        var rows = component.get('v.oldAreasAffari');
        var rowIndex = rows.indexOf(row);
        component.set('v.rowIndex', rowIndex);

        switch (action.name) {
            case 'actionEdit':
                component.set('v.isEditUnitaAffari', true);
                var attributeName = 'v.listZone'+row.Region_Name__c;
                var listAreas = component.get(attributeName);
                component.set('v.listZones', listAreas);
                break;
            case 'actionDelete':    
                component.set('v.isOpenDelete', true);
                break;
            default:
                break;
        }
    },

    editUnitaAffari: function (component, event, helper) {
        helper.hadleEditUnitaAffari(component);           
    },

    cancelEditUnitaAffari: function (component, event, helper) {
        component.set('v.isEditUnitaAffari', false);
    },

    setAreaEdit: function (component, event, helper) {
        var regione = component.find("rEdit").get("v.value");
        var editAreaAffari = component.get('v.editAreaAffari');
        editAreaAffari.Region_Name__c = regione;
        var attributeName = 'v.listZone'+regione;
        var listAreas = component.get(attributeName);
        component.set('v.listZones', listAreas);
        component.set('v.editAreaAffari', editAreaAffari);
    },

    cancelDelete : function (component, event, helper) {
        component.set('v.isOpenDelete', false);
    },

    confirmDelete : function (component, event, helper) {
        helper.handleConfirmDelete(component);
    },

    handleNext : function(component, event, helper) { 
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber+1);
        helper.handleGetAreaAffari(component);
    },
     
    handlePrev : function(component, event, helper) {        
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber-1);
        helper.handleGetAreaAffari(component);
    }

})