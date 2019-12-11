/**
 * Class: CommodityFuturoCnt
  * @description: apex class contains implements method of Futuro
  * @date:16/05/2019
  * @author:Mady COLY
  * */

public with sharing class CommodityFuturoCnt {

  /**
   * @description: List Agente
   * @date::16/05/2019
   * @author:Khadim Rassoul Ndeye
   * @return: Response|Map<String,COM_Agente__c>
   */
   
   @AuraEnabled(cacheable=true)
   public static Map<String,Object> getAllAgente() {
       List<COM_Agente__c> records;
       Map<String,Object> response=new Map<String,Object>();
       Map<Id, COM_Agente__c> agentes;
       response.put('error',false);
       try {
           
           records = [SELECT Id, Name, Com_Area__c, Com_Codice__c,createdDate, Com_Numero_Contatti__c,(Select COM_AGENTE_FUTURO__c,Name,COM_ChiusoNon_Conforme__c,COM_PraticheChiuse_Conforme__c from Commodity_Survey__r) FROM COM_Agente__c ] ;
           response.put('data',records);

       } catch(Exception e){
           response.put('error',true);
           response.put('message',e.getMessage());
           response.put('cause',e.getCause());
           response.put('stackTrace',e.getStackTraceString());
       }
       return response;

   }
   /**
   * @description: Liste des clients
   * @date::17/05/2019
   * @author:Mame Seynabou Diop
   * @return: Response|Map<String,Com_Commodity_Survey__c>
   */
    @AuraEnabled(cacheable=true)
    public static Map<String,Object> getCommodities(){
         List<Com_Commodity_Survey__c> commodities;
       Map<String,Object> response=new Map<String, Object>();
       response.put('error',false);
       try {
           commodities = [SELECT Id, Name, COM_NOME_CEDENTE__c,COM_CED_TELEFONO1__c, COM_CED_TELEFONO2__c, COM_CED_TELEFONO_CELL__c,
                          COM_AGENTE_FUTURO__r.Name,COM_AGENTE__c,createdDate,COM_AGENTE_FUTURO__r.Com_Numero_Contatti__c,COM_DATA_CONTRATTO__c,richiamare_il__c,COM_Status_FUTURO__c,Interviste_Utili__c,Ultimo_Esito__c,
                          COM_DATA_INSERIMENTO__c,COM_Current_Period_Futuro__c,Note__c,COM_ChiusoNon_Conforme__c,COM_PraticheChiuse_Conforme__c,LastModifiedDate FROM Com_Commodity_Survey__c ORDER BY richiamare_il__c DESC NULLS LAST];
           response.put('data',commodities);
       
       } catch(Exception e){
           response.put('error',true);
           response.put('message',e.getMessage());
           response.put('cause',e.getCause());
           response.put('stackTrace',e.getStackTraceString());
       }
       system.debug(response);
       return response;
    }

     /**
   * @description: find a Com_Commodity_Survey__c by IdCom_Commodity_Survey__c
   * @date::27/05/2019
   * @author:Mady COLY
   * @return: Map<String,Object>
   * dateLastModification: none
   */
    @AuraEnabled
    public static Map<String,Object> getCommoditySurveyDetail(ID commodity_SurveyId) {

        Map<String,Object> response=new Map<String, Object>();
        Com_Commodity_Survey__c myCommodityServey= null;
        response.put('error',false);
                 try {
                      myCommodityServey =  [SELECT Id, Name , CreatedDate, LastModifiedDate,COM_AGENTE__c,COM_TIPO_PRODOTTO__c,COM_SESSO_CEDENTE__c,
                                            COM_NOME_CEDENTE__c, COM_CED_TELEFONO1__c, COM_CED_TELEFONO2__c, COM_CED_TELEFONO_CELL__c,
                                            COM_NUMERO_RATE__c, COM_IMPORTO_RATA__c,COM_NETTO_EROGATO__c,COM_DATA_CONTRATTO__c,
                                            COM_COD_SUB_AGENTE__c, COM_SUB_AGENTE__c, COM_TipoRinnovo__c, COM_PraticheChiuse_Conforme__c,
                                            COM_ChiusoNon_Conforme__c, richiamare_il__c, COM_Numero_Pratiche_Futuro__c, Ultimo_Esito__c,
                                             Data_Ultimo_Esito__c,COM_Status_FUTURO__c, COM_AGENTE_FUTURO__c,COM_CATEGORIA_PRODOTTO__c 
                                             FROM Com_Commodity_Survey__c WHERE Id=: commodity_SurveyId];
                      response.put('data',myCommodityServey);
                    } catch(Exception e){
                        response.put('error',true);
                        response.put('message',e.getMessage());
                        response.put('cause',e.getCause());
                        response.put('stackTrace',e.getStackTraceString());
                    }
                    system.debug('response'+response);
                    return response;
    }

   /*
   * @description: update a sObject
   * @date:29/05/2019
   * @author:Mady COLY
   * @return: SObject
   * dateLastModification: none
   */
    @AuraEnabled
    public static SObject updateSobject (SObject mySobject){
        system.debug('04_05_2019 param->'+mySobject);
        try {
            update mySobject;
            System.debug('mise à jour reussi');
        } catch (DmlException e) {
            System.debug('error message: '+e.getMessage() );
            System.debug('error cause: '+e.getCause() );
            return null;
        }

    return mySobject;
    }
    
       @AuraEnabled
    public static List<SObject> updateListSobject(List<SObject> mySobject){
        system.debug('04_05_2019 param->'+mySobject);
        try {
            update mySobject;
            System.debug('mise à jour reussi');
        } catch (DmlException e) {
            System.debug('error message: '+e.getMessage() );
            System.debug('error cause: '+e.getCause() );
            return null;
        }

    return mySobject;
    }

    /*
   * @description: update or create  Risposte__c
   * @date:13/06/2019
   * @author:Mady COLY
   * @return: Risposte__c
   * dateLastModification: none
   */
    @AuraEnabled
    public static Map<String,Object> upsertRisposta (Risposte__c risposta){
        system.debug('13_06_2019 risposta ->'+risposta);
        Map<String,Object> response=new Map<String, Object>();
        response.put('error',false);
        risposta.Type__c = 'Futuro';
        try {   
            upsert risposta;
            System.debug('mise à jour reussi');
             response.put('data: ',risposta);
        }  catch(Exception e){
           response.put('error',true);
           response.put('message',e.getMessage());
           response.put('cause',e.getCause());
           response.put('stackTrace',e.getStackTraceString());
       }
       system.debug(response);
       return response;
    }
    /*
   * @description: find Com_Commodity_Survey__c by Agente
   * @date:29/05/2019
   * @author:Mady COLY
   * @return: Map<String,Object>
   * dateLastModification: none
   */
    @AuraEnabled
    public static Map<String,Object> getCommoditiesByAgente(Id agenteId){
        System.debug('debut getCommoditiesByAgente');
        System.debug('agenteId: '+agenteId);
         List<Com_Commodity_Survey__c> commodities=null;
       Map<String,Object> response=new Map<String, Object>();
       response.put('error',false);
       try {
           commodities = [SELECT Id, Name, COM_NOME_CEDENTE__c,COM_CED_TELEFONO1__c, COM_CED_TELEFONO2__c, COM_CED_TELEFONO_CELL__c,
                          COM_AGENTE_FUTURO__c,COM_DATA_CONTRATTO__c,richiamare_il__c,Ultimo_Esito__c,COM_DATA_INSERIMENTO__c,
                          LastModifiedDate,COM_AGENTE_FUTURO__r.Name  FROM Com_Commodity_Survey__c WHERE COM_AGENTE_FUTURO__c =: agenteId ] ;
           response.put('commodities',commodities);
            System.debug('data: '+commodities);
       } catch(Exception e){
           response.put('error',true);
           response.put('message',e.getMessage());
           response.put('cause',e.getCause());
           response.put('stackTrace',e.getStackTraceString());
       }
       system.debug(response);
       return response;
    }

       /*
   * @description: fetch list of Risposte__c
   * @date:13/06/2019
   * @author:Mady COLY
  * @return: Response|Map<String,Com_Commodity_Survey__c>
  * dateLastModification: none
   */
     @AuraEnabled
    public static Map<String,Object> getRisposteByCommoditySurveyId(String idIntervista){
        System.debug('idIntervista :'+idIntervista);
        Risposte__c risposte = new Risposte__c();
       Map<String,Object> response=new Map<String, Object>();
       response.put('error',false);
       try {
           risposte = [ SELECT Id,Name, D1_Futuro__c,D2_Futuro__c,D3_Futuro__c,D4_Futuro__c,D5_Futuro__c,D6_Futuro__c,D6bis_Futuro__c,
                                    D7_Futuro__c,D8_Futuro__c,D9_Futuro__c,D10_Futuro__c,D11_Futuro__c,Type__c,Valutazione__c,COM_Note_Contratto__c,
                                    COM_Note_Contratto_Assicurazione__c,COM_Note_Documenti_Assicurazione__c,COM_Note_Motivazione_Recesso__c,COM_Note_Precontratto__c,
                                    COM_Note_Questionario_Assicurativo__c,COM_Note_Secci__c,COM_Note_Soddisfazione_Cliente__c,COM_Note9__c,COM_Note_10__c,COM_Note_11__c
                                 FROM Risposte__c WHERE Intervista_Futuro__r.Id =: idIntervista and  Type__c='Futuro' Limit 1];
           response.put('data',risposte);
       } catch(Exception e){
           response.put('error',true);
           response.put('message',e.getMessage());
           response.put('cause',e.getCause());
           response.put('stackTrace',e.getStackTraceString());
       }
       system.debug(response);
       return response;
    }

       /*
   * @description: fetch list of Com_Commodity_Survey__c
   * @date:13/06/2019
   * @author:Mame Seynabou diop
  * @return: Response|Map<String,Com_Commodity_Survey__c>
  * dateLastModification: none
   */
     @AuraEnabled
    public static Map<String,Object> getRisposteValutazione(){
        List<Com_Commodity_Survey__c> rispostes=new List<Com_Commodity_Survey__c> ();
       Map<String,Object> response=new Map<String, Object>();
       response.put('error',false);
       try {
           rispostes= [ SELECT Id,com_agente_futuro__r.Name, COM_ChiusoNon_Conforme__c, COM_PraticheChiuse_Conforme__c
                                 FROM Com_Commodity_Survey__c];
           response.put('data',rispostes);
       } catch(Exception e){
           response.put('error',true);
           response.put('message',e.getMessage());
           response.put('cause',e.getCause());
           response.put('stackTrace',e.getStackTraceString());
       }
       system.debug(response);
       return response;
    }
}