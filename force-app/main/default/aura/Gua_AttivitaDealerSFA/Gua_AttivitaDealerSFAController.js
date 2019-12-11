({
    doInit: function (component, event, helper) {
        component.set('v.columns', [
            { label: 'Tipo Attività', fieldName: 'Name', type: 'name', sortable: true },
            { label: 'Priorità', fieldName: 'LeadSource', type: 'picklist', sortable: true },
            { label: 'Pianificazione Per', fieldName: 'Level__c', type: 'picklist', sortable: true }
        ]);
    }
})