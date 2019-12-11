//----------------------------------------------------------------------
//-- - Author       : SANA BADJI
//-- - Date         : 12/06/2019
//-- - Description  : Handle Call Web Service
//----------------------------------------------------------------------

public with sharing class CallWebService {
public static RecuperaStatiAttributiPrtResponse res;
public static  String statoPratica;
public static  String attributoPratica;
public static  String statoOcs;


/*
* @description This method  allow to retrieve statoPratica and attributoPratica
for Queue : Coda Contatto “Anomalie Pre Sic PP”
* @Param recuperaRequest
* @Param idCase
*/
public  static String recuperaRequestPreSic(Set<Id> idCase){
    RecuperaStatiAttributiPrtRequest  recuperaRequest= CallWebService.buildElencoPratica(idCase);
    if(recuperaRequest== null || idCase.size() == 0){
    System.debug('************ recuperaRequest is empty '+recuperaRequest);
    System.debug('************ idCase is  emmty'+idCase.size());
    return statoOcs;
    }
    if(recuperaRequest!= null && idCase.size() > 0){
            res = Invoker.invoke(recuperaRequest);
            System.debug('************ requestPresic '+recuperaRequest);
            System.debug('************ responsePresic '+res);
            if(RecuperaStatiAttributiPrtService.ValidateResponse(res)){
            List<RecuperaStatiAttributiPrtResponse.RecuperaStatiAttributiPrtRes> elencoPraticheResp = res.RecuperaStatiAttributiPrtResponse.elencoPratiche;
            List<RecuperaStatiAttributiPrtRequest.RecuperaStatiAttributiPrtReq>  elencoPratiche=recuperaRequest.RecuperaStatiAttributiPrtRequest.elencoPratiche;
            //System.debug('************ elencoPratiche '+recuperaRequest.elencoPratiche);
            System.debug('************ elencoPratiche request '+elencoPratiche);
           // System.debug('************ elencoPraticheResp '+elencoPraticheResp);
            System.debug('************ elencoPratiche response'+elencoPraticheResp);
            for(RecuperaStatiAttributiPrtResponse.RecuperaStatiAttributiPrtRes res: elencoPraticheResp){
                statoPratica=  res.statoPratica;
                attributoPratica= res.attributoPratica;
                }
            statoOcs=statoPratica+attributoPratica;
            System.debug('************ stato_ocs '+statoOcs);
        }
}
return statoOcs;
}


/*  
* Autheur : Sana Badji 
* @param idsetCases
* @date  17/05/2019
    */
    public static RecuperaStatiAttributiPrtRequest  buildElencoPratica  (Set<Id> idsetCases){
        List<Anomalie_Doc__c> anomalibyId=AnomalieSelector.listAnomalieByID(idsetCases);
        RecuperaStatiAttributiPrtRequest  recuperaRequest;
        if(anomalibyId.size() == 0){
            System.debug('******** anomalibyId is empty'+anomalibyId.size());
        }
        else{ 
            for(Anomalie_Doc__c ano: anomalibyId){  
                recuperaRequest=new RecuperaStatiAttributiPrtRequest();
                recuperaRequest.buildElencoPratica(ano.CaseId__r.Tipo_Pratica__c,
                    ano.CaseId__r.NumeroPratica__c, ano.CaseId__r.Stato_Pratica__c,
                    ano.CaseId__r.Attributi_Pratica__c,ano.CaseId__r.CanaleContatto__c);
                }
        }
    return recuperaRequest;
    }

/*  
* Autheur : Sana Badji 
* @param caseIds
* @param developperName
* @param familyProduct
* @date  18/05/2019
    */
        public static void   addToQueuAfterCallWebservice  (Set<Id> caseIds,String developperName,String familyProduct){
                List<Case> listCaseToUpdate = new List<Case>();
                Group gr = CaseService.getQueue(developperName);
                List<Case> cases= CaseSelector.getPropuitFamily(caseIds,familyProduct);
                System.debug('************gr' +gr);
                System.debug('************cases ' +cases);
                System.debug('************familyProduct ' +familyProduct);
                    try{
                        if (gr != null && cases.size() > 0) {
                        System.debug('************ cases '+cases);
                        for (Case c : cases) {
                        c.OwnerId = gr.Id;
                        c.Is_Discordanza_Cellulare__c=true;       
                        System.debug('************  gr.Id' + gr.Id);
                        listCaseToUpdate.add(c);
                        }
                        System.debug('************listCaseToUpdate ' +listCaseToUpdate.size());
                        if(!listCaseToUpdate.isEmpty()){
                            Recursion.isTriggerExecuting=true;
                            upsert listCaseToUpdate;
                            System.debug('************Recursion.isTriggerExecuting After ' +Recursion.isTriggerExecuting);
                        }
                        }
                    }catch(Exception e){
                        //Recursion.isTriggerExecuting=true;}
                        System.debug('The following exception has occurred: ' + e.getMessage());
                        System.debug('errorStract'+ e.getStackTraceString() ); 
                        System.debug('cases: ' + cases);
                        System.debug('************ finish methode');
                }
    }
/*  
* Autheur : Sana Badji 
* @param nameDEM
* @param email
* @param roLinkbozza
* @param descrizioneAnomaliaop
* @param idcase
* @date  11/11/2019
*/

     public static void createNote(String nameDEM,String email,String roLinkbozza,String descrizioneAnomaliaop, Id idcase ){
        //String email = c.Account.PersonEmail;
        String body = 'a:'+email+'\n'+
                        'Link Bozza :'+roLinkBozza+'\n'+
                        'Anomalie DOC:'+descrizioneAnomaliaop;
        CaseDomain.createFeeditem(nameDEM,body,idcase);
    }
}