public class SFAConvenzionamento {

    //contiene logiche centralizzate per il processo

    
    
    //steps di lavorazione del processo:
    public static final String NewDealerProspect_StepIniziale = 'NewDealerProspect_StepIniziale';
    public static final String NewDealerProspect_ReportPresente = 'NewDealerProspect_ReportPresente';
    public static final String NewDealerProspect_QuickReportRichiesto = 'NewDealerProspect_QuickReportRichiesto';
    public static final String NewDealerProspect_GlobalExpertRichiesto = 'NewDealerProspect_GlobalExpertRichiesto';
    public static final String NewDealerProspect_RichiediQuickReport = 'NewDealerProspect_RichiediQuickReport';
    public static final String NewDealerProspect_RichiediGlobalExpert = 'NewDealerProspect_RichiediGlobalExpert';
    public static final String NewDealerProspect_DealerInIscrizione = 'NewDealerProspect_DealerInIscrizione';
    public static final String NewDealerProspect_VerificaDati = 'NewDealerProspect_VerificaDati';
    public static final String NewDealerProspect_EsitaCase = 'NewDealerProspect_EsitaCase';   
    public static final String NDA_CompletaInfoEControlli1 = 'NewDealerAcquisition_CompletaInfoEControlli1';
    public static final String NDA_CompletaInfoEControlli2 = 'NewDealerAcquisition_CompletaInfoEControlli2';
    public static final String NDA_CompletaInfoEControlli3 = 'NewDealerAcquisition_CompletaInfoEControlli3';
    public static final String NDA_CompletaInfoEControlli4 = 'NewDealerAcquisition_CompletaInfoEControlli4';
    public static final String NDA_FormInizialeAV = 'NewDealerAcquisition_FormInizialeAV';
    public static final String NDA_FormInizialeMD = 'NewDealerAcquisition_FormInizialeMD'; 
    public static final String NDA_VerificaAnagraficaECollegati = 'NewDealerAcquisition_VerificaAnagraficaECollegati'; 
    public static final String NDA_InteseEDocumenti = 'NewDealerAcquisition_InteseEDocumenti';
    public static final String NDA_VerificaAnagraficaECollegatiNO_TIT = 'NewDealerAcquisition_VerificaAnagraficaECollegatiNO_TIT';    //schermata dove è possibile ricercare titolare nel database, oppure inserirne uno nuovo
    public static final String NDA_VerificaAnagraficaECollegatiVisualizzaTIT = 'NewDealerAcquisition_VerificaAnagraficaECollegatiVisualizzaTIT';  //schermata in cui viene mostrato il titolare recuperato da OCS
    public static final String NDA_VerificaAnagraficaECollegatiIBAN = 'NewDealerAcquisition_VerificaAnagraficaECollegatiIBAN';
    public static final String GDD_DocumentiObbligatori = 'GestioneDossierDealer_DocumentiObbligatori';
    public static final String GDD_DocumentiCollegati = 'GestioneDossierDealer_DocumentiCollegati';
    public static final String GDD_DocumentiAddizionali = 'GestioneDossierDealer_DocumentiAddizionali';
    public static final String GDD_RiepilogoDocumentiMancanti = 'GestioneDossierDealer_RiepilogoDocumentiMancanti';
    public static final String GDD_StampaCover = 'GestioneDossierDealer_StampaCover';
    public static final String GAD_DocumentiObbligatori = 'GestioneAccolloDealer_DocumentiObbligatori';
    public static final String GAD_DocumentiAddizionali = 'GestioneAccolloDealer_DocumentiAddizionali';
    public static final String GAD_RiepilogoDocumentiMancanti = 'GestioneAccolloDealer_RiepilogoDocumentiMancanti';
    public static final String GAD_StampaCover = 'GestioneAccolloDealer_StampaCover'; 
    public static final String queueAV = 'Q500';
    public static final String queueMD = 'Q502';
    public static final String sharingToAV = 'ConvenzionamentoToAV';   //per il share del case ad AV
    public static final String sharingToMD = 'ConvenzionamentoToMD';   //per il share del case a Monitoraggio Dealer
    public static final String sharingToIDM = 'ConvenzionamentoToIDM';  //per il share del case durante Gestione Dossier con IDM
    
    //testo note eventi
    public static final String TITLE_NOTE_EVENTO='Evento';
    public static final String NOTA_EVENTO_DOSSIER_COMPLETAMENTOFILIALE='Completato filiale.';
    public static final String NOTA_EVENTO_DOSSIER_INIZIOFILIALE='Lavorazione filiale.';
    public static final String NOTA_EVENTO_DOSSIER_COMPLETAMENTOIDM='Completato IDM.';
    public static final String NOTA_EVENTO_DOSSIER_RICONSEGNATOFILIALE='Riconsegnato alla filiale.';
    public static final String NOTA_EVENTO_DOSSIER_RITIROIDM_SMISTAMENTO='Ricevuto da IDM – Smistamento.';
    public static final String NOTA_EVENTO_DOSSIER_RITIROIDM_POSTA='Ritirato da IDM presso Uff. Posta Compass.';
    

    public static final String NOTA_EVENTO_ACCOLLO_COMPLETAMENTOFILIALE='Completato filiale.';
    public static final String NOTA_EVENTO_ACCOLLO_INIZIOFILIALE='Lavorazione filiale.';
    public static final String NOTA_EVENTO_ACCOLLO_COMPLETAMENTOIDM='Completato IDM.';
    public static final String NOTA_EVENTO_ACCOLLO_RICONSEGNATOFILIALE='Riconsegnato alla filiale.';
    public static final String NOTA_EVENTO_ACCOLLO_RITIROIDM_SMISTAMENTO='Ricevuto da IDM – Smistamento.';
    public static final String NOTA_EVENTO_ACCOLLO_RITIROIDM_POSTA='Ritirato da IDM presso Uff. Posta Compass.';
    
