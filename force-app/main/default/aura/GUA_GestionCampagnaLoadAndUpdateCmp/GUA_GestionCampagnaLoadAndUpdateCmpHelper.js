({
    fetchData: function (cmp, row) {
        return new Promise($A.getCallback(function (resolve, reject) {
            var currentDatatemp = cmp.get("c.getCampaign");
            var pageSize = cmp.get("v.pageSize").toString();
            var pageNumber = cmp.get("v.pageNumber").toString();
            currentDatatemp.setParams({
                'pageSize': pageSize,
                'pageNumber': pageNumber
            });

            currentDatatemp.setCallback(this, function (a) {
                resolve(a.getReturnValue());
                // var countstemps = component.get("v.currentCount");
                //countstemps = countstemps + component.get("v.initialRows");
                //component.set("v.currentCount", countstemps);

            });
            $A.enqueueAction(currentDatatemp);

        }));
    },
    getData: function (component, helper) {
        var spinner = component.find("csvSpinner");
        $A.util.toggleClass(spinner, "slds-hide");

        var action = component.get("c.getCampaign");
        var pageSize = component.get("v.pageSize").toString();
        var pageNumber = component.get("v.pageNumber").toString();
        action.setParams({
            'pageSize': pageSize,
            'pageNumber': pageNumber
        });
        action.setCallback(this, function (a) {
            //component.set("v.data", a.getReturnValue());
            var state = a.getState();
            if (state === "SUCCESS") {
                var resultData = a.getReturnValue();
                if (resultData.length < component.get("v.pageSize")) {
                    component.set("v.isLastPage", true);
                } else {
                    component.set("v.isLastPage", false);
                }
                component.set("v.dataSize", resultData.length);
                component.set("v.data", resultData);
                var spinner = component.find("csvSpinner");
                $A.util.toggleClass(spinner, "slds-hide");

            }
        });
        $A.enqueueAction(action);
    },
    sortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.data");
        var reverse = sortDirection !== 'asc';
        //sorts the rows based on the column header that's clicked
        data.sort(this.sortBy(fieldName, reverse))
        cmp.set("v.data", data);
    },
    sortBy: function (field, reverse, primer) {
        var key = primer ?
            function (x) {
                return primer(x[field])
            } :
            function (x) {
                return x[field]
            };
        //checks if the two rows should switch places
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    },
    updateCampaigns: function (cmp) {
        var rows = cmp.get('v.data');
        var activeFilter = cmp.get('v.activeFilter');
        console.log('activeFilter Helper' + activeFilter)
        var filteredRows = rows;
        if (activeFilter == 'All') {
            return rows;
        }
        if (activeFilter !== 'All') {
            filteredRows = rows.filter(function (row) {
                console.log('Each Row' + row.publish_status__c);
                if (row.publish_status__c == activeFilter) {
                    return row;
                }
                // return (activeFilter === 'In_Completed') ||(activeFilter === 'Pre_Order');
            });
        }
        cmp.set('v.data', filteredRows);
    },
    handleNext: function (component, event, helper) {
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber + 1);
        helper.getData(component, helper);
    },

    handlePrev: function (component, event, helper) {
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber - 1);
        helper.getData(component, helper);
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
        var spinner = component.find('spinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({
            isVisible: false
        });
        evt.fire();
    }
})