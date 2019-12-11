({
    handleCaseSearch: function(component, event, helper) {
        console.log('############### running  handleCaseSearch ');
        helper.showDetail_Dealer(component, event);
        

    },
    afterScriptsLoaded: function(component, event, helper) {
        console.log('############### test ');
        _map.callapsef();
    },
    showModal: function(component, event, helper) {
        console.log('############# running showModalSearDealer');
        component.set("v.isOpenedModal", true);
        var showModalEvent = component.getEvent("guaSearchDealerEvt");
        console.log('##### event ##### ' + JSON.stringify(showModalEvent));
        showModalEvent.fire();
        console.log('############# running after');

    }

})