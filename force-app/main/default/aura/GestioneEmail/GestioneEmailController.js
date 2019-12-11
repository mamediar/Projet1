({
    init : function(cmp, event, helper) {
        helper.setOptions(cmp); 
        helper.loadData(cmp);
        console.log('init');
    },     
    
    changeType : function(cmp, event, helper){  
        helper.setDataTable(cmp);
        cmp.set('v.configEmailFaxData', helper.search(cmp, helper.filterType(cmp)));
    },
    
    checkBalance : function(cmp, event, helper){      
        var toast = $A.get('e.force:showToast');
        var draft = event.getParam('draftValues');
        for(var i in draft){
            if (draft[i].Balancing__c < 0)
                var checkForStarting = true;
        }       
        if(checkForStarting){
            toast.setParams({
                'title' : 'Attenzione! Il balancing non può essere un numero negativo!',
                'type' : 'warning',
                'message' : ' '                   
            });                       
            toast.fire();                             
        }
        else{    
            var action = cmp.get('c.checkRecords');
            action.setParam('data', draft);
            action.setCallback(this, function(response){
                if(response.getState() == 'SUCCESS'){
                    var result = response.getReturnValue();
                    console.log(result);
                    if(Object.keys(result).length > 0){
                        if(Object.keys(result).length == 1){
                            toast.setParams({
                                'title' : 'Attenzione! ' + Object.keys(result) + ' ha un balancing totale diverso da 100',
                                'type' : 'warning',
                                'message' : ' '                   
                            });                       
                            toast.fire();
                            console.log('1 element');
                        }
                        else{  
                            var rows = Object.keys(result).toString().split(',');
                            console.log('rows ' + rows);
                            var message = '';
                            for(var c in rows) message += rows[c] + '\n';
                            toast.setParams({
                                'title' : 'Attenzione! le seguenti Email hanno un balancing totale diverso da 100',
                                'type' : 'warning',
                                'message' : message                   
                            });
                            toast.fire();
                            console.log('more than 1 element');                        
                        }                        
                    } else {
                        setTimeout(function(){$A.get('e.force:refreshView').fire(); }, 1500);
                        toast.setParams({
                            'title' : 'Dati aggiornati con successo!',
                            'type' : 'success',
                            'message' : ' '                   
                        });
                        toast.fire();
                        console.log('No Element');
                    }
                }
            });  
            $A.enqueueAction(action);                     
        }
    },    
    
    isChanged : function(cmp, event, helper){
        cmp.set('v.suppressBottomBar', false);
    },
    
    searchValues : function(cmp, event, helper){
        cmp.set('v.configEmailFaxData', helper.search(cmp, helper.filterType(cmp)));
    },
    
    refreshTableView : function(cmp, event, helper){
        var buttonItem = cmp.find('refreshButtonContainer').getElement();        
        helper.rotate(buttonItem);
        helper.loadData(cmp);
    }
})