public class SFAConvenzGestioneAccolloController {
	
    private static final String AT = 'AT';
	private static final String FL = 'FL';
  	private static final String IS = 'IS';
  	private static final String CH = 'CH';
  	private static final String PV = 'PV';

  	private static final Integer STATUS_NOT_AT_FL = -1;
  	private static final Integer ACTIVATION_DATE_TOO_OLD = -2;
  	private static final Integer DEALER_IS_PV = -3;
  	private static final Integer CREA_ACCOLLO = -4;
  	private static final Integer GESTIONE_ALTRO_UFFICIO = -5;
  	private static final Integer DOSSIER_PRECEDENTE_ATTIVAZIONE = -6;
 	private static final Integer STATUS_NOT_GESTITO = -7;

  	private static final String NOT_ALL_MANDATORY_DOCS_SELECTED = 'M01';
  	private static final String NOT_ALL_IDENTITY_DOCS_SELECTED = 'I01';
  	private static final String NOT_ALL_ADDITIONAL_QUESTIONS_ANSWERED = 'A01';
  	private static final String DEFAULT_ANSWER = '(Seleziona)';

   @AuraEnabled
    public static InitData RecuperaContesto (String RecId){
     InitData initData = new InitData();
     System.Debug('RecordId_iniz: '+RecId);
     list <dossier__c> CaseId =  [select IdAttivita__c from dossier__c where id= :RecId];
     
     System.Debug('Recupero CaseId: '+CaseId);
     if(caseId.size()!=0)
         initData.CaseIdRec= CaseId[0].IdAttivita__c;
     else     
        initData.CaseIdRec=RecId;
      
       System.Debug('initData.CaseIdRec : '+initData.CaseIdRec);     
     return initdata;
    }
    
    
    
  @AuraEnabled
    public static InitData MostraTipologie(String caseId){
        
        List<Accolli_Type_List__c> Tipologia = new List<Accolli_Type_List__c>();
        List<Dossier__c> Accollo = new List<Dossier__c>();
        List<Accolli_Type__c> TypeSelected = new List<Accolli_Type__c>();
        List<Accolli_Type_List__c> AccType = new List<Accolli_Type_List__c>();
        Set<String> TypeSel = new Set<String>();
        Set<String> Acc = new Set<String>();
        List<Id> SelezList = new List<Id>();
        
  //     String ProfileId = UserInfo.getProfileId();
  //     list<profile> Profile = [select name from profile where id=:profileId] ;
  //     if(profile[0].name ='')
      
        InitData initData = new InitData();
        //initData.isInManoAFiliale = true;
        
        Tipologia = [SELECT Accollo_Type_Desc_Abrev__c FROM Accolli_Type_List__c];
		
        Accollo = [SELECT Id FROM Dossier__c where IdAttivita__c =:caseId];
        for(Dossier__c A : Accollo){
            Acc.add(A.Id);
        }
        
        TypeSelected = [SELECT  AccolloType__c	 FROM Accolli_Type__c WHERE Accollo_Id__c = :Acc and Rimozione_Logica__c = false];
        for(Accolli_Type__c T : TypeSelected){
            TypeSel.add(T.AccolloType__c);
        }
        
        AccType = [SELECT Id from Accolli_Type_List__c where Id =	:TypeSel];
        
        for(Accolli_Type_List__c Sel : AccType){
            SelezList.add(Sel.Id);
        }
        
    	SYSTEM.debug('tipologie******: '+ Tipologia);
        SYSTEM.debug('Selezione******: '+ SelezList);
   		initData.Tipologie =  Tipologia;   
    	initData.Selezione = SelezList;
                                          
    return initData;
    }  
    
