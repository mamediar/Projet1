public class CRMRetentionUtil 
{
    
    //CASE
    public static FINAL String CASE_ACTIVITY_OUTBOUND_RETENTION = 'Outbound Calling Retention';
    public static FINAL String CASERETENTIONCARTESUBJECT = 'Retention Carte';
    public static FINAL String CASE_RETENTION_PRESTITI_BAD_SUBJECT = 'E/A x Retention BAD';
    public static FINAL String CASE_RETENTION_PRESTITI_SUBJECT = 'E/A x Retention';
    public static FINAL String CASERETENTIONCARTEPROCESSTYPEINBOUND = 'RetentionCarte_Inbound';
    public static FINAL String CASERETENTIONCARTEPROCESSTYPEOUTBOUND = 'RetentionCarte_Outbound';
    public static FINAL String CASE_RETENTION_PRESTITI_PROCESSTYPE_RETENTIONOK = 'RetentionPrestiti_RetentionOK';
    public static FINAL String CASE_RETENTION_PRESTITI_PROCESSTYPE_RETENTIONBAD = 'RetentionPrestiti_RetentionBAD';
    public static FINAL String CASE_RETENTION_PRESTITI_PROCESSTYPE_RETENTIONTF = 'RetentionPrestiti_RetentionTaskForce';
    public static FINAL String CASE_RETENTION_PRESTITI_PROCESSTYPE_RETENTIONTFAPT = 'RetentionPrestiti_RetentionTF_APT';
   
    public static FINAL STRING CASERETENTIONCARTECLOSESTATUS = 'Closed';
    
    //CRM_Retention
    public static FINAL String RETENTIONTYPEREQUESTED = 'Requested';
    public static FINAL String RETENTION_TYPE_TO_CREATE = 'ToCreate';
    
    //Queue DeveloperName
    public static FINAL String QUEUERETENTIONCARTENAME = 'Q141';
    public static FINAL String QUEUE_RETENTION_EA_NAME = 'Q18';
    public static FINAL String QUEUE_RETENTION_EA_BAD_NAME = 'Q385';
    public static FINAL String QUEUE_RECALL_APPUNTAMENTI_TF_NAME = 'Q369';
    public static FINAL String QUEUE_RECALL_RETENTION_TF_NAME = 'Q368';
    public static FINAL String QUEUE_PV_RETENTION_EA_CUSTOMER_SERVICE_NAME = 'Q297';
    
    //Note
    public static FINAL String NOTE_RETENTION_PRESTITI_PREWORK = 'NOTE.RetentionPrestitiPrework';
    public static FINAL String NOTE_RETENTION_PRESTITI_RICHIESTA_CRM= 'NOTE.RetentionEARichiestaCRM';
    public static FINAL String NOTE_RETENTION_FISSA_APPUNTAMENTO = 'NOTE.RetentionFissaAppuntamento';
    public static FINAL String NOTE_UFFICIO_HEADER = 'NOTE.UfficioHeader';
    public static FINAL String NOTE_PRATICA_ESITO = 'NOTE.PraticaEsito';
    public static FINAL String NOTE_TICKETING_BORG = 'NOTE.TicketingBorg';
        
    //Email Template
    public static FINAL String EMAIL_RETENTION_FISSA_APPUNTAMENTO_FILIALE = 'Email.RetentionFissaAppuntamentoFiliale';
    
    //Query
    public static FINAL String QUERY_CASE_PROCESSTYPE = 'id,ProcessType__c';
    public static FINAL String QUERY_CASE_ACCOUNTCODE = 'id,ProcessType__c,CaseNumber,AccountId,Account.getCodice_Cliente__c';
    
    //Retention Campi Tecnici
    public static FINAL String REVOCATO = 'REV';
    public static FINAL String TRATTENUTO = 'PRD';
    public static FINAL String TRATTENUTOTESTO = 'NO - Trattenuto con cambio prodotto';
    public static FINAL String MESSAGGIOERRORE = 'Azione Rev non rilevata';
    public static FINAL String MESSAGGIO_ERRORE_PRD = 'Azione PRD non rilevata';
    public static FINAL String MESSAGGIOERROREDISCREPANZA = 'Azione Evo Non Combacia';
    public static FINAL String COD_PRODOTTO_PP = 'PP';
    public static FINAL String COD_PRODOTTO_PE = 'PE';
    public static FINAL MAP<String,String> MAP_ESITO_DESCRIPTION = new Map<String, String>{'ALL' => 'Upselling o rinegoziazione', 'RIN' => 'Rinegoziazione', 'UPS' => 'Upselling','CON' => 'Consigliare a parole','BAD' => 'Cliente da trattenere BAD','GIO' => 'Prestito recente, consigliare' ,'ESP' => 'Troppo esposto, poco margine'};
    
    public static FINAL List<String> ACTIONKO = new List<String>{'KO',''};
    public static FINAL List<String> ACTIONOK = new List<String>{'OK','CON'};
    
    //Messaggi Errore
    public static FINAL String TELEFONONONCONFORME = '- Telefono non conforme\n';
    public static FINAL String EMAILNONCONFORME = '- Email non conforme\n';
    public static FINAL String FASCIANONSELEZIONATA = '- Selezionare una fascia oraria di contatto\n';
    public static FINAL String DISPOSITION_NON_VALORIZZATE = '- Esiti non valorizzati\n';
    public static FINAL String PRATICHE_NON_ESITATE = '- Inserire l’esito per tutte le pratiche';
    public static FINAL String NON_ESITATO = 'Esito non valorizzato';
    public static FINAL String SELEZIONARE_PRATICA = 'Selezionare una pratica';
    public static FINAL String INFORMAZIONI_MANCANTI = 'per questo cliente non sono presenti informazioni sulla retention.\nCliente da NON trattenere. Fornire conteggio estinzione';
    public static FINAL String SOLO_CONTRATTI_ATTIVI = 'Il cliente ha solo contratti stipulati con partner, dunque non è possibile procedere. Fornire conteggio estinzione';
    public static FINAL String CONTRATTI_ATTIVI = 'Il cliente ha contratti attivi con Partner. Verificare se la pratica oggetto di estinzione è tra questi.';
    public static FINAL String PRATICA_PARTNER = 'La pratica selezionata è stata stipulata da un partner, dunque non è possibile procedere. fornire conteggio estinzione';
    public static FINAL String NESSUNA_PRATICA_TROVATA = '- Nessuna Pratica Trovata. Impossibile inserire la richiesta di retention. Se si è sicuri che il cliente abbia pratiche, scrivere a crm@compass.it';
    
    public static CRM_Retention__c getFirstRetention(String caseId,List<String> actionList)
    {
        return [Select id,LastModifiedDate,disposition__c from CRM_Retention__c where Type__c = :RETENTIONTYPEREQUESTED AND (Action__c IN :actionList) AND Selected__c = true AND Case__c = :caseId order by LastModifiedDate asc][0];
    }
    
    public static map<String,CRM_Retention__c> getLoanNumberSObjectMapByList(List<CRM_Retention__c> listRetention)
    {
        MAP<String,CRM_Retention__c> retentionMap = new MAP<String,CRM_Retention__c>();
        for(CRM_Retention__c ret :listRetention )
        {
            retentionMap.put(ret.loanNumber__c,ret);
        }
        return retentionMap;
    }

    public static OCSRecuperaStatoRichiestePSVResponse.ResponseClass getLastValueOfPSVService(String pratica,String tipoPratica)
    {
    	OCSRecuperaStatoRichiestePSVResponse res = OCSRecuperaStatoRichiestePSVInvoker.Invoke(tipoPratica, pratica, '', dateTime.now().format('yyyyMMdd'));
        OCSRecuperaStatoRichiestePSVResponse.ResponseClass r = (res.recuperaStatoRichiestePSVResponse.elencoStatiRichieste.size() > 0 ? res.recuperaStatoRichiestePSVResponse.elencoStatiRichieste.get(res.recuperaStatoRichiestePSVResponse.elencoStatiRichieste.size() - 1) : null);
        return r;
    }
    
    public static List<CRM_Retention__c> getRetentionRequestedByCaseId(String caseId)
    {
        return [SELECT Id, FirstDueDate__c, FinancedAmount__c, ExtinctionDate__c, Disposition__c, Customer__c,Customer__r.getCodice_Cliente__c, CreatedDate, Case__c, Branch__c, Balance__c, Disposition__r.visibility__c,Disposition__r.Name,Action__c, LastDueDate__c, LiquidDate__c, LoanNumber__c, LoanStatusAttribute__c, LoanStatus__c, LoanType__c, ProductCode__c, RepaymentMode__c, ProductDescription__c, RetentionValue__c, Selected__c, Source__c, TotalAmount__c, Type__c, Utente__c, LastModifiedDate FROM CRM_Retention__c where case__c = :caseId AND Type__c = :RETENTIONTYPEREQUESTED];
    }
    
    public static void saveRetentionWithDisposition(CRM_Retention__c retention,XCS_Disposition__c disposition)
    {
        CRM_Retention__c thisRetention = new CRM_Retention__c(id=retention.Id,disposition__c = disposition.Id,Selected__c = retention.Selected__c);
        Update thisRetention;
    }
    public static List<CRM_Retention__c> getRetentionToCreateNotUsed()
    {
        return [SELECT Id, LoanNumber__c, Customer__c, Type__c, Selected__c, Branch__c,Branch__r.OCS_External_Id__c FROM CRM_Retention__c Where Type__c = :RETENTION_TYPE_TO_CREATE AND Selected__c = false];
    }
}