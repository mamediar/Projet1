/* 
* Autheur : Sana Badji 
* description Class created for handle  Anomalie by Family: DS
* @date  27/06/2019
*/

public with sharing class AnomalieDocProductDSP {
  public static final String AFTER_FIVE_DAYS = 'afterFiveDays';
  public static  Set<Id> idCase = new Set<Id>();
  public static   List<Case> listCaseToUpdate = new List<Case>();

    public AnomalieDocProductDSP() {

    }

/* 
    * Autheur : Sana Badji 
    * @param idAccount
    * @param idCases
    * @param nameOfCampaign
    * @date  16/05/2019
    */  
      public static void  dEMAnomalieDocumentaliDSP (Id idAccount, Set<Id> idCases ){
            List<Anomalie_Doc__c> anomalibyId =AnomalieSelector.listAnomalieByID(idCases);
            List<XCS_Template__c> templateAnoContpp = AnomalieSelector.templateTesto('SMSAnomalieContratto_DSP');
            List<XCS_Template__c> templateAnoDocppPartener = AnomalieSelector.templateTesto('SMSAnomalieDoc_DSP');
            Account getAccount=AnomalieSelector.getAccount(idAccount);
            String telefonoCellulare;
            Id caseId;
            String body;
            String tempBody;
            List<Case> cases = new List<Case>();
            Date dateNow = Date.today();
            if(anomalibyId.size() ==0){
              System.debug('******** anomalibyId is empty'+anomalibyId.size());
            }
            else
              {
                  for(Anomalie_Doc__c ano: anomalibyId ){
                      if(getAccount.getCodice_Cliente__c != null && 
                      ano.Descrizione_Anomalia_Op__c != null)
                      {
                      idCase.add(ano.CaseId__c);
                      caseId=ano.CaseId__c;
                      telefonoCellulare=getAccount.Telefono_Cellulare__c;
                      CaseDomain.mailDem('2555', caseId,'Prestito Online CheBanca!: firma contratto', 
                      'PrestitoonlineCheBanca@compass.it', 'Compass Banca S.p.A');
                      OCSInviaSMSInvoker.inviaSMS('',telefonoCellulare,'','',templateAnoContpp[0].Body__c);
                      CaseDomain.createFeeditem('DEMAnomalieContratto_PP_CB',body,caseId); 
                      System.debug('************ DEM AND SMS Anomalie Contratto PP Partner  sended succesfully'+templateAnoContpp[0].Body__c);
                      }else if(ano.CaseId__r.NumeroPratica__c == null || 
                      ano.Descrizione_Anomalia_Op__c == null){
                      CaseDomain.mailDem('2554', caseId,'Prestito online CheBanca!: richiesta con anomalie', 
                      'PrestitoonlineCheBanca@compass.it', 'Compass Banca S.p.A');
                      OCSInviaSMSInvoker.inviaSMS('',telefonoCellulare,'','',templateAnoDocppPartener[0].Body__c);
                      CaseDomain.createFeeditem('DEMAnomalieDoc_PP_CB',body,  caseId);
                      System.debug('************ DEM AND SMS Anomalie Documentali PP Partner'+templateAnoDocppPartener[0].Body__c);
                      ValidationField.validateFieldError(ano);
                      }
                }
        }
      }
 
/*  
* Autheur : Sana Badji 
* @param idAccount
* @param idCases
* @param nameOfCampaign
* @date  16/05/2019
     */
  public static void  dEMAccountReassuranceDSP (Id idAccount, Set<Id> idCases){
            List<Anomalie_Doc__c> anomalibyId = AnomalieSelector.listAnomalieByID(idCases);
            List<XCS_Template__c> templateRassCliente = AnomalieSelector.templateTesto('SMSRassicuraCliente_DSP');
            Account getAccount=AnomalieSelector.getAccount(idAccount);
            String telefonoCellulare;
            List<Case> cases = new List<Case>();
            Date dateNow = Date.today();
            Id caseId;
            String body;
            Set<Id> idcaseAno= new Set<Id>();
            if(anomalibyId.size() == 0){
              System.debug('******** anomalibyId is empty'+anomalibyId.size());
            }
            else{
                for(Anomalie_Doc__c ano: anomalibyId ){
                if(getAccount.getCodice_Cliente__c != null && 
                  ano.Descrizione_Anomalia_Op__c == null && 
                  ano.CaseId__r.stato_ocs__c=='30'){
                  idcaseAno.add(ano.CaseId__c);
                  caseId=ano.CaseId__c;
                  telefonoCellulare=getAccount.Telefono_Cellulare__c;
                  CaseDomain.mailDem('2725', caseId, getAccount.Name+', manca poco per conoscere l\'esito del Prestito Online Compass!', 
                  'richiesta@compass.it', 'Compass Banca S.p.A');
                  System.debug('********Rassicura Cliente '+templateRassCliente[0].Body__c);
                  OCSInviaSMSInvoker.inviaSMS('',telefonoCellulare,'','',templateRassCliente[0].Body__c);
                  CaseDomain.createFeeditem('DEMRassicuraCliente_DS',body,  caseId);
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
      public static void  checkAnoPPPartnersThreeHours (Set<Id> caseIds ){
          String statoOcs= CallWebService.recuperaRequestPreSic(caseIds);
          Set<String> checkStatoOcsExist = AnomalieDocProductDSP.anomaliePPPartners(caseIds);
          if(statoOcs ==null || checkStatoOcsExist.size()==0){
          System.debug('************ checkStatoOcsExist '+checkStatoOcsExist);
          System.debug('************ statoOcs '+statoOcs);
          }
          if(checkStatoOcsExist.contains(statoOcs)){
            System.debug('************ statoOcs exist '+checkStatoOcsExist);
            Group gr = CaseService.getQueue('Q376');
            CallWebService.addToQueuAfterCallWebservice(caseIds,'Q376','PP_ONLINE_PARTNER_DS');     
      }
  }

/* 
* Autheur : Sana Badji 
* @param idsetCases
* @date  20/05/2019
     */
      public static Set<String> anomaliePPPartners  (Set<Id> idsetCases){
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
                  if((ano.CaseId__r.stato_ocs__c =='05BT' || ano.CaseId__r.stato_ocs__c=='10') && 
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
* @param idCases
* @descriptiion this method check If there are still documentary anomalies after 5 hours
    For Product Family : DSP
* @date  26/06/2019
 */
      public static void  checkCodaSolContraPPPartnersAfterFiveDays ( Set<Id> idCases){

          List<RO_CRMRich_online_steplog__c> steplogByCase = CaseSelector.SelectorRichOnlineStepLog(idCases);
          List<Case> cases = new List<Case>();
          String crOnFivehours;
          if(AnomalieDocProductDS.codaSollecitoContratto(idCases).size() == 0 || steplogByCase.size() ==0){
              System.debug('************ steplogByCase is emplty '+ steplogByCase);
          }
          System.debug('************ steplogByCase '+ steplogByCase); 
          if(AnomalieDocProductDS.codaSollecitoContratto(idCases).size() > 0 && steplogByCase.size() > 0){
              for(RO_CRMRich_online_steplog__c stepLog: steplogByCase){
                  if(stepLog.RO_CRMStep__c  =='Step 8 - Scelta Firma'){  
                    idCase.add(stepLog.RO_CRMRichiesta_Online__c);
                }
            CallWebService.addToQueuAfterCallWebservice(idCases,'Q341','PP_ONLINE_PARTNER_DS');
      }
  }
}

/*  
* Autheur : Sana Badji 
* @param idCases
* @descriptiion this method check If there are still documentary anomalies after 30 minutes
    For Product Family : DSP
* @date  26/06/2019
 */
      public static List<Case>  checkCodaSolContraPPPartnersAfterThirtyMinutes ( Set<Id> idCases){

          List<RO_CRMRich_online_steplog__c> steplogByCase = CaseSelector.SelectorRichOnlineStepLog(idCases);
          List<Case> cases = new List<Case>();
          System.debug('************ steplogByCase '+ steplogByCase); 
          if(AnomalieDocProductDS.codaSollecitoContratto(idCases).size() > 0 && steplogByCase.size() > 0){
              for(RO_CRMRich_online_steplog__c stepLog: steplogByCase){
                  if(stepLog.RO_CRMStep__c  =='Step 10 - Contratto Firmato con FEA' || stepLog.RO_CRMStep__c ==null){  
                    idCase.add(stepLog.RO_CRMRichiesta_Online__c);
                }
            CallWebService.addToQueuAfterCallWebservice(idCases,'Q341','PP_ONLINE_PARTNER_DS');
      }
  }
  return listCaseToUpdate;
}



/*  
* Autheur : Sana Badji 
* @descriptiion this method execute the Shedule  after 5 hours
    For Product Family : DSP
* @date  01/07/2019
 */
      public static void executeSheduleFiveDays(String cronAfterFiveHours,Set<Id> setIdcase){
        String crOnFivedays;
        if(AnomalieDocProductDSP.checkCodaSolContraPPPartnersAfterThirtyMinutes(idCase).size()==0){
          System.debug('************  liste CodaSolContrattoAfterThirtyMinutes is empty ');  
          System.debug('************  setIdcase '+setIdcase);  
          System.debug('************  cronAfterFiveHours '+cronAfterFiveHours);  
          String jobIDS = System.schedule('anoSchedul_DSP_AfterFiveDays_'+cronAfterFiveHours, 
          cronAfterFiveHours, new SchedulableDSP(setIdcase,AFTER_FIVE_DAYS,''));
          System.debug('************  jobIDS' + jobIDS);
        }else{
        for (Case c : AnomalieDocProductDSP.checkCodaSolContraPPPartnersAfterThirtyMinutes(idCase)) {
          crOnFivedays= CaseHandlerTriggerClass.createCronExpressionFromDateTimeFiveDays(c.LastModifiedDate);        
          System.debug('************  ' + crOnFivedays);
          idCase.add(c.Id);
        }
        SchedulableDSP anoSchedul = new SchedulableDSP(idCase,AFTER_FIVE_DAYS,'');  
        String jobID = System.schedule('anoSchedul_DSP_AfterFiveDays_'+crOnFivedays, crOnFivedays, anoSchedul);
        System.debug('************  jobID' + jobID);
      }
}

}