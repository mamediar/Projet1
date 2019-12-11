({
    toastIndirizzoNonTrovato : function() {
        var toast = $A.get('e.force:showToast');
        toast.setParams({
            'title' : 'Attenzione! Nessun indirizzo trovato!',
            'type' : 'warning',
            'message' : ' '                   
        });                       
        toast.fire();   
    },
    
    toastProblemaServer : function(){
        var toast = $A.get('e.force:showToast');
        toast.setParams({
            'title' : 'Attenzione!',
            'type' : 'warning',
            'message' : 'È stato riscontrato un problema. Potrebbe essere sufficiente ricaricare la pagina o rieffettuare la ricerca.'
            + '\nNel caso il problema persista, contattare l\' amministratore'
        });                       
        toast.fire();    
    },
    
    callOCS : function(cmp, event, helper) {
        var action = cmp.get("c.recuperaIndirizzi");
        action.setParam('input',cmp.get('v.indirizzoInput'));
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){               
                var response = resp.getReturnValue();  
                console.log('la response è = ' +JSON.stringify(response));
                if(response.length == 1){
                    if(cmp.get('v.showAlwaysModale')){  // booleano che controlla la visualizzazione della modale anche quando l indirizzo ritornato è solo 1
                        cmp.set('v.showModale',true);
                        cmp.set('v.indirizziData',response);
                        //è la logica per preselezionare la prima riga della datatable. osservazione: il keyField è "indirizzo"
                        var arr = [];
                        arr.push(cmp.get('v.indirizziData')[0]['indirizzo']);
                        cmp.set('v.selectedIndirizzo',arr);
                        cmp.set('v.indirizzoOutput',cmp.get('v.indirizziData')[0]);
                        
                    }
                    else{
                        cmp.set('v.indirizzoOutput',response);  
                        helper.launchEvent(cmp,event,helper);
                    }
                }
                else if (response.length > 1){
                    cmp.set('v.showModale',true);
                    cmp.set('v.indirizziData',response); 
                    //è la logica per preselezionare la prima riga della datatable
                    var arr = [];
                    arr.push(cmp.get('v.indirizziData')[0]['indirizzo']);
                    cmp.set('v.selectedIndirizzo',arr);
                    cmp.set('v.indirizzoOutput',cmp.get('v.indirizziData')[0]);
                } 
                    else
                        helper.toastIndirizzoNonTrovato();
            }  
            else
                helper.toastProblemaServer();
        });
        $A.enqueueAction(action); 
    },
    
    launchEvent : function(component, event, helper) {
        var event = $A.get("e.c:XCS_RiceviIndirizzoEvent");
        event.setParams({
            "indirizzoOutput": component.get("v.indirizzoOutput")
        });
        event.fire();
    }
})