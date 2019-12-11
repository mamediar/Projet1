public class SFAConvenz_NDA_RecupInserisciTitCtroller {

    @AuraEnabled
    public static DatiDealerCollegati getDealerCollegati(String caseId ) {        
		SFAConvenzionamento.Dati dati = new SFAConvenzionamento.Dati();
        dati=SFAConvenzionamento.getConvenzioneDati(caseId);        
        DatiDealerCollegati datiDealerCollegati=new DatiDealerCollegati();
		datiDealerCollegati.dealer=dati;      
		return datiDealerCollegati;		
	} 
    
    @AuraEnabled
    public static SFAConvenzionamento.CategoriaEStepLavorazione getCategoriaEStepLavorazione(String caseId) {
        return SFAConvenzionamento.getCategoriaEStepLavorazione(caseId);	
	}    
       
    @AuraEnabled
    public static List<DatiTitolareTrovato> ricercaTitolareDatabase(String codFiscale, String OCS){
		List<DatiTitolareTrovato> datiTitolareTrovatoList = new List<DatiTitolareTrovato>();
        
        String query = 'SELECT Id, LastName, FirstName, OCS_External_Id__c, Sesso__c, Luogo_Nascita__c, Birthdate, Codice_Fiscale__c, Partita_IVA__c, Email, MailingAddress, MailingCity, MailingCountry, MailingPostalCode, MailingState, MailingStreet, RagioneSociale__c, DataInizioAttivita__c, CittaSede__c, Provincia_Nascita__c, Tipo_Anagrafica__c, IsResidenteEstero__c FROM Contact WHERE ';
        if(!String.isEmpty(codFiscale) && !String.isEmpty(OCS)){
            query += 'Codice_Fiscale__c=:codFiscale AND OCS_External_Id__c=:OCS';
        } else if(!String.isEmpty(codFiscale) && String.isEmpty(OCS)){
            query += 'Codice_Fiscale__c=:codFiscale';
        } else if(String.isEmpty(codFiscale) && !String.isEmpty(OCS)){
            query += 'OCS_External_Id__c=:OCS';
        }
        
        if(!(String.isEmpty(codFiscale) && String.isEmpty(OCS))){
            List<Contact> titolari=Database.query(query);
            String cognome,nome,CF,OCSExternalId;
            for(Contact ti:titolari){
                DatiTitolareTrovato datiTitolareTrovato = new DatiTitolareTrovato();
                cognome=String.IsEmpty(ti.LastName)?'':ti.LastName;
                nome=String.IsEmpty(ti.FirstName)?'':ti.FirstName;
                CF=String.IsEmpty(ti.Codice_Fiscale__c)?'':ti.Codice_Fiscale__c;
                OCSExternalId=String.IsEmpty(ti.OCS_External_Id__c)?'':ti.OCS_External_Id__c;
                datiTitolareTrovato.titolareDescrizione=cognome +' '+ nome +' - CF:'+CF+' -CIP:'+OCSExternalId;
                datiTitolareTrovato.titolareId=ti.Id;
                datiTitolareTrovatoList.add(datiTitolareTrovato);
            }
        }
            
        System.debug('*********datiTitolareTrovatoList:: '+datiTitolareTrovatoList);    
   		return datiTitolareTrovatoList;
        
    }
    
    @AuraEnabled
    public static OCSCensimentoAnagConvenzionatoInvoker.DatiOCStitolare salvaNuovoTitolareSuOCS(String titolareId ) { 
        System.debug('************* QUI:: '+titolareId);
     	OCSCensimentoAnagConvenzionatoResponse response = OCSCensimentoAnagConvenzionatoInvoker.callCensimentoAnagTitolare(titolareId); 		    
        OCSCensimentoAnagConvenzionatoInvoker.DatiOCStitolare datiOCS= OCSCensimentoAnagConvenzionatoInvoker.processaResponseTitolare(response, titolareId);        		    
		return datiOCS;		
	} 

	@AuraEnabled 
    public static DatiChiamataOCS salvaRuoloTitolareSuDatabaseEOCS(String dealerId, String titolareId){ 
        Boolean chiamataOK=false;
        DatiChiamataOCS datiChiamataOCS = new DatiChiamataOCS();
        //chiama servizio  
        OCSCensimTitolareConvenzionatoResponse response = OCSCensimTitolareConvenzionatoInvoker.callCensimentoTitolareConvenzionato(dealerId,titolareId);
        if(response.resultMessage=='Ok'){   // && 
              datiChiamataOCS.chiamataOK=true;
        } else {
              datiChiamataOCS.message=response.resultMessage;
        }

        //se servizio a buon fine...salvo il ruolo del collegato
        if(datiChiamataOCS.chiamataOK){
			SFAConvenzionamento.associateTitolareToDealer(dealerId,titolareId);
        } 
        
        return datiChiamataOCS;
    }
    
    @AuraEnabled
    public static void aggiornaProvinciaCittaNascitaResidenzaNewTitolare(String titolareId, String provinciaResidenzaTitolare , String cittaResidenzaTitolare, String provinciaNascitaTitolare , String cittaNascitaTitolare) {        
        Contact titolare =[SELECT Id,MailingState, MailingCity,Luogo_Nascita__c, Provincia_Nascita__c 
                          FROM Contact  where id=:titolareId][0];
 
        titolare.MailingState=provinciaResidenzaTitolare; 
        titolare.MailingCity=cittaResidenzaTitolare; 
        titolare.Luogo_Nascita__c=cittaNascitaTitolare;       
        titolare.Provincia_Nascita__c=provinciaNascitaTitolare; 
		update titolare;
        
    }
    
	@AuraEnabled
    public static void valutaNextStepLavorazione(String caseId) {
        Account dealer= SFAConvenzionamento.getDealer(caseId);
        Case caseAttivita = new Case(Id=caseId);
        if(dealer.Tipo_Intermediario__c=='SA'){
            caseAttivita.StepAttivitaConvenzionamento__c=SFAConvenzionamento.GDD_DocumentiObbligatori;   
            caseAttivita.Subject=CaseUtils.SFA_SUBJECT_GESTIONE_DOSSIER;
            caseAttivita.Categoria_Riferimento__r = XCS_CategoriaUtil.getCategoryForExternalId(XCS_CategoriaUtil.SFA_CONVENZIONAMENTO_GESTIONE_DOSSIER_DEALER);
        	caseAttivita=CaseShareUtil.emptyCaseShare(caseAttivita);
            caseAttivita=XCS_DispositionUtils.aggiungiDispositionCase(caseAttivita,XCS_DispositionUtils.NUOVO_DOSSIER);
            caseAttivita.DataCreazioneDossier__c=datetime.now();
        } else {
			caseAttivita.StepAttivitaConvenzionamento__c=SFAConvenzionamento.NDA_VerificaAnagraficaECollegatiIBAN;
		}
		update caseAttivita;        
	}     
    
    @AuraEnabled
    public static void salvaProvinciaECittaRilascioIDTitolare(String titolareId, String provinciaRilascio , String luogoRilascio) {        
		Contact titolare =[SELECT Id,Luogo_Rilascio__c, Provincia_Rilascio__c 
                          FROM Contact  where id=:titolareId][0];
        titolare.Provincia_Rilascio__c=provinciaRilascio; 
        titolare.Luogo_Rilascio__c=luogoRilascio; 
		update titolare;
        
    }

    @AuraEnabled
    public static ProvinciaCittaRilascio getProvinciaECittaRilascioIDTitolare(String titolareId) { 
        ProvinciaCittaRilascio provinciaCittaRilascio = new ProvinciaCittaRilascio();
		Contact titolare =[SELECT Id,Luogo_Rilascio__c, Provincia_Rilascio__c 
                          FROM Contact  where id=:titolareId][0];
        provinciaCittaRilascio.provinciaRilascioDocumento=titolare.Provincia_Rilascio__c;
        provinciaCittaRilascio.cittaRilascioDocumento=titolare.Luogo_Rilascio__c; 
		return provinciaCittaRilascio;
        
    }    
       
    @AuraEnabled
    public static DatiChiamataOCS aggiornaDatiIDTitolareSuOCS(String titolareId) {
        DatiChiamataOCS datiChiamataOCS= new DatiChiamataOCS();
        datiChiamataOCS.chiamataOK=false;
        OCSVariazioneDocIdentitaResponse response = OCSVariazioneDocIdentitaInvoker.callVariazioneDocIdentita(titolareId);	
        if(response.resultMessage=='Ok'){   // && 
            if(response.datiVariazioneDocIdentitaResponse.as400Status=='OK'){              
              datiChiamataOCS.chiamataOK=true;
            } else {
              datiChiamataOCS.message=response.resultMessage;  
            }           
        }                    
		return datiChiamataOCS;
	}    
       
 	public class DatiDealerCollegati {
        @AuraEnabled
        public SFAConvenzionamento.Collegati collegati {get { if (collegati == null ) collegati = new SFAConvenzionamento.Collegati(); return collegati; } set;}
        @AuraEnabled
        public SFAConvenzionamento.Dati dealer {get { if (dealer == null ) dealer = new SFAConvenzionamento.Dati(); return dealer; } set;}    
        @AuraEnabled
        public List<String> optionsTipoIntermediario2 {get { if (optionsTipoIntermediario2 == null ) optionsTipoIntermediario2 = new List<String>(); return optionsTipoIntermediario2; } set;}        
    }
    
 	public class DatiChiamataOCS {
        @AuraEnabled
        public Boolean chiamataOK {get; set;}
        @AuraEnabled
        public String message {get; set;}    
    } 

 	public class DatiTitolareTrovato {
        @AuraEnabled
        public String titolareDescrizione {get; set;}
        @AuraEnabled
        public String titolareId {get; set;}    
    }    
    
 	public class ProvinciaCittaRilascio {
        @AuraEnabled
        public String provinciaRilascioDocumento {get; set;}
        @AuraEnabled
        public String cittaRilascioDocumento {get; set;}    
    }    
    
}