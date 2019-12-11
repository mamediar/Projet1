/* 
Author: Andrea Vanelli

*/

public class PVRecuperaDatiPostvenditaController {
	@AuraEnabled
	public static Map<String,List<Object> > getClienti(Map<String,String> data, String filtroClassName, Map<String,String> filtroParametriMap){
		Map<String,List<Object> > res=new Map<String,List<Object> >();
		System.debug('OCSRecuperaDatiPostvenditaInvoker.callRecDatiPV: ' +data);
			system.debug('getClienti filtroPratica : ' +filtroClassName  );
			system.debug(filtroParametriMap);
		//	system.debug(filtroParametriMap.get('filiale'));
        // AV TODO NBC si dovrebbe gestire eventuali errori del servizio facendo prima  OCSRecuperaDatiPostvenditaResponse reas = (OCSRecuperaDatiPostvenditaInvoker.callRecDatiPV(data)

		List<OCSCliente> clientiList=OCSObjectsFactory.makeClienti(OCSRecuperaDatiPostvenditaInvoker.callRecDatiPV(data));
        // AV il filtro lo metto qua, avoid passare al JS tutto e tornare nell'APEX per filtrare cliente per cliente tutte le pratiche... NBC
		if (filtroClassName != null && !filtroClassName.equals('')) {
            PVRecuperaDatiPVFiltroInterface filtro = (PVRecuperaDatiPVFiltroInterface)Type.forName(filtroClassName).newInstance();
            clientiList =filtro.filtra(clientiList,filtroParametriMap);
        }
        // AV qua ho filtrato...




		res.put('clienti',clientiList);
		return res;
	}

	public List<OCSCliente> elaboraStandard(List<OCSCliente> clienti, Map<String,String> filtroParametriMap){
		// AV pensa un po APEX NON HA ListIterator e dobbiamo creare nuove liste per trattare le liste... !!
		List<OCSCliente> newClienti = new List<OCSCliente>();


		Iterator<OCSCliente> clientiIterator = clienti.iterator();
		while(clientiIterator.hasNext()) {
			OCSCliente cliente = clientiIterator.next();

			List<OCSPratica> newPratiche = new List<OCSPratica>();
			Iterator<OCSPratica> praticheIterator = cliente.pratiche.iterator();
			while(praticheIterator.hasNext()) {
				OCSPratica pratica = praticheIterator.next();
				
				// fare altre code
				
				//pratica = filtroPratica(pratica,filtroParametriMap);
				if (pratica != null) {
					newPratiche.add(pratica);
				}
				/*if(!pratica.filiale.equals('012')) {
				        // AV esempio rimozione (NON FARE NULLA)
				   } else {
				        // AV esempio elemento OK (aggiungere a nuova lista)
				        newPratiche.add(pratica);
				   }

				   //AV esempio modifica (modifica elemento e aggiunti anuova lista)
				   if(pratica.filiale.equals('012')) {
				        pratica.numPratica = '999999999';
				        newPratiche.add(pratica);
				   }
				 */

			}
			// fine cilclo pratiche del cliente
			//cliente.pratiche = elaboraPratiche(newPratiche,filtroParametriMap);
			// AV per ora aggiungo sempre tutti i clienti (verificare se vale la pena eliminarlo se non ha pratiche)
			newClienti.add(cliente);


		}
		return newClienti;
	}


}