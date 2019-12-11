//----------------------------------------------------------------------
//-- - Class Name   : OCSRecuperaDatiPostvenditaInvoker
//-- - Autor        : 
//-- - Date         : 07/06/2019
//-- - Description  : 
//-- - Version      : 1.0
//----------------------------------------------------------------------

public class OCSRecuperaDatiPostvenditaInvoker {
    public static OCSRecuperaDatiPostvenditaResponse callRecDatiPV(OCSRecuperaDatiPostvenditaRequest request){
        return (OCSRecuperaDatiPostvenditaResponse)ApiUtils.callApi('ocs.recuperaDatiPostvendita',request,OCSRecuperaDatiPostvenditaResponse.class);
    }
    
    public static OCSRecuperaDatiPostvenditaResponse callRecDatiPV(String codCliente){
        OCSRecuperaDatiPostvenditaRequest request=new OCSRecuperaDatiPostvenditaRequest();
        request.codCliente=codCliente;
        return callRecDatiPV(request);
    }
    
    public static OCSRecuperaDatiPostvenditaResponse getReclamiPratica(String codCliente, String societa){
        OCSRecuperaDatiPostvenditaRequest request=new OCSRecuperaDatiPostvenditaRequest();
        request.codCliente=codCliente;
        if(societa == 'Compass'){
            request.filtroTipoPratica='CA#CO#CQ#PB';
            request.flagInfoCliente='true';
        }
        return callRecDatiPV(request);
    }
    
    public static OCSRecuperaDatiPostvenditaResponse callRecDatiPV(String codCliente, String filtroTipoPratica){
        OCSRecuperaDatiPostvenditaRequest request=new OCSRecuperaDatiPostvenditaRequest();
        request.codCliente=codCliente;
        request.filtroTipoPratica = filtroTipoPratica;
        return callRecDatiPV(request);
    }
    public static OCSRecuperaDatiPostvenditaResponse callRecDatiCoobligati(String codCliente, String filtroTipoPratica, string InfoCli){
        OCSRecuperaDatiPostvenditaRequest request=new OCSRecuperaDatiPostvenditaRequest();
        request.codCliente=codCliente;
        request.filtroTipoPratica = filtroTipoPratica;
        request.flagInfoCliente=InfoCli;
        return callRecDatiPV(request);
    }
    public static OCSRecuperaDatiPostvenditaResponse callRecDatiPVPratica(String codpratica, String tipoDoc){
       OCSRecuperaDatiPostvenditaRequest request=new OCSRecuperaDatiPostvenditaRequest();
       request.numPratica = codpratica;
       request.filtroTipoPratica = tipoDoc;
       //request.flagInfoCliente = 'true';
       return callRecDatiPV(request);
    }


    
    public static OCSRecuperaDatiPostvenditaResponse callRecDatiPV(Map<String,String> data){
        

        System.debug('OCSRecuperaDatiPostvenditaInvoker callRecDatiPV(Map) data: '+data);
        
        // SERVE SOLO PER VEDERE QUALI DATI ARRIVANO FABIO 07-06-2019
        for(String key:data.keySet()){
            System.debug('OCSRecuperaDatiPostvenditaInvoker callRecDatiPV(Map) data: '+data.get(key));
        }

        OCSRecuperaDatiPostvenditaRequest request=new OCSRecuperaDatiPostvenditaRequest();
        request.numPratica=data.keySet().contains('numPratica')?data.get('numPratica'):null;
        request.flagInfoCliente=data.keySet().contains('flagInfoCliente')?data.get('flagInfoCliente'):null;
        request.filtroTipoPratica=data.keySet().contains('filtroTipoPratica')?data.get('filtroTipoPratica'):null;
        request.codCliente=data.keySet().contains('codCliente')?data.get('codCliente'):null;
        request.cognomeCliente=data.keySet().contains('cognomeCliente')?data.get('cognomeCliente'):null;
        request.nomeCliente=data.keySet().contains('nomeCliente')?data.get('nomeCliente'):null;
        request.dataNascitaCliente=data.keySet().contains('dataNascitaCliente')?data.get('dataNascitaCliente'):null;
        request.codFiscaleCliente=data.keySet().contains('codFiscaleCliente')?data.get('codFiscaleCliente'):null;
        request.pan=data.keySet().contains('pan')?data.get('pan'):null;
        request.telefonoCliente=data.keySet().contains('telefonoCliente')?data.get('telefonoCliente'):null;
        request.faxCliente=data.keySet().contains('faxCliente')?data.get('faxCliente'):null;
        request.emailCliente=data.keySet().contains('emailCliente')?data.get('emailCliente'):null;
        request.provinciaCliente=data.keySet().contains('provinciaCliente')?data.get('provinciaCliente'):null;
        request.ragioneSociale=data.keySet().contains('ragioneSociale')?data.get('ragioneSociale'):null;
        System.debug('OCSRecuperaDatiPostvenditaInvoker callRecDatiPV(Map) request: '+request);
        
        OCSRecuperaDatiPostvenditaResponse res=callRecDatiPV(request);
        System.debug('OCSRecuperaDatiPostvenditaInvoker callRecDatiPV(Map) res: '+res);
        return res;
    }
}