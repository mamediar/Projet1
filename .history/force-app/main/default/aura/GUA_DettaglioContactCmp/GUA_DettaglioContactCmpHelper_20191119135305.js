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
        this.getFilialeCase(component, event, helper);

    },
    cercaDealer: function(component, event, helper) {
        var contactDetail= component.get('v.contactDetail');
        var eventContact = $A.get("e.force:navigateToComponent");
                eventContact.setParams({
        			componentDef : "c:GUA_SearchInformazioniDealerCmp",
        			componentAttributes: {
            		caseDealer : contactDetail,
                    isOpenedModal : true
        			}
    		});
            eventContact.fire();
    },
    chiudichiamata: function(component, event, helper) {
        component.set("v.isModalOpen", true);

    },

    creaTicketAltriUffici: function(component, event, helper) {},
    creaTicketFiliale: function(component, event) {},
    creaTicketCompassAffari: function(component, event, helper) {

    } ,
    getFilialeCase : function (component,event,helper){
        console.log('filiale '+JSON.stringify(component.get('v.contactDetail')));
        var resultat;
        var filialeId= component.get('v.contactDetail.Account.Branch__c');
        console.log('caseDealer', JSON.stringify(filialeId));
        var action = component.get('c.getFilialeById');
        action.setParams({"idAccount":filialeId}); 
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                resultat = response.getReturnValue();
                console.log('filiale '+JSON.stringify(resultat));
                if (!resultat.erreur) {
                    if(resultat.filiale==true){
                        component.set('v.filialeCase',resultat.filiale);
                    }
                } else {
                    console.log('message', "Error");
                }
            }
        });
        $A.enqueueAction(action); 
    }
})