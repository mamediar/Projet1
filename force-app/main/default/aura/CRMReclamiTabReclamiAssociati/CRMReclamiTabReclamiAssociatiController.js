({
    init : function(cmp, event, helper) {
        console.log('**********init reclami associati**********');
        helper.setOptions(cmp);
        helper.loadData(cmp);        
    },
    
    getRowId : function(cmp,event,helper){
        var valore= JSON.stringify(event.getParam('selectedRows')[0].Id);
        cmp.set('v.idReclamoAssociatoSelezionato', valore);
        console.log('riga ======= ' + valore);        
    },
    //
    //capire se mostrare anche il reclamo stesso, o se toglierlo del tutto e mostrare solo gli associati de-facto
    navigateToReclamoAssociato : function(cmp,event,helper){
        console.log('ID RECLAMO ASSOCIATO : ' + cmp.get('v.idReclamoAssociatoSelezionato'));
        var idReclamoAssociatoSelezionato = cmp.get('v.idReclamoAssociatoSelezionato');
        if(idReclamoAssociatoSelezionato){
        var navigation = cmp.find("navigation"); 
        var action = cmp.get('c.preRedirect');
        console.log('record id = ' + cmp.get('v.recordId'));
        console.log('selezi id = ' + cmp.get('v.idReclamoAssociatoSelezionato'));        
                 
        action.setParam('recordId', idReclamoAssociatoSelezionato );
        action.setCallback(this,function(response){
            if(response.getState() == 'SUCCESS'){
                var pageReference = response.getReturnValue();
                console.log('pagereference ' + JSON.stringify(pageReference));
                navigation.navigate(pageReference);
            }
        });
        $A.enqueueAction(action);
        }
        else
            alert('nessun reclamo selezionato!');
    }
    
    
})