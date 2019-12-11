public class SFAConvenzionamNewDealAcquisitCtrller {
	
    public static final String nomeSede = 'DCC/AV MCC';
    public static final String nomeFiliale = 'Filiale';
    
    @AuraEnabled
    public static DatiCompletaInformazioniEControlli getDealerAcquisition(String caseId) {

        DatiCompletaInformazioniEControlli datiCompletaInformazioniEControlli = new DatiCompletaInformazioniEControlli();
        datiCompletaInformazioniEControlli.sfaConvezionamentoDati = SFAConvenzionamento.getConvenzioneDati(caseId);

        String dealerAcquisitionId = datiCompletaInformazioniEControlli.sfaConvezionamentoDati.dealerId;
        System.debug('*** SFAConvenzionamNewDealAcquisitCtrller.cls | dealerAcquisitionId :: ' + dealerAcquisitionId);

        Account dealerA =[SELECT Id, MacroArea__c, ProdottoDominanteMacroarea__c  FROM Account WHERE Id = :dealerAcquisitionId];
        
        if(dealerA.MacroArea__c != '' && dealerA.MacroArea__c != null && dealerA.MacroArea__c != 'undefined'){
            datiCompletaInformazioniEControlli.MacroAr = dealerA.MacroArea__c;
        }
        if(dealerA.ProdottoDominanteMacroarea__c != '' && dealerA.ProdottoDominanteMacroarea__c != null && dealerA.ProdottoDominanteMacroarea__c != 'undefined'){
            datiCompletaInformazioniEControlli.ProdDominant=dealerA.ProdottoDominanteMacroarea__c;
        }
        datiCompletaInformazioniEControlli.lstSelectOption = getTipiAccordo(dealerAcquisitionId);
        return datiCompletaInformazioniEControlli;
	}

    @AuraEnabled
    public static List<SelectOption> getTipiAccordo(String dealerAcquisitionId) {

        List<SelectOption> lstSelectOption = new List<SelectOption>();

        SelectOption selectOption = new SelectOption('--Nessuno--', '', 'true');
        lstSelectOption.add(selectOption);
        
        String tipoAccordoNew = [SELECT Id, Tipo_Accordo_New__c FROM Account WHERE Id = :dealerAcquisitionId][0].Tipo_Accordo_New__c;

        List<dealer_accordi__c> lstTipiAccordo = 
            [SELECT Id, Name, Codice_Accordo__c, desc_accordo__c, Flag_attivo__c, is_h3g__c, is_assic__c 
             FROM dealer_accordi__c 
             WHERE Flag_attivo__c = true
             ORDER BY desc_accordo__c ASC];
        
        for (dealer_accordi__c tipoAccordo : lstTipiAccordo) {

            SelectOption so;

            if (tipoAccordo.Codice_Accordo__c != null && tipoAccordo.Codice_Accordo__c.equals(tipoAccordoNew)) {
                lstSelectOption[0].value = 'false';
                so = new SelectOption(tipoAccordo.desc_accordo__c, tipoAccordo.Codice_Accordo__c, 'true');
            }
            else {
                so = new SelectOption(tipoAccordo.desc_accordo__c, tipoAccordo.Codice_Accordo__c, 'false');
            }
            lstSelectOption.add(so);
        }
                                                                                                            
        return lstSelectOption;
    }

    @AuraEnabled
    public static SFAConvenzionamento.CategoriaEStepLavorazione getCategoriaEStepLavorazione(String caseId) {
        return SFAConvenzionamento.getCategoriaEStepLavorazione(caseId);	
	}    
    
    @AuraEnabled
    public static Assicuraz_H3G updateAssicurazione(String dealerAcquisitionId, String TipoAccordo) {
        System.debug('riga 13:: '+dealerAcquisitionId);
        Assicuraz_H3G assicuraz_H3G = new Assicuraz_H3G();
        assicuraz_H3G.assicurazione=false;
        assicuraz_H3G.h3g=false;         
		Account dealerAcquisition =[SELECT Id, IsConvenzioneH3G__c, IsConvenzioneAssicurativo__c FROM Account WHERE Id = :dealerAcquisitionId][0];
        
        List<dealer_accordi__c> codiceAssicuraz = [SELECT Id, Name, Codice_Accordo__c, desc_accordo__c, Flag_attivo__c, is_h3g__c, is_assic__c FROM dealer_accordi__c WHERE Codice_Accordo__c = :TipoAccordo];

        dealerAcquisition.Tipo_Accordo_New__c = TipoAccordo;

		System.debug('riga 31:: '+codiceAssicuraz);
        if (codiceAssicuraz.size()>0){
            assicuraz_H3G.assicurazione=codiceAssicuraz[0].is_assic__c;
            assicuraz_H3G.h3g=codiceAssicuraz[0].is_h3g__c;            
            dealerAcquisition.IsConvenzioneAssicurativo__c=codiceAssicuraz[0].is_assic__c;
            dealerAcquisition.IsConvenzioneH3G__c=codiceAssicuraz[0].is_h3g__c;
        } else {
            dealerAcquisition.IsConvenzioneAssicurativo__c=false;
            dealerAcquisition.IsConvenzioneH3G__c=false;
        }
        update dealerAcquisition;
        return assicuraz_H3G;
		
	}
    
    @AuraEnabled
    public static Boolean updateFlagProforma(String dealerAcquisitionId, String CodiceAgente ) {
        Boolean prevalorizeFlags=false;
        List<SFA_Convenzionam_CanaleAgenti__mdt> agente=[SELECT Id, Canale__c, tipo_quest__c, nome_abbr__c, Codice_agente__c FROM SFA_Convenzionam_CanaleAgenti__mdt WHERE Codice_agente__c=:CodiceAgente];
        if(agente.size()>0){
            if(agente[0].Canale__c=='Canale Agenti'){
                Account dealerAcquisition =[SELECT Id, FlagProforma__c, FlagProfRist__c, FlagAllProforma__c, FlagAllProfRist__c FROM Account WHERE Id = :dealerAcquisitionId][0];
                System.debug('riga 15:: '+dealerAcquisitionId);            
                dealerAcquisition.FlagProforma__c=null;
                dealerAcquisition.FlagProfRist__c=null;
                dealerAcquisition.FlagAllProforma__c='N';
                dealerAcquisition.FlagAllProfRist__c='N'; 
                update dealerAcquisition;
                prevalorizeFlags=true;
            }
        }
        return prevalorizeFlags;
	
	}    
    
    @AuraEnabled
    public static String segnalaErroreSalvataggio(String dealerAcquisitionId, String Type_Anag, String Tipo_Intermediario, string Macro_Area, String Prodotto_Dominante) {
        String errorMessage='0';
		Account dealerAcquisition =[SELECT Id, Forma_Giuridica__c  FROM Account WHERE Id = :dealerAcquisitionId][0];
        System.debug('riga Type_Anag__c:: '+Type_Anag);
        System.debug('riga Forma_Giuridica__c:: '+dealerAcquisition.Forma_Giuridica__c);
        System.debug('riga Tipo_Intermediario__c:: '+Tipo_Intermediario);
        if (dealerAcquisition.Forma_Giuridica__c=='DIN' && Type_Anag!='F'){
           errorMessage='Natura giuridica e tipo anagrafica del convenzionato non corrispondono.';
           System.debug('riga 34:: '+errorMessage);
        } else if(dealerAcquisition.Forma_Giuridica__c!='DIN' && !String.isEmpty(dealerAcquisition.Forma_Giuridica__c) && Type_Anag=='F'){
           errorMessage='Natura giuridica e tipo anagrafica del convenzionato non corrispondono.'; 
           System.debug('riga 37:: '+errorMessage);
        } else if(Tipo_Intermediario =='PV' && Type_Anag!='A'){   //era Type_Anag!='PV' ma noi abbiamo A anzichè PV nel tipo anagrafica
           errorMessage='Tipo accordo e tipo anagrafica del convenzionato non corrispondono.'; 
           System.debug('riga 40:: '+errorMessage);
        }
        else if(Macro_Area == null || Macro_Area ==''){
             errorMessage='Per procedere bisogna popolare il campo Macro Area.';
        }
         else if(Prodotto_Dominante == null ||Prodotto_Dominante ==''){
             errorMessage='Per procedere bisogna popolare il campo Prodotto Dominante.';
        }
        System.debug('errorMessage:: '+errorMessage);
		return errorMessage;
		
	}    
    
    
    @AuraEnabled
    public static void valutaAutonomia(String caseId, String dealerAcquisitionId,String Macro_Area, String Prodotto_Dominante) {
		Boolean autonomiaSede=false,isCollegatoResidenteEstero=false,dealerCollegatiInEsponentiBancari=false;
        String prodottoAutonomia='Filiale',dealerRagioneSociale='',dealerNome,dealerCognome,dealerCF,dealerIVA,collegatoRagioneSociale='',collegatoNome,collegatoCognome;
		Date today=Date.today(),threeYearsAgo=today.addYears(-3);
        List<String> ratingList1 = new list<String> {'C4_3', 'C4_4', 'C4_5', '9_CGS', '10_CGS','7','ROSSO F'};
        List<String> ratingList2 = new list<String> {'8_CGS', '6', 'ROSSO E'};        

        Case caseDealer=SFAConvenzionamento.getCase(caseId);    
		Account dealerAcquisition =SFAConvenzionamento.getDealerById(dealerAcquisitionId); 
		ReportCerved__c reportCerved=SFAConvenzionamento.getReport(dealerAcquisitionId);
        
        if(dealerAcquisition.Tipo_Intermediario__c!='SA'){
            if(String.IsEmpty(dealerAcquisition.FlagProforma__c) || String.IsEmpty(dealerAcquisition.FlagProfRist__c) || String.IsEmpty(dealerAcquisition.FlagAllProforma__c) || String.IsEmpty(dealerAcquisition.FlagAllProfRist__c)){
                if(String.IsEmpty(dealerAcquisition.FlagProforma__c)){
                    dealerAcquisition.FlagProforma__c='S';
                }
                if(String.IsEmpty(dealerAcquisition.FlagProfRist__c)){
                    dealerAcquisition.FlagProfRist__c='S';
                }
                if(String.IsEmpty(dealerAcquisition.FlagAllProforma__c)){
                    dealerAcquisition.FlagAllProforma__c='S';
                }
                if(String.IsEmpty(dealerAcquisition.FlagAllProfRist__c)){
                    dealerAcquisition.FlagAllProfRist__c='S';
                }
                update dealerAcquisition;            
            }
    	}
		
        List<SFA_Convenzionam_CalcoloAutonomAttivita__mdt> prodottoAutonomiaList=[SELECT Id, Autonomia__c FROM SFA_Convenzionam_CalcoloAutonomAttivita__mdt WHERE Codice_Macroarea__c=:Macro_Area AND Codice_Prodotto_Dominante__c=:Prodotto_Dominante];
        if(prodottoAutonomiaList.size()>0){
            prodottoAutonomia=prodottoAutonomiaList[0].Autonomia__c;
            if(prodottoAutonomia=='checkAccordo'){
                if(dealerAcquisition.Dealership_Code__c==null){
                    prodottoAutonomia=nomeSede;
                } else {
                    prodottoAutonomia=nomeFiliale;
                }
            }
        }
        
        //valuta se alemeno uno dei collegati risiede all'estero
        List<Contact> collegatiList=SFAConvenzionamento.getCollegati(dealerAcquisitionId);        
        for (Contact co:collegatiList){
            if(co.IsResidenteEstero__c){
                isCollegatoResidenteEstero=true;   //almeno un collegato all'estero per uscire dal ciclo ed assegnare l'autonomia alla sede
                break;
            }
        }
        
        //valuta se dealer presente nell'elenco di esponente bancari e parti correlate:
        List<Esponenti_bancari_e_parti_correlate__mdt> elencoEsponenti = new List<Esponenti_bancari_e_parti_correlate__mdt>();      
        if(dealerAcquisition.Type_Anag__c=='F'){
            dealerNome=String.isEmpty(dealerAcquisition.FirstName)?'':dealerAcquisition.FirstName;
            dealerCognome=String.isEmpty(dealerAcquisition.LastName)?'':dealerAcquisition.LastName;
            dealerRagioneSociale=dealerNome+' '+dealerCognome;
        } else {
            dealerRagioneSociale=dealerAcquisition.Name;
        }
        
        elencoEsponenti=[SELECT Id, TipoAnagrafica__c, CodiceFiscale__c, Partita_IVA__c, 
                         Cognome__c, Nome__c, Tipo_Sel__c, RagioneSociale__c 
                         FROM Esponenti_bancari_e_parti_correlate__mdt WHERE CodiceFiscale__c=:dealerAcquisition.Codice_Fiscale__c]; 
        if(elencoEsponenti.size()==0){
            elencoEsponenti=[SELECT Id, TipoAnagrafica__c, CodiceFiscale__c, Partita_IVA__c, 
                             Cognome__c, Nome__c, Tipo_Sel__c, RagioneSociale__c 
                             FROM Esponenti_bancari_e_parti_correlate__mdt WHERE RagioneSociale__c=:dealerRagioneSociale];
        }
        if(elencoEsponenti.size()==0 && dealerAcquisition.Type_Anag__c!='F'){  //il controllo sulla partita iva scatta solo se il dealer non è persona fisica
            elencoEsponenti=[SELECT Id, TipoAnagrafica__c, CodiceFiscale__c, Partita_IVA__c, 
                             Cognome__c, Nome__c, Tipo_Sel__c, RagioneSociale__c 
                             FROM Esponenti_bancari_e_parti_correlate__mdt WHERE Partita_IVA__c=:dealerAcquisition.Partita_IVA__c];                 
        }        
        if(elencoEsponenti.size()>0){
            dealerCollegatiInEsponentiBancari=true;
        }
        
		//valuta se collegati presenti nell'elenco di esponente bancari e parti correlate (solo se il dealer non lo è perchè altrimenti l'autonomia va già in sede e non c'è bisogno di ulteriore controllo dei collegati)
		List<String> collegatiRagioneSociale= new List<String>();
        List<String> collegatiCF= new List<String>();
        List<String> collegatiIVA= new List<String>();
        if(!dealerCollegatiInEsponentiBancari){   //entro nel ciclo e verifico se collegati nella lista degli esponenti bancari solo se il dealer non lo è, perchè tanto per l'autonomia basta che uno dei due sia presente nella lista
            List<Contact> collegati=SFAConvenzionamento.getCollegati(dealerAcquisitionId);  
            
            for(Contact co:collegati){
                if(co.Tipo_Anagrafica__c=='F' || co.Tipo_Anagrafica__c=='P' ){
                    System.debug('collegato fisico: '+collegatoRagioneSociale + ' cf: '+co.Codice_Fiscale__c);
                    collegatoNome=String.isEmpty(co.FirstName)?'':co.FirstName;
                    collegatoCognome=String.isEmpty(co.LastName)?'':co.LastName;
                    collegatoRagioneSociale=collegatoNome+' '+collegatoCognome;
                    
                } else {
                    System.debug('collegato giuridico: '+collegatoRagioneSociale + ' cf: '+co.Codice_Fiscale__c+' iva: '+co.Partita_IVA__c);
                    collegatoRagioneSociale=co.RagioneSociale__c ;
                    if(!String.isEmpty(co.Partita_IVA__c)){  //la partita IVA la controllo solo nel caso il collegato non sia una persona fisica o privata
                    	collegatiIVA.add(co.Partita_IVA__c);
                    }
           
                }
                if(!String.isEmpty(collegatoRagioneSociale)){
                	collegatiRagioneSociale.add(collegatoRagioneSociale);
                }
                if(!String.isEmpty(co.Codice_Fiscale__c)){
                	collegatiCF.add(co.Codice_Fiscale__c);
                }
                
                if(collegatiCF.size()>0){
                    elencoEsponenti=[SELECT Id, TipoAnagrafica__c, CodiceFiscale__c, Partita_IVA__c, 
                                     Cognome__c, Nome__c, Tipo_Sel__c, RagioneSociale__c 
                                     FROM Esponenti_bancari_e_parti_correlate__mdt WHERE CodiceFiscale__c IN:collegatiCF];                    
                }
                if(collegatiRagioneSociale.size()>0 && elencoEsponenti.size()==0){
                    elencoEsponenti=[SELECT Id, TipoAnagrafica__c, CodiceFiscale__c, Partita_IVA__c, 
                                     Cognome__c, Nome__c, Tipo_Sel__c, RagioneSociale__c 
                                     FROM Esponenti_bancari_e_parti_correlate__mdt WHERE RagioneSociale__c IN:collegatiRagioneSociale];                    
                }
                if(collegatiIVA.size()>0 && elencoEsponenti.size()==0){
                    elencoEsponenti=[SELECT Id, TipoAnagrafica__c, CodiceFiscale__c, Partita_IVA__c, 
                                     Cognome__c, Nome__c, Tipo_Sel__c, RagioneSociale__c 
                                     FROM Esponenti_bancari_e_parti_correlate__mdt WHERE Partita_IVA__c IN:collegatiIVA];                    
                }                
                if(elencoEsponenti.size()>0){
                    dealerCollegatiInEsponentiBancari=true;
                    break;
                }            
                
            }
        }        
        

        if (ratingList1.contains(reportCerved.Rating__c)){
            autonomiaSede=true;
        } else if(ratingList2.contains(reportCerved.Rating__c) &&  dealerAcquisition.DataInizioAttivita__c>=threeYearsAgo ){
			autonomiaSede=true;
        } else if (dealerAcquisition.Status_Attr__c=='IR' || dealerAcquisition.Status_Attr__c=='PN'){
            autonomiaSede=true;
        } else if( reportCerved.FinanziamentiCarteIrregolari__c == true || reportCerved.CollegatoConvenzChiusaIrregol__c == true || reportCerved.SociFiduciaria__c == true || reportCerved.SospesoPerIrregolarita__c == true  ||  reportCerved.ProtestiPregiudizievoliIpoteticheLegali__c == true ){    //||    ATTENZIONE reportCerved.ProtestiPregiudizievoliIpoteticheLegali__c == true  ALESSIO DICEVA CHE QUESTO CONTROLLO NON DOVREBBE ESISTERE PIù MA NON è RIPORTATO DA NESSUNA PARTE, L'HA DETTO SOLO A VOCE
            autonomiaSede=true;
        } else if(dealerAcquisition.IsDealerEstero__c == true){     //IMP:: AGGIUNGERE CONTROLLO SE COLLEGATO ALL'ESTERO
            autonomiaSede=true;
        } else if(prodottoAutonomia==nomeSede){
            autonomiaSede=true;
        }  else if(isCollegatoResidenteEstero){
            autonomiaSede=true;
        }  else if(dealerCollegatiInEsponentiBancari){
            autonomiaSede=true;
        }
        
        System.debug('276- prodottoAutonomia:: '+prodottoAutonomia);
        System.debug('autonomiaSede:: '+autonomiaSede);
        System.debug('dealerAcquisition:: '+dealerAcquisition);
        
        
        if(autonomiaSede){
            System.debug('@@@@@@@@@@autonomia sede');
            String dispositionExternalId;

            caseDealer=SFAConvenzionamento.utenteLavorazione(caseDealer,SFAConvenzionamento.queueAV,false);
            System.debug('""""""""""caseDealer.ShareCase__c: '+caseDealer.ShareCase__c);
            if(!String.isEmpty(caseDealer.Disposition__c)){
                dispositionExternalId=CaseUtils.getDispositionExternalId(caseDealer.Disposition__c);
            }
            if(dispositionExternalId=='DP1815'){    //AV ha chiesto informazioni aggiuntive--->allora impongo I_GIUST (invio giustificativi)
                caseDealer=CaseUtils.aggiornaDispositionCase(caseDealer,'DP1816',false);   
            } else {
                caseDealer=CaseUtils.aggiornaDispositionCase(caseDealer,'DP1810',false);
            }
            caseDealer.StepAttivitaConvenzionamento__c=SFAConvenzionamento.NDA_CompletaInfoEControlli2;
            caseDealer.IsAutonomiaConvenzionamentoSede__c=true;
            if(caseDealer.Data_Ricezione__c==null){
                caseDealer.Data_Ricezione__c =Date.today(); //data di consegna dell'attività a DCR/AV
            }
            
            caseDealer=CaseShareUtil.setStringInCaseShare(caseDealer,SFAConvenzionamento.sharingToAV);
            System.debug('@@@@@@@@@@caseDealer: '+caseDealer);
        } else {            
			caseDealer.StepAttivitaConvenzionamento__c=SFAConvenzionamento.NDA_VerificaAnagraficaECollegati;      
        }
        update caseDealer;

	}        
    
 	public class Dati {
        @AuraEnabled
        public Id dealerAcquisitionId {get; set;}
        @AuraEnabled
        public Id reportCervedId {get; set;}      
        @AuraEnabled
        public Account accountDealer {get; set;}       
    }
    
 	public class Assicuraz_H3G {
        @AuraEnabled
        public Boolean assicurazione {get; set;}
        @AuraEnabled
        public Boolean h3g {get; set;}          
    }

    public class SelectOption {

		public SelectOption(String label, String text, String value) {
			this.label = label;
			this.text = text;
			this.value = value;
		}

		@AuraEnabled
		public String label { get; set; }
		@AuraEnabled
		public String text { get; set; }
		@AuraEnabled
		public String value { get; set; }
	}

    public class DatiCompletaInformazioniEControlli {
        @AuraEnabled
        public SFAConvenzionamento.Dati sfaConvezionamentoDati {get; set;}
        @AuraEnabled
        public List<SelectOption> lstSelectOption {get; set;}
        @AuraEnabled
        public string MacroAr  {get; set;}
        @AuraEnabled
        public string ProdDominant  {get; set;}
    }
    
}