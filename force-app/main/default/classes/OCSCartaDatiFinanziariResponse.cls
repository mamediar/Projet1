/**
 * @File Name          : OCSCartaDatiFinanziariResponse.cls
 * @Description        :
 * @Author             : Lorenzo Marzocchi
 * @Group              :
 * @Last Modified By   : Lorenzo Marzocchi
 * @Last Modified On   : 2019-8-26 11:07:22
 * @Modification Log   :
 *==============================================================================
 * Ver         Date                     Author                        Modification
 *==============================================================================
 * 1.0    2019-6-27 11:58:36   Lorenzo Marzocchi     Initial Version
 **/
public class OCSCartaDatiFinanziariResponse extends OCSResponse {
	@auraEnabled
	public DatiCartaDatiFinanziariResponseDTO datiCartaDatiFinanziariResponse {get; set;}

	public OCSCartaDatiFinanziariResponse() {
		datiCartaDatiFinanziariResponse = new DatiCartaDatiFinanziariResponseDTO();
	}

	public class DatiCartaDatiFinanziariResponseDTO {
		@AuraEnabled public String numeroPratica {get; set;}
		public String filiale {get; set;}
		@AuraEnabled public String emettitore {get; set;}
		@AuraEnabled public Double pagamentoMinimo {get; set {pagamentoMinimo = OCSResponse.setNumber(value);}}
		@AuraEnabled public String pagamentoMinimoPerc {get; set;}
		public String commissioneEntrata {get; set;}
		@AuraEnabled public String modCalcoloRata {get; set;}
		public String intestazione1 {get; set;}
		public String intestazione2 {get; set;}
		@AuraEnabled public String dataValidita {get; set;}
		@AuraEnabled public String dataScadenza {get; set;}
		@AuraEnabled public String dataValiditaSlashed {get {
									String res = '';
									if(!String.isBlank(dataValidita) && !'0'.equalsIgnoreCase(dataValidita)) {
										res += dataValidita.subString(0, 4) + '/';
										res += dataValidita.subString(4, 6) + '/';
										res += dataValidita.subString(6);
									}
									return res;
								} set;}
		@AuraEnabled public String dataScadenzaSlashed {get {
									String res = '';
									if(!String.isBlank(dataScadenza) && !'0'.equalsIgnoreCase(dataScadenza)) {
										res += dataScadenza.subString(4, 6) + '/';
										res += dataScadenza.subString(0, 4);
									}
									return res;
								} set;}
		@AuraEnabled public String dataScadenzaUnslashed {get {
									  String res = '';
									  if(!String.isBlank(dataScadenza) && !'0'.equalsIgnoreCase(dataScadenza)) {

										  res += dataScadenza.subString(0, 4);
										  res += dataScadenza.subString(4, 6);
									  }
									  return res;
								  } set;}
		@AuraEnabled public String checkIntermediario {get; set;}
		@AuraEnabled public String pagamento {get; set;}
		@AuraEnabled public String bancaCliAbi {get; set;}
		@AuraEnabled public String bancaCliCab {get; set;}
		@AuraEnabled public String contoCorrente {get; set;}
		@AuraEnabled public String iban {get; set;}
		public String comRinnovo {get; set;}
		public String comRinnovo1 {get; set;}
		public String comRinnovoDurata1 {get; set;}
		public String comRinnovo2 {get; set;}
		public String comRinnovoDurata2 {get; set;}
		public String comRinnovo3 {get; set;}
		public String comRinnovoDurata3 {get; set;}
		@AuraEnabled public String stato {get; set;}
		public String blocco {get; set;}
		@AuraEnabled public String tassoTan {get; set;}
		@AuraEnabled public String tassoTaeg {get; set;}
		@AuraEnabled public String pan {get; set;}
		@AuraEnabled public Double fidoTotale {get; set {fidoTotale = OCSResponse.setNumber(value);}}
		@AuraEnabled public Double dispTotale {get; set {dispTotale = OCSResponse.setNumber(value);}}
		@AuraEnabled public String fidoRiserva1 {get; set;}
		@AuraEnabled public String dispRiserva1 {get; set;}
		@AuraEnabled public String fidoRiserva2 {get; set;}
		@AuraEnabled public String dispRiserva2 {get; set;}
		@AuraEnabled public String fidoRiserva3 {get; set;}
		@AuraEnabled public String dispRiserva3 {get; set;}
		@AuraEnabled public String flagAttivazioneCarta {get; set;}
		@AuraEnabled public String codProdotto {get; set;}
		@AuraEnabled public String desProdotto {get; set;}
		public String flagAlertSms {get; set;}
		@AuraEnabled public Double riservaPrincipaleFido {
			get {return OCSResponse.getNumber(riservaPrincipaleFido,riservaPrincipaleFidoSegno);}
			set {riservaPrincipaleFido = OCSResponse.setNumber(value);}
		}
		@AuraEnabled public String riservaPrincipaleFidoSegno {get; set;}


