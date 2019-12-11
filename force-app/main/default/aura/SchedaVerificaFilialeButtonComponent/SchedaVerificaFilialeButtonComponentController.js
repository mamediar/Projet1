({
	sendApproval : function(component, event, helper) {
		helper.checkQuestionnaire(component, event, helper);
	},

	doInit : function (component, event, helper) {
		if(component.get('v.simpleRecord.Stati_Approvazione__c') == null || component.get('v.simpleRecord.Stati_Approvazione__c') == 3){
			component.set('v.showSendApprovers',true);
		} else {
			component.set('v.showSendApprovers',false);
		}
	},

	schedaPrecedente : function (component, event, helper) {
		helper.getSchedaPrecedente(component);
	},
    
    stampaPDF : function(component, event, helper) {
        window.open('/apex/SchedaVerificaFilialeStampaPDF?schedaId='+component.get("v.recordId")+'&stampaPdf=true');
	},
	
	openModalExtension : function(component, event, helper) {
		helper.openModalExtension(component,event,helper);
	},

	closeModal : function (component, event, helper) {
		helper.closeModal(component, event, helper);
	},
})