  @AuraEnabled
  public static InitData checkDossierEsistente(String caseId) {

    System.debug('*** SFAConvenzGestioneDossierController - checkDossierEsistente()');

    InitData initData = new InitData();
    //    initData.isInManoAFiliale = true;
    system.debug('caseId Prima: ' +caseId) ;
   list <Case> CaseExist = [SELECT id FROM Case WHERE Id = :caseId]; 
 
    Case currentCase = [SELECT Disposition__r.External_Id__c, AccountId, Account.OCS_External_Id__c, CaseNumber, Account.Tipo_Intermediario__c FROM Case WHERE Id = :caseId];
      
    if(currentCase.Disposition__r.External_Id__c == XCS_DispositionUtils.ACCOLLO_INCOMPLETO_MD ||  
       currentCase.Disposition__r.External_Id__c == XCS_DispositionUtils.ACCOLLO_INCOMPLETO_IDM || 
       currentCase.Disposition__r.External_Id__c == XCS_DispositionUtils.NUOVO_ACCOLLO) {
          //showButtonAvvisaIDM
          initData.isInManoAFiliale = true;
          
         if(currentCase.Disposition__r.External_Id__c == XCS_DispositionUtils.ACCOLLO_INCOMPLETO_MD ||  currentCase.Disposition__r.External_Id__c == XCS_DispositionUtils.ACCOLLO_INCOMPLETO_IDM){
          //showButtonAvvisaIDM
        		initData.abilitaAvviso = true;
    	}
    } 
    else{
         initData.isInManoAFiliale = false;  
    }
      
    
    Account acc = [SELECT  ParentId, Parent.OCS_External_Id__c  FROM Account Where Id= :currentCase.AccountId];
      //showButtonAvvisaIDM
     System.debug('CurrenCaseAccount****** : '+currentCase);
      System.debug('CurrenAccount****** : '+acc);
    String dealerId = currentCase.AccountId;
    String dealerMasterId =  acc.ParentId;
    String TipoInterm =  currentCase.Account.Tipo_Intermediario__c;
    String dealerOCSExternalId = currentCase.Account.OCS_External_Id__c;
	
    initData.tipoChecklist = TipoInterm;
      
    System.debug('*** dealerId :: ' + dealerId);
    System.debug('*** dealerOCSExternalIdPre :: ' + dealerOCSExternalId);

    initData.dealerId = dealerId; 
    initData.dealerMasterId = dealerMasterId;

    // da vedere ***
    StatoAttributoData sad = getStatoAttributoData(dealerOCSExternalId);
    System.debug('*** sad :: ' + JSON.serialize(sad));

    if (sad.errorCode < 0) {
      initData.errorCode = sad.errorCode;
      return initData; 
    }
  
    Id queueMDId = GroupUtils.getQueue(SFAConvenzionamento.queueMD).Id;
	String ProfileId = UserInfo.getProfileId();
    System.debug('*** ProfileId :: ' + ProfileId);
      
    String utenteId = UserInfo.getUserId();
      System.debug('*** utenteId :: ' + utenteId);
    String filialeQueue = [SELECT Id, DefaultQueueId__c FROM User WHERE Id = :utenteId][0].DefaultQueueId__c;
    System.debug('*** filialeQueue :: ' + filialeQueue);
    Id queueFilialeId = null;
    if(filialeQueue != '' && filialeQueue != null)
     	queueFilialeId = GroupUtils.getQueue(filialeQueue).Id;

    // eseguo la logica fino al punto 3 poi eseguo il punto 4, come segue
    XCS_Categoria__c categoria = XCS_CategoriaUtil.getCategoryForExternalId(XCS_CategoriaUtil.SFA_CONVENZIONAMENTO_GESTIONE_ACCOLLO_DEALER);

    System.debug('*** categoria :: ' + JSON.serialize(categoria));

    List<Case> lstAccolloCaseEsistente = 
      [SELECT Id, CaseNumber, Categoria_Riferimento__r.External_Id__c, Status, StepAttivitaConvenzionamento__c
      FROM Case 
      WHERE AccountId = :dealerId AND Categoria_Riferimento__r.External_Id__c = :categoria.External_Id__c AND Id = :caseId AND Status != :CaseUtils.ANNULLATO AND Status != :CaseUtils.CHIUSO
      ORDER BY CreatedDate DESC];

    for (Case c : lstAccolloCaseEsistente) {
      if ( SFAConvenzionamento.GAD_DocumentiAddizionali.equals(c.StepAttivitaConvenzionamento__c) || 
           SFAConvenzionamento.GAD_RiepilogoDocumentiMancanti.equals(c.StepAttivitaConvenzionamento__c) ) {

        c.StepAttivitaConvenzionamento__c = SFAConvenzionamento.GAD_DocumentiObbligatori;

      }
    }

    update lstAccolloCaseEsistente;

    System.debug('*** lstAccolloCaseEsistente :: ' + JSON.serialize(lstAccolloCaseEsistente));

    Date today = Date.today();
    String numeroRiferimento = DateUtils.formatDateYYMMDD(today)+'-'+currentCase.CaseNumber;
    
    if (lstAccolloCaseEsistente.size() == 1) {
    	List<Dossier__c> lstAccolloCorrente = [SELECT Id, Name, DataRiferimento__c, IdAttivita__r.AccountId FROM Dossier__c WHERE IdAttivita__c = :caseId ORDER BY CreatedDate DESC];
      
        Dossier__c Accollo = lstAccolloCorrente.get(0);
       
       
        if (lstAccolloCorrente.size() > 0) {
              
            initData.dossier = Accollo;
          
        }

    }

    List <Profile> lp = [select Name from Profile where id=:ProfileId];
    string profileName = lp[0].Name;
      
    String utenteLavorazione = [SELECT Id, Utente_Lavorazione__c FROM Case WHERE Id = :caseId][0].Utente_Lavorazione__c;

    System.debug('*** utenteLavorazione :: ' + utenteLavorazione);
      System.debug('*** queueMDId :: ' + queueMDId);
      System.debug('*** queueFilialeId :: ' + queueFilialeId);
	System.debug('*** lp :: ' + lp);
      System.debug('*** profileName :: ' + profileName);
    
      if(profileName != 'System Administrator' && profileName != 'Monitoraggio Dealer'){
    		if (utenteLavorazione == queueFilialeId || String.isBlank(utenteLavorazione))
      			initData.isInManoAFiliale = true;
    		else
      			initData.isInManoAFiliale = false;
      }
    System.debug('*** initData :: ' + JSON.serialize(initData));
    return initData;
  }
  
  @AuraEnabled
    public static InitData CheckTypeSelezionati (Dossier__c dossier, List<Id> TipoAccollo, string caseId){
       	InitData initData = new InitData();  
       	List<Dossier__c> Accollo = new List<Dossier__c>();
       	List<Accolli_Type_List__c> AccType = new List<Accolli_Type_List__c>();
        initData.errorDesc = ''; 
		Map<Id,Accolli_Type__c> mapTipiEsist = new Map<Id,Accolli_Type__c>();
        Map<Id,Accolli_Type__c> mapTipiRimossi = new Map<Id,Accolli_Type__c>();
        
        List<String> DaCreareListId = new List<String>();
        List<String> DaRipristinareList = new List<String>();
        List<String> DaRimuovereList = new List<String>();
    
        List<Accolli_Type__c> TipiGiaSelez = [SELECT AccolloType__c , AccolloType__r.Accollo_Type_Code__c , Rimozione_Logica__c  FROM Accolli_Type__c WHERE Accollo_Id__c = :dossier.Id];
        
        System.debug('TIPOACCOLLOTEST: '+TipoAccollo);
        
        if(TipiGiaSelez.size()==0)
        {
            XCSNoteUtils.postANote(caseId,SFAConvenzionamento.TITLE_NOTE_EVENTO,SFAConvenzionamento.NOTA_EVENTO_ACCOLLO_INIZIOFILIALE); 
        }
        
        for(Accolli_Type__c AT : TipiGiaSelez){
            if(AT.Rimozione_Logica__c == true){
                mapTipiRimossi.put(AT.AccolloType__c, AT);
                
            }
            else{
                mapTipiEsist.put(AT.AccolloType__c, AT); 
            }
        }
        
      	List<Accolli_Type_List__c> Selezionati = [SELECT Id,Accollo_Type_Code__c  FROM Accolli_Type_List__c where Id = :TipoAccollo];
        
        for (Accolli_Type_List__c Tipi : Selezionati) {
            
            if(mapTipiEsist.containsKey(Tipi.Id)){  
                 mapTipiEsist.remove(Tipi.Id);// Remove Key from Map
                 
            }
            else if (mapTipiRimossi.containsKey(Tipi.Id)){
                DaRipristinareList.add(Tipi.Id); // Update Accolli Type e DossieDocument con flag Rimosso a False      
            }
            else{
               DaCreareListId.add(Tipi.Id); //Creazione Record Accolli Type  e DossierDocument              
            } 
        }
        if(!mapTipiEsist.isEmpty())
        {
            for(Accolli_Type__c target : mapTipiEsist.values())
            {
             //   String rimozionePossibile = VerificaFileEsistente();
                DaRimuovereList.add(target.AccolloType__c);   // Update Accolli Type e DossieDocument con flag Rimosso a True       
            }           
        }
        system.debug('DaRipristinareList: '+ DaRipristinareList);
        system.debug('DaRimuovereList: '+ DaRimuovereList);
        system.debug('DaCreareListId: '+ DaCreareListId);
        
        
        if(!DaRipristinareList.isEmpty()){
          UpdateFlagRimosso(dossier.id,DaRipristinareList,false);  
        }
        if(!DaRimuovereList.isEmpty()){
           initData.errorDesc = UpdateFlagRimosso(dossier.id,DaRimuovereList,true);
           
        }
        if(!DaCreareListId.isEmpty()){
            CreazioneDocAccollo(dossier.id,DaCreareListId);
        }
        
     return initData; 
    }
    
