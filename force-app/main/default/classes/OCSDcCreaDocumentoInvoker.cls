public class OCSDcCreaDocumentoInvoker {
    
    
    public static OCSDcCreaDocumentoResponse callDcCreaDocumento(OCSDcCreaDocumentoRequest req){
        return (OCSDcCreaDocumentoResponse)ApiUtils.callApi('ocs.dcCreaDocumento',req,OCSDcCreaDocumentoResponse.class);
    }    
    
    public static OCSDcCreaDocumentoResponse callDcCreaDocumento (String nomeTemplate, ParamFiller filler) {
        List<String> nomiTemplate=new List<String>{nomeTemplate}; 
        return callDcCreaDocumento(nomiTemplate,filler);
    }
    
    public static OCSDcCreaDocumentoResponse callDcCreaDocumento (List<String> nomiTemplate, ParamFiller filler) {
        OCSDcCreaDocumentoRequest req = new OCSDcCreaDocumentoRequest();
        req.dcCreaDocumentoRequest.pratica.labelProperty = convertParametro(filler.getParams());
        req.dcCreaDocumentoRequest.pratica.listaModuloVarie =nomiTemplate; 
        return callDcCreaDocumento(req);
    }    
    

    public static List<OCSDcCreaDocumentoRequest.LabelProperty> convertParametro(List<ParamFiller.Parametro> parametri){
        List<OCSDcCreaDocumentoRequest.LabelProperty> paramsList =new List<OCSDcCreaDocumentoRequest.LabelProperty>();
        
        for(ParamFiller.Parametro param:parametri){
            OCSDcCreaDocumentoRequest.LabelProperty p=new OCSDcCreaDocumentoRequest.LabelProperty();
            p.valore=param.valore;
            p.variabile=param.variabile;
            paramsList.add(p);
        }
        
        return paramsList;
    }
    

    
}