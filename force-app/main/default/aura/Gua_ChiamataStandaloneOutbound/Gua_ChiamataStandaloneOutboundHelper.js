({
    chiamateOutboundDealer: function(component, event, helper) {
        component.set("v.isOpenedModal", true);
        component.set('v.showDetailFiliale', false);
        component.set("v.showDetailDealer", true);
        console.log('############# running after isOpenedModal');
    },
    chiamateOutboundFiliale: function(component, event, helper) {
        component.set('v.showDetailFiliale', true);
        component.set("v.isOpenedModal", false);
        component.set("v.showDetailDealer", false);
    },
    showDetail_Dealer: function(component, event) {
        var caseDealer = event.getParam('caseDealer');
        console.log('############### running  handleCaseSearch  cases test ' + JSON.stringify(caseDealer));
        var obj = caseDealer.UAF_DatiAggiuntiviFile__c;
        var regex = /&quot;/gi;
        obj = obj.replace(regex, '"');
        obj = obj.replace(/""""/gi, '""');
        component.set('v.datiAggiuntivi', JSON.parse(obj));
        component.set("v.isFoundDealer", true);
        component.set("v.isOpenedModal", false);
        component.set("v.isOpen", true);
        component.set("v.caseDealer", caseDealer);
        component.set("v.datiAggiuntivi", obj);
    },
})