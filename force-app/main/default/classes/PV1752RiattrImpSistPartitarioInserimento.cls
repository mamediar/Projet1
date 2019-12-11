/**
 * @File Name          : PV1752RiattrImpSistPartitarioInserimento.cls
 * @Description        : 
 * @Author             : sabrina vitali
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 22/10/2019, 15:36:12
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    26/7/2019, 17:37:33   sabrina vitali     Initial Version
**/
public class PV1752RiattrImpSistPartitarioInserimento  extends PVAction {
	
    public class PV1752RiattrImpSistPartitarioForm extends PVForm {
		@AuraEnabled public String modalitaRimborso{get;set;}
		@AuraEnabled public String noteRimborso{get;set;}
		@AuraEnabled public Date dataIncasso{get;set;}
        @AuraEnabled public Decimal importo{get;set;}
        @AuraEnabled public Boolean hasRimborso{get;set;}
        @AuraEnabled public String rataOrigine{get;set;}
        @AuraEnabled public String rataDestinazione{get;set;}
	}

	@AuraEnabled
	public static void conferma(PV1752RiattrImpSistPartitarioForm datiForm){
		new PV1752RiattrImpSistPartitarioInserimento().execute(datiForm);
	}

	/* metodi NON aura enabled */

	public void execute(PVForm form){
		String messaggio_errore = '';
		try{
			System.debug('### XCS CATEGORIA : '+form.categoriaPV.External_Id__c);
			PV1752RiattrImpSistPartitarioForm myForm = (PV1752RiattrImpSistPartitarioForm) form;
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
        PV1752RiattrImpSistPartitarioForm myForm = (PV1752RiattrImpSistPartitarioForm) form;
        casoPV.Importo_Rimborso__c = myForm.importo;
        casoPV.Has_Rimborso__c = myForm.hasRimborso;

		return casoPV;
	}

	public override String recuperaNotaSpecificaPV(PVForm form, Case casoPV){
		//preparazione nota
		PV1752RiattrImpSistPartitarioForm myForm = (PV1752RiattrImpSistPartitarioForm) form;
		//7 : Note specifiche PV
		String notaSpecificaPV;
		notaSpecificaPV =  'Numero pratica: ' + myForm.pratica.numPratica + '\n';
        System.debug('myForm.dataIncasso ' + myForm.dataIncasso);
        if(!String.isBlank(String.ValueOf(myForm.dataIncasso))){
		    notaSpecificaPV +=  'Data incasso: ' + DateUtils.formatDateDDslashMMslashYYYY(myForm.dataIncasso) + '\n';
        }
        if(myForm.rataOrigine != ''){
            notaSpecificaPV +=  'Numero rata di origine: ' + myForm.rataOrigine + '\n';
        }
        if(myForm.rataDestinazione != ''){
            notaSpecificaPV +=  'Numero rata di destinazione: ' + myForm.rataDestinazione + '\n';
        }    
        notaSpecificaPV +=  'Importo: ' + myForm.importo + '\n';
        if(String.isBlank(myForm.modalitaRimborso)){
            notaSpecificaPV +=  'Richiesta rimborso: ' + 'No'+ '\n';
        }else{
            notaSpecificaPV +=  'Richiesta rimborso: ' + 'Si'+ '\n';
        } 
        if(!String.isBlank(myForm.modalitaRimborso)){
            notaSpecificaPV +=  myForm.noteRimborso + '\n';   
        }
		return notaSpecificaPV;
	}

	public override XCS_Messaggio__c preparaMessaggioOCS(PVForm form, XCS_Messaggio__c xcs_messaggio){
		//preparazione XCS_Messaggio
		PV1752RiattrImpSistPartitarioForm myForm = (PV1752RiattrImpSistPartitarioForm) form;
		xcs_messaggio.NumPratica__c = myForm.pratica.numPratica;
        xcs_messaggio.TipoPratica__c = myForm.pratica.tipoPratica;
		return xcs_messaggio;
	}
}