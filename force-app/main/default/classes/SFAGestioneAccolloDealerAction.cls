public class SFAGestioneAccolloDealerAction extends XCSMenuAction {

  public static final String AT = 'AT';
  public static final String FL = 'FL';
  public static final String IS = 'IS';
  public static final String CH = 'CH';
  public static final String PV = 'PV';

  public final String STATUS_NOT_AT_FL = 'STATUS_NOT_AT_FL';
  public final String ACTIVATION_DATE_TOO_OLD = 'ACTIVATION_DATE_TOO_OLD';
  public final String DEALER_IS_PV = 'DEALER_IS_PV';
  public final String CREA_ACCOLLO = 'CREA_ACCOLLO';
  public final String STATUS_NOT_GESTITO = 'STATUS_NOT_GESTITO';

  public override XCSMenuActionResult preRedirect() {

    XCSMenuActionResult res = new XCSMenuActionResult('standard__recordPage');

    String dealerId = getAccount().Id;
    String TipoIntermediario = getAccount().Tipo_Intermediario__c;
     System.debug('VERIFICAAAAAAAA');
    //InitData initData = new InitData();
    //XCSMenuActionResult.DatiConvenzionamento datiConvenzionamento =  new XCSMenuActionResult.DatiConvenzionamento();

//   String tipoChecklist = SFAConvenzGestioneDossierController.getTipoChecklist(dealerId);
 //   System.debug('*** tipoChecklist :: ' + tipoChecklist);
    //datiConvenzionamento.tipoChecklist = tipoChecklist;

    
    String dealerOCSExternalId = [SELECT Id, CodiceAgente__c, OCS_External_Id__c , Tipo_Intermediario__c
      FROM Account 
      WHERE RecordType.Name = 'Dealer' AND Id = :dealerId][0].OCS_External_Id__c;

    StatoAttributoData sad = getStatoAttributoData(dealerOCSExternalId);
    System.debug('*** sad :: ' + JSON.serialize(sad));

    if (sad.errorCode != null) {
      //datiConvenzionamento.errorCode = sad.errorCode;
      res.getAttributes().setIsOk(false);
      if (sad.errorCode == 'STATUS_NOT_AT_FL')
        res.getAttributes().setErrorMessage('Per creare un\'attività di gestione Accollo lo stato deve essere settato con AT o FL');
		
      if(sad.errorCode == 'OSC_CODE_NULL'){
                res.getAttributes().setErrorMessage('Codice OCS non presente');
      } 
      return res; 
    }

    Id queueMDId = GroupUtils.getQueue(SFAConvenzionamento.queueMD).Id;

    String utenteId = UserInfo.getUserId();
    String filialeQueue = [SELECT Id, DefaultQueueId__c FROM User WHERE Id = :utenteId][0].DefaultQueueId__c;
    System.debug('*** filialeQueue :: ' + filialeQueue);
	String ProfileId = UserInfo.getProfileId();
    Profile Prof = [select name from Profile where id=:ProfileId];
        
    if (prof.Name=='System Administrator')
       	filialeQueue='F80';
    Id queueFilialeId = GroupUtils.getQueue(filialeQueue).Id;

    // eseguo la logica fino al punto 3 poi eseguo il punto 4, come segue
    XCS_Categoria__c categoriaD = XCS_CategoriaUtil.getCategoryForExternalId(XCS_CategoriaUtil.SFA_CONVENZIONAMENTO_GESTIONE_DOSSIER_DEALER);
    XCS_Categoria__c categoria = XCS_CategoriaUtil.getCategoryForExternalId(XCS_CategoriaUtil.SFA_CONVENZIONAMENTO_GESTIONE_ACCOLLO_DEALER);

    System.debug('*** categoriaD :: ' + JSON.serialize(categoriaD));

    List<Case> lstDossierCaseEsistente = 
      [SELECT Id, CaseNumber, Categoria_Riferimento__r.External_Id__c, Status
      FROM Case 
      WHERE AccountId = :dealerId AND Categoria_Riferimento__r.External_Id__c = :categoriaD.External_Id__c  and Status = 'Gestito'
      ORDER BY CreatedDate DESC];
      
      List<Case> lstDossierInLavorazione = 
      [SELECT Id, CaseNumber, Categoria_Riferimento__r.External_Id__c, Status
      FROM Case 
      WHERE AccountId = :dealerId AND Categoria_Riferimento__r.External_Id__c = :categoriaD.External_Id__c  and Status != 'Annullato'  AND Status != 'Gestito' and Status != 'Chiuso' 
      ORDER BY CreatedDate DESC];
      
  	List<Case> lstAccolloCaseInLavorazione = 
      [SELECT Id, CaseNumber, Categoria_Riferimento__r.External_Id__c, Status
      FROM Case 
      WHERE AccountId = :dealerId AND Categoria_Riferimento__r.External_Id__c = :categoria.External_Id__c AND Status != 'Annullato' AND Status != 'Chiuso' AND Status != 'Gestito'
      ORDER BY CreatedDate DESC];
   	  System.debug('*** lstAccolloCaseInLavorazione :: ' + JSON.serialize(lstAccolloCaseInLavorazione));
    
     
		Case CaseEsistente2 = (lstDossierCaseEsistente.size() != 0) ? lstDossierCaseEsistente[0] : null;
       
    Date today = Date.today();
      
	if(lstDossierCaseEsistente.size() == 0 && TipoIntermediario !='PV'){
          System.debug('*** DOSSIER NON PRESENTE');
          res.getAttributes().setIsOk(false);
                res.getAttributes().setErrorMessage('Non esiste un dossier Gestito associato al dealer selezionato, occorre creare un’attività di Gestione Dossier Dealer o gestire quella esistente.');
          return res;
        
    }
      
    else if (TipoIntermediario =='PV' && lstDossierCaseEsistente.size() == 0) {
    	if (lstAccolloCaseInLavorazione.size() != 0 ){
        	System.debug('*** Accollo IN CORSO');
          	res.getAttributes().setIsOk(false);
            res.getAttributes().setErrorMessage('Esiste già un attività di Nuovo Accollo in corso associata al dealer: Impossibile creare un nuovo accollo');
          	return res;
   		 }
        else
        {
            Case nuovoCaseAccollo = CaseUtils.getCase(RecordTypeUtil.SFA_CONVENZIONAMENTO,XCS_CategoriaUtil.SFA_CONVENZIONAMENTO_GESTIONE_ACCOLLO_DEALER);
            nuovoCaseAccollo = XCS_DispositionUtils.aggiungiDispositionCase(nuovoCaseAccollo, XCS_DispositionUtils.NUOVO_ACCOLLO);
      		nuovoCaseAccollo.AccountId = dealerId;
      		nuovoCaseAccollo.StepAttivitaConvenzionamento__c=SFAConvenzionamento.GAD_DocumentiObbligatori;   
     		nuovoCaseAccollo.Subject=CaseUtils.SFA_SUBJECT_GESTIONE_ACCOLLO;
      		nuovoCaseAccollo.DataCreazioneDossier__c=datetime.now();
            nuovoCaseAccollo.OCSExternalFilialeConvenzionato__c = filialeQueue;
     		insert nuovoCaseAccollo;
       
     		 String caseNumber = [SELECT Id, CaseNumber FROM Case WHERE Id = :nuovoCaseAccollo.Id][0].CaseNumber;

            Dossier__c Accollo = new Dossier__c();
            Accollo.IdAttivita__c = nuovoCaseAccollo.Id;
            Accollo.Tipo__c = 'Accollo';
            Accollo.DataRiferimento__c = sad.dataRiferimento;
            Accollo.Name = DateUtils.formatDateYYMMDD(today)+'-'+caseNumber;
            insert Accollo;

            res.getAttributes().setRecordId(nuovoCaseAccollo.Id);
        }
    }
    else if (lstDossierCaseEsistente.size() > 0 && !'Closed'.equals(CaseEsistente2.status) && !'Gestito'.equals(CaseEsistente2.status)) {
        
         System.debug('*** DOSSIER IN CORSO');
          res.getAttributes().setIsOk(false);
                res.getAttributes().setErrorMessage('Il dossier è ancora in lavorazione : impossibile proseguire nell attività di accollo');
          return res;
        
    }
    else if (lstAccolloCaseInLavorazione.size() != 0 ){
        System.debug('*** Accollo IN CORSO');
          res.getAttributes().setIsOk(false);
                res.getAttributes().setErrorMessage('Esiste già un attività di Nuovo Accollo in corso associata al dealer: Impossibile creare un nuovo accollo');
          return res;
    }
   else{
   
      
  		Case dossierCaseEsistente = lstDossierCaseEsistente[0];
      List<Dossier__c> lstDossierEsistente = [SELECT Id, Name, DataRiferimento__c, IdAttivita__r.AccountId, IsCaseDossierEsistente__c FROM Dossier__c WHERE IdAttivita__c = :dossierCaseEsistente.Id ORDER BY CreatedDate DESC];
      if (lstDossierEsistente.size() > 0 || lstDossierInLavorazione.size() == 0 )  {
        Dossier__c DossierEsistente = lstDossierEsistente.get(0);
        
            
          System.debug('*** riga 257_: '+ sad.dataRiferimento + '___ '+DossierEsistente.DataRiferimento__c);

             Case nuovoCaseAccollo = CaseUtils.getCase(RecordTypeUtil.SFA_CONVENZIONAMENTO,XCS_CategoriaUtil.SFA_CONVENZIONAMENTO_GESTIONE_ACCOLLO_DEALER);
            nuovoCaseAccollo = XCS_DispositionUtils.aggiungiDispositionCase(nuovoCaseAccollo, XCS_DispositionUtils.NUOVO_ACCOLLO);
      		nuovoCaseAccollo.AccountId = dealerId;
      		nuovoCaseAccollo.StepAttivitaConvenzionamento__c=SFAConvenzionamento.GAD_DocumentiObbligatori;   
      		//nuovoCaseAccollo.ActivityType__c=CaseUtils.SFA_GESTIONE_ACCOLLO_DEALER;   //new activity di Gestione Dossier
     		nuovoCaseAccollo.Subject=CaseUtils.SFA_SUBJECT_GESTIONE_ACCOLLO;
      		nuovoCaseAccollo.DataCreazioneDossier__c=datetime.now();
            nuovoCaseAccollo.OCSExternalFilialeConvenzionato__c = filialeQueue;
           // nuovoCaseAccollo.Dossier__c = DossierEsistente.Id;
      		insert nuovoCaseAccollo;

            String caseNumber = [SELECT Id, CaseNumber FROM Case WHERE Id = :nuovoCaseAccollo.Id][0].CaseNumber;

            Dossier__c Accollo = new Dossier__c();
            Accollo.IdAttivita__c = nuovoCaseAccollo.Id;
            Accollo.Tipo__c = 'Accollo';
            Accollo.Dossier__c = DossierEsistente.Id;
            Accollo.DataRiferimento__c = sad.dataRiferimento;
            Accollo.Name = DateUtils.formatDateYYMMDD(today)+'-'+caseNumber;
            insert Accollo;

            res.getAttributes().setRecordId(nuovoCaseAccollo.Id);
            //datiConvenzionamento.dossier = dossier;
          
          
        }
       
       else {
          System.debug('*** STATUS_NOT_GESTITO');
          res.getAttributes().setIsOk(false);
                res.getAttributes().setErrorMessage('Esiste un dossier attualmente in lavorazione. Richiederne la chiusura se la posizione è rimasta aperta per errore.');
          //datiConvenzionamento.errorCode = STATUS_NOT_GESTITO;
          //res.getAttributes().setDatiConvenzionamento(datiConvenzionamento);
          return res;
        }
           
    }

        res.getAttributes().setObjectApiName(res.CASEAPINAME);  
        res.getAttributes().setActionName(res.VIEWACTION);
    //res.getAttributes().setDatiConvenzionamento(datiConvenzionamento);

    System.debug('*** res :: ' + JSON.serialize(res));
    return res;

  }

  @AuraEnabled
  public static StatoAttributoData getStatoAttributoData(String dealerOCSExternalId) {

    System.debug('*** dealerOCSExternalId :: ' + dealerOCSExternalId);

    StatoAttributoData sad = new StatoAttributoData();
	if(dealerOCSExternalId != null)
    {
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
                sad.errorCode = 'STATUS_NOT_AT_FL';
                System.debug('*** riga 126');
                System.debug('*** getStatoAttributoData - sad :: ' + JSON.serialize(sad));
                return sad;
              }
              if (AT.equals(sad.stato)) {
                sad.dataRiferimento = DateUtils.parseFromYYYYMMDDString(listaStati.get(i).dataRiferimento);
                System.debug('*** getStatoAttributoData - sad :: ' + JSON.serialize(sad));
                System.debug('*** riga 131');
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
    
        /*Account dealer = [SELECT Id, DataRiferimento__c FROM Account WHERE OCS_External_Id__c = :dealerOCSExternalId][0];
    
        System.debug('*** dealer :: ' + JSON.serialize(dealer));
    
        dealer.DataRiferimento__c = sad.dataRiferimento;
        update dealer;*/
    
 //       if (sad.dataRiferimento.daysBetween(Date.today()) > 120)
  //        sad.errorCode = 'ACTIVATION_DATE_TOO_OLD';
    }
    else{
            sad.errorCode = 'OSC_CODE_NULL';
            
    }
    System.debug('*** getStatoAttributoData - sad :: ' + JSON.serialize(sad));
    return sad;

  }

  public class StatoAttributoData {
    @AuraEnabled
    public Date dataRiferimento {get; set;}
    @AuraEnabled
    public String stato {get; set;}
    @AuraEnabled
    public String attributo {get; set;}
    @AuraEnabled
    public String errorCode {get; set;}
  }

}