  //ruoli collegati:
  public static final String titolareEffettivo='TI';
    
    public static Dati getConvenzioneDati(String caseId) {
    Dati dati = new Dati();

    Case caseAttivita =getCase(caseId);
        dati.caseAttivita=caseAttivita;
        dati.dealerId=caseAttivita.AccountId;
        dati.OCSExternalFiliale=caseAttivita.OCSExternalFilialeConvenzionato__c;
         
        ReportCerved__c report=getReport(dati.dealerId);
        dati.reportCervedId=report.Id;
        dati.reportFileId=report.FileId__c;        

        dati.dealerInfo=getDealer(caseAttivita.Id);
        
        dati.contactDiRiferimentoId=getContactDiRiferimentoDealer(dati.dealerId).Id;

        if(!String.isEmpty(caseAttivita.Disposition__c)){
            dati.disposition=XCS_DispositionUtils.getDisposition(caseAttivita.Disposition__c);
        }
        dati.recordTypeId=RecordTypeUtil.getDealerRecordType();
        
    return dati;    
  }
    
    public static Case getCase(String caseId){
        return [SELECT Id, AccountId, Disposition__c, ShareCase__c, OCSExternalFilialeConvenzionato__c, OwnerId, ActivityType__c, 
               StepAttivitaConvenzionamento__c, Categoria_Riferimento__c, Utente_Lavorazione__c, 
                IsAutonomiaConvenzionamentoSede__c,IsMDCoinvoltoInAttivitaConvenzionamento__c, CategoriaExternalId__c,Data_Ricezione__c,
                DataTermineLavoro__c, Owner_User__c, DataCreazioneDossier__c
                FROM Case 
                WHERE Id = :caseId][0];
    }
    
    public static Id getCaseIdFromDossier(String dossierId){
        return [SELECT Id, IdAttivita__c FROM Dossier__c WHERE Id=:dossierId][0].Id;
    }

    public static String getDispositionExternalIdFromDossier(String dossierId){
        Id caseId=getCaseIdFromDossier(dossierId);
        Case caseAttivita=getCase(caseId);
        return XCS_DispositionUtils.getDispositionExternalId(caseAttivita.Disposition__c);
    }    

    public static Dati getCCDati(String caseId) {
        System.debug('****getCCDati');
    Dati dati = new Dati();
    dati=getConvenzioneDati(caseId);

        List<XCS_CCAccredito__c> CCList = [SELECT Id, ABI__c, CAB__c, ContoCorrente__c, IBAN__c, Descrizione__c, Erogazione_RVD_CO__c, Liquidazione__c, 
                                Provvigioni__c FROM XCS_CCAccredito__c WHERE AccountId__c=:dati.dealerId AND IsEliminato__c=false];
        if(CCList.size()>0){
            dati.contiCorrenteList=CCList;
        }

    return dati;    
  }      
    
    public static Account getDealer(String caseId) {

    Case caseAttivita = [SELECT Id, AccountId, Disposition__c, OCSExternalFilialeConvenzionato__c, OwnerId 
                             FROM Case 
                             WHERE Id = :caseId][0];
        
    return getDealerById(caseAttivita.AccountId);
    
  }   
    
     public static Dossier__c  getDossierFromCase(String caseId) { 
        return [SELECT Id, Name, IdAttivita__c,  NumeroRiferimento__c, DataRiferimento__c, Tipo__c,
                IsDocumentiNonManipolati__c, IsDocumentiCompleti__c, Note__c, DataCompletamentoFiliale__c
                FROM Dossier__c WHERE IdAttivita__c=:caseId ][0];    
  } 
    
     public static Dossier__c  getDossier(String dossierId) { 
        return [SELECT Id, Name, IdAttivita__c, NumeroRiferimento__c, DataRiferimento__c, Tipo__c,
                IsDocumentiNonManipolati__c, IsDocumentiCompleti__c, IsDossierReinviato__c, DataCompletamentoFiliale__c, NumeroAllegati__c
                FROM Dossier__c WHERE Id=:dossierId ][0];    
  }
      public static Dossier__c  getIdAccollo_Dossier_ByCase(String CaseId) { 
        return [SELECT Id FROM Dossier__c WHERE IdAttivita__c=:CaseId ][0];    
  }  
    
    public static List<SFADossierDocumento__c> getDossierDocumenti(String caseId) { 
        Dossier__c dossier=getDossier(caseId);
    return getDossierDocumenti(caseId,dossier);    
  }   
    