  @AuraEnabled  
  public static String UpdateFlagRimosso (string dossierId, List<String> TipoAccollo, Boolean Valore){  
     // List<Accolli_Type__c> AccolliType = new List<Accolli_Type__c>();
      list<String> AccolliType = new List<String>();
      List<SFADossierDocumento__c> lstAccolloDocumento = new List<SFADossierDocumento__c>(); 
      system.debug('UpdateFlag_TipoAccollo: '+ TipoAccollo);
      system.debug('UpdateFlag_dossierId: '+ dossierId);
      Map<Id,SFADossierDocumento__c> mapDocPres = new Map<Id,SFADossierDocumento__c>();
      string Errore = '';
      
      list<Accolli_Type__c> AccType = [SELECT Id,AccolloType__r.Accollo_type_code__c ,Rimozione_Logica__c FROM Accolli_Type__c where Accollo_Id__c = :dossierId AND AccolloType__c =:TipoAccollo];
      for(Accolli_Type__c A : AccType){
          
          system.debug('CicloForAccType: '+ A);
          A.Rimozione_Logica__c= Valore;
          AccolliType.add(A.AccolloType__r.Accollo_type_code__c);
      }
      
      List<SFADossierDocumento__c> Doc = [SELECT Id, Rimozione_Logica__c,Document__c, TipoConv__c,NumeroAllegati__c, Dossier__c, Collegato__c, RispostaDocumentiAddizionali__c,IsDocumentoSelezionato__c, DocumentType__c, DocumentDetails__c, SFAConvenzDealerDocumentsList__c 
       									 FROM SFADossierDocumento__c
       								 	 WHERE Dossier__c = :dossierId AND TipoConv__c = :AccolliType];
      
      List<SFADossierDocumento__c> DocPresenti = [SELECT Id, Rimozione_Logica__c, TipoConv__c,NumeroAllegati__c, Dossier__c, SFAConvenzDealerDocumentsList__c 
       									 FROM SFADossierDocumento__c
       								 	 WHERE Dossier__c = :dossierId AND Rimozione_Logica__c=false and NumeroAllegati__c > 0 ];
      
      for(SFADossierDocumento__c  P : DocPresenti){
           mapDocPres.put(P.SFAConvenzDealerDocumentsList__c, P);
      }
      
      for(SFADossierDocumento__c D : Doc){
          if(D.NumeroAllegati__c > 0 && Valore == true)
          {
              if(mapDocPres.containsKey(D.SFAConvenzDealerDocumentsList__c))
              {
              		string TipoConv = mapDocPres.get(D.SFAConvenzDealerDocumentsList__c).TipoConv__c ;
                  	if(TipoConv != D.TipoConv__c)
                    {
                        D.Rimozione_Logica__c= Valore;  D.IsDocumentoSelezionato__c = false; D.RispostaDocumentiAddizionali__c='No';
          	  		}
                   	else
                   	{
                       Errore = 'Impossibile deselezionare tipo accollo '+ D.TipoConv__c +' poiche esistono gia doc allegati';
             		   system.debug('Errore*** : '+Errore);
                    }    
              }
              else
              {
                  Errore = 'Impossibile deselezionare tipo accollo '+ D.TipoConv__c +' poiche esistono gia doc allegati';
                  system.debug('Errore*** : '+Errore);
              }
              
          }
          else{
              
              D.Rimozione_Logica__c= Valore;  
       		  if(Valore==true){
            	  D.IsDocumentoSelezionato__c = false;
              	D.RispostaDocumentiAddizionali__c='No';
          	  }
              
          }          
      }
      
      Try{
           system.debug('Update ListType: '+AccType + 'Update List: '+Doc );
          if(Errore ==''){
      		update AccType;
      		update Doc;
          }
      }
      catch(exception e){
            system.debug('ERORR_Update: '+ e.getMessage());
      }
      return Errore;
  }
  