		@AuraEnabled public Double riservaPrincipaleSaldo   {
			get {return OCSResponse.getNumber(riservaPrincipaleSaldo,riservaPrincipaleSaldoSegno);}
			set {riservaPrincipaleSaldo = OCSResponse.setNumber(value);}
		}

		@AuraEnabled public String riservaPrincipaleSaldoSegno {get; set;}


		@AuraEnabled public Double riservaPrincipaleDisp {
			get {return OCSResponse.getNumber(riservaPrincipaleDisp,riservaPrincipaleDispSegno);}
			set {riservaPrincipaleDisp = OCSResponse.setNumber(value);}
		}


		@AuraEnabled public String riservaPrincipaleDispSegno {get; set;}


		@AuraEnabled public Double riservaPrincipaleSconfino {
			get {return OCSResponse.getNumber(riservaPrincipaleSconfino,riservaPrincipaleSconfinoSegno);}
			set {riservaPrincipaleSconfino = OCSResponse.setNumber(value);}
		}


		@AuraEnabled public String riservaPrincipaleSconfinoSegno {get; set;}


		@AuraEnabled public Double riservaPrincipaleOverlimit {
			get {return OCSResponse.getNumber(riservaPrincipaleOverlimit,riservaPrincipaleOverlimitSegno);}
			set {riservaPrincipaleOverlimit = OCSResponse.setNumber(value);}

		}


		@AuraEnabled public String riservaPrincipaleOverlimitSegno {get; set;}


		@AuraEnabled public Double riservaPrincipaleDispTeorMax {
			get {return OCSResponse.getNumber(riservaPrincipaleDispTeorMax,riservaPrincipaleDispTeorMaxSegno);}
			set {riservaPrincipaleDispTeorMax = OCSResponse.setNumber(value);}
		}


		@AuraEnabled public String riservaPrincipaleDispTeorMaxSegno {get; set;}


		@AuraEnabled public Double riservaSalvadanaioFido {
			get {return OCSResponse.getNumber(riservaSalvadanaioFido,riservaSalvadanaioFidoSegno);}
			set {riservaSalvadanaioFido = OCSResponse.setNumber(value);}
		}


		@AuraEnabled public String riservaSalvadanaioFidoSegno {get; set;}


		@AuraEnabled public Double riservaSalvadanaioSaldo {
			get {return OCSResponse.getNumber(riservaSalvadanaioSaldo,riservaSalvadanaioSaldoSegno);}
			set {riservaSalvadanaioSaldo = OCSResponse.setNumber(value);}
		}


		@AuraEnabled public String riservaSalvadanaioSaldoSegno {get; set;}


		@AuraEnabled public Double riservaSalvadanaioDisp {
			get {return OCSResponse.getNumber(riservaSalvadanaioDisp,riservaSalvadanaioDispSegno);}
			set {riservaSalvadanaioDisp = OCSResponse.setNumber(value);}
		}


		@AuraEnabled public String riservaSalvadanaioDispSegno {get; set;}


		@AuraEnabled public Double riservaSalvadanaioSconfino {
			get {return OCSResponse.getNumber(riservaSalvadanaioSconfino,riservaSalvadanaioSconfinoSegno);}
			set {riservaSalvadanaioSconfino = OCSResponse.setNumber(value);}
		}


		@AuraEnabled public String riservaSalvadanaioSconfinoSegno {get; set;}


		@AuraEnabled public Double riservaSalvadanaioOverlimit {
			get {return OCSResponse.getNumber(riservaSalvadanaioOverlimit,riservaSalvadanaioOverlimitSegno);}
			set {riservaSalvadanaioOverlimit = OCSResponse.setNumber(value);}
		}


		@AuraEnabled public String riservaSalvadanaioOverlimitSegno {get; set;}


		@AuraEnabled public Double riservaSalvadanaioDispTeorMax {
			get {return OCSResponse.getNumber(riservaSalvadanaioDispTeorMax,riservaSalvadanaioDispTeorMaxSegno);}
			set {riservaSalvadanaioDispTeorMax = OCSResponse.setNumber(value);}
		}


		@AuraEnabled public String riservaSalvadanaioDispTeorMaxSegno {get; set;}


		@AuraEnabled public Double riservaInternetFido {
			get {return OCSResponse.getNumber(riservaInternetFido,riservaInternetFidoSegno);}
			set {riservaInternetFido = OCSResponse.setNumber(value);}
		}


		@AuraEnabled public String riservaInternetFidoSegno {get; set;}


		@AuraEnabled public Double riservaInternetSaldo {
			get {return OCSResponse.getNumber(riservaInternetSaldo,riservaInternetSaldoSegno);}
			set {riservaInternetSaldo = OCSResponse.setNumber(value);}
		}


		@AuraEnabled public String riservaInternetSaldoSegno {get; set;}


