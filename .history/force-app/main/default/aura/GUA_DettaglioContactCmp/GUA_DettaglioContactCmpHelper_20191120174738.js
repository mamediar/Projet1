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
    },
    getCaseByRecord : function(component){
        var resultat;
        var recordId= component.get('v.recordId');
        console.log('caseDealer', JSON.stringify(recordId));
        var action = component.get('c.getCase');
        action.setParams({"idCase":recordId}); 
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                resultat = response.getReturnValue();
                console.log('caseDetail '+JSON.stringify(resultat));
                if (!resultat.erreur) {
                    component.set('v.contactDetail',resultat.resultat);

                    var caseDetail =resultat.resultat;
                    var obj = caseDetail.UAF_DatiAggiuntiviFile__c;
                    var regex = /&quot;/gi;
                    obj = obj.replace(regex, '"');
                    obj = obj.replace(/""""/gi,'""');
                    component.set('v.datiAggiuntivi', JSON.parse(obj));
                } else {
                    console.log('message Error');
                }
            }
        });
        $A.enqueueAction(action); 
    },
    getFilialeCase : function (component,event,helper){
        //getFilialeById(String idAccount)
        var resultat;
        var idFiliale= component.get('v.caseDealer.Account.Branch__c');
        console.log('caseDealer', JSON.stringify(idFiliale));
        var action = component.get('c.getFilialeById');
        action.setParams({"idAccount":idFiliale}); 
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                resultat = response.getReturnValue();
                console.log('filiale '+JSON.stringify(resultat));
                if (!resultat.erreur) {
                        component.set('v.filialeCase',resultat.filiale);
                        var tf=component.get('v.filialeCase');
                        console.log('tf '+tf);
                } else {
                    console.log('message', "Error");
                }
            }
        });
        $A.enqueueAction(action); 
    }
})