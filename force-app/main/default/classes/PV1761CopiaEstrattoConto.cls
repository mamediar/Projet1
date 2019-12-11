/**
 * @File Name          : PV1761CopiaEstrattoConto.cls
 * @Description        : 
 * @Author             : Riccardo Donato
 * @Group              : 
 * @Last Modified By   : Riccardo Donato
 * @Last Modified On   : 14/10/2019, 11:05:00
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    14/10/2019, 11:05:00   Riccardo Donato     Initial Version
**/
public class PV1761CopiaEstrattoConto extends PVAction  {

	public class PV1761CopiaEstrattoContoForm extends PVForm {
		@AuraEnabled public OCSPratica pratica {get; set;}
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
	public static void conferma(PV1761CopiaEstrattoContoForm datiForm){
		//new PV2564AzzeramentoSpeseInserimento().execute(datiForm);
	}

	public void execute(PVForm form){
		PV1761CopiaEstrattoContoForm myForm = (PV1761CopiaEstrattoContoForm) form;
		commonExecute(myForm);
	}


	public override Case completaCasePostVendita(Case casoPV,PVForm form){
		//continuare a valorizzare l'oggetto casoPV integrando i dati di questo post vendita
		PV1761CopiaEstrattoContoForm myForm = (PV1761CopiaEstrattoContoForm) form;

		// scelto dall'utente
		if(!myForm.ufficioDestinazione.equalsIgnoreCase('')){
			casoPV.UfficioDestinazione__c = [Select Id from Account where RecordType.Name = 'Uffici e Altro' AND Codice_Ufficio__c =: myForm.ufficioDestinazione][0].id;
		}

		return casoPV;
	}


	public override String recuperaNotaSpecificaPV(PVForm form, Case casoPV){
		//preparazione nota
		PV1761CopiaEstrattoContoForm myForm = (PV1761CopiaEstrattoContoForm) form;

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
		PV1761CopiaEstrattoContoForm myForm = (PV1761CopiaEstrattoContoForm) form;
		xcs_messaggio.NumPratica__c = myForm.pratica.numPratica;
		xcs_messaggio.TipoPratica__c = myForm.pratica.tipoPratica;
		return xcs_messaggio;
	}


	public override void insertTabelleExtra(PVForm pvForm,Case casoPV) {
		PV1761CopiaEstrattoContoForm myForm = (PV1761CopiaEstrattoContoForm) pvForm;
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