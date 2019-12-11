({
    init:function(cmp,event,helper){
        
    },
    
    cambiaProdotto:function(cmp,event,helper){
        if(cmp.get('v.praticaSelezionata')){
            console.log('(cmp.get(v.praticaSelezionata'+cmp.get('v.praticaSelezionata'));
            cmp.set('v.praticaSelezionata',null);
            cmp.set('v.infoPraticaSelezionata',null);
            cmp.set('v.stepInserimentoCliente',(cmp.get('v.stepInserimentoCliente')-1));
            console.log('(cmp.get(v.stepInserimentoCliente'+cmp.get('v.stepInserimentoCliente'));
        }
        else{
            alert('Nessuna pratica da selezionare');
        }
    }
})