    public static List<SFADossierDocumento__c> getDossierDocumenti(String caseId, Dossier__c dossier) { 
    String dossierId=dossier.Id;
    return [SELECT Id, Name, Dossier__c, SFAConvenzDealerDocumentsList__c, Collegato__c, IsDocumentoSelezionato__c, 
                                                  DocumentType__c, Document__c, TipoConv__c, NomeCollegato__c, 
                                                  DocumentDetails__c, RispostaDocumentiAddizionali__c, NumeroAllegati__c FROM SFADossierDocumento__c 
                                                WHERE Dossier__c=:dossierId AND Rimozione_Logica__c = false AND IsDocumentoSelezionato__c = true];    
  }
    public static List<SFADossierDocumento__c> getDocumentiList (List<SFADossierDocumento__c> documentiDossList){
    
    	Map<Id, Id> MapDocASingolo = new Map<Id, Id>();
    	List<SFADossierDocumento__c> IdDocList = New List<SFADossierDocumento__c>();
        
    for(SFADossierDocumento__c dosDoc : documentiDossList)
    {	
        if(MapDocASingolo.isEmpty()){
        	MapDocASingolo.put(dosDoc.SFAConvenzDealerDocumentsList__c,dosDoc.id);
        	IdDocList.add(dosDoc);
        }
        else if(!MapDocASingolo.containsKey(dosDoc.SFAConvenzDealerDocumentsList__c)){
            MapDocASingolo.put(dosDoc.SFAConvenzDealerDocumentsList__c,dosDoc.id);
        	IdDocList.add(dosDoc);
        }
        else{
            System.debug('Doc NON TROVATO');
        }
    }
     
    return IdDocList;
        
    }
    
    public static List<SFADossierDocumento__c> getDossierDocumento(String dossierDocumentoId) { 
    return [SELECT Id, Name, Dossier__c, SFAConvenzDealerDocumentsList__c, Collegato__c, IsDocumentoSelezionato__c, 
                                                  DocumentType__c, Document__c, TipoConv__c, NomeCollegato__c, 
                                                  DocumentDetails__c, RispostaDocumentiAddizionali__c, NumeroAllegati__c FROM SFADossierDocumento__c 
                                                WHERE Id=:dossierDocumentoId AND Rimozione_Logica__c = false];    
  }   
    
    @AuraEnabled
    public static CategoriaEStepLavorazione getCategoriaEStepLavorazione(String caseId) {
    CategoriaEStepLavorazione categoriaEStepLavorazione= new CategoriaEStepLavorazione();
    Case caseAttivita = [SELECT Id, AccountId, CategoriaExternalId__c, StepAttivitaConvenzionamento__c
                             FROM Case 
                             WHERE Id = :caseId][0];
        categoriaEStepLavorazione.categoria=caseAttivita.CategoriaExternalId__c;
        categoriaEStepLavorazione.stepLavorazione=caseAttivita.StepAttivitaConvenzionamento__c;
    return categoriaEStepLavorazione;  
  }     
    
    public static Account getDealerById(String dealerId) {
        
    return [SELECT id, CodiceAgente__c, Dealership_Code__c, Macroarea__c , IsConvenzioneAssicurativo__c, IsConvenzioneH3G__c, 
                Tipo_Intermediario__c , Tipo_Intermediario_2__c, Name, COD_Ateco__c, Partita_IVA__c, Type_Anag__c, Codice_Fiscale__c, 
                Forma_Giuridica__c, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, Sae__c, Rae__c,
                OCS_External_Id__c, Status__c, Branch__r.OCS_External_Id__c, FlagProforma__c, 
                FlagProfRist__c, FlagAllProforma__c, FlagAllProfRist__c, ProdottoDominanteMacroarea__c, DataSegnalazione__c,
                DataInizioAttivita__c, Status_Attr__c,IsDealerEstero__c, FirstName, LastName
                FROM Account 
                WHERE id=:dealerId][0];    //aggiungere tutti i campi che si necessita avere
        
  }    
    
    public static ReportCerved__c getReport(String dealerId) {
        return [SELECT Id, DealerId__c, IsReportValido__c, FileId__c,Rating__c, FinanziamentiCarteIrregolari__c, CollegatoConvenzChiusaIrregol__c, 
                SociFiduciaria__c, SospesoPerIrregolarita__c, ProtestiPregiudizievoliIpoteticheLegali__c FROM ReportCerved__c WHERE IsReportValido__c=true AND DealerId__c=:dealerId][0];    
  }
    
    public static Contact getContactDiRiferimentoDealer(String dealerAccountId) {
    return  [SELECT Id, AccountId, Phone, Fax, MobilePhone, Email, Sesso__c, Birthdate, Luogo_Nascita__c, Provincia_Nascita__c, LastName, FirstName 
                FROM Contact 
                WHERE AccountId = :dealerAccountId AND IsContactDiRiferimentoDealer__c =true][0];       
    }
    
    public static List<Contact> getCollegati(String dealerAccountId) {
        System.debug('dealerAccountId:: '+dealerAccountId);
        List <AccountContactRelation> accountContactList = [SELECT Id, AccountId, ContactId, Roles, isCollegatoFirmatario__c, isCollegatoRappresentante__c  FROM AccountContactRelation WHERE AccountId=:dealerAccountId];
        List<Contact> collegatiList= new List<Contact>();
        if(accountContactList.size()>0){
            Set<Id> accountContactIds = new Set<Id>();  
            for(AccountContactRelation ac:accountContactList){  
                accountContactIds.add(ac.ContactId);  
            }
            collegatiList = [SELECT Id, LastName, FirstName, OCS_External_Id__c, Sesso__c, Luogo_Nascita__c, Birthdate, Codice_Fiscale__c, Partita_IVA__c, 
                                           Email, MailingAddress, MailingCity, MailingCountry, MailingPostalCode, MailingState, MailingStreet, RagioneSociale__c, 
                                           DataInizioAttivita__c, CittaSede__c, Provincia_Nascita__c, Tipo_Anagrafica__c, IsResidenteEstero__c 
                                           FROM Contact 
                                           WHERE id IN: accountContactIds AND IsContactDiRiferimentoDealer__c=false];              
        }   
        System.debug('collegatiList:: '+collegatiList);
    return collegatiList; 
  }    
    