    @AuraEnabled  
  	public static void CreazioneDocAccollo (string dossierId, List<String>TipoAccollo){  
        
        List<String> TiplogieCode = new List<string>();
        List<Accolli_Type__c> AccolliType = new List<Accolli_Type__c>(); 
        
		List<Accolli_Type_List__c> TypeList = [SELECT Id, Accollo_Type_Code__c From Accolli_Type_List__c where Id = :TipoAccollo];
        for(Accolli_Type_List__c T : TypeList){
            Accolli_Type__c AccolliT = new Accolli_Type__c();
            AccolliT.Accollo_Id__c=dossierId;
            AccolliT.AccolloType__c=T.Id;
            AccolliType.add(AccolliT); 
            TiplogieCode.Add(T.Accollo_Type_Code__c);
        }
        
 
      	List<SFAConvenzDealerDocumentsList__c> lstDocumenti = [SELECT Name, Id, IdDocument__c, CodDocument__c, Document__c, FlgEsclusione__c FROM SFAConvenzDealerDocumentsList__c];
    	Map<String, String> mapDocumentiId = new Map<String, String>();

    	for (SFAConvenzDealerDocumentsList__c documento : lstDocumenti) {
     		 mapDocumentiId.put(documento.IdDocument__c, documento.Id);
        }
        List<SFAConvenzDealerDocumentsTipoConvCO__c> lstDocumentiObbligatori = 
        [SELECT Name, Id, IdDocumentTipoConv__c, IdxDocument__c, TipoConv__c, DateStart__c, DocumentType__c, DocumentDetails__c, DateEnd__c 
        FROM SFAConvenzDealerDocumentsTipoConvCO__c
        WHERE TipoConv__c = :TiplogieCode AND DocumentType__c = 'mandatory' AND DateStart__c <= today AND DateEnd__c >= today];
            
         System.debug('*** lstDocumentiObbligatori :: ' + JSON.serialize(lstDocumentiObbligatori)); 
         
        List<SFAConvenzDealerDocumentsTipoConvCO__c> lstDocumentiAddizionali = 
        [SELECT Name, Id, IdDocumentTipoConv__c, IdxDocument__c, TipoConv__c, DateStart__c, DocumentType__c, DocumentDetails__c, DateEnd__c 
        FROM SFAConvenzDealerDocumentsTipoConvCO__c
        WHERE TipoConv__c = :TiplogieCode AND DocumentType__c = 'additional' AND DateStart__c <= today AND DateEnd__c >= today];
            
        System.debug('*** lstDocumentiAddizionali :: ' + JSON.serialize(lstDocumentiAddizionali));
            
        List<SFADossierDocumento__c> lstAccolloDocumento = new List<SFADossierDocumento__c>(); 
            
        for (SFAConvenzDealerDocumentsTipoConvCO__c documento : lstDocumentiObbligatori) {
        	SFADossierDocumento__c AccolloDocumento = new SFADossierDocumento__c();
            AccolloDocumento.Dossier__c = dossierId;
            AccolloDocumento.SFAConvenzDealerDocumentsList__c = mapDocumentiId.get(documento.IdxDocument__c);
            AccolloDocumento.TipoConv__c = documento.TipoConv__c;
            AccolloDocumento.DocumentType__c = 'mandatory';
            lstAccolloDocumento.add(AccolloDocumento);
         }
                        
         for (SFAConvenzDealerDocumentsTipoConvCO__c documento : lstDocumentiAddizionali) {
         	SFADossierDocumento__c AccolloDocumento = new SFADossierDocumento__c();
            AccolloDocumento.Dossier__c = dossierId;
            AccolloDocumento.SFAConvenzDealerDocumentsList__c = mapDocumentiId.get(documento.IdxDocument__c);
            AccolloDocumento.TipoConv__c = documento.TipoConv__c;
            AccolloDocumento.DocumentDetails__c = documento.DocumentDetails__c;
            AccolloDocumento.DocumentType__c = 'additional';
            lstAccolloDocumento.add(AccolloDocumento);    
         }
        
        try
        {
            insert AccolliType;
        	insert lstAccolloDocumento;
        }
        catch(exception e){
            system.debug('ERORR_INSERT: '+ e.getMessage());
        }
  }
    
  @AuraEnabled
  public static StatoAttributoData getStatoAttributoData(String dealerOCSExternalId) {

    System.debug('*** dealerOCSExternalId :: ' + dealerOCSExternalId);

    StatoAttributoData sad = new StatoAttributoData();

    String codiceIntermediario = dealerOCSExternalId.Substring(1);

    OCSRecuperaLogAzioniIntermedResponse response = OCSRecuperaLogAzioniIntermedInvoker.recuperaLogAzioniIntermediario(codiceIntermediario);

    System.debug('*** getStatoAttributoData - response :: ' + JSON.serialize(response));

    List<OCSRecuperaLogAzioniIntermedResponse.Elenco> listaStati = response.recuperaLogAzioniIntermediarioResponse.elenco;

    if (listaStati != null) {
      for (Integer i=0; i<listaStati.size(); i++) {
        if (i == 0) {
          sad.stato = listaStati.get(i).stato;
          sad.attributo = listaStati.get(i).attributo;
          if (!AT.equals(sad.stato) && !FL.equals(sad.stato)) {
            sad.errorCode = STATUS_NOT_AT_FL;
      //      System.debug('*** riga 126');
            //System.debug('*** getStatoAttributoData - sad :: ' + JSON.serialize(sad));
            return sad;
          }
          if (AT.equals(sad.stato)) {
            sad.dataRiferimento = DateUtils.parseFromYYYYMMDDString(listaStati.get(i).dataRiferimento);
          //  System.debug('*** getStatoAttributoData - sad :: ' + JSON.serialize(sad));
       //     System.debug('*** riga 131');
          }
        }
        else {
          String stato = listaStati.get(i).stato;
          if (AT.equals(stato))
            sad.dataRiferimento = DateUtils.parseFromYYYYMMDDString(listaStati.get(i).dataRiferimento);
          else if (IS.equals(stato))
            break;
        }
      }
    }

//    if (sad.dataRiferimento.daysBetween(Date.today()) > 120)
//      sad.errorCode = ACTIVATION_DATE_TOO_OLD;

    System.debug('*** getStatoAttributoData - sad :: ' + JSON.serialize(sad));
    return sad;

  }
    
