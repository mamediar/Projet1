public class SFAConvenzGestAccolloGeneraCoverCtrller {
 
  public String ragioneSociale {get; set;}
  public String ocsCode {get; set;}
  public String ragioneSocialeM {get; set;}
  public String ocsCodeM {get; set;}
  public String numeroRiferimento {get; set;}
  public String barCode {get; set;}
  public String nomeFiliale {get; set;}
  public String ocsCodeFiliale {get; set;}
  public String dateTimeNow {get; set;}
  public Boolean isDossierReinviato {get; set;}

  public List<String> lstObbligatori {get; set;}
  public List<String> lstCollegati {get; set;}
  public List<String> lstAddizionali {get; set;}
  public List<String> lstNote {get; set;}
  public List<String> lstStrNote {get; set;}
  public Integer lstStrNoteSize {get; set;}

  public void getDocumenti(){

    lstObbligatori = new List<String>();
    lstCollegati = new List<String>();
    lstAddizionali = new List<String>();
    lstNote = new List<String>();

    String dossierId = ApexPages.currentPage().getParameters().get('dossierId');
    system.debug('Genera Coveeeerrrr Pre : '+dossierId);

      if(dossierId != '' && dossierId != 'undefined' && dossierId != null)
      {
      		system.debug('Genera Coveeeerrrr Normale'); 
        	Dossier__c dossier = 
          	[SELECT Tipo__c,Id, Name, NumeroRiferimento__c, BarCode__c, IdAttivita__c, IdAttivita__r.AccountId, IsDossierReinviato__c
          	FROM Dossier__c 
          	WHERE Id = :dossierId][0];
    
        	String caseId = dossier.IdAttivita__c;
        	string Tipo = dossier.Tipo__c;
    
            numeroRiferimento = dossier.NumeroRiferimento__c;
            barCode = dossier.BarCode__c;
        	isDossierReinviato = dossier.IsDossierReinviato__c;
    
        	String dealerId = dossier.IdAttivita__r.AccountId;
    
        	Account dealer = 
          	[SELECT Id, Name,ParentId, Partita_IVA__c, OCS_External_Id__c, Branch__r.Name, Branch__r.OCS_External_Id__c
          	FROM Account
          	WHERE Id = :dealerId][0];
         
          	
          	String dealerMasterId =  dealer.ParentId;
         	 system.debug('dealerMasterId**:'+dealerMasterId);
          	if(dealerMasterId != '' && dealerMasterId != null)
            {
                Account dealerM = 
                [SELECT Id, Name, OCS_External_Id__c
                FROM Account
                WHERE Id = :dealerMasterId]; 
                
                ragioneSocialeM = dealerM.Name;
            	ocsCodeM = dealerM.OCS_External_Id__c != null ? dealerM.OCS_External_Id__c.substring(1) : dealerM.OCS_External_Id__c;
                 system.debug('ragioneSocialeM**:'+ragioneSocialeM);
            }
            ragioneSociale = dealer.Name;
            ocsCode = dealer.OCS_External_Id__c != null ? dealer.OCS_External_Id__c.substring(1) : dealer.OCS_External_Id__c;
            
          
            nomeFiliale = dealer.Branch__r.Name;
            ocsCodeFiliale = dealer.Branch__r.OCS_External_Id__c;
            
            dateTimeNow = String.valueOf(DateTime.now());
    
        	List<SFADossierDocumento__c> lstDossierDocumentoObbligatori = 
          	[SELECT Id, Document__c, TipoConv__c, Dossier__c, Collegato__c, IsDocumentoSelezionato__c, DocumentType__c, DocumentDetails__c, SFAConvenzDealerDocumentsList__c 
           	FROM SFADossierDocumento__c
          	WHERE Dossier__c = :dossierId  AND IsDocumentoSelezionato__c = true and Rimozione_Logica__c = false];
    
        	List<SFADossierDocumento__c> documentiList = SFAConvenzionamento.getDocumentiList(lstDossierDocumentoObbligatori);
          
        	for (SFADossierDocumento__c documento : documentiList) {
          	lstObbligatori.add(documento.Document__c);
        	}
          
          
        	List<ContentNote> lstNote = XCSNoteUtils.getAllNotes(caseId);
    
        	System.debug('*** lstNote :: ' + JSON.serialize(lstNote));
    
        	List<String> lstDefaultQueueId = new List<String>();
    
        	for (ContentNote note : lstNote) {
          	lstDefaultQueueId.add(note.CreatedBy.DefaultQueueId__c);
        	}
    
        	Set<String> setDefaultQueueId = new Set<String>();
        	setDefaultQueueId.addAll(lstDefaultQueueId);
    
        	List<Account> lstFiliale = [SELECT Id, Name, OCS_External_Id__c FROM Account WHERE RecordType.Name = 'Branch' AND OCS_External_Id__c IN :setDefaultQueueId];
    
        	Map<String, String> mapOCSCodeName = new Map<String, String>();
    
        	for (Account filiale : lstFiliale) {
          		mapOCSCodeName.put(filiale.OCS_External_Id__c, filiale.Name);
        	}
    
        	lstStrNote = new List<String>();
    
        	for (ContentNote note : lstNote) {
          		String createdDate = DateUtils.formatDateDDslashMMslashYYYY(note.CreatedDate);
          		String defaultQueueId = note.CreatedBy.DefaultQueueId__c;
            	String nomeFiliale = mapOCSCodeName.get(defaultQueueId);
          		String aliasUtente = note.CreatedBy.Alias;
          		String noteBody = note.TextPreview;
          		lstStrNote.add(createdDate + ' - ' + nomeFiliale + ' - ' + aliasUtente + ' - ' + noteBody);
        	}
    
        	lstStrNoteSize = lstStrNote.size();
    
       	 System.debug('*** lstStrNote :: ' + JSON.serialize(lstStrNote));
      }
      else
      {      
          String AccId = ApexPages.currentPage().getParameters().get('AccId');
          String Tipo = ApexPages.currentPage().getParameters().get('Tipo');
          String CaseId = ApexPages.currentPage().getParameters().get('CaseId');
          System.debug('*** lCOVERFITTIZIAAAA- AccId :: '+AccId);
          System.debug('*** lCOVERFITTIZIAAAA- Tipo :: '+Tipo);
          System.debug('*** lCOVERFITTIZIAAAA- CaseId :: '+CaseId);
           if(AccId.substring(0,1) != 'D')
            	AccId = 'D'+AccId;
          
          Account dealer = 
          [SELECT Id, Name,ParentId, Partita_IVA__c, OCS_External_Id__c, Branch__r.Name, Branch__r.OCS_External_Id__c
          FROM Account
          WHERE OCS_External_Id__c = :AccId];
         
          String dealerMasterId =  dealer.ParentId;
            system.debug('dealerMasterId**:'+dealerMasterId);
          if(dealerMasterId != '' && dealerMasterId != null)
          {
              Account dealerM = 
              [SELECT Id, Name, OCS_External_Id__c
              FROM Account
              WHERE Id = :dealerMasterId]; 
              
              ragioneSocialeM = dealerM.Name;
              ocsCodeM = dealerM.OCS_External_Id__c != null ? dealerM.OCS_External_Id__c.substring(1) : dealerM.OCS_External_Id__c;
              system.debug('ragioneSocialeM**:'+ragioneSocialeM);
          }
          
          ragioneSociale = dealer.Name;
          ocsCode = dealer.OCS_External_Id__c != null ? dealer.OCS_External_Id__c.substring(1) : dealer.OCS_External_Id__c;
           
            
          dateTimeNow = String.valueOf(DateTime.now());
          
          case CaseF = [select CreatedDate,CaseNumber from case where id=:CaseId];

          string anno = String.valueOf(CaseF.CreatedDate.year());
           string mese = String.valueOf(CaseF.CreatedDate.Month());
           string giorno = String.valueOf(CaseF.CreatedDate.Day());
          
          barCode = OCSCode.leftPad(12,'0')+
             			'-01-'+
						anno.right(2)+
						mese.leftPad(2,'0')+
						giorno.leftPad(2,'0')+'-'+
             			'AF' + '-' +
						CaseF.CaseNumber.leftPad(9,'0') ;
          
		 numeroRiferimento = anno.right(2) +	mese.leftPad(2,'0')+ giorno.leftPad(2,'0')+'-'+CaseF.CaseNumber;
          

    
      	List<ContentNote> lstNote = XCSNoteUtils.getAllNotes(caseId);
    
        System.debug('*** lstNote :: ' + JSON.serialize(lstNote));
    
        List<String> lstDefaultQueueId = new List<String>();
    
        for (ContentNote note : lstNote) {
          lstDefaultQueueId.add(note.CreatedBy.DefaultQueueId__c);
        }
    
        Set<String> setDefaultQueueId = new Set<String>();
        setDefaultQueueId.addAll(lstDefaultQueueId);
    
        List<Account> lstFiliale = [SELECT Id, Name, OCS_External_Id__c FROM Account WHERE RecordType.Name = 'Branch' AND OCS_External_Id__c IN :setDefaultQueueId];
    
        Map<String, String> mapOCSCodeName = new Map<String, String>();
    
        for (Account filiale : lstFiliale) {
          mapOCSCodeName.put(filiale.OCS_External_Id__c, filiale.Name);
        }
    
        lstStrNote = new List<String>();
    
        for (ContentNote note : lstNote) {
          String createdDate = DateUtils.formatDateDDslashMMslashYYYY(note.CreatedDate);
          String defaultQueueId = note.CreatedBy.DefaultQueueId__c;
          String nomeFiliale = mapOCSCodeName.get(defaultQueueId);
          String aliasUtente = note.CreatedBy.Alias;
          String noteBody = note.TextPreview;
          lstStrNote.add(createdDate + ' - ' + nomeFiliale + ' - ' + aliasUtente + ' - ' + noteBody);
        }
    
        lstStrNoteSize = lstStrNote.size();  
        System.debug('*** barCode :: ' + barCode);
                  
        System.debug('*** lstStrNote :: ' + lstStrNote);
		System.debug('*** lstStrNoteSize :: ' + lstStrNoteSize);
      }
  }

}