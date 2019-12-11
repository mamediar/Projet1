/**
 * @File Name          : VerificaFidoUtilClass.cls
 * @Description        :
 * @Author             : Lorenzo Marzocchi
 * @Group              :
 * @Last Modified By   : Lorenzo Marzocchi
 * @Last Modified On   : 2019-8-26 17:10:15
 * @Modification Log   :
 *==============================================================================
 * Ver         Date                     Author                        Modification
 *==============================================================================
 * 1.0    2019-6-27 12:42:10   Lorenzo Marzocchi     Initial Version
 **/
public class VerificaFidoUtilClass {

	@AuraEnabled
	public static CheckFidoWrapper VerifyAumentoFido(OCSSchedaClienteResponse.PSVDatiPraticaDTO pratica){
		System.debug(pratica);
		OCSCartaDatiFinanziariResponse praticaDetails= getcartaDatiFinanziari(pratica.numPratica);
		Double disponibilita= praticaDetails.datiCartaDatiFinanziariResponse.dispTotale;
	
		CheckFidoWrapper result= new CheckFidoWrapper(  disponibilita,
		                                                '',
		                                                'Aumento fido OK',
		                                                'Success');

		if( !preliminaryCheckAumentoFido(praticaDetails, result) ||
		    !checkAssenzaBlocchi(praticaDetails, result) ||
		    !getCheckMaxFido(praticaDetails, result) ||
		    !getDelinquency(pratica.codCliente, result) ||
		    !getScaduto(pratica.codCliente, result) ||
		    !getCRIF(pratica.codCliente, result)
		    ) {
			result.messaggioErrore='Aumento fido non disponibile per carta '+ pratica.numPratica + ' '+ result.messaggioErrore;
		}
		else{
			result.messaggioErrore='Aumento fido disponibile per carta '+ pratica.numPratica+' proporre AF ed anche erogazione contante, se carta con disponibilità sufficiente';
		}
		return result;
	}

	// metodo per il PV che effettua tutte le verifiche e concatena i messaggi di errore
	@AuraEnabled
	public static CheckFidoWrapper VerifyAumentoFidoPV(OCSSchedaClienteResponse.PSVDatiPraticaDTO pratica){
		System.debug(pratica);
		OCSCartaDatiFinanziariResponse praticaDetails= getcartaDatiFinanziari(pratica.numPratica);
		Double disponibilita= praticaDetails.datiCartaDatiFinanziariResponse.dispTotale;
		
		CheckFidoWrapper result= new CheckFidoWrapper(  disponibilita,
		                                                '',
		                                                'Aumento fido OK',
		                                                'Success');

		preliminaryCheckAumentoFido(praticaDetails, result);
		checkAssenzaBlocchi(praticaDetails, result);
		getCheckMaxFido(praticaDetails, result);
		getDelinquency(pratica.codCliente, result);
		getScaduto(pratica.codCliente, result);
		if (!SystemUtils.isSandbox()) {getCRIF(pratica.codCliente, result);}

		if (result.toastType == 'Error')
		{
			result.messaggioErrore='Aumento fido non disponibile per carta '+ pratica.numPratica + ' '+ result.messaggioErrore;
		}

		return result;
	}




	public static boolean preliminaryCheckAumentoFido(OCSCartaDatiFinanziariResponse praticaDetails, CheckFidoWrapper result){
		List<Fido_Risk__c> fidoRiskList = [SELECT OCS_Code__c,Outcome__c,Reason__c FROM Fido_Risk__c WHERE OCS_Code__c =: praticaDetails.datiCartaDatiFinanziariResponse.numeroPratica];
		if(fidoRiskList.isEmpty() ) {
			result.toastType='Error';
			result.messaggioErrore += 'Codice pratica non presente nella lista fornita dall\'Ufficio Sviluppo Modelli di Scoring. \n';
			result.messaggioErroreShort= 'Fido KO Rischio';
			return false;
		}
		if(!fidoRiskList.isEmpty() && fidoRiskList.size() == 1 && 'KO'.equalsIgnoreCase(fidoRiskList[0].Outcome__c)) {
			result.toastType='Error';
			result.messaggioErrore+= fidoRiskList[0].Reason__c +'\n';
			result.messaggioErroreShort= fidoRiskList[0].Reason__c;
			return false;
		}
		// se FX passo l'informazione al PV
		result.FXRequired=fidoRiskList[0].Outcome__c;
		return true;
	}