  @AuraEnabled
  public static DatiListaDocumenti getListeDocumenti(String caseId, Dossier__c dossier, List<Id> TipoAccollo ) {//, String Azione gestione

    System.debug('*** getListeDocumenti()');

    System.debug('*** caseId :: ' + caseId);
    System.debug('*** dossier :: ' + JSON.serialize(dossier));
    System.debug('*** tipoConv :: ' + TipoAccollo);

    String step = [SELECT Id, StepAttivitaConvenzionamento__c FROM Case WHERE Id = :caseId][0].StepAttivitaConvenzionamento__c;

    Date today = Date.today();

    String dealerId = dossier.IdAttivita__r.AccountId;
    String dossierId = dossier.id;
        
        System.debug('*** dossier.IdAttivita__c :: ' + dossier.IdAttivita__c);
        System.debug('*** dossierId :: ' + dossierId);

    List<SFAConvenzDealerDocumentsList__c> lstDocumenti = [SELECT Name, Id, IdDocument__c, CodDocument__c, Document__c, FlgEsclusione__c FROM SFAConvenzDealerDocumentsList__c];
    Map<String, String> mapDocumentiId = new Map<String, String>();

    for (SFAConvenzDealerDocumentsList__c documento : lstDocumenti) {
      mapDocumentiId.put(documento.IdDocument__c, documento.Id);
    }
  	System.debug('*** tipoConv: '+ TipoAccollo);
    DatiListaDocumenti datiListaDocumenti = new DatiListaDocumenti();
    
      List<Accolli_type_List__c>  TipoAcc = [SELECT Accollo_Type_Code__c FROM Accolli_type_List__c where Id = :TipoAccollo];
      
      List<String> Tipolog = new List<String>();
      
      for(Accolli_type_List__c TL : TipoAcc){
          Tipolog.Add(TL.Accollo_Type_Code__c);
      }

    List<SFADossierDocumento__c> lstAccolloDocumentoPresente = 
      [SELECT Id, Name 
      FROM SFADossierDocumento__c
      WHERE TipoConv__c = :Tipolog  AND Dossier__c = :dossierId AND Rimozione_Logica__c = false];
	
       System.debug('*** Tipolog: '+ Tipolog);
       System.debug('*** lstAccolloDocumentoPresente: '+ lstAccolloDocumentoPresente);
     
  
    if (lstAccolloDocumentoPresente.size() != 0 && Tipolog.size()>0) {

      System.debug('*** lstDossierDocumentoPresente.size() != 0');


		List<Id> IdDoc = New List<Id>();
        Map<Id, Id> MapDocSel = new Map<Id, Id>();
        List<Id> IdDocA = New List<Id>();
        Map<Id, Id> MapDocASel = new Map<Id, Id>();
        
        List<SFADossierDocumento__c> lstDossierDocumentoObbligatori = 
            [SELECT Id, Document__c, TipoConv__c, Dossier__c, IsDocumentoSelezionato__c, DocumentType__c, DocumentDetails__c, SFAConvenzDealerDocumentsList__c 
             FROM SFADossierDocumento__c
             WHERE Dossier__c = :dossierID AND DocumentType__c = 'mandatory' and  TipoConv__c = :Tipolog and Rimozione_Logica__c = false];
       
        for (SFADossierDocumento__c documentoD : lstDossierDocumentoObbligatori) { 
        	IdDoc.add(documentoD.SFAConvenzDealerDocumentsList__c);
            
            if(documentoD.IsDocumentoSelezionato__c==true)
            {
                MapDocSel.put(documentoD.SFAConvenzDealerDocumentsList__c,documentoD.Id);
            }
            
        }
        
       List<SFAConvenzDealerDocumentsList__c  > lstDocumentoObbligatori = 
           [select Id, OwnerId, Name,  CodDocument__c, Document__c, FlgEsclusione__c, IdDocument__c from SFAConvenzDealerDocumentsList__c  where id=:IdDoc];
           
        system.debug('*** IdDoc.size() ***' + IdDoc.size() );   
        system.debug('*** MapDocSel.size() ***' + MapDocSel.size() );   
        system.debug('*** lstDocumentoObbligatori.size() ***' + lstDocumentoObbligatori.size() );   
        system.debug('*** lstDossierDocumentoObbligatori.size() ***' + lstDossierDocumentoObbligatori.size() );   
        system.debug('*** lstDocumentoObbligatori ***' + lstDocumentoObbligatori );   
        
        
        for (SFAConvenzDealerDocumentsList__c documentoL : lstDocumentoObbligatori) {
            if(MapDocSel.containsKey(documentoL.Id)){
                datiListaDocumenti.lstDocumentoObbligatori.add(documentoL);
            	datiListaDocumenti.lstSelectedObbligatori.add(documentoL.Id);
            }
            else
            {
                datiListaDocumenti.lstDocumentoObbligatori.add(documentoL);
            }    
        }
        
        
        List<SFADossierDocumento__c> lstDossierDocumentoAddizionali = 
            [SELECT Id, Document__c, TipoConv__c, Dossier__c, Collegato__c, IsDocumentoSelezionato__c, DocumentType__c, DocumentDetails__c, SFAConvenzDealerDocumentsList__c, RispostaDocumentiAddizionali__c 
             FROM SFADossierDocumento__c 
             WHERE Dossier__c = :dossierID AND DocumentType__c = 'additional' and  TipoConv__c = :Tipolog and Rimozione_Logica__c = false];
        
        for (SFADossierDocumento__c documentoD : lstDossierDocumentoAddizionali) { 
        	IdDocA.add(documentoD.SFAConvenzDealerDocumentsList__c);
            
            if(documentoD.IsDocumentoSelezionato__c==true)
            {
                MapDocASel.put(documentoD.SFAConvenzDealerDocumentsList__c,documentoD.Id);
            }
            
        }
        
       List<SFAConvenzDealerDocumentsList__c  > lstDocumentoAddizionali = 
           [select Id, OwnerId, Name,  CodDocument__c, Document__c, FlgEsclusione__c, IdDocument__c from SFAConvenzDealerDocumentsList__c  where id=:IdDocA];
        
        for (SFAConvenzDealerDocumentsList__c documentoL : lstDocumentoAddizionali) {
            if(MapDocASel.containsKey(documentoL.Id)){
                datiListaDocumenti.lstDocumentoAddizionali.add(documentoL);
            	datiListaDocumenti.lstSelectedAddizionali.add(documentoL.Id);
            }
            else
            {
                datiListaDocumenti.lstDocumentoAddizionali.add(documentoL);
            }    
        }
        
    }
    System.debug('*** datiListaDocumenti: '+ datiListaDocumenti); 
    datiListaDocumenti.step = step;

    // ritornarmi le tre liste di documenti
    System.debug('*** datiListaDocumenti :: ' + JSON.serialize(datiListaDocumenti));
    return datiListaDocumenti;
    
  }

