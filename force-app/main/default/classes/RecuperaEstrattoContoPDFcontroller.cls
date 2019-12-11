public class RecuperaEstrattoContoPDFcontroller {

    
    @AuraEnabled
    public static OCSRecuperaEstrattoContoPDFResponse getContoPDF(String codCliente, String numPratica, String mese, String anno) { 
        
        OCSRecuperaEstrattoContoPDFResponse Resp = OCSRecuperaEstrattoContoPDFInvoker.invoke(codCliente, numPratica, mese, anno);
        system.debug('DP Resp getContoPDF: '+Resp);
        return Resp;
    }
    
}