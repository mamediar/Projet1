//----------------------------------------------------------------------
//-- - Class Name   : OCSChiusuraSinistroInvoker
//-- - Autor        : Fabio Giuliani(Lynx)
//-- - Date         : 01/07/2019
//-- - Description  : Invoker per chiamata servizio ws_ChiusuraSinistro
//-- - Version      : 1.0
//----------------------------------------------------------------------
public class OCSChiusuraSinistroinvoker { 
    public static OCSChiusuraSinistroResponse callChiSinistro(OCSChiusuraSinistroRequest request){
        return (OCSChiusuraSinistroResponse)ApiUtils.callApi('ocs.chiusuraSinistro',request,OCSChiusuraSinistroResponse.class);
    }
    
//    public static OCSChiusuraSinistroResponse callChiSinistro(Map<String,String> data){
    public static OCSChiusuraSinistroRequest.ChiusuraSinistroRequestDTO setElencoSinistri(String flagEsito, 
                                                                String numPratica, String tipoPratica,
                                                                String esito, String motivo, String importoindennizzato,
                                                                String cognome, String nome,
                                                                String tipoSinistro, String tipoPagamento){

        OCSChiusuraSinistroRequest.ChiusuraSinistroRequestDTO req=new OCSChiusuraSinistroRequest.ChiusuraSinistroRequestDTO();
//        req.compagnia=compagnia;
//        req.flagreadOnly=flagReadOnly;
        req.flagesito=flagEsito;
        req.numPratica=numPratica;
        req.tipoPratica=tipoPratica;
        req.esito=esito;
        req.motivo=motivo;
        req.importoindennizzato=importoIndennizzato;
        req.cognome=cognome;
        req.nome=nome;
        req.tipoSinistro=tipoSinistro;
        req.tipoPagamento=tipoPagamento;
        
        return req;
    }
    
    public static OCSChiusuraSinistroResponse callOCS(List<OCSChiusuraSinistroRequest.ChiusuraSinistroRequestDTO> lista, String flagReadOnly, String compagnia){
        OCSChiusuraSinistroRequest ocsReq = new OCSChiusuraSinistroRequest(lista);
        ocsReq.compagnia = compagnia;
        ocsReq.flagReadOnly = flagReadOnly;
        return callChiSinistro(ocsReq);
    }
    
}