public class SFAConvenzBottoneAnnullaCntroller {

    @AuraEnabled
    public static Boolean getIfCaseAnnulled(String recordId){ 
        
        Boolean attivitaAnnullata=false;
        
        String statusAttivita= [SELECT Id, Status FROM Case where id=:recordId][0].Status;
        if (statusAttivita==CaseUtils.ANNULLATO){
            attivitaAnnullata=true;
            
        }
        
        System.debug('attivita annullata:: ***** '+attivitaAnnullata);
        return attivitaAnnullata;


    }     
    
    
    @AuraEnabled
    public static Id handleCase(String caseId, String listViewName){

        //Aggiorna lo satto del case
        Case caseAttivita=SFAConvenzionamento.getCase(caseId);
        caseAttivita=CaseUtils.changeStatus(caseAttivita,CaseUtils.ANNULLATO);
        update caseAttivita;  
        
        //recupera l'id della list view in base alla categoria del case nel caso in cui non venga passata alcuna listView a cui navigare una volta annullata l'attivita
        if(String.IsEmpty(listViewName)){
            Map<String,String> mapListView=new Map<String,String>();
            mapListView.put(XCS_CategoriaUtil.SFA_CONVENZIONAMENTO_GESTIONE_DOSSIER_DEALER,'Gestione_Dossier');
            mapListView.put(XCS_CategoriaUtil.SFA_CONVENZIONAMENTO_NEW_DEALER_ACQUISITION,'New_Dealer_Acquisition');
            mapListView.put(XCS_CategoriaUtil.SFA_CONVENZIONAMENTO_NEW_DEALER_PROSPECT,'New_Dealer_Prospect');
            mapListView.put(XCS_CategoriaUtil.SFA_CONVENZIONAMENTO_SEGNALAZ_DEALER,'Segnalazione_Dealer');
            listViewName=mapListView.get(caseAttivita.CategoriaExternalId__c );
        } 

        return [SELECT Id, Name FROM ListView WHERE SobjectType ='Case' AND DeveloperName=:listViewName][0].Id;

    }    
    
    
}