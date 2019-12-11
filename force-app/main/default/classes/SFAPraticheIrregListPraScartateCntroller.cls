public class SFAPraticheIrregListPraScartateCntroller {
    @AuraEnabled
    public static List<SFA_PraticaIrregolare__c> getAllPratiche(Id recordId)
        {   
            
            List<SFA_PraticaIrregolare__c> CDLs = [SELECT Name,EsitoCaricamento__c
                                              FROM SFA_PraticaIrregolare__c WHERE ActivityId__c = :recordId AND EsitoCaricamento__c != :'Pratica caricata'];
            

            return CDLs;
        }  
}