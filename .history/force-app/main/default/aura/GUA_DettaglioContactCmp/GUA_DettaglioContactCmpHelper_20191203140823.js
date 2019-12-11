({
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
                if (!resultat.erreur) {
                    component.set('v.contactDetail',resultat.resultat);
                    var caseDetail = resultat.resultat;
                    console.log('#l caseDetail', JSON.stringify(caseDetail));

                    var obj = caseDetail.UAF_DatiAggiuntiviFile__c;
                    if(obj!=null){
                        var regex = /&quot;/gi;
                        obj = obj.replace(regex, '"');
                        obj = obj.replace(/""""/gi,'""');
                        component.set('v.datiAggiuntivi', JSON.parse(obj));
                    }
                    this.getFilialeCase(component);
                } else {
                    console.log('message Error');
                }
            }
        });
        $A.enqueueAction(action); 
    } ,
    getFilialeCase : function (component,event,helper){
        console.log('contactDetail '+JSON.stringify(component.get('v.contactDetail')));
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
                        component.set('v.filialeCase',resultat.filiale);
                } else {
                    console.log('message', "Error");
                }
            }
        });
        $A.enqueueAction(action); 
    },

    searchCapoFiliale : function(component){
        //getCapoFiliale(String idFiliale)
        var resultat;
        var filialeId= component.get('v.contactDetail.Account.Branch__c');
        console.log('caseDealer', JSON.stringify(filialeId));
        var action = component.get('c.getCapoFiliale');
        action.setParams({"idFiliale":filialeId.Account.Branch__c}); 
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                resultat = response.getReturnValue();
                console.log('capo '+JSON.stringify(resultat));
                if (!resultat.erreur) {
                    if(resultat.filiale==true){
                        component.set('v.capoFiliale',resultat.resultat);
                    }
                } else {
                    console.log('message', "Error");
                }
            }
        });
        $A.enqueueAction(action); 
        
    }
})