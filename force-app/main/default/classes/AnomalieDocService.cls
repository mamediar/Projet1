/**
*@Author Madicke BALDE
*@description Service for Anomalie
*@Date 15/05/2019
*/
public with sharing class AnomalieDocService {
   

    /***
    *@Author Madicke BALDE
    *@description  This method returns Map containing List of anomalies whose Case contain an anomaly discorda cellulare
    *@param list_anomalies : Anomalie_Doc_c list 
    *@return Map
    */
public static  Map<String,Object> discordaCellulare(List<Anomalie_Doc__c> list_anomalies ){
          System.debug('********* Running AnomalieDocService  *******************');
            System.debug('********* lsit *******************'+list_anomalies );

          Map<String,Object> returnValue = new Map<String,Object>();

          List<Anomalie_Doc__c> anomalies = new   List<Anomalie_Doc__c>();

          Map<Id, List<Anomalie_Doc__c>> mpAnomalies = new  Map<Id,List<Anomalie_Doc__c>>();
          try {
                if(list_anomalies.size() > 0 ) {
                      //******* create name job
                      String name ='ScheduleBatchAnomalieDoc'+ String.valueOfGmt(list_anomalies[0].CreatedDate);

                      //***** retrieve CreatedDate for Anomalie_Doc__c
                      Datetime createdDate = list_anomalies[0].CreatedDate;

                //*** Create Map Map<IdCase, List<Anomalie_Doc__c>>
                  for(Anomalie_Doc__c anomalie: list_anomalies){
                        if(!mpAnomalies.containsKey(anomalie.CaseId__c)){
                                mpAnomalies.put(anomalie.CaseId__c, new List<Anomalie_Doc__c>{anomalie});
                        }
                            mpAnomalies.get(anomalie.CaseId__c).add(anomalie);
                    }
                //******* Get Case List contains discorda cellulare
                List<Case> cases= CaseService.checkd_Discorda(mpAnomalies.keySet());
                System.debug('******  case '+cases);
                //**** check if Case List not empty 
                if(cases.size()  > 0 ){
                    for(Case cas: cases){
                        if(mpAnomalies.containsKey(cas.Id) )
                            for(Anomalie_Doc__c ano: mpAnomalies.get(cas.Id) ){
                                  anomalies.add(ano);
                              }
                      }
                }
                //****** CreatedDate anomalie
                returnValue.put('createdDay',createdDate);
                //***** name job
                returnValue.put('namejob', name);
                // Anomalie List contains discorda cellulare
                System.debug('anomalie Case '+anomalies);
                returnValue.put('anomalies', anomalies); 

                }
          } 
          catch (Exception e) {
          System.debug('**********  check_Anomalie**'+e.getMessage());
          System.debug('errorStract'+ e.getStackTraceString() ); 
          }
          return returnValue;
}
 /**
 *@Auhtor Madicke BALDE
 *@description check if Anomalie_Doc__c contains anomalie
 *@param listAnomalies Anomalie_Doc__c List
 *@return Boolean
 */
 public static Boolean checkAnomalie(List<Anomalie_Doc__c> listAnomalies){
          Boolean exist = false;
          try {
              if(listAnomalies.size() > 0 ){
                  for(Anomalie_Doc__c anomalie : listAnomalies){
                         if(!String.isBlank(anomalie.Descrizione_Anomalia_Op__c)) exist = true;
                  }
              }

          } catch (Exception e) {
             System.debug('**********  check_Anomalie**'+e.getMessage());
          }
          return exist;
   }
    /*
    *@Author Madicke BALDE
    *@description shedulable batch 
    *@param anomaliesDocs List 
    *@param namejob : name of job
    *@param executionDate 
    */
    public static void shedulableAnomalieBatch(List<Anomalie_Doc__c> anomaliesDocs, String namejob, String executionDate){
        try {
              if(anomaliesDocs.size() > 0 ){
                    Set<Id> ids = new Set<Id>();
                        for(Anomalie_Doc__c anomalie : anomaliesDocs){
                           ids.add(anomalie.Id);
                        }
                      //   executionDate = '59 35 12 4 7 ? 2019';
                      //   20 0 20 19 10 ? 2019 
                     System.schedule(namejob , executionDate , new ScheduleBatchAnomalieDoc(ids));
                     System.debug('*********** shedulableAnomalieBatch ******* ');
              }
        } 
        catch (Exception e) {
          System.debug('*********** errorMessage ******* '+e.getMessage());
        }
   }
 
    public static Map<String, Object> insertAnomalies(List<Anomalie_Doc__c> anomalies){
              Map< String, Object> returnValue = new Map< String, Object>();
              returnValue.put('exception', false);
              try {
                  if(anomalies.size() > 0){
                    insert anomalies;
                    returnValue.put('anomalies', anomalies);
                  }
              } catch (Exception ex) {
                System.debug('********* insertAnomalies errorMessage '+ex.getMessage() );
                returnValue.put('exception', true);
                returnValue.put('errorException','[KO-Anomalie0002]');
              }
              return returnValue;

    } 

    /**
      *@Author Madicke BALDE
      *@description remove AnomalieDocInQueue
      *@param list_Anomalies :  List<Anomalie_Doc__c>
**/
      public static void gestatoAnomalieDoc( List<Anomalie_Doc__c> list_Anomalies){
              List <Anomalie_Doc__c> anomalies = new List <Anomalie_Doc__c> ();
           try {
                      Set<String> codeAnomalies = new  Set<String>();

                      for(Anomalie_Doc__c anomalie : list_Anomalies){
                             codeAnomalies.add(anomalie.codice_Anomalia__c);
                      }
                              if(codeAnomalies.size() > 0 ) anomalies = getAnomalieByCode(codeAnomalies);

                                  if(anomalies.size() == 0) throw new CGMWSUtils_1_0.CGMWSRException('[KO-Anomalie0001]');

                                  if(anomalies.size() > 0 ){
                                         Map<String,Object> mp = discordaCellulare(anomalies);
                                        if(checkAnomalie(anomalies) &&
                                            ((List<Anomalie_Doc__c>)mp.get('anomalies')).size() >0 &&
                                                  CaseService.checkCaseInQueue(anomalies[0].CaseId__r.OwnerId)){ 
                                                  System.debug('***** Remove Case in queue ******');
                                                  CaseService.addCase_To_Queue(new Set<Id>{anomalies[0].CaseId__c},'Q525');

                                        }
                                  }

              
           } 
              catch (Exception ex) {
               System.debug('******** error Message removeAnomalieDocInQueue '+ ex.getMessage());
               System.debug('errorStract'+ ex.getStackTraceString() ); 
             
            } 
      }
      public static List<Anomalie_Doc__c> getAnomalieByCode(Set<String> codAnomalie){
          List<Anomalie_Doc__c> anomalieDocs = new List<Anomalie_Doc__c>();
          try {
            anomalieDocs = [SELECT Id, CreatedDate,
                                       codice_Anomalia__c,
                                       Codice_Documento__c,
                                       Codice_Ocs__c,
                                       Ristampa_Contratto__c,
                                       CaseId__c,
                                       CaseId__r.OwnerId ,
                                       Descrizione_Anomalia_Op__c
                                       FROM Anomalie_Doc__c
                                       WHERE codice_Anomalia__c IN : codAnomalie ];
            
          } catch (Exception e) {
            System.debug(' ************ errorMessage **** getAnomalieByCode  '+e.getMessage());
            System.debug(' ************ errorMessage **** getAnomalieByCode  '+e.getStackTraceString());
          }
          return anomalieDocs;
      }

}