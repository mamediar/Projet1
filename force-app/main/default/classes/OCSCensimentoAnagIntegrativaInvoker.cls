public class OCSCensimentoAnagIntegrativaInvoker {
    

    public static OCSCensimentoAnagIntegrativaResponse callCensimentoAnagIntegrativa (String dealerId) {
		List<OCSCensimentoAnagIntegrativaRequest.ELenco> elenco=processaDati(dealerId);        
        OCSCensimentoAnagIntegrativaRequest req = new OCSCensimentoAnagIntegrativaRequest();
        req.censimentoAnagraficaIntegrativaRequest.elenco = elenco;  
        OCSCensimentoAnagIntegrativaResponse response = (OCSCensimentoAnagIntegrativaResponse) ApiUtils.callApi('ocs.censimentoAnagraficaIntegrativa', req, OCSCensimentoAnagIntegrativaResponse.class);
        system.debug('Response: ' + response);
        return response;
    }  
    
    /*public static OCSCensimentoAnagIntegrativaResponse callCensimentoAnagIntegrativa (List<OCSCensimentoAnagIntegrativaRequest.ELenco> elenco) {
		//List<OCSCensimentoAnagIntegrativaRequest.ELenco> elenco=processaDati(dealerId,collegatiIds);        
        OCSCensimentoAnagIntegrativaRequest req = new OCSCensimentoAnagIntegrativaRequest();
        req.censimentoAnagraficaIntegrativaRequest.elenco = elenco;  
        OCSCensimentoAnagIntegrativaResponse response = (OCSCensimentoAnagIntegrativaResponse) ApiUtils.callApi('ocs.censimentoAnagraficaIntegrativa', req, OCSCensimentoAnagIntegrativaResponse.class);
        system.debug('Response: ' + response);
        return response;
    }*/
    
    /*public static DatiOCS processaResponse (OCSCensimentoAnagIntegrativaResponse response) {   
        DatiOCS datiOCS = new DatiOCS();
        datiOCS.chiamataOK=true;
        if(response.censimentoAnagraficaIntegrativaResponse.elenco[0].segnala!='Anagrafica inserita CONTROLLARE MESSAGGIO!!!!!!!!!!!!'){   //risposta andata a buon fine!
            datiOCS.chiamataOK=false;
            datiOCS.message.add('-Convenzionato: '+response.censimentoAnagraficaIntegrativaResponse.elenco[0].segnala);   
        }        
		return datiOCS; 
    }*/
    
 	/*public class DatiOCS {
        @AuraEnabled
        public List<String> message {get { if (message == null ) message = new List<String>(); return message; } set;}
        @AuraEnabled
        public Boolean chiamataOK {get; set;}          
    } */   
    
    public static List<String> processaResponse (OCSCensimentoAnagIntegrativaResponse response){   
        List<String> message = new List<String>();
        if(response.isOK()){
           message.add('-Convenzionato: '+response.censimentoAnagraficaIntegrativaResponse.elenco[0].segnala); 
        } else {
           message.add(response.resultMessage);  
        }     
		return message; 
    }    
                   
    
    public static List<OCSCensimentoAnagIntegrativaRequest.ELenco> processaDati (String dealerId) {
        String deal_fatt_rich = 'F', deal_tipol = '', deal_accr_auto_fatt = '', deal_mediatore = '', deal_dest_prof = '', deal_pag_provv = '', deal_ann_prov = '', cat_provv = '';
		
        Account dealer=SFAConvenzionamento.getDealerById(dealerId);
        
        List<OCSCensimentoAnagIntegrativaRequest.ELenco> elenco = new List<OCSCensimentoAnagIntegrativaRequest.ELenco>();
        OCSCensimentoAnagIntegrativaRequest.ELenco elencoDealer = new OCSCensimentoAnagIntegrativaRequest.ELenco();

        if(dealer.Tipo_Intermediario__c=='CV' || dealer.Tipo_Intermediario__c=='SA')    
            deal_mediatore = 'N';
        
        
        List<SFA_Convenzionam_CanaleAgenti__mdt> agente=[SELECT Id, Canale__c FROM SFA_Convenzionam_CanaleAgenti__mdt WHERE Codice_agente__c=:dealer.CodiceAgente__c];
        if(agente.size()>0 && agente[0].Canale__c=='Canale Agenti'){        
            deal_tipol = 'AGN';
            deal_dest_prof = 'A';
            deal_pag_provv = 'N';
            deal_ann_prov = 'N';
            cat_provv = 'T00';   
        }

        elencoDealer.intCodice=dealer.OCS_External_Id__c.Substring(1);
        elencoDealer.intStato=dealer.Status__c;
        elencoDealer.intFiliale=dealer.Branch__r.OCS_External_Id__c.Substring(1);           
        elencoDealer.intStampaProf= String.valueof(dealer.FlagProforma__c)=='true'?'S':'N'; 		
        elencoDealer.intRsStampaProf=String.valueof(dealer.FlagProfRist__c)=='true'?'S':'N'; 			
        elencoDealer.intStampaAllProf=String.valueof(dealer.FlagAllProforma__c)=='true'?'S':'N'; 	
        elencoDealer.intRsStampaAllProf=String.valueof(dealer.FlagAllProfRist__c)=='true'?'S':'N'; 
        elencoDealer.intMacroarea=dealer.Macroarea__c;
        elencoDealer.intProdottoDom=dealer.ProdottoDominanteMacroarea__c;             		
        elencoDealer.intAbilIsvap='N';
        elencoDealer.respons='001';
        elencoDealer.codagente=dealer.CodiceAgente__c;
        elencoDealer.intAccrAutomFatt=deal_accr_auto_fatt; 
        elencoDealer.tipoint=dealer.Tipo_Intermediario__c;      
        elencoDealer.intFattRic=deal_fatt_rich;		
        elencoDealer.intTipologia=deal_tipol;     
        elencoDealer.destprof=deal_dest_prof;			
        elencoDealer.pagprovv=deal_pag_provv;		
        elencoDealer.annprov=deal_ann_prov;		
        elencoDealer.prvcatCategoria=cat_provv;    
        elencoDealer.intMediatore=deal_mediatore;	
        elencoDealer.codcomp='48';
        elencoDealer.codconv='0';
        elencoDealer.dtconv=DateUtils.formatDateYYYYMMDD(dealer.DataSegnalazione__c);                  

        elenco.add(elencoDealer); 
        
        if(!String.isEmpty(dealer.Tipo_Intermediario_2__c)){
            OCSCensimentoAnagIntegrativaRequest.ELenco elencoDealer2 = (OCSCensimentoAnagIntegrativaRequest.ELenco)JSON.deserialize(JSON.serialize(elencoDealer), OCSCensimentoAnagIntegrativaRequest.ELenco.class);
			//elencoDealer2 è una copia di elencoDealer
            if(dealer.Tipo_Intermediario__c=='CV' || dealer.Tipo_Intermediario__c=='SA') 
                deal_mediatore = 'N';
            
            if(agente.size()>0 && agente[0].Canale__c=='Canale Agenti'){
                deal_tipol = 'AGN';
                deal_dest_prof = 'A';
                deal_pag_provv = 'N';
                deal_ann_prov = 'N';
                cat_provv = 'T00';  	
            }

            elencoDealer2.tipoint=dealer.Type_Anag__c;
            elencoDealer2.intTipologia=deal_tipol;
            elencoDealer2.intMediatore=deal_mediatore;             
            elencoDealer2.destprof=deal_dest_prof;	        
            elencoDealer2.pagprovv=deal_pag_provv;			        
            elencoDealer2.annprov=deal_ann_prov;		
            elencoDealer2.prvcatCategoria=cat_provv;       
            elencoDealer2.intAccrAutomFatt=deal_accr_auto_fatt;      
            elencoDealer2.intFattRic=deal_fatt_rich;	   
            elencoDealer2.codcomp='48';     
            elencoDealer2.codconv='0';		
            elenco.add(elencoDealer2); 
   
        }
        return elenco;
    }    

    
}