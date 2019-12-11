({
    showModalSearDealer: function(component, event, helper) {
        console.log('############# running ssssssssssssss');

        helper.showModal(component, event);
    },

    closeModalSearDealer: function(component, event, helper) {
        helper.closeModal(component, event);
    },

    recerceDealer: function(component, event, helper) {
        console.log('############# ' + component.get("v.nomeDealer"));
        helper.recercaInformationDealer(component, event, helper);
    },


    doInit: function(component, event, helper) {
        console.log('################## init ');
        /*  var actions = [
              { label: 'Show details', name: 'show_details' },
              { label: 'Delete', name: 'delete' }
          ],
          fetchData = {
              name : 'company.companyName',
              author: 'name.findName',
              published : 'address.state'
          };


          component.set('v.columns', [
              { label: 'Regione Sociale', fieldName: 'Dealer__r.Region_Name__c', type: 'text' },
              { label: 'Cod OCS', fieldName: 'CodiceDealer__c', type: 'text' },
              { label: 'Tipo', fieldName: 'published', type: 'text' },
              { label: 'Stato', fieldName: 'Stato_Pratica__c', type: 'text' },
              { label: 'Prov', fieldName: 'published', type: 'text' },
              { type: 'action', typeAttributes: { rowActions: actions } }
          ]);
          helper.showModal(component,event); */
    },

    handleRowAction: function(component, event, helper) {
        var action = event.getParam('action');
        component.set("v.rowSelected", event.getParam('row'));
        switch (action.name) {
            case 'show_details':
                helper.showDetail(component, event);
                break;
        }
    },


    handleNext: function(component, event, helper) {
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber + 1);
        helper.recercaInformationDealer(component, event, helper);
    },

    handlePrev: function(component, event, helper) {
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber - 1);
        helper.recercaInformationDealer(component, event, helper);
    },
    dealerSelected: function(component, event, helper) {
        var dSelected = event.getSource().get('v.value');
        console.log('################## dealerSelected controller  '+dSelected);
        helper.dealerSelected(component, event, dSelected);
    },
    handleManageContact: function(component, event, helper) {

    },
    dettaglioDealer: function(component, event, helper) {

    }


})