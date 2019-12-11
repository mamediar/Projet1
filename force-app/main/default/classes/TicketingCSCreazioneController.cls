public with sharing class TicketingCSCreazioneController {
       
    @AuraEnabled
    public static List<XCS_Disposition__c> loadListaDisposition(String tipologiaSelezionata){

        String Parent = XCS_DispositionUtils.findDispositionByExternalID('DP1925').Id;
        
        List<XCS_Disposition__c> list2disp = new List<XCS_Disposition__c>([SELECT Id,name,Parent__c,External_Id__c 
                                                                           FROM XCS_Disposition__c 
                                                                           WHERE Parent__c =:Parent]);
        system.debug('DP list2disp: '+list2disp);
        return list2disp;
    }
    
    /* Metodo per la creazione del caso con inserimento di Post e Allegati */
    @AuraEnabled
    public static void createRecord (Case Ticket, Map<String,String> MapFiles, String catIdS){
               
        try{
            System.debug('Ticket inizio Try'+Ticket);            
            list<ContentVersion> contVers = new list<ContentVersion>();
            list<ContentDocumentLink> cdlCont = new list<ContentDocumentLink>();         
            if(Ticket != null){
                Database.DMLOptions dmlOpts = new Database.DMLOptions();
   				dmlOpts.assignmentRuleHeader.useDefaultRule= true;
                Ticket.setOptions(dmlOpts);
                insert Ticket;                
                
                
            }else{
                System.debug('Ticket VUOTO!');
            }                       
        } catch (Exception ex){
            System.debug('Error: '+ex.getMessage());
        }        
    }
    
    /* Recupero RecordTypeId di Ticketing */
    @AuraEnabled
    public static String getRecordType() {
        String TKT_RECORDTYPE_ID = RecordTypeUtil.getCaseRecordType('Ticketing');
        return TKT_RECORDTYPE_ID;
    }
}