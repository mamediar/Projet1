/**
 * @File Name          : PV2870RiemissionePINInserimento.cls
 * @Description        : 
 * @Author             : sabrina vitali
 * @Group              : 
 * @Last Modified By   : sabrina vitali
 * @Last Modified On   : 11/9/2019, 16:15:42
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    25/7/2019, 16:15:49   sabrina vitali     Initial Version
**/
public class PV2870RiemissionePINInserimento extends PVAction {
	public class PV2870RiemissionePINInserimentoForm extends PVForm {
	}

	@AuraEnabled
	public static void conferma(PV2870RiemissionePINInserimentoForm datiForm){
		new PV2870RiemissionePINInserimento().execute(datiForm);
	}

	public void execute(PVForm form){
		String messaggio_errore = '';
		try{
			PV2870RiemissionePINInserimentoForm myForm = (PV2870RiemissionePINInserimentoForm) form;
			OCSCliente cliente = myForm.cliente;

            OCSRistampaPINInvoker.Request req = new OCSRistampaPINInvoker.Request();
            req.ristampaPinRequest.intermediario = '12';
            req.ristampaPinRequest.provenienza = 'CA';
            req.ristampaPinRequest.tipoIntermediario = 'AG';
            req.ristampaPinRequest.numCarta = myForm.pratica.numPratica;
            req.ristampaPinRequest.pan = '';
            req.ristampaPinRequest.ricalcoloPin = 'N';
            req.ristampaPinRequest.rifEsterno2 = '';
            req.ristampaPinRequest.addebitoCommissioni = 'N';

            System.debug('@@@ debugger req ' + req);
            OCSRistampaPINInvoker.Response res = OCSRistampaPINInvoker.invoke(req.ristampaPinRequest);
            System.debug('@@@ debugger res ' + res);

            if(!res.isOK()) {
				messaggio_errore = res.getMessage();
			}
            else if(res.ristampaPinResponse.as400Status == 'KO') {
				messaggio_errore = 'Errore da OCS: ' + res.ristampaPinResponse.as400Status + ' - ' + res.ristampaPinResponse.as400Errore;
			}else{
				//Common di PVAction
				commonExecute(myForm);
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
		PV2870RiemissionePINInserimentoForm myForm = (PV2870RiemissionePINInserimentoForm) form;
		return casoPV;
	}

	public override String recuperaNotaSpecificaPV(PVForm form, Case casoPV){
		//preparazione nota
		PV2870RiemissionePINInserimentoForm myForm = (PV2870RiemissionePINInserimentoForm) form;
		//7 : Note specifiche PV
		String notaSpecificaPV;
		notaSpecificaPV = 'Numero pratica: ' + myForm.pratica.numPratica + '\n';
		return notaSpecificaPV;
	}

	public override XCS_Messaggio__c preparaMessaggioOCS(PVForm form, XCS_Messaggio__c xcs_messaggio){
		//preparazione XCS_Messaggio
		PV2870RiemissionePINInserimentoForm myForm = (PV2870RiemissionePINInserimentoForm) form;
		//xcs_messaggio.CodCliente__c = myForm.cliente.codCliente;
		xcs_messaggio.NumPratica__c = myForm.pratica.numPratica;
		xcs_messaggio.TipoPratica__c = myForm.pratica.tipoPratica;
		return xcs_messaggio;
	}

	@AuraEnabled
	public static OCSCartaDatiFinanziariResponse.DatiCartaDatiFinanziariResponseDTO recuperaDatiFinanziari(String numeroCarta){
		OCSCartaDatiFinanziariResponse cartaDatiFinanziariResponse = OCSCartaDatiFinanziariInvoker.cartaDatiFinanziari(numeroCarta);
		return cartaDatiFinanziariResponse.datiCartaDatiFinanziariResponse;
	}

	@AuraEnabled
	public static OCSRecuperaInfoCartaResponse.RecuperaInfoCartaResponse recuperaInfoCarta(String numeroCarta){
		OCSRecuperaInfoCartaResponse recuperaInfoCartaResponse = OCSRecuperaInfoCartaInvoker.callRecInfoCarta(numeroCarta);
		return recuperaInfoCartaResponse.recuperaInfoCartaResponse;
	}

	@AuraEnabled
	public static String recuperaIndirizzoCompleto(String codCliente){
		//OCSRecuperaIndirizziClienteResponse indirizzi;
        OCSRecuperaIndirizziClienteResponse indirizzi = OCSRecuperaIndirizziClienteInvoker.callRecIndirizzi(codCliente);
        OCSRecuperaIndirizziClienteResponse.IndirizzoDTO indirizzo;
        system.debug('*********** 1');
        String indirizzoCompleto = '';
        system.debug('*********** 2');
        for(Integer j=0;j<indirizzi.recuperaIndirizziClienteResponse.elencoIndirizzi.size();j++){
            indirizzo = indirizzi.recuperaIndirizziClienteResponse.elencoIndirizzi[j];
            system.debug('*********** indirizzo' + indirizzo);
            if(String.isNotBlank(indirizzo.tipoIndirizzo) && indirizzo.tipoIndirizzo.trim().equalsIgnoreCase('D') && 
                String.isNotBlank(indirizzo.indirizzo)){
                indirizzoCompleto = indirizzo.indirizzo.trim() + '\n' + indirizzo.cap.trim() + ' ' + indirizzo.localita.trim() + ' (' + indirizzo.provincia.trim() + ')';
            }else if (String.isNotBlank(indirizzo.tipoIndirizzo) && indirizzo.tipoIndirizzo.trim().equalsIgnoreCase('R') && 
                String.isNotBlank(indirizzo.indirizzo) && String.isBlank(indirizzoCompleto)) {
                indirizzoCompleto = indirizzo.indirizzo.trim() + '\n' + indirizzo.cap.trim() + ' ' + indirizzo.localita.trim() + ' (' + indirizzo.provincia.trim() + ')';
            }
        }
        return indirizzoCompleto;
	}

}