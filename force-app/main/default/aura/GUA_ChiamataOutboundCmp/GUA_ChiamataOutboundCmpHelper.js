({
    showDetail_Dealer : function(component, event) {
        var caseDealer = event.getParam('caseDealer');
        console.log('############### running  handleCaseSearch  cases test ' +  JSON.stringify(caseDealer));
        var obj = caseDealer.UAF_DatiAggiuntiviFile__c;
        var regex = /&quot;/gi;
        obj = obj.replace(regex, '"');
        obj = obj.replace(/""""/gi,'""');
        component.set('v.datiAggiuntivi', JSON.parse(obj));
        component.set("v.isFoundDealer", true);
        component.set("v.isOpenedModal", false);
        component.set("v.isOpen", true);
        component.set("v.caseDealer",caseDealer );
        component.set("v.datiAggiuntivi",obj );

    /*    var action =  component.get('c.getInformazioniDealerByCodeOCS');
        action.setParams({
            'codiceOCS': codeOCS
        });*/

    },


})