		@AuraEnabled public Double riservaInternetDisp {
			get {return OCSResponse.getNumber(riservaInternetDisp,riservaInternetDispSegno);}
			set {riservaInternetDisp = OCSResponse.setNumber(value);}
		}


		@AuraEnabled public String riservaInternetDispSegno {get; set;}


		@AuraEnabled public Double riservaInternetSconfino {
			get {return OCSResponse.getNumber(riservaInternetSconfino,riservaInternetSconfinoSegno);}
			set {riservaInternetSconfino = OCSResponse.setNumber(value);}
		}


		@AuraEnabled public String riservaInternetSconfinoSegno {get; set;}


		@AuraEnabled public Double riservaInternetOverlimit {
			get {return OCSResponse.getNumber(riservaInternetOverlimit,riservaInternetOverlimitSegno);}
			set {riservaInternetOverlimit = OCSResponse.setNumber(value);}
		}


		@AuraEnabled public String riservaInternetOverlimitSegno {get; set;}


		@AuraEnabled public Double riservaInternetDispTeorMax {
			get {return OCSResponse.getNumber(riservaInternetDispTeorMax,riservaInternetDispTeorMaxSegno);}
			set {riservaInternetDispTeorMax = OCSResponse.setNumber(value);}
		}


		@AuraEnabled public String riservaInternetDispTeorMaxSegno {get; set;}


		@AuraEnabled public Double riservaMulticontoFido {
			get;
			set {riservaMulticontoFido = OCSResponse.setNumber(value);}
		}


		@AuraEnabled public Double riservaMulticontoSaldo {
			get {return OCSResponse.getNumber(riservaMulticontoSaldo,riservaMulticontoSaldoSegno);}
			set {riservaMulticontoSaldo = OCSResponse.setNumber(value);}
		}


		@AuraEnabled public String riservaMulticontoSaldoSegno {get; set;}


		@AuraEnabled public Double riservaMulticontoDisp {
			get {return OCSResponse.getNumber(riservaMulticontoDisp,riservaMulticontoDispSegno);}
			set {riservaMulticontoDisp = OCSResponse.setNumber(value);}
		}


		@AuraEnabled public String riservaMulticontoDispSegno {get; set;}


		@AuraEnabled public Double riservaMulticontoSconfino {
			get {return OCSResponse.getNumber(riservaMulticontoSconfino,riservaMulticontoSconfinoSegno);}
			set {riservaMulticontoSconfino = OCSResponse.setNumber(value);}
		}


		@AuraEnabled public String riservaMulticontoSconfinoSegno {get; set;}


		@AuraEnabled public Double riservaMulticontoOverlimit {
			get {return OCSResponse.getNumber(riservaMulticontoOverlimit,riservaMulticontoOverlimitSegno);}
			set {riservaMulticontoOverlimit = OCSResponse.setNumber(value);}
		}


		@AuraEnabled public String riservaMulticontoOverlimitSegno {get; set;}


		@AuraEnabled public Double riservaMulticontoDispTeorMax {
			get {return OCSResponse.getNumber(riservaMulticontoDispTeorMax,riservaMulticontoDispTeorMaxSegno);}
			set {riservaMulticontoDispTeorMax = OCSResponse.setNumber(value);}
		}


		@AuraEnabled public String riservaMulticontoDispTeorMaxSegno {get; set;}


		public String as400Status {get; set;}
		public String as400Errore {get; set;}

		@AuraEnabled public String fidoCustom {get {
							       return getFidoTotale();
						       } set;}
		@AuraEnabled public String disponibilitaCustom {get {
									return getDisponibilita();
								} set;}
		@AuraEnabled public String modCalcoloRataCustom {get {
									 return CompassParametersUtils.getLabelFromService('carteDatiFinanziari','ModCalcoloRata',modCalcoloRata);
								 } set;}
		@AuraEnabled public String statoCustom {get {
								return CompassParametersUtils.getLabelFromService('carteDatiFinanziari','StatoCarta',stato);
							} set;}
		@AuraEnabled public String statoRinnovoCustom {get {
								       return CompassParametersUtils.getLabelFromService('carteDatiFinanziari','StatoRinnovo',flagAttivazioneCarta);
							       } set;}

		public String getFidoTotale() {
			/*if(String.isNotBlank(fidoTotale))
				return String.valueOf((double.valueOf(fidoTotale))/100);
			*/
			return '';
			
		}


		public String getDisponibilita() {

		/*	if(String.isNotBlank(dispTotale))
				return String.valueOf((double.valueOf(dispTotale))/100);
*/
			return '';
		}
	}

	public Boolean isStatusOK(){
		return 'OK'.equalsIgnoreCase(datiCartaDatiFinanziariResponse.as400Status);
	}
	public String getAs400Errore(){
		return datiCartaDatiFinanziariResponse.as400Errore;
	}
	public String getAs400Status(){
		return datiCartaDatiFinanziariResponse.as400Status;
	}
}