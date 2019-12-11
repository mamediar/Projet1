public class SchedaVerificaFilialeHandler extends TriggerHandler{
    public override void afterInsert() {   
        System.debug('_______SchedaVerificaFilialeHandler.afterInsert____START');       
        SchedaVerificaFilialeUtils.generateQuestions(Trigger.new);
        //sharing del record di filiale
        SchedaVerificaFilialeUtils.sharingSchedaVerificaFiliale((List<Scheda_Verifica_Filiale__c>)Trigger.new);
        
        
        System.debug('_______SchedaVerificaFilialeHandler.afterInsert____DONE');  
    }

    public override void beforeInsert() {
        System.debug('_______SchedaVerificaFilialeHandler.beforeInsert____START'); 
        String filialeId =  ((Scheda_Verifica_Filiale__c) Trigger.new[0]).Filiale__c;
        System.debug('filialeid-->'+filialeId);

        Boolean correctDate = SchedaVerificaFilialeUtils.checkOrderDate();
        if(false == correctDate) return;


        Boolean pass = SchedaVerificaFilialeUtils.checkOpenRecord(filialeId);
        if(true == pass) {
            String roleId = UserInfo.getUserRoleId();
            String userRole;
            if(String.isBlank(roleId)){
                Trigger.new[0].addError('Errore: Nessun ruolo configurato per la tua utenza. Configura un ruolo e riprova.');
                return;
            } 
            
            userRole = [select id,DeveloperName from UserRole where ID=:roleId].DeveloperName;
            
            for(Scheda_Verifica_Filiale__c svf : (List<Scheda_Verifica_Filiale__c >)Trigger.new){
                svf.Ruolo_Creazione__c  = userRole;
            }
        } else {
            Trigger.new[0].addError('Errore: Non è stato possibile creare la Scheda. Esiste già una scheda aperta per la Filiale.');
            return;
        }
        System.debug('_______SchedaVerificaFilialeHandler.beforeInsert____DONE');  
    }

    public override void beforeUpdate() {
        Boolean correctDate = SchedaVerificaFilialeUtils.checkOrderDate();
        if(false == correctDate) return;
    }

    public override void beforeDelete() {
        Scheda_Verifica_Filiale__c scheda = (Scheda_Verifica_Filiale__c) Trigger.old[0];
        if (scheda.Stato__c != '1'){
            Trigger.old[0].addError('Errore: Non è possibile eliminare Schede Verifica Filiali con stato diverso da Bozza');
            return;
        }
    }
}