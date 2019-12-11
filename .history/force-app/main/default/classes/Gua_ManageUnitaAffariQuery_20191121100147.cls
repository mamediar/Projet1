/**
 * @File Name          : Gua_ManageUnitaAffariQuery.cls
 * @Description        : 
 * @Author             : Mame Bousso kane
 * @CreatedDate        : 09/09/2019
**/
public with sharing class Gua_ManageUnitaAffariQuery {

    public static List<Account> getAccount(){
        List<Account> accounts= new List<Account>();
        try {
            accounts = [Select OCSAreaId__c, Id, Region_Name__c from Account];
        } catch (Exception e) {
            System.debug('Gua_ManageUnitaAffariQuery getAccount error');
            System.debug('Gua_ManageUnitaAffariQuery getAccount '+ e.getMessage()+' '+ e.getLineNumber());
        }
        return accounts;
    }
    
    public static List<Group> getQueus(){
        List<Group> queus= new List<Group>();
        try {
            queus = [SELECT Id, Name, Type, LastModifiedById, DeveloperName FROM Group where Type like 'Queue' and 
                     		(DeveloperName='Q281' or DeveloperName='Q285' 
                             or DeveloperName ='Q286' or DeveloperName='Q287')];
        } catch (Exception e) {
            System.debug('Gua_ManageUnitaAffariQuery getAccount error');
            System.debug('Gua_ManageUnitaAffariQuery getAccount '+ e.getMessage()+' '+ e.getLineNumber());
        }
        return queus;
    } 
	
    public static Account getFilialeById(String idFiliale){
        Account filiale = new Account();
        try {
            filiale= [SELECT Id,Telefono_Casa__c,PersonEmail, DataInizioAttivita__pc, Name,NameRoleReference__c,Phone, LastViewedDate FROM Account where id=:idFiliale];
        } catch (Exception e) {
            System.debug('error '+e.getMessage());
        }
        return filiale;
    }

    public static List<Case> getContactsCaseByQueue(Group grp,String pageSize, String pageNumber){
        Integer psize = Integer.valueOf(pageSize);
        Integer pnumber = Integer.valueOf(pageNumber)-1;
        List<Case> cntactsCase= new List<Case>();
        try {
            Id recordType=CGMWSUtils_1_0.getRecordTypeId('Case','GUA_Contact');
            Id recordTypeDealer=CGMWSUtils_1_0.getRecordTypeId('Account','Dealer');
            cntactsCase = [SELECT Id, CaseNumber, CampaignId__c, CampaignId__r.Name, CodiceDealer__c, Scadenza__c, Priority, Tentativo__c, Contact.Name, ContactId,LastModifiedDate ,
                           Account.RagioneSociale__pc,Account.Macroarea__c,Account.ProdottoDominanteMacroarea__c,Data_Creazione_Pratica__c,TipoChiamata__c,Partita_Iva__c,
                            Assegnatario__c, Assegnatario__r.Name, Status, Esito__c,UAF_DatiAggiuntiviFile__c, Account.Region_Name__c,Account.CodiceClienteFilled__c,Account.Address_Abbr_Sms__c,
                            Account.Telefono_Casa__c, Account.Telefono_Cellulare__c, Account.Phone , Account.PersonEmail, Account.Branch__r.Name, Account.Branch__r.Address_Abbr_Sms__c,Account.Branch__r.NameRoleReference__c,
                            Account.Branch__r.Phone, Account.LastViewedDate, Account.Branch__r.Telefono_Casa__c, Account.Branch__r.PersonEmail,Account.Branch__r.DataInizioAttivita__pc, CampaignId__r.UAF_DatiAggiuntivi__c 
                            FROM Case
                            where RecordTypeId=:recordType 
                            and Account.RecordTypeId=:recordTypeDealer
                            and CampaignId__c!=null
                            and OwnerId=:grp.Id  LIMIT :Integer.valueOf(psize) OFFSET :(psize*pnumber) ];
        } catch (Exception e) {
            System.debug('Gua_ManageUnitaAffariQuery getAccount error');
            System.debug('Gua_ManageUnitaAffariQuery getAccount '+ e.getMessage()+' '+ e.getLineNumber());
        }
        return cntactsCase;
    }
	
     public static List<Case> getLastContactCaseByQueue(Group grp,String pageSize){
        Integer psize = Integer.valueOf(pageSize);
        List<Case> cntactsCase= new List<Case>();
        try {
            Id recordType=CGMWSUtils_1_0.getRecordTypeId('Case','GUA_Contact');
            Id recordTypeDealer=CGMWSUtils_1_0.getRecordTypeId('Account','Dealer');
            cntactsCase = [SELECT Id, CaseNumber, CampaignId__c, CampaignId__r.Name, CodiceDealer__c, Scadenza__c, Priority, Tentativo__c, Contact.Name, ContactId,LastModifiedDate,
                           Account.RagioneSociale__pc,Account.Macroarea__c,Account.ProdottoDominanteMacroarea__c,Data_Creazione_Pratica__c,TipoChiamata__c,Partita_Iva__c,
                            Assegnatario__c, Assegnatario__r.Name, Status, Esito__c,UAF_DatiAggiuntiviFile__c, Account.Region_Name__c,Account.CodiceClienteFilled__c,Account.Address_Abbr_Sms__c,
                            Account.Telefono_Casa__c, Account.Telefono_Cellulare__c, Account.Phone , Account.PersonEmail, Account.Branch__r.Name, Account.Branch__r.Address_Abbr_Sms__c,Account.Branch__r.NameRoleReference__c,
                            Account.Branch__r.Phone, Account.LastViewedDate, Account.Branch__r.Telefono_Casa__c, Account.Branch__r.PersonEmail,Account.Branch__r.DataInizioAttivita__pc, CampaignId__r.UAF_DatiAggiuntivi__c 
                            FROM Case
                            where RecordTypeId=:recordType 
                            and Account.RecordTypeId=:recordTypeDealer
                            and CampaignId__c!=null
                            and OwnerId=:grp.Id  
                            order by CreatedDate desc LIMIT :Integer.valueOf(psize) ];
        } catch (Exception e) {
            System.debug('Gua_ManageUnitaAffariQuery getAccount error');
            System.debug('Gua_ManageUnitaAffariQuery getAccount '+ e.getMessage()+' '+ e.getLineNumber());
        }
        return cntactsCase;
    } 

    public static List<Case> filterCaseByCampagna(Group grp, String nameCampagna, String orderCriter){
        List<Case> cntactsCase= new List<Case>();
        System.debug('grp'+grp+'/'+nameCampagna+'/'+orderCriter);
        String val='';
        if(orderCriter=='Scadenza'){
            val = 'Scadenza__c';
        }else if(orderCriter=='Numero tentativi'){
            val = 'Tentativo__c';
        }else if(orderCriter=='Priorità'){
            val = 'Priority';
        }
        try {
            Id recordType=CGMWSUtils_1_0.getRecordTypeId('Case','GUA_Contact');
            Id recordTypeCamp=CGMWSUtils_1_0.getRecordTypeId('Campaign','GUA_Unita_Affari_Campagna');
            cntactsCase = [SELECT Id, CaseNumber, CampaignId__c, CampaignId__r.Name, CodiceDealer__c, Scadenza__c,Account.Branch__r.NameRoleReference__c,
                                    Priority, Tentativo__c, Contact.Name, ContactId,LastModifiedDate ,Assegnatario__c,
                                    Assegnatario__r.Name, Status, Esito__c, UAF_DatiAggiuntiviFile__c    FROM Case 
                                    where RecordTypeId=:recordType and CampaignId__r.RecordTypeId=:recordTypeCamp
                           			and CampaignId__c!=null and CampaignId__r.Name=:nameCampagna
                                    and OwnerId=:grp.Id ];
            System.debug('contactsCase'+cntactsCase);
        } catch (Exception e) {
            System.debug('Gua_ManageUnitaAffariQuery getAccount error');
            System.debug('Gua_ManageUnitaAffariQuery getAccount '+ e.getMessage()+' '+ e.getLineNumber());
        }
        return cntactsCase;
    }


    public static List<Case> filterCaseByCodiceOcsNome(String codiceOcs, String nome, String utenza ){
        List<Case> cntactsCase = new List<Case>();
        try{
            
            Id recordType=CGMWSUtils_1_0.getRecordTypeId('Case','GUA_Contact');
            Id recordTypeCamp=CGMWSUtils_1_0.getRecordTypeId('Campaign','GUA_Unita_Affari_Campagna');
             cntactsCase = [SELECT Id, CaseNumber, CampaignId__c, CampaignId__r.Name, CodiceDealer__c, Scadenza__c,
                                    Priority, SuppliedMobilePhone__c,
                                    SuppliedIdContract__c,Account.PersonEmail, Tentativo__c, Contact.Name, ContactId,LastModifiedDate ,
                                    Assegnatario__c, F_Indirizzo_Filiale__c,Account.RagioneSociale__pc,Account.Branch__r.NameRoleReference__c,
                                    Assegnatario__r.Name, Status, Esito__c, UAF_DatiAggiuntiviFile__c  , Account.LastViewedDate,
                                    Account.ProdottoDominanteMacroarea__c, Account.DealerPersonaRiferimento__c,
                                    Account.DealerPersonaRiferimentoCellulare__c, Account.DealerPersonaRiferimentoEmail__c,
                                    Account.DealerPersonaRiferimentoTelefono__c, Account.Macroarea__c, TipoChiamata__c
                                   
                                    FROM Case 
                                    where  RecordTypeId=:recordType  And CodiceDealer__c=:codiceOcs ];
                           			
                    
                                    //where (RecordTypeId=:recordType and CampaignId__r.RecordTypeId=:recordTypeCamp)
            System.debug('contactsCase'+cntactsCase);

        }
        catch(Exception e){
             System.debug('################### errorMessage '+e.getMessage());
             System.debug('################### errorMessage '+e.getStackTraceString() );
        }
        return cntactsCase;
    }
    
    public static List<Case>  filterCaseByCodiceOcsNome (String codiceOcs, String nome, String pageSize, String pageNumber){
                Integer psize = Integer.valueOf(pageSize);
                Integer pnumber = Integer.valueOf(pageNumber)-1;
                List<Case> cntactsCase = new List<Case>();
          try{
                Id recordType=CGMWSUtils_1_0.getRecordTypeId('Case','GUA_Contact');
                Id recordTypeCamp=CGMWSUtils_1_0.getRecordTypeId('Campaign','GUA_Unita_Affari_Campagna');
                cntactsCase = [SELECT Id, CaseNumber, CampaignId__c, CampaignId__r.Name, CodiceDealer__c, Scadenza__c,
                Priority, SuppliedMobilePhone__c, CampaignId__r.UAF_DatiAggiuntivi__c,Pratica_Codice_Attributo_PM__c,
                SuppliedIdContract__c, AccountId, Account.PersonEmail, Tentativo__c, Contact.Name, ContactId,LastModifiedDate ,
                Assegnatario__c, F_Indirizzo_Filiale__c, Account.RagioneSociale__pc,Account.Branch__r.NameRoleReference__c,
                Assegnatario__r.Name, Status, Esito__c, UAF_DatiAggiuntiviFile__c  , Stato_Pratica__c,Note__c, Account.LastViewedDate,
                Account.ProdottoDominanteMacroarea__c, Account.DealerPersonaRiferimento__c, Account.Region_Name__c,
                Account.DealerPersonaRiferimentoCellulare__c, Account.DealerPersonaRiferimentoEmail__c,
                Account.DealerPersonaRiferimentoTelefono__c, Account.Macroarea__c, TipoChiamata__c,
                Account.Fax, Account.Telefono_Cellulare__c, Account.Tipo_Intermediario__c, Account.Address_Abbr_Sms__c,
                Account.Branch__r.Name, Account.Branch__r.Address_Abbr_Sms__c,
                Account.Branch__r.Phone, Account.Branch__r.Telefono_Casa__c, Account.Branch__r.PersonEmail,Account.Branch__r.DataInizioAttivita__pc
                FROM Case 
                where RecordTypeId=:recordType AND (CodiceDealer__c=:codiceOcs OR DealerName__c =: nome) 
                LIMIT :Integer.valueOf(psize) OFFSET :(psize*pnumber) ];

          }
          catch(Exception e){
              System.debug('################ errorMessage '+e.getMessage());
              System.debug('################ errorMessage '+e.getStackTraceString() );
          }
          return cntactsCase;
    }

     public static List<Case>  filterCase (Group grp,String pageSize, String pageNumber, String elementFilter){
        Integer psize = Integer.valueOf(pageSize);
        Integer pnumber = Integer.valueOf(pageNumber)-1;
        List<Case> cntactsCase= new List<Case>();
        try {
            Id recordType=CGMWSUtils_1_0.getRecordTypeId('Case','GUA_Contact');
            Id recordTypeDealer=CGMWSUtils_1_0.getRecordTypeId('Account','Dealer');
            if (elementFilter=='Scadenza__c') {
                cntactsCase = [SELECT Id, CaseNumber, CampaignId__c, CampaignId__r.Name, CodiceDealer__c, Scadenza__c, Priority, Tentativo__c, Contact.Name, ContactId,LastModifiedDate ,
                           Account.RagioneSociale__pc,Account.Macroarea__c,Account.ProdottoDominanteMacroarea__c,Data_Creazione_Pratica__c,TipoChiamata__c,Partita_Iva__c,
                            Assegnatario__c, Assegnatario__r.Name, Status, Esito__c,UAF_DatiAggiuntiviFile__c, Account.Region_Name__c,Account.CodiceClienteFilled__c,Account.Address_Abbr_Sms__c,
                            Account.Telefono_Casa__c, Account.Telefono_Cellulare__c, Account.Phone , Account.PersonEmail, Account.Branch__r.Name, Account.Branch__r.Address_Abbr_Sms__c,Account.Branch__r.NameRoleReference__c,
                            Account.Branch__r.Phone, Account.LastViewedDate, Account.Branch__r.Telefono_Casa__c, Account.Branch__r.PersonEmail,Account.Branch__r.DataInizioAttivita__pc, CampaignId__r.UAF_DatiAggiuntivi__c 
                            FROM Case
                            where RecordTypeId=:recordType 
                            and Account.RecordTypeId=:recordTypeDealer
                            and CampaignId__c!=null
                            and OwnerId=:grp.Id order by Scadenza__c desc LIMIT :Integer.valueOf(psize) OFFSET :(psize*pnumber) ];
            }else if (elementFilter=='Tentativo__c'){
                cntactsCase = [SELECT Id, CaseNumber, CampaignId__c, CampaignId__r.Name, CodiceDealer__c, Scadenza__c, Priority, Tentativo__c, Contact.Name, ContactId,LastModifiedDate ,
                           Account.RagioneSociale__pc,Account.Macroarea__c,Account.ProdottoDominanteMacroarea__c,Data_Creazione_Pratica__c,TipoChiamata__c,Partita_Iva__c,
                            Assegnatario__c, Assegnatario__r.Name, Status, Esito__c,UAF_DatiAggiuntiviFile__c, Account.Region_Name__c,Account.CodiceClienteFilled__c,Account.Address_Abbr_Sms__c,
                            Account.Telefono_Casa__c, Account.Telefono_Cellulare__c, Account.Phone , Account.PersonEmail, Account.Branch__r.Name, Account.Branch__r.Address_Abbr_Sms__c,Account.Branch__r.NameRoleReference__c,
                            Account.Branch__r.Phone, Account.LastViewedDate, Account.Branch__r.Telefono_Casa__c, Account.Branch__r.PersonEmail,Account.Branch__r.DataInizioAttivita__pc, CampaignId__r.UAF_DatiAggiuntivi__c 
                            FROM Case
                            where RecordTypeId=:recordType 
                            and Account.RecordTypeId=:recordTypeDealer
                            and CampaignId__c!=null
                            and OwnerId=:grp.Id order by Tentativo__c desc LIMIT :Integer.valueOf(psize) OFFSET :(psize*pnumber) ];
            }else if (elementFilter=='Priority') {
                cntactsCase = [SELECT Id, CaseNumber, CampaignId__c, CampaignId__r.Name, CodiceDealer__c, Scadenza__c, Priority, Tentativo__c, Contact.Name, ContactId,LastModifiedDate ,
                           Account.RagioneSociale__pc,Account.Macroarea__c,Account.ProdottoDominanteMacroarea__c,Data_Creazione_Pratica__c,TipoChiamata__c,Partita_Iva__c,
                            Assegnatario__c, Assegnatario__r.Name, Status, Esito__c,UAF_DatiAggiuntiviFile__c, Account.Region_Name__c,Account.CodiceClienteFilled__c,Account.Address_Abbr_Sms__c,
                            Account.Telefono_Casa__c, Account.Telefono_Cellulare__c, Account.Phone , Account.PersonEmail, Account.Branch__r.Name, Account.Branch__r.Address_Abbr_Sms__c,Account.Branch__r.NameRoleReference__c,
                            Account.Branch__r.Phone, Account.LastViewedDate, Account.Branch__r.Telefono_Casa__c, Account.Branch__r.PersonEmail,Account.Branch__r.DataInizioAttivita__pc, CampaignId__r.UAF_DatiAggiuntivi__c 
                            FROM Case
                            where RecordTypeId=:recordType 
                            and Account.RecordTypeId=:recordTypeDealer
                            and CampaignId__c!=null
                            and OwnerId=:grp.Id order by Priority desc LIMIT :Integer.valueOf(psize) OFFSET :(psize*pnumber) ];
            }else {
                
            }
            
        } catch (Exception e) {
            System.debug('Gua_ManageUnitaAffariQuery getAccount error');
            System.debug('Gua_ManageUnitaAffariQuery getAccount '+ e.getMessage()+' '+ e.getLineNumber());
        }
        return cntactsCase;
    }
    
   public static List<Account> searchDealer(String codiceOcs, String nome, String pageSize, String pageNumber){
         System.debug('############# nome in query '+nome);
         Integer psize = Integer.valueOf(pageSize);
         Integer pnumber = Integer.valueOf(pageNumber)-1;
         List<Account> dealers = new List<Account>();
         try {
              Id recordType=CGMWSUtils_1_0.getRecordTypeId('Account','Dealer');
              Id recordTypeCase =CGMWSUtils_1_0.getRecordTypeId('Case','GUA_Contact');
             dealers = [SELECT Id, Name, LastName,FirstName, PersonEmail,DealerPersonaRiferimento__c, 
                                Region_Name__c,DealerPersonaRiferimentoCellulare__c,
                                DealerPersonaRiferimentoEmail__c,DealerPersonaRiferimentoTelefono__c,
                                Macroarea__c,Telefono_Cellulare__c,Fax, Status__c, Provincia_Nascita__pc,
                                (SELECT Id, Scadenza__c,  Priority, Tentativo__c, Contact.Name, UAF_DatiAggiuntiviFile__c,
                                 ContactId, LastModifiedDate ,Assegnatario__c,
                                Status, CampaignId__r.UAF_DatiAggiuntivi__c,Note__c,
                                Esito__c,Pratica_Codice_Attributo_PM__c,Stato_Pratica__c
                                FROM Cases WHERE RecordTypeId=:recordTypeCase LIMIT 1),
                                Tipo_Intermediario__c, Address_Abbr_Sms__c,Branch__c,
                                Branch__r.Name, Branch__r.Address_Abbr_Sms__c,
                                Branch__r.Phone, Branch__r.Telefono_Casa__c, Branch__r.PersonEmail,
                                Branch__r.DataInizioAttivita__pc, OCS_External_Id__c
                                FROM Account WHERE (Name =:nome OR OCS_External_Id__c =:codiceOcs) AND
                                RecordTypeId =: recordType  LIMIT :Integer.valueOf(psize) OFFSET :(psize*pnumber)] ;
            System.debug('############ query '+dealers[0].Cases[0].UAF_DatiAggiuntiviFile__c);
              
             
         } catch (Exception e) {
                 System.debug('################ errorMessage '+e.getMessage());
                 System.debug('################ errorMessage '+e.getStackTraceString()  );
         }
        return dealers;
    }



    public static Case getCase(String idCampagn){
        Case cntactsCase= new Case();
        try {
            Id recordType=CGMWSUtils_1_0.getRecordTypeId('Case','GUA_Contact');
            Id recordTypeDealer=CGMWSUtils_1_0.getRecordTypeId('Account','Dealer');
            //Id recordTypeCamp=CGMWSUtils_1_0.getRecordTypeId('Campaign','GUA_Unita_Affari_Campagna');
            cntactsCase = [SELECT Id, CaseNumber, CampaignId__c, CampaignId__r.Name, CodiceDealer__c,
                           Pratica_Codice_Attributo_PM__c, Contact.Name, ContactId,LastModifiedDate ,Assegnatario__c,UAF_DatiAggiuntiviFile__c ,
                           AccountId,Account.LastName,Account.Data_Depennamento__c , Assegnatario__r.Name, Status, Esito__c,
                           Account.Region_Name__c,Account.CodiceClienteFilled__c,Account.Address_Abbr_Sms__c,Account.Telefono_Casa__c,
                           Account.Telefono_Cellulare__c, Account.Phone , Account.PersonEmail, Account.Branch__r.Name, Account.Branch__r.Address_Abbr_Sms__c,
                           Account.Branch__r.Phone, Account.Branch__r.Telefono_Casa__c, Account.Branch__r.PersonEmail,Account.Branch__r.DataInizioAttivita__pc, CampaignId__r.UAF_DatiAggiuntivi__c 
                           FROM Case where RecordTypeId=:recordType
                                //and Account.RecordTypeId=:recordTypeDealer
                                and CampaignId__c=:idCampagn LIMIT 1];
        } catch (Exception e) {
            System.debug('Gua_ManageUnitaAffariQuery getAccount error');
            System.debug('Gua_ManageUnitaAffariQuery getAccount '+ e.getMessage()+' '+ e.getLineNumber());
        }
        return cntactsCase;
    }
     public static Case getCaseByIdCase(String idCase){
        Case cntactsCase= new Case();
        try {
            Id recordType=CGMWSUtils_1_0.getRecordTypeId('Case','GUA_Contact');
            Id recordTypeDealer=CGMWSUtils_1_0.getRecordTypeId('Account','Dealer');
            //Id recordTypeCamp=CGMWSUtils_1_0.getRecordTypeId('Campaign','GUA_Unita_Affari_Campagna');
            cntactsCase =  [SELECT Id, CaseNumber, CampaignId__c, CampaignId__r.Name, CodiceDealer__c,NumeroPratica__c,Codice_Cliente__c,
                           Pratica_Codice_Attributo_PM__c, Contact.Name, ContactId,Assegnatario__c,UAF_DatiAggiuntiviFile__c ,
                           Assegnatario__r.Name,Account.Region_Name__c,Account.CodiceClienteFilled__c,Account.Address_Abbr_Sms__c,CampaignId__r.UAF_DatiAggiuntivi__c,
                           Account.Telefono_Casa__c,Account.Telefono_Cellulare__c, Account.Phone , Account.PersonEmail, Account.Branch__r.Name,Account.Branch__r.Address_Abbr_Sms__c,Stato_Pratica__c,
                           Account.Branch__r.Phone, Account.Branch__c,Account.Branch__r.Telefono_Casa__c, Account.Branch__r.PersonEmail,Account.Branch__r.DataInizioAttivita__pc,OwnerId,Owner.Name
                                FROM Case where RecordTypeId=:recordType
                                //and Account.RecordTypeId=:recordTypeDealer
                                and Id=:idCase LIMIT 1];
        } catch (Exception e) {
            System.debug('Gua_ManageUnitaAffariQuery getAccount error');
            System.debug('Gua_ManageUnitaAffariQuery getAccount '+ e.getMessage()+' '+ e.getLineNumber());
        }
        return cntactsCase;
    }

    public static List<Account> getFiliales(String valueNameCF){
        valueNameCF = '%'+valueNameCF+'%';
        List<Account> filiales= [SELECT Id,Name, CittaSede__pc,getCodice_Cliente__c,Region_Name__c ,
                    			Sesso__pc,Provincia_Nascita__pc,Luogo_Nascita__pc,ShippingStreet,Address_Abbr_Sms__c,
                           		OCS_External_Id__c,  ShippingCity, BillingAddress, Phone, Fax, PersonEmail,
                                ShippingPostalCode, ShippingState, ShippingCountry, ShippingAddress, Branch__r.Name
                           		FROM Account WHERE RecordType.Name='Branch'
                                AND (Name LIKE :valueNameCF OR getCodice_Cliente__c LIKE :valueNameCF)];

                                System.debug('filiales ##############'+filiales);

        return filiales;

    }

    public static Case getDealerByCase(String idCase){
        Case dealerCase= new Case();
        try {
            Id recordType=CGMWSUtils_1_0.getRecordTypeId('Case','GUA_Contact');
            Id recordTypeDealer=CGMWSUtils_1_0.getRecordTypeId('Account','Dealer');
            dealerCase = [SELECT Id, CaseNumber, CampaignId__c, CampaignId__r.Name, CodiceDealer__c,NumeroPratica__c,Codice_Cliente__c,
                           Pratica_Codice_Attributo_PM__c, Contact.Name, ContactId,Assegnatario__c,UAF_DatiAggiuntiviFile__c ,
                           Assegnatario__r.Name,Account.Region_Name__c,Account.CodiceClienteFilled__c,Account.Address_Abbr_Sms__c,CampaignId__r.UAF_DatiAggiuntivi__c,
                           Account.Telefono_Casa__c,Account.Telefono_Cellulare__c, Account.Phone , Account.PersonEmail, Account.Branch__r.Name,Account.Branch__r.Address_Abbr_Sms__c,Stato_Pratica__c,
                           Account.Branch__r.Phone, Account.Branch__c,Account.Branch__r.Telefono_Casa__c, Account.Branch__r.PersonEmail,Account.Branch__r.DataInizioAttivita__pc,OwnerId,Owner.Name
                                FROM Case where RecordTypeId=:recordType and Account.RecordTypeId=:recordTypeDealer and Id=:idCase];
            System.debug('dealerCase '+dealerCase);
        } catch (Exception e) {
            System.debug('Gua_ManageUnitaAffariQuery getDealerByCase error');
            System.debug('Gua_ManageUnitaAffariQuery getDealerByCase '+ e.getMessage()+' '+ e.getLineNumber());
        }
        return dealerCase;
    }

    public static Case getFilaliByCase(String idCase){
        Case filialeCase= new Case();
        try {
            Id recordType=CGMWSUtils_1_0.getRecordTypeId('Case','GUA_Contact');
            Id recordTypeDealer=CGMWSUtils_1_0.getRecordTypeId('Account','Branch');
            filialeCase = [SELECT Id, CaseNumber, CampaignId__c, CampaignId__r.Name, CodiceDealer__c,NumeroPratica__c,
                           Pratica_Codice_Attributo_PM__c, Contact.Name, ContactId,Assegnatario__c,UAF_DatiAggiuntiviFile__c ,
                           Assegnatario__r.Name,Account.Region_Name__c,Account.CodiceClienteFilled__c,Account.Address_Abbr_Sms__c,
                           Account.Telefono_Casa__c,Account.Telefono_Cellulare__c, Account.Phone , Account.PersonEmail, Account.Branch__r.Name,Account.Branch__r.Address_Abbr_Sms__c,
                           Account.Branch__r.Phone, Account.Branch__r.Telefono_Casa__c, Account.Branch__r.PersonEmail,Account.Branch__r.DataInizioAttivita__pc,Stato_Pratica__c
                                FROM Case where RecordTypeId=:recordType and Account.RecordTypeId=:recordTypeDealer and Id=:idCase];
        } catch (Exception e) {
            System.debug('Gua_ManageUnitaAffariQuery getDealerByCase error');
            System.debug('Gua_ManageUnitaAffariQuery getDealerByCase '+ e.getMessage()+' '+ e.getLineNumber());
        }
        return filialeCase;
    }
    public static Account getDealerByCodiceOCS(String codiceOCS ){
        Account acc = new Account();
        try {
            acc = [SELECT Id, RagioneSociale__pc, OCS_External_Id__c,
                          Provincia_Nascita__pc, Macro_Area__c, Tipo_Intermediario__c, 
                          Macroarea__c, DealerPersonaRiferimento__c, DealerPersonaRiferimentoTelefono__c,
                          DealerPersonaRiferimentoEmail__c,  DealerPersonaRiferimentoCellulare__c, getCodice_Cliente__c,
                          Telefono_Cellulare__c, BusinessEmail__c, FirstName, LastName, Fax 
                          FROM Account WHERE OCS_External_Id__c =: codiceOCS AND RecordType.Name ='Dealer' ];
        } catch (Exception e) {
                System.debug('##################### errorMessage '+e.getMessage());
                System.debug('##################### errorMessage '+e.getStackTraceString() );
        }
        return acc;
    }

    /**--------------------------------------------------------------------------------------------------
      *@Author Madicke BALDE
      *@description get List case by codiceOCS
      *@param codiceOcs : Set of CodiceOcs
      *@param pageSize : 
      *@param pageNumber 
      *@return Case List
    
     *----------------------------------------------------------------------------------------------------*/
 
 public static List<Account> getCasesByCodiceOcs(Set<String> codiceOcs, String pageSize, String pageNumber){
          Integer psize = Integer.valueOf(pageSize);
         Integer pnumber = Integer.valueOf(pageNumber)-1;
         List<Account> dealers = new List<Account>();
         try {
              Id recordType=CGMWSUtils_1_0.getRecordTypeId('Account','Dealer');
              Id recordTypeCase =CGMWSUtils_1_0.getRecordTypeId('Case','GUA_Contact');
              dealers = [SELECT Id, Name, LastName,FirstName, PersonEmail,DealerPersonaRiferimento__c, 
                                Region_Name__c,DealerPersonaRiferimentoCellulare__c,
                                DealerPersonaRiferimentoEmail__c,DealerPersonaRiferimentoTelefono__c,
                                Macroarea__c,Telefono_Cellulare__c,Fax, Status__c, Provincia_Nascita__pc,
                                (SELECT Id, Scadenza__c,  Priority, Tentativo__c, Contact.Name, UAF_DatiAggiuntiviFile__c,
                                 ContactId, LastModifiedDate ,Assegnatario__c,
                                Status, CampaignId__r.UAF_DatiAggiuntivi__c,Note__c,
                                Esito__c,Pratica_Codice_Attributo_PM__c,Stato_Pratica__c
                                FROM Cases WHERE RecordTypeId=:recordTypeCase  ),
                                
                                Tipo_Intermediario__c,Address_Abbr_Sms__c,Branch__c,
                                Branch__r.Name, Branch__r.Address_Abbr_Sms__c,
                                Branch__r.Phone, Branch__r.Telefono_Casa__c, Branch__r.PersonEmail,
                                Branch__r.DataInizioAttivita__pc, OCS_External_Id__c
                                FROM Account WHERE  OCS_External_Id__c IN:codiceOcs AND
                                RecordTypeId =: recordType  LIMIT :Integer.valueOf(psize) OFFSET :(psize*pnumber)] ;
            System.debug('########### Query '+dealers);  
             
         } catch (Exception e) {
                 System.debug('################ errorMessage '+e.getMessage());
                 System.debug('################ errorMessage '+e.getStackTraceString()  );
         }
        return dealers;
    }
    
}