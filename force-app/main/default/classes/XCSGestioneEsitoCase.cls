public class XCSGestioneEsitoCase {
    @AuraEnabled
    public static List<String> getEsiti(String caseId){
        
        Case cs = [SELECT ActivityType__c FROM Case WHERE Id =: caseId];
        
        String pId = UserInfo.getProfileId();
        String profile=[select Name from Profile where id=:pId].Name;
        
        List<CaseEsitiConfig__mdt> lstEsiti = [SELECT Label, TipologiaCase__c, Visibility__c, Sort_Order__c 
                                               FROM CaseEsitiConfig__mdt 
                                               WHERE TipologiaCase__c =: cs.ActivityType__c
                                               ORDER BY Sort_Order__c ASC];
        System.debug('--Lista Esiti: '+lstEsiti);
        System.debug('XCSGestioneEsitoCase getEsiti profile: '+profile);
        lstEsiti=filterEsiti(lstEsiti,profile);
        System.debug('--Lista esiti filtrata: '+lstEsiti);
        //Filtrare esiti in base al profilo utente!
        List<String> scelteEsito = new List<String>();
        for(CaseEsitiConfig__mdt c : lstEsiti){
            scelteEsito.add(c.Label);
        }
        System.debug('--Res: '+scelteEsito);
        return scelteEsito;
    }
    
    private static List<CaseEsitiConfig__mdt> filterEsiti(List<CaseEsitiConfig__mdt> data, String filter){
        List<CaseEsitiConfig__mdt> res=new List<CaseEsitiConfig__mdt>();
        for(CaseEsitiConfig__mdt c:data){
            List<String> vis=c.Visibility__c==null?new List<String>{''}:c.Visibility__c.split(',');
            for(String s:vis){
                if(s.equalsIgnoreCase(filter) || ('System Administrator'.equals(filter))){
                    res.add(c);
                    break;
                }
            }
        }
        return res;
    }
    
    @AuraEnabled
    public static void handleCase(String esito,String recordId,String note){
        CaseUtils.esitaCase(recordId,esito,note);
        XCSNoteUtils.postANote(recordId,'Nota - '+esito,!String.isEmpty(note)?note:'');
        /* La gestione è lasciata al componente padre
         * 
         * if(!esito.equalsIgnoreCase('Annullata')){
            if(esito.equalsIgnoreCase('Gestita')){
                CaseUtils.closeCase(recordId);
            }
            CaseUtils.assignToParentQueue(recordId);
        }
        else{
            CaseUtils.closeCase(recordId);
        }*/
    }
    
    @AuraEnabled //Deprecated, use this.handleCase() instead
    public static void updateCase(String caseId, String esito, String nota){
        Case cs = [SELECT Id, Esito__c, Status, Note__c FROM Case WHERE Id =: caseId];
        
        System.debug('NOTA TEST DA VISIONARE' + nota);
     	 XCSNoteUtils.postANote(caseId,'Nota - '+esito,!String.isEmpty(nota)?nota:'');
        
        cs.Status = 'Closed';
        cs.Esito__c = esito;
        cs.Note__c = nota;
       
        update cs;
        System.debug('Caso in salvataggio: ' + cs);
    }
    
    
    
}