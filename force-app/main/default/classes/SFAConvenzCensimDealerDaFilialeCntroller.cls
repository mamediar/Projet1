public class SFAConvenzCensimDealerDaFilialeCntroller {

  @AuraEnabled
  public static DatiCensimento salvaDatiDealer(String ragioneSociale,String personaDiRiferimento, String partitaIVA, String codiceFiscale, String indirizzo, String citta, String CAP, String provincia, String telefono, String telefonoCellulare, String emailPersonaDiRiferimento, String preferenze, String note) {
      DatiCensimento datiCensimento= new DatiCensimento();
      datiCensimento.dealerAttivitaInseriti=false;
      datiCensimento.erroreTecnico = 1;

      User u = [select firstname, lastname, DefaultQueueId__c from user where id=:userinfo.getuserid()][0];  //utente connesso (di filiale)
      String OCSExternalFiliale=u.DefaultQueueId__c;

      List<Account> lstDealerEsistentePerPIoCF = SFAConvenzVerificaSeDealerEsistente.getListDealerEsistentePerPIoCF(partitaIVA, codiceFiscale);

      System.debug('*** lstDealerEsistentePerPIoCF.size() :: ' + lstDealerEsistentePerPIoCF.size());

      List<Account> lstDealerEsistentePerRagioneSociale = SFAConvenzVerificaSeDealerEsistente.getListDealerEsistentePerRagioneSociale(ragioneSociale);

      System.debug('*** lstDealerEsistentePerRagioneSociale.size() :: ' + lstDealerEsistentePerRagioneSociale.size());
      
      System.debug('*** lstDealerEsistentePerPIoCF_partitaIVA :: ' + partitaIVA);
      System.debug('*** lstDealerEsistentePerPIoCF_codiceFiscale:: ' + codiceFiscale); 
      
      //check email format::
      if(!String.isEmpty(emailPersonaDiRiferimento) && !ValidationUtils.isEmailValida(emailPersonaDiRiferimento)){
          datiCensimento.erroreTecnico=0;      
      }
      else if (lstDealerEsistentePerPIoCF.size() > 0 && lstDealerEsistentePerPIoCF[0].Branch__r.OCS_External_Id__c != OCSExternalFiliale) {
         datiCensimento.erroreTecnico = -1;
         datiCensimento.messaggioErrore = 'Prospect già censito: ' + lstDealerEsistentePerPIoCF[0].Name + 
         ' associato alla filiale: ' + lstDealerEsistentePerPIoCF[0].Branch__r.getCodice_Cliente__c;
      }
      else if (lstDealerEsistentePerRagioneSociale.size() > 0 && ((partitaIVA == null || partitaIVA == '') && (codiceFiscale == null || codiceFiscale ==''))) {
         datiCensimento.erroreTecnico = -2;
         
         datiCensimento.messaggioErrore = 'Un prospect con ragione sociale simile già censito e associato alla filiale: ' + 
            lstDealerEsistentePerRagioneSociale[0].Branch__r.getCodice_Cliente__c + '. Prova ad inserire P.IVA o C.F. per una ricerca più precisa';
      }
      else if (lstDealerEsistentePerPIoCF.size() > 0 && lstDealerEsistentePerPIoCF[0].Branch__r.OCS_External_Id__c == OCSExternalFiliale) {

          Boolean hasAttivitaDiConvenzionamento = hasAttivitaDiConvenzionamentoInCorso(lstDealerEsistentePerPIoCF[0].Id);

          if (lstDealerEsistentePerPIoCF[0].Status__c == 'AT' || lstDealerEsistentePerPIoCF[0].Status__c == 'FL') {
              datiCensimento.erroreTecnico = -3;
              datiCensimento.messaggioErrore = 'Il convenzionato è in stato AT o FL';
          }
          else if (hasAttivitaDiConvenzionamento) {
              datiCensimento.erroreTecnico = -4;
              datiCensimento.messaggioErrore = 'Attività di convenzionamento o segnalazione in corso';
          }
          else {
              datiCensimento.erroreTecnico = 2;
          }
      }

      System.debug('*** erroreTecnico :: ' + datiCensimento.erroreTecnico);
             
      if(datiCensimento.erroreTecnico > 0 && !String.isEmpty(ragioneSociale) && !String.isEmpty(personaDiRiferimento) && (!String.isEmpty(partitaIVA) || !String.isEmpty(codiceFiscale))){
              
              //***********Account Dealer:
              Account dealerSegnalato=new Account();

              if (datiCensimento.erroreTecnico == 1) {
                Date today=Date.today();
                List<RecordType> recordTypeIdDealer=[SELECT Id FROM RecordType where Name='Dealer'];
                if (recordTypeIdDealer.size()>0){
                    dealerSegnalato.RecordTypeId=recordTypeIdDealer[0].id; 
                } 
                dealerSegnalato.Name=ragioneSociale;  
                dealerSegnalato.DataSegnalazione__c=today;
                dealerSegnalato.Partita_IVA__c=partitaIVA;
                dealerSegnalato.Codice_Fiscale__c=codiceFiscale;
                dealerSegnalato.ShippingStreet=indirizzo;  
                dealerSegnalato.ShippingPostalCode=CAP;
                dealerSegnalato.ShippingCity=citta;
                dealerSegnalato.ShippingState=provincia;                 
                dealerSegnalato.CodiceAgente__c ='12';  
                dealerSegnalato.Status__c ='IS';
                dealerSegnalato.FlagAllProfRist__c ='S';
                dealerSegnalato.FlagAllProforma__c ='S';
                dealerSegnalato.FlagProfRist__c ='S';
                dealerSegnalato.FlagProforma__c ='S';          
                List<Account> filialeAssociata=AccountUtils.getBranch(OCSExternalFiliale.substring(1, OCSExternalFiliale.length()));
                if(filialeAssociata.size()<1){
                    System.debug('nessuna filiale associata all\'utente connesso');
                } else {                  
                    dealerSegnalato.Branch__c=filialeAssociata[0].id; //lego l'account alla filiale
                }
                insert dealerSegnalato;
                System.debug('dealerSegnalato riga 185:: '+dealerSegnalato);          
            
                Contact dealerSegnalatoContact=new Contact(); 
                dealerSegnalatoContact.AccountId=dealerSegnalato.Id;
                dealerSegnalatoContact.Phone=telefono; 
                dealerSegnalatoContact.MobilePhone=telefonoCellulare;  
                dealerSegnalatoContact.Email=emailPersonaDiRiferimento; 
                System.debug('email 1:: '+emailPersonaDiRiferimento);
                System.debug('email:: '+dealerSegnalatoContact.Email);
                if(String.isEmpty(personaDiRiferimento)){
                    dealerSegnalatoContact.LastName='_';   
                } else {
                    dealerSegnalatoContact.LastName=personaDiRiferimento;   
                }           
                dealerSegnalatoContact.IsContactDiRiferimentoDealer__c=true;
                insert dealerSegnalatoContact; 
                        
              }
              
              //***********Crea nuova attività con stato "Segnalazione Dealer": 
              Case attivitaSegnalazioneDealer=new Case();

              if (datiCensimento.erroreTecnico == 1)
                attivitaSegnalazioneDealer.AccountId=dealerSegnalato.id;
              if (datiCensimento.erroreTecnico == 2)
                attivitaSegnalazioneDealer.AccountId=lstDealerEsistentePerPIoCF[0].id;

              attivitaSegnalazioneDealer.Subject = CaseUtils.SFA_SUBJECT_NEW_DEALER_PROSPECT;
              attivitaSegnalazioneDealer.Categoria_Riferimento__r = XCS_CategoriaUtil.getCategoryForExternalId(XCS_CategoriaUtil.SFA_CONVENZIONAMENTO_NEW_DEALER_PROSPECT);
              attivitaSegnalazioneDealer.StepAttivitaConvenzionamento__c = SFAConvenzionamento.NewDealerProspect_StepIniziale; 
              attivitaSegnalazioneDealer.RecordTypeId=RecordTypeUtil.getCaseRecordType('SFA_Convenzionamento');   
          	  attivitaSegnalazioneDealer.OCSExternalFilialeConvenzionato__c=OCSExternalFiliale;
              insert attivitaSegnalazioneDealer;
              if(!String.isEmpty(u.DefaultQueueId__c)){
                  CaseUtils.assignToQueue(attivitaSegnalazioneDealer.id,OCSExternalFiliale);
              }
              
              datiCensimento.attivitaId=attivitaSegnalazioneDealer.id;    
              datiCensimento.dealerAttivitaInseriti=true;  
          
          
          	 //allega note e preferenze al case:  
              if(!String.isEmpty(note)){
                  XCSNoteUtils.postANote(attivitaSegnalazioneDealer.id,CaseUtils.SFA_SUBJECT_SEGNALAZ_DEALER+' Note',note);
              } 
              if(!String.isEmpty(preferenze)){
                  XCSNoteUtils.postANote(attivitaSegnalazioneDealer.id,CaseUtils.SFA_SUBJECT_SEGNALAZ_DEALER+' Preferenze',preferenze);
              }           
          }  
          

    return datiCensimento;  
      
  }

  public static Boolean hasAttivitaDiConvenzionamentoInCorso(String dealerId) {
      
      List<Case> lstAttivita=[SELECT id, isClosed, CategoriaExternalId__c, Disposition__c, Categoria_Riferimento__c,CreatedDate,Esito__c FROM Case WHERE AccountId = :dealerId ORDER BY CreatedDate DESC];
      for (Case attivita : lstAttivita) {
          if ( (attivita.CategoriaExternalId__c == XCS_CategoriaUtil.SFA_CONVENZIONAMENTO_SEGNALAZ_DEALER ||
              attivita.CategoriaExternalId__c == XCS_CategoriaUtil.SFA_CONVENZIONAMENTO_NEW_DEALER_PROSPECT ||
              attivita.CategoriaExternalId__c == XCS_CategoriaUtil.SFA_CONVENZIONAMENTO_NEW_DEALER_ACQUISITION)
              && attivita.IsClosed==false ) {

                return true; 

          }
      }
      return false;
  }    
    
    
	public class DatiCensimento {
        @AuraEnabled
        public Boolean dealerAttivitaInseriti {get; set;}
        @AuraEnabled
        public String attivitaId {get; set;}     
        @AuraEnabled
        public Integer erroreTecnico {get; set;}
        @AuraEnabled
        public String messaggioErrore {get; set;}         
    }     
    
}