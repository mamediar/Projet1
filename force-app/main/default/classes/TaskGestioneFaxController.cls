public class TaskGestioneFaxController {
    
    @AuraEnabled
    public static void updateStatus(String objId, String status){
        Case currentCase = new Case(
            Id = objId,
            Stato_Azione__c = status
        );
        update currentCase;
   }
    
    @AuraEnabled
    public static Case getCase(String objId){//getTask(String objId){        
       Case currentCase = [SELECT id, Stato_Azione__c, Account.getCodice_cliente__c, NumeroPratica__c, product__r.ProductCode, product__r.Name, product__r.RSS_External_Id__c,
                           categoria_riferimento__r.External_id__c, categoria_riferimento__r.Name, parentid, TentativoNum__c, Status, GestioneFax_Esito__c,
                           Stato_Comunicazione__c FROM Case Where id =: objId
                           ];
        return currentCase;
    }
    
    @AuraEnabled
    public static void updateStatusConunicazione(String objId, String status){        
      	Case currentCase = new Case(
        	id = objId,
            Stato_Comunicazione__c = status
        );
        update currentCase;
    }
    
    @AuraEnabled
    public static PV launchPV(Double IdProdotto, Double IdCategoria, String recordId, String codCliente){    
       Double idPVFax;
        PV postVendita = new PV();
        String accId = '';

        System.debug( 'Prodotto: ' + idProdotto + ' - Categoria ' + idCategoria );
        
        List<CRM_Gestione_Fax_Config__mdt> gfx =  [SELECT operation_cat_id__c,operation_pv_category_id__c FROM CRM_Gestione_Fax_Config__mdt 
                                                   where idProdotto__c =: IdProdotto AND idCategoria__c =: IdCategoria];

        postVendita.config = gfx[0];
        postVendita.ids = getAttachments( recordId );
        
        return postVendita;
    }
    
    @AuraEnabled
    public static List<Codice> getComunicazioni(String esito, Double IdCategoria, Double IdProdotto){ 
        
        List<CRM_Gestione_Fax_Config__mdt> gfx = new List<CRM_Gestione_Fax_Config__mdt>();         
        List<Codice> codice = new List<Codice>();       
        
        String letterNotSplitted;
        String[] letterSplitted;
        String smsNotSplitted;
        String[] smsSplitted;
        String emailNotSplitted;
        String[] emailSplitted;
        
        if('OK'.equalsIgnoreCase(esito)){
            gfx = [Select label, sms_ok_code__c, letter_ok_code__c, email_ok_code__c 
                   from CRM_Gestione_Fax_Config__mdt 
                   where idProdotto__c =: IdProdotto AND idCategoria__c =: IdCategoria];
            
            if(gfx.size() > 0){                
                letterNotSplitted = gfx[0].letter_ok_code__c;
                smsNotSplitted = gfx[0].sms_ok_code__c;
                emailNotSplitted = gfx[0].email_ok_code__c;                
            } 
            
        } else if ('KO'.equalsIgnoreCase(esito)){
            gfx = [Select label, sms_ko_code__c, letter_ko_code__c, email_ko_code__c 
                   from CRM_Gestione_Fax_Config__mdt 
                   where idProdotto__c =: IdProdotto AND idCategoria__c =: IdCategoria];
            
            if(gfx.size() > 0){
                letterNotSplitted = gfx[0].letter_ko_code__c;
                smsNotSplitted = gfx[0].sms_ko_code__c;
                emailNotSplitted = gfx[0].email_ko_code__c;
            }
        }
        
        for(CRM_Gestione_Fax_Config__mdt m : gfx){
            
            if(letterNotSplitted != null && !''.equalsIgnoreCase(letterNotSplitted)){
                letterSplitted = letterNotSplitted.split('/');
                if(letterSplitted.size() > 0){                   
                    for(Integer i = 0; i < letterSplitted.size(); i++){
                        Codice cod = new Codice();
                        cod.Tipologia = 'Lettera';
                        cod.Codice = letterSplitted[i];
                        codice.add(Cod);                       
                    }
                }
            }
            if(smsNotSplitted != null && !''.equalsIgnoreCase(smsNotSplitted)){
                smsSplitted = smsNotSplitted.split('/');  
                if(smsSplitted.size() > 0){
                    for(Integer i = 0; i < smsSplitted.size(); i++){
                        Codice cod = new Codice();
                        cod.Tipologia = 'Sms';
                        cod.Codice = smsSplitted[i];
                        codice.add(Cod);                      
                    }
                }                
            }
            if(emailNotSplitted != null && !''.equalsIgnoreCase(emailNotSplitted)){
                emailSplitted = emailNotSplitted.split('/');               
                if(emailSplitted.size() > 0){
                    for(Integer i = 0; i < emailSplitted.size(); i++){
                        Codice cod = new Codice();
                        cod.Tipologia = 'Email';
                        cod.Codice = smsSplitted[i];
                        codice.add(Cod);                      
                    }
                }               
            }            
        }       
        return codice;       
    }
    
    @AuraEnabled
    public static void updateTaskStatus(String objId, String status){
        String userAlias = [Select alias from user where id = :userinfo.getUserId()].alias;
        Case currentCase = new Case(
        	Id = objId,
            Status = status,
            Utente_Lavorazione__c = userAlias
        );
        update currentCase;
    }
    
    @AuraEnabled
    public static void updateCaseTaskStatus(String idCase, String objId, String status, String note){        
        String userAlias = [Select alias from user where id = :userinfo.getUserId()].alias;
        List<Case> caseList = [SELECT id, (select id, status from cases where id !=: objId) FROM Case where id= :idCase];
        List<Case> caseChildList = caseList[0].cases;
        Case c = [Select id,createdDate from case where id = :objId];
        Boolean isCompleted = true;
        
        
        
        Case currentCase = new Case(
        	id = objId,
            Status = status,
            Note__c = note,
            Utente_Lavorazione__c = userAlias,
            sla_minutes__c = BusinessHoursUtils.getDiffMinutesForCRMFax(c.createdDate, system.now())
        );
        
        for(Case t : caseChildList){
            if(!'Closed'.equalsIgnoreCase(t.Status)){
                isCompleted = false;
                break;
            }           
        }  
        
        if(isCompleted){
            caseList[0].status = 'Gestito';
            update caseList[0];
        }
        
        update currentCase;
    }
    
    @AuraEnabled
    public static void updateSlaDateCase(String objId, String idCase, DateTime recall){
        System.debug('id case = ' + idCase);
        DateTime dt = DateTime.now();
        Long slaDateForRecall;  
        List<CRM_QueueMailFaxConfig__c> qmfx = new List<CRM_QueueMailFaxConfig__c>();
        List<Group> g = new List<Group>();

        List<Case> currentCase = [Select TentativoNum__c,Status From Case Where id =: objId];
        currentCase[0].Status = 'In corso';
        currentCase[0].TentativoNum__c++;
        
        List<Case> c = [Select id, SLA_Date__c, RecallDate__c, owner.name from case where id =: idCase];
        
        
        BusinessHours bh = [Select Id, MondayStartTime, MondayEndTime from BusinessHours where name = 'CRM_SLA_Fax'];
        String bhId = bh.id;
        if(recall != null){
            if(c.size() > 0){
                if(c[0].SLA_Date__c != null){ 
                    DateTime newSla = DateTime.newInstance(recall.getTime()); 
                    //In questo caso la Bh è impostata con 10 ore lavorative 
                    
                    Long hours = bh.MondayEndTime.hour() - bh.MondayStartTime.hour();
                    System.debug('hours = ' + hours);
                    Long slaDateOggi = (newSla.getTime() - dt.getTime())/hours;
                    System.debug('differenza tra le date in millisecondi = ' + slaDateOggi);
                    System.debug('ore = '+ slaDateOggi/1000/3600);
                    
                    c[0].SLA_Date__c = BusinessHours.add(bhId,recall,slaDateOggi);  
                    c[0].RecallDate__c = recall;
                    System.debug('slaDate aggiornata = ' + c[0].SLA_Date__c);
                    
                }
            }
        }
        
        List<EmailMessage> e = [select toAddress from EmailMessage where Parentid =: c[0].id order by createdDate asc limit 1];
        System.debug('emailMessage = ' + e);
        List<Group> tmpG = [select developerName from group where name =: c[0].owner.name and type = 'Queue' limit 1];
        if(e.size() > 0)
            qmfx = [select Recall_Queue__c from CRM_QueueMailFaxConfig__c where Mailbox__c =: e[0].ToAddress and DeveloperName__c =: tmpG[0].developerName limit 1];
        System.debug('qmfx = ' + qmfx);
        if(qmfx.size() > 0)
            g = [Select id from Group where developerName =: qmfx[0].Recall_Queue__c limit 1];
        System.debug('g = ' + g);
        if(g.size() > 0)
            c[0].ownerId = g[0].id;
        
        update currentCase; 
        update c[0];
        
    }
    
    @AuraEnabled
    public static String checkStatusAzione(String objId){
        Case tk = [Select stato_azione__c from Case where id =: objId];
        return tk.Stato_Azione__c;
        
    }
    
    @AuraEnabled
    public static String checkStatusComunicazione(String objId){
        Case tk = [Select stato_comunicazione__c from Case where id =: objId];
        return tk.Stato_Comunicazione__c;       
    }
    
    @AuraEnabled
    public static Double getConfigFax(Double idProdotto, Double idCategoria){
        System.debug('idProdotto '+ idProdotto);
        System.debug('idCategoria '+ idCategoria);
        double recallMax = 0; 
        List<CRM_Gestione_Fax_Config__mdt> gfx = [SELECT recall_number__c FROM CRM_Gestione_Fax_Config__mdt 
                                                  WHERE idCategoria__c =:idCategoria 
                                                  AND idProdotto__c =: idProdotto LIMIT 1];
        
        System.debug('gfx '+ gfx);
        if(gfx.size() > 0){
            recallMax = gfx[0].recall_number__c;
        }
        
        return recallMax;
    }
    
    @AuraEnabled
    public static void updateFlagContatto(String objId, Boolean flagCliente){
       	Case currentCase = new Case(
        	Id = objId);
        if(flagCliente == null || flagCliente == false)
            currentCase.FlagContattoCliente__c  = false;      
        else if (flagCliente == true){
            currentCase.FlagContattoCliente__c  = true;
        }
        
        update currentCase;

    }
    
    @auraEnabled
    public static void updateEsitoTask(String objId, String esito){
        Case currentCase = new Case(
        	Id = objid,
            GestioneFax_esito__c = esito
        );
        update currentCase;
    }
    
    @AuraEnabled
    public static List<Id> getAttachments( String idCase )
    {
        List<Attachment> attachments = [ select id from attachment
        where parentid in ( select id from emailmessage where parentid =: idCase ) ];

        List<Id> ids = new List<Id>();

        for( Attachment att : attachments  )
        {
            ids.add( att.id );
        }

        return ids;
    }



    public class PV{
        @AuraEnabled
        public CRM_Gestione_Fax_Config__mdt config {get; set;}
        @AuraEnabled
        public ID[] ids {get; set;}
    }
    
    public class Codice{
        @AuraEnabled
        public String Tipologia{get; set;}
        @AuraEnabled
        public String Codice{get; set;}
    }
    
}