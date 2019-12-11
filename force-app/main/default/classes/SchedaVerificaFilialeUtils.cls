public without sharing class SchedaVerificaFilialeUtils {
    public static List<Questionario_Scheda_Filiale__c> questionnaireToBeInsert;
    public static List<Domande_Scheda_Filiale__mdt> questions;
    /**
     * Genera una lista di Domande per ogni scheda verifica filiale in input
     * @param  listSchede - lista delle schede inserite
     */
    public static void generateQuestions (List<Scheda_Verifica_Filiale__c> listSchede){
        questionnaireToBeInsert = new List<Questionario_Scheda_Filiale__c>();
        //recupera tutte le domande presenti all'interno del metadato ed Attive
        questions = retrieveQuestions();
        for(Scheda_Verifica_Filiale__c scheda : listSchede){
            //genera per ogni scheda il questionario
            generateQuestionnaire(scheda);
        }

        insert questionnaireToBeInsert;
    }
    
    /**
     * Recupera la lista delle domande per la scheda filiale
     * @return List<Domande_Scheda_Filiale__mdt>
     */
    public static List<Domande_Scheda_Filiale__mdt> retrieveQuestions(){
        return [SELECT Id, DeveloperName, MasterLabel, Language, NamespacePrefix, Label, QualifiedApiName, Index__c, Rif__c, Sezione__c, Argomento__c, Tipologia__c, Evidenze_Precedenti__c, Attivo__c 
                        FROM Domande_Scheda_Filiale__mdt 
                        WHERE Attivo__c = true
                        order by Index__c];
    }

    /**
     * Genera la lista di domande afferenti alla scheda passata in input
     * @param  scheda - La scheda Verifica Filiale a cui dovranno afferire le domande generate
     */
    public static void generateQuestionnaire (Scheda_Verifica_Filiale__c scheda){

        for(Domande_Scheda_Filiale__mdt question:questions){
            Questionario_Scheda_Filiale__c questionnaire= new Questionario_Scheda_Filiale__c(Scheda_Verifica_Filiale__c=scheda.ID);
            questionnaire.Argomento__c              = question.Argomento__c;
            questionnaire.Evidenze_Precedenti__c    = question.Evidenze_Precedenti__c;
            questionnaire.Index__c                  = question.Index__c;
            questionnaire.Rif__c                    = question.Rif__c;
            questionnaire.Tipologia__c              = question.Tipologia__c;
            questionnaire.Sezione__c                = question.Sezione__c;
            questionnaireToBeInsert.add(questionnaire);
            
        }
    }

    public static void sharingSchedaVerificaFiliale (List<Scheda_Verifica_Filiale__c> schedaFiliale){
        
        String userRoleId = UserInfo.getUserRoleId();
        Group gruppo = [select id,RelatedId, related.name from Group  where RelatedId=:userRoleId and  type='Role' ];
        List<Scheda_Verifica_Filiale__Share> shareToInsert = new List<Scheda_Verifica_Filiale__Share>();
        if(String.isNotBlank(userRoleId)){
            for(Scheda_Verifica_Filiale__c scheda : schedaFiliale){
                    Scheda_Verifica_Filiale__Share share = new Scheda_Verifica_Filiale__Share(
                    ParentId=scheda.ID,
                    UserOrGroupId = gruppo.ID,
                    AccessLevel = 'Edit' );
                    shareToInsert.add(share);
            }
          
           insert shareToInsert;
        }
         
    }
    public static Boolean checkOpenRecord (String filialeId){
        List<Scheda_Verifica_Filiale__c> schedeAperte = [SELECT ID FROM Scheda_Verifica_Filiale__c WHERE Filiale__c=:filialeId AND Stato__c != '4' LIMIT 1];
        return schedeAperte.size()==0;
    }
    
    public static Boolean checkOrderDate (){
        Scheda_Verifica_Filiale__c scheda = (Scheda_Verifica_Filiale__c) Trigger.new[0];
        if(scheda.Periodo_dal__c!=null && scheda.Periodo_al__c!= null && scheda.Periodo_dal__c>scheda.Periodo_al__c){
            Trigger.new[0].addError('Attenzione, data fine verifica antecedente alla data inizio.');
            return false;
        }
        return true;
    }
}