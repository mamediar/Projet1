/* 
* Autheur : Sana Badji 
* description Class created for handle  Anomalie by Family: DS
* @date  27/06/2019
*/
public with sharing class AnomalieDocProductDS {

  public static final String AFTER_FIVE_DAYS = 'afterFiveDays';
  public static  Set<Id> idCase = new Set<Id>();
  public static   List<Case> listCaseToUpdate = new List<Case>();

    public AnomalieDocProductDS() {

    }

/* 
    * Autheur : Sana Badji 
    * @param idAccount
    * @param idCases
    *@date  16/05/2019
    */  
      public static Set<Id>  dEMAnomalieDocumentaliDS (Id idAccount, Set<Id> idCases){
            List<Anomalie_Doc__c> anomalibyId =AnomalieSelector.listAnomalieByID(idCases);
            List<XCS_Template__c> templateAnoContpp = AnomalieSelector.templateTesto('SMSAnomalieContratto_DS');
            List<XCS_Template__c> templateAnoDocpp = AnomalieSelector.templateTesto('SMSAnomalieDoc_DS');
            Account getAccount=AnomalieSelector.getAccount(idAccount);
            String telefonoCellulare;
            Id  caseId;
            String descrizioneAnomaliaop;
            String roLinkbozza;
            String email;
            List<Case> cases = new List<Case>();
            if(anomalibyId.size() == 0 || getAccount ==null)
              {
                System.debug('******** anomalibyId is empty'+anomalibyId.size());
                System.debug('******** Account is '+getAccount);
              }else
              {
                System.debug('******** anomalibyId '+anomalibyId.size());
                for(Anomalie_Doc__c ano: anomalibyId ){
                    if(ano.CaseId__r.Stato_Pratica__c!= null && 
                    ano.Descrizione_Anomalia_Op__c != null)
                    {
                    caseId= ano.CaseId__c;
                    descrizioneAnomaliaop=ano.Descrizione_Anomalia_Op__c;
                    telefonoCellulare=getAccount.Telefono_Cellulare__c;
                    roLinkbozza= ano.CaseId__r.RO_Link_Bozza__c;
                    email=getAccount.PersonEmail;
                    // Send Mail 
                    CaseDomain.mailDem('2069', caseId, getAccount.Name+', il tuo contratto di Prestito Online Compass è pronto!', 
                    'richiesta@compass.it', 'Compass Banca S.p.a');
                    // Send Sms
                    OCSInviaSMSInvoker.inviaSMS('',telefonoCellulare,'','',templateAnoContpp[0].Body__c);
                    // Create Note
                    CallWebService.createNote('Inviata mail DEMAnomalieContrato_DS',email,roLinkbozza,descrizioneAnomaliaop,caseId);
                    System.debug('************ DEM And SMS Anomalie Contratto PP sended Succesfully');
                    }else if(ano.CaseId__r.Stato_Pratica__c == null && 
                    ano.Descrizione_Anomalia_Op__c == null){
                    caseId= ano.CaseId__c;
                    descrizioneAnomaliaop=ano.Descrizione_Anomalia_Op__c;
                    telefonoCellulare=getAccount.Telefono_Cellulare__c;
                    roLinkbozza= ano.CaseId__r.RO_Link_Bozza__c;
                    email=getAccount.PersonEmail;
                    System.debug('************ caseId Documentali PP '+caseId);
                    // Send Mail 
                    CaseDomain.mailDem('2068', caseId, getAccount.Name+',abbiamo bisogno di te!', 
                    'richiesta@compass.it', 'Compass Banca S.p.a');
                    // Send Sms
                    OCSInviaSMSInvoker.inviaSMS('',telefonoCellulare,'','',templateAnoDocpp[0].Body__c);
                    // Create Note
                    CallWebService.createNote('Inviata mail DEMAnomalieDoc_DS',email,roLinkbozza,descrizioneAnomaliaop,caseId);
                    System.debug('************ DEM And SMS Anomalie Documentali PP sended Succesfully');
                    ValidationField.validateFieldError(ano);
                  }
                }
        } 
      return idCase;
    } 
   
  /* 
  * Autheur : Sana Badji 
  * @param idAccount
  * @param idCases
  * @date  16/05/2019
     */
      public static void  dEMAccountReassuranceDS (Id idAccount, Set<Id> idCases){
          List<Anomalie_Doc__c> anomalibyId = AnomalieSelector.listAnomalieByID(idCases);
          List<XCS_Template__c> templateRassCliente = AnomalieSelector.templateTesto('SMSRassicuraCliente_DS');
          Account getAccount=AnomalieSelector.getAccount(idAccount);
          String telefonoCellulare;
          List<Case> cases = new List<Case>();
          Set<Id> idcaseAno= new Set<Id>();
          Id  caseId;
          if(anomalibyId.size() == 0 || getAccount==null){
                System.debug('******** anomalibyId is empty'+anomalibyId.size());
                System.debug('******** Account is '+getAccount);
            }
          else{
              System.debug('******** anomalibyId '+anomalibyId.size());
              for(Anomalie_Doc__c ano: anomalibyId ){
                System.debug('******** ano.CaseId__r.NumeroPratica__c '+ano.CaseId__r.NumeroPratica__c);
                System.debug('******** ano.Descrizione_Anomalia_Op__c '+ano.Descrizione_Anomalia_Op__c);
                System.debug('******** ano.CaseId__r.stato_ocs__c '+ano.CaseId__r.stato_ocs__c);
                System.debug('******** ano.CaseId__c '+ano.CaseId__c);
                if(ano.CaseId__r.Stato_Pratica__c != null && ano.Descrizione_Anomalia_Op__c == null && 
                  (ano.CaseId__r.stato_ocs__c=='30' ||ano.CaseId__r.stato_ocs__c==null)){
                  caseId=ano.CaseId__c;
                  telefonoCellulare=getAccount.Telefono_Cellulare__c;
                  CaseDomain.mailDem('2725', caseId, getAccount.Name+', manca poco per conoscere l\'esito del Prestito Online Compass!', 
                  'richiesta@compass.it', 'Compass Banca S.p.A ');
                  OCSInviaSMSInvoker.inviaSMS('',telefonoCellulare,'','',templateRassCliente[0].Body__c);
                  //CaseDomain.createFeeditem('DEMRassicuraCliente_DS',body,  caseId);
                  System.debug('************ DEM And SMS Rassicura Cliente DS   sended Succesfully');

                  } 
                else{
                    ValidationField.validateFieldError(ano);
                  }      
            }
      }
      }

/* 
* Autheur : Sana Badji 
* @param idsetCases
* @date  28/05/2019
     */
      public static void  checkAnoPreSicPPAfterThreeHours(Set<Id> caseIds){
          String statoOcs= CallWebService.recuperaRequestPreSic(caseIds);
          Set<String> checkStatoOcsExist = AnomalieDocProductDS.anomaliePreSicPP(caseIds);
          if(statoOcs ==null || checkStatoOcsExist.size()==0){
          System.debug('************ checkStatoOcsExist '+checkStatoOcsExist);
          System.debug('************ statoOcs '+statoOcs);
          }
          if(checkStatoOcsExist.contains(statoOcs)){
            System.debug('************ StatoOcs exist '+checkStatoOcsExist);
            CallWebService.addToQueuAfterCallWebservice(caseIds,'Q339','PP_ONLINE_COMPASS_DS');
          }
  }
  
/*  
 * Autheur : Sana Badji 
 * @param idsetCases
 * @date  31/05/2019
     */
      public static void  checkAnoPostSicPPAfterThreeHours(Set<Id> caseIds){
          String statoOcs= CallWebService.recuperaRequestPreSic(caseIds);
          Set<String> checkStatoOcsExist = AnomalieDocProductDS.anomaliePostSicPP(caseIds);
          if(statoOcs ==null || checkStatoOcsExist.size()==0){
          System.debug('************ checkStatoOcsExist '+checkStatoOcsExist);
          System.debug('************ statoOcs is  '+statoOcs);
          }
          if(checkStatoOcsExist.contains(statoOcs)){
          System.debug('************ statoOcs exist '+checkStatoOcsExist);
          CallWebService.addToQueuAfterCallWebservice(caseIds,'Q340','PP_ONLINE_COMPASS_DS');
          }
}

/*  
* Autheur : Sana Badji 
* @param idsetCases
* @date  17/05/2019
     */
  public static Set<String>  anomaliePreSicPP  (Set<Id> idsetCases){
          List<Anomalie_Doc__c> anomalibyId=AnomalieSelector.listAnomalieByID(idsetCases);
          Account getAccount;
          Set<String> statoOcs = new Set<String>() ;
          if(anomalibyId.size() == 0){
                System.debug('******** anomalibyId is empty'+anomalibyId.size());
            }
          else{
            System.debug('******** anomalibyId size '+anomalibyId.size());  
              for(Anomalie_Doc__c ano: anomalibyId){ 
                getAccount=AnomalieSelector.getAccount(ano.CaseId__r.AccountId);
                System.debug('******** ano.CaseId__r.stato_ocs__c '+ano.CaseId__r.stato_ocs__c);
                System.debug('******** ano.Descrizione_Anomalia_Op__c '+ano.Descrizione_Anomalia_Op__c);
                System.debug('********  ano.CaseId__r.RO_Vecchio_Cellulare__c '+ ano.CaseId__r.RO_Vecchio_Cellulare__c);
                System.debug('********  getAccount.getCodice_Cliente__c '+ getAccount.getCodice_Cliente__c);
                  if(getAccount.getCodice_Cliente__c != null && 
                  (ano.CaseId__r.stato_ocs__c =='05BT' || ano.CaseId__r.stato_ocs__c=='10') && 
                      (ano.Descrizione_Anomalia_Op__c != null || ano.CaseId__r.RO_Vecchio_Cellulare__c!=null)){
                      statoOcs.add(ano.CaseId__r.stato_ocs__c);
                      System.debug('******** statoOcs added'+statoOcs);
                  }else {
                    ValidationField.validateFieldError(ano);
                  }
          }
    }
    return statoOcs;
  }

/*  
* Autheur : Sana Badji 
* @param idsetCases
* @date  20/05/2019
     */
      public static Set<String>  anomaliePostSicPP  (Set<Id> idsetCases){
          List<Anomalie_Doc__c> anomalibyId=AnomalieSelector.listAnomalieByID(idsetCases);
          Account getAccount;
          Set<String> statoOcs = new Set<String>() ;
          if(anomalibyId.size() == 0){
                System.debug('******** anomalibyId is empty'+anomalibyId.size());
            }
          else{
            System.debug('******** anomalibyId size '+anomalibyId.size());  
              for(Anomalie_Doc__c ano: anomalibyId){ 
                getAccount=AnomalieSelector.getAccount(ano.CaseId__r.AccountId);
                System.debug('******** ano.CaseId__r.stato_ocs__c '+ano.CaseId__r.stato_ocs__c);
                System.debug('******** ano.Descrizione_Anomalia_Op__c '+ano.Descrizione_Anomalia_Op__c);
                System.debug('********  ano.CaseId__r.RO_Vecchio_Cellulare__c '+ ano.CaseId__r.RO_Vecchio_Cellulare__c);
                System.debug('********  getAccount.getCodice_Cliente__c '+ getAccount.getCodice_Cliente__c);
                  if(getAccount.getCodice_Cliente__c != null && 
                    (ano.CaseId__r.stato_ocs__c =='20SD' || ano.CaseId__r.stato_ocs__c=='20') && 
                    (ano.Descrizione_Anomalia_Op__c != null || ano.CaseId__r.RO_Vecchio_Cellulare__c!=null)){
                      statoOcs.add(ano.CaseId__r.stato_ocs__c);
                      System.debug('******** statoOcs added'+statoOcs);
                  }else {
                    ValidationField.validateFieldError(ano);
                  }
          }
    }
    return statoOcs;
}


/*  
* Autheur : Sana Badji 
* @param idsetCases
* @date  20/05/2019
     */
      public static Set<Id>  codaSollecitoContratto  ( Set<Id> idsetCases){
          List<Anomalie_Doc__c> anomalibyId =AnomalieSelector.selectCodaSollecitoContratto(idsetCases);
          Set<Id> idCases = new Set<Id>();
          Account getAccount;
          if(anomalibyId.size() == 0 ){
          System.debug('************ anomalibyId is empty '+ anomalibyId  );
          return idCases;
          }else{
            System.debug('************ anomalibyId is not empty'+ anomalibyId  );
              for(Anomalie_Doc__c ano: anomalibyId){
                System.debug('************ Descrizione_Anomalia_Op__c'+ ano.Descrizione_Anomalia_Op__c);
                getAccount=AnomalieSelector.getAccount(ano.CaseId__r.AccountId);
                if(getAccount.getCodice_Cliente__c != null && ano.CaseId__r.stato_ocs__c =='30' && 
                    (ano.Codice_Macro_Documento__c =='RIC' && ano.codice_Anomalia__c!= null) ){
                      System.debug('************ ano.Codice_Macro_Documento__c'+ ano.Codice_Macro_Documento__c);
                      System.debug('************ ano.codice_Anomalia__c'+ ano.codice_Anomalia__c);
                      idCases.add(ano.CaseId__c);
                  }else{
                  ValidationField.validateFieldError(ano);
                }
          }
      }
  return idCases;
}


/*  
* Autheur : Sana Badji 
* @param idCases
* @descriptiion this method check If there are still documentary anomalies after 30min 
    For Product Family : DS
* @date  26/06/2019
 */
      public static List<Case>  checkCodaSolContrattoAfterThirtyMinutes ( Set<Id> idCases){

          List<RO_CRMRich_online_steplog__c> steplogByCase = CaseSelector.selectorRichOnlineStepLog(idCases);
          List<Case> cases = new List<Case>();
          if(codaSollecitoContratto(idCases).size() == 0 || steplogByCase.size() ==0){
            System.debug('************ steplogByCase is emplty '+ steplogByCase);
          }    
          if(codaSollecitoContratto(idCases).size() > 0 && steplogByCase.size() > 0){
              System.debug('************ steplogByCase '+ steplogByCase);  
              for(RO_CRMRich_online_steplog__c stepLog: steplogByCase){
                  if(stepLog.RO_CRMStep__c  =='Step 10 - Contratto Firmato con FEA' || stepLog.RO_CRMStep__c ==null){  
                    idCase.add(stepLog.RO_CRMRichiesta_Online__c);
                }
              }
            CallWebService.addToQueuAfterCallWebservice(idCases,'Q341','PP_ONLINE_COMPASS_DS');
      }
    return listCaseToUpdate;
}

/*  
* Autheur : Sana Badji 
* @descriptiion this method execute the Shedule  after 5 hours
    For Product Family : DS
* @date  01/07/2019
 */
      public static void executeSheduleFiveDays(String cronAfterFiveDays,Set<Id> setIdcase){
        String crOnFivedays;
        Set<Id> idCas=new Set<Id>();
        if(AnomalieDocProductDS.checkCodaSolContrattoAfterThirtyMinutes(idCase).size()==0){
          System.debug('************  liste CodaSolContrattoAfterThirtyMinutes is empty ');  
          System.debug('************  setIdcase '+setIdcase);  
          System.debug('************  cronAfterFiveDays '+cronAfterFiveDays);
          
          String jobIDS = System.schedule('anoSchedul_DS_AfterFiveDays_'+cronAfterFiveDays, 
          cronAfterFiveDays, new SchedulableDS(setIdcase,AFTER_FIVE_DAYS,''));
          System.debug('************  jobIDS' + jobIDS);
        }else{
          System.debug('************  liste CodaSolContrattoAfterThirtyMinutes is not empty '
          +AnomalieDocProductDS.checkCodaSolContrattoAfterThirtyMinutes(idCase).size());

        for (Case c : AnomalieDocProductDS.checkCodaSolContrattoAfterThirtyMinutes(idCase)) {
          crOnFivedays= CaseHandlerTriggerClass.createCronExpressionFromDateTimeFiveDays(c.LastModifiedDate);        
          System.debug('************ crOnFivedays ' + crOnFivedays);
          idCas.add(c.Id);
        }
        SchedulableDS anoSchedul = new SchedulableDS(idCas,AFTER_FIVE_DAYS,'');  
        String jobID = System.schedule('anoSchedul_DS_AfterFiveDays_'+crOnFivedays, crOnFivedays, anoSchedul);
       // System.debug('************  jobID' + jobID);
      }
    }
/*  
* Autheur : Sana Badji 
* @param idCases
* @descriptiion this method check If there are still documentary anomalies after 5 hours
    For Product Family : DS
* @date  26/06/2019
 */
      public static void  checkCodaSolContrattoAfterFiveDays ( Set<Id> idCases){

            List<RO_CRMRich_online_steplog__c> steplogByCase = CaseSelector.SelectorRichOnlineStepLog(idCases);
            List<Case> cases = new List<Case>();
            Set<Id> idCase = new Set<Id>();
            System.debug('************ steplogByCase '+ steplogByCase); 
            if(codaSollecitoContratto(idCases).size() == 0 || steplogByCase.size() == 0){
              return;
            }
            if(codaSollecitoContratto(idCases).size() > 0 && steplogByCase.size() > 0){
            for(RO_CRMRich_online_steplog__c stepLog: steplogByCase){
                if(stepLog.RO_CRMStep__c =='Step 8 - Scelta Firma'){  
                  idCase.add(stepLog.RO_CRMRichiesta_Online__c);
              }
            CallWebService.addToQueuAfterCallWebservice(idCases,'Q341','PP_ONLINE_COMPASS_DS');
      }
  }
}

}