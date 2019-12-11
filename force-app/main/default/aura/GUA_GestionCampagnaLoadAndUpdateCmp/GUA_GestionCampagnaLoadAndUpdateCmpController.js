({
    init: function (cmp, event, helper) {
        var totalCnt = cmp.get("c.getTotalCount");
        totalCnt.setCallback(this, function (a) {
            cmp.set("v.totalNumberOfRows", a.getReturnValue());
        });
        $A.enqueueAction(totalCnt);
        var actions = [{
                label: 'Show details',
                name: 'show_details'
            },
            {
                label: 'Delete',
                name: 'delete'
            }
        ];
        var headerActions = [{
                label: 'All',
                checked: true,
                name: 'All'
            },
            {
                label: 'Completed',
                checked: false,
                name: 'Completed'
            },
            {
                label: 'In Completed',
                checked: false,
                name: 'In Completed'
            },
            {
                label: 'Pre Order',
                checked: false,
                name: 'Pre Order'
            }
        ];
        cmp.set('v.columns', [{
                label: 'Id',
                fieldName: 'Id',
                type: 'text'
            },
            {
                label: 'Name',
                fieldName: 'Name',
                type: 'text',
                sortable: true,
                actions: headerActions,
                editable: true
            },
            {
                label: 'StartDate',
                fieldName: 'StartDate',
                type: 'date',
                sortable: true,
                editable: true
            },
            {
                label: 'EndDate',
                fieldName: 'EndDate',
                type: 'date',
                sortable: true,
                editable: true
            },
            {
                label: 'Script',
                fieldName: 'UAF_Script__c',
                type: 'text',
                sortable: true,
                editable: true
            },
            {
                label: 'DatiAggiuntivi',
                fieldName: 'UAF_DatiAggiuntivi__c',
                type: 'text',
                sortable: true,
                editable: true
            },
            {
                type: 'action',
                typeAttributes: {
                    rowActions: actions
                }
            }

        ]);
        helper.getData(cmp);
        //helper.fetchData(cmp, event, helper);
    },

    handleSaveEdition: function (cmp, event, helper) {
        var draftValues = event.getParam('draftValues');
        var rows = cmp.get('v.data');
        var rowIndex = rows.indexOf(rows);
        console.log(draftValues);
        var action = cmp.get("c.updateCampaign");
        action.setParams({
            "cam": draftValues
        });
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The record has been updated successfully.",
            "type": "success"
        });
        var toastEventError = $A.get("e.force:showToast");
        toastEventError.setParams({
            "title": "Error message!",
            "message": "Error  updated Campaign.",
            "type": "error"
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log('state', state);
            if (state == "SUCCESS") {
                toastEvent.fire();
            } else if (state == "ERROR") {
                toastEventError.fire();
            }
        });
        $A.enqueueAction(action);

    },
    filter: function (component, event, helper) {
        var action = component.get("c.getCampaign");
        var data = component.get("v.data"),
            term = component.get("v.filter"),
            results = data,
            regex;
        try {
            regex = new RegExp(term, "i");
            // filter checks each row, constructs new array where function returns true
            results = data.filter(row => regex.test(row.Name));
            console.log('results', results);
            component.set("v.data", results);
        } catch (e) {
            // invalid regex, use full list
            action.setCallback(this, function (a) {
                component.set("v.data", a.getReturnValue());

            });
            $A.enqueueAction(action);
            //  results = data;
        }
    },
    loadMoreData: function (component, event, helper) {
        //Display a spinner to signal that data is being loaded
        // event.getSource().set("v.isLoading", true);
        //Display "Loading" when more data is being loaded
        var spinner = component.find("csvSpinner");
        $A.util.toggleClass(spinner, "slds-hide");

        var currentData = component.get('v.data');
        //Appends new data to the end of the table
        //var newData = currentData.concat(data);
        component.set('v.data', currentData);
        component.set('v.loadMoreStatus', 'Please wait ');
        var spinner = component.find("csvSpinner");
        $A.util.toggleClass(spinner, "slds-hide");

        //event.getSource().set("v.isLoading", false);

    },
    handleRowAction: function (cmp, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'show_details':
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": row.Id,
                    "slideDevName": "detail"
                });
                navEvt.fire();
                break;
            case 'delete':
                var rows = cmp.get('v.data');
                var rowIndex = rows.indexOf(row);
                console.log('rowIndex' + rowIndex);
                console.log('rowIndex row' + rows[rowIndex].Id);
                var deleteAct = cmp.get("c.deleteCampaigns");
                deleteAct.setParams({
                    ids: rows[rowIndex].Id
                });
                $A.enqueueAction(deleteAct);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "The record has been delete successfully."
                });
                toastEvent.fire();
                rows.splice(rowIndex, 1);
                cmp.set('v.data', rows);
                break;
        }
    },
    handleHeaderAction: function (cmp, event, helper) {
        // helper.getData(cmp);
        var actionName = event.getParam('action').name;
        var colDef = event.getParam('columnDefinition');
        var columns = cmp.get('v.columns');
        var activeFilter = cmp.get('v.activeFilter');
        console.log('activeFilter-->' + activeFilter);
        if (actionName !== activeFilter) {
            var idx = columns.indexOf(colDef);
            var actions = columns[idx].actions;
            console.log('actions' + actions)
            actions.forEach(function (action) {
                action.checked = action.name === actionName;
            });
            cmp.set('v.activeFilter', actionName);
            helper.updateCampaigns(cmp);
            cmp.set('v.columns', columns);
        }
    },
    // Client-side controller called by the onsort event handler
    updateColumnSorting: function (cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        cmp.set("v.sortedBy", fieldName);
        cmp.set("v.sortedDirection", sortDirection);
        helper.sortData(cmp, fieldName, sortDirection);
    },
    onChangeSorting: function (cmp, event, helper) {
        var action = cmp.get("c.getCampaignLimit");
        var activeFilter = cmp.get("v.initialRows");
        console.log('activeFilter', activeFilter);
        action.setParams({
            "limits": cmp.get("v.initialRows")
        });
        action.setCallback(this, function (a) {
            cmp.set("v.data", a.getReturnValue());
        });
        $A.enqueueAction(action);

    },
    handleNext: function (component, event, helper) {
        helper.handleNext(component, event, helper);
    },

    handlePrev: function (component, event, helper) {
        helper.handlePrev(component, event, helper);
    },
    showSpinner: function (component, event, helper) {
        var spinner = component.find('spinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({
            isVisible: true
        });
        evt.fire();
    },

    hideSpinner: function (component, event, helper) {
        helper.hideSpinner(component, event, helper);
    },
    showSpinner: function (component, event, helper) {
        helper.showSpinner(component, event, helper);
    }
})