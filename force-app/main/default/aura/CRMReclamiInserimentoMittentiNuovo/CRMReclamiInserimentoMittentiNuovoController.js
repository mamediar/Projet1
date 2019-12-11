({
    init:function(cmp,event,helper){
        console.log('2-B -------> INIT');
        helper.initHelper(cmp,helper);
        helper.buildSalutiValues(cmp);        
        helper.buildIndirizziValues(cmp); 
    },
    
    rebuildSalutoValues:function(cmp,event,helper){
        helper.buildSalutiValues(cmp);
    },
     
    salva:function(cmp,event,helper){
        cmp.set('v.isOk',helper.checkIfok(cmp,helper));
        console.log('Mittente Nuovo List: '+cmp.get('v.isOk'));
        if(cmp.get('v.isOk')){
            if(!cmp.get('v.mittenteSelezionatoListaMitt')){
                if(cmp.get('v.indirizzoPredefinitoMittente')){
                    helper.salvaIndPred(cmp);
                }
                else{
                    helper.salvaMittente(cmp);
                }
            }
            else{
                helper.salvaModifiche(cmp);
            }
        }
        else{
            alert('Compilare i campi obbligatori prima di salvare.');
        }
    },
    
    annulla:function(cmp,event,helper){
        cmp.set('v.mittenteSelezionatoListaMitt',null);
        cmp.set('v.stepInserimentoMittenti','main');
    },
    
    selectIndirizzo:function(cmp,event,helper){
        helper.selectIndirizzoHelper(cmp);
        helper.initHelper(cmp,helper);
        cmp.set('v.isOk',helper.checkIfok(cmp,helper));
    },
    
    checkValues:function(cmp,event,helper){
        console.log('2-a CHECK VALUES');
        cmp.set('v.isOk',helper.checkIfok(cmp,helper));
        console.log('CHECKVALUEEE : '+cmp.get('v.isOk'));
    },
    checkLength : function(component, event, helper) {

        var change = event.getSource().get("v.name");
        if(change==='cap'){
            var val = component.find("cap").get('v.value');
            if(val.length > 5){
                console.log('CAP SBAGLIATOOOO');
                var comp = component.find("cap");
                comp.set('v.value',val.substring(0,5));
            }
        }
    }
})