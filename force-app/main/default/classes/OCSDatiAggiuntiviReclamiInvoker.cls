public class OCSDatiAggiuntiviReclamiInvoker {
    
    public static OCSDatiAggiuntiviReclamiResponse callDatiAgguntiviReclami (OCSDatiAggiuntiviReclamiRequest req){
        return (OCSDatiAggiuntiviReclamiResponse)ApiUtils.callApi('ocs.datiAggiuntiviReclami',req,OCSDatiAggiuntiviReclamiResponse.class);                                  
    }
    
    public static OCSDatiAggiuntiviReclamiResponse callDatiAgguntiviReclami (String codCliente, String codPratica, String tipoPratica){
        OCSDatiAggiuntiviReclamiRequest req = new OCSDatiAggiuntiviReclamiRequest();
        req.datiAggiuntiviReclamiRequest.codCliente = codCliente;
        req.datiAggiuntiviReclamiRequest.codPratica = codPratica;
        req.datiAggiuntiviReclamiRequest.tipoPratica = tipoPratica;
        return (callDatiAgguntiviReclami(req));
    }    
}