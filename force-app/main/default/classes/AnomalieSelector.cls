/*
* Author: Sana BADJI
* Class Created for handle the queries on Object AnomalieDoc
*/

public with sharing class AnomalieSelector {
  
/*
    * @description :  methods   return  List anomalie by Id 
    * Only diference are the fields 
    * @param : set <Id> idCases
*/

    public static List<Anomalie_Doc__c> listAnomalieByID( Set<Id> idCases ){
         List<Anomalie_Doc__c> anomaliById = [SELECT Id,
          Descrizione_Anomalia_Op__c,CaseId__r.stato_ocs__c,CaseId__r.NumeroPratica__c,
          CaseId__r.RO_Vecchio_Cellulare__c,CaseId__r.LastModifiedDate,
          CaseId__r.Tipo_Pratica__c,CaseId__r.Stato_Pratica__c,CaseId__r.Attributi_Pratica__c,
          CaseId__r.CanaleContatto__c,CaseId__r.AccountId,Codice_Macro_Documento__c,codice_Anomalia__c,
          CaseId__r.RO_Link_Bozza__c
          FROM Anomalie_Doc__c 
          WHERE CaseId__c IN: idCases];
          return anomaliById;
    }

/*
    * @description :  method  return  List anomalies by Id for DocumentaliDSAndDSP
    * Only diference are the fields 
    * @param : set <Id> idCases
*/

    public static List<Anomalie_Doc__c> selectDocumentaliDSWithDSP( Set<Id> idCases ){
         List<Anomalie_Doc__c> listAnoDocumentaliDSWithDSP =  [SELECT Id, Codice_Ocs__c, 
            Descrizione_Anomalia_Op__c , CaseId__r.NumeroPratica__c,CaseId__r.RO_Vecchio_Cellulare__c
            FROM Anomalie_Doc__c WHERE CaseId__c IN: idCases];
          return listAnoDocumentaliDSWithDSP;
    }

/*
    * @description :  method  return  List anomalies by Id for AccountReassuranceDSAndDSP
    * Only diference are the fields 
    * @param : set <Id> idCases
*/
    
    public static List<Anomalie_Doc__c> selectAccountReassuranceDSWithDSP(Set<Id> idCases ){
          List<Anomalie_Doc__c> accountReassuranceDSWithDSP = 
           [SELECT Id, Codice_Ocs__c, Descrizione_Anomalia_Op__c,
          CaseId__r.stato_ocs__c , CaseId__r.NumeroPratica__c
          FROM Anomalie_Doc__c WHERE CaseId__c IN: idCases];
          return accountReassuranceDSWithDSP;
    }


/*
    * @description :  method  return  List anomalies by Id for CodaSollecitoContratto
    * Only diference are the fields 
    * @param : set <Id> idCases
*/

    public static List<Anomalie_Doc__c> selectCodaSollecitoContratto(Set<Id> idCases ){
        List<Anomalie_Doc__c> codaSollecitoContratto = [SELECT Id,
        Codice_Macro_Documento__c,codice_Anomalia__c,CaseId__r.stato_ocs__c,
        CaseId__r.NumeroPratica__c,Descrizione_Anomalia_Op__c,
        CaseId__r.RO_Vecchio_Cellulare__c,CaseId__r.LastModifiedDate, CaseId__c,CaseId__r.AccountId
        FROM Anomalie_Doc__c 
        WHERE CaseId__c IN: idCases];
        return codaSollecitoContratto;
    }
    public static List<XCS_Template__c> templateTesto (String templateName ){
        List<XCS_Template__c> templateTesto = [SELECT Body__c FROM XCS_Template__c Where Name = : templateName];
        return templateTesto;
        }
    public static Account getAccount (Id idAccount ){
         Account  getAccount=null;
        if(idAccount==null){
            System.debug('idAccount is ' + idAccount);
            return getAccount;
        }
        else{
        getAccount = [SELECT Id,Telefono_Cellulare__c , Name, getCodice_Cliente__c,PersonEmail FROM 
        Account Where Id = : idAccount];
        return getAccount;
        }
    }
}