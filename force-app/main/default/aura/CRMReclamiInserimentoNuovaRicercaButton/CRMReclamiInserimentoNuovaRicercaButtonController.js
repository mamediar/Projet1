({
	nuovaRicerca:function(cmp,event,helper){
        console.log('sono in inserimento nuova ricerca button');
        cmp.set('v.listaClienti',null);
        cmp.set('v.clienteSelezionato',null);
        cmp.set('v.clienteSelezionatoContainer',null);
        cmp.set('v.listaPratiche',null);
        cmp.set('v.praticaSelezionata',null);
        cmp.set('v.praticaSelezionataContainer',null);
        cmp.get('v.listaInfoPratiche',null);
        cmp.set('v.infoPraticaSelezionata',null);
		cmp.set('v.stepInserimentoCliente',1);
    }
    /*
    nuovaRicerca:function(cmp,event,helper){
        //gestione reclamo
        var numReclamo = cmp.get('v.numeroReclamo');

        if(numReclamo!=null){
        
          var reclamo = cmp.get('v.reclamoSelezionato');
          var step = cmp.get('v.stepInserimentoCliente');

          var praticaSelezionata = cmp.get('v.praticaSelezionata');
          var infoPraticaSelezionata = cmp.get('v.infoPraticaSelezionata');
          var showCambiaProdotto = cmp.get('v.showCambiaProdotto');
          var filiale = cmp.get('v.filiale');

          cmp.set('v.reclamoSelezionato',reclamo);
          cmp.set('v.stepInserimentoCliente',step);
          cmp.set('v.praticaSelezionata',praticaSelezionata);
          cmp.set('v.infoPraticaSelezionata',infoPraticaSelezionata);
          cmp.set('v.showCambiaProdotto',showCambiaProdotto);
          cmp.set('v.filiale',filiale);

        }else{
          console.log('sono in inserimento nuova ricerca button');
          cmp.set('v.listaClienti',null);
          cmp.set('v.clienteSelezionato',null);
          cmp.set('v.clienteSelezionatoContainer',null);
          cmp.set('v.listaPratiche',null);
          cmp.set('v.praticaSelezionata',null);
          cmp.set('v.praticaSelezionataContainer',null);
          cmp.get('v.listaInfoPratiche',null);
          cmp.set('v.infoPraticaSelezionata',null);
        }

        cmp.set('v.stepInserimentoCliente',1);
      }
    */
})