({
    handleManageContact : function(component, event, helper) {
        var resultat;
        var recordId= component.get('v.recordId');
        console.log('recordId', JSON.stringify(recordId));
        var action = component.get('c.getDealerByCase');
        action.setParams({"idCase":recordId}); 
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                resultat = response.getReturnValue();
                if (!resultat.erreur) {
                    var contact = resultat.resultat;
                    console.log('getDealerByCase', JSON.stringify(resultat));
                    component.set('v.caseDealer',resultat.resultat);
                    
                    var obj = contact.UAF_DatiAggiuntiviFile__c;
                    if(obj!=null){
                        var regex = /&quot;/gi;
                        obj = obj.replace(regex, '"');
                        obj = obj.replace(/""""/gi,'""');
                        component.set('v.datiAggiuntivi', JSON.parse(obj));
                    }
                        this.getFilialeCase(component,event,helper);
                } else {
                    console.log('message', "Error");
                }
            }
        });
        $A.enqueueAction(action); 
         
    },
    getFilialeCase : function (component,event,helper){
        //getFilialeById(String idAccount)
        var resultat;
        var caseDealer= component.get('v.caseDealer');
        if(caseDealer.hasOwnProperty('Account')) {
            var account = caseDealer.Account;
            if (account.hasOwnProperty('Branch__c')) {
                var filialeId = account.Branch__c;
                console.log('caseDealer', JSON.stringify(filialeId));
                var action = component.get('c.getFilialeById');
                action.setParams({"idAccount":filialeId}); 
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
                this.searchCapoFiliale(component);
        }
        }
    },
    searchCapoFiliale : function(component){
        //getCapoFiliale(String idFiliale)
        var resultat;
        var caseDealer= component.get('v.caseDealer');
        if(caseDealer.hasOwnProperty('Account')) {
            var account = caseDealer.Account;
            if (account.hasOwnProperty('Branch__c')) {
                var filialeId = account.Branch__c;
                console.log('caseDealer', JSON.stringify(filialeId));
                var action = component.get('c.getCapoFiliale');
                action.setParams({"idFiliale":filialeId}); 
                action.setCallback(this, function (response) {
                    if (response.getState() === "SUCCESS") {
                        resultat = response.getReturnValue();
                        console.log('capo GuaDealer'+JSON.stringify(resultat));
                        if (!resultat.erreur) {
                            var data= resultat.resultat;
                            if(data!=null){
                                component.set('v.capoFiliale',resultat.resultat);
                            }else{
                                console.log('non capo')
                            }
                                
                        } else {
                            console.log('message', "Error");
                        }
                    }
                });
                $A.enqueueAction(action); 
            }
        }
    },
    gesDispositionDay : function(component){
        //getCapoFiliale(String idFiliale)
        var resultat;
        var caseDealer= component.get('v.caseDealer');
        if(caseDealer.hasOwnProperty('Account')) {
            var account = caseDealer.Account;
            if (account.hasOwnProperty('Branch__c')) {
                var filialeId = account.Branch__c;
                console.log('caseDealer', JSON.stringify(filialeId));
                var action = component.get('c.searchDisponibilitaFiliale');
                action.setParams({"idFiliale":filialeId}); 
                action.setCallback(this, function (response) {
                    if (response.getState() === "SUCCESS") {
                        resultat = response.getReturnValue();
                        console.log('capo GuaDealer'+JSON.stringify(resultat));
                        if (!resultat.erreur) {
                            var data= resultat.date;
                            if(data!=null){
                                component.set('v.dispoDay',resultat.date);
                            }else{
                                console.log('non capo')
                            }
                        } else {
                            console.log('message', "Error");
                        }
                    }
                });
                $A.enqueueAction(action); 
            }
        }
    }
})