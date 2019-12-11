public class CRMReclamiGestioneDettagliContainerCtrl {
    
    @AuraEnabled
    public static Map<String,List<Object>> getModInvio(){
        Map<String,List<Object>> res = new Map<String,List<Object>>();
        List<String> modalita = new List<String>();
        Schema.DescribeFieldResult fieldResultMod = Case.Modalita_Invio__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResultMod.getPicklistValues();
        for(Schema.PicklistEntry pickListVal:ple){
            modalita.add(pickListVal.getLabel());
        }
        
        res.put('modList', modalita);
        return res;
    }
    
    @AuraEnabled
    public static String getMod(String recordId){
        Case c = [Select Modalita_Invio__c from case where id =: recordId];
        
        String modalita = '';
        Schema.DescribeFieldResult fieldResultMod=Case.Modalita_Invio__c.getDescribe();
        List<Schema.PicklistEntry> ple=fieldResultMod.getPicklistValues();
       	if(c.Modalita_Invio__c == null) return '';
        for(Schema.PicklistEntry pickListVal:ple){
            if(c.Modalita_Invio__c.equalsIgnoreCase(pickListVal.getValue()))
                modalita = pickListVal.getLabel();
        }
        return modalita;
    }
    @AuraEnabled
    public static Datetime getDecisione(String recordId){
        Case c = [Select Data_Decisione__c from case where id =: recordId];
    
        return c.Data_Decisione__c;
        
    }

    @AuraEnabled
    public static Boolean isScadenzaReclamoReadOnly(String societa, String tipoReclamo){
        system.debug('societa: '+societa+' - tipoReclamo: '+tipoReclamo);
        Boolean readOnly = true;

        List<CRM_RCL_Tipologia_Reclamo__mdt> tipologiaReclamo = [
            SELECT Id, DeveloperName, Area__c, Descrizione__c, External_Id__c, Rule_Id__c, Societa__c, Visibile__c 
            FROM CRM_RCL_Tipologia_Reclamo__mdt 
            WHERE External_Id__c =: tipoReclamo
            AND Area__c =: societa
        ];


        List<rules__mdt> ruleList = [
            SELECT External_Id__c, Label__c, Societa__c, Tipi_Associati__c, Label, DeveloperName, Id 
            FROM rules__mdt 
            WHERE Label__c = 'AUTORITA'
            AND Societa__c =: societa
        ];

        system.debug('tipologiaReclamo: '+tipologiaReclamo+'\nruleList: '+ruleList);
        if(!tipologiaReclamo.isEmpty() && !ruleList.isEmpty()){

            String tipoSelezionato = tipologiaReclamo.get(0).Descrizione__c;
            system.debug('tipoSelezionato: '+tipoSelezionato);

            system.debug('ruleList.get(0).Tipi_Associati__c.split: '+(ruleList.get(0).Tipi_Associati__c.split('/')));
            for(String rule : ruleList.get(0).Tipi_Associati__c.split('/')){

                system.debug('\n--------------------\n'+rule+' ISEQUALSTO '+tipoSelezionato+'? '+rule.equalsIgnoreCase(tipoSelezionato)+'\n------------------------\n');
                if(rule.equalsIgnoreCase(tipoSelezionato)){
                    readOnly = false;
                    break;
                }
            }

            if(!readOnly){
                Id userRoleID = UserInfo.getUserRoleId();
                List<String> ruoliAbilitati = new List<String>();//CUSTOMER OPERATIONS MANAGER oppure RECLAMO User oppure RECLAMO Manager
                ruoliAbilitati.add('Customer Operation Manager');
                ruoliAbilitati.add('Reclami User');
                ruoliAbilitati.add('Reclami Manager');

                UserRole userRole = [SELECT Name, Id, ParentRoleId FROM UserRole WHERE Id =: userRoleID LIMIT 1];

                if(userRole!=null){
                    system.debug('ruoliAbilitati.contains(userRole.Name): '+ruoliAbilitati.contains(userRole.Name));
                    if(ruoliAbilitati.contains(userRole.Name)){
                        return false;
                    }
                }

            }else{
                return true;
            }
        } 

        return readOnly;
        
    }
}