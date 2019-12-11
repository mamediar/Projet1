public class SFAConvenz_NDA_RecuperaInteseCtrller {

    @AuraEnabled
    public static SFAConvenzionamento.CategoriaEStepLavorazione getCategoriaEStepLavorazione(String caseId) {
        return SFAConvenzionamento.getCategoriaEStepLavorazione(caseId);	
	}
    
    @AuraEnabled
    public static DatiConvenzioneEIntese getIntesePDFpathEDatiConvenzione(String caseId) {
 		DatiConvenzioneEIntese datiConvenzioneEIntese= new DatiConvenzioneEIntese(); 
        SFAConvenzionamento.Dati dati = new SFAConvenzionamento.Dati();
		
        //get dati processo convenzionamento
        dati=SFAConvenzionamento.getConvenzioneDati(caseId);
        datiConvenzioneEIntese.dati=dati;
        System.debug('#########################caseAttivita: '+datiConvenzioneEIntese.dati.caseAttivita);
		
        //get intese recuperate NB: questa sarà la parte da modificare per integrare il servizio, "getInteseId" recupera le intese dall'oggetto "Convenzionamento_PDF_Massivo__c" che servono e le salva in una mappa (id, Name del template)
        //quando si integrerà il servizio, questi "name" dei template dovranno essergli passati 
        List<Convenzionamento_PDF_Massivo__c> inteseList = new List<Convenzionamento_PDF_Massivo__c>();
        inteseList = getInteseName(caseId);
        ConvenzionamentoParamFiller filler = new ConvenzionamentoParamFiller(dati.dealerInfo);
        //Base64ETemplatePDF base64ETemplatePDF = new Base64ETemplatePDF();
        
        for(Convenzionamento_PDF_Massivo__c intesa: inteseList){
            OCSDcCreaDocumentoResponse response = OCSDcCreaDocumentoInvoker.callDcCreaDocumento(intesa.Template_PDF__c, filler);
        	if(response.isOK()){
                if(response.dcCreaDocumentoResponse.documentoGenerato!=null){
                    //base64ETemplatePDF.base64PDF = response.dcCreaDocumentoResponse.documentoGenerato[0].stream;
                    datiConvenzioneEIntese.intesePDFbase64.put(intesa.Name, response.dcCreaDocumentoResponse.documentoGenerato[0].stream);
                } else {
                    datiConvenzioneEIntese.intesePDFbase64.put(intesa.Name, ''); //nel caso il base64 non sia stato recuperato, restituisco il nome dell'intesa con il base64 a vuoto
                }
            } else {
                datiConvenzioneEIntese.intesePDFbase64.put(intesa.Name, ''); //nel caso di errore del servizio, restituisco il nome dell'intesa con il base64 a vuoto
            }
        }
        return datiConvenzioneEIntese;		
	}    
    
    
    //contiene logica di recupero delle intese per il convenzionamento
	@AuraEnabled
    public static List<Convenzionamento_PDF_Massivo__c> getInteseName(String caseId) {
        
        List<Convenzionamento_PDF_Massivo__c> inteseList = new List<Convenzionamento_PDF_Massivo__c>();
        
        String codAccordo, codAgente='', canale='', activity='CONV',macroarea, queryOR='', queryElement='';
        List<String> lstPDFParticolari = new List<String>();  
        String query= 'SELECT Id, Name, Template_PDF__c, Codice_Accordo__c, Codice_Agente__c, Active_flag__c, Canale__c, Macroarea__c, Activity__c  FROM Convenzionamento_PDF_Massivo__c  WHERE Activity__c=:activity AND Active_flag__c=true ';

        Account dealer=SFAConvenzionamento.getDealer(caseId);
        codAccordo=String.isEmpty(String.valueof(dealer.Dealership_Code__c))?'':String.valueof(dealer.Dealership_Code__c);
		macroarea=String.isEmpty(dealer.Macroarea__c)?'':dealer.Macroarea__c;      
        
		queryElement=String.isEmpty(codAccordo)?'AND (':'AND (Codice_Accordo__c=:codAccordo ';        
        queryOR +=queryElement;
        queryElement=String.isEmpty(macroarea)?'':'OR Macroarea__c=:macroarea ';
        queryOR +=queryElement;
        
        if(!String.isEmpty(dealer.CodiceAgente__c)){
            codAgente=dealer.CodiceAgente__c;
            queryElement='OR Codice_Agente__c=:codAgente ';
            queryOR +=queryElement;
            List<SFA_Convenzionam_CanaleAgenti__mdt> agente=[SELECT Id, Canale__c FROM SFA_Convenzionam_CanaleAgenti__mdt WHERE Codice_agente__c=:codAgente];
            if(agente.size()>0){
                canale=agente[0].Canale__c;
                queryElement=String.isEmpty(agente[0].Canale__c)?')':'OR Canale__c=:canale)';    
                queryOR +=queryElement;
            } else {
                queryOR +=')';
            }           
        }
        
          
        queryOR=queryOR.replace('(OR ','(');
        queryOR=queryOR.replace('AND ()','');
		query +=queryOR; 
        
        System.debug('*** query :: ' + query);
        System.debug('*** activity :: ' + activity);
        System.debug('*** codAccordo :: ' + codAccordo);
        System.debug('*** codAgente :: ' + codAgente);
        
        List<Convenzionamento_PDF_Massivo__c> particularList = Database.query(query);
		
        if(particularList.size()>0){   //tiro su solo questi PDF
            return particularList;
        } 
        else {   //entro nel caso particolare di H3G, ASSICURATIVO...
            System.debug('size<0');
            if(dealer.IsConvenzioneH3G__c){
                inteseList.add(new Convenzionamento_PDF_Massivo__c(Name = 'COM348', Template_PDF__c = 'COM348'));
                inteseList.add(new Convenzionamento_PDF_Massivo__c(Name = 'COM349', Template_PDF__c = 'COM349'));
            } else if(dealer.IsConvenzioneAssicurativo__c){
                inteseList.add(new Convenzionamento_PDF_Massivo__c(Name = 'COM355', Template_PDF__c = 'COM355'));
                inteseList.add(new Convenzionamento_PDF_Massivo__c(Name = 'COM356', Template_PDF__c = 'COM356'));
            } else {
                inteseList.add(new Convenzionamento_PDF_Massivo__c(Name = 'COM140', Template_PDF__c = 'COM140'));
                inteseList.add(new Convenzionamento_PDF_Massivo__c(Name = 'COM141', Template_PDF__c = 'COM141'));
            }
            if(!String.isEmpty(dealer.Macroarea__c)){
                if(integer.valueof(dealer.Macroarea__c)==26){
                    inteseList.add(new Convenzionamento_PDF_Massivo__c(Name = 'COM532', Template_PDF__c = 'COM532'));
                	inteseList.add(new Convenzionamento_PDF_Massivo__c(Name = 'COM533', Template_PDF__c = 'COM533'));
                }                
            }

        }
        return inteseList;		
	}    


    @AuraEnabled
    public static SFAConvenzionamento.CollegatiERuoli getCollegati(String dealerId) {
        return SFAConvenzionamento.getCollegatiNonCancellatiERuoli(dealerId,false);	
	}        
   
    @AuraEnabled
    public static void salvaProvinciaECittaRilascioIDCollegato(String collegatoId, String provinciaRilascio , String luogoRilascio) {        
		Contact collegato =[SELECT Id,Luogo_Rilascio__c, Provincia_Rilascio__c 
                          FROM Contact  where id=:collegatoId][0];
        collegato.Provincia_Rilascio__c=provinciaRilascio; 
        collegato.Luogo_Rilascio__c=luogoRilascio; 
		update collegato;
        
    }    
    
    @AuraEnabled
    public static DatiChiamataOCS aggiornaDatiIDCollegatoSuOCS(String collegatoId) {
        DatiChiamataOCS datiChiamataOCS= new DatiChiamataOCS();
        datiChiamataOCS.chiamataOK=false;
        OCSVariazioneDocIdentitaResponse response = OCSVariazioneDocIdentitaInvoker.callVariazioneDocIdentita(collegatoId);	
        if(response.isOK()){   
            if(response.datiVariazioneDocIdentitaResponse.as400Status=='OK'){      //con  as400Status capisco se ha aggiornato correttamente i dati su OCS oppure mi ha restituito un errore       
              datiChiamataOCS.chiamataOK=true;
            } else {
              datiChiamataOCS.message=response.datiVariazioneDocIdentitaResponse.as400Errore;
            }           
        } else {
            datiChiamataOCS.message=response.resultMessage;  
        }                    
		return datiChiamataOCS;
	}

    @AuraEnabled
    public static OCSRecuperaTitolariEffettiviInvoker.DatiChiamataOCS valutaNextStepLavorazione(Account dealerInfo, String caseId) {
        Boolean titolareTrovatoSuOCS=false;
        Case caseAttivita = new Case(Id=caseId);
        OCSRecuperaTitolariEffettiviInvoker.DatiChiamataOCS datiChiamataOCS = new OCSRecuperaTitolariEffettiviInvoker.DatiChiamataOCS();
        if(dealerInfo.Type_Anag__c=='G'){  //anagrafica è G
            System.debug('**************anag G');
			OCSRecuperaTitolariEffettiviResponse response = OCSRecuperaTitolariEffettiviInvoker.callRecuperaTitolariEffettivi(dealerInfo.OCS_External_Id__c.Substring(1));
            datiChiamataOCS= OCSRecuperaTitolariEffettiviInvoker.processaResponse(response,dealerInfo.Id);
            if(datiChiamataOCS.chiamataOK){
                if(datiChiamataOCS.isTitolareTrovatoSuOCS && datiChiamataOCS.isTitolareTrovatoSuDB){  //titolare trovato sia su OCS che sul CRM
                    caseAttivita.StepAttivitaConvenzionamento__c=SFAConvenzionamento.NDA_VerificaAnagraficaECollegatiVisualizzaTIT;
                } else if(datiChiamataOCS.isTitolareTrovatoSuOCS && !datiChiamataOCS.isTitolareTrovatoSuDB){   //titolare trovato su OCS ma non sul CRM
                    if(dealerInfo.Tipo_Intermediario__c=='SA'){   //intermediario è un SA
                        caseAttivita.StepAttivitaConvenzionamento__c=SFAConvenzionamento.GDD_DocumentiObbligatori;   
                        caseAttivita=CaseShareUtil.emptyCaseShare(caseAttivita);
                        caseAttivita.Subject=CaseUtils.SFA_SUBJECT_GESTIONE_DOSSIER;
                        caseAttivita.Categoria_Riferimento__r = XCS_CategoriaUtil.getCategoryForExternalId(XCS_CategoriaUtil.SFA_CONVENZIONAMENTO_GESTIONE_DOSSIER_DEALER);
                    	caseAttivita=XCS_DispositionUtils.aggiungiDispositionCase(caseAttivita,XCS_DispositionUtils.NUOVO_DOSSIER);
                        caseAttivita.DataCreazioneDossier__c=datetime.now();
                    } else {   //intermediario non è un SA
                        caseAttivita.StepAttivitaConvenzionamento__c=SFAConvenzionamento.NDA_VerificaAnagraficaECollegatiIBAN;
                    }
                } else if (!datiChiamataOCS.isTitolareTrovatoSuOCS){  //titolare non trovato su OCS
                    caseAttivita.StepAttivitaConvenzionamento__c=SFAConvenzionamento.NDA_VerificaAnagraficaECollegatiNO_TIT;
                }                
            }
        } else {   //anagrafica non è G
            System.debug('**************anag non G');
            caseAttivita.StepAttivitaConvenzionamento__c=SFAConvenzionamento.GDD_DocumentiObbligatori;   
            caseAttivita=CaseShareUtil.emptyCaseShare(caseAttivita);   //per togliere la visibilità ad AV e Monitoraggio Dealer che hanno eventualmente lavorato l'attività
            caseAttivita.Subject=CaseUtils.SFA_SUBJECT_GESTIONE_DOSSIER;
            caseAttivita.Categoria_Riferimento__r = XCS_CategoriaUtil.getCategoryForExternalId(XCS_CategoriaUtil.SFA_CONVENZIONAMENTO_GESTIONE_DOSSIER_DEALER);
			caseAttivita=XCS_DispositionUtils.aggiungiDispositionCase(caseAttivita,XCS_DispositionUtils.NUOVO_DOSSIER);   
            caseAttivita.DataCreazioneDossier__c=datetime.now();
        }
        update caseAttivita;
        return datiChiamataOCS;
    }
     
 	public class DatiConvenzioneEIntese {
        @AuraEnabled
        public Map<String, String> intesePDFbase64 {get { if (intesePDFbase64 == null ) intesePDFbase64 = new Map<String, String>(); return intesePDFbase64; } set;}
        @AuraEnabled
        public SFAConvenzionamento.Dati dati {get { if (dati == null ) dati = new SFAConvenzionamento.Dati(); return dati; } set;}      
    }
    
    /*public class Base64ETemplatePDF {
        @AuraEnabled
        public String templatePDF {get; set;}
        @AuraEnabled
        public String base64PDF {get; set;}
    } */
    
 	public class DatiChiamataOCS {
        @AuraEnabled
        public Boolean chiamataOK {get; set;}
        @AuraEnabled
        public String message {get; set;}    
    }     
}