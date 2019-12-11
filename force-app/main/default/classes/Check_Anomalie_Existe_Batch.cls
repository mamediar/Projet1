/**
*@Author Madicke BALDE
*
*@description batch execute 2 hours after created Anomalie contain discorda cellulare
*
*/

global  class Check_Anomalie_Existe_Batch implements Database.Batchable<sObject> {

    public List<Anomalie_Doc__c> anomalies = new  List<Anomalie_Doc__c>();

    global Set<Id> setId;

    Set<ID> idSet_Case = new Set<ID>();

    public Check_Anomalie_Existe_Batch(Set<Id> setId) {
    this.setId = setId;
    System.debug('************ id set '+setId);
    }
    /**
    *@descitpion methode excetute at the start of batch
    *** Retrive Anomalie_Doc__c List 
    *@param Database.BatchableContext
    *@return query 
    */
    global Database.QueryLocator start(Database.BatchableContext bc) {
                  String query = 'SELECT Id, CaseId__c, CreatedDate, CaseId__r.RO_Vecchio_Cellulare__c,codice_Anomalia__c FROM Anomalie_Doc__c WHERE Id IN :setId';
                  System.debug(Database.getQueryLocator(query) )  ;  
                  return Database.getQueryLocator(query);     
    }
   /**
   *@Author Madicke BALDE
   *@description
   *@param Database.BatchableContext
   *@param scope : Anomalie_Doc__c List
   */
    global void execute(Database.BatchableContext bc, List<Anomalie_Doc__c> scope) {
                 
                  Map<String,Object> returnValues =  AnomalieDocService.discordaCellulare(scope);
                  if( ((List<Anomalie_Doc__c>) returnValues.get('anomalies')).size() > 0 ){
                              for(Anomalie_Doc__c anomal: (List<Anomalie_Doc__c>) returnValues.get('anomalies') ){
                                     idSet_Case.add(anomal.CaseId__c);
                              }

                    }
                  if(idSet_Case.size() > 0 ){
                           CaseService.addCaseToQueue(idSet_Case, 'Richieste Online - Anomalie Doc. E-comme');  
                 }
  
    }
    /*
    *@description finish methode
    *@param Database.BatchableContext
    *
    */
    global void finish(Database.BatchableContext bc) {
       System.debug('******************  finish batch ***************');
       System.debug('*********** id Case new  ************'+idSet_Case );
      
    }
}