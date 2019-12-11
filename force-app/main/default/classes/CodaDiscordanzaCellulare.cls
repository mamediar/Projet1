/*
 *  @description  Class CodaDiscordanzaCellulare 
 *  @author Sana Badji
 *  @Modified by LayePythagore   01/11/2019         
 *  @date  27/05/2019
 *
 */
@RestResource(UrlMapping = '/codaDiscordanzaCellulare')
global with sharing class CodaDiscordanzaCellulare extends CGMServiceWsr_1_0 {

    
    /*
     *  @description  Update  Case Webservice
     *  @param numeroPratica
     *  @param tipoPratica
     *  @param vecchioCell
     *  @param nuovoCell
     *  @param testoNota
     *  @author Sana Badji 
     *  @Modified by LayePythagore        
     *  @date  27/05/2019
     *
     */
    @HttpPost
    global static PerformCRMActivityResponse performCRMActivity(String numeroPratica, String tipoPratica,
        String vecchioCell, String nuovoCell , String testoNota) {

        Case caseObj =getnumeroPraticaAndId(numeroPratica);
        Id recordType=CGMWSUtils_1_0.getRecordTypeId('Case','CRM_RichiestaOnline');
        Case thisCase = new Case(
                Id= caseObj.Id,
                NumeroPratica__c=caseObj.caseNumber,
                Tipo_Pratica__c=tipoPratica,
                RecordTypeId=recordType,
                RO_Vecchio_Cellulare__c=vecchioCell,
                RO_Nuovo_Cellulare__c=nuovoCell,
                Note__c=testoNota);
        
        PerformCRMActivityResponse performCRMActResp = new PerformCRMActivityResponse(0L, 'Success');
        // Match case by Id, if present.
        // Otherwise, create new case.
        try {
            upsert thisCase;
            System.debug('#l case ####'+ JSON.serialize(thisCase));
        } catch (Exception e) {
            performCRMActResp.resultCode = 1L;
            performCRMActResp.resultMessage = e.getMessage()+' '+e.getStackTraceString();
        }
        
        // Return the case ID.
        return performCRMActResp;
    }

    /*
     *  @description  Method return Case for retrieving IdCase and  caseNumber
     *  @author Sana Badji         
     *  @date  27/05/2019
     *
     */
    public static Case getnumeroPraticaAndId(String numeroPratica){
        List<String> errorFields = new List<String>(); 
        Case caseObj;
        try {  
        caseObj = [SELECT Id, caseNumber FROM Case WHERE caseNumber = : numeroPratica];
        }catch (System.QueryException e) {
        caseObj=null;
        System.debug('************* caseNumber not exit   '+e.getMessage());
        }
        return caseObj;
    }

    /*
     *  @description  Class CaseWrapper 
     *  @Attribut numeroPratica
     *  @Attribut tipoPratica
     *  @Attribut vecchioCell
     *  @Attribut nuovoCell
     *  @author Sana Badji         
     *  @date  27/05/2019
     *
     */
    global class CaseWrapper extends ObjectWrapper {
        global String numeroPratica { get; set; }
        global String tipoPratica { get; set; }
        global String vecchioCell { get; set; }
        global String oldValue { get; set; }
        global String nuovoCell { get; set; }
        global String testoNota { get; set; }
        
 
        global  CaseWrapper(Case cas) {
            super(cas);
        }
    }

    /*
     * @author abdoulaye.diopdev3@compass.com.dev
     * @date  01/11/2019
     * @description class PerformCRMActivityResponse 
     */
    global class PerformCRMActivityResponse extends GenericResponse {
        public Long resultCode {get; set;}
        public String resultMessage {get; set;}

        global PerformCRMActivityResponse(Long resultCode, String resultMessage){
            super(resultCode, resultMessage);
        }

        global PerformCRMActivityResponse(){
            super();
        }
    }
}