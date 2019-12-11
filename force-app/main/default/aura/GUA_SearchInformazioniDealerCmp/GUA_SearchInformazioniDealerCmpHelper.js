({

    showModal: function(component, event) {
        console.log('############# running showModal');
        component.set("v.isOpenedModal", true);
    },
    closeModal: function(component, event) {
        component.set("v.isOpenedModal", false);
        component.set("v.nomeDealer", '');
        component.set("v.codiceOcsDealer", '');
        component.set("v.utenzaOrCFDealer", '');
        component.set("v.data", []);
        component.set("v.isFounded", false);
    },

    recercaInformationDealer: function(component, event, helper) {

        var pageSize = component.get("v.pageSize").toString();
        var pageNumber = component.get("v.pageNumber").toString();

        var nameDealer = component.get("v.nomeDealer");
        var codiceOcsDealer = component.get("v.codiceOcsDealer");
        var utenzaOrCFDealer = component.get("v.utenzaOrCFDealer");
        var action = component.get('c.filterCaseByNomeOcsCF');
        console.log('#################  nameDealer ' + nameDealer);
        console.log('#################  codiceOcsDealer ' + codiceOcsDealer);
        var resultat;
        action.setParams({
            "nome": nameDealer,
            "codiceOcs": codiceOcsDealer,
            "utenzoCF": utenzaOrCFDealer,
            'pageSize': pageSize,
            'pageNumber': pageNumber
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                resultat = response.getReturnValue();
                console.log('resultat  >> ', resultat);
                //console.log('############## cntactsCases size  json'+ JSON.stringify(resultat.cntactsCases));
                console.log('############## cntactsCases size ' + resultat.cntactsCases.length);
                console.log('############### liste ' + JSON.stringify(resultat.cntactsCases));
                if (resultat.cntactsCases.length < component.get("v.pageSize")) {
                    component.set("v.isLastPage", true);
                } else {
                    component.set("v.isLastPage", false);
                }
                component.set("v.dataSize", resultat.cntactsCases.length);
                component.set("v.data", resultat.cntactsCases);

                /*     console.log('########### yesss ');
                     var searchEvent = $A.get("e.c:GUA_SearchByCodiceDealerEvt");
                        searchEvent.setParams({
                            "caseDealer": resultat.cntactsCases
                        }); 
                        searchEvent.fire();   */

                component.set("v.data", resultat.cntactsCases);
                component.set("v.isFounded", true);
                this.displaye(component, event);


            } else {
                console.log('message', "Error");
            }
        });
        $A.enqueueAction(action);
    },

    displaye: function(component, event) {
        var actions = [
                { label: 'Show details', name: 'show_details' },
                { label: 'Delete', name: 'delete' }
            ],
            fetchData = {
                name: 'company.companyName',
                author: 'name.findName',
                published: 'address.state'
            };


        component.set('v.columns', [
            { label: 'Regione Sociale', fieldName: 'name', type: 'text' },
            { label: 'Cod OCS', fieldName: 'author', type: 'text' },
            { label: 'Tipo', fieldName: 'published', type: 'text' },
            { label: 'Stato', fieldName: 'published', type: 'text' },
            { label: 'Prov', fieldName: 'published', type: 'text' },
            { type: 'action', typeAttributes: { rowActions: actions } }
        ]);
    },
    showDetail: function(component, event) {
        var caseSelected = component.get("v.rowSelected");
        var searchEvent = $A.get("e.c:GUA_SearchByCodiceDealerEvt");
        searchEvent.setParams({
            "caseDealer": caseSelected
        });
        searchEvent.fire();
        component.set("v.isOpenedModal", false);
        this.closeModal(component, event);

    },
    dealerSelected: function(component, event,dSelected) {
       
        console.log('################## dealerSelected helper  ' + JSON.stringify(dSelected));

        /*   var searchEvent =  $A.get("e.c:GUA_SearchByCodiceDealerEvt");
           searchEvent.setParams({
              "caseDealer" : dSelected
           }); 
           searchEvent.fire();  */
        /*     var obj = caseDealer.UAF_DatiAggiuntiviFile__c;
             var regex = /&quot;/gi;
             obj = obj.replace(regex, '"');
             obj = obj.replace(/""""/gi,'""');
             */
        component.set("v.dealer", dSelected);
        component.set("v.isOpen", true);
        component.set("v.isOpenedModal", false);
        component.set("v.caseDealer", dSelected);
    }
})