    public static List<String> getCollegatiIds(String dealerAccountId) {
        List<Contact> collegati = getCollegati(dealerAccountId);
        List<String> collegatiIds= new List<String>();
        for(Contact co:collegati){
            collegatiIds.add(co.Id);
        }
        return collegatiIds;
  }
    
    public static List<Contact> getCollegatiNonCancellati(String dealerAccountId, List<String> ruoli) {

        String query = 'SELECT Id, AccountId, ContactId, Roles, isCollegatoFirmatario__c, isCollegatoRappresentante__c  FROM AccountContactRelation WHERE AccountId=:dealerAccountId AND isCollegatoEliminato__c=false AND Roles includes (';
        
        for(String ruolo : ruoli)
            query += +'\''+ ruolo + +'\',';
        query = query.removeEnd(',') +')';

        List <AccountContactRelation> accountContactList = (List <AccountContactRelation>)Database.query(query);

       Set<Id> accountContactIds = new Set<Id>();  
        for(AccountContactRelation ac:accountContactList){  
            accountContactIds.add(ac.ContactId);  
        }
    List<Contact> collegatiList = [SELECT Id, LastName, FirstName, OCS_External_Id__c, Sesso__c, Luogo_Nascita__c, Birthdate, Codice_Fiscale__c, Partita_IVA__c, 
                                       Email, MailingAddress, MailingCity, MailingCountry, MailingPostalCode, MailingState, MailingStreet, RagioneSociale__c, 
                                       DataInizioAttivita__c, CittaSede__c, Provincia_Nascita__c, Tipo_Anagrafica__c, IsResidenteEstero__c, HomePhone, MobilePhone 
                                        FROM Contact 
                                       WHERE id IN: accountContactIds AND IsContactDiRiferimentoDealer__c=false];
        
        return collegatiList;        
    }
    
    public static List<Contact> getCollegatiNonCancellati(String dealerAccountId, Boolean perOCS) {
        System.debug('dealerAccountId:: '+dealerAccountId);
        List <AccountContactRelation> accountContactList = new List <AccountContactRelation>();
        Boolean found;
        List<String> lstRolesCollegato= new List<String>();
        if(perOCS){
            List<String> rolesListOCS = new list<String> {'FIR', 'RPP', 'LGR', 'REF', 'COM', 'SOC', 'SOA', 'SON', 'SOU', 'SOR', 'TIT', 'AUN', 'TI'};
            List <AccountContactRelation> accountContacts = [SELECT Id, AccountId, ContactId, Roles, isCollegatoFirmatario__c, isCollegatoRappresentante__c  
                                                                FROM AccountContactRelation 
                                                                WHERE AccountId=:dealerAccountId AND isCollegatoEliminato__c=false];
            for(AccountContactRelation acc:accountContacts){
                found=false;
                String roles=acc.Roles;
                System.debug('*** Role: '+ roles);
                if(!String.IsEmpty(roles)){
                    if(roles.contains(',')){
                        lstRolesCollegato= roles.split(',');
                    } else {
                        lstRolesCollegato.add(roles);
                    }
                }
                //lstRolesCollegato= acc.Roles.split(',');
                for(String role:lstRolesCollegato){
                    if(!found && rolesListOCS.contains(role)){
                        accountContactList.add(acc);
                        found=true;
                    }
                }
            }
        } else {
            accountContactList = [SELECT Id, AccountId, ContactId, Roles, isCollegatoFirmatario__c, isCollegatoRappresentante__c  
                                                                FROM AccountContactRelation 
                                                                WHERE AccountId=:dealerAccountId AND isCollegatoEliminato__c=false];            
        }
        
       Set<Id> accountContactIds = new Set<Id>();  
        for(AccountContactRelation ac:accountContactList){  
            accountContactIds.add(ac.ContactId);  
        }
    List<Contact> collegatiList = [SELECT Id, LastName, FirstName, OCS_External_Id__c, Sesso__c, Luogo_Nascita__c, Birthdate, Codice_Fiscale__c, Partita_IVA__c, 
                                       Email, MailingAddress, MailingCity, MailingCountry, MailingPostalCode, MailingState, MailingStreet, RagioneSociale__c, 
                                       DataInizioAttivita__c, CittaSede__c, Provincia_Nascita__c, Tipo_Anagrafica__c, IsResidenteEstero__c, HomePhone, MobilePhone 
                                        FROM Contact 
                                       WHERE id IN: accountContactIds AND IsContactDiRiferimentoDealer__c=false];
        
        return collegatiList;
    }


    public static List<String> getCollegatiNonCancellatiExternalIds(String dealerAccountId, Boolean perOCS) {
        List<Contact> collegati = getCollegatiNonCancellati(dealerAccountId, perOCS);
        List<String> collegatiExternalIds= new List<String>();
        for(Contact co:collegati){
            collegatiExternalIds.add(co.OCS_External_Id__c);
        }
        return collegatiExternalIds;
  }
    
