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
	
    public static List<Case> getContactsCaseByQueue(Group grp,String pageSize, String pageNumber){
        Integer psize = Integer.valueOf(pageSize);
        Integer pnumber = Integer.valueOf(pageNumber)-1;
        List<Case> cntactsCase= new List<Case>();
        try {
            Id recordType=CGMWSUtils_1_0.getRecordTypeId('Case','GUA_Contact');
            Id recordTypeDealer=CGMWSUtils_1_0.getRecordTypeId('Account','Dealer');
            cntactsCase = [SELECT Id, CaseNumber, CampaignId__c, CampaignId__r.Name, CodiceDealer__c, Scadenza__c, Priority, Tentativo__c, Contact.Name, ContactId,LastModifiedDate ,
                            Assegnatario__c, Assegnatario__r.Name, Status, Esito__c,UAF_DatiAggiuntiviFile__c, Account.Region_Name__c,Account.CodiceClienteFilled__c,Account.Address_Abbr_Sms__c,
                            Account.Telefono_Casa__c, Account.Telefono_Cellulare__c, Account.Phone , Account.PersonEmail, Account.Branch__r.Name, Account.Branch__r.Address_Abbr_Sms__c,
                            Account.Branch__r.Phone, Account.Branch__r.Telefono_Casa__c, Account.Branch__r.PersonEmail,Account.Branch__r.DataInizioAttivita__pc, CampaignId__r.UAF_DatiAggiuntivi__c 
                            FROM Case
                            /*where RecordTypeId=:recordType 
                            and Account.RecordTypeId=:recordTypeDealer
                            and CampaignId__c!=null*/
                            LIMIT :Integer.valueOf(psize) OFFSET :(psize*pnumber)
                            //and OwnerId=:grp.Id 
                                    ];
        } catch (Exception e) {
            System.debug('Gua_ManageUnitaAffariQuery getAccount error');
            System.debug('Gua_ManageUnitaAffariQuery getAccount '+ e.getMessage()+' '+ e.getLineNumber());
        }
        return cntactsCase;
    }
	
     public static List<Case> getLastContactCaseByQueue(Group grp,String pageSize){
        Integer psize = Integer.valueOf(pageSize);
        Integer pnumber = Integer.valueOf(pageNumber)-1;
        List<Case> cntactsCase= new List<Case>();
        try {
            Id recordType=CGMWSUtils_1_0.getRecordTypeId('Case','GUA_Contact');
            Id recordTypeDealer=CGMWSUtils_1_0.getRecordTypeId('Account','Dealer');
            cntactsCase = [SELECT Id, CaseNumber, CampaignId__c, CampaignId__r.Name, CodiceDealer__c, Scadenza__c, Priority, Tentativo__c, Contact.Name, ContactId,LastModifiedDate ,
                            Assegnatario__c, Assegnatario__r.Name, Status, Esito__c,UAF_DatiAggiuntiviFile__c, Account.Region_Name__c,Account.CodiceClienteFilled__c,Account.Address_Abbr_Sms__c,
                            Account.Telefono_Casa__c, Account.Telefono_Cellulare__c, Account.Phone , Account.PersonEmail, Account.Branch__r.Name, Account.Branch__r.Address_Abbr_Sms__c,
                            Account.Branch__r.Phone, Account.Branch__r.Telefono_Casa__c, Account.Branch__r.PersonEmail,Account.Branch__r.DataInizioAttivita__pc, CampaignId__r.UAF_DatiAggiuntivi__c 
                            FROM Case
                            /*where RecordTypeId=:recordType 
                            and Account.RecordTypeId=:recordTypeDealer
                            and CampaignId__c!=null*/
                            ORDER BY CreatedDate ASC LIMIT :Integer.valueOf(psize)
                            //and OwnerId=:grp.Id 
                                    ];
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
            cntactsCase = [SELECT Id, CaseNumber, CampaignId__c, CampaignId__r.Name, CodiceDealer__c, Scadenza__c,
                                    Priority, Tentativo__c, Contact.Name, ContactId,LastModifiedDate ,Assegnatario__c,
                                    Assegnatario__r.Name, Status, Esito__c, UAF_DatiAggiuntiviFile__c    FROM Case 
                                    where RecordTypeId=:recordType and CampaignId__r.RecordTypeId=:recordTypeCamp
                           			and CampaignId__c!=null and CampaignId__r.Name=:nameCampagna
                                    //and OwnerId=:grp.Id and RecordType.Name='GUA Contact'
                                    ];
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
                                    Assegnatario__c, F_Indirizzo_Filiale__c,Account.RagioneSociale__pc,
                                    Assegnatario__r.Name, Status, Esito__c, UAF_DatiAggiuntiviFile__c  ,
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
    
    public static List<Case>  filterCaseByCodiceOcsNome (String codiceOcs, String nome, String  utenza, String pageSize, String pageNumber){
                Integer psize = Integer.valueOf(pageSize);
                Integer pnumber = Integer.valueOf(pageNumber)-1;
                List<Case> cntactsCase = new List<Case>();
          try{
                Id recordType=CGMWSUtils_1_0.getRecordTypeId('Case','GUA_Contact');
                Id recordTypeCamp=CGMWSUtils_1_0.getRecordTypeId('Campaign','GUA_Unita_Affari_Campagna');
                cntactsCase = [SELECT Id, CaseNumber, CampaignId__c, CampaignId__r.Name, CodiceDealer__c, Scadenza__c,
                Priority, SuppliedMobilePhone__c,
                SuppliedIdContract__c,Account.PersonEmail, Tentativo__c, Contact.Name, ContactId,LastModifiedDate ,
                Assegnatario__c, F_Indirizzo_Filiale__c,Account.RagioneSociale__pc,
                Assegnatario__r.Name, Status, Esito__c, UAF_DatiAggiuntiviFile__c  ,
                Account.ProdottoDominanteMacroarea__c, Account.DealerPersonaRiferimento__c,
                Account.DealerPersonaRiferimentoCellulare__c, Account.DealerPersonaRiferimentoEmail__c,
                Account.DealerPersonaRiferimentoTelefono__c, Account.Macroarea__c, TipoChiamata__c
                FROM Case 
                where  RecordTypeId=:recordType  And CodiceDealer__c=:codiceOcs
                LIMIT :Integer.valueOf(psize) OFFSET :(psize*pnumber) ];

          }
          catch(Exception e){
              System.debug('################ errorMessage '+e.getMessage());
              System.debug('################ errorMessage '+e.getStackTraceString() );
          }
          return cntactsCase;
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
            dealerCase = [SELECT Id, CaseNumber, CampaignId__c, CampaignId__r.Name, CodiceDealer__c,
                           Pratica_Codice_Attributo_PM__c, Contact.Name, ContactId,Assegnatario__c,UAF_DatiAggiuntiviFile__c ,
                           Assegnatario__r.Name,Account.Region_Name__c,Account.CodiceClienteFilled__c,Account.Address_Abbr_Sms__c,
                           Account.Telefono_Casa__c,Account.Telefono_Cellulare__c, Account.Phone , Account.PersonEmail, Branch__r.Name,Branch__r.Address_Abbr_Sms__c,
                           Branch__r.Phone, Branch__r.Telefono_Casa__c, Branch__r.PersonEmail,Branch__r.DataInizioAttivita__pc
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
            filialeCase = [SELECT Id, CaseNumber, CampaignId__c, CampaignId__r.Name, CodiceDealer__c,
                           Pratica_Codice_Attributo_PM__c, Contact.Name, ContactId,LastModifiedDate ,Assegnatario__c,UAF_DatiAggiuntiviFile__c ,
                           Account.Data_Depennamento__c , Assegnatario__r.Name, Status, Esito__c,
                           Account.Region_Name__c,Account.CodiceClienteFilled__c,Account.Address_Abbr_Sms__c,Account.Telefono_Casa__c,
                           Account.Telefono_Cellulare__c, Account.Phone , Account.PersonEmail, Branch__r.Name,Branch__r.Address_Abbr_Sms__c,
                           Branch__r.Phone, Branch__r.Telefono_Casa__c, Branch__r.PersonEmail,Branch__r.DataInizioAttivita__pc
                                FROM Case where RecordTypeId=:recordType and Branch__r.RecordTypeId=:recordTypeDealer and Id=:idCase];
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
    
}