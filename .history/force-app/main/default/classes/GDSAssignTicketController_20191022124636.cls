public without sharing class GDSAssignTicketController
{
    @AuraEnabled
    public static Case[] returnTicket (String nome,String cognome,String Datadinascita,String Codicefiscale){
        String nuovoStato = CaseUtils.APERTO;
        String categoriaCaso = XCS_CategoriaUtil.AUI_RECUPERO_DOCUMENTI_SCADUTI;
        String querySelect = 'SELECT Id,caseNumber,Subject, AccountId,Account.Firstname,Account.Lastname,Account.Data_nascita__c,Account.Codice_Fiscale__pc, Status,  ActivityType__c, Categoria__c, Sottocategoria__c , Account.OCS_External_Id__c';
        String queryFrom = ' FROM Case';
        String queryWhere = ' WHERE Status = :nuovoStato AND Categoria_riferimento__r.External_id__c = :categoriaCaso';
        if(String.isNotBlank(nome)){
            nome += '%';
            queryWhere += ' AND Account.FirstName like :nome';
        }
        System.debug('*****' + queryWhere);
        if(String.isNotBlank(cognome))
        {
            cognome += '%';
            queryWhere += ' AND Account.LastName like :cognome';
        }
        if(String.isNotBlank(codiceFiscale))
        {
            codiceFiscale += '%';
            queryWhere += ' AND Account.Codice_Fiscale__pc like :codiceFiscale';
        }
        if(String.isNotBlank(Datadinascita))
        {
          	Date DDN = date.valueOf(Datadinascita);
            queryWhere += ' AND Account.Data_nascita__c = :DDN';
        }
        List<Case> res = Database.query(querySelect + queryFrom + queryWhere);
        System.debug('*******' + queryWhere);

        /*
        if(Datadinascita == null)
        {
            res= [
                SELECT Id,caseNumber,Subject, AccountId,Account.Firstname,Account.Lastname,Account.Data_nascita__c,Account.Codice_Fiscale__pc, Status,  ActivityType__c, Categoria__c, Sottocategoria__c , Account.OCS_External_Id__c
                FROM Case 
                WHERE
                Account.FirstName like :nome AND
                Account.LastName like :cognome AND
                Account.Codice_Fiscale__pc like : Codicefiscale AND
                Status ='New' AND 
                Categoria_riferimento__r.External_id__c = '5616'
            ];
        }
        else
        {
            Date DDN = date.valueOf(Datadinascita);
            res= [
                SELECT Id,caseNumber,Subject, AccountId,Account.Firstname,Account.Lastname,Account.Data_nascita__c,Account.Codice_Fiscale__pc, Status,  ActivityType__c, Categoria__c, Sottocategoria__c 
                FROM Case 
                WHERE
                Account.FirstName like :nome AND
                Account.LastName like :cognome AND
                Account.Codice_Fiscale__pc like : Codicefiscale AND
                Account.Data_nascita__c = :DDN  AND
                Status ='New' AND 
                Categoria_riferimento__r.External_id__c = '5616'
            ]; 
        }
        */
        System.debug('TEST LIST' + res);
        return res;
    }
    
    @AuraEnabled
    public static List<String> abbinaContatto(String caseDadId, String caseChildId, XCS_Disposition__c disposition, String notas){
        
       	String esito = disposition.External_Id__c;
        System.debug('Object child case = ' + caseChildId);
        System.debug('id case = ' + caseDadId);
        System.debug('esito = ' + esito);
        System.debug(UserInfo.getLastName());
        
        List<String> valori = new List<String>();
        List<Case> t = new List<Case>();
       
        Case father = [Select id,CaseNumber FROM case WHERE id =: caseDadId];
        Case child ;
        
        String idProfilo = UserInfo.getProfileId();
        String nomeProfilo = [Select name from Profile where id =: idProfilo].name;
        
        System.debug(nomeProfilo);
        
        father.Utente_Lavorazione__c = UserInfo.getLastName();
        father.Profilo_Utente_Lavorazione__c = nomeProfilo;
        
        String idAcc = '';
        String templateName = '';
        String idAccWithoutC = '';
        System.debug('idAccWithoutC' + idAccWithoutC);
        
        String notaFormattata = '----------inizio note--------- \n' + nomeProfilo +  '-' + UserInfo.getLastName() + '\n Stato:gestita + \n + note:AUI documento conforme, archiviato e modificato anagrafica + \n ' + notas + ' \n -----------fine note ----------';
        String nota ;        
        System.debug('accid =' + idAcc);
        System.debug(nota);
        father.Disposition__c = disposition.id;
        if(caseChildId == null || caseChildId == '')
        {
            father.Status = 'Closed';
            t.add(father);   
        }
        else{
            child = [Select id,ParentId, SuppliedMobilePhone__c from case where id =: caseChildId];    
            child.Utente_Lavorazione__c = UserInfo.getLastName();
            child.Profilo_Utente_Lavorazione__c = nomeProfilo;
            idAcc = [SELECT Account.OCS_External_Id__c from Case where id =: caseChildId].Account.OCS_External_Id__c;
            idAccWithoutC = idAcc.substring(1);
            if('DP5620'.equalsIgnoreCase(esito)){
                System.debug('documenti illeggibile, chiudi solo il case in lavorazione (child)');
                child.ParentId = caseDadId;
                father.Status = 'Closed';
                templateName = 'SMS.AUI_EsitoKO';
                nota = '-----Nota richiesta postvendita CRM ' + father.CaseNumber + '----- AUI - Recupero Documento Scaduto ' + nomeProfilo +  '-' + UserInfo.getLastName() + 'Stato:in Lavorazione + note: AUI Documento non conforme' + notas + ' -----------fine note ----------';
            } else if('DP5619'.equalsIgnoreCase(esito)){
                System.debug('documenti ok, chiudi entrambi i cases (child/father)');
                List<Case> recall = [select id,Status from case where Type = 'CRM' AND Status ='New' AND Categoria_riferimento__r.External_Id__c = '1037' AND Parentid = :child.Id];
                For(Case c : recall)
                {
                   c.Status = 'Closed';
                   t.add(c);
                }
                child.ParentId = caseDadId; 
                child.Status = 'Closed';
                father.Status = 'Closed';
                
                templateName = 'SMS.AUI_EsitoOK';
                nota = '-----Nota richiesta postvendita CRM ' + father.CaseNumber + '----- AUI - Recupero Documento Scaduto ' + nomeProfilo +  '-' + UserInfo.getLastName() + 'Stato:gestita + note: AUI Documento conforme, archiviato e modificato anagrafica ' + notas + ' -----------fine note ----------';
            }       
            else
                system.debug('Attenzione: i valori della pickList non esistono o sono stati modificati');
            t.add(child);
            t.add(father);
        }     
        CaseUtils.updateListCase(t);	
        
        valori.add(idAccWithoutC);
        valori.add(nota);
        valori.add(idAcc);
        valori.add(templateName);
        valori.add(caseChildId);
        
        return valori;
        
    }
    
    @AuraEnabled
    public static void chiamaServizio(List<String> strings){
        System.debug('sono nel metodo chiama servizio ' + strings.get(2));
        if(strings.size() == 4 && !''.equals(strings.get(4)) && null != strings.get(4))
        {
            OCSGestioneNoteInvoker.filtranote('',strings.get(0),'','','A','P',strings.get(1));
            callWebService(strings.get(2),strings.get(3),strings.get(4));
        }
    }
    @AuraEnabled
    public static void callWebService(String idClient, String templateName, String idCase){
        
        System.debug('Sono in GestioneDocumentiScadutiInvocableSms'+ idClient);
        List<Account> listA = [Select ID,Lastname,FirstName From account where OCS_External_Id__c = :idClient];
        List<Case> listC = [Select ID, SuppliedMobilePhone__c From case where ID = :idCase];
        List<XCS_Template__c> templateTesto = [SELECT Body__c FROM XCS_Template__c Where Name = : templateName];
        System.debug(templateTesto);
        if(listC.size() > 0 ){
            Account a = listA[0];
            case c = listC[0];
            if(c != null){
                System.debug('sono nell if di account' + a.FirstName + ' ' + a.LastName);
                if(!(''.equals(c.SuppliedMobilePhone__c) || c.SuppliedMobilePhone__c == null )){
                    OCSInviaSMSInvoker.inviaSMS('',c.SuppliedMobilePhone__c,'','',templateTesto[0].Body__c);  
                    System.debug('cell = ' + c.SuppliedMobilePhone__c + ' ID:' + a.Id);
                } 
            }
        }
        
    }
    
}