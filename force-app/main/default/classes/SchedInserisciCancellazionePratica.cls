/**
 * @File Name          : SchedInserisciCancellazionePratica.cls
 * @Description        : 
 * @Author             : sabrina vitali
 * @Group              : 
 * @Last Modified By   : sabrina vitali
 * @Last Modified On   : 23/10/2019, 14:17:14
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    14/10/2019   sabrina vitali     Initial Version
**/
global class SchedInserisciCancellazionePratica implements Schedulable {
    public String query;
    global SchedInserisciCancellazionePratica() {
        System.debug('***************** running SchedInserisciCancellazionePratica');
        //prendo i Case in attesa di essere inseriti nel registro. Posso eventualmente rilanciare per gli eventuali KO
        query = 'SELECT Id, Tipo_Pratica__c, NumeroPratica__c, Branch__r.Codice_Ufficio__c, Status, Step_PV__c ';
        query += 'FROM Case WHERE RecordType.Name = \'XCS_Post_Vendita\' and  Step_PV__c = \'998\' and Categoria_Riferimento__r.External_Id__c = \'1766\'';
        query += ' and pv_esito_poste__c <> \'OK\''; 
    }

    global void execute(SchedulableContext ct){
        System.debug('***************** execute SchedInserisciCancellazionePratica');
        Id idjob = Database.executeBatch(new BatchInserisciCancellazionePratica(query),80);
        System.debug('*** idjob : ' + idjob);
    }
}