  @AuraEnabled
  public static void salvaSelezioneDocumenti(String dossierId, String caseId, List<String> lstIdDocumento, List<String> lstIdDocumentoA, String step) {

    System.debug('*** lstIdDocumento :: ' + JSON.serialize(lstIdDocumento));
    System.debug('*** step :: ' + step);

    if (SFAConvenzionamento.GAD_DocumentiObbligatori.equals(step)) {
      List<SFADossierDocumento__c> lstDossierDocumentoObbligatori = 
        [SELECT Id, Document__c, TipoConv__c, Dossier__c, Collegato__c, IsDocumentoSelezionato__c, DocumentType__c, SFAConvenzDealerDocumentsList__c, RispostaDocumentiAddizionali__c 
         FROM SFADossierDocumento__c 
         WHERE Dossier__c = :dossierId AND DocumentType__c = 'mandatory' AND Rimozione_Logica__c = false];

      for (SFADossierDocumento__c documento : lstDossierDocumentoObbligatori) {
                if (lstIdDocumento.contains(documento.SFAConvenzDealerDocumentsList__c)) {
         			documento.IsDocumentoSelezionato__c = true;
                	documento.RispostaDocumentiAddizionali__c = 'Si';
                }
                else {
          documento.IsDocumentoSelezionato__c = false;
                }
      }
     // if(lstIdDocumentoA.size() > 0){
      		List<SFADossierDocumento__c> lstDossierDocumentoAddizionali = 
      		[SELECT Id, Document__c, TipoConv__c, Dossier__c, Collegato__c, IsDocumentoSelezionato__c, DocumentType__c, SFAConvenzDealerDocumentsList__c, RispostaDocumentiAddizionali__c 
         	FROM SFADossierDocumento__c 
         	WHERE Dossier__c = :dossierId AND DocumentType__c = 'additional' AND Rimozione_Logica__c = false];

     		for (SFADossierDocumento__c documento : lstDossierDocumentoAddizionali) {
                if (lstIdDocumentoA.contains(documento.SFAConvenzDealerDocumentsList__c)) {
         			documento.IsDocumentoSelezionato__c = true;
                	documento.RispostaDocumentiAddizionali__c = 'Si';
                }
                else {
          		documento.IsDocumentoSelezionato__c = false;
                }
      		}
			update lstDossierDocumentoAddizionali; 
//   }
      update lstDossierDocumentoObbligatori;
        
           
      SFAConvenzionamento.updateStepLavorazione(caseId, step);
    }

  }

/*  @AuraEnabled
 public static void salvaRisposteDocumentiAddizionali(String dossierId, String caseId, Map<String, String> mapIdRispostaDocumentoAddizionali, String step) {

    System.debug('*** mapIdRispostaDocumentoAddizionali :: ' + JSON.serialize(mapIdRispostaDocumentoAddizionali));
    System.debug('*** step :: ' + step);

    if (SFAConvenzionamento.GAD_DocumentiAddizionali.equals(step)) {
      List<SFADossierDocumento__c> lstDossierDocumentoAddizionali = 
        [SELECT Id, Document__c, TipoConv__c, Dossier__c, Collegato__c, IsDocumentoSelezionato__c, DocumentType__c, SFAConvenzDealerDocumentsList__c, RispostaDocumentiAddizionali__c
         FROM SFADossierDocumento__c 
         WHERE Dossier__c = :dossierId AND DocumentType__c = 'additional' AND Rimozione_Logica__c = false];

      for (SFADossierDocumento__c documento : lstDossierDocumentoAddizionali) {
        if (mapIdRispostaDocumentoAddizionali.containsKey(documento.Id))
          documento.RispostaDocumentiAddizionali__c = mapIdRispostaDocumentoAddizionali.get(documento.Id);
      }

      update lstDossierDocumentoAddizionali;

      SFAConvenzionamento.updateStepLavorazione(caseId, step);
    }
  }*/

  @AuraEnabled
  public static String generaCoverDossierUrl(String dossierId) {
    String res='/apex/SFAConvenzGestioneAccolloGeneraCover?dossierId='+dossierId;
        return res;
  }

  @AuraEnabled  
  public static void assignToIDM(string dossierId, string caseId){

    XCSNoteUtils.postANote(caseId,SFAConvenzionamento.TITLE_NOTE_EVENTO,SFAConvenzionamento.NOTA_EVENTO_ACCOLLO_COMPLETAMENTOFILIALE);

    Date today = Date.today();
        Dossier__c dossier= SFAConvenzionamento.getDossier(dossierId);
    dossier.DataCompletamentoFiliale__c = today;
    update dossier;

    Case caseAttivita= SFAConvenzionamento.getCase(caseId);
    caseAttivita.Status=CaseUtils.INOLTRATO;
    caseAttivita=CaseUtils.aggiornaDispositionCase(caseAttivita,XCS_DispositionUtils.ACCOLLO_COMPLETO_FILIALE,false);
    caseAttivita=SFAConvenzionamento.utenteLavorazione(caseAttivita,GroupUtils.IDM_RITORNIPOSTALI,false,false);
    caseAttivita=CaseShareUtil.appendStringToCaseShare(caseAttivita,SFAConvenzionamento.sharingToIDM);
    update caseAttivita;
  }
  
   @AuraEnabled  
  public static void SendToIDM(string dossierId, string caseId){
	List<Messaging.SingleEmailMessage> ListSendMail = new List<Messaging.SingleEmailMessage>();
    List<String> Mail = new list <String>();
    List<Id> NoteC = new list <Id>();
     String TestoNote= '';
    //XCSNoteUtils.postANote(caseId,SFAConvenzionamento.TITLE_NOTE_EVENTO,SFAConvenzionamento.NOTA_EVENTO_ACCOLLO_COMPLETAMENTOFILIALE);
	
    List<ContentDocumentLink> lConDocLink = [select ContentDocumentId from ContentDocumentLink where LinkedEntityId = :caseId];
    for(ContentDocumentLink  Con: lConDocLink){
        NoteC.add(Con.ContentDocumentId);
    }
      
    List<ContentNote> Note = [select TextPreview from ContentNote where Id = :NoteC and (Title != 'Evento' and Title !='IDM' And Title !='MD') order by CreatedDate DESC];
      
      if(Note.size() > 0){
          TestoNote = Note[0].TextPreview;
      }
	      
    Date today = Date.today();
    Dossier__c dossier= SFAConvenzionamento.getDossier(dossierId);
    dossier.DataCompletamentoFiliale__c = today;
    dossier.Note__c=TestoNote;
    update dossier;
    XCSNoteUtils.postANote(caseId,SFAConvenzionamento.TITLE_NOTE_EVENTO,SFAConvenzionamento.NOTA_EVENTO_ACCOLLO_COMPLETAMENTOFILIALE);

    Case caseAttivita= SFAConvenzionamento.getCase(caseId);
    caseAttivita.Status=CaseUtils.INOLTRATO;
    caseAttivita=CaseUtils.aggiornaDispositionCase(caseAttivita,XCS_DispositionUtils.ACCOLLO_COMPLETO_FILIALE,false);
    caseAttivita=SFAConvenzionamento.utenteLavorazione(caseAttivita,GroupUtils.IDM_RITORNIPOSTALI,false,false);
    caseAttivita=CaseShareUtil.appendStringToCaseShare(caseAttivita,SFAConvenzionamento.sharingToIDM);
    update caseAttivita;
    Mail.add(CompassParametersUtils.getValue('Prod_Mail_IDM'));
      
    ListSendMail.add(EmailUtils.generateEmail('AvvisoAccolloIDM',Mail,dossierId));
    EmailUtils.sendEmail(ListSendMail);                  
  }

