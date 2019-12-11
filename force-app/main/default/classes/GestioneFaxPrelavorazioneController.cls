public class GestioneFaxPrelavorazioneController {
    
    public class DispObj {
       @AuraEnabled public String tipo;
       @AuraEnabled public String label;
       @AuraEnabled public String value;
       @AuraEnabled public String category_id;
       @AuraEnabled public String queue_id;
       @AuraEnabled public String disposition_id;

       public boolean isUpdateStatus( )
       {
           return String.isEmpty( category_id ) && 
                  String.isEmpty( queue_id ) &&
                 !String.isEmpty( disposition_id );
       }
    }

    @AuraEnabled
    public static void saveDisposition( Id caseId, String scelta ) {
        system.debug ( 'Scelta : ' + scelta );
        DispObj sceltaDisp = (DispObj)JSON.deserialize( scelta, DispObj.class );
        system.debug( sceltaDisp );
        Case c = new Case( id = caseId );
        if ( !String.isEmpty( sceltaDisp.category_id ) )
            c.Categoria_Riferimento__r = XCS_CategoriaUtil.getCategoryForExternalId( sceltaDisp.category_id );
        if ( !String.isEmpty( sceltaDisp.disposition_id ) )
            CaseUtils.aggiornaDispositionCase( c, sceltaDisp.disposition_id, false);
        if ( !String.isEmpty( sceltaDisp.queue_id ) )
            c.ownerId = GroupUtils.getQueue( sceltaDisp.queue_id ).Id;

        if ( sceltaDisp.isUpdateStatus() )
            c.status = 'Gestito';
        
        update c;
    }

    @AuraEnabled
    public static List<Map<String, String>> getQueueMailFax(){
        List<Map<String, String>> res = new List<Map<String, String>>();
        Set<String> mailBoxSet = new Set<String>();
        List<CRM_QueueMailFaxConfig__c> addressList = [SELECT Id, MailBox__c FROM CRM_QueueMailFaxConfig__c WHERE Type__c = 'Fax' AND Balancing__c > 0];
        for(CRM_QueueMailFaxConfig__c q : addressList){ 
            mailBoxSet.add(q.MailBox__c); 
        }
        for(String m : mailBoxSet){
            Map<String, String> tempMap = new Map<String, String>();
            tempMap.put('label', m);
            tempMap.put('value', m);
            res.add(tempMap);
        }                 
        return res;
    }
    
    @AuraEnabled
    public static void aggiungiCaseFiglio (String caseId, String prodotto, String categoria, String codiceCliente, String codicePratica, Integer idCategoria, Integer idProdotto, OCSCliente clienteOcs ) {        
        
        List<Case> lCase = new List<Case>();
        id rt = RecordtypeUtil.getRecordType(RecordtypeUtil.API_NAME_CASE,RecordtypeUtil.CRM_ATTIVITA_FAX);
        Case casePadre = [Select id,ownerid from case where id =:caseID];
        Case cs = new Case();
        cs.ParentId = caseid;  
        cs.Subject = (prodotto + ' - ' + categoria);
        cs.ownerid = casePadre.ownerid;
     //   cs.Categoria__c = categoria;
        cs.Product__c = Product2Util.getProductFromExternalId(idProdotto + '').id;
        cs.categoria_riferimento__r = XCS_CategoriaUtil.getCategoryForExternalId(idCategoria + '');
        cs.Account = new Account(OCS_External_Id__c = 'C' + codiceCliente);
        cs.NumeroPratica__c = codicePratica;
        cs.recordtypeid = rt;
        lCase.add(cs);
        System.debug( 'cliente: ' + clienteOcs );

        if ( clienteOcs != null )
        {           
            Account cliente = Accountutils.makeAccount( clienteOcs, 'Compass' );
            
            upsert cliente ocs_external_id__c;
		
            system.debug( 'upsert avvenuto con id: ' + cliente.id );

            Case c = new Case( );
            c.id = caseId;
            c.accountId = cliente.id;
        	lCase.add(c);
        }
        System.debug('***************LCASE:' + lCase);
        upsert lCase;
    }
    
    @AuraEnabled
    public static void doUpshot(String caseId, String outcome){
            
            Case currentCase = new Case ();
            currentCase.Id=caseId;
            currentCase.Esito__c = outcome;
            currentCase.Status = 'Gestito';
            update currentCase;
    }
    
    @AuraEnabled
    public static void doRouting(String caseId, String addressToForward){        
        RoutingEmailFax routingEmail = new RoutingEmailFax();
        routingEmail.init();        
        Case currentCase = [SELECT Id FROM Case WHERE Id = :caseId];
        List<Case> caseList = new List<Case>{currentCase};
            routingEmail.routing(caseList, addressToForward);                   
    }
    
    @AuraEnabled
    public static List<CRM_Gestione_Fax_Prodotti__mdt> loadProducts(){
        //  List<Map<String, String>> res = new List<Map<String, String>>();
        List<CRM_Gestione_Fax_Prodotti__mdt> products = [SELECT Id, MasterLabel, DeveloperName, idProdotto__c, NotUniqueLabel__c, Emettitore__c,Emettitore_Carta__c FROM CRM_Gestione_Fax_Prodotti__mdt ORDER BY MasterLabel ASC];
        System.debug('PRODOTTI:::::::::::>' + products);
        return products;
    }
    
    @AuraEnabled
    public static list<CRM_Gestione_Fax_Config__mdt> loadConfigs(){
        List<CRM_Gestione_Fax_Config__mdt> configs = [SELECT Id, check_duplicated__c, idCategoria__c, idProdotto__c, operation_pv_category_id__c  FROM CRM_Gestione_Fax_Config__mdt];
        return configs;
    }
    
    @AuraEnabled
    public static list<CRM_Gestione_Fax_Azioni__mdt> getCategorie(){
        List<CRM_Gestione_Fax_Azioni__mdt> actions = [SELECT Id, idAzione__c, Label__c, DeveloperName, MasterLabel  FROM CRM_Gestione_Fax_Azioni__mdt ORDER BY MasterLabel ASC];
        return actions;
    }
    
    @AuraEnabled
    public static String getEmettitore(String numPratica) {
        OCSCartaDatiFinanziariResponse res = OCSCartaDatiFinanziariInvoker.cartaDatiFinanziari(numPratica);
        return res.datiCartaDatiFinanziariResponse.emettitore;
    }
    
    @AuraEnabled
    public static Boolean hasTaskDuplicate (Double prodId, Double catId, String codiceCliente, String numeroPratica, Boolean checkDuplicated, String recordId){
        System.debug( 'ProdId :::::::::::::> ' + prodId);
        System.debug( 'CatId :::::::::::::> ' +  catId);
        System.debug( 'ProdId :::::::::::::> ' + codiceCliente );
        System.debug( 'ProdId :::::::::::::> '  +numeroPratica);
        
        if(checkDuplicated){
            List<Case> cases = [SELECT parentid FROM Case WHERE Product__r.rss_External_id__c =:prodId+'' AND Categoria_riferimento__r.External_id__c =: catId+'' AND Account.getCodice_Cliente__c =: codiceCliente AND NumeroPratica__c =:numeroPratica];
            System.debug( 'TASKS :::::::::::::> ' + cases);
            Set<Id> casesId = new Set<Id>();
            List<Case> ParentcaseNotClosed = new List<Case>();
            System.debug( 'Sono prima del for each del task' );
            
            for (case t : cases) {
                casesid.add(t.parentid);
            }
            
            System.debug( 'Sono DENTRO il ciclo for del task' );
            List<Case> cas = [SELECT Id,Status,IsClosed FROM Case WHERE Id IN: casesid];
            for (Case c : cas) {
                if (!c.IsClosed){
                    ParentcaseNotClosed.add(c);
                }
            }
            return ParentcaseNotClosed.size() >0;
        }
        
        else{
            List<case> caseschilds = [SELECT parentid FROM Case WHERE parentid = :recordid AND Product__r.rss_External_id__c =:prodId+'' AND Categoria_riferimento__r.External_id__c =: catId+'' AND Account.getCodice_Cliente__c =: codiceCliente AND NumeroPratica__c =:numeroPratica];
            System.debug( 'TASKS :::::::::::::> ' + caseschilds);
            Set<Id> caseId = new Set<Id>();
            List<Case> ParentcaseNotClosed = new List<Case>();
            System.debug( 'Sono prima del for each del task' );
            
            for (case t : caseschilds) {
                caseId.add(t.parentid);
            }
            System.debug( 'Sono DENTRO il ciclo for del task' );
            List<Case> cas = [SELECT Id,Status,IsClosed FROM Case WHERE Id IN: caseId];
            for (Case c : cas) {
                if (!c.IsClosed){
                    ParentcaseNotClosed.add(c);
                }
            }
            return ParentcaseNotClosed.size() >0;
        }
        
    }     
    @AuraEnabled
    public static Boolean hasTaskAssociati(String recordId){
        List<Case> cases = [SELECT Id FROM Case WHERE Parentid = :recordId];
        System.debug('TASK LIST ::::::::::::::::::::::::::::::::::> '  + cases);
        
        return cases.size() > 0;
        
    }
}