public abstract class PVRecuperaDatiPVFiltroInterface {


	public abstract OCSPratica filtroPratica(OCSPratica pratica,Map<String,String> filtroParametriMap);
	public abstract List<OCSPratica> elaboraPratiche(List<OCSPratica> listaPratiche,Map<String,String> filtroParametriMap);

	public List<OCSCliente> filtra(List<OCSCliente> clienti, Map<String,String> filtroParametriMap){
		// AV pensa un po APEX NON HA ListIterator e dobbiamo creare nuove liste per trattare le liste... !!
		List<OCSCliente> newClienti = new List<OCSCliente>();


		Iterator<OCSCliente> clientiIterator = clienti.iterator();
		while(clientiIterator.hasNext()) {
			OCSCliente cliente = clientiIterator.next();

			List<OCSPratica> newPratiche = new List<OCSPratica>();
			Iterator<OCSPratica> praticheIterator = cliente.pratiche.iterator();
			while(praticheIterator.hasNext()) {
				OCSPratica pratica = praticheIterator.next();
				pratica = filtroPratica(pratica,filtroParametriMap);
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
			cliente.pratiche = elaboraPratiche(newPratiche,filtroParametriMap);
			// AV per ora aggiungo sempre tutti i clienti (verificare se vale la pena eliminarlo se non ha pratiche)
			newClienti.add(cliente);


		}
		return newClienti;
	}
}