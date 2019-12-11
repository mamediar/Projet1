({
    handleManageContact: function(component, event, helper) {
        var contactsCaseList;
        var resultat;
        var contact = component.get('v.contactDetail');
        var queueCntct = component.get('v.queueContact');
        console.log('contact', JSON.stringify(contact));
        console.log('queueCntct', JSON.stringify(queueCntct));

        var obj = contact.UAF_DatiAggiuntiviFile__c;
        var regex = /&quot;/gi;
        obj = obj.replace(regex, '"');
        obj = obj.replace(/""""/gi,'""');
        component.set('v.datiAggiuntivi', JSON.parse(obj));

        
/*
        var action = component.get('c.getCase');
        action.setParams({ "idCampagn": contact.CampaignId__c });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                resultat = response.getReturnValue();
                if (!resultat.erreur) {
                    console.log('resultat ' + JSON.stringify(resultat));

                    var obj = resultat.resultat.UAF_DatiAggiuntiviFile__c;
                    var regex = /&quot;/gi;
                    obj = obj.replace(regex, '"');
                    obj = obj.replace(/""""/gi,'""');
                    component.set('v.datiAggiuntivi', JSON.parse(obj));

                   
                    contactsCaseList = resultat.resultat;
                    component.set('v.contactDetail', contactsCaseList);
                    component.set('v.uafDatiAggiuntiviFile', resultat.mainJSONWrapper);
                } else {
                    console.log('message', "Error");
                }
            }
        });
        $A.enqueueAction(action);
        */
    },
    chiama: function(component, event, helper) {
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