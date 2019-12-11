public class OCSNormalizzaIndirizzoInvoker {
    public static OCSNormalizzaIndirizzoResponse callNormalizzaIndirizzo(OCSNormalizzaIndirizzoRequest req,String company){
        return (OCSNormalizzaIndirizzoResponse)ApiUtils.callApi('ocs.normalizzaIndirizzo',req,OCSNormalizzaIndirizzoResponse.class, company);
    }
    
    public static OCSNormalizzaIndirizzoResponse callNormalizzaIndirizzo(String tipoIndirizzo,String indirizzo,String civico,String cap,String localita,String provincia,String nazione,String capRischio){
        return callNormalizzaIndirizzo(buildReq(tipoIndirizzo,indirizzo,civico,cap,localita,provincia,nazione,capRischio),'C');
    }
    
    public static OCSNormalizzaIndirizzoResponse callNormalizzaIndirizzo(String tipoIndirizzo,String indirizzo,String civico,String cap,String localita,String provincia,String nazione,String capRischio,String company){
        return callNormalizzaIndirizzo(buildReq(tipoIndirizzo,indirizzo,civico,cap,localita,provincia,nazione,capRischio),company);
    }
    
    private static OCSNormalizzaIndirizzoRequest buildReq(String tipoIndirizzo,String indirizzo,String civico,String cap,String localita,String provincia,String nazione,String capRischio){
        OCSNormalizzaIndirizzoRequest req =  new OCSNormalizzaIndirizzoRequest();
        req.normalizzaIndirizzoRequest.indirizzo.tipoIndirizzo=tipoIndirizzo;
        req.normalizzaIndirizzoRequest.indirizzo.indirizzo=indirizzo;
        req.normalizzaIndirizzoRequest.indirizzo.civico=civico;
        req.normalizzaIndirizzoRequest.indirizzo.cap=cap;
        req.normalizzaIndirizzoRequest.indirizzo.localita=localita;
        req.normalizzaIndirizzoRequest.indirizzo.provincia=provincia;
        req.normalizzaIndirizzoRequest.indirizzo.nazione=nazione;
        req.normalizzaIndirizzoRequest.indirizzo.capRischio=capRischio;
        return req;
    }
    
    public static DatiChiamataOCS processaResponse (OCSNormalizzaIndirizzoResponse response) {   
        DatiChiamataOCS datiChiamataOCS = new DatiChiamataOCS();
        datiChiamataOCS.chiamataOK=true;        
        if(!response.isOK()){
            //
            if(response.resultMessage==null){
                datiChiamataOCS.message='Errore nella chiamata del servizio "Normalizza Indirizzo". \n Rivolgersi al proprio amministratore di sistema.';
            } else {
                datiChiamataOCS.message=response.resultMessage;
            }
        	datiChiamataOCS.chiamataOK=false;
        } else if(response.normalizzaIndirizzoResponse.codErrore=='0') {   //esito 0 è indice di errore 
            datiChiamataOCS.message=response.normalizzaIndirizzoResponse.desErrore;
        	datiChiamataOCS.chiamataOK=false;            
            System.debug('messaggio codice errore: '+response.normalizzaIndirizzoResponse.codErrore);
            System.debug('messaggio descrizione errore: '+response.normalizzaIndirizzoResponse.desErrore);
        } else {
            if(response.normalizzaIndirizzoResponse.elencoIndirizzi.size()>0){                
                for(OCSNormalizzaIndirizzoResponse.IndirizzoDTO resIndirizzoOCS:response.normalizzaIndirizzoResponse.elencoIndirizzi){
                    IndirizzoOCS indirizzoOCS = new IndirizzoOCS();
                	indirizzoOCS.indirizzo=resIndirizzoOCS.tipoIndirizzo+' '+resIndirizzoOCS.indirizzo+' '+resIndirizzoOCS.civico;    
                    indirizzoOCS.localita=resIndirizzoOCS.localita;    
                    indirizzoOCS.provincia=resIndirizzoOCS.provincia;    
                    indirizzoOCS.nazione=resIndirizzoOCS.nazione;    
                    indirizzoOCS.cap=resIndirizzoOCS.cap;
                    datiChiamataOCS.indirizziElenco.add(indirizzoOCS);   
                }
            } 
        } 
		return datiChiamataOCS; 
    }
    
 	public class DatiChiamataOCS {
        @AuraEnabled
        public String message {get; set;}     
        @AuraEnabled
        public Boolean chiamataOK {get; set;}            
        @AuraEnabled   
        public List<IndirizzoOCS> indirizziElenco {get { if (indirizziElenco == null ) indirizziElenco = new List<IndirizzoOCS>(); return indirizziElenco; } set;}       
    }
    
    
 	public class IndirizzoOCS {
        @AuraEnabled
        public String indirizzo {get; set;}     
        @AuraEnabled
        public String localita {get; set;}    
        @AuraEnabled
        public String cap {get; set;}         
        @AuraEnabled
        public String provincia {get; set;}     
        @AuraEnabled
        public String nazione {get; set;}          
    }    
    
    

}