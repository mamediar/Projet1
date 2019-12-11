({
    handleManageContact: function(component, event, helper) {
        var contact = component.get('v.contactDetail');
        var queueCntct = component.get('v.queueContact');
        console.log('contact', JSON.stringify(contact));
        console.log('queueCntct', JSON.stringify(queueCntct));

        var obj = contact.UAF_DatiAggiuntiviFile__c;
        var regex = /&quot;/gi;
        obj = obj.replace(regex, '"');
        obj = obj.replace(/""""/gi,'""');
        component.set('v.datiAggiuntivi', JSON.parse(obj));

    },
    cercaDealer: function(component, event, helper) {
        component.set("v.isChiama", true);
        console.log(' here');
    },
    chiudichiamata: function(component, event, helper) {
        component.set("v.isModalOpen", true);

    },

    creaTicketAltriUffici: function(component, event, helper) {},
    creaTicketFiliale: function(component, event, helper) {},
    creaTicketCompassAffari: function(component, event, helper) {

    }
})