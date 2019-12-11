/*  
* Autheur : Sana Badji 
* @Class created handle errors on Fields 
* @date  16/06/2019
*/
public  class ValidationField {
    public static List<ValidationFieldMessageError> errors = new List<ValidationFieldMessageError>();
   
   /*  
* Autheur : Sana Badji 
* @Method return true if a field is empty
* @param Anomalie_Doc__c
* @date  16/06/2019
*/
    public static Boolean validateFieldError(Anomalie_Doc__c ano){
        Boolean hasError = false;
        Boolean hasValid = false;
        DateTime dateNow = System.now();
            if(String.isBlank(ano.CaseId__r.NumeroPratica__c)) {
                    hasError = true;          
                    errors.add(new ValidationFieldMessageError
                    ('Invalid ! NumeroPratica__c Can\' t be empty  ',
                     'AnomalieDocService'));}
                                                            
                if(String.isBlank(ano.CaseId__r.stato_ocs__c)){
                                hasError = true;
                                errors.add(new ValidationFieldMessageError
                                ('Invalid ! stato_ocs__c Can\' t be empty',
                                'AnomalieDocService')); }
               
                if(String.isBlank(ano.Descrizione_Anomalia_Op__c)){
                                hasError = true;
                                errors.add(new ValidationFieldMessageError
                                ('Invalid ! Descrizione_Anomalia_Op__c Can\' t be empty',
                                 'AnomalieDocService' )); } 
                                                                  
                if(String.isBlank(ano.CaseId__r.RO_Vecchio_Cellulare__c)){
                                 hasError = true;
                                 errors.add(new ValidationFieldMessageError
                                 ('Invalid ! RO_Vecchio_Cellulare__c Can\' t be empty',
                                  'AnomalieDocService')); } 
                        
         
         return !hasError;
    }

 /*  
* Autheur : Sana Badji 
* @Method return true if a field is empty
* @param Anomalie_Doc__c
* @date  16/06/2019
*/
public static boolean validateFieldSollecitoContrattoError(Set<Id> idsetCases ){
        List<Anomalie_Doc__c> anomalibyId=AnomalieSelector.listAnomalieByID(idsetCases);
        Boolean hasError = false;
        for(Anomalie_Doc__c ano: anomalibyId){    
            if(String.isBlank(ano.CaseId__r.NumeroPratica__c)) {
                    hasError = true;          
                    errors.add(new ValidationFieldMessageError
                    ('Invalid ! NumeroPratica__c Can\' t be empty  ',
                     'AnomalieDocService'));}
                                                            
                if(String.isBlank(ano.CaseId__r.stato_ocs__c)){
                                hasError = true;
                                errors.add(new ValidationFieldMessageError
                                ('Invalid ! stato_ocs__c Can\' t be empty',
                                'AnomalieDocService')); }
               
                if(String.isBlank(ano.Codice_Macro_Documento__c)){
                                hasError = true;
                                errors.add(new ValidationFieldMessageError
                                ('Invalid ! Codice_Macro_Documento__c Can\' t be empty',
                                 'AnomalieDocService' )); } 
                                                                  
                if(String.isBlank(ano.codice_Anomalia__c)){
                                 hasError = true;
                                 errors.add(new ValidationFieldMessageError
                                 ('Invalid ! RO_Vecchio_Cellulare__c Can\' t be empty',
                                  'AnomalieDocService')); }                            
               
    }
       return !hasError;
}
}