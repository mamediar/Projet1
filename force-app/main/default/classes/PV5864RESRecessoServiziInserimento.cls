/**
 * @File Name          : PV5864RESRecessoServiziInserimento.cls
 * @Description        :
 * @Author             : Andrea Vanelli
 * @Group              :
 * @Last Modified By   : sabrina vitali
 * @Last Modified On   : 20/9/2019, 17:16:39
 * @Modification Log   :
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    10/7/2019, 08:57:47   Andrea Vanelli     Initial Version
 **/

public class PV5864RESRecessoServiziInserimento extends PVAction  {
	public class PV5864RESRecessoServiziForm extends PVForm {
		@AuraEnabled public OCSPratica pratica {get; set;}
		@AuraEnabled public String tipoSinistro {get; set;}
		@AuraEnabled public String dataSinistro {get; set;}
		@AuraEnabled public String dataDefinizione {get; set;}
	}

	@AuraEnabled
	public static void conferma(PV5864RESRecessoServiziForm datiForm){
		new PV5864RESRecessoServiziInserimento().execute(datiForm);


		/*******************************
			// esempio chiamata esterna
		/***********************************************/
/*		
		// prova inserimento PV esterna
		PV5864RESRecessoServiziInserimento.PV5864RESRecessoServiziForm datiForm = new PV5864RESRecessoServiziInserimento.PV5864RESRecessoServiziForm();

		// se si vuole usare l'utente collegato (deve essere correttamente configurato per l'inseimento PV altrimenti verrà ritornata un'eccezione)
		//datiForm = (PV5864RESRecessoServiziInserimento.PV5864RESRecessoServiziForm) PV5864RESRecessoServiziInserimento.prepareFormExternal(datiForm, '5864', null);
		// in alternativa è possibile parrare l'id specifico di un utente (es: simulare l'inserimento da parte di un ufficio specifico)    
		datiForm = (PV5864RESRecessoServiziInserimento.PV5864RESRecessoServiziForm)PV5864RESRecessoServiziInserimento.prepareFormExternal(datiForm, '5864', '0050Q000002NJvfQAG');
		
		// i dati del cliente sono obbligatori sono obbligatori    
		// visto che potenzialmente potrebbe essere creata un'anagrafica sarebbe corretto passare tutti quelli a disposizione
		datiForm.cliente = new OCSCliente();
		datiForm.cliente.email = 'POSTVENDITA@EMAIL.TEST';
		datiForm.cliente.codCliente = '1';
		datiForm.cliente.cognome = 'COGNOME';
		datiForm.cliente.nome = 'NOME';
		datiForm.cliente.denominazioneAzienda = 'NOME COGNOME';
		datiForm.cliente.dataNascita = '20100101';

		// specifici per ogni PV 
		// Pratica solo Testata
		datiform.pratica = new OCSPratica();
		datiform.pratica.tipoPratica = 'CA';
		datiform.pratica.numPratica = '2106662676';

		//dati specifici PV
		datiform.tipoSinistro = 'DC';
		datiform.dataSinistro = '21/03/2019';
		datiform.dataDefinizione = '18/06/2019';


		// esecuzione inserimento
		PV5864RESRecessoServiziInserimento.conferma(datiform);
		//se errore il metodo esegue "throw new AuraHandledException"

*/				
	}



	/* metodi NON aura enabled */


	public void execute(PVForm form){
		String messaggio_errore = '';
		try{
			PV5864RESRecessoServiziForm myForm = (PV5864RESRecessoServiziForm) form;
			commonExecute(myForm);
		}catch(Exception e) {
			messaggio_errore = e.getMessage();
		}finally{
			if(messaggio_errore != '') {
				gestisciException(messaggio_errore);
			}
		}
	}

	public override Case completaCasePostVendita(Case casoPV,PVForm form){
		//continuare a valorizzare l'oggetto casoPV integrando i dati di questo post vendita
		return casoPV;
	}

	public override String recuperaNotaSpecificaPV(PVForm form, Case casoPV){
		//preparazione nota
		PV5864RESRecessoServiziForm myForm = (PV5864RESRecessoServiziForm) form;
		String notaSpecificaPV = '';

		if(String.isNotEmpty(myForm.tipoSinistro)){
			notaSpecificaPV +=  'Tipo Sinistro: ' + myForm.tipoSinistro + '\n';
		}
		if(String.isNotEmpty(myForm.dataSinistro)){
			notaSpecificaPV +=  'Data Sinistro: ' + myForm.dataSinistro + '\n';
		}
		if(String.isNotEmpty(myForm.dataDefinizione)){
			notaSpecificaPV +=  'Data Definizione: ' + myForm.dataDefinizione + '\n';
		}
		return notaSpecificaPV;
	}

	public override XCS_Messaggio__c preparaMessaggioOCS(PVForm form, XCS_Messaggio__c xcs_messaggio){
		//preparazione XCS_Messaggio
		PV5864RESRecessoServiziForm myForm = (PV5864RESRecessoServiziForm) form;
		//xcs_messaggio.CodCliente__c = myForm.cliente.codCliente;
		//xcs_messaggio.NumPratica__c = myForm.pratica.numPratica;
		//xcs_messaggio.TipoPratica__c = myForm.pratica.tipoPratica;
		return xcs_messaggio;
	}



}