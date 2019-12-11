//----------------------------------------------------------------------
//-- - Class Name   : OCSAperturaSinistroInvoker
//-- - Autor        : Fabio Giuliani(Lynx)
//-- - Date         : 01/07/2019
//-- - Description  : Invoker per chiamata servizio ws_AperturaSinistro
//-- - Version      : 1.0
//----------------------------------------------------------------------

public class OCSAperturaSinistroInvoker {
    public static OCSAperturaSinistroResponse callApeSinistro(OCSAperturaSinistroRequest request){
        return (OCSAperturaSinistroResponse)ApiUtils.callApi('ocs.aperturaSinistro',request,OCSAperturaSinistroResponse.class);
    }
    
//    public static OCSAperturaSinistroResponse callApeSinistro(Map<String,String> data){
    public static OCSAperturaSinistroResponse callApeSinistro(String compagnia, String numPratica, String tipoPratica,
                                                                String dataSinistro, String tipoSinistro, String cognomeCliente,
                                                                String nomeCliente, String flagReadOnly){

        OCSAperturaSinistroRequest req=new OCSAperturaSinistroRequest();
        req.datiAperturaSinistroRequest.compagnia=compagnia;
        req.datiAperturaSinistroRequest.numPratica=numPratica;
        req.datiAperturaSinistroRequest.tipoPratica=tipoPratica;
        req.datiAperturaSinistroRequest.dataSinistro=dataSinistro;
        req.datiAperturaSinistroRequest.tipoSinistro=tipoSinistro;
        req.datiAperturaSinistroRequest.cognome=cognomeCliente;
        req.datiAperturaSinistroRequest.nome=nomeCliente;
        req.datiAperturaSinistroRequest.flagReadOnly=flagReadOnly;
        
        OCSAperturaSinistroResponse res=callApeSinistro(req);
      	System.debug(res);
        return res;
    }
}