global class SFAListaDaSedeChiusuraListe implements Database.Batchable<sObject>,Database.Stateful {

    //Quando una lista (SFA_Liste_Caricate__c) viene chiusa, tutti i case relativi verranno chiusi

    private static final String ESITO_CHIUSURA_AUTOMATICA = 'Chiusura Automatica';
    private static final String CHIUSO = 'Chiuso';
    @AuraEnabled
    public List<SFA_ListeCaricate__c> listechiuse = new List<SFA_ListeCaricate__c>();
    public Map<Id,SFA_ListeCaricate__c> listMap = new Map<Id,SFA_ListeCaricate__c>();

    global SFAListaDaSedeChiusuraListe(List<SFA_ListeCaricate__c> lista){
        listechiuse=lista;
        system.debug('COSTRUTTORE listechiuse'+listechiuse);
    }

    global Iterable<sObject> start(Database.BatchableContext bc){
        system.debug('@@@@@@@@@@@ BATCH SFAListaDaSedeChiusuraListe START: ');

        List<Case> caseList = new List<Case>();
        system.debug('START listechiuse'+listechiuse);

        if(!listechiuse.isEmpty()){

            for(SFA_ListeCaricate__c lista : listechiuse){
                if(!listMap.containsKey(lista.Id)){
                    listMap.put(lista.id,lista);
                }
            }

            caseList = [SELECT Id,Esito__c,Status,Data_Visibilita__c,SFA_ListeCaricate__c FROM Case WHERE SFA_ListeCaricate__c IN:listechiuse];
            system.debug('@@@caseList: '+caseList);
        }

        return caseList;
    }
    
    global void execute(Database.BatchableContext bc, List<Case> caseList){
   		system.debug('@@@@@@@@@@@ BATCH SFAListaDaSedeChiusuraListe EXECUTE: ');
        if(!caseList.isEmpty()){

            for(Case c : caseList){
                SFA_ListeCaricate__c lista = listMap.get(c.SFA_ListeCaricate__c);
                
                if(lista.Chiuso__c!=null && lista.Chiuso__c){
                    c.Esito__c = ESITO_CHIUSURA_AUTOMATICA;
                    c.Status = CHIUSO;
                }

                c.Data_Visibilita__c = lista.Data_Visibilita__c!=null ? lista.Data_Visibilita__c : c.Data_Visibilita__c!=null ? c.Data_Visibilita__c : null; 
            }

            update caseList;
        }
    }
    
    global void finish(Database.BatchableContext BC){
        system.debug('@@@@@@@@@@@ BATCH SFAListaDaSedeChiusuraListe FINISH: ');        
    }

}