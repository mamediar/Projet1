public class OCSCalcolaIbanInvoker {
    public static OCSCalcolaIbanResponse callCalcolaIban(OCSCalcolaIbanRequest request){
        return (OCSCalcolaIbanResponse)ApiUtils.callApi('ocs.calcolaIban',request,OCSCalcolaIbanResponse.class);
    }
    
    public static OCSCalcolaIbanResponse callCalcolaIban(String abi,String cab,String numConto){
        OCSCalcolaIbanRequest request=new OCSCalcolaIbanRequest();
        request.abi=abi;
        request.cab=cab;
        request.numConto=numConto;
        return callCalcolaIban(request);
    }
    

    public static OCSCalcolaIbanResponse callCalcolaIban(ValoriRichiesti val){
        OCSCalcolaIbanRequest request=new OCSCalcolaIbanRequest();
        request.abi = val.abi;
        request.cab = val.cab;
        request.numConto = val.numConto;
        return callCalcolaIban(request);
    }
    
    public static List<OCSCalcolaIbanResponse> callCalcolaIban(List<ValoriRichiesti> vaList) {
        List<OCSCalcolaIbanResponse> listaResponse = new List<OCSCalcolaIbanResponse>();
        for (ValoriRichiesti v : vaList) {
            listaResponse.add(callCalcolaIban(v));
        }
        return listaResponse;
    }
    
    
    public static DatiChiamataOCS processaResponse(OCSCalcolaIbanResponse response){
        DatiChiamataOCS datiChiamataOCS=new DatiChiamataOCS();
        if(response.isOK()){
           datiChiamataOCS.chiamataOK=true; 
           datiChiamataOCS.iban=response.iban;
        } else {
           datiChiamataOCS.chiamataOK=false;  
           datiChiamataOCS.message=response.resultMessage;  
        }
        System.debug('datiChiamataOCS "Calcola IBAN":: '+datiChiamataOCS);
        return datiChiamataOCS;
    }    
    
    
    public class ValoriRichiesti {
        public String abi {get;set;}
        public String cab {get;set;}
        public String numConto {get;set;}
    }
    
    public class DatiChiamataOCS {
        @AuraEnabled public Boolean chiamataOK {get;set;}
        @AuraEnabled public String message {get;set;}
        @AuraEnabled public String iban {get;set;}
    }    
}