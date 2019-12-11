/**
 * @File Name          : PV1766CancellazionePraticaInserimento.cls
 * @Description        : 
 * @Author             : sabrina vitali
 * @Group              : 
 * @Last Modified By   : sabrina vitali
 * @Last Modified On   : 24/10/2019, 12:12:52
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    26/7/2019, 17:38:48   sabrina vitali     Initial Version
**/
public class PV1766CancellazionePraticaInserimento extends PVAction {

	public class PV1766CancellazionePraticaForm extends PVForm {
		//da componente
		@AuraEnabled public List<Pratica> praticheList {get; set;}
		@AuraEnabled public List<OCSCliente> clientiList {get; set;}
		//necessari all'elaborazione dei Case
		@AuraEnabled public Pratica praticaCurrent {get; set;}
		@AuraEnabled Boolean gotoDCRAV {get; set;}
		//se richiesta già in corso, inserisco il Case da Annullare per tenerne traccia, poi eventualmente bloccarne del tutto l'inserimento
		@AuraEnabled Boolean annulla {get; set;}
	}

	public class Pratica {
		@AuraEnabled  public String questionario {get; set;}
		@AuraEnabled  public String domandaQuestionario {get; set;}
		@AuraEnabled  public String descrizioneMotivo {get; set;}
		@AuraEnabled  public String cartaCongiunta {get; set;}
		// come lo passo nella lista???
		@AuraEnabled  public PostvenditaConfig_reason__mdt reasonMdt{get;set;}

		@AuraEnabled  public String cognome {get; set;}
		@AuraEnabled  public String nome {get; set;}

		@AuraEnabled public String numPratica {get; set;}
		@AuraEnabled public String codCliente {get; set;}
		@AuraEnabled public String statoPratica {get; set;}
		@AuraEnabled public String tipoPagamento {get; set;}
		@AuraEnabled public String prodotto {get; set;}
		@AuraEnabled public String filiale {get; set;}
		@AuraEnabled public String dataEstinzione {get; set;}
		@AuraEnabled public String tipoPratica {get; set;}
		//////
		@AuraEnabled public String dealerCode{get;set;}
		@AuraEnabled public String convenzionato {get; set;}
		@AuraEnabled public String puntoVendita {get; set;}
		@AuraEnabled public String agente {get; set;}
		@AuraEnabled public String subAgente {get; set;}

		@AuraEnabled public String canale {get; set;}
	}

	public class RecuperaDatiPVFiltro extends PVRecuperaDatiPVFiltroInterface {
		// AV TODO override per la ricerca pratica
		public override OCSPratica filtroPratica(OCSPratica pratica, Map<String,String> filtroParametriMap){
			if (filtroParametriMap != null 
				&& ((filtroParametriMap.get('filiale') != null && pratica.filiale.equalsIgnoreCase(filtroParametriMap.get('filiale')))
				|| filtroParametriMap.get('ufficio') != null)) {
				return pratica;
			}
			return null;
		}

		public override List<OCSPratica> elaboraPratiche(List<OCSPratica> listaPratiche,Map<String,String> filtroParametriMap) {

			//abbino le pratiche di sestinazione alla pratica di origine
			String praticaOrigine = '';
			for(Integer i=0;i<listaPratiche.size();i++){
				OCSPratica pratica = listaPratiche[i];

				//quando trovo una CAcc, la riga precedente contiene sempre la pratica di origine
				if(String.isNotBlank(pratica.tipoPratica) && pratica.tipoPratica.equalsIgnoreCase('CAcc')){
					pratica.numPraticaOrigine = praticaOrigine;
				}
				//le CAcp e le BEcp  sono carte e borsellini agganciati al CPAY ricercato. Devono essere non seleizonabili da soli e devono essere cancellati insieme al CP (sarà creato un incident per ogni prodotto)
				else if(String.isNotBlank(pratica.tipoPratica) && (pratica.tipoPratica.equalsIgnoreCase('CAcp') || pratica.tipoPratica.equalsIgnoreCase('BEcp'))){
					pratica.numPraticaOrigine = pratica.dataEstinzione;
				}
				else{
					praticaOrigine = pratica.numPratica;
					//non sono all'ultimo elemento ed il successivo è una carta congiunta
					if(i<listaPratiche.size()-1 && String.isNotBlank(listaPratiche[i+1].tipoPratica) && listaPratiche[i+1].tipoPratica.equalsIgnoreCase('CAcc')){
						pratica.numPraticaDestinazione = listaPratiche[i+1].numPratica;	
					}
				}
				System.debug('####pratica : ' + pratica.tipoPratica);
				System.debug('####pratica : ' + pratica.numPraticaOrigine);
			}
			return listaPratiche;
		}
	}

