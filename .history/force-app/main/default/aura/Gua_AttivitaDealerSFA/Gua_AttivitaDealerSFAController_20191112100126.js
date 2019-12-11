({
    doInit: function (component, event, helper) {
        component.set('v.columns', [
            { label: 'Tipo Actività', fieldName: 'Name', type: 'name', sortable: true },
            { label: 'Prioirità', fieldName: 'LeadSource', type: 'picklist', sortable: true },
            { label: 'Pianificazione Per', fieldName: 'Level__c', type: 'picklist', sortable: true }
        ]);
    }
})