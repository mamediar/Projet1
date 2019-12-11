({
    init:function(cmp,event,helper){
        console.log('listaInfoPratiche');
        console.log(cmp.get('v.listaInfoPratiche'));
        if(cmp.get('v.aziendaSelezionata') =='Futuro'){
           cmp.set('v.columns',helper.setColumnsF()); 
        }      
        else{
        	cmp.set('v.columns',helper.setColumns());
        }
    },
    
    selectPratica:function(cmp,event,helper){
        console.log('sono in selectPratica di lista pratiche controller' );
        var pratiche=cmp.get('v.listaPratiche');
        cmp.set('v.infoPraticaSelezionata',event.getParam('selectedRows')[0]);
        pratiche.forEach(function(temp){
            if(temp['numPratica']==event.getParam('selectedRows')[0]['numPratica']){
                cmp.set('v.praticaSelezionata',temp);
                return;
            }
        });
    }
})