	public static boolean getCheckMaxFido(OCSCartaDatiFinanziariResponse praticaDetails, CheckFidoWrapper result){

		Integer emitterNumber= Integer.valueOf(praticaDetails.datiCartaDatiFinanziariResponse.emettitore);
		List<PSV_Limite_Credito__mdt > emettitoreFidoTable= [SELECT Emettitore__c, Filtro_prodotto_fax__c,Prodotto__c, Rata_minima__c, Step_di_aumento__c, tipologia__c FROM PSV_Limite_Credito__mdt WHERE Emettitore__c=: emitterNumber];

		String Steps;
		if(!emettitoreFidoTable.isEmpty()) {
			Steps= emettitoreFidoTable[0].Step_di_aumento__c;
		}


		//String Steps='1200/1600/2000/2600/3000/3500/4000/5000'; //MOCK

		if(String.isBlank(Steps)) {
			result.toastType='Error';
			result.messaggioErrore+='Emettitore non abilitato. \n';
			result.messaggioErroreShort='Fido KO Emettitore non abilitato';
			return false;
		}

		if('0'.equals(Steps)) {
			result.toastType='Error';
			result.messaggioErrore+='Aumento fido non previsto per questo emettitore. \n';
			result.messaggioErroreShort='Fido KO Emettitore non abilitato';
			return false;
		}

		String[] stepList=Steps.split('/');

		Double currFido=Double.valueOf(praticaDetails.datiCartaDatiFinanziariResponse.fidoTotale);
		boolean isLess=false;
		for(integer index=0; index<stepList.size() && !isLess; index++) {
			Double actualStep= Double.valueOf(stepList[index]);
			if(currFido+400<=actualStep) {
				isLess=true;
				result.actualStep = String.valueOf(actualStep);
				return true;
			}
		}
		if(!isLess) {
			result.toastType='Error';
			result.messaggioErrore+='La carta ha già raggiunto il limite massimo di fido. \n';
			result.messaggioErroreShort='Fido KO Fido al massimo';
			return false;
		}
		return true;

	}

	public static boolean getScaduto(String codCliente, CheckFidoWrapper result){
		OCSRecuperaSaldoClienteResponse saldoCliente= OCSRecuperaSaldoClienteInvoker.callGetSaldoCliente(codCliente);
		Double scadutoTotal=0;
		for(OCSRecuperaSaldoClienteResponse.PraticheClass pratica:saldocliente.recuperaSaldoClienteResponse.elencoPratiche) {
			if(!String.isBlank(pratica.scaduto) && pratica.scaduto!='0') {
				scadutoTotal=scadutoTotal+double.valueOf(pratica.scaduto);
			}
		}
		if(scadutoTotal>5) {
			System.debug('scadutoTotal= ******************************** '+scadutoTotal);
			result.toastType='Error';
			result.messaggioErrore+='Lo scaduto pratica non è massimo 5 euro su tutte le posizioni. \n';
			result.messaggioErroreShort='Fido KO Pratiche scadute presenti';
			return false;
		}
		return true;
	}

	public static boolean getDelinquency(String codCliente, CheckFidoWrapper result){

		System.debug('delinquency: '+OCSRecuperaDelinquencyInvoker.callGetDelinquency(codCliente));
		String maxDelinquency=OCSRecuperaDelinquencyInvoker.callGetDelinquency(codCliente).recuperaDelinquencyResponse.maxDelinquencyCliente;
		if(maxDelinquency!='1'&&maxDelinquency!='0') {
			result.toastType='Error';
			result.messaggioErrore+='Controllo Delinquecy non superato. \n';
			result.messaggioErroreShort='Fido KO Delinquency presenti';
			return false;
		}
		return true;
	}

	public static boolean getCRIF(String codCliente, CheckFidoWrapper result){

		OCSRecuperaFasciaTassoCrifResponse.recuperaFasciaTassoCrifResponse response = OCSRecuperaFasciaTassoCrifInvoker.callGetFasciaTassoCrif(codCliente).recuperaFasciaTassoCrifResponse;
		String CRIFMark= response.codFasciaTasso;
		String CRIFStatus= response.as400Status;
		List<String> goodMarks=new List<String> {'A','B','C','D','E','F'};
		if(goodMarks.contains(CRIFMark) || CRIFStatus == 'KO' ) {
			result.toastType='Error';
			result.messaggioErrore+='Controllo CRIF non superato. \n';
			result.messaggioErroreShort='Fido KO Fascia CRIF insoddisfacente';
			return false;
		}
		return true;

	}

	public static boolean checkAssenzaBlocchi(OCSCartaDatiFinanziariResponse praticaDetails, CheckFidoWrapper result){
		if((String.isBlank(praticaDetails.datiCartaDatiFinanziariResponse.blocco)) || (praticaDetails.datiCartaDatiFinanziariResponse.blocco == 'XX' && praticaDetails.datiCartaDatiFinanziariResponse.stato == '50') || (praticaDetails.datiCartaDatiFinanziariResponse.stato == '60' && (praticaDetails.datiCartaDatiFinanziariResponse.blocco == 'XX' || praticaDetails.datiCartaDatiFinanziariResponse.blocco == 'H' || praticaDetails.datiCartaDatiFinanziariResponse.blocco == 'PE'))) {
			return true;
		}
		result.toastType='Error';
		result.messaggioErrore+='Carta non attiva o con blocchi diversi da H, PE o XX. \n';
		result.messaggioErroreShort='Fido KO Blocchi presenti';
		return false;
	}

	public static OCSCartaDatiFinanziariResponse getcartaDatiFinanziari(String numPratica){
		return OCSCartaDatiFinanziariInvoker.cartaDatiFinanziari(numPratica);
	}


	public class CheckFidoWrapper {
		@AuraEnabled
		public Double disponibilita;
		@AuraEnabled
		public String messaggioErrore;
		@AuraEnabled
		public String messaggioErroreShort;
		@AuraEnabled
		public String toastType;
		@AuraEnabled
		public String actualStep;
		@AuraEnabled
		public String FXRequired;

		public CheckFidoWrapper(Double disponibilita,
		                        String messaggioErrore,
		                        String messaggioErroreShort,
		                        String toastType){
			this.disponibilita = disponibilita;
			this.messaggioErrore = messaggioErrore;
			this.messaggioErroreShort= messaggioErroreShort;
			this.toastType = toastType;
		}
	}
}