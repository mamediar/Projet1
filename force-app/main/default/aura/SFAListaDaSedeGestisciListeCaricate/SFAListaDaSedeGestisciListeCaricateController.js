({
    doInit : function(component, event, helper) {
        helper.columnsandquickactions(component);
        helper.getListeCaricateList(component);
        helper.totalListeCaricate(component);       
    },
    handleSelectedRow :function (component, event, helper) {
        var selectedRows = component.find("tableListeCaricate").getSelectedRows();
        //alert(selectedRows[0].Id);   
    },
    RowAction: function (component, event, helper) {
        var action = event.getParam('action');
        switch (action.name){ 
            case 'New': alert(action.name)
            break;
            case 'edit':alert(action.name)
            break;
            case 'delete': alert(action.name)
            break;
            case 'view':alert(action.name)
            break; 
            default: alert('Salesforce');
        }
    },
    LoadMore:function (component, event, helper) {
        if(!component.get('v.breakload')) {
            event.getSource().set('v.isLoading', true);
            var recordLimit = component.get('v.initRows');       
            var action = component.get('c.getListeCaricate');       
            action.setParams({
                "Limits": recordLimit,
                "showOnly" : component.get('v.showOnly') 
            });
            action.setCallback(this, function(response) {          
                var state = response.getState();     
                if (state === "SUCCESS" ) {
                    var Opplist = response.getReturnValue();
                    Opplist.forEach(function(entry) {
                        entry.Nome_Attivita=entry.Tipo_Attivita__r.Descrizione__c;
                        //entry.Chiuso__c = entry.Chiuso__c==true ? 'SI' : 'NO';
                    });
                    if(Opplist.length<component.get('v.initRows'))
                        component.set('v.breakload',true);
                    component.set('v.initRows',component.get('v.initRows')+10);
                    event.getSource().set('v.isLoading', false);
                    component.set('v.Opplist', Opplist);  
                    component.set("v.locallimit",Opplist.length);
                }
            });
            if(component.get('v.totalResult')==component.get('v.locallimit')) {
                event.getSource().set("v.isLoading", false);
            }
            else{
                $A.enqueueAction(action);
            }
        }
    },
	handleSaveEdition2: function (cmp, event, helper) {
        var params = event.getParam('arguments');
		debugger;
        helper.saveEdition(cmp, params.draftValues, false);
    },
    handleSaveEdition: function (cmp, event, helper) {
        var draftValues = event.getParam('draftValues');
		debugger;
        helper.saveEdition(cmp, draftValues, true);
    },
    handleCancelEdition: function (cmp) {
    },
})