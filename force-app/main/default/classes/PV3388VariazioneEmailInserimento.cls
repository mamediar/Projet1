/**
 * @File Name          : PV3388VariazioneEmailInserimento.cls
 * @Description        : 
 * @Author             : Lorenzo Marzocchi
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 6/11/2019, 11:08:56
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    2019-6-18 18:21:10   Lorenzo Marzocchi     Initial Version
**/
public class PV3388VariazioneEmailInserimento extends PVAction {

	public class PV3388VariazioneEmailForm extends PVForm {
		@AuraEnabled
		public String mailNuova {get; set;}
	}



	@AuraEnabled
	public static void conferma(PV3388VariazioneEmailForm datiForm){
		new PV3388VariazioneEmailInserimento().execute(datiForm);
	}

	@AuraEnabled
	public static boolean isAccountPresente(String codCliente) {
		List<Account> accountList = [SELECT Id FROM Account WHERE OCS_External_Id__c = :codCliente];
		return accountList.size()>0;
	}

	@AuraEnabled
	public static boolean isRecuperoCredenzialiPresente(String codCliente) {
		List<Case> caseList = [SELECT Id, ActivityType__c, Categoria_Riferimento__r.External_Id__c
		                       FROM Case
		                       WHERE ActivityType__c = 'CRM_POSTVENDITA'
		                                               AND Categoria_Riferimento__r.External_Id__c = '2785'
		                                                                                             AND Account.OCS_External_Id__c = :codCliente
		                                                                                                                              AND IsClosed != true];
		return caseList.size()>0;
	}




	/* metodi NON aura enabled */



	public void execute(PVForm form){
		String messaggio_errore = '';
		
		try{
			PV3388VariazioneEmailForm myForm = (PV3388VariazioneEmailForm) form;
			OCSCliente cliente = myForm.cliente;

			OCSVariazioneEmailResponse res = OCSVariazioneEmailInvoker.variazioneMail(cliente.codCliente, myForm.mailNuova);
			System.debug('PV3388VariazioneEmailAction - OCSVariazioneEmailResponse res: ' + res);

			if(res.isOK()) {
				//Common di PVAction
				commonExecute(myForm);
			}else{
				messaggio_errore = res.getMessage();
			}
		}catch(Exception e) {
			messaggio_errore = e.getMessage();
			System.debug('TEST EMAIL EXCEPTION ERRORE:' + messaggio_errore);
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
		PV3388VariazioneEmailForm myForm = (PV3388VariazioneEmailForm) form;
		//7 : Note specifiche PV
		String notaSpecificaPV;
		notaSpecificaPV =  'Email precedente: ' + myForm.cliente.email + '\n';
		notaSpecificaPV +=  'Nuova email: ' + myForm.mailNuova + '\n';
		return notaSpecificaPV;
	}

	public override XCS_Messaggio__c preparaMessaggioOCS(PVForm form, XCS_Messaggio__c xcs_messaggio){
		//preparazione XCS_Messaggio
		PV3388VariazioneEmailForm myForm = (PV3388VariazioneEmailForm) form;
		xcs_messaggio.CodCliente__c = myForm.cliente.codCliente;
		return xcs_messaggio;
	}



}