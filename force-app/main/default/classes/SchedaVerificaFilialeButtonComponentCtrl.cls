public without sharing class SchedaVerificaFilialeButtonComponentCtrl {

    /**
     * il metodo controlla i campi obbligatori per
     * proseguire con l approvazione
     * @param  schedaFilialeId 
     * @return error description               
     */
    @AuraEnabled
    public static String checkRequired(String schedaFilialeId){
        List<String> errorList = new List<String>();
        System.debug('____SchedaVerificaFilialeButtonComponentCtrl:checkRequired___START');
        System.debug('SchedaVerificaFilialeButtonComponentCtrl schedafiliale-->'+schedaFilialeId);
        //check for questions without esito
        List<Questionario_Scheda_Filiale__c> questionarioList = [SELECT ID,Rif__c, Argomento__c FROM Questionario_Scheda_Filiale__c WHERE Scheda_Verifica_Filiale__c = :schedaFilialeId AND Esito_controllo_Attuale__c = NULL ORDER BY index__c];
        System.debug('SchedaVerificaFilialeButtonComponentCtrl questionario null-->'+questionarioList);
        for(Questionario_Scheda_Filiale__c quest : questionarioList){
            return 'questionario';
        }

        Scheda_Verifica_Filiale__c scheda = [SELECT ID, Periodo_al__c, Responsabile_Attuale__c, Responsabile_dal__c,Considerazioni_Conclusioni__c
                                                FROM Scheda_Verifica_Filiale__c
                                                WHERE ID=:schedaFilialeId];
        if(scheda.Periodo_al__c==null){
            errorList.add('Data \'Periodo: al\'');
        }
        if(String.isBlank(scheda.Responsabile_Attuale__c)){
            errorList.add('Reponsabile attuale');
        }
        if(scheda.Responsabile_dal__c==null){
            errorList.add('Data \'Reponsabile attuale\'');
        }
        if(String.isBlank(scheda.Considerazioni_Conclusioni__c)){
            errorList.add('Considerazioni/Conclusioni');
        }


        System.debug('____SchedaVerificaFilialeButtonComponentCtrl:checkRequired___DONE');

        return JSON.serialize(errorList);
    }
    /**
     * Gestisce l invio in approvazione della scheda
     * agli utenti della label SchedaVerificaFiliale_AliasApprovatori
     * @param  schedaFilialeId 
     * @return                 
     */
    @AuraEnabled
    public static String sendApprovalUser(String schedaFilialeId){
        System.debug('____SchedaVerificaFilialeButtonComponentCtrl:sendApprovalUser___START');
        String response;
        /*String approvers = Label.SchedaVerificaFiliale_AliasApprovatori;
        List<String> aliasList = approvers.split(';');
        List<User> userApprovers = [SELECT ID, alias    
                        FROM USER WHERE Alias in :aliasList 
                        AND IsActive = true];*/
        /*if(userApprovers.size() == 0){
             response = 'Nessun utente approvatore trovato';
        } else {*/
        String userId = UserInfo.getUserId();
            User user = [select id,Profile.Name from user where id=:userId];
            if(user.Profile.Name == 'Area Manager' || 
                user.Profile.Name == 'System Administrator' || 
                user.Profile.Name == 'Amministratore del sistema'){
                System.debug('Richiesta approvazione');
                try{
                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                req.setComments('');
                req.setObjectId(schedaFilialeId);
                /*List<ID> userApprId= new List<ID>();
                for(User usID : userApprovers){
                    userApprId.add(usID.ID);
                }
                req.setNextApproverIds(userApprId);*/

                Approval.ProcessResult result = Approval.process(req);
                }catch(Exception e){
                    response = e.getMessage();
                }
            //}
            } else {
                //utente non abilitato alla richiesta approvazione
                return 'Errore : Utente non abilitato alla richiesta approvazione';
            }
            
           
        System.debug('____SchedaVerificaFilialeButtonComponentCtrl:sendApprovalUser___START');
        
        return response;
    }

    @AuraEnabled
    public static string getSchedaFilialePrecedente(String filialeId, String schedaFilialeId){
        System.debug('____SchedaVerificaFilialeButtonComponentCtrl:getSchedaFilialePrecedente___START');
        System.debug('filialeId:'+filialeId);
        System.debug('schedaFilialeId:'+schedaFilialeId);
        List<Scheda_Verifica_Filiale__c> schedaFiliale = [SELECT ID FROM Scheda_Verifica_Filiale__c 
                                                WHERE filiale__c = :filialeId  AND
                                                stato__c = '4' AND ID !=:schedaFilialeId 
                                                ORDER BY Createddate DESC 
                                                LIMIT 1];
        if(schedaFiliale.size()==1){
            System.debug('____SchedaVerificaFilialeButtonComponentCtrl:getSchedaFilialePrecedente___DONE');
            return schedaFiliale[0].ID;
        }
        System.debug('____SchedaVerificaFilialeButtonComponentCtrl:getSchedaFilialePrecedente___DONE');
        return null;
    }

    public class CustomException extends Exception {
        
    }
}