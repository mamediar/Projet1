({
    init:function(cmp,event,helper){
        console.log('3-B init');
        helper.buildTableColumnsMittente(cmp);
    },
    
    modificaMittente:function(cmp,event,helper){
        console.log('3-B MODIFICA MITTENTE');
        console.log('mittente selezionato lista MITT = ' + JSON.stringify(cmp.get('v.mittenteSelezionatoListaMitt')));
        if(cmp.get('v.mittenteSelezionatoListaMitt')){
            cmp.set('v.stepInserimentoMittenti','nuovo');
        }    
        else{
            cmp.set("v.toastMsg", "Nessun mittente selezionato");
            helper.showToastError(cmp);
            //alert('Nessun mittente selezionato');
        }
    },
    
    onRowSelection:function(cmp,event,helper){
        console.log('on row action: hai selezionato = '+ event.getParam('selectedRows')[0]);
        cmp.set('v.mittenteSelezionatoListaMitt',event.getParam('selectedRows')[0]);
    },
    
    eliminaMittente:function(cmp,event,helper){
        var mittente=cmp.get('v.mittenteSelezionatoListaMitt');    
        if(mittente){
            helper.eiliminaMittenteHelper(cmp,mittente);
        }
        else{
            component.set("v.toastMsg", "Nessun mittente selezionato");
            helper.showToastError(cmp);
            //alert('Nessun mittente selezionato');
        }

            
    }
})