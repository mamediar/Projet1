/**
 * @File Name          : PV1772DaCustomerServAFilialeIns.cls
 * @Description        : 
 * @Author             : Federico Negro
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 4/11/2019, 17:41:59
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    28/10/2019   Federico Negro     Initial Version
**/
public class PV1772DaCustomerServAFilialeIns extends PVAction {

    public class PV1772DaCustomerServAFilialeInsForm extends PVForm {
		@AuraEnabled public String codFiliale {get; set;}
	}

	/***************************/
	/*   metodi Aura enabled   */
	/***************************/

	//recupera filiali
    @AuraEnabled
    public static List<Account> recuperaFiliali(){
        List<Account> fil = [SELECT Name, OCS_External_Id__c FROM Account WHERE Type='FIL' ORDER BY Name ASC];
        return fil;
    }
    
	@AuraEnabled
	public static void conferma(PV1772DaCustomerServAFilialeInsForm datiForm){
		new PV1772DaCustomerServAFilialeIns().execute(datiForm);
	}

	/***************************/
	/* metodi NON Aura enabled */
	/***************************/

	public void execute(PVForm form){
		PV1772DaCustomerServAFilialeInsForm myForm = (PV1772DaCustomerServAFilialeInsForm) form;
		commonExecute(myForm);	
	}

	public override Case completaCasePostVendita(Case casoPV,PVForm form){
		//continuare a valorizzare l'oggetto casoPV integrando i dati di questo post vendita
		PV1772DaCustomerServAFilialeInsForm myForm = (PV1772DaCustomerServAFilialeInsForm) form;
			
			if(!String.isBlank(myForm.codFiliale)){
				Account ufficio = [Select Id, Name, Type from Account where OCS_External_Id__c =: myForm.codFiliale][0];
				casoPV.UfficioDestinazione__c = ufficio.id;
			}else{
				casoPV.Step_PV__c = '3';
			}
			
			
			//myForm.codFiliale.substring(0,1) = 'F'
			//casoPV.UfficioDestinazione__c = [Select Id from Account where RSS_External_Id__c =: myForm.codUfficio][0].id;
			//System.debug('*** invio a numero blu '+ casoPV.UfficioDestinazione__c);
			
		return casoPV;
	}

	public override String recuperaNotaSpecificaPV(PVForm form, Case casoPV){
		//preparazione nota
		PV1772DaCustomerServAFilialeInsForm myForm = (PV1772DaCustomerServAFilialeInsForm) form;

		String notaSpecificaPV;
		String nome_filiale = '';
		notaSpecificaPV =  '';
		notaSpecificaPV +=  'Pratica : ' + myForm.pratica.tipoPratica + ' ' + myform.pratica.numPratica + '\n';

		if(!String.isBlank(myForm.codFiliale)){
			nome_filiale = [Select Name from Account where Type='FIL' AND OCS_External_Id__c =: myForm.codFiliale][0].Name;
			notaSpecificaPV +=  'Filiale destinataria : ' + nome_filiale + '\n';
		}

		return notaSpecificaPV;
	}

	public override XCS_Messaggio__c preparaMessaggioOCS(PVForm form, XCS_Messaggio__c xcs_messaggio){
		//preparazione XCS_Messaggio
		PV1772DaCustomerServAFilialeInsForm myForm = (PV1772DaCustomerServAFilialeInsForm) form;
		xcs_messaggio.NumPratica__c = myForm.pratica.numPratica;
		xcs_messaggio.TipoPratica__c = myForm.pratica.tipoPratica;
		return xcs_messaggio;
	}

}