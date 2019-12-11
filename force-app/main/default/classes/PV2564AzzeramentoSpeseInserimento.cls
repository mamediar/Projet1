/**
 * @File Name          : PV2564AzzeramentoSpeseInserimento.cls
 * @Description        : 
 * @Author             : Andrea Vanelli
 * @Group              : 
 * @Last Modified By   : Andrea Vanelli
 * @Last Modified On   : 20/10/2019, 17:06:37
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    31/7/2019, 17:31:25   Andrea Vanelli     Initial Version
**/
public class PV2564AzzeramentoSpeseInserimento extends PVAction  {

	public class PV2564AzzeramentoSpeseInserimentoForm extends PVForm {
		@AuraEnabled public String ufficioDestinazione {get; set;}
		@AuraEnabled public List<OCSRecuperaSpeseAzzeraRecInvoker.SpesaRecuperoDTO> speseList {get; set;}
	}

	/*********************************/
	/* metodi CUSTOM del singolo PV */

    @AuraEnabled
    public static OCSRecuperaSpeseAzzeraRecInvoker.Response recuperaSpeseAzzeramentoRecupero(String numPratica, String tipoPratica){
		return OCSRecuperaSpeseAzzeraRecInvoker.invoke(numPratica, tipoPratica);
    } 


	/*****************************/
	/* metodi STANDARD 			 */

	@AuraEnabled
	public static void conferma(PV2564AzzeramentoSpeseInserimentoForm datiForm){
		new PV2564AzzeramentoSpeseInserimento().execute(datiForm);
	}

	public void execute(PVForm form){
		PV2564AzzeramentoSpeseInserimentoForm myForm = (PV2564AzzeramentoSpeseInserimentoForm) form;
		commonExecute(myForm);
	}


	public override Case completaCasePostVendita(Case casoPV,PVForm form){
		//continuare a valorizzare l'oggetto casoPV integrando i dati di questo post vendita
		PV2564AzzeramentoSpeseInserimentoForm myForm = (PV2564AzzeramentoSpeseInserimentoForm) form;

		// scelto dall'utente
		if(!myForm.ufficioDestinazione.equalsIgnoreCase('')){
			casoPV.UfficioDestinazione__c = [Select Id from Account where RecordType.Name = 'Uffici e Altro' AND Codice_Ufficio__c =: myForm.ufficioDestinazione][0].id;
		}

		return casoPV;
	}


	public override String recuperaNotaSpecificaPV(PVForm form, Case casoPV){
		//preparazione nota
		PV2564AzzeramentoSpeseInserimentoForm myForm = (PV2564AzzeramentoSpeseInserimentoForm) form;

		String notaSpecificaPV;
		notaSpecificaPV =  '';
		notaSpecificaPV +=  'Pratica : ' + myForm.pratica.tipoPratica + ' ' + myform.pratica.numPratica + '\n';
		notaSpecificaPV +=  'Azzeramento richiesto: \n';

        if (myForm.sottotipologiaMdt.uniqueId__c == 18) {
            notaSpecificaPV += 'Totale, segue elenco spese azzerabili selezionate automaticamente:\n';
        }
		// ciclo le spese
		for (OCSRecuperaSpeseAzzeraRecInvoker.SpesaRecuperoDTO s : myform.speseList) {
			notaSpecificaPV += ' - ' + s.descrizioneSpesa + '\n';
		}
		return notaSpecificaPV;
	}


	public override XCS_Messaggio__c preparaMessaggioOCS(PVForm form, XCS_Messaggio__c xcs_messaggio){
		//preparazione XCS_Messaggio
		PV2564AzzeramentoSpeseInserimentoForm myForm = (PV2564AzzeramentoSpeseInserimentoForm) form;
		xcs_messaggio.NumPratica__c = myForm.pratica.numPratica;
		xcs_messaggio.TipoPratica__c = myForm.pratica.tipoPratica;
		return xcs_messaggio;
	}


	public override void insertTabelleExtra(PVForm pvForm,Case casoPV) {
		PV2564AzzeramentoSpeseInserimentoForm myForm = (PV2564AzzeramentoSpeseInserimentoForm) pvForm;
		List<psv_azzer_sel__c> speseToInsert = new List<psv_azzer_sel__c>();
		for (OCSRecuperaSpeseAzzeraRecInvoker.SpesaRecuperoDTO spesaOrigine : myForm.speseList) {
			psv_azzer_sel__c spesaToInsert = new psv_azzer_sel__c();
			spesaToInsert.codice_case__c = casoPV.Id;
			spesaToInsert.sel_id__c = spesaOrigine.customID;
			spesaToInsert.cod_orig_sel__c = 'A'; // verificare i valori
			speseToInsert.add(spesaToInsert);
		}
		insert speseToInsert;
	}


}