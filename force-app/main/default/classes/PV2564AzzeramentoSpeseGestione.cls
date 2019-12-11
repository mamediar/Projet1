/**
 * @File Name          : PV2564AzzeramentoSpeseGestione.cls
 * @Description        :
 * @Author             : Andrea Vanelli
 * @Group              :
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 25/10/2019, 17:05:23
 * @Modification Log   :
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    3/8/2019, 17:25:39   Andrea Vanelli     Initial Version
 **/
public class PV2564AzzeramentoSpeseGestione extends PVActionGestione {

	public class PV2564AzzeramentoSpeseGestioneForm extends PVForm {
		@AuraEnabled public List<OCSRecuperaSpeseAzzeraRecInvoker.SpesaRecuperoDTO> speseList {get; set;}
		@AuraEnabled public String accettarifiuta {get; set;}
	}


	@AuraEnabled
	public static void saveCase(PV2564AzzeramentoSpeseGestioneForm form, Case theCase){

		// AV TODO i motivi in questo PV dovrebbero popolarsi sia con che senza selezione sottotipologia
		// al momento si popolano solo se non scegli la sottotipologia

		String messaggio_errore = '';
		String note_video = '';
		String note_case ='';
		String lista_spese ='';
		Double totale = 0;

		try{
			System.debug('PV2564AzzeramentoSpeseGestioneForm: ' + form);
			if(form.newStatus.equalsIgnoreCase(CaseUtils.CHIUSO)) {

/*in base allo step
   1==rifiutata ora in rilavorazione filiale/ufficio
   2== in gestione recupero*/
				if(theCase.Step_PV__c.equals('2') ) {

					// AV TODO controllo la selezione
					// AV TODO spesa ancora selezionbile? vedi logica aplicata in selezione lista
					if(form.accettarifiuta.equals('rifiuta') ) {
						// salvo con step 3
						theCase.Step_PV__c = '3';
						note_case = 'La richiesta di azzeramento spese non è stata accettata.\n';

					} else {
						if (form.speseList.size() == 0 ) {
							// errore
							messaggio_errore = 'Nessuna spesa selezionata';
						} else {


							// chiamo ocs
							//B2BSOAP_eseguiAzioneRecupero
							/*se ufficio
							                note = ufficio;
							   se agency user
							                note = 'rdf';
							   else
							                note = 'da altro ufficio'
							 */
							//form.userData.accountOffice.Name
							Double pretotale = 0;
							for (OCSRecuperaSpeseAzzeraRecInvoker.SpesaRecuperoDTO spesaOrigine : form.speseList) {
								System.debug('spesaorig saldo : '+spesaOrigine.saldo);
								pretotale += spesaOrigine.saldo;
							}
							note_video += form.userData.user.UserRole.Name + ' - ' + form.userData.user.LastName + ': Azzeramento spese EUR ' + pretotale; //EUR 10,00\n';        //+ totaleazzerato;

							OCSEseguiAzioneRecuperoInvoker.EseguiAzioneRecuperoRequestDTO reqDTO = new OCSEseguiAzioneRecuperoInvoker.EseguiAzioneRecuperoRequestDTO();
							reqDTO.azione = 'PDT';         // psv_loan_action_code
							reqDTO.classificazione = '';        // verificare // psv_loan_action_clasf
							reqDTO.dataScadenza = '';         // psv_loan_action_fixed_dt
							reqDTO.esito = '565';         // psv_loan_action_result
							reqDTO.note = note_video;         // vedi sopra// psv_loan_action_notes
							reqDTO.numPratica = form.pratica.numPratica;
							reqDTO.operatore = '';         // psv_loan_action_user
							reqDTO.oraScadenza = '';         // psv_loan_action_fixed_tm
							reqDTO.recuperatore = '';         // psv_loan_action_collector
							reqDTO.tipoPratica = form.pratica.tipoPratica;
							reqDTO.tipoScadenza = 'RV';         // psv_loan_action_fixed_ty
							//Invoke
							System.debug('OCSEseguiAzioneRecuperoInvoker Req: ' + reqDTO);
							OCSEseguiAzioneRecuperoInvoker.Response res = OCSEseguiAzioneRecuperoInvoker.invoke(reqDto);


							System.debug('OCSEseguiAzioneRecuperoInvoker Res: ' + res);

							if (!res.isOK()) {
								messaggio_errore = res.getMessage() + res.resultMessage;
							} else {
								// controllo errori
								String esitoEsec = res.eseguiAzioneRecuperoResponse.esito;
								String descErrore = res.eseguiAzioneRecuperoResponse.desErrore;
								if (esitoEsec.equals('OK')) {
									note_video += 'Azione inserita con data odierna\n';
								} else {
									note_video += 'Inserimento dell\'azione di recupero fallito: ' + descErrore;
									if (descErrore.equals('6599 Pratica non a recupero')) {
										esitoEsec = 'OK';
										note_video += ' (questo errore non è bloccante)';
									}
									note_video += '\n';
								}

								if (esitoEsec != 'OK') {
									messaggio_errore = note_video;
								} else {

									//se tutto ok
									OCSAnnullaSpeseRecuperoInvoker.SpesaRecuperoDaAnnullareDTO[] spese       = new  List<OCSAnnullaSpeseRecuperoInvoker.SpesaRecuperoDaAnnullareDTO>();

									for (OCSRecuperaSpeseAzzeraRecInvoker.SpesaRecuperoDTO spesaOrigine : form.speseList) {

										OCSAnnullaSpeseRecuperoInvoker.SpesaRecuperoDaAnnullareDTO spe   = new OCSAnnullaSpeseRecuperoInvoker.SpesaRecuperoDaAnnullareDTO();

										// preparo BSOAP_annullaSpeseRecupero
										// AV TODO prepara elenco di SpesaRecuperoDaAnnullareDTO
										System.debug('spesaorig custom id : '+spesaOrigine.customID);
										spe.progressivo = spesaOrigine.customID.substring(15,24);
										spe.tipoSpesa = spesaOrigine.customID.substring(14,15);

										spese.add(spe);
									}

									// AV TODO eseguo chiamata BSOAP_annullaSpeseRecupero

									//AnnullaSpeseRecuperoRes response = (AnnullaSpeseRecuperoRes) gResponse;
									OCSAnnullaSpeseRecuperoInvoker.Request req = new OCSAnnullaSpeseRecuperoInvoker.Request();
									req.annullaSpeseRecuperoRequest.tipoPratica = form.pratica.tipoPratica;
									req.annullaSpeseRecuperoRequest.numPratica = form.pratica.numPratica;
									req.annullaSpeseRecuperoRequest.elencoSpeseDaAnnullare = spese;

									System.debug('OCSAnnullaSpeseRecuperoInvoker Req: ' + req);
									OCSAnnullaSpeseRecuperoInvoker.Response resAnnulla = OCSAnnullaSpeseRecuperoInvoker.invoke(req.annullaSpeseRecuperoRequest);
									System.debug('OCSAnnullaSpeseRecuperoInvoker Res: ' + resAnnulla);

									if (!resAnnulla.isOK()) {
										messaggio_errore = resAnnulla.getMessage() + resAnnulla.resultMessage;
									} else {
										//String erroriAnnulla = gestioneErroriAnnullaSpeseRecupero(resAnnulla.annullaSpeseRecuperoResponse.elencoErrori, form.speseList);


										String erroriAnnulla = '';
										Integer i = -1;

										for (OCSRecuperaSpeseAzzeraRecInvoker.SpesaRecuperoDTO spesaOrigine : form.speseList) {
											i++;
											String errore = resAnnulla.annullaSpeseRecuperoResponse.elencoErrori.get(i);
											if (errore!=null && errore.trim().length()>0) {

												String text = '';
												switch on Integer.valueOf(errore) {
													when 0 {                        // when block 1
														text = '000 - Azzerata con successo';
													}
													when 1 {                        // when block 2
														text = '001 - Spesa non trovata';
													}
													when 2 {                        // when block 3
														text = '002 - Nessun residuo da annullare';
													}
													when else {                       // default block, optional
														text = errore+'!';
													}
												}

												erroriAnnulla+=text+' ('+spesaOrigine.descrizioneSpesa+')';
											} else {
												// azzeramento riuscito: se è Aggiunto lo segno come aZzerato
												spesaOrigine.selezioneOriginale = 'Z';
											}
										}


										if (erroriAnnulla.equals('')) {
											// OK
											note_video += 'Annullamento effettuato correttamente.\n';
										} else {
											// non ok
											note_video += 'Annullamento effettuato con errori: ' + erroriAnnulla + '\n';
											//messaggio_errore = erroriAnnulla;
											// se blocco l'inserimento dovrei anche ricaricare la lista perche alcuni potrebbero essere entrati
										}
										// metto comunque il risultato nelle note feed
										//salvo le spese azzerate (Z) nel custo object

										// a questo punto creo le note mettendo le spese a Z che sono OK
										//+ gli errori
										note_case = 'La richiesta di azzeramento spese è stata accettata e l’operazione è stata eseguita.';
										note_case += 'Spese azzerate:\n';
										for (OCSRecuperaSpeseAzzeraRecInvoker.SpesaRecuperoDTO spesaOrigine : form.speseList) {
											//note_case += spesaOrigine.descrizioneSpesa + '\n';
											System.debug('Spesa : ' + spesaorigine);
											if (spesaOrigine.selezioneOriginale.equals('Z')) {
												lista_spese += ' - ' + spesaOrigine.descrizioneSpesa + '\n';
												totale += spesaOrigine.saldo;
											}
										}
										note_case += lista_spese;
										note_case += 'Valore totale: ' + totale + ' EUR\n';

										if (!erroriAnnulla.equals('')) {
											note_case += 'Errori:\n' + erroriAnnulla;
										}
										//messaggio_errore = note_case;
										// test per recuperatore da rimuovere!
										//form.pratica.codRecuperatore = 'FID94';
										if (form.pratica.codRecuperatore != null && !form.pratica.codRecuperatore.equals('')) {
											// AV TODO verificare serce pratica a recupero per capire se il codice di ocs va bene su Rnt_Code__c
											Collectors__c collector = [SELECT Email__c FROM Collectors__c WHERE Rnt_Code__c =:form.pratica.codRecuperatore][0];
											if (collector != null && collector.Email__c != '') {
												String subject = 'Segnalazione per avvenuto azzeramento spese di recupero pratica ' +form.pratica.tipoPratica + ' - ' + form.pratica.numPratica;
												String body = '';

												body += 'La presente richiesta di Azzeramento Spese è stata verificata dal Centro di Recupero ';
												body += form.userData.user.UserRole.Name +' di Compass ed è stata quindi accettata ed elaborata.\nDettagli Richiesta:\n';
												body += 'Numero pratica: ' + form.pratica.tipoPratica + ' - ' + form.pratica.numPratica + '\n';
												body += 'Codice cliente: ' + theCase.Account.getCodice_Cliente__c + '\n';
												body += 'Nome cliente: ' + theCase.Account.LastName + ' ' + theCase.Account.FirstName  + '\n';
												body += 'Totale spese azzerate: ' + totale + ' EUR\n';
												body += 'Le spese azzerate interessate dalla richiesta sono le seguenti:\n' + lista_spese;
												body += '\n\nQuesta è una comunicazione automatica, proveniente dalla procedura Gestione Richieste di Post Vendita.\nSi prega di non rispondere direttamente a questo indirizzo.';

												// manda email
												List<Messaging.SingleEmailMessage> emailToSend = new List<Messaging.SingleEmailMessage>();
												Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
												if (SystemUtils.isSandbox()) {
													collector.Email__c = 'andrea.vanelli@compass.it';
												}
												String[] toAddresses = new String[] {collector.Email__c};
												mail.setToAddresses(toAddresses);
												mail.setSubject(subject);
												mail.setPlainTextBody(body );
												emailToSend.add(mail);
												EmailUtils.sendEmail(emailToSend);

											} else {
												note_case += 'Collector ' + form.pratica.codRecuperatore + ' non configurato correttamente su CRM\n';
											}
										}
										//messaggio_errore = note_video;
									}

								}


							}



						}
					}
				} else {
					// rilavorazione fil o uff
					// solo x info e chiusura

				}

			} else if(form.newStatus.equalsIgnoreCase(CaseUtils.SOSPESO)) {
				// non fa nulla
			}

			//OCSCliente cliente = myForm.cliente;

			// modifico il case
			// se voglio forzare lo stato devo modificare form.newStatus
			if (messaggio_errore.equals('')) {
				String notePV = creaNote(form, theCase) + '\n' + note_case;
				saveUtil(form, theCase, notePV);
			}

		}catch(Exception e) {                    messaggio_errore = loggaException(e);          }finally{                       if(messaggio_errore != '') {                                                    gestisciException(messaggio_errore);                    }}


	}
/*
    @AuraEnabled
    public static OCSRecuperaSpeseAzzeraRecInvoker.Response recuperaSpeseAzzeramentoRecupero(String numPratica, String tipoPratica){
        // AV TODO select da tabella selezionate
        // incrocio e complesto con S prima di ritornare
                return OCSRecuperaSpeseAzzeraRecInvoker.invoke(numPratica, tipoPratica);
    }
 */
	/* metodi NON aura enabled */

/*
        private static String gestioneErroriAnnullaSpeseRecupero (List<String> elencoErrori, List<OCSRecuperaSpeseAzzeraRecInvoker.SpesaRecuperoDTO> elencoSpese) {
        }
 */
	private static String creaNote(PVForm myform, Case theCase) {
		return myForm.note;
	}




}