  @AuraEnabled
  public static UpdateStepLavorazioneData updateStepLavorazione(String dossierId, String caseId) {
    System.debug('*** caseId :: ' + caseId);

    String step = [SELECT Id, StepAttivitaConvenzionamento__c FROM Case WHERE Id = :caseId][0].StepAttivitaConvenzionamento__c;
    
    UpdateStepLavorazioneData usld = new UpdateStepLavorazioneData();
    
    if (SFAConvenzionamento.GAD_DocumentiObbligatori.equals(step)) {
      System.debug('*** step :: ' + step);

      List<SFADossierDocumento__c> lstDossierDocumentoObbligatori = 
        [SELECT Id, Document__c, TipoConv__c, Dossier__c, Collegato__c, IsDocumentoSelezionato__c, DocumentType__c, SFAConvenzDealerDocumentsList__c 
         FROM SFADossierDocumento__c 
         WHERE Dossier__c = :dossierId AND DocumentType__c = 'mandatory' and Rimozione_Logica__c = false];

      for (SFADossierDocumento__c documento : lstDossierDocumentoObbligatori) {
        if (documento.IsDocumentoSelezionato__c == false)
          usld.errorMessage = NOT_ALL_MANDATORY_DOCS_SELECTED;
      }

      List<SFADossierDocumento__c> lstDossierDocumentoAddizionali = 
        [SELECT Id, Document__c, TipoConv__c, Dossier__c, Collegato__c, IsDocumentoSelezionato__c, DocumentType__c, SFAConvenzDealerDocumentsList__c, RispostaDocumentiAddizionali__c
         FROM SFADossierDocumento__c 
         WHERE Dossier__c = :dossierId AND DocumentType__c = 'additional' AND Rimozione_Logica__c = false];

      
      usld.datiListaDocumenti = getRiepilogoDocumentiMancanti(dossierId);
System.debug('*** usld.datiListaDocumenti.lstDocumentoObbligatori.size()  :: ' + usld.datiListaDocumenti.lstDocumentoObbligatori.size() );
        System.debug('*** usld.datiListaDocumenti.lstDocumentoAddizionali.size() :: ' + usld.datiListaDocumenti.lstDocumentoAddizionali.size());
      //Se tutte le liste di documenti mancanti sono vuote allora procedi a generare la cover
      if (usld.datiListaDocumenti.lstDocumentoObbligatori.size() == 0 )
      //  && usld.datiListaDocumenti.lstDocumentoAddizionali.size() == 0) 
      {

        usld.newStep = SFAConvenzionamento.GAD_StampaCover;

      }
        
      //altrimenti vai alla pagina della lista documenti mancanti
      else {
        usld.newStep = SFAConvenzionamento.GAD_RiepilogoDocumentiMancanti;
      }

    }

    SFAConvenzionamento.updateStepLavorazione(caseId, usld.newStep);
    
    System.debug('*** usld :: ' + JSON.serialize(usld));
    return usld;
  }
    
    @AuraEnabled
    public static UpdateStepLavorazioneData TornaAdObbligatori (String caseId) {
        
        UpdateStepLavorazioneData usld = new UpdateStepLavorazioneData();
        usld.newStep = SFAConvenzionamento.GAD_DocumentiObbligatori;
        SFAConvenzionamento.updateStepLavorazione(caseId, usld.newStep);
    	return usld;
    }

  public static DatiListaDocumenti getRiepilogoDocumentiMancanti(String dossierId) {

    DatiListaDocumenti datiListaDocumenti = new DatiListaDocumenti();

    		List<Id> IdDoc = New List<Id>();
        Map<Id, Id> MapDocSel = new Map<Id, Id>();
        List<Id> IdDocA = New List<Id>();
        Map<Id, Id> MapDocASel = new Map<Id, Id>();
        
        List<SFADossierDocumento__c> lstDossierDocumentoObbligatori = 
            [SELECT Id, Document__c, TipoConv__c, Dossier__c, IsDocumentoSelezionato__c, DocumentType__c, DocumentDetails__c, SFAConvenzDealerDocumentsList__c 
             FROM SFADossierDocumento__c
             WHERE Dossier__c = :dossierId AND DocumentType__c = 'mandatory' and Rimozione_Logica__c = false];
       
        for (SFADossierDocumento__c documentoD : lstDossierDocumentoObbligatori) { 
        	IdDoc.add(documentoD.SFAConvenzDealerDocumentsList__c);
            
            if(documentoD.IsDocumentoSelezionato__c==false)
            {
                MapDocSel.put(documentoD.SFAConvenzDealerDocumentsList__c,documentoD.Id);
            }
            
        }
        
		List<SFAConvenzDealerDocumentsList__c  > lstDocumentoObbligatori = 
           [select Id, OwnerId, Name,  CodDocument__c, Document__c, FlgEsclusione__c, IdDocument__c from SFAConvenzDealerDocumentsList__c  where id=:IdDoc]; 
        
        for (SFAConvenzDealerDocumentsList__c documentoL : lstDocumentoObbligatori) {
            if(MapDocSel.containsKey(documentoL.Id)){
                datiListaDocumenti.lstDocumentoObbligatori.add(documentoL);  
        	}
        }
        
        List<SFADossierDocumento__c> lstDossierDocumentoAddizionali = 
            [SELECT Id, Document__c, TipoConv__c, Dossier__c, Collegato__c, IsDocumentoSelezionato__c, DocumentType__c, DocumentDetails__c, SFAConvenzDealerDocumentsList__c, RispostaDocumentiAddizionali__c 
             FROM SFADossierDocumento__c 
             WHERE Dossier__c = :dossierId AND DocumentType__c = 'additional' and Rimozione_Logica__c = false];
        
        for (SFADossierDocumento__c documentoD : lstDossierDocumentoAddizionali) { 
        	IdDocA.add(documentoD.SFAConvenzDealerDocumentsList__c);
            
            if(documentoD.IsDocumentoSelezionato__c==false)
            {
                MapDocASel.put(documentoD.SFAConvenzDealerDocumentsList__c,documentoD.Id);
            }
            
        }
        
		List<SFAConvenzDealerDocumentsList__c  > lstDocumentoAddizionali = 
           [select Id, OwnerId, Name,  CodDocument__c, Document__c, FlgEsclusione__c, IdDocument__c from SFAConvenzDealerDocumentsList__c  where id=:IdDocA];
        
        for (SFAConvenzDealerDocumentsList__c documentoL : lstDocumentoAddizionali) {
            if(MapDocASel.containsKey(documentoL.Id)){
                datiListaDocumenti.lstDocumentoAddizionali.add(documentoL);      	
        	}
        }

    return datiListaDocumenti;

  }
    
