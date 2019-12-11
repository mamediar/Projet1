public class CRM_EasyCM_Research_ControllerApex {
    @AuraEnabled
    public static List<Account> searchAccounts(Map<String, String> inputWrapper){
        boolean firstCondition=true;
        String query= 'SELECT Name,OCS_External_Id__c,PersonEmail,LastName,FirstName,Data_Nascita__c,Luogo_Nascita__pc,Provincia_Nascita__pc,Sesso__pc,Codice_Fiscale__pc,Partita_IVA__pc,PersonMailingStreet,PersonMailingPostalCode,PersonMailingCity,PersonMailingCountry,Tipo_documento__pc,Numero_Documento__pc,Ufficio_Rilascio__c,Luogo_Rilascio__pc,Provincia_Rilascio__pc,Data_Rilascio__pc,Denominazione_Azienda__c,Forma_Giuridica__c,Tipo_Anagrafica__pc,Data_Scadenza__pc,Telefono_Casa__c,Telefono_Cellulare__c,Tipo_Rapporto__c,Data_Depennamento__c,InvestFlag__pc,Qualitydetectionflag__pc,Interncommoffer__pc,Extcommoffer__pc,OtherService__pc FROM Account WHERE';
        String FirstName= inputWrapper.get('FirstName');
        String LastName= inputWrapper.get('LastName');
        String Data_Nascita_str= inputWrapper.get('Data_Nascita');
        Date Data_Nascita;
        if(!String.isBlank(Data_Nascita_str))
            Data_Nascita=Date.valueOf(Data_Nascita_str);
        String Codice_Fiscale= inputWrapper.get('Codice_Fiscale');
        String Telefono= inputWrapper.get('Telefono_Casa');
        String OCS_External_Id= inputWrapper.get('OCS_External_Id');

        if(!String.isBlank(FirstName)){
            query= query+ ' FirstName=: FirstName AND LastName=: LastName';
            if(!String.isBlank(Data_Nascita_str)){
                query= query+ ' AND Data_Nascita__c =: Data_Nascita';
            }
            firstCondition=false;
        }
        if(!String.isBlank(Codice_Fiscale)){
            if(!firstCondition){
                query= query+ ' AND';
            }
            query= query+ ' Codice_Fiscale__pc =:  Codice_Fiscale';
            firstCondition=false;
        }
        if(!String.isBlank(Telefono)){
            if(!firstCondition){
                query=query+ ' AND';
            }
            query= query+ ' (PersonOtherPhone=:Telefono OR Telefono_Casa__c =: Telefono OR Telefono_Cellulare__c =: Telefono OR Phone =: Telefono)';
            firstCondition=false;
        }
        if(!String.isBlank(OCS_External_Id)){
            if(!firstCondition){
                query=query+ ' AND';
            }
            query= query+ ' OCS_External_Id__c =: OCS_External_Id';
        }
        String devName='PersonAccount';
        query= query+ ' AND RecordType.DeveloperName=: devName'; 
        System.debug('query: ');
        System.debug(query);
        List<Account> accounts = Database.query(String.escapeSingleQuotes(query));
        return accounts;
    }
}