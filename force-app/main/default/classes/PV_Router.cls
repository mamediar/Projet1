/**
 * @File Name          : PV_Router.cls
 * @Description        :
 * @Author             : Andrea Vanelli
 * @Group              :
 * @Last Modified By   : Andrea Vanelli
 * @Last Modified On   : 15/10/2019, 12:09:07
 * @Modification Log   :
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    3/8/2019, 13:59:21   Andrea Vanelli     Initial Version
 **/
// NOTE x rilascio
// creato field sul case Step_PV__c
// TODO da creare XCS_PV_ Config__c
// agganciata questa classe sul ProcessBuilder XXXXX

/* X TEST
   List<Case> cases = new List<Case>();
   Case caseObj = new Case(
    Categoria_Riferimento__c = 	'a0Y0Q000000QBl6UAG',
    Step_PV__c = '1',
    Status = 'Working',
    Origin = 'Phone');

   cases.add(caseObj);
   PV_Router.startPVRouter(cases);
   System.debug('FINE');
 */

public with sharing class PV_Router {

	static final String Status_PV_Da_Processare = 'PV_Da_Processare';

	@InvocableMethod(label='PV_Router' description='Metodo che invoca il router del Post Vendita!!!')
	public static void startPVRouter(List<Case> cases) {

		try {
			Map<String, Map<String,String> > filtriRegole= new Map<String, Map<String,String> >();
			List<Case> casesToUpdate = new List<Case>();


			// ciclo i case ricevuti per determinare i criteri di ricerca nelle regole
			String key;
			for (Case theCase : cases) {
				key = theCase.Categoria_Riferimento__c + ':' + theCase.Step_PV__c;
				//filtroAttuale = getFiltro(theCase.Categoria_Riferimento__c+":"+theCase.Step_PV__c, filtriRegole);
				if(!filtriRegole.containsKey(key)) {
					Map<String,String> filtro = new Map<String,String>();
					filtro.put('Categoria_Riferimento__c', theCase.Categoria_Riferimento__c);
					filtro.put('Step_PV__c', theCase.Step_PV__c);
					filtriRegole.put(key,filtro);
				}

			}
			System.debug(filtriRegole);
			// ora applico i filtri alla query sulle regole
			String sql = '';
			for (Map<String,String> valuesMap  : filtriRegole.values())
			{
				if (!sql.equals('') ) sql += ' OR ';
				sql += '(XCS_Categoria__c = \'' + valuesMap.get('Categoria_Riferimento__c') + '\' AND Step__c = \'' + valuesMap.get('Step_PV__c') + '\')';
			}
			sql = 'SELECT id,Name, XCS_Categoria__c, Stato__c, Step__c, Condizioni__c, Set_Stato__c, Set_Step__c,	Set_Coda__c, Set_Altro__c  '+
			      ' from XCS_PV_Config__c WHERE ' + sql;

			System.debug(sql);
			// ottengo i risultati
			List<XCS_PV_Config__c> XCS_PV_Configs = Database.query(sql);


			// preparo la lista code
			Map<String, ID> queuesMap = new Map<String, ID>(); //([SELECT DeveloperName, Id FROM Group WHERE DeveloperName like 'U%' or DeveloperName like 'F%' ]);
			for (Group theGroup:[Select Id, DeveloperName from Group where Type = 'Queue' AND (DeveloperName like 'U%' or DeveloperName like 'F%') ])
			{
				queuesMap.put(theGroup.DeveloperName,theGroup.Id);
			}

			//preparo lista degli uffici
			Map<ID, Account> ufficiMap = new Map<ID, Account>([Select OCS_External_Id__c, RecordType.Name, Name, Codice_Ufficio__c from Account WHERE RecordType.Name = 'Uffici e Altro' OR RecordType.Name = 'Branch']);


			// ciclo i case
			for (Case theCase : cases) {
				System.debug('CASE: ' + theCase);

				Case caseToUpdate = null;

// AV TODO dovrei mettere qua un try catch per gestire l'errore su un case/regola e poter comunque processare i rimanenti case
				// trovo la regola da applicare
				for (XCS_PV_Config__c rule : XCS_PV_Configs) {
					System.debug('RULE: ' + rule);

					if (checkCondizioniStandard(theCase, rule)) {
						// verifico le condizioni extra
						System.debug('condizioni standard OK');
						if (checkCondizioniAggiuntive(theCase, rule.Condizioni__c,ufficiMap)) {
							System.debug('condizioni extra OK');
							System.debug('regola ' +rule.Name);


							String setCoda;
							caseToUpdate = new Case(
								Id = theCase.Id,
								Status = rule.Set_Stato__c,
								Step_PV__c = rule.Set_Step__c

								);

							// TODO se chiuso potrei metterlo nella Q524	Coda Casi chiusi

							// se necessario trovo la coda
							if(!(rule.set_Coda__c==null || rule.set_Coda__c.equals(''))) {

								System.debug('setCoda: ' + rule.set_Coda__c);
								ID idCoda = null;
								// se la coda è filiale devo trovare la filiale
								if(rule.set_Coda__c.equals('FILIALE')) {
									// da capire se e a cosa serve e come individuare la filiale giusta
								} else if(rule.set_Coda__c.equals('UFF_INSERIMENTO')) {
									// prendo il codice dell'ufficio o filiale da Branch__r
									Account ufficio = ufficiMap.get(theCase.Branch__c);
									if (ufficio.RecordType.Name == 'Uffici e Altro') {
										idCoda = queuesMap.get('U'+ufficio.Codice_Ufficio__c);
									} else {
										idCoda = queuesMap.get(ufficio.OCS_External_Id__c);
									}

								} else if(rule.set_Coda__c.equals('UfficioDestinazione__c')) {
									// prendo il codice dell'ufficio o filiale da UfficioDestinazione__c
									Account ufficio = ufficiMap.get(theCase.UfficioDestinazione__c);
									if (ufficio.RecordType.Name == 'Uffici e Altro') {
										idCoda = queuesMap.get('U'+ufficio.Codice_Ufficio__c);
									} else {
										idCoda = queuesMap.get(ufficio.OCS_External_Id__c);
									}


								} else {
									// questo caso avrò la sigla di un ufficio
									idCoda = queuesMap.get(rule.set_Coda__c);
								}

								if (idCoda != null) caseToUpdate.OwnerId = idCoda;

							}

							// applico eventuali campi agguintivi, ritorna null se ci sono errori
							caseToUpdate = setCampiAggiuntivi(caseToUpdate, rule.Set_Altro__c);

							// termino loop sulle regole per questo Case
							break;
						}

					}
				}

				if (caseToUpdate == null) {
					// se è null non è stato possibile processarlo
					caseToUpdate = new Case(
						Id = theCase.Id,
						Status = 'PV Non Processabile'
						);
				}
				casesToUpdate.add(caseToUpdate);

			}
			System.debug('LISTA FINALE: ' + casesToUpdate);

			update casesToUpdate; // update a DB di tutti i case

		} catch (Exception ex) {
			// log
			//chiedere ivan (suggerito oggetto custom, con log errori gravi)
			System.debug('Exception: ' + ex.getTypeName() + ': ' + ex.getMessage() + ' -- ' + ex.getCause());
		}

		return;

	}


	private static boolean checkCondizioniStandard(Case theCase, XCS_PV_Config__c rule) {
		if (theCase.Categoria_Riferimento__c.equals(rule.XCS_Categoria__c)) {
			if (theCase.Step_PV__c.equals(rule.Step__c)) {
				if (theCase.Status.equals(rule.Stato__c)) {
					return true;
				}
			}
		}
		return false;
	}


	private static boolean checkCondizioniAggiuntive(Case theCase, String condizioni, Map<ID, Account> ufficiMap) {

		System.debug('Condizioni__c ' +condizioni);
		if (condizioni == null || condizioni.equals('')) return true;

		String[] arrCondizioni = condizioni.split(';');
		String field,valore;


		try {

			for (String condizione: arrCondizioni)
			{
				// per ogni condizione
				// se ==
				String operatore = '**';
				if (condizione.indexOf('==') > -1) {
					operatore = '==';
					String[] arrCondizione = condizione.split(operatore);
					field= arrCondizione[0];
					valore= arrCondizione[1];

					//System.debug('Condizioni__c caso == (field: ' +field + ' - valore: ' + theCase.get(field).toString()  + ')');

                    if ('null'.equalsIgnoreCase(valore)) {

						if (theCase.get(field) != null && !''.equals(theCase.get(field).toString())) {
							// se non corrisponde la regola non è rispettata
							return false;
						}
					} else {

						if (!field.equals('UFF_INSERIMENTO') && theCase.get(field) == null) {
							return false;
						} else {

							if(field.equals('UFF_INSERIMENTO')) {
								// prendo il codice dell'ufficio o filiale da Branch__r
								Account ufficio = ufficiMap.get(theCase.Branch__c);
								if (ufficio == null || ufficio.Codice_Ufficio__c != valore) {
									return false;
								}
							} else if (!valore.equalsIgnoreCase(theCase.get(field).toString())) {
								// se non corrisponde la regola non è rispettata
								return false;
							}
						}
					}



				} else if (condizione.indexOf('!=') > -1) {


					operatore = '!=';
					String[] arrCondizione = condizione.split(operatore);
					field= arrCondizione[0];
					valore= arrCondizione[1];
					//System.debug('Condizioni__c caso != (field: ' +field + ' - valore: ' + theCase.get(field).toString() + ')');

					if ('null'.equalsIgnoreCase(valore)) {

						if (theCase.get(field) == null || ''.equals(theCase.get(field).toString())) {
							// se non corrisponde la regola non è rispettata
							return false;
						}
					} else {

						// se non è null la regola prima verifico il campo
						if (!field.equals('UFF_INSERIMENTO') && theCase.get(field) == null) {
							//ok
						} else {

							if(field.equals('UFF_INSERIMENTO')) {
								// prendo il codice dell'ufficio o filiale da Branch__r
								Account ufficio = ufficiMap.get(theCase.Branch__c);
								if (ufficio == null || ufficio.Codice_Ufficio__c == valore) {
									return false;
								}
							} else if (valore.equalsIgnoreCase(theCase.get(field).toString())) {
								// se non corrisponde la regola non è rispettata
								return false;
							}
						}
					}

				} else {
					return false;
				}



			}
		} catch (Exception ex) {
			System.debug('Exception: PV_Router.checkCondizioniAggiuntive - ' + ex.getTypeName() + ': ' + ex.getMessage() + ' -- ' + ex.getCause());
			System.debug('-- condizioni: ' + condizioni);
			return false;
		}

		return true;
	}

	private static Case setCampiAggiuntivi(Case theCase, String campi) {

		if (campi == null || campi.equals('')) return theCase;

		String[] arrCampi = campi.split(';');
		String field,valore;

		try {

			for (String campo: arrCampi)
			{
				// per ogni campo
				String[] arrCampo = campo.split('=');
				field= arrCampo[0];
				valore= arrCampo[1];
				theCase.put(field, valore);
			}
		} catch (Exception ex) {
			System.debug('Exception: PV_Router.setCampiAggiuntivi - ' + ex.getTypeName() + ': ' + ex.getMessage() + ' -- ' + ex.getCause());
			System.debug('-- campi: ' + campi);
			return null;
		}

		return theCase;

	}




}