	@AuraEnabled
	public static void conferma(PV1766CancellazionePraticaForm datiForm){
		new PV1766CancellazionePraticaInserimento().execute(datiForm);
	}

	/* metodi NON aura enabled */

	public void execute(PVForm form){
		String messaggio_errore = '';
		Pratica pratica;
		OCSCliente cliente;
		try{
			PV1766CancellazionePraticaForm myForm = (PV1766CancellazionePraticaForm) form;
			//verifico, pratica per pratica, se esiste già una richiesta in coda, altrimenti inserisco la richiesta
			String messaggioFinale = '';
			for (Integer i = 0; i < myForm.praticheList.size(); i++) {
				pratica = (Pratica) myForm.praticheList[i];
				myForm.annulla = false; 
				if([SELECT Id, ActivityType__c, Categoria_Riferimento__r.External_Id__c FROM Case
		            WHERE ActivityType__c = 'CRM_POSTVENDITA' AND Categoria_Riferimento__r.External_Id__c = '1766'
		            AND NumeroPratica__c =: pratica.numPratica AND IsClosed != true].size() > 0)
				{
					//inserisco comunque il case come annullato
					messaggioFinale += 'Cancellazione della pratica già richiesta :' + pratica.numPratica + ' , la cui gestione è in corso.\n';		
					myForm.annulla = true;
				}
				for (Integer c = 0; c < myForm.clientiList.size(); c++) {
					cliente = (OCSCliente) myForm.clientiList[c];
					if(pratica.codCliente.equals(myForm.clientiList[c].codCliente)) {	
						//ho trovato il cliente della pratica, lo imposto
						myForm.cliente = cliente;
						//dati pratica che mi servono per elaborazione
						myForm.praticaCurrent = pratica;
						//imposto il motivo selezionato per questa pratica
						myForm.motivazione = pratica.descrizioneMotivo;
						myForm.reasonMdt = pratica.reasonMdt;
						//valorizzo oggetto OCSPratica per elaborazione PVAction
						myForm.pratica = new OCSPratica();
						myForm.pratica.numPratica = pratica.numPratica;
						myForm.pratica.tipoPratica = pratica.tipoPratica;
						myForm.pratica.statoPratica = pratica.statoPratica;
						myForm.pratica.convenzionato = pratica.convenzionato;

						myForm.gotoDCRAV = false;
						//myForm.inserisciRegistro = false;
						if(myForm.reasonMdt.uniqueId__c == 5){
							//la reason prevede gestione di Acquisizione
							myForm.gotoDCRAV = true;
						}
						else if(myForm.userData.user.Branch_Or_Office__c.equalsIgnoreCase('FIL') && String.isNotBlank(myForm.praticaCurrent.dealerCode) && String.isNotBlank(myForm.praticaCurrent.canale) 
									&& (myForm.praticaCurrent.canale.equalsIgnoreCase('WH3') || myForm.praticaCurrent.canale.equalsIgnoreCase('EW3'))){
							OCSCheckDealerWFInvoker.Response res = OCSCheckDealerWFInvoker.invoke(myForm.praticaCurrent.puntoVendita,myForm.praticaCurrent.convenzionato,myForm.praticaCurrent.subAgente,myForm.praticaCurrent.agente);
							if(res.flagEsiste.equalsIgnoreCase('S')) {
								//prevista gestione di Acquisizione
								myForm.gotoDCRAV = true;
							}
						}							
						commonExecute(myForm);
					}
				}
			}
			//System.debug('[[[[[[[[[[[[[[[[[[[[[[[[[[[ messaggioFinale : ' + messaggioFinale);
		}catch(Exception e) {
			messaggio_errore = e.getMessage();
		}finally{
			if(messaggio_errore != '') {
				//throw new AuraHandledException in PVAction
				gestisciException(messaggio_errore);
			}
		}
	}