    @AuraEnabled
    public static void AnnullaAccollo(String caseId, String note)
    {   
		Case caseAttivita= SFAConvenzionamento.getCase(caseId);
		caseAttivita.Status=CaseUtils.ANNULLATO;
		caseAttivita=CaseUtils.aggiornaDispositionCase(caseAttivita,XCS_DispositionUtils.ACCOLLO_ANNULLATO_MD,false);
        caseAttivita.Utente_Lavorazione__c='';   //il case non è più in lavorazione da nessuno
		update caseAttivita;
         CancellazioneRimossi(CaseId);

        if(!String.isEmpty(note)){
            XCSNoteUtils.postANote(caseId,'Filiale',note);
        }
        else{
            XCSNoteUtils.postANote(caseId,'Filiale','ANNULLATO - FILIALE');
        }
	}
	
	
	    @AuraEnabled
    public static void CancellazioneRimossi(String caseId)
    {   
		Dossier__c dossier = SFAConvenzionamento.getIdAccollo_Dossier_ByCase(caseId);
        list<SFADossierDocumento__c> DossDocRemove = new  list<SFADossierDocumento__c>();
        list<Accolli_type__c> AccTypeRemove = new  list<Accolli_type__c>();
         System.debug('RimozzioneaccolloID:  ** '+dossier.Id);
        
        DossDocRemove = [SELECT Id FROM SFADossierDocumento__c  WHERE Dossier__c=:dossier.Id AND Rimozione_Logica__c = true];
        AccTypeRemove = [select Id From Accolli_type__c where Accollo_Id__c =:dossier.Id and Rimozione_Logica__c = true];
         System.debug('RimozzioneListaDoc:  ** '+DossDocRemove);
         System.debug('RimozzioneListaJunk:  ** '+AccTypeRemove);
        delete DossDocRemove;
        delete AccTypeRemove;
	}

  public class StatoAttributoData {
    @AuraEnabled
    public Date dataRiferimento {get; set;}
    @AuraEnabled
    public String stato {get; set;}
    @AuraEnabled
    public String attributo {get; set;}
    @AuraEnabled
    public Integer errorCode {get; set;}
  }

  public class DatiListaDocumenti {
    @AuraEnabled
    public List<SFADossierDocumento__c> lstDossierDocumentoObbligatori {get; set;}
    @AuraEnabled
    public List<SFADossierDocumento__c> lstDossierDocumentoAddizionali {get; set;}
    @AuraEnabled
    public List<String> lstSelectedRowsObbligatori {get; set;}
    @AuraEnabled
    public List<String> lstSelectedRowsAddizionali {get; set;}
      
    @AuraEnabled
    public List<SFAConvenzDealerDocumentsList__c> lstDocumentoObbligatori {get; set;}
    @AuraEnabled
    public List<SFAConvenzDealerDocumentsList__c> lstDocumentoAddizionali {get; set;}
    @AuraEnabled
    public List<String> lstSelectedObbligatori {get; set;}
    @AuraEnabled
    public List<String> lstSelectedAddizionali {get; set;}  
      
    @AuraEnabled
    public String step {get; set;}

    public DatiListaDocumenti() {
      this.lstDossierDocumentoObbligatori = new List<SFADossierDocumento__c>();
	  this.lstDocumentoObbligatori = new List<SFAConvenzDealerDocumentsList__c>();
	  this.lstDocumentoAddizionali = new List<SFAConvenzDealerDocumentsList__c>();
      this.lstDossierDocumentoAddizionali = new List<SFADossierDocumento__c>();
        
      this.lstSelectedRowsObbligatori = new List<String>();
  	  this.lstSelectedObbligatori = new List<String>();
      this.lstSelectedRowsAddizionali = new List<String>();
      this.lstSelectedAddizionali = new List<String>();
    }

  }

  public class InitData {
    @AuraEnabled
    public Integer errorCode {get; set;}
     @AuraEnabled
    public String errorDesc {get; set;}
    @AuraEnabled
    public String nuovoCaseId {get; set;}
    @AuraEnabled
    public Dossier__c dossier {get; set;}
    @AuraEnabled
    public String tipoChecklist {get; set;}
    @AuraEnabled
    public String dealerId {get; set;}
    @AuraEnabled
    public String dealerMasterId {get; set;}
    @AuraEnabled
    public Boolean isInManoAFiliale {get; set;}
    @AuraEnabled
    public Boolean abilitaAvviso {get; set;}
    @AuraEnabled
    public String CaseIdRec  {get; set;}

    @AuraEnabled
    public List<Accolli_Type_List__c>  Tipologie {get; set;}  
    @AuraEnabled
    public List<Id>  Selezione {get; set;}  
  }

  public class UpdateStepLavorazioneData {
    @AuraEnabled
    public String errorMessage {get; set;}
    @AuraEnabled
    public String newStep {get; set;}
    @AuraEnabled
    public DatiListaDocumenti datiListaDocumenti {get; set;}

    public UpdateStepLavorazioneData() {
      this.datiListaDocumenti = new DatiListaDocumenti();
    }
  }

}