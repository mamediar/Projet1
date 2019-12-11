public class GD_UtilsClass{
    
      @AuraEnabled
      public static List<IVASS_Dealer_courses_Iscritti__c> IscrittiAlCorso( String IDCorso) 
      {
             List<IVASS_Dealer_courses_Iscritti__c> ListIscrittiAlCorso = [ SELECT Id,Name,Codice_Intermediario__c,Ragione_Sociale__c,Codice_Fiscale__c, 
                                                                                  Data_Iscrizione__c,Stato_Corso__c,Note__c,Note_x_Outsourcer__c, 
                                                                                  Dealer__c,Corso__c,Regione__c,Cognome__c,Nome__c,Referente__c, 
                                                                                  Esito_Outsourcer__c, Area__c, Filiale__c ,
                                                                                  Nome_Dealer__c,Nome_Corso__c
                                                                           FROM IVASS_Dealer_courses_Iscritti__c 
                                                                           WHERE Corso__c =: IDCorso ];
             return ListIscrittiAlCorso;
      }
                   

}