	public override Case completaCasePostVendita(Case casoPV,PVForm form){
		//continuare a valorizzare l'oggetto casoPV integrando i dati di questo post vendita
		PV1766CancellazionePraticaForm myForm = (PV1766CancellazionePraticaForm) form;
		casoPV.Disposition__c = XCS_DispositionUtils.findDispositionByExternalID('DP'+String.valueOf(myForm.reasonMdt.dispositionId__c)).Id;

		if(myForm.annulla == true){
			casoPV.Step_PV__c = '999';
		}
		else if(myForm.gotoDCRAV==true){
			//salvo il dato in un campo per le prossime regole (se è stata coinvolta AVC, in alcuni casi dovrà tornare ad AVC)
			casoPV.pv_cuas__c = 'DCRAV';
		}
		//le regole smisteranno su BACK se ha inserito Reclami 
		//o andrà in sospeso all'ufficio di riferimento (FIL) in attesa di annullamento o scrittura in registro OCS per cancellazione

		return casoPV;
	}

	public override void insertTabelleExtra(PVForm pvForm,Case casoPV) {
	}

	public override String recuperaNotaSpecificaPV(PVForm form, Case casoPV){
		//preparazione nota specifica PV
		PV1766CancellazionePraticaForm myForm = (PV1766CancellazionePraticaForm) form;
		//7 : Note specifiche PV
		String notaSpecificaPV;
		
		if(myForm.annulla == true){
			return 'Cancellazione della pratica già richiesta :' + myForm.praticaCurrent.numPratica + ' , la cui gestione è in corso.\n';		
		}
		notaSpecificaPV = 'Numero pratica: ' + myForm.pratica.tipoPratica + ' - ' + myForm.pratica.numPratica + '\n';
		notaSpecificaPV += myForm.reasonMdt.Descrizione__c;
		if(String.isNotBlank(myForm.praticaCurrent.questionario)){
			notaSpecificaPV += ' ' + myForm.praticaCurrent.domandaQuestionario + ' - ' + myForm.praticaCurrent.questionario;
		}
		notaSpecificaPV += '\n';
		//CARTA CONGIUNTA!!!
		if(String.isNotBlank(myForm.praticaCurrent.convenzionato)) {
			notaSpecificaPV += 'Dealer: ' + myForm.praticaCurrent.convenzionato + '\n';
		}
		notaSpecificaPV += 'Canale Pratica: ' + myForm.praticaCurrent.canale + '\n';
		return notaSpecificaPV;
	}

	public override XCS_Messaggio__c preparaMessaggioOCS(PVForm form, XCS_Messaggio__c xcs_messaggio){
		//preparazione XCS_Messaggio
		PV1766CancellazionePraticaForm myForm = (PV1766CancellazionePraticaForm) form;
		if(myForm.annulla != true){
			//xcs_messaggio.CodCliente__c = myForm.cliente.codCliente;
			xcs_messaggio.NumPratica__c = myForm.praticaCurrent.numPratica;
			xcs_messaggio.TipoPratica__c = myForm.praticaCurrent.tipoPratica;
		}
		return xcs_messaggio;
	}
}