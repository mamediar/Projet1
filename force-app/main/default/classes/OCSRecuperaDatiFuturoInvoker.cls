public class OCSRecuperaDatiFuturoInvoker {
    public static OCSRecuperaDatiFuturoResponse callRecDatiFuturo(OCSRecuperaDatiFuturoRequest req){
        return (OCSRecuperaDatiFuturoResponse)ApiUtils.callApi('ocs.recuperaDatiFuturo',req,OCSRecuperaDatiFuturoResponse.class);
    }
    
    public static OCSRecuperaDatiFuturoResponse callRecDatiFuturo(String codCliente){
        OCSRecuperaDatiFuturoRequest req=new OCSRecuperaDatiFuturoRequest();
        req.codCliente=codCliente;
        return callRecDatiFuturo(req);
    }
    
    public static OCSRecuperaDatiFuturoResponse callRecDatiFuturo(Map<String,String> data){
        OCSRecuperaDatiFuturoRequest request=new OCSRecuperaDatiFuturoRequest();
        request.numPratica=data.keySet().contains('numPratica')?data.get('numPratica'):null;
        request.flagInfoCliente=data.keySet().contains('flagInfoCliente')?data.get('flagInfoCliente'):null;
        request.filtroTipoPratica=data.keySet().contains('filtroTipoPratica')?data.get('filtroTipoPratica'):null;
        request.codCliente=data.keySet().contains('codCliente')?data.get('codCliente'):null;
        request.cognomeCliente=data.keySet().contains('cognomeCliente')?data.get('cognomeCliente'):null;
        request.nomeCliente=data.keySet().contains('nomeCliente')?data.get('nomeCliente'):null;
        request.dataNascitaCliente=data.keySet().contains('dataNascitaCliente')?data.get('dataNascitaCliente'):null;
        request.codFiscaleCliente=data.keySet().contains('codFiscaleCliente')?data.get('codFiscaleCliente'):null;
        request.telefonoCliente=data.keySet().contains('telefonoCliente')?data.get('telefonoCliente'):null;
        request.faxCliente=data.keySet().contains('faxCliente')?data.get('faxCliente'):null;
        request.emailCliente=data.keySet().contains('emailCliente')?data.get('emailCliente'):null;
        request.provinciaCliente=data.keySet().contains('provinciaCliente')?data.get('provinciaCliente'):null;
        request.ragioneSociale=data.keySet().contains('ragioneSociale')?data.get('ragioneSociale'):null;
        
        OCSRecuperaDatiFuturoResponse res=callRecDatiFuturo(request);
        System.debug('OCSRecuperaDatiFuturoInvoker callRecDatiFuturo(Map) res: '+res);
        return res;
    }
}