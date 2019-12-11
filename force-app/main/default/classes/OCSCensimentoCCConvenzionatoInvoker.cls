public class OCSCensimentoCCConvenzionatoInvoker {
    
    public static final String AGGIORNAMENTO_CC_OK='AGGIORNAMENTO OK';
    public static OCSCensimentoCCConvenzionatoResponse callCensimentoCCConvenzionato (List<OCSCensimentoCCConvenzionatoRequest.ELenco> elenco) {
        OCSCensimentoCCConvenzionatoRequest req = new OCSCensimentoCCConvenzionatoRequest();
        req.censimentoCCConvenzionatoRequest.elenco = elenco;  
        OCSCensimentoCCConvenzionatoResponse response = (OCSCensimentoCCConvenzionatoResponse) ApiUtils.callApi('ocs.censimentoCCConvenzionato', req, OCSCensimentoCCConvenzionatoResponse.class);
        return response;
    }
    
    
    public static OCSCensimentoCCConvenzionatoResponse callCensimentoCCConvenzionato (String iban, String intermediario, String abi, String cab, String conto, String descrizione, String liquidazione, String provvigioni, String erRvd, String agente) {
		//valutare effettivamente quali valori sono da passare
		////NB se non le passo l'iban devo però passarle abi, cab e conto. Se invece le passo l'iban l'unico opzionale che posso non passarle è il conto
        List<OCSCensimentoCCConvenzionatoRequest.ELenco> elenco = new List<OCSCensimentoCCConvenzionatoRequest.ELenco>();
        OCSCensimentoCCConvenzionatoRequest.ELenco elencoCC = new OCSCensimentoCCConvenzionatoRequest.ELenco();
        elencoCC.iban=iban;
		elencoCC.intermediario=intermediario;
        if(String.isEmpty(abi)){
            elencoCC.abi=iban.Substring(5,10);
        } else {
            elencoCC.abi=abi;
        }
        if(String.isEmpty(cab)){
            elencoCC.cab=iban.Substring(10,15);
        } else {
            elencoCC.cab=cab;
        }
        if(String.isEmpty(conto)){
            elencoCC.conto=iban.Substring(15);
        } else {
            elencoCC.conto=conto;
        }    
        elencoCC.cin=iban.Substring(4,5);
        elencoCC.descrizione=descrizione;
        elencoCC.liquidazione=liquidazione;
        elencoCC.provvigioni=provvigioni;
        elencoCC.erRvd=erRvd;
        elencoCC.agente=agente;        
        elenco.add(elencoCC);
    	return (callCensimentoCCConvenzionato(elenco));
    }
    
    
    public static DatiChiamataOCS callCensimentoCCConvenzionato (String CCSelezionatoId, String dealerId) {
        XCS_CCAccredito__c cc= [SELECT Id, ABI__c, CAB__c, ContoCorrente__c, IBAN__c, Descrizione__c, Erogazione_RVD_CO__c, Liquidazione__c, 
                                Provvigioni__c, isDeleted, iseliminato__c FROM XCS_CCAccredito__c WHERE id=:CCSelezionatoId][0];
		Account dealer= [SELECT id, OCS_External_Id__c, CodiceAgente__c FROM Account WHERE id=:dealerId][0];
        //valutare effettivamente quali valori sono da passare
		////NB se non le passo l'iban devo però passarle abi, cab e conto. Se invece le passo l'iban l'unico opzionale che posso non passarle è il conto
        List<OCSCensimentoCCConvenzionatoRequest.ELenco> elenco = new List<OCSCensimentoCCConvenzionatoRequest.ELenco>();
        OCSCensimentoCCConvenzionatoRequest.ELenco elencoCC = new OCSCensimentoCCConvenzionatoRequest.ELenco();
        elencoCC.iban=cc.IBAN__c;
		elencoCC.intermediario=dealer.OCS_External_Id__c.Substring(1);
        if(String.isEmpty(cc.ABI__c)){
            elencoCC.abi=cc.IBAN__c.Substring(5,10);
        } else {
            elencoCC.abi=cc.ABI__c;
        }
        if(String.isEmpty(cc.CAB__c)){
            elencoCC.cab=cc.IBAN__c.Substring(10,15);
        } else {
            elencoCC.cab=cc.CAB__c;
        }
        if(String.isEmpty(cc.ContoCorrente__c)){
            elencoCC.conto=cc.IBAN__c.Substring(15);
        } else {
            elencoCC.conto=cc.ContoCorrente__c;
        }        
        elencoCC.cin=cc.IBAN__c.Substring(4,5);
        elencoCC.descrizione=cc.Descrizione__c;
        elencoCC.liquidazione=cc.Liquidazione__c;
        elencoCC.provvigioni=cc.Provvigioni__c;
        elencoCC.erRvd=cc.Erogazione_RVD_CO__c;
        elencoCC.agente=dealer.CodiceAgente__c;        
        elenco.add(elencoCC);
    	return (processaResponse(callCensimentoCCConvenzionato(elenco)));
    }    
    
    public static DatiChiamataOCS processaResponse (OCSCensimentoCCConvenzionatoResponse response) {   
        DatiChiamataOCS datiChiamataOCS = new DatiChiamataOCS();
        datiChiamataOCS.chiamataOK=false;
        
        if(!response.isOK()){
            datiChiamataOCS.message=response.resultMessage;   //'Problema nella chiamata del servizio "Censimento CC Convenzionato". \n Rivolgersi al proprio amministratore di sistema.'
        } else {
            OCSCensimentoCCConvenzionatoResponse.ELenco resElenco=response.censimentoCCConvenzionatoResponse.elenco[0];
            if(response.resultMessage=='Ok' && (resElenco.segnala.contains('0032') || resElenco.segnala.contains(AGGIORNAMENTO_CC_OK))){
                datiChiamataOCS.chiamataOK=true;
            } else {
                datiChiamataOCS.message=resElenco.segnala;
            }
        }
		return datiChiamataOCS; 
    }
    
 	public class DatiChiamataOCS {
        @AuraEnabled
        public String message {get; set;}     
        @AuraEnabled
        public Boolean chiamataOK {get; set;}          
    }
    
    
    	/*//NEL CASO DI UTILIZZO DELL'ELENCO::
        public static DatiChiamataOCS processaResponse (OCSCensimentoCCConvenzionatoResponse response) {   
            DatiChiamataOCS datiChiamataOCS = new DatiChiamataOCS();
            datiChiamataOCS.chiamataOK=true;
            if(response.resultMessage!='Ok'){
                datiChiamataOCS.message.add('Problema nella chiamata del servizio "Censimento CC Convenzionato". \n Rivolgersi al proprio amministratore di sistema.');
                datiChiamataOCS.chiamataOK=false;
            } else {
                for(OCSCensimentoCCConvenzionatoResponse.ELenco resElenco:response.censimentoCCConvenzionatoResponse.elenco){
                    if(!(resElenco.segnala.contains('0032') || resElenco.segnala.contains(AGGIORNAMENTO_CC_OK))){
                        datiChiamataOCS.chiamataOK=false;
                        datiChiamataOCS.message.add(resElenco.segnala);
                    }                
                }            
                
            }
                
    
            
            return datiChiamataOCS; 
        }
        
        public class DatiChiamataOCS {
            @AuraEnabled
            public List<String> message {get { if (message == null ) message = new List<String>(); return message; } set;} 
            @AuraEnabled
            public Boolean chiamataOK {get; set;}          
        } */    
    
}