    public static CollegatiERuoli getCollegatiNonCancellatiERuoli(String dealerAccountId, Boolean perOCS) {
        System.debug('dealerAccountId:: '+dealerAccountId);
        List<AccountContactRelation> accountContactList = new List<AccountContactRelation>();
        if(perOCS){
            List<String> rolesListOCS = new list<String> {'FIR', 'RPP', 'LGR', 'REF', 'COM', 'SOC', 'SOA', 'SON', 'SOU', 'SOR', 'TIT', 'AUN', 'TI'};
            accountContactList = [SELECT Id, AccountId, ContactId, Roles, isCollegatoFirmatario__c, isCollegatoRappresentante__c  
                                                                FROM AccountContactRelation 
                                                                WHERE AccountId=:dealerAccountId AND isCollegatoEliminato__c=false AND Roles IN: rolesListOCS];
        } else {
            accountContactList = [SELECT Id, AccountId, ContactId, Roles, isCollegatoFirmatario__c, isCollegatoRappresentante__c  
                                                                FROM AccountContactRelation 
                                                                WHERE AccountId=:dealerAccountId AND isCollegatoEliminato__c=false];                        
        }
            
            
        Set<Id> accountContactIds = new Set<Id>();  
        for(AccountContactRelation ac:accountContactList){  
            accountContactIds.add(ac.ContactId);  
        }
    List<Contact> collegatiList = [SELECT Id, LastName, FirstName, OCS_External_Id__c, Sesso__c, Luogo_Nascita__c, Provincia_Nascita__c, Birthdate, Codice_Fiscale__c, Partita_IVA__c, 
                                       Email, MailingAddress, MailingCity, MailingCountry, MailingPostalCode, MailingState, MailingStreet, RagioneSociale__c, 
                                       DataInizioAttivita__c, CittaSede__c, Tipo_Anagrafica__c, IsResidenteEstero__c, Luogo_Rilascio__c, Provincia_Rilascio__c 
                                        FROM Contact 
                                       WHERE id IN: accountContactIds AND IsContactDiRiferimentoDealer__c=false];              
        
        CollegatiERuoli collegatiERuoliList= new CollegatiERuoli();
        List<CollegatoERuoloObject> collegatiERuolo= new List<CollegatoERuoloObject>(); 
        set<String> ruoli= new set<String>(); 
        for (Contact co:collegatiList){
            CollegatoERuoloObject collegatoERuolo= new CollegatoERuoloObject();
            collegatoERuolo.contactCollegato=co;
            for(AccountContactRelation acc:accountContactList){
                if(acc.ContactId==co.Id){
                    collegatoERuolo.Ruolo=acc.Roles;
                    ruoli.add(acc.Roles);
                    break;
                }
            }
            collegatiERuolo.add(collegatoERuolo);           
        }
        collegatiERuoliList.collegati=collegatiERuolo;
        collegatiERuoliList.ruoli=ruoli;    

        System.debug('***** SFACONVENZIONAMENTO collegatiERuoliList:: '+collegatiERuoliList);
    return collegatiERuoliList; 

  }    
    
    
    public static CollegatiERuoli getCollegatiNonCancellatiERuoliPerOCS(String dealerAccountId) {
        System.debug('dealerAccountId:: '+dealerAccountId);
        List<String> rolesListOCS = new list<String> {'FIR', 'RPP', 'LGR', 'REF', 'COM', 'SOC', 'SOA', 'SON', 'SOU', 'SOR', 'TIT', 'AUN', 'TI'};
        List<AccountContactRelation> accountContactList = [SELECT Id, AccountId, ContactId, Roles, isCollegatoFirmatario__c, isCollegatoRappresentante__c  
                                                               FROM AccountContactRelation 
                                                               WHERE AccountId=:dealerAccountId AND isCollegatoEliminato__c=false];
        Set<Id> accountContactIds = new Set<Id>();  
        for(AccountContactRelation ac:accountContactList){  
            accountContactIds.add(ac.ContactId);  
        }
    List<Contact> collegatiList = [SELECT Id, LastName, FirstName, OCS_External_Id__c, Sesso__c, Luogo_Nascita__c, Provincia_Nascita__c, Birthdate, Codice_Fiscale__c, Partita_IVA__c, 
                                       Email, MailingAddress, MailingCity, MailingCountry, MailingPostalCode, MailingState, MailingStreet, RagioneSociale__c, 
                                       DataInizioAttivita__c, CittaSede__c, Tipo_Anagrafica__c, IsResidenteEstero__c, Luogo_Rilascio__c, Provincia_Rilascio__c 
                                        FROM Contact 
                                       WHERE id IN: accountContactIds AND IsContactDiRiferimentoDealer__c=false];              
        
        CollegatiERuoli collegatiERuoliList= new CollegatiERuoli();
        List<CollegatoERuoloObject> collegatiERuolo= new List<CollegatoERuoloObject>(); 
        set<String> ruoli= new set<String>(); 
        for (Contact co:collegatiList){
            
            //collegatoERuolo.contactCollegato=co;
            for(AccountContactRelation acc:accountContactList){
                if(acc.ContactId==co.Id){
          List<String> lstRoles = acc.Roles.split(',');
                    for(String role:lstRoles){  //per ogni ruolo inserisco una nuova riga con il contactCollegato e il ruolo
                        if(rolesListOCS.contains(role)){  //il collegato viene passato solo se il ruolo è contenuto nella lista da passare ad OCS
                            CollegatoERuoloObject collegatoERuolo= new CollegatoERuoloObject();
                            collegatoERuolo.contactCollegato=co;
                            collegatoERuolo.Ruolo=role;
                            ruoli.add(role);
              collegatiERuolo.add(collegatoERuolo);                                 
            }
                    }
                    break;
                }
            }
            //collegatiERuolo.add(collegatoERuolo);           
        }
        collegatiERuoliList.collegati=collegatiERuolo;
        collegatiERuoliList.ruoli=ruoli;    

        System.debug('***** SFACONVENZIONAMENTO collegatiERuoliList:: '+collegatiERuoliList);
    return collegatiERuoliList; 

  }    

 
    public static List<CollegatiObject> getCollegatiERuolo(String dealerAccountId) {
        //Collegati collegatiList= new Collegati();
        List<CollegatiObject> collegatiList= new List<CollegatiObject>();
        //collegati SOCI:
        List <AccountContactRelation> accountContactList = [SELECT Id, AccountId, ContactId, Roles, isCollegatoEliminato__c, 
                                                                isCollegatoFirmatario__c, isCollegatoRappresentante__c FROM AccountContactRelation WHERE AccountId=:dealerAccountId];
       Set<Id> accountContactIds = new Set<Id>();  
        Map < Id, AccountContactRelation > accountContactRelationMap = new Map < Id, AccountContactRelation >();
        for(AccountContactRelation ac:accountContactList){  
            accountContactIds.add(ac.ContactId);   
            accountContactRelationMap.put(ac.ContactId,ac);
        }
                        
    List<Contact> collegati = [SELECT Id, LastName, FirstName, OCS_External_Id__c, Sesso__c, Luogo_Nascita__c, Provincia_Nascita__c, Birthdate, Codice_Fiscale__c, Email,
                                       MailingAddress, MailingCity, MailingCountry, MailingPostalCode, MailingState, MailingStreet, Tipo_Anagrafica__c
                                        FROM Contact 
                                       WHERE id IN: accountContactIds AND IsContactDiRiferimentoDealer__c=false];         
        
        
        System.debug('collegatiList:: '+collegatiList);
        
        for (Contact co:collegati ){    
            CollegatiObject collegatiRow = new CollegatiObject();
            collegatiRow.contactCollegato=co;
            collegatiRow.accountContactCollegato=accountContactRelationMap.get(co.id);
            collegatiList.add(collegatiRow);
        }
               

    return collegatiList; 
  }    
    
    /*public static Collegati getCollegatiSociENon(String dealerAccountId) {
        Collegati collegatiList= new Collegati();
        String socioCode='SOC';
        //collegati SOCI:
        List <AccountContactRelation> accountContactSociList = [SELECT Id, AccountId, ContactId, Roles, isCollegatoEliminato__c, 
                                                                isCollegatoFirmatario__c, isCollegatoRappresentante__c FROM AccountContactRelation WHERE AccountId=:dealerAccountId AND Roles=:socioCode];
       Set<Id> accountContactSociIds = new Set<Id>();  
        Map < Id, AccountContactRelation > accountContactRelationSociMap = new Map < Id, AccountContactRelation >();
        for(AccountContactRelation ac:accountContactSociList){  
            accountContactSociIds.add(ac.ContactId);   
            accountContactRelationSociMap.put(ac.ContactId,ac);
        }
                        
    List<Contact> collegatiSociList = [SELECT Id, LastName, FirstName, OCS_External_Id__c, Sesso__c, Luogo_Nascita__c, Provincia_Nascita__c, Birthdate, Codice_Fiscale__c, Email,
                                       MailingAddress, MailingCity, MailingCountry, MailingPostalCode, MailingState, MailingStreet, Tipo_Anagrafica__c
                                        FROM Contact 
                                       WHERE id IN: accountContactSociIds AND IsContactDiRiferimentoDealer__c=false];         
        
        
        System.debug('collegatiSociList:: '+collegatiSociList);
        
        for (Contact co:collegatiSociList ){    
            CollegatiObject collegatiRow = new CollegatiObject();
            collegatiRow.contactCollegato=co;
            collegatiRow.accountContactCollegato=accountContactRelationSociMap.get(co.id);
            collegatiList.collegatiSoci.add(collegatiRow);
        }
               
        //collegati NON SOCI:
        List <AccountContactRelation> accountContactNonSociList = [SELECT Id, AccountId, ContactId, Roles, isCollegatoEliminato__c, isCollegatoFirmatario__c, isCollegatoRappresentante__c FROM AccountContactRelation WHERE AccountId=:dealerAccountId AND Roles!=:socioCode];
       Set<Id> accountContactNonSociIds = new Set<Id>();  
        Map < Id, AccountContactRelation > accountContactRelationMap = new Map < Id, AccountContactRelation >();
        for(AccountContactRelation ac:accountContactNonSociList){  
            accountContactNonSociIds.add(ac.ContactId);   
            accountContactRelationMap.put(ac.ContactId,ac);
        }
                        
    List<Contact> collegatiNonSociList = [SELECT Id, LastName, FirstName, OCS_External_Id__c, Sesso__c, Luogo_Nascita__c, Provincia_Nascita__c, Birthdate, Codice_Fiscale__c, Email,
                                       MailingAddress, MailingCity, MailingCountry, MailingPostalCode, MailingState, MailingStreet, Tipo_Anagrafica__c
                                        FROM Contact 
                                       WHERE id IN: accountContactNonSociIds AND IsContactDiRiferimentoDealer__c=false];                 
        
        System.debug('collegatiNonSociList:: '+collegatiNonSociList);

        for (Contact co:collegatiNonSociList ){    
            CollegatiObject collegatiRow = new CollegatiObject();
            collegatiRow.contactCollegato=co;
            collegatiRow.accountContactCollegato=accountContactRelationMap.get(co.id);
            collegatiList.collegatiNonSoci.add(collegatiRow);
        }

    return collegatiList; 
  }*/
    
    
    public static Id getTitolareId(String dealerAccountId) {
        System.debug('dealerAccountId:: '+dealerAccountId);
        List <AccountContactRelation> accountContactList = [SELECT Id, AccountId, ContactId, Roles, isCollegatoFirmatario__c, isCollegatoRappresentante__c  FROM AccountContactRelation WHERE AccountId=:dealerAccountId AND Roles=:titolareEffettivo ORDER BY CreatedDate DESC];
        if(accountContactList.size()>0){
            return accountContactList[0].ContactId;
        } else {
            return null;
        }
  }    

    public static Map<String,String> getMapProvinciaEstesaEdAbbreviata(List<String> provinceEstese) {
        List<XCS_Town__c> provList=[SELECT Id, Provincia__c, Provincia_Desc__c FROM XCS_Town__c WHERE Provincia_Desc__c IN: provinceEstese];
    Map<String,String> provMap = new Map<String,String>();
        for (XCS_Town__c pr:provList){
          provMap.put(pr.Provincia_Desc__c,pr.Provincia__c);  
        }
    return provMap; 
  }    
        
    public static void updateStepLavorazione(String caseId, String newStep){
        Case c = [SELECT Id,StepAttivitaConvenzionamento__c FROM Case WHERE Id =: caseId];
        c.StepAttivitaConvenzionamento__c =newStep;        
        update(c);
    }   
    
    public static Case stepLavorazione(Case c, String newStep, Boolean updateCase){
        c.StepAttivitaConvenzionamento__c =newStep;        
        if(updateCase){update(c);}
        return c;
    }
    
    public static Case utenteLavorazione(String caseId, String queueName, Boolean updateCase){
        Case c = getCase(caseId);
        if(updateCase){
            c=utenteLavorazione(c,queueName,true);
        } else {
            c=utenteLavorazione(c,queueName,false);
        }
        return c;
        
    }     
    

    
    public static Case utenteLavorazione(Case c, String queueName, Boolean updateCase){
        return utenteLavorazione(c, queueName, updateCase, true);
    } 
    
    public static Boolean evaluateCaseUserOwner(Case c){
        String userID = Userinfo.getUserId();
        Boolean actualUserOwner=false;
        String ProfileId = UserInfo.getProfileId();
    	Profile Prof = [select Name from Profile where id=:ProfileId];
        
        if (prof.Name=='System Administrator')
        {
            actualUserOwner = true;
        }
        else{
            if(c.Owner_User__c ==userID){
                actualUserOwner=true;
            }
        }
        return actualUserOwner;
    } 
    
    public static Boolean evaluateCaseUserOwner(String caseId){
        return evaluateCaseUserOwner(getCase(caseId));
    }    
    
    public static Case utenteLavorazione(Case c, String queueName, Boolean updateCase, Boolean isQueue){  //se isQueue è false allora vuol dire che si tratta di un Role
        Id queueId;
        if(isQueue){
            queueId= GroupUtils.getQueue(queueName).Id;
        } else {
            queueId= GroupUtils.getRoleGroup(queueName).Id;
        }
        c.Utente_Lavorazione__c =queueId;        
        if(updateCase){update(c);}
        return c;
    }     
    
    public static List<SFA_ConvenzionamentoMessaggioAttivita__mdt> getLstMessageToVisualize(String ProfileName, String disposition){
        List<SFA_ConvenzionamentoMessaggioAttivita__mdt> lstMessage = [SELECT Id, Message__c, ProfileName__c, Disposition__c FROM SFA_ConvenzionamentoMessaggioAttivita__mdt WHERE ProfileName__c=:ProfileName AND Disposition__c=:disposition];
        return lstMessage;
    }  
    
    public static String getMessageToVisualize(String ProfileName, String disposition){
        String message='';  //se non trova nessuna disposition con messaggio per il profilo passato, ritorna un messaggio vuoto.
        List<SFA_ConvenzionamentoMessaggioAttivita__mdt> lstMessage=getLstMessageToVisualize(ProfileName,disposition);
        if(lstMessage.size()==1){
            message=lstMessage[0].Message__c;
        }
        return message;
    }
    
    public static DatiMessage getFinalMessageToVisualize(String caseId, String queueName, String disposition, String ProfileName, String genericMessage){
        //evaluate if queue is owner of the case and if not get the Message to visualize
        DatiMessage datiMessage = new DatiMessage();
        datiMessage.queueOwnerActivity=evaluateActivityOwnership(caseId,queueName);
        if(!datiMessage.queueOwnerActivity){    //if queue is not owner of the case then we recover the message to visualize from custom metadata table
           String message=getMessageToVisualize(ProfileName,disposition);
           if(!String.isEmpty(message)){
               datiMessage.message=message; 
           } else {
               datiMessage.message=genericMessage;
           }
        }
        return datiMessage;
    }
    
    public static Boolean evaluateActivityOwnership(String caseId, String queueName){   //valuta se l'utente connesso è owner dell'attività oppure no
        
    Case caseAttivita = 
      [SELECT Id, AccountId, Disposition__c, OCSExternalFilialeConvenzionato__c, Utente_Lavorazione__c  
      FROM Case 
      WHERE Id = :caseId][0];        
        
        return evaluateActivityOwnership(caseAttivita,queueName);
    }
    
    public static Boolean evaluateActivityOwnershipRole(String caseId, String queueName){   //valuta se l'utente connesso è owner dell'attività oppure no
        
    Case caseAttivita = 
      [SELECT Id, AccountId, Disposition__c, OCSExternalFilialeConvenzionato__c, Utente_Lavorazione__c  
      FROM Case 
      WHERE Id = :caseId][0];        
        
        return evaluateActivityOwnershipRole(caseAttivita,queueName);
    }    
    
    public static Boolean evaluateActivityOwnership(Case caseAttivita, String queueName){   //valuta se l'utente connesso è owner dell'attività oppure no
        
        Boolean queueOwnerActivity; 
        String ProfileId = UserInfo.getProfileId();
    	Profile Prof = [select Name from Profile where id=:ProfileId];
        
        if (prof.Name=='System Administrator')
        {
            queueOwnerActivity = true;
        }
        else{
            Group queue=GroupUtils.getQueue(queueName); 
            
            if(queue.Id==caseAttivita.Utente_Lavorazione__c){
                queueOwnerActivity=true;
            } else {
                queueOwnerActivity=false;
            }
        }  
        return queueOwnerActivity;
    }
    
    public static Boolean evaluateActivityOwnershipRole(Case caseAttivita, String queueName){   //valuta se l'utente connesso è owner dell'attività oppure no
        
        Boolean queueOwnerActivity;        
        
        Group queue=GroupUtils.getRoleGroup(queueName); 
        
        if(queue.Id==caseAttivita.Utente_Lavorazione__c){
            queueOwnerActivity=true;
        } else {
            queueOwnerActivity=false;
        }
          
        return queueOwnerActivity;
    }    
    
    
    public static void associateTitolareToDealer(String dealerId, String titolareId){
        associateCollegatoToDealer(dealerId, titolareId, SFAConvenzionamento.titolareEffettivo);
    }
    
    public static void associateCollegatoToDealer(String dealerId, String collegatoId, String ruoloCollegato){
        Contact collegato =[SELECT id, AccountId FROM Contact WHERE id=:collegatoId][0];
        if(String.isEmpty(collegato.AccountId)){   //se il contact recuperato non è associato ad alcun account (AccountId=null), allora lo associo al dealer che sto convenzionando, altrimenti l'AccountContactRelation non può essere creata
            System.debug('!!!!!!!!!!!!!! associatecollegatoToDealer 1');
            collegato.AccountId=dealerId;  
            update collegato;
            AccountContactRelation acc_con =[SELECT id, ContactId, AccountId, Roles FROM AccountContactRelation WHERE AccountId=:dealerId AND ContactId=:collegato.Id][0]; 
            acc_con.Roles=ruoloCollegato;
            update acc_con;
        } else if(collegato.AccountId==dealerId){
            System.debug('!!!!!!!!!!!!!! associatecollegatoToDealer 2');
            AccountContactRelation acc_con =[SELECT id, ContactId, AccountId, Roles FROM AccountContactRelation WHERE AccountId=:dealerId AND ContactId=:collegato.Id][0]; 
            acc_con.Roles=ruoloCollegato;
            update acc_con;
        } else {
            System.debug('!!!!!!!!!!!!!! associatecollegatoToDealer 3');
            AccountContactRelation acc_con = new AccountContactRelation();
            acc_con.ContactId=collegato.Id;
            acc_con.AccountId=dealerId;
            acc_con.Roles=ruoloCollegato;
            insert acc_con; 
            
        }        
        
    }
   public class DatiMessage {
        @AuraEnabled
        public Boolean queueOwnerActivity {get; set;}
        @AuraEnabled
        public String message {get; set;}     
      
    }
        
   public class Dati {
        @AuraEnabled
        public Id dealerId {get; set;}
        @AuraEnabled
        public Id reportCervedId {get; set;}   
        @AuraEnabled
        public Id recordTypeId {get; set;}         
        @AuraEnabled
        public String reportFileId {get; set;}         
        @AuraEnabled
        public String OCSExternalFiliale {get; set;} 
        @AuraEnabled
        public String contactDiRiferimentoId {get; set;}        
        @AuraEnabled
        public XCS_Disposition__c disposition {get; set;}        
        @AuraEnabled
        public Account dealerInfo {get; set;}    
        @AuraEnabled
        public Case caseAttivita {get; set;}      
        @AuraEnabled
        public List<XCS_CCAccredito__c> contiCorrenteList {get { if (ContiCorrenteList == null ) ContiCorrenteList = new List<XCS_CCAccredito__c>(); return ContiCorrenteList; } set;}        
    }       
    
   public class Collegati {
        @AuraEnabled
        public List<CollegatiObject> collegatiSoci {get { if (collegatiSoci == null ) collegatiSoci = new List<CollegatiObject>(); return collegatiSoci; } set;}
        @AuraEnabled
        public List<CollegatiObject> collegatiNonSoci {get { if (collegatiNonSoci == null ) collegatiNonSoci = new List<CollegatiObject>(); return collegatiNonSoci; } set;}        
    }     
         
   public class CollegatiObject {
        @AuraEnabled
        public Contact contactCollegato {get { if (contactCollegato == null ) contactCollegato = new Contact(); return contactCollegato; } set;}
        @AuraEnabled
        public AccountContactRelation accountContactCollegato {get { if (accountContactCollegato == null ) accountContactCollegato = new AccountContactRelation(); return accountContactCollegato; } set;}        
    }
    
   public class CollegatoERuoloObject {
        @AuraEnabled
        public Contact contactCollegato {get { if (contactCollegato == null ) contactCollegato = new Contact(); return contactCollegato; } set;}
        @AuraEnabled
        public String Ruolo {get; set;}        
    }

   public class CollegatiERuoli {
        @AuraEnabled
        public List<CollegatoERuoloObject> collegati {get { if (collegati == null ) collegati = new List<CollegatoERuoloObject>(); return collegati; } set;}
        @AuraEnabled
        public Set<String> ruoli {get { if (ruoli == null ) ruoli = new Set<String>(); return ruoli; } set;}        
    }     
    
   public class CategoriaEStepLavorazione {
        @AuraEnabled
        public String categoria {get; set;}
        @AuraEnabled
        public String stepLavorazione {get; set;}
    }    
}