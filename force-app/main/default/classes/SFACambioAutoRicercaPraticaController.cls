public class SFACambioAutoRicercaPraticaController {

    private static final String SFA = 'SFA';
    private static final String CRM = 'CRM';
    private static final String FIL = 'FIL';
    private static final String GDV = 'GDV';
    private static final String AV = 'AV';
    private static final String COORD = 'COORD';
    private static final String FIL_PROFILE = 'Branch Employee';
    private static final String GDV_PROFILE = 'Direttore Rete';
    private static final String AV_PROFILE = 'DCR/AV';
    private static final String COORD_PROFILE = 'Area Manager';
    private static final String SFA_CAMAUT = 'SFA_CAMAUT';
    //private static final String SFA_CAMAUT_ATTIVITA = 'SFA_CAMAUT_ATTIVITA';
    private static final String SFA_CAMAUT_NOTIFICHE = 'SFA_CAMAUT_NOTIFICHE';

    @AuraEnabled
    public static DatiPratica getPratica(String caseId) {

        Case attivita = [SELECT Id, ActivityType__c, NumeroPratica__c, Status, Esito__c FROM Case WHERE Id = :caseId][0];

        String numeroPratica = attivita.NumeroPratica__c;
        String caseStatus = attivita.Status;
        String esitoDiProvenienza = attivita.Esito__c;

        DatiPratica pratica;

        if (numeroPratica != null && numeroPratica != '') {
        
            SFAPraticaCambioAuto__c praticaDB = 
            [SELECT Id, Name, IdAttivita__c, CodOutcome__c, NumeroPratica__c, Targa__c, Telaio__c, Modello__c, AnnoImmatricolazione__c, MeseImmatricolazione__c, Valore__c, ImportoStorno__c, TargaOcs__c, TelaioOcs__c, DataLiquidazione__c, BeneOcs__c, ValoreOcs__c, ProdottoOcs__c, DataImmatricolazione__c, ClienteOcs__c, Dealer__c, DealerOcsExternalId__c, Lloyd__c,   ModelloOcs__c
            FROM SFAPraticaCambioAuto__c
            WHERE NumeroPratica__c = :numeroPratica][0];

            pratica = new DatiPratica();

            pratica.caseStatus = caseStatus;
            pratica.esitoDiProvenienza = esitoDiProvenienza;

            pratica.numeroPratica = praticaDB.NumeroPratica__c;
            pratica.codiceEsitoDiProvenienza = praticaDB.CodOutcome__c;
                
            pratica.dataLiquidazione = praticaDB.DataLiquidazione__c;
            pratica.isDataLiquidazioneRed = calcolaIsDataLiquidazioneRed(praticaDB.DataLiquidazione__c);
            pratica.assicurazione = praticaDB.Lloyd__c;
            pratica.isAssicurazioneRed = praticaDB.Lloyd__c != null && (praticaDB.Lloyd__c.substring(0, 1)).equals('S') ? true : false;
            pratica.cliente = praticaDB.ClienteOcs__c;
            pratica.targa = praticaDB.TargaOcs__c;
            pratica.telaio = praticaDB.TelaioOcs__c;
            pratica.prodotto = praticaDB.ProdottoOcs__c;
            pratica.descrizioneBene = praticaDB.BeneOcs__c;
            pratica.modello = praticaDB.ModelloOcs__c;
            pratica.valore = praticaDB.ValoreOcs__c;
            pratica.dataImmatricolazione = praticaDB.DataImmatricolazione__c;

            pratica.targaNew = praticaDB.Targa__c;
            pratica.telaioNew = praticaDB.Telaio__c;
            pratica.annoImmatricolazioneNew = praticaDB.AnnoImmatricolazione__c;
            pratica.meseImmatricolazioneNew = praticaDB.MeseImmatricolazione__c;
            pratica.modelloNew = praticaDB.Modello__c;
            pratica.valoreNew = praticaDB.Valore__c;
            pratica.importoStorno = praticaDB.ImportoStorno__c;
            
        }
                                                                                                            
        return pratica;

    }

    @AuraEnabled
    public static List<SelectOption> getEsiti(String caseId) {

        String numeroPratica = [SELECT Id, ActivityType__c, NumeroPratica__c FROM Case WHERE Id = :caseId][0].NumeroPratica__c;

        List<SelectOption> lstSelectOption = new List<SelectOption>();

        SelectOption selectOption = new SelectOption('Seleziona l\'esito', '', 'true');
        lstSelectOption.add(selectOption);

        if (numeroPratica != null && numeroPratica != '') {

            String userId = UserInfo.getUserId();
            String currentProfileId = [SELECT Id, profileId FROM User WHERE Id = :userId][0].profileId;
            String currentProfileName = [SELECT Id, Name FROM Profile WHERE Id = :currentProfileId][0].Name;
            System.debug('*** currentProfileName :: ' + currentProfileName);
            
            String codiceEsitoDiProvenienza = [SELECT Id, CodOutcome__c FROM SFAPraticaCambioAuto__c WHERE NumeroPratica__c = :numeroPratica][0].CodOutcome__c;

            System.debug('*** codiceEsitoDiProvenienza :: ' + codiceEsitoDiProvenienza);

            List<SFA_CambioAuto_EsitiConfig__c> lstSCAEC = [SELECT Id, CodNextOutcome__c, CodNextOutcomeLabel__c 
                                                            FROM SFA_CambioAuto_EsitiConfig__c 
                                                            WHERE ActorProfileName__c = :currentProfileName AND CodOutcome__c = :codiceEsitoDiProvenienza];
            
            System.debug('*** lstSCAEC :: ' + JSON.serialize(lstSCAEC));
            
            for (SFA_CambioAuto_EsitiConfig__c scaec : lstSCAEC) {
                SelectOption so = new SelectOption(scaec.CodNextOutcomeLabel__c, scaec.CodNextOutcome__c, 'false');
                lstSelectOption.add(so);
            }
        }

        /*else {
            SelectOption so = new SelectOption('Inoltra Richiesta', 'SEND', 'false');
            lstSelectOption.add(so);
        }*/
                                                                                                            
        return lstSelectOption;
    }

	@AuraEnabled  
    public static DatiPratica recuperaPratica(String numeroPratica, String caseId){
        
        OCS_recuperaInfoPraticaResponse response = OCS_recuperaInfoPraticaInvoker.callAggiornaDati(numeroPratica);
        
        DatiPratica pratica;
        
        if (response.isOK()) {
            String assicurazione = recuperaPacchettiAssicurativi(numeroPratica, caseId);
            pratica = new DatiPratica();
            pratica.dataLiquidazione = response.recuperaInfoPraticaResponse.dataLiquidazione;
            pratica.isDataLiquidazioneRed = calcolaIsDataLiquidazioneRed(response.recuperaInfoPraticaResponse.dataLiquidazione);
            pratica.assicurazione = assicurazione != null ? assicurazione : 'Errore nel recupero dei pacchetti assicurativi';
            pratica.isAssicurazioneRed = assicurazione != null && (assicurazione.substring(0, 1)).equals('S') ? true : false;
            pratica.cliente = response.recuperaInfoPraticaResponse.ragioneSociale;
            pratica.targa = response.recuperaInfoPraticaResponse.targa;
            pratica.telaio = response.recuperaInfoPraticaResponse.telaio;
            pratica.prodotto = response.recuperaInfoPraticaResponse.prodotto;
            pratica.descrizioneBene = response.recuperaInfoPraticaResponse.descrizioneBene;
            pratica.modello = response.recuperaInfoPraticaResponse.marcaModello;
            pratica.valore = response.recuperaInfoPraticaResponse.valoreBene;
            pratica.dataImmatricolazione = response.recuperaInfoPraticaResponse.annoMeseImmatricolazione;

            pratica.codiceEsitoDiProvenienza = 'SEND';

            SFAPraticaCambioAuto__c praticaDB = 
                [SELECT Id, DataLiquidazione__c, Lloyd__c, ClienteOcs__c, TargaOcs__c, TelaioOcs__c, ProdottoOcs__c, BeneOcs__c, ModelloOcs__c, ValoreOcs__c, DataImmatricolazione__c
                 FROM SFAPraticaCambioAuto__c 
                 WHERE NumeroPratica__c = :numeroPratica][0];

            Case c = [SELECT Id, NumeroPratica__c, AccountId FROM Case WHERE Id = :caseId][0];

            String dealerId = c.AccountId;

            Account dealer = [SELECT Id, Name, OCS_External_Id__c FROM Account WHERE Id = :dealerId][0];

            praticaDB.Dealer__c = dealer.Name;
            praticaDB.DealerOcsExternalId__c = dealer.OCS_External_Id__c;

            praticaDB.CodOutcome__c = pratica.codiceEsitoDiProvenienza;

            praticaDB.DataLiquidazione__c = pratica.dataLiquidazione;
            praticaDB.Lloyd__c = pratica.assicurazione;
            praticaDB.ClienteOcs__c = pratica.cliente;
            praticaDB.TargaOcs__c = pratica.targa;
            praticaDB.TelaioOcs__c = pratica.telaio;
            praticaDB.ProdottoOcs__c = pratica.prodotto;
            praticaDB.BeneOcs__c = pratica.descrizioneBene;
            praticaDB.ModelloOcs__c = pratica.modello;
            praticaDB.ValoreOcs__c = pratica.valore;
            praticaDB.DataImmatricolazione__c = pratica.dataImmatricolazione;

            update praticaDB;

            //c.SFAPraticaCambioAuto__c = praticaDB.Id;
            c.NumeroPratica__c = numeroPratica;
            update c;

        }
        
        return pratica;
    }

    @AuraEnabled  
    public static String recuperaPacchettiAssicurativi(String numeroPratica, String caseId){
        OCSRecuperaPacchettiServiziResponse response = OCSRecuperaPacchettiServiziInvoker.callRecPacchServ('CO', numeroPratica);
        
        if (response.isOK()) {

            List<OCSRecuperaPacchettiServiziResponse.PacchettoServizioDTO> lstPacchettoServizioDTO = response.recuperaPacchettiServiziResponse.elencoPacchettiServizi;

            SFAPraticaCambioAuto__c pratica = new SFAPraticaCambioAuto__c();
            pratica.NumeroPratica__c = numeroPratica;
            pratica.IdAttivita__c = caseId;

            // Estrae i pacchetti assicurativi e li salva a DB: questi pacchetti non saranno mostrati a FE
            String codServizio;
            String pacchettiAssicurativiOcs = '';
            for (Integer i = 0; i < lstPacchettoServizioDTO.size(); i++) {
                codServizio = lstPacchettoServizioDTO[i].codServizio;
                if (!pacchettiAssicurativiOcs.equals('')) {
                    pacchettiAssicurativiOcs += ',';
                }
                pacchettiAssicurativiOcs += codServizio;
            }

            pratica.PacchettiAssicurativiOcs__c = pacchettiAssicurativiOcs;

            insert pratica;

            String flagPacchettoAssicurativoDaEscludere = checkPacchettiAssicurativiDaEscludere(lstPacchettoServizioDTO);

            return flagPacchettoAssicurativoDaEscludere;
        }
        else {
            return null;
        }        
    }
    
    @AuraEnabled  
    public static String checkPacchettiAssicurativiDaEscludere(List<OCSRecuperaPacchettiServiziResponse.PacchettoServizioDTO> elencoPacchetti) {

        String flag_assic = 'N';
        String pacc_assic = '';
        String sCodServizio;
        Date today_date = Date.today();
        
        List<PacchettiAssicurativiDaEscludere__mdt> lstPacchettoAssicurativoDaEscludere = [SELECT Id, MacroType__c FROM PacchettiAssicurativiDaEscludere__mdt ORDER BY MacroType__c ASC];

        List<String> lstMacroTypePacchettoAssicurativoDaEscludere = new List<String>();
        Set<String> setMacroTypePacchettoAssicurativoDaEscludere = new Set<String>();

        for (PacchettiAssicurativiDaEscludere__mdt pade : lstPacchettoAssicurativoDaEscludere) {
            setMacroTypePacchettoAssicurativoDaEscludere.add(pade.MacroType__c);
        }

        lstMacroTypePacchettoAssicurativoDaEscludere.addAll(setMacroTypePacchettoAssicurativoDaEscludere); 

        for (Integer i = 0; i < elencoPacchetti.size(); i++) {
            sCodServizio = elencoPacchetti[i].codServizio;
            Date dataFineCopertura;
            Date dataInizioCopertura;
            if (elencoPacchetti[i].dataFineCopertura != null && elencoPacchetti[i].dataFineCopertura.length() == 8) {
                String strDataFineCopertura = elencoPacchetti[i].dataFineCopertura;
                Integer annoFineCopertura = Integer.valueOf(strDataFineCopertura.substring(0, 4));
                Integer meseFineCopertura = Integer.valueOf(strDataFineCopertura.substring(4, 6));      
                Integer giornoFineCopertura = Integer.valueOf(strDataFineCopertura.substring(6, 8));
                dataFineCopertura = Date.newInstance(annoFineCopertura, meseFineCopertura, giornoFineCopertura);
            }
            if (elencoPacchetti[i].dataInizioCopertura != null && elencoPacchetti[i].dataInizioCopertura.length() == 8) {
                String strDataInizioCopertura = elencoPacchetti[i].dataInizioCopertura;
                Integer annoInizioCopertura = Integer.valueOf(strDataInizioCopertura.substring(0, 4));
                Integer meseInizioCopertura = Integer.valueOf(strDataInizioCopertura.substring(4, 6));      
                Integer giornoInizioCopertura = Integer.valueOf(strDataInizioCopertura.substring(6, 8));
                dataInizioCopertura = Date.newInstance(annoInizioCopertura, meseInizioCopertura, giornoInizioCopertura);
            }
            if ((dataInizioCopertura <= today_date) && (dataFineCopertura >= today_date)) {
                if (!pacc_assic.equals('')) {
                    pacc_assic += ',';
                }
                pacc_assic += sCodServizio;
            }
        }

        if (!pacc_assic.equals('')) {
            String macro_type = '';
            String[] strut = pacc_assic.split(',');
            for (Integer j = 0; j < strut.size(); j++) {
                macro_type = strut[j].substring(0, 3);
                if (lstMacroTypePacchettoAssicurativoDaEscludere.contains(macro_type)) {
                    flag_assic = 'S (' + pacc_assic + ')';
                    return flag_assic;
                }
            }
        }

        return flag_assic;
    }

    @AuraEnabled
    public static Boolean calcolaIsDataLiquidazioneRed(String strDataLiquidazione) {

        if (strDataLiquidazione != null && strDataLiquidazione.length() == 8) {

            Integer annoLiquidazione = Integer.valueOf(strDataLiquidazione.substring(0, 4));
            Integer meseLiquidazione = Integer.valueOf(strDataLiquidazione.substring(4, 6));      
            Integer giornoLiquidazione = Integer.valueOf(strDataLiquidazione.substring(6, 8));
            
            Date dataLiquidazione = Date.newInstance(annoLiquidazione, meseLiquidazione, giornoLiquidazione);
            Date today = Date.today();

            if (dataLiquidazione.addMonths(4) <= today) 
                return true;
            else
                return false;
        }
        else {
            return false;
        }
    }

    @AuraEnabled
    public static Boolean checkDoppiaAttivita(String numeroPratica, String caseId) {
        List<Case> lstAttivitaCAMAUTinCorso = [SELECT Id, NumeroPratica__c FROM Case WHERE Status != 'Closed' AND ActivityType__c = 'SFA_CAMAUT' AND NumeroPratica__c = :numeroPratica];
        //System.debug('*** numeroPratica :: ' + numeroPratica);
        //System.debug('*** caseId :: ' + caseId);
        System.debug('*** lstAttivitaCAMAUTinCorso :: ' + JSON.serialize(lstAttivitaCAMAUTinCorso));
        if (lstAttivitaCAMAUTinCorso.size() >= 2) {
            System.debug('*** doppia attivita!');
            chiudiAttivita(caseId, 'ATTIVO');
            return true;
        }
        else {
            return false;
        }
    }
    
    @AuraEnabled
    public static void chiudiAttivita(String caseId, String esito) {
        Case attivita = [SELECT Id, NumeroPratica__c, Status, Esito__c FROM Case WHERE Id = :caseId][0];
        attivita.status = 'Closed';
        attivita.Esito__c = esito;
        update attivita;
    }

    /*@AuraEnabled
    public static String creaTicket(String numeroPratica, String activityType) {

        SFAPraticaCambioAuto__c pratica = [SELECT Id, IdTicket__c, ClienteOcs__c, Dealer__c, DealerOcsExternalId__c FROM SFAPraticaCambioAuto__c WHERE NumeroPratica__c = :numeroPratica][0];

        Case ticket = new Case();

        ticket.ActivityType__c = activityType;
        ticket.NumeroPratica__c = numeroPratica;
        ticket.SFAPraticaCambioAuto__c = pratica.Id;
        ticket.Subject = 'Cambio veicolo. PRATICA  : '+numeroPratica+' - CLIENTE : '+pratica.ClienteOcs__c+' -  DEALER : '+pratica.Dealer__c+' '+pratica.DealerOcsExternalId__c+' : Inoltrata';
        insert ticket;

        pratica.idTicket__c = ticket.Id;
        update pratica;

        return ticket.Id;
    }*/

    @AuraEnabled
    public static String creaTicketNotifica(String numeroPratica, String activityType, String codiceEsitoSuccessivo) {

        SFAPraticaCambioAuto__c pratica = [SELECT Id, ClienteOcs__c, Dealer__c, DealerOcsExternalId__c FROM SFAPraticaCambioAuto__c WHERE NumeroPratica__c = :numeroPratica][0];

        String titolo;

        if (codiceEsitoSuccessivo == 'STOP_COORD')
            titolo = 'Cambio veicolo. PRATICA  : '+numeroPratica+' - CLIENTE : '+pratica.ClienteOcs__c+' -  DEALER : '+pratica.Dealer__c+' '+pratica.DealerOcsExternalId__c+' : Richiesta respinta dal coordinatore';
        else if (codiceEsitoSuccessivo == 'KO_GDVCA')
            titolo = 'Cambio veicolo. PRATICA  : '+numeroPratica+' - CLIENTE : '+pratica.ClienteOcs__c+' -  DEALER : '+pratica.Dealer__c+' '+pratica.DealerOcsExternalId__c+' : Richiesta fuori procedura';
        else if (codiceEsitoSuccessivo == 'GIA_FATTO')
            titolo = 'Cambio veicolo. PRATICA  : '+numeroPratica+' - CLIENTE : '+pratica.ClienteOcs__c+' -  DEALER : '+pratica.Dealer__c+' '+pratica.DealerOcsExternalId__c+' : Cambio auto già fatto';
        
        //OK_GDVCA_STORNO non esiste come codice esito ma solo come template email
        else if (codiceEsitoSuccessivo == 'OK_GDVCA_STORNO')
            titolo = 'Cambio veicolo. PRATICA  : '+numeroPratica+' - CLIENTE : '+pratica.ClienteOcs__c+' -  DEALER : '+pratica.Dealer__c+' '+pratica.DealerOcsExternalId__c+' : richiesta confermata con storno provigionale';

        Case ticket = new Case();

        ticket.Type = CRM;
        ticket.ActivityType__c = activityType;
        ticket.NumeroPratica__c = numeroPratica;
        //ticket.SFAPraticaCambioAuto__c = pratica.Id;
        ticket.Subject = titolo;
        insert ticket;

        return ticket.Id;
    }

    @AuraEnabled
    public static void completaPratica(String numeroPratica, String targaNew, String telaioNew, String annoImmatricolazioneNew, String meseImmatricolazioneNew, String modelloNew, String valoreNew, String importoStorno, String note) {

        SFAPraticaCambioAuto__c praticaDB = [SELECT Id, IdAttivita__c, Targa__c, Telaio__c, Modello__c, AnnoImmatricolazione__c, MeseImmatricolazione__c, Valore__c, ImportoStorno__c, Note__c FROM SFAPraticaCambioAuto__c WHERE NumeroPratica__c = :numeroPratica][0];

        praticaDB.Targa__c = targaNew;
        praticaDB.Telaio__c = telaioNew;
        praticaDB.AnnoImmatricolazione__c = annoImmatricolazioneNew;
        praticaDB.MeseImmatricolazione__c = meseImmatricolazioneNew;
        praticaDB.Modello__c = modelloNew;
        praticaDB.Valore__c = valoreNew;
        praticaDB.ImportoStorno__c = importoStorno;
        if (praticaDB.Note__c != note && note != null && !note.equals(''))
            praticaDB.Note__c = note;

        upsert praticaDB;

        if (note != null && !note.equals(''))
            XCSNoteUtils.postANote(praticaDB.IdAttivita__c, 'Nota', note);
      
    }

    @AuraEnabled
    public static void processaAttivita(String numeroPratica, String codiceEsitoDiProvenienza, String codiceEsitoSuccessivo, String targaNew, String telaioNew, String annoImmatricolazioneNew, String meseImmatricolazioneNew, String modelloNew, String valoreNew, String importoStorno, String note) {

        completaPratica(numeroPratica, targaNew, telaioNew, annoImmatricolazioneNew, meseImmatricolazioneNew, modelloNew, valoreNew, importoStorno, note);

        SFAPraticaCambioAuto__c pratica = [SELECT Id, CodOutcome__c, IdAttivita__c, DealerOcsExternalId__c, IsRichMod__c
                                           FROM SFAPraticaCambioAuto__c 
                                           WHERE NumeroPratica__c = :numeroPratica][0];

        String caseId = pratica.IdAttivita__c;

        /*String userId = UserInfo.getUserId();
        String currentProfileId = [SELECT Id, profileId FROM User WHERE Id = :userId][0].profileId;
        String currentProfileName = [SELECT Id, Name FROM Profile WHERE Id = :currentProfileId][0].Name;*/

        //System.debug('*** currentProfileName :: ' + currentProfileName);

        System.debug('*** codiceEsitoDiProvenienza :: ' + codiceEsitoDiProvenienza);
        System.debug('*** codiceEsitoSuccessivo :: ' + codiceEsitoSuccessivo);

        SFA_CambioAuto_EsitiConfig__c scaec = 
            [SELECT Id, Actor__c, NextActor__c, IsCaseToBeClosed__c, IsNoteMandatory__c, CodNextOutcomeLabel__c
             FROM SFA_CambioAuto_EsitiConfig__c 
             WHERE CodOutcome__c = :codiceEsitoDiProvenienza AND CodNextOutcome__c = :codiceEsitoSuccessivo][0];

        Case c = [SELECT Id, ownerId, Note__c, CreatedDate, DueDate__c FROM Case WHERE Id = :caseId][0];

        System.debug('*** caseId :: ' + caseId);        

        Boolean isCaseToBeClosed = scaec.IsCaseToBeClosed__c;
        Boolean isNoteMandatory = scaec.IsNoteMandatory__c;
        String actor = scaec.Actor__c;
        String nextActor = scaec.NextActor__c;
        String labelCodiceEsitoSuccessivo = scaec.CodNextOutcomeLabel__c;

        //String idTicket = pratica.IdTicket__c;
        String dealerOcsExternalId = pratica.DealerOcsExternalId__c;
        String praticaId = pratica.Id;

        String emailTemplate = codiceEsitoSuccessivo;

        /*User u = [select DefaultQueueId__c from user where id=:userinfo.getuserid()][0]; 
        List<Account> filialeUser = [SELECT id, BusinessEmail__c 
                                  	 FROM Account WHERE RecordType.Name = 'Branch' AND OCS_External_Id__c = :u.DefaultQueueId__c];*/

        String emailFiliale = getFilialeEmailByDealer(dealerOcsExternalId);
        String emailCapoFiliale = getCapoFilialeEmailByDealer(dealerOcsExternalId);
        String emailAreaManager = getCoordinatoreEmailByDealer(dealerOcsExternalId);
        String emailRegionalManager = getRegionalManagerEmailByDealer(dealerOcsExternalId);
        String emailGDV = CompassParametersUtils.getValue('gdv.mail');
        String emailAV = CompassParametersUtils.getValue('av.mail');
        String emailUfficioContabilita = CompassParametersUtils.getValue('ufficiocontabilita.mail');

        c.Esito__c = labelCodiceEsitoSuccessivo;
        update c;

        if (!isCaseToBeClosed) {

            // assegnamento a coda successiva
            if (nextActor == AV) {
                System.debug('*** mi trovo in :: nextActor == AV');

                c.Type = CRM;
                update c;

                /*if (idTicket == null || idTicket == '') {

                    System.debug('*** mi trovo in :: idTicket == null || idTicket ==');
                    
                    String ticketId = creaTicket(numeroPratica, SFA_CAMAUT_ATTIVITA);

                    CaseUtils.assignToQueue(ticketId, 'Q500');
                    CaseUtils.assignToQueue(caseId, 'Q500');

                    //Mandare mail a Template SEND

                    List<String> lstEmailTo = new List<String>();
                    lstEmailTo.add(emailCapoFiliale);
                    lstEmailTo.add(emailAreaManager);
                    Messaging.SingleEmailMessage messageMail = EmailUtils.generateEmail(emailTemplate, lstEmailTo, Id.valueOf(praticaId));  
                    messageMail.setSenderDisplayName(emailFiliale);
                    EmailUtils.sendEmail(messageMail);
                }*/
                /*else {*/
                /*    Case ticket = [SELECT Id, Note__c FROM Case WHERE Id = :idTicket][0];
                    ticket.Status = 'New';
                    update ticket;

                    CaseUtils.assignToQueue(ticket.Id, 'Q500');*/
                    pratica.CodOutcome__c = codiceEsitoSuccessivo;
                    update pratica;

                    CaseUtils.assignToQueue(caseId, 'Q500');

                    if (emailTemplate == 'SEND') {

                        System.debug('*** mi trovo in :: emailTemplate == SEND');
                        
                        List<String> lstEmailTo = new List<String>();
                        lstEmailTo.add(emailCapoFiliale);
                        lstEmailTo.add(emailAreaManager);
                        Messaging.SingleEmailMessage messageMail = EmailUtils.generateEmail(emailTemplate, lstEmailTo, Id.valueOf(praticaId));  
                        messageMail.setSenderDisplayName(emailFiliale);
                        EmailUtils.sendEmail(messageMail);

                    }
                    else if (emailTemplate == 'RESP_AV') {
                        System.debug('*** mi trovo in :: emailTemplate == RESP_AV');
                        
                        List<String> lstEmailTo = new List<String>();
                        lstEmailTo.add(emailCapoFiliale);
                        lstEmailTo.add(emailRegionalManager);
                        Messaging.SingleEmailMessage messageMail = EmailUtils.generateEmail(emailTemplate, lstEmailTo, Id.valueOf(praticaId));  
                        messageMail.setSenderDisplayName(emailAreaManager);
                        EmailUtils.sendEmail(messageMail);

                    }
                    else if (emailTemplate == 'RESP_AV_GD') {
                        System.debug('*** mi trovo in :: emailTemplate == RESP_AV_GD');

                    // In questo caso non viene mandata email ma solo viene riaperto il ticket per AV di tipo “Cambio Auto - Attività” aggiungendo alle note cosa scritto a pag 21 dell'analisi
                    }
                /*}*/

            }
            else if (nextActor == GDV) {
                System.debug('*** mi trovo in :: nextActor == GDV');

                c.Type = SFA;
                update c;

                /*if (actor == AV) {
                    System.debug('*** mi trovo in :: actor == AV');
                    Case ticket = [SELECT Id, Status FROM Case WHERE Id = :idTicket][0];
                    ticket.Status = 'Closed';
                    update ticket;
                }*/

                pratica.CodOutcome__c = codiceEsitoSuccessivo;
                update pratica;

                CaseUtils.assignToQueue(caseId, 'Q502');
                
                List<String> lstEmailTo = new List<String>();
                lstEmailTo.add(emailGDV);
                Messaging.SingleEmailMessage messageMail = EmailUtils.generateEmail(emailTemplate, lstEmailTo, Id.valueOf(praticaId));

                if (emailTemplate == 'SEND_MOD') {
                    System.debug('*** mi trovo in :: emailTemplate == SEND_MOD');
                    
                    messageMail.setSenderDisplayName(emailFiliale);

                }
                else if (emailTemplate == 'DEAL_AV') {
                    System.debug('*** mi trovo in :: emailTemplate == DEAL_AV');
                    
                    messageMail.setSenderDisplayName(emailAV);

                }
                else if (emailTemplate == 'GO_AV') {
                    System.debug('*** mi trovo in :: emailTemplate == GO_AV');

                    messageMail.setSenderDisplayName(emailAV);

                }
                else if (emailTemplate == 'GO_STRN_AV') {
                    System.debug('*** mi trovo in :: emailTemplate == GO_STRN_AV');
                    
                    messageMail.setSenderDisplayName(emailAV);
                    
                }
                
                EmailUtils.sendEmail(messageMail);

            }
            else if (nextActor == COORD) {
                System.debug('*** mi trovo in :: nextActor == COORD');

                c.Type = SFA;
                update c;

                /*if (actor == AV) {
                    System.debug('*** mi trovo in :: actor == AV');
                    Case ticket = [SELECT Id, Status FROM Case WHERE Id = :idTicket][0];
                    ticket.Status = 'Closed';
                    update ticket;
                }*/

                pratica.CodOutcome__c = codiceEsitoSuccessivo;
                update pratica;

                String coordinatoreQueue = getCoordinatoreQueueByDealer(dealerOcsExternalId);

                CaseUtils.assignToQueue(caseId, coordinatoreQueue);

                // L'unica esito qui è ASK_COORD (bisogna mandare l'email a quel template)

                List<String> lstEmailTo = new List<String>();
                List<String> lstEmailCc = new List<String>();
                lstEmailTo.add(emailAreaManager);
                lstEmailCc.add(emailRegionalManager);
                Messaging.SingleEmailMessage messageMail = EmailUtils.generateEmail(emailTemplate, lstEmailTo, lstEmailCc, Id.valueOf(praticaId));  
                messageMail.setSenderDisplayName(emailAV);
                EmailUtils.sendEmail(messageMail);
                
            }
            else if (nextActor == FIL) {
                System.debug('*** mi trovo in :: nextActor == FIL');

                c.Type = SFA;
                update c;

                /*if (actor == AV) {
                    System.debug('*** mi trovo in :: actor == AV');
                    Case ticket = [SELECT Id, Status FROM Case WHERE Id = :idTicket][0];
                    ticket.Status = 'Closed';
                    update ticket;
                }*/

                List<String> lstEmailTo = new List<String>();
                lstEmailTo.add(emailFiliale);
                Messaging.SingleEmailMessage messageMail = EmailUtils.generateEmail(emailTemplate, lstEmailTo, Id.valueOf(praticaId)); 

                if (emailTemplate == 'NEW_ATT_GD') {
                    System.debug('*** mi trovo in :: emailTemplate == NEW_ATT_GD');
                    messageMail.setSenderDisplayName(emailGDV);

                }
                else if (emailTemplate == 'RICH_MOD') {
                    System.debug('*** mi trovo in :: emailTemplate == RICH_MOD');

                    if (pratica.IsRichMod__c == false) {
                        pratica.IsRichMod__c = true;
                        DateTime newDueDate_DateTime = c.CreatedDate.addDays(15);
                        Date newDueDate_Date = Date.newinstance(newDueDate_DateTime.year(), newDueDate_DateTime.month(), newDueDate_DateTime.day());
                        System.debug('*** Due Date aggiornata da :: ' + c.DueDate__c);
                        c.DueDate__c = newDueDate_Date;
                        update c;
                        System.debug('*** a :: ' + c.DueDate__c);
                    }

                    // Allegare modulo (pag. 20 analisi)
                    messageMail.setSenderDisplayName(emailGDV);

                }
                else if (emailTemplate == 'NEW_ATT_AV') {
                    System.debug('*** mi trovo in :: emailTemplate == NEW_ATT_AV');
                    messageMail.setSenderDisplayName(emailAV);

                }

                pratica.CodOutcome__c = codiceEsitoSuccessivo;
                update pratica;

                String filialeQueue = getFilialeQueueByDealer(dealerOcsExternalId);
                CaseUtils.assignToQueue(caseId, filialeQueue);

                EmailUtils.sendEmail(messageMail);
                
            }

        }

        else {
            c.Status = 'Closed';
            update c;

            System.debug('*** mi trovo in :: isCaseToBeClosed == true');

            if (emailTemplate == 'GIA_FATTO') {
                System.debug('*** mi trovo in :: emailTemplate == GIA_FATTO');

                // Manda email
                List<String> lstEmailTo = new List<String>();
                lstEmailTo.add(emailFiliale);
                Messaging.SingleEmailMessage messageMail = EmailUtils.generateEmail(emailTemplate, lstEmailTo, Id.valueOf(praticaId));  
                messageMail.setSenderDisplayName(emailGDV);
                EmailUtils.sendEmail(messageMail);

                //Viene inserito un ticket per AV di tipo “Cambio Auto - Notifiche” con soggetto l’oggetto della mail.

                String ticketId = creaTicketNotifica(numeroPratica, SFA_CAMAUT_NOTIFICHE, emailTemplate);

                CaseUtils.assignToQueue(ticketId, 'Q500');

            }
            else if (emailTemplate == 'KO_GDVCA') {
                System.debug('*** mi trovo in :: emailTemplate == KO_GDVCA');

                // Manda email
                List<String> lstEmailTo = new List<String>();
                lstEmailTo.add(emailFiliale);
                Messaging.SingleEmailMessage messageMail = EmailUtils.generateEmail(emailTemplate, lstEmailTo, Id.valueOf(praticaId));  
                messageMail.setSenderDisplayName(emailGDV);
                EmailUtils.sendEmail(messageMail);

                System.debug('*** lstEmailTo :: ' + JSON.serialize(lstEmailTo));
                System.debug('*** praticaId :: ' + praticaId);

                //Viene inserito un ticket per AV di tipo “Cambio Auto - Notifiche” con soggetto l’oggetto della mail.

                String ticketId = creaTicketNotifica(numeroPratica, SFA_CAMAUT_NOTIFICHE, emailTemplate);

                CaseUtils.assignToQueue(ticketId, 'Q500');

            }
            // emailTemplate e codiceEsitoSuccessivo hanno lo stesso valore tranne che per il template OK_GDVCA_STORNO
            else if (codiceEsitoSuccessivo == 'OK_GDVCA') {
                System.debug('*** mi trovo in :: codiceEsitoSuccessivo == OK_GDVCA'); 

                if (codiceEsitoDiProvenienza == 'GO_AV') {
                    emailTemplate = 'OK_GDVCA';

                    List<String> lstEmailTo = new List<String>();
                    lstEmailTo.add(emailFiliale);
                    Messaging.SingleEmailMessage messageMail = EmailUtils.generateEmail(emailTemplate, lstEmailTo, Id.valueOf(praticaId));
                    messageMail.setSenderDisplayName(emailGDV);
                    EmailUtils.sendEmail(messageMail);
                }
                else if (codiceEsitoDiProvenienza == 'GO_STRN_AV') {
                    emailTemplate = 'OK_GDVCA_STORNO';

                    String ticketId = creaTicketNotifica(numeroPratica, SFA_CAMAUT_NOTIFICHE, emailTemplate);
                    CaseUtils.assignToQueue(ticketId, 'Q500');

                    List<String> lstEmailTo = new List<String>();
                    lstEmailTo.add(emailFiliale);
                    List<String> lstEmailCc = new List<String>();
                    lstEmailCc.add(emailUfficioContabilita);
                    Messaging.SingleEmailMessage messageMail = EmailUtils.generateEmail(emailTemplate, lstEmailTo, lstEmailCc, Id.valueOf(praticaId));
                    messageMail.setSenderDisplayName(emailGDV);
                    EmailUtils.sendEmail(messageMail);
                }

                // Manda email
                

                //SOLO IN CASO DI STORNO (pag. 20) Viene inserito un ticket per AV di tipo “Cambio Auto - Notifiche” con soggetto l’oggetto della mail.

            }
            else if (emailTemplate == 'STOP_AV') {
                System.debug('*** mi trovo in :: emailTemplate == STOP_AV');
                /*Case ticket = [SELECT Id, Status FROM Case WHERE Id = :idTicket][0];
                ticket.Status = 'Closed';
                update ticket;*/

                List<String> lstEmailTo = new List<String>();
                List<String> lstEmailCc = new List<String>();
                lstEmailTo.add(emailFiliale);
                lstEmailCc.add(emailGDV);
                Messaging.SingleEmailMessage messageMail = EmailUtils.generateEmail(emailTemplate, lstEmailTo, lstEmailCc, Id.valueOf(praticaId));  
                messageMail.setSenderDisplayName(emailAV);
                EmailUtils.sendEmail(messageMail);
                
            }
            else if (emailTemplate == 'STOP_COORD') {
                System.debug('*** mi trovo in :: emailTemplate == STOP_COORD');

                List<String> lstEmailTo = new List<String>();
                lstEmailTo.add(emailRegionalManager);
                lstEmailTo.add(emailCapoFiliale);
                Messaging.SingleEmailMessage messageMail = EmailUtils.generateEmail(emailTemplate, lstEmailTo, Id.valueOf(praticaId));  
                messageMail.setSenderDisplayName(emailAreaManager);
                EmailUtils.sendEmail(messageMail);

                //Il rifiuto del coordinatore apre un ticket “Cambio Auto - Notifiche”, con soggetto l’oggetto della mail,  verso AV per la comunicazione dell’esito.
                String ticketId = creaTicketNotifica(numeroPratica, SFA_CAMAUT_NOTIFICHE, emailTemplate);

                CaseUtils.assignToQueue(ticketId, 'Q500');
                
            }

            pratica.CodOutcome__c = codiceEsitoSuccessivo;
            update pratica;
            
        }

        /*if (isNoteMandatory) {
            c.Note__c = nota;
        }*/

        /*pratica.CodOutcome__c = codiceEsitoSuccessivo;

        update pratica;*/
      
    }

    @AuraEnabled
       public static String getRegionalManagerEmailByDealer(String dealerOcsExternalId){

        String filialeQueue = [select Id, Branch__r.OCS_External_Id__c from Account where RecordType.Name = 'Dealer' AND OCS_External_Id__c = :dealerOcsExternalId][0].Branch__r.OCS_External_Id__c;
        System.debug('*** filialeQueue :: ' + filialeQueue);

        String filialeUserRoleId = [SELECT Id,DefaultQueueId__c,UserRoleId, Email FROM User WHERE DefaultQueueId__c = :filialeQueue and ( not userrole.developername like '%_Manager' ) ] [0].UserRoleId;
        System.debug('*** filialeUserRoleId :: ' + filialeUserRoleId);
	
        String branchManagerUserRoleId = [SELECT Id, Name, DeveloperName, ParentRoleId FROM UserRole WHERE Id = :filialeUserRoleId][0].ParentRoleId;
        System.debug('*** branchManagerUserRoleId :: ' + branchManagerUserRoleId);

        String areaManagerUserRoleId = [SELECT Id, Name, DeveloperName, ParentRoleId FROM UserRole WHERE Id = :branchManagerUserRoleId][0].ParentRoleId;
        System.debug('*** areaManagerUserRoleId :: ' + areaManagerUserRoleId);

        String regionalManagerUserRoleId = [SELECT Id, Name, DeveloperName, ParentRoleId FROM UserRole WHERE Id = :areaManagerUserRoleId][0].ParentRoleId;

        String email = [SELECT Id, Email FROM User WHERE UserRoleId = :regionalManagerUserRoleId][0].Email;
        System.debug('*** email :: ' + email);

        return email;
    }

    @AuraEnabled
    public static String getCoordinatoreQueueByDealer(String dealerOcsExternalId){

        String filialeQueue = [select Id, Branch__r.OCS_External_Id__c from Account where RecordType.Name = 'Dealer' AND OCS_External_Id__c = :dealerOcsExternalId][0].Branch__r.OCS_External_Id__c;
        //System.debug('*** filialeQueue :: ' + filialeQueue);

        String filialeUserRoleId = [SELECT Id,DefaultQueueId__c,UserRoleId, Email FROM User WHERE DefaultQueueId__c = :filialeQueue and ( not userrole.developername like '%_Manager' ) ][0].UserRoleId;
        //System.debug('*** filialeUserRoleId :: ' + filialeUserRoleId);

        String branchManagerUserRoleId = [SELECT Id, Name, DeveloperName, ParentRoleId FROM UserRole WHERE Id = :filialeUserRoleId][0].ParentRoleId;
        //System.debug('*** branchManagerUserRoleId :: ' + branchManagerUserRoleId);

        String areaManagerUserRoleId = [SELECT Id, Name, DeveloperName, ParentRoleId FROM UserRole WHERE Id = :branchManagerUserRoleId][0].ParentRoleId;

        String areaManagerUserRoleName = [SELECT Id, Name, DeveloperName FROM UserRole WHERE Id = :areaManagerUserRoleId][0].Name;

        Map<String, String> mapCoordinatore = CompassParametersUtils.getParameterByGroup('AREA_QUEUE');

        String coordinatoreQueue = mapCoordinatore.get(areaManagerUserRoleName);
        
        System.debug('*** coordinatoreQueue :: ' + coordinatoreQueue);
        return coordinatoreQueue;
    }

    @AuraEnabled
    public static String getCoordinatoreEmailByDealer(String dealerOcsExternalId){

        String filialeQueue = [select Id, Branch__r.OCS_External_Id__c from Account where RecordType.Name = 'Dealer' AND OCS_External_Id__c = :dealerOcsExternalId][0].Branch__r.OCS_External_Id__c;
        //System.debug('*** filialeQueue :: ' + filialeQueue);

        String filialeUserRoleId = [SELECT Id,DefaultQueueId__c,UserRoleId, Email FROM User WHERE DefaultQueueId__c = :filialeQueue and ( not userrole.developername like '%_Manager' ) ][0].UserRoleId;
        //System.debug('*** filialeUserRoleId :: ' + filialeUserRoleId);

        String branchManagerUserRoleId = [SELECT Id, Name, DeveloperName, ParentRoleId FROM UserRole WHERE Id = :filialeUserRoleId][0].ParentRoleId;
        //System.debug('*** branchManagerUserRoleId :: ' + branchManagerUserRoleId);

        String areaManagerUserRoleId = [SELECT Id, Name, DeveloperName, ParentRoleId FROM UserRole WHERE Id = :branchManagerUserRoleId][0].ParentRoleId;
        //System.debug('*** areaManagerUserRoleId :: ' + areaManagerUserRoleId);

        String email = [SELECT Id, Email FROM User WHERE UserRoleId = :areaManagerUserRoleId][0].Email;
        //System.debug('*** email :: ' + email);

        return email;
    }

    @AuraEnabled
    public static String getCapoFilialeEmailByDealer(String dealerOcsExternalId){

        String filialeQueue = [select Id, Branch__r.OCS_External_Id__c from Account where RecordType.Name = 'Dealer' AND OCS_External_Id__c = :dealerOcsExternalId][0].Branch__r.OCS_External_Id__c;
        //System.debug('*** filialeQueue :: ' + filialeQueue);

        String filialeUserRoleId = [SELECT Id,DefaultQueueId__c,UserRoleId, Email FROM User WHERE DefaultQueueId__c = :filialeQueue and ( not userrole.developername like '%_Manager' ) ][0].UserRoleId;
        //System.debug('*** filialeUserRoleId :: ' + filialeUserRoleId);

        String branchManagerUserRoleId = [SELECT Id, Name, DeveloperName, ParentRoleId FROM UserRole WHERE Id = :filialeUserRoleId][0].ParentRoleId;
        //System.debug('*** branchManagerUserRoleId :: ' + branchManagerUserRoleId);

        String email = [SELECT Id, Email FROM User WHERE UserRoleId = :branchManagerUserRoleId][0].Email;
        //System.debug('*** email :: ' + email);

        return email;
    }

    @AuraEnabled
    public static String getFilialeQueueByDealer(String dealerOcsExternalId){
        String filialeQueue = [select Id, Branch__r.OCS_External_Id__c from Account where RecordType.Name = 'Dealer' AND OCS_External_Id__c = :dealerOcsExternalId][0].Branch__r.OCS_External_Id__c;

        return filialeQueue;
    }

    @AuraEnabled
    public static String getFilialeEmailByDealer(String dealerOcsExternalId){
        System.debug('*** dealerOcsExternalId :: ' + dealerOcsExternalId);
        String email = [select Id, Branch__r.BusinessEmail__c from Account where RecordType.Name = 'Dealer' AND OCS_External_Id__c = :dealerOcsExternalId][0].Branch__r.BusinessEmail__c;

        return email;
    }
    
    public class DatiPratica {

        @AuraEnabled
        public String caseStatus {get; set;}
        @AuraEnabled
		public String esitoDiProvenienza {get; set;}

        @AuraEnabled
		public String numeroPratica {get; set;}

        @AuraEnabled
		public String codiceEsitoDiProvenienza {get; set;}

        //Dati provenienti da OCS
		@AuraEnabled
		public String dataLiquidazione {get; set;}
        @AuraEnabled
		public Boolean isDataLiquidazioneRed {get; set;}
        @AuraEnabled
		public String cliente {get; set;}
        @AuraEnabled
		public String assicurazione {get; set;}
        @AuraEnabled
		public Boolean isAssicurazioneRed {get; set;}
        @AuraEnabled
		public String prodotto {get; set;}
		@AuraEnabled
		public String descrizioneBene {get; set;}
        @AuraEnabled
		public String modello {get; set;}
		@AuraEnabled
		public String targa {get; set;}
        @AuraEnabled
		public String telaio {get; set;}
		@AuraEnabled
		public String valore {get; set;}
        @AuraEnabled
		public String dataImmatricolazione {get; set;}
        
        // Dati nuovi
        @AuraEnabled
		public String targaNew {get; set;}
        @AuraEnabled
		public String telaioNew {get; set;}
        @AuraEnabled
		public String annoImmatricolazioneNew {get; set;}
        @AuraEnabled
		public String meseImmatricolazioneNew {get; set;}
        @AuraEnabled
		public String modelloNew {get; set;}
        @AuraEnabled
		public String valoreNew {get; set;}
        @AuraEnabled
		public String importoStorno {get; set;}

	}

    public class SelectOption {

		public SelectOption(String label, String text, String value) {
			this.label = label;
			this.text = text;
			this.value = value;
		}

		@AuraEnabled
		public String label { get; set; }
		@AuraEnabled
		public String text { get; set; }
		@AuraEnabled
		public String value { get; set; }
	}
	
}