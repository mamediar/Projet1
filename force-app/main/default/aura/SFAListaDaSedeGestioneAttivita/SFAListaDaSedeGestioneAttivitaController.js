({
	init : function(component, event, helper) {
		helper.doInit(component, event, helper);
		helper.getDispositionsLevel1(component, event, helper);
		helper.setHeaderColumns(component, event, helper);
	},
    
    getDisposition : function(component, event, helper) {
		component.set('v.dispositionName',null);
		helper.getDispositionsList(component, event, helper);
	},
    
    insert : function(component, event, helper) {
		helper.insertRecord(component, event, helper);
	},
    remove : function(component, event, helper) {
		helper.removeRecord(component, event, helper);
	},
	resetAll : function(component, event, helper) {
		helper.resetAllValue(component, event, helper);
		helper.getAllRecordCreated(component, event, helper);
	},
	setEsitoSelected : function(component, event, helper) {
		helper.setSelectedEsito(component, event, helper);
	},
	insertToList : function(component, event, helper) {
		
		helper.insertRecordToList(component, event, helper);
	},
	setDispositionName : function(component, event, helper) {
		helper.getDisposition(component, event, helper);
	},
	setCategoryName : function(component, event, helper) {
		helper.setSelected(component, event, helper);
		//helper.resetForm(component, event, helper);
		component.set('v.outputActivityList',[]);
		component.set('v.allRecordInsered',[]);
		component.set('v.outputActivityTmp',[]);
		component.find("categoryType").set("v.value",null);
		component.find("level1").set("v.value",null);
		component.find("dispositionType").set("v.value",null);
	},
	insertToDB : function(component, event, helper) {
		helper.insertUpdate(component, event, helper);
	}
})