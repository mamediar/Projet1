public class OCSSchedaClienteInvoker {
    public static OCSSchedaClienteResponse callGetSchedaCliente(OCSSchedaClienteRequest request){
        return (OCSSchedaClienteResponse)ApiUtils.callApi('ocs.schedaCliente',request,OCSSchedaClienteResponse.class);
    }
    
    public static OCSSchedaClienteResponse callGetSchedaCliente(String codCliente){
        OCSSchedaClienteRequest request=new OCSSchedaClienteRequest();
        codCliente=codCliente.replace('C', '');
        request.codCliente=codCliente;
        OCSSchedaClienteResponse res= callGetSchedaCliente(request);
        return res;
    }
    
    public static OCSSchedaClienteResponse callGetSchedaCliente(String codCliente, 
                                                                String numPratica, 
                                                                String flagInfoCliente,
                                                                String filtroTipoPratica,
                                                                String cognomeCliente,
                                                                String nomeCliente,
                                                                String dataNascitaCliente,
                                                                String codFiscaleCliente,
                                                                String pan,
                                                                String telefonoCliente,
                                                                String faxCliente,
                                                                String emailCliente,
                                                                String provinciaCliente,
                                                                String ragioneSociale){
        OCSSchedaClienteRequest request=new OCSSchedaClienteRequest();
        codCliente=codCliente.replace('C', '');
        request.codCliente=codCliente;
        request.numPratica=numPratica;
        request.flagInfoCliente=flagInfoCliente;
        request.filtroTipoPratica=filtroTipoPratica;
        request.cognomeCliente=cognomeCliente;
        request.nomeCliente=nomeCliente;
        request.dataNascitaCliente=dataNascitaCliente;
        request.codFiscaleCliente=codFiscaleCliente;
        request.pan=pan;
        request.telefonoCliente=telefonoCliente;
        request.faxCliente=faxCliente;
        request.emailCliente=emailCliente;
        request.provinciaCliente=provinciaCliente;
        request.ragioneSociale=ragioneSociale;
        OCSSchedaClienteResponse res= callGetSchedaCliente(request);
        return res;
    }
}