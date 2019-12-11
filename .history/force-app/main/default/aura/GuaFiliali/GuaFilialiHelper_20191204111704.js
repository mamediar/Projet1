({
    getCases: function(component, event, helper) {
        var recordId = component.get('v.recordId');
        console.log('recordId >>', JSON.stringify(recordId));
        var action = component.get('c.getCase');
        action.setParams({ "idCase": recordId });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var result = response.getReturnValue();
                console.log('result init >>', result.data);
                if (!result.erreur) {
                    component.set('v.filialeCase', result.data);
                    console.log('data', JSON.stringify(result.data.CTI_DNIS__c));
                    this.getFilialeCase(component,event,helper);
                } else {
                    console.log('message getCase', "Error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    getFilialeCase : function (component,event,helper){
        console.log('contactDetail '+JSON.stringify(component.get('v.filialeCase')));
        var resultat;
        var filiale= component.get('v.filialeCase');
        console.log('caseBranch', JSON.stringify(filiale));
        var action = component.get('c.getFilialeById');
        action.setParams({"idAccount":filiale.AccountId}); 
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                resultat = response.getReturnValue();
                console.log('filiale '+JSON.stringify(resultat.filiale));
                if (!resultat.erreur) {
                    component.set('v.filiale',resultat.filiale);
                    this.getUtenteHandler(component, event, helper);                       
                } else {
                    console.log('message', "Error");
                }
            }
        });
        $A.enqueueAction(action); 
    }, 
    getUtenteHandler: function(component, event, helper) {
        //component.set('v.showUtenzaPasscom', true);
        var action = component.get('c.getRecuperaUtenzeIntermediario');
        var resultat;
        var myCase = component.get('v.filialeCase');
        console.log('NameRoleReference__c >>', myCase.Account.NameRoleReference__c);
        action.setParams({
            "role": myCase.Account.NameRoleReference__c,
            /* "role": 'Alessandria', */
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                resultat = response.getReturnValue();
                console.log('response >>', resultat);
                if (!resultat.erreur) {
                    component.set('v.userDealerList', resultat.utentente);
                    var filialeList = component.get('v.userDealerList');
                    this.initializePagination(component,filialeList);
                } else {
                    console.log('message', "Error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    initializePagination: function(component, datas) {
        var pageSize = component.get("v.pageSize");
        component.set("v.start", 0);
        component.set("v.end", pageSize - 1);
        var totalPage = Math.ceil(datas.length / pageSize);
        component.set("v.totalPage", totalPage);
        var pages = [];
        for (var i = 1; i <= totalPage; i++) {
          pages.push(i);
        }
        component.set("v.pages", pages);
        var paginationList = [];
        for (var i = 0; i < pageSize; i++) {
          if (datas.length > i) paginationList.push(datas[i]);
        }
        component.set("v.totalRecord", datas.length);
        component.set("v.objectList", datas);
        component.set("v.paginationList", paginationList);
        component.set("v.currentPage", 1);
        this.PageDetails(component,paginationList)
    },

    PageDetails: function(component, recs) {
        var paginationList = [];
        for (var i = 0; i < recs.length; i++) {
          paginationList.push(recs[i]);
        }
        component.set("v.paginationList", paginationList);
    }

    
})