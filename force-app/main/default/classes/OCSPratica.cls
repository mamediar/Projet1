/**
 * @File Name          : OCSPratica.cls
 * @Description        :
 * @Author             : Andrea Vanelli
 * @Group              :
 * @Last Modified By   : Andrea Vanelli
 * @Last Modified On   : 26/9/2019, 14:38:54
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    26/9/2019   Andrea Vanelli     Initial Version
 **/
public class OCSPratica {
	@AuraEnabled public String numPratica {get; set;}
	@AuraEnabled public String codCliente {get; set;}
	@AuraEnabled public String abi {get; set;}
	@AuraEnabled public String cab {get; set;}
	@AuraEnabled public String numConto {get; set;}
	@AuraEnabled public String iban {get; set;}
	@AuraEnabled public String statoPratica {get; set;}
	@AuraEnabled public String tipoPagamento {get; set;}
	@AuraEnabled public String prodotto {get; set;}
	@AuraEnabled public String filiale {get; set;}
	@AuraEnabled public String dataEstinzione {get; set;}
	@AuraEnabled public String tipoPratica {get; set;}
	@AuraEnabled public String dataCaricamento {get {return(String.isNotBlank(dataCaricamento) ? (dataCaricamento.contains('/') ? dataCaricamento : (DateTime.newInstance(Long.valueOf(dataCaricamento))).format('dd/MM/yyyy')) : '');} set;}
	@AuraEnabled public String pan {get; set;}
	@AuraEnabled public String convenzionato {get; set;}
	@AuraEnabled public String puntoVendita {get; set;}
	@AuraEnabled public String venditore {get; set;}
	@AuraEnabled public String agente {get; set;}
	@AuraEnabled public String subAgente {get; set;}
	@AuraEnabled public String flagRecupero {get; set;}
	@AuraEnabled public String classifRecupero {get; set;}
	@AuraEnabled public String societa {get; set;}
	@AuraEnabled public OCSCliente[] elencoCoobbligati {get; set;}
	@AuraEnabled public String codStatoPratica {get; set;}
	@AuraEnabled public String codAttributoPratica {get; set;}
	@AuraEnabled public String desStatoPratica {get; set;}
	@AuraEnabled public String desAttributoPratica {get; set;}
	@AuraEnabled public String codRecuperatore {get; set;}
	@AuraEnabled public String desRecuperatore {get; set;}
	@AuraEnabled public String canale {get; set;}
	@AuraEnabled public String cedCom {get; set;}
	@AuraEnabled public String Tabella_Finanziaria {get; set;}
	@AuraEnabled public String Pratica_Codice_Attributo_PM {get; set;}
	@AuraEnabled public String Pratica_Descr_Attributo_PM {get; set;}
	@AuraEnabled public List<PacchettoAssicurativo> pacchettiAssicurativi {get; set;}

	@AuraEnabled public String numPraticaOrigine {get; set;}
	@AuraEnabled public String numPraticaDestinazione {get; set;}
	@AuraEnabled public String dealerCode {
		get {return OCSResponse.getDealerCode(puntoVendita, convenzionato, subAgente,agente   );}
		set;
	}

	public class PacchettoAssicurativo {
		@AuraEnabled public String codice {get; set;}
		@AuraEnabled public String descrizione {get; set;}
	}
}