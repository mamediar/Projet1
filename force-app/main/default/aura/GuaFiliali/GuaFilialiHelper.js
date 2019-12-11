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
                    this.searchCapoFiliale(component);
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
        
        var resultat;
        var myCase = component.get('v.filialeCase');
        if (myCase.hasOwnProperty('Account')) {
            var account = myCase.Account;
            console.log('response Account>>', JSON.stringify(myCase));
            if (account.hasOwnProperty('NameParentRoleReference__c')) {
                var action = component.get('c.getRecuperaUtenzeIntermediario');
                action.setParams({
                    "role": myCase.Account.NameParentRoleReference__c,
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
                            
                        }
                    }
                });
                $A.enqueueAction(action);
            }
        } else {
            console.log('NameRoleReference__c is undefined');
            component.set('v.userDealerList', []);
        }
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
       
    },
    searchCapoFiliale: function (component) {
        //getCapoFiliale(String idFiliale)
        var filiali = component.get('v.filialeCase');
        var action = component.get('c.getCapoFiliale');
        action.setParams({ "idFiliale": filiali.AccountId});
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                var resultat = response.getReturnValue();
                console.log('capo GuaFiliali' + JSON.stringify(resultat));
                if (!resultat.erreur) {
                    var data = resultat.resultat;
                    if (data != null) {
                        component.set('v.capoFiliale', resultat.resultat);
                    } else {
                        console.log('non capo')
                    }
                } else {
                    console.log('message', "Error");
                }
            }
        });
        $A.enqueueAction(action);
        /*if (filiali.hasOwnProperty('Account')) {
            var account = filiali.Account;
            if (account.hasOwnProperty('Branch__c')) {
                var filialeId = account.Branch__c;
                console.log('caseDealer', JSON.stringify(filialeId));
                
            }
            else{
                console.log('Account.Branch__c is undefined');
            }
        }*/
    }
})