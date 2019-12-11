public class OCSCensimDatiAggConvenzionatoInvoker {
    
    public static final String AGGIORNAMENTO_CC_OK='AGGIORNAMENTO OK';
    public static OCSCensimDatiAggConvenzionatoResponse callCensimentoDatiAggConvenzionato (List<OCSCensimDatiAggConvenzionatoRequest.ELenco> elenco) {
        OCSCensimDatiAggConvenzionatoRequest req = new OCSCensimDatiAggConvenzionatoRequest();
        req.censimentoDatiAggConvenzionatoRequest.elenco = elenco;  
        OCSCensimDatiAggConvenzionatoResponse response = (OCSCensimDatiAggConvenzionatoResponse) ApiUtils.callApi('ocs.censimentoDatiAggConvenzionato', req, OCSCensimDatiAggConvenzionatoResponse.class);
        return response;
    }
    
    
    public static OCSCensimDatiAggConvenzionatoResponse callCensimentoDatiAggConvenzionato (String Intermediario, String gestionePv, String gestioneVe, String destinatario, String destinatarioRappel, String pagamentoProvv, String pagamentoTerzi, String terzoDaLiquidare, String obblDocumenti, String plafond, String volumeAffari ){
        List<OCSCensimDatiAggConvenzionatoRequest.ELenco> elenco = new List<OCSCensimDatiAggConvenzionatoRequest.ELenco>();
        OCSCensimDatiAggConvenzionatoRequest.ELenco elencoDatiAgg = new OCSCensimDatiAggConvenzionatoRequest.ELenco();
		elencoDatiAgg.intermediario=intermediario;
        elencoDatiAgg.gestionePv=gestionePv;
        elencoDatiAgg.gestioneVe=gestioneVe;
        elencoDatiAgg.destinatario=destinatario;
        elencoDatiAgg.destinatarioRappel=destinatarioRappel;
        elencoDatiAgg.pagamentoProvv=pagamentoProvv;
        elencoDatiAgg.pagamentoTerzi=pagamentoTerzi;
        elencoDatiAgg.terzoDaLiquidare=terzoDaLiquidare;
        elencoDatiAgg.obblDocumenti=obblDocumenti; 
        elencoDatiAgg.plafond=plafond;
        elencoDatiAgg.volumeAffari=volumeAffari;        
        elenco.add(elencoDatiAgg);
    	return (callCensimentoDatiAggConvenzionato(elenco));
    }
    
    public static OCSCensimDatiAggConvenzionatoResponse callCensimentoDatiAggConvenzionato (String dealerId){
        List<OCSCensimDatiAggConvenzionatoRequest.ELenco> elenco = new List<OCSCensimDatiAggConvenzionatoRequest.ELenco>();
        Decimal d;
        String plafond='', volume='';
        OCSCensimDatiAggConvenzionatoRequest.ELenco elencoDatiAgg = new OCSCensimDatiAggConvenzionatoRequest.ELenco();
        Account dealer = [SELECT id, OCS_External_Id__c,Gestione_PV__c, Gestione_VE__c,Pagamento_provvigioni__c,DocumentiObbligatori__c,
                          		 DestinatarioProforma__c, DestinatarioRappel__c ,PagamentoTerzi__c ,ErogatoMese__c, TerzoDaLiquidare__c,VolumeAffari__c FROM Account WHERE Id=:dealerId][0];

        if(dealer.ErogatoMese__c!=null ){
            d= dealer.ErogatoMese__c*100;
            plafond= String.valueof(d).replace(',','.');
            plafond= plafond.replaceAll('\\p{Punct}','');
            if(plafond.equals('0.0'))
            	plafond ='';
        }
        
        if(dealer.VolumeAffari__c!=null ){
            d= dealer.VolumeAffari__c*100;
            volume= String.valueof(d).replace(',','.');
            volume= volume.replaceAll('\\p{Punct}','');
            if(volume.equals('0.0'))
            	volume ='';
        }        
        
       
        
        elencoDatiAgg.intermediario=dealer.OCS_External_Id__c.Substring(1);
        elencoDatiAgg.gestionePv=dealer.Gestione_PV__c;
        elencoDatiAgg.gestioneVe=dealer.Gestione_VE__c;
        elencoDatiAgg.destinatario=dealer.DestinatarioProforma__c;
        elencoDatiAgg.destinatarioRappel=dealer.DestinatarioRappel__c;
        elencoDatiAgg.pagamentoProvv=dealer.Pagamento_provvigioni__c;
        elencoDatiAgg.pagamentoTerzi=dealer.PagamentoTerzi__c;
        elencoDatiAgg.terzoDaLiquidare=String.valueof(dealer.TerzoDaLiquidare__c);   
        elencoDatiAgg.obblDocumenti=dealer.DocumentiObbligatori__c; 
        elencoDatiAgg.plafond=plafond;
        elencoDatiAgg.volumeAffari=volume;        
        elenco.add(elencoDatiAgg);
    	return (callCensimentoDatiAggConvenzionato(elenco));
    }    
    
    public static DatiChiamataOCS processaResponse (OCSCensimDatiAggConvenzionatoResponse response) {   
        DatiChiamataOCS datiChiamataOCS = new DatiChiamataOCS();
        datiChiamataOCS.chiamataOK=false;
        
        if(!response.isOK()){
            datiChiamataOCS.message=response.resultMessage;     //'Problema nella chiamata del servizio "Censimento Dati Aggiuntivi Convenzionato". \n Rivolgersi al proprio amministratore di sistema.';
        } else {
            OCSCensimDatiAggConvenzionatoResponse.ELenco resElenco=response.censimentoDatiAggConvenzionatoResponse.elenco[0];
            if(resElenco.segnala.contains(AGGIORNAMENTO_CC_OK)){
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

    
}