//----------------------------------------------------------------------
//-- - Class Name   : CRMBatChiudiSinistroSecond
//-- - Autor        : Daniele Segoloni(Lynx)
//-- - Date         : 02/07/2019
//-- - Description  : Batch per la chiusura dei Sinistri Assicurativi
//-- - Version      : 1.0
//----------------------------------------------------------------------

global class CRMBatChiudiSinistroSecond implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful, Schedulable{
    
    public class BorisException extends Exception{}

    global String query;
    global String mailBodyWithError = '';
    global String mailBodyScarti; 
    global String mailBodyNoScarti;
    global String sFlag = '';
    global String sNotaOCS = '';
    global String sNotaScarto = '';
    global List<OCSChiusuraSinistroRequest.ChiusuraSinistroRequestDTO> alicoRequestList  = new List<OCSChiusuraSinistroRequest.ChiusuraSinistroRequestDTO>();
    global List<OCSChiusuraSinistroRequest.ChiusuraSinistroRequestDTO> cardifRequestList  = new List<OCSChiusuraSinistroRequest.ChiusuraSinistroRequestDTO>();
    global List<Sinistro_Assicurativo__c> sinistriGlobali  = new List<Sinistro_Assicurativo__c>();
    global List<Chiusura_Sinistri_XLS__c> sinDaXLS  = new List<Chiusura_Sinistri_XLS__c>();
    global List<Chiusura_Sinistri_XLS__c> sinistriFromScarti  = new List<Chiusura_Sinistri_XLS__c>();
    global List<Sinistro_Assicurativo__c> sinistriWithError = new List<Sinistro_Assicurativo__c>();
    global List<Sinistro_Assicurativo__c> scarti = new List<Sinistro_Assicurativo__c>();
    global Map<String,Id> mDisp = new Map<String,Id>();
    global List<Case> caseUpdate = new List<Case>();
    
    global Map<String, Case> caseToInsertMap = new Map<String, Case>();
    global Map<String, String> noteCaseToInsertMap = new Map<String, String>();

    //global Map<String, String> noteSinistroToInsertMap = new Map<String, String>();
    
    public final String MAIL_TITLE_SCARTI = 'CRMA - Scarti chiusure excel';
    public final String MAIL_TITLE_NOSCARTI = 'CRMA - Chiusure excel terminate - nessuno scarto trovato';
    public final String MAIL_TITLE_ERR = 'CRMA - Chiusure Excel con errore';
    
    global final String CLIENTE_DIVERSO_OCS = 'Pratica associata a cliente diverso in OCS';
    global final String PRATICA_NON_TROVATA = 'Pratica non trovata in OCS';
    global final String INVIATA_A_OCS = 'Inviata a OCS';
    global final String CHIUSO_DA_ASSIC = 'Chiuso – Indennizzato da Assic';
    global final String IND_AL_CLIENTE = 'Indennizzo corrisposto direttamente al cliente';
    global final String CHIUSO_DA_CONTABILIZZARE = 'Chiuso – da contabilizzare';
    global final String IND_CORR_A_COMPASS = 'Indennizzo nota precedente corrisposto a COMPASS';
    global final String CHIUSO_RESPINTO = 'Chiuso – Respinto';
    global final String CHIUSO_NO_SEGUITO = 'Chiuso senza seguito';
    global final String CHIUSO = 'Chiuso';
    global final String LAVORATO = 'Lavorato';
    global final String TITLE_NOTA = 'Note sinistro';
    
    //COSTANTI CSV
    public final String DELIMITATORE_INIZIO = '"';
    public final String DEL = '","';
    public final String DELIMITATORE_FINE = '"\n';
    public final String BLANK_VALUE = '';
    public final String NULL_VALUE = 'null';
    public final String DATE_TIME = '00:00:00';
    public final String HEADER = 'Nome Sinistro,Account,Anomalia,Assicurazione,Beneficiario,Categoria,Coda,Cognome,Nome,Compagnia,Data Apertura,Data Chiusura,Data Definizione,Data Elaborazione,Data Erogazione,Data Fine Copertura,Data Inizio Copertura,Data Primo Utilizzo,Data Sinistro,Decorrenza,Descrizione Scarto,Esito,Flag err,Flag Esito,hasAttachment,Importo Indennizzato,isRead,Luogo Elaborazione,Motivo,Nominativo Assicurato,Note Assicurazione,Note, Contratto,Numero Pratica,PAN,Piano Ammortamento,Polizza,Rata,Saldo Residuo,Stato Sinistro,Subject,Tipologia Sinistro,Tipo Pagamento,Tipo Pratica,Ultimo Indennizzo \n';
    public final String CSV_NAME = 'scarti.csv';
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        system.debug('---------------------------------------------------------------------------------------');
        system.debug('-- Class Name: CRMBatChiudiSinistroSecond - Method Name: start'); 

        mailBodyScarti = XCS_TemplateUtils.getBody('CRMBatChiudiSinistro_EsitoConScarti');
        mailBodyNoScarti = XCS_TemplateUtils.getBody('CRMBatChiudiSinistro_EsitoSenzaScarti');
        
        Id idDisp = [SELECT Id FROM XCS_Disposition__c WHERE External_Id__c = 'DP2563'].Id;        
        mDisp.put('DP2563', idDisp);
        Id idDisp1 = [SELECT Id FROM XCS_Disposition__c WHERE External_Id__c = 'DP2547'].Id;        
        mDisp.put('DP2547', idDisp1);
        Id idDisp2 = [SELECT Id FROM XCS_Disposition__c WHERE External_Id__c = 'DP2546'].Id;        
        mDisp.put('DP2546', idDisp2);
        Id idDisp3 = [SELECT Id FROM XCS_Disposition__c WHERE External_Id__c = 'DP2549'].Id;        
        mDisp.put('DP2549', idDisp3);
        
        query = 'SELECT Id,Name,caseId__r.Account.LastName, caseId__r.Account.firstname,Anomalia__c,Assicurazione__c,caseId__r.Categoria__c,Coda__c,';
        query += 'Compagnia__c,Data_Apertura__c,Data_Chiusura__c,Data_Elaborazione__c,Data_Erogazione__c,';
        query += 'Data_Fine_Copertura__c,Data_Inizio_Copertura__c,Data_Primo_Utilizzo__c,Data_Sinistro__c,Decorrenza__c,';
        query += 'Esito__c,Flag_err__c,Flag_Esito__c,hasAttachment__c,Importo_Indennizzato__c,isRead__c,Luogo_Elaborazione__c,';
        query += 'caseId__r.Motivo__c,Note_Assicurazione__c,Note__c,caseId__r.NumeroPratica__c,caseId__r.pan__c,Piano_Ammortamento__c,';
        query += 'Polizza__c,Rata__c,Saldo_Residuo__c,caseId__r.Status,caseId__r.Subject,Tipologia_Sinistro__c,caseId__r.Pagamenti__c,caseId__r.Tipo_Pratica__c,Ultimo_Indennizzo__c';
        query += ' FROM Sinistro_Assicurativo__c';
        query += ' WHERE caseId__r.Status != \'Chiuso\'';
//        query += ' AND RecordType.Name = \'Standard\'';
        
        System.debug('query: '+query);
        
        return Database.getQueryLocator(query);
        
    }
    
    global void execute(Database.BatchableContext bc, List<Sinistro_Assicurativo__c> sinistriList){
        
        system.debug('---------------------------------------------------------------------------------------');
        system.debug('-- Class Name: CRMBatChiudiSinistroSecond - Method Name: execute'); 
        List<KeySinistro> listKs = new List<KeySinistro>();
        List<String> lNumeroPratica = new List<String>();
        List<String> lTipologiaSinistro = new List<String>();
        List<Date> lDataEvento = new List<Date>();
        List<Chiusura_Sinistri_XLS__c> sinistriFromFile = new List<Chiusura_Sinistri_XLS__c>();

        system.debug('-- sinistrilist.size-->' + sinistriList.size()); 

        for (Sinistro_Assicurativo__c s : sinistriList) {
            String Key = s.caseId__r.NumeroPratica__c + '-' + s.Tipologia_Sinistro__c + '-' + s.Data_Sinistro__c;
            
            lNumeroPratica.add(s.caseId__r.NumeroPratica__c);
            lTipologiaSinistro.add(s.Tipologia_Sinistro__c);
            lDataEvento.add(s.Data_Sinistro__c);
            
            KeySinistro temp = new KeySinistro(Key, s.caseId__r.NumeroPratica__c, s.Tipologia_Sinistro__c,s.Data_Sinistro__c, s);
            
            listKs.add(temp);
        }
        
        sinistriFromFile = [
            SELECT Id, Atto_correttezza__c, Beneficiario__c,CausaRifiuto__c, CauseDiSinistro__c, Name, CodiceGaranzia__c, CodiceProdotto__c, Cognome__c,
            Contraente__c,Contratto__c, Convenzione__c, Created__c, DataCaricamento__c, DataDefinizione__c, DataDenuncia__c, DataEvento__c,
            DataNascita__c, DataPerv__c, Data_ricezione_reclamo__c, Data_ricezione_ultimi_doc__c, Data_rifiuto__c, Data_ultima_richiesta__c, 
            Decorrenza_Copertura_Assicurativa__c, descScartoOCS__c, desScartoXLS__c, Diff__c, doc_Completa__c, flagUltimoIndennizzo__c,
            Garanzia__c, GroupID__c, id__c, Incaricato__c, list_id__c, Nome__c, Note__c, Pagato__c, riga__c, Sinistro__c, statoRecord__c, 
            Status__c, Tipo__c, updated__c
            FROM Chiusura_Sinistri_XLS__c 
            WHERE statoRecord__c = 2 
            AND DataEvento__c = : lDataEvento 
            AND Garanzia__c = : lTipologiaSinistro
            AND Contratto__c = : lNumeroPratica
        ];
        

        sinistriFromScarti = [
            SELECT Id, Atto_correttezza__c, Beneficiario__c,CausaRifiuto__c, CauseDiSinistro__c, Name, CodiceGaranzia__c, CodiceProdotto__c, Cognome__c,
            Contraente__c,Contratto__c, Convenzione__c, Created__c, DataCaricamento__c, DataDefinizione__c, DataDenuncia__c, DataEvento__c,
            DataNascita__c, DataPerv__c, Data_ricezione_reclamo__c, Data_ricezione_ultimi_doc__c, Data_rifiuto__c, Data_ultima_richiesta__c, 
            Decorrenza_Copertura_Assicurativa__c, descScartoOCS__c, desScartoXLS__c, Diff__c, doc_Completa__c, flagUltimoIndennizzo__c,
            Garanzia__c, GroupID__c, id__c, Incaricato__c, list_id__c, Nome__c, Note__c, Pagato__c, riga__c, Sinistro__c, statoRecord__c, 
            Status__c, Tipo__c, updated__c
            FROM Chiusura_Sinistri_XLS__c 
            WHERE statoRecord__c = 1 
        ];

        for(Chiusura_Sinistri_XLS__c chSin: sinistriFromFile){
            for(KeySinistro ks : listKs){
                if(chSin.DataEvento__c == ks.Sinistro.Data_Sinistro__c 
                   && chSin.Garanzia__c == ks.Sinistro.Tipologia_Sinistro__c 
                   && chSin.Contratto__c == ks.Sinistro.caseId__r.NumeroPratica__c){
                       System.debug('ASSOCIO CHIUSIN');
                       
                       ks.chiuSin = chSin;
                }
            }
        }
        
        List<OCSChiusuraSinistroRequest.ChiusuraSinistroRequestDTO > listaWSAlico = new List<OCSChiusuraSinistroRequest.ChiusuraSinistroRequestDTO >();
        List<OCSChiusuraSinistroRequest.ChiusuraSinistroRequestDTO > listaWSCardif = new List<OCSChiusuraSinistroRequest.ChiusuraSinistroRequestDTO >();
        
        System.debug('-- INIZIO CICLI FOR --');
        for(KeySinistro ks:listKs ){
            
            String compagnia ='';
            String flagReadOnly='';
            String flagEsito = '';
            String numPratica = ''; 
            String tipoPratica = '';
            String esito = ''; 
            String motivo = ''; 
            String importoindennizzato = '0';
            String cognome = ''; 
            String nome = '';
            String tipoSinistro = ''; 
            String tipoPagamento = '';
            
            System.debug('-- FLAG_ERR = 0 '); 
            if(!ks.Sinistro.Flag_err__c){
                sFlag = '0';
                ks.cas.Status = 'Sospeso';
                ks.ChiuSin.statoRecord__c = 3;
                
//                OCSChiusuraSinistroRequest.ChiusuraSinistroRequestDTO sinistroReq = new OCSChiusuraSinistroRequest.ChiusuraSinistroRequestDTO();
                nome = ks.Sinistro.caseId__r.Account.Firstname;
                cognome = ks.Sinistro.caseId__r.Account.Lastname;
                numPratica = ks.Sinistro.caseId__r.NumeroPratica__c;
                tipoPratica = ks.Sinistro.caseId__r.Tipo_Pratica__c;
                if(ks.Sinistro.Importo_Indennizzato__c==Null || String.isBlank(ks.Sinistro.Importo_Indennizzato__c)){
                    importoIndennizzato = '0';
                }else{
                    importoIndennizzato = ks.Sinistro.Importo_Indennizzato__c;
                }
                
                String stipoSinistro = '';
                String stipoPagamento = '';
                String sflagEsito = '';
                String sesito = '';
                String smotivo = '';
                
                if(ks.ChiuSin.Tipo__c=='ALICO'){
                    System.debug('-- IF SET REQ TIPO ALICO --');
                    //set di tipoSinistro
                    if (ks.ChiuSin.Garanzia__c == 'IPT' || ks.ChiuSin.Garanzia__c == 'Invalidità Totale Permanente') {
                        stipoSinistro = 'IPT';
                    }else if (ks.ChiuSin.Garanzia__c == 'Decesso' || ks.ChiuSin.Garanzia__c == 'DC') {
                        stipoSinistro = 'DC';
                    }else if (ks.ChiuSin.Garanzia__c == 'Malattia Grave' || ks.ChiuSin.Garanzia__c == 'MG') {
                        stipoSinistro = 'MG';
                    }else if (ks.ChiuSin.Garanzia__c == 'Inabilità Temporanea Totale' || ks.ChiuSin.Garanzia__c == 'ITT') {
                        stipoSinistro = 'ITT';
                    }else if (ks.ChiuSin.Garanzia__c == 'Perdita di impiego' || ks.ChiuSin.Garanzia__c == 'Perdita involontaria di impiego' || ks.ChiuSin.Garanzia__c == 'PII') {
                        stipoSinistro = 'PII';
                    }else if (ks.ChiuSin.Garanzia__c == 'Ricovero Ospedaliero' || ks.ChiuSin.Garanzia__c == 'RO') {
                        stipoSinistro = 'RO';
                    }
                    tipoSinistro = stipoSinistro;
                    
                    //set di tipoPagamento
                    if (ks.Sinistro.Tipologia_Sinistro__c == 'IPT' || ks.Sinistro.Tipologia_Sinistro__c == 'DC' || ks.Sinistro.Tipologia_Sinistro__c == 'MG') {
                        stipoPagamento = 'CLO';
                    }else if (ks.Sinistro.Tipologia_Sinistro__c == 'ITT' || ks.Sinistro.Tipologia_Sinistro__c == 'PII' || ks.Sinistro.Tipologia_Sinistro__c == 'RO') {
                        if (ks.ChiuSin.flagUltimoIndennizzo__c == 'S') {
                            stipoPagamento = 'CLO';
                        }else{
                            stipoPagamento = 'PEC';
                        }
                    }
                    tipoPagamento = stipoPagamento;
                    
                    //set di motivo (primi 50 caratteri di causa rifiuto)
                    System.debug('-- CausaRifiuto' + ks.ChiuSin.CausaRifiuto__c);
                    if (ks.Chiusin.CausaRifiuto__c.Length()>50){
	                    smotivo = ks.ChiuSin.CausaRifiuto__c.substring(0, 49);
                    }else{
	                    smotivo = ks.ChiuSin.CausaRifiuto__c;
                    }
                    motivo = smotivo;
                    
                    //status
                    if (ks.ChiuSin.Status__c == 'Chiuso con indennizzo') {
                        sflagEsito = 'C';
                        sesito = 'CON INDENNIZZO';
                    }else if (ks.ChiuSin.Status__c == 'Respinto') {
                        sflagEsito = 'R';
                        sesito = 'RESPINTO';
                    }else if (ks.ChiuSin.Status__c == 'Senza Seguito') {
                        sflagEsito = 'S';
                        sesito = 'SENZA SEGUITO';
                    }
                    flagEsito = sflagEsito;
                    esito = sesito;
                    
//                    alicoRequestList.add(sinistroReq);
                    
//                    System.debug('-- SINISTRO REQ '); 
//                    System.debug(sinistroReq); 

                    listaWSAlico.add(OCSChiusuraSinistroinvoker.setElencoSinistri(flagEsito, 
                                                                numPratica, tipoPratica,
                                                                esito, motivo, importoindennizzato,
                                                                cognome, nome,
                                                                tipoSinistro, tipoPagamento));
                    System.debug('-- SINISTRO REQ ALICO '); 
                    System.debug(listaWSAlico); 

                }
                else if(ks.ChiuSin.Tipo__c=='CARDIF'){
                    System.debug('-- IF SET REQ TIPO CARDIF --');
                    
                    if (ks.ChiuSin.Garanzia__c == 'IPT') {
                        stipoSinistro = 'IPT';
                    }else if (ks.ChiuSin.Garanzia__c == 'Decesso' || ks.ChiuSin.Garanzia__c == 'DC') {
                        stipoSinistro = 'DC';
                    }else if (ks.ChiuSin.Garanzia__c == 'MG') {
                        stipoSinistro = 'MG';
                    }else if (ks.ChiuSin.Garanzia__c == 'ITT') {
                        stipoSinistro = 'ITT';
                    }else if (ks.ChiuSin.Garanzia__c == 'PII') {
                        stipoSinistro = 'PII';
                    }else if (ks.ChiuSin.Garanzia__c == 'RO') {
                        stipoSinistro = 'RO';
                    }
                    tipoSinistro = stipoSinistro;
                    
                    //set di motivo (primi 50 caratteri di causa rifiuto)
                    if (ks.Chiusin.CausaRifiuto__c.Length()>50){
	                    smotivo = ks.ChiuSin.CausaRifiuto__c.substring(0, 49);
                    }else{
	                    smotivo = ks.ChiuSin.CausaRifiuto__c;
                    }
                    motivo = smotivo;
                    
                    //status
                    if (ks.ChiuSin.Status__c == 'CLO') {
                        sflagEsito = 'C';
                        sesito = 'CON INDENNIZZO';
                    }else if (ks.ChiuSin.Status__c == 'PEC') {
                        sflagEsito = 'C';
                        sesito = 'CON INDENNIZZO';
                    }else if (ks.ChiuSin.Status__c == 'REF') {
                        sflagEsito = 'R';
                        sesito = 'RESPINTO';
                    }
                    flagEsito = sflagEsito;
                    esito = sesito;
                    
//                    cardifRequestList.add(sinistroReq);
//                    System.debug('-- SINISTRO REQ '); 
//                    System.debug(sinistroReq); 
                    
                    listaWSCardif.add(OCSChiusuraSinistroinvoker.setElencoSinistri(flagEsito, 
                                                                             numPratica, tipoPratica,
                                                                             esito, motivo, importoindennizzato,
                                                                             cognome, nome,
                                                                             tipoSinistro, tipoPagamento));
                    
                    System.debug('-- SINISTRO REQ CARDIF '); 
                    System.debug(listaWSCardif); 
                }
                String nota = 'Importo: '+ks.ChiuSin.Pagato__c;
                
                if (ks.ChiuSin.Tipo__c == 'ALICO') {
                    nota += '\nUltimo indennizzo: '+ks.ChiuSin.flagUltimoIndennizzo__c;
                }
                nota += '\nMotivo: '+motivo;
                nota += '\nEsito: '+esito;
                nota += '\nData definizione: '+ks.ChiuSin.DataDefinizione__c;
                
                System.debug('-- nota: '+nota);
                ks.Sinistro.Note__c = nota;
            } // CHIUDE IF FLAG = 0
            
            
//            listaWS.add(OCSChiusuraSinistroinvoker.setElencoSinistri(compagnia, flagReadOnly, flagEsito, 
//                                                                numPratica, tipoPratica,
//                                                                esito, motivo, importoindennizzato,
//                                                                cognome, nome,
//                                                                tipoSinistro, tipoPagamento));
        }// chiude FOR PER SETTARE LA REQ setElencoSinistri
        
        System.debug('-- listaWSAlico.size()' + listaWSAlico.size()); 
        System.debug('-- sFlag' + sFlag); 

        if (listaWSAlico.size() > 0 && sFlag == '0') { // LANCIA IL SERVIZIO CHIUSURA PER ALICO FLAG 0
            System.debug('-- CHIUDO SINISTRI ALICO'); 
            System.debug('-- ELENCO SINISTRI ALICO'); 
            System.debug(listaWSAlico); 
//            OCSChiusuraSinistroRequest req = new OCSChiusuraSinistroRequest();
//            req.flagReadOnly = 'N';
//            req.elencoSinistri = alicoRequestList;
//            req.compagnia = 'ALICO';

            OCSChiusuraSinistroResponse alicoResp;
//            if (Test.isRunningTest()) {
//                alicoResp = buildMockChiusSinisResp();
//            }else{
                alicoResp = OCSChiusuraSinistroinvoker.callOCS(listaWSAlico, 'N', 'ALICO');
//                alicoResp = buildMockChiusSinisResp();
//            }
            System.debug('-- alicoResp: ');
            System.debug(alicoResp);
            listaWSAlico.clear();
            for (OCSChiusuraSinistroResponse.ChiusuraSinistroDTO sinistroResp : alicoResp.datiChiusuraSinistroResponse) {
                for(KeySinistro ks: listKs){
                    String rTipoSinistro;
                    String kTipoSinistro;
                    if(sinistroResp.tipoSinistro != null){
                        rTipoSinistro = sinistroResp.tipoSinistro.trim();
                    }else{
                        rTipoSinistro = null;
                    }
                    
                    if(ks.tipoSinistro != null){
                        kTipoSinistro = ks.tipoSinistro.trim();
                    }else{
                        kTipoSinistro = null;
                    }


                    System.debug('sinistroResp.tipoSinistro ' + rTipoSinistro);
                    System.debug('sinistroResp.numPratica ' + sinistroResp.numPratica);
                    System.debug('ks.tipoSinistro ' + kTipoSinistro);
                    System.debug('ks.numPratica ' + ks.numeroPratica);
//                    if(ks.tipoSinistro.trim() == sinistroResp.tipoSinistro.trim() 
                    if(kTipoSinistro == rTipoSinistro 
                       && ks.numeroPratica == sinistroResp.numPratica){
                        System.debug('-- ASSOCIO RESPONSE CHIUSURA');
                           
                           ks.respCompagnia = sinistroResp.compagnia;
                           ks.respNumPratica = sinistroResp.numPratica;
                           ks.respTipoPratica = sinistroResp.tipoPratica;
                           ks.respFlagEsito = sinistroResp.flagEsito;
                           ks.respEsito = sinistroResp.esito;
                           ks.respMotivo = sinistroResp.motivo;
                           ks.respImportoIndennizzato = sinistroResp.importoIndennizzato;
                           ks.respCognome = sinistroResp.cognome;
                           ks.respNome = sinistroResp.nome;
                           ks.respTipoSinistro = sinistroResp.tipoSinistro;
                           ks.respTipoPagamento = sinistroResp.tipoPagamento;
                           ks.respDesScarto = sinistroResp.desScarto;
                    }
                }
            }
        }// CHIUDE IF LANCIO CHIUSURA ALICO FLAG 0
        
        if (listaWSCardif.size() > 0 && sFlag == '0') { // LANCIA SERVIZIO CHIUSURA PER CARDIF FLAG 0
//            OCSChiusuraSinistroRequest req = new OCSChiusuraSinistroRequest();
//            req.flagReadOnly = 'N';
//            req.elencoSinistri = cardifRequestList;
//            req.compagnia = 'CARDIF';
          
            OCSChiusuraSinistroResponse cardifResp;
//            if (Test.isRunningTest()) {
//                cardifResp = buildMockChiusSinisResp();
//            }else{
                cardifResp = OCSChiusuraSinistroinvoker.callOCS(listaWSCardif, 'N', 'CARDIF');
//            }
            System.debug('cardifResp: '+cardifResp);
            
            for (OCSChiusuraSinistroResponse.ChiusuraSinistroDTO sinistroResp : cardifResp.datiChiusuraSinistroResponse) {
                for(KeySinistro ks: listKs){
                    String rTipoSinistro;
                    String kTipoSinistro;
                    if(sinistroResp.tipoSinistro != null){
                        rTipoSinistro = sinistroResp.tipoSinistro.trim();
                    }else{
                        rTipoSinistro = null;
                    }
                    
                    if(ks.tipoSinistro != null){
                        kTipoSinistro = ks.tipoSinistro.trim();
                    }else{
                        kTipoSinistro = null;
                    }

//                    if(ks.tipoSinistro == sinistroResp.tipoSinistro 
                    if(kTipoSinistro == rTipoSinistro 
                       && ks.numeroPratica == sinistroResp.numPratica){
                           
                           ks.respCompagnia = sinistroResp.compagnia;
                           ks.respNumPratica = sinistroResp.numPratica;
                           ks.respTipoPratica = sinistroResp.tipoPratica;
                           ks.respFlagEsito = sinistroResp.flagEsito;
                           ks.respEsito = sinistroResp.esito;
                           ks.respMotivo = sinistroResp.motivo;
                           ks.respImportoIndennizzato = sinistroResp.importoIndennizzato;
                           ks.respCognome = sinistroResp.cognome;
                           ks.respNome = sinistroResp.nome;
                           ks.respTipoSinistro = sinistroResp.tipoSinistro;
                           ks.respTipoPagamento = sinistroResp.tipoPagamento;
                           ks.respDesScarto = sinistroResp.desScarto;
                    }
                }
            }
        }// CHIUDE IF LANCIO CHIUSURA CARDIF FLAG 0
        
        // GESTIONE FLAG ERR = 1 
        
        System.debug('-- INIZIO FOR PER FLAG 1');
        for(KeySinistro ks:listKs ){
            String compagnia ='';
            String flagReadOnly='';
            String flagEsito = '';
            String numPratica = ''; 
            String tipoPratica = '';
            String esito = ''; 
            String motivo = ''; 
            String importoindennizzato = '';
            String cognome = ''; 
            String nome = '';
            String tipoSinistro = ''; 
            String tipoPagamento = '';

            if(ks.Sinistro.Flag_err__c){
                System.debug('-- FLAG_ERR = 1');
                
                sFlag = '1';
                ks.cas.Status = 'Sospeso';
                ks.ChiuSin.statoRecord__c = 3;
                
//                OCSChiusuraSinistroRequest.ChiusuraSinistroRequestDTO sinistroReq = new OCSChiusuraSinistroRequest.ChiusuraSinistroRequestDTO();
                //sinistroReq.put('compagnia', sFromFile.Compagnia__c);
                nome = ks.Sinistro.caseId__r.Account.Firstname;
                cognome = ks.Sinistro.caseId__r.Account.Lastname;
                numPratica = ks.Sinistro.caseId__r.NumeroPratica__c;
                tipoPratica = ks.Sinistro.caseId__r.Tipo_Pratica__c;
                
                String stipoSinistro = '';
                String stipoPagamento = '';
                String sflagEsito = '';
                String sesito = '';
                String smotivo = '';
                
                if(ks.ChiuSin.Tipo__c=='ALICO'){
                    System.debug('-- TIPO ALICO FLAG 1--');
                    //set di tipoSinistro
                    if (ks.ChiuSin.Garanzia__c == 'IPT' || ks.ChiuSin.Garanzia__c == 'Invalidità Totale Permanente') {
                        stipoSinistro = 'IPT';
                    }else if (ks.ChiuSin.Garanzia__c == 'Decesso' || ks.ChiuSin.Garanzia__c == 'DC') {
                        stipoSinistro = 'DC';
                    }else if (ks.ChiuSin.Garanzia__c == 'Malattia Grave' || ks.ChiuSin.Garanzia__c == 'MG') {
                        stipoSinistro = 'MG';
                    }else if (ks.ChiuSin.Garanzia__c == 'Inabilità Temporanea Totale' || ks.ChiuSin.Garanzia__c == 'ITT') {
                        stipoSinistro = 'ITT';
                    }else if (ks.ChiuSin.Garanzia__c == 'Perdita di impiego' || ks.ChiuSin.Garanzia__c == 'Perdita involontaria di impiego' || ks.ChiuSin.Garanzia__c == 'PII') {
                        stipoSinistro = 'PII';
                    }else if (ks.ChiuSin.Garanzia__c == 'Ricovero Ospedaliero' || ks.ChiuSin.Garanzia__c == 'RO') {
                        stipoSinistro = 'RO';
                    }
                    tipoSinistro = stipoSinistro;
                    
                    //set di tipoPagamento
                    if (ks.Sinistro.Tipologia_Sinistro__c == 'IPT' || ks.Sinistro.Tipologia_Sinistro__c == 'DC' || ks.Sinistro.Tipologia_Sinistro__c == 'MG') {
                        stipoPagamento = 'CLO';
                    }else if (ks.Sinistro.Tipologia_Sinistro__c == 'ITT' || ks.Sinistro.Tipologia_Sinistro__c == 'PII' || ks.Sinistro.Tipologia_Sinistro__c == 'RO') {
                        if (ks.ChiuSin.flagUltimoIndennizzo__c == 'S') {
                            stipoPagamento = 'CLO';
                        }else{
                            stipoPagamento = 'PEC';
                        }
                    }
                    tipoPagamento = stipoPagamento;
                    
                    //set di motivo (primi 50 caratteri di causa rifiuto)
                    if (ks.Chiusin.CausaRifiuto__c.Length()>50){
	                    smotivo = ks.ChiuSin.CausaRifiuto__c.substring(0, 49);
                    }else{
	                    smotivo = ks.ChiuSin.CausaRifiuto__c;
                    }
                    motivo = smotivo;
                    
                    //status
                    if (ks.ChiuSin.Status__c == 'Chiuso con indennizzo') {
                        sflagEsito = 'C';
                        sesito = 'CON INDENNIZZO';
                    }else if (ks.ChiuSin.Status__c == 'Respinto') {
                        sflagEsito = 'R';
                        sesito = 'RESPINTO';
                    }else if (ks.ChiuSin.Status__c == 'Senza Seguito') {
                        sflagEsito = 'S';
                        sesito = 'SENZA SEGUITO';
                    }
                    flagEsito = sflagEsito;
                    esito = sesito;
                    
//                    alicoRequestList.add(sinistroReq);

                    listaWSAlico.add(OCSChiusuraSinistroinvoker.setElencoSinistri(flagEsito, 
                                                                             numPratica, tipoPratica,
                                                                             esito, motivo, importoindennizzato,
                                                                             cognome, nome,
                                                                             tipoSinistro, tipoPagamento));

                    
                }
                else if(ks.ChiuSin.Tipo__c=='CARDIF'){
                    System.debug('-- TIPO CARDIF FLAG 1--');    
                    if (ks.ChiuSin.Garanzia__c == 'IPT') {
                        stipoSinistro = 'IPT';
                    }else if (ks.ChiuSin.Garanzia__c == 'Decesso' || ks.ChiuSin.Garanzia__c == 'DC') {
                        stipoSinistro = 'DC';
                    }else if (ks.ChiuSin.Garanzia__c == 'MG') {
                        stipoSinistro = 'MG';
                    }else if (ks.ChiuSin.Garanzia__c == 'ITT') {
                        stipoSinistro = 'ITT';
                    }else if (ks.ChiuSin.Garanzia__c == 'PII') {
                        stipoSinistro = 'PII';
                    }else if (ks.ChiuSin.Garanzia__c == 'RO') {
                        stipoSinistro = 'RO';
                    }
                    tipoSinistro = stipoSinistro;
                    
                    //set di motivo (primi 50 caratteri di causa rifiuto)
                    if (ks.Chiusin.CausaRifiuto__c.Length()>50){
	                    smotivo = ks.ChiuSin.CausaRifiuto__c.substring(0, 49);
                    }else{
	                    smotivo = ks.ChiuSin.CausaRifiuto__c;
                    }
                    motivo = smotivo;
                    
                    //status
                    if (ks.ChiuSin.Status__c == 'CLO') {
                        sflagEsito = 'C';
                        sesito = 'CON INDENNIZZO';
                    }else if (ks.ChiuSin.Status__c == 'PEC') {
                        sflagEsito = 'C';
                        sesito = 'CON INDENNIZZO';
                    }else if (ks.ChiuSin.Status__c == 'REF') {
                        sflagEsito = 'R';
                        sesito = 'RESPINTO';
                    }
                    flagEsito = sflagEsito;
                    esito = sesito;
                    
//                    cardifRequestList.add(sinistroReq);

                    listaWSCardif.add(OCSChiusuraSinistroinvoker.setElencoSinistri(flagEsito, 
                                                                             numPratica, tipoPratica,
                                                                             esito, motivo, importoindennizzato,
                                                                             cognome, nome,
                                                                             tipoSinistro, tipoPagamento));
                    
                }
                String nota = 'Importo: '+ks.ChiuSin.Pagato__c;
                if (ks.ChiuSin.Tipo__c == 'ALICO') {
                    nota += '\nUltimo indennizzo: '+ks.ChiuSin.flagUltimoIndennizzo__c;
                }
                nota += '\nMotivo: '+motivo;
                nota += '\nEsito: '+esito;
                nota += '\nData definizione: '+ks.ChiuSin.DataDefinizione__c;
                
                System.debug('nota: '+nota);
                ks.Sinistro.Note__c = nota;
            }
        } // FINE CICLO FOR PER REQ FLAG 1
        
        if (listaWSAlico.size() > 0 && sFlag == '1') { // LANCIO SERVIZIO ALICO FLAG 1
//            OCSChiusuraSinistroRequest req = new OCSChiusuraSinistroRequest();
//            req.flagReadOnly = 'N';
//            req.elencoSinistri = alicoRequestList;
//            req.compagnia = 'ALICO';
            
            OCSChiusuraSinistroResponse alicoResp;
//            if (Test.isRunningTest()) {
//                alicoResp = buildMockChiusSinisResp();
//            }else{
                alicoResp = OCSChiusuraSinistroinvoker.callOCS(listaWSAlico, 'S', 'ALICO');
//            }
            System.debug('alicoResp: '+alicoResp);
            
            for (OCSChiusuraSinistroResponse.ChiusuraSinistroDTO sinistroResp : alicoResp.datiChiusuraSinistroResponse) {
                for(KeySinistro ks: listKs){
                    String rTipoSinistro;
                    String kTipoSinistro;
                    if(sinistroResp.tipoSinistro != null){
                        rTipoSinistro = sinistroResp.tipoSinistro.trim();
                    }else{
                        rTipoSinistro = null;
                    }
                    
                    if(ks.tipoSinistro != null){
                        kTipoSinistro = ks.tipoSinistro.trim();
                    }else{
                        kTipoSinistro = null;
                    }
//                    if(ks.tipoSinistro == sinistroResp.tipoSinistro 
                    if(kTipoSinistro == rTipoSinistro 
                       && ks.numeroPratica == sinistroResp.numPratica){
                           System.debug('--ASSOCIATA RESPONSE--');
                           ks.respCompagnia = sinistroResp.compagnia;
                           ks.respNumPratica = sinistroResp.numPratica;
                           ks.respTipoPratica = sinistroResp.tipoPratica;
                           ks.respFlagEsito = sinistroResp.flagEsito;
                           ks.respEsito = sinistroResp.esito;
                           ks.respMotivo = sinistroResp.motivo;
                           ks.respImportoIndennizzato = sinistroResp.importoIndennizzato;
                           ks.respCognome = sinistroResp.cognome;
                           ks.respNome = sinistroResp.nome;
                           ks.respTipoSinistro = sinistroResp.tipoSinistro;
                           ks.respTipoPagamento = sinistroResp.tipoPagamento;
                           ks.respDesScarto = sinistroResp.desScarto;
                    }
                }
            }
        }
        
        if (listaWSCardif.size() > 0 && sFlag == '1') { // LANCIO SERVIZIO CARDIF FLAG 1
//            OCSChiusuraSinistroRequest req = new OCSChiusuraSinistroRequest();
//            req.flagReadOnly = 'N';
//            req.elencoSinistri = cardifRequestList;
//            req.compagnia = 'CARDIF';
            
            OCSChiusuraSinistroResponse cardifResp;
//            if (Test.isRunningTest()) {
//                cardifResp = buildMockChiusSinisResp();
//            }else{
                cardifResp = OCSChiusuraSinistroinvoker.callOCS(listaWSCardif, 'S', 'CARDIF');
//            }
            System.debug('cardifResp: '+cardifResp);
            
            for (OCSChiusuraSinistroResponse.ChiusuraSinistroDTO sinistroResp : cardifResp.datiChiusuraSinistroResponse) {
                for(KeySinistro ks: listKs){
                    String rTipoSinistro;
                    String kTipoSinistro;
                    if(sinistroResp.tipoSinistro != null){
                        rTipoSinistro = sinistroResp.tipoSinistro.trim();
                    }else{
                        rTipoSinistro = null;
                    }
                    
                    if(ks.tipoSinistro != null){
                        kTipoSinistro = ks.tipoSinistro.trim();
                    }else{
                        kTipoSinistro = null;
                    }

                    if(kTipoSinistro == rTipoSinistro 
                       && ks.numeroPratica == sinistroResp.numPratica){
                           
                           ks.respCompagnia = sinistroResp.compagnia;
                           ks.respNumPratica = sinistroResp.numPratica;
                           ks.respTipoPratica = sinistroResp.tipoPratica;
                           ks.respFlagEsito = sinistroResp.flagEsito;
                           ks.respEsito = sinistroResp.esito;
                           ks.respMotivo = sinistroResp.motivo;
                           ks.respImportoIndennizzato = sinistroResp.importoIndennizzato;
                           ks.respCognome = sinistroResp.cognome;
                           ks.respNome = sinistroResp.nome;
                           ks.respTipoSinistro = sinistroResp.tipoSinistro;
                           ks.respTipoPagamento = sinistroResp.tipoPagamento;
                           ks.respDesScarto = sinistroResp.desScarto;
                       }
                }
            }
        }
        
        System.debug('-- KEY SINISTRO ');
//        for(KeySinistro ksu:listKs) System.debug(ksu);
//        if(true)throw new BorisException('FABIO');    
        
        // INIZIO ELABORAZIONE RISULTATI LANCIO
        for(KeySinistro ksu:listKs){
            System.debug('ksu.respDesScarto' + ksu.respDesScarto);
            String rDesScarto;
            if (ksu.respDesScarto != null){
                rDesScarto = ksu.respDesScarto.trim();
            } else{
                rDesScarto = null;
            }
//            if (ksu.respDesScarto.trim() == 'OK' ||
//                ksu.respDesScarto.trim() == 'L\'importo dell’indennizzo è maggiore del saldo carta' ||
//                ksu.respDesScarto.trim() == 'L\'importo dell’indennizzo è maggiore dello scaduto' ||
//                ksu.respDesScarto.trim() == 'L\'importo dell’indennizzo è maggiore del saldo car' ||
//                ksu.respDesScarto.trim() == 'La carta ha filiale 200 non è possibile forzatura OLC') {
            if (rDesScarto == 'OK' ||
                rDesScarto == 'L\'importo dell’indennizzo è maggiore del saldo carta' ||
                rDesScarto == 'L\'importo dell’indennizzo è maggiore dello scaduto' ||
                rDesScarto == 'L\'importo dell’indennizzo è maggiore del saldo car' ||
                rDesScarto == 'La carta ha filiale 200 non è possibile forzatura OLC') {
                System.debug('-- ENTRATO IF ');
                System.debug('-- ksu.respDesScarto->' + ksu.respDesScarto);

                //ksu.Cas.Status = '4'; // DA CAPIRE COSA METTERCI 
                    if(ksu.respFlagEsito == 'C' && ksu.respCompagnia == 'CARDIF'){
                        System.debug('-- ksu.respFlagEsito + ksu.respCompagnia ' + ksu.respFlagEsito + '-' + ksu.respCompagnia );
                        ksu.cas.Esito__c = mDisp.get('DP2563');
                        sNotaOCS = IND_AL_CLIENTE; //note OCS == note assicurazione?
                        ksu.cas.Status = CHIUSO;
                    }else if (ksu.respFlagEsito == 'C' && ksu.respCompagnia != 'CARDIF'){
                        System.debug('-- ksu.respFlagEsito + ksu.respCompagnia ' + ksu.respFlagEsito + '-' + ksu.respCompagnia );
                        if(ksu.ChiuSin.Beneficiario__c != 'COMPASS' ){
                            System.debug('-- ksu.ChiuSin.Beneficiario__c ' + ksu.chiuSin.Beneficiario__c);
                            ksu.cas.Esito__c = mDisp.get('DP2563');
                            ksu.cas.Status = CHIUSO;
                            sNotaOCS = IND_AL_CLIENTE; //note OCS == note assicurazione?
                            XCSNoteUtils.postANote(ksu.Sinistro.Id, TITLE_NOTA, sNotaOCS); 
                        }else{
                            System.debug('-- ksu.ChiuSin.Beneficiario__c ' + ksu.chiuSin.Beneficiario__c);
                            ksu.cas.Esito__c = mDisp.get('DP2547');
                            sNotaOCS =IND_CORR_A_COMPASS; //note OCS == note assicurazione?
                            XCSNoteUtils.postANote(ksu.Sinistro.Id, TITLE_NOTA, sNotaOCS); 
                            ksu.cas.Status = 'Lavorato';
                        }
                    }else if(ksu.respFlagEsito == 'R' && ksu.respCompagnia == 'CARDIF'){
                        System.debug('-- ksu.respFlagEsito + ksu.respCompagnia ' + ksu.respFlagEsito + '-' + ksu.respCompagnia );
                        ksu.cas.Esito__c = mDisp.get('DP2546');
                        ksu.cas.Status = CHIUSO;
                    }else if(ksu.respFlagEsito == 'R' && ksu.respCompagnia != 'CARDIF'){
                        System.debug('-- ksu.respFlagEsito + ksu.respCompagnia ' + ksu.respFlagEsito + '-' + ksu.respCompagnia );
                        ksu.cas.Esito__c = mDisp.get('DP2546');
                        ksu.cas.Status = CHIUSO;
                    }else if(ksu.respFlagEsito == 'S' && ksu.respCompagnia == 'CARDIF'){
                        System.debug('-- ksu.respFlagEsito + ksu.respCompagnia ' + ksu.respFlagEsito + '-' + ksu.respCompagnia );
                        ksu.cas.Esito__c = mDisp.get('DP2549');
                        ksu.cas.Status = CHIUSO;
                    }
//            }else if(ksu.respDesScarto != 'OK' && ksu.respDesScarto != null){
            }else if(!String.isBlank(rDesScarto)){
                    System.debug('-- ksu.respDesScarto ' + ksu.respDesScarto);
                    ksu.ChiuSin.statoRecord__c = 1;
                    ksu.cas.Status = 'Aperto';
                    ksu.Sinistro.Flag_err__c = true;
                    sinistriFromScarti.add(ksu.chiuSin);
            }
            if(ksu.cas.Status == 'Lavorato'){
                System.debug('STATUS LAVORATO');
                PV2550SinistroDaContabInserimento.PV2550SinistroDaContabilizzareForm datiForm = new PV2550SinistroDaContabInserimento.PV2550SinistroDaContabilizzareForm();
                ksu.Sinistro.Coda__c = '104';
                String nota = 'Sinistro da contabilizzare';
                nota += '\nCodice Cliente: ' + ksu.cas.Codice_Cliente__c;
                nota += '\nNome cliente: '+ksu.Sinistro.caseId__r.Account.FirstName + ' ' + ksu.Sinistro.caseId__r.Account.LastName;
                nota += '\nPratica: '+ksu.numeroPratica;
                nota += '\nData sinistro: '+ksu.Sinistro.Data_Sinistro__c;
                nota += '\nTipo sinistro: '+ksu.tipoSinistro;
                nota += '\nUltimo indennizzo: ' + ksu.Sinistro.Ultimo_Indennizzo__c;
                nota += '\nImporto indennizzo: '+ksu.Sinistro.Importo_Indennizzato__c;
//                nota += '\nData definizione: '+ksu.sinistro.Data_Definizione__c;
                nota += '\nNote: richiesta creata automaticamente';
                nota += '\nCompagnia assicurativa: '+ksu.Sinistro.Compagnia__c;
                ksu.Sinistro.Note__c = nota;
            }
            
            OCSRecuperaPraticheAssicurateResponse praticheAssicurate;
//            if (Test.isRunningTest()){
//                praticheAssicurate = buildMockPratAssicResp();
//            }else{
                praticheAssicurate = OCSRecuperaPraticheAssicurateInvoker.callRecuperaPraticheAssicurate(ksu.NumeroPratica, '' , '', '', '' , null, '', '');
//            }
            
            if (praticheAssicurate != Null && praticheAssicurate.elencoPratiche != null && praticheAssicurate.elencoPratiche.size()>0 && 
                praticheAssicurate.elencoPratiche[0].tipoPratica == 'CO' && 
                (praticheAssicurate.elencoPratiche[0].assicurazione == 'AIGR1' ||
                 praticheAssicurate.elencoPratiche[0].assicurazione == 'AIGR2' ||
                 praticheAssicurate.elencoPratiche[0].assicurazione == 'AIGR3' ||
                 praticheAssicurate.elencoPratiche[0].assicurazione == 'AIGR4')) {
                     //TODO: Crea Richiesta PV Tipo “RES Recesso Servizi” Assegnata a OPA su coda “RES Recesso Servizi”(345)
                     PV5864RESRecessoServiziInserimento.PV5864RESRecessoServiziForm datiForm = new PV5864RESRecessoServiziInserimento.PV5864RESRecessoServiziForm();
                 }
            if(ksu.respDesScarto == null){
                System.debug('-- ksu.respDesScarto == NULL ');
                ksu.ChiuSin.statoRecord__c = 1;
                ksu.Sinistro.Flag_err__c = true;
                sNotaScarto += 'OCS non ha restituito la chiusura del sinistro con numPratica = ' + ksu.numeroPratica +'\n';
            }
        }
        
        List<Chiusura_Sinistri_XLS__c> updChi = new List<Chiusura_Sinistri_XLS__c>();
        List<Case> updCas = new List<Case>();
        List<Sinistro_Assicurativo__c> updSin = new List<Sinistro_Assicurativo__c>();
        
        for(KeySinistro ks:listKs){
            System.debug('-- ID Chiusin' + ks.chiuSin.Id);
            if(ks.chiuSin.Id != null){
                updChi.add(ks.ChiuSin);
            }
        }
        if(updChi.size()>0)
            update updChi;
        
        for(KeySinistro ks:listKs){
            updCas.add(ks.cas);
        }
        if(updCas.size()>0)
            update updCas;
        
        for(KeySinistro ks:listKs){
            updSin.add(ks.Sinistro);
        }
        if(updSin.size()>0)
            update updSin;
    }
    
    /*

String nota = 'Nome cliente: '+s.caseId__r.Account.FirstName + ' ' + s.caseId__r.Account.LastName;
nota += '\nPratica: '+s.caseId__r.NumeroPratica__c;
nota += '\nData sinistro: '+s.Data_Sinistro__c;
nota += '\nTipo sinistro: '+s.Tipologia_Sinistro__c;
nota += '\nUltimo indennizzo: '+s.Compagnia__c == 'ALICO' ? s.Ultimo_Indennizzo__c : '';
nota += '\nImporto indennizzo: '+s.Importo_Indennizzato__c;
nota += '\nData definizione: '+s.Data_Definizione__c;
nota += '\nNote: richiesta creata automaticamente';
nota += '\nCompagnia assicurativa: '+s.Compagnia__c;


if (String.isBlank(s.Descrizione_Scarto__c)) {
//Aggiungo testo a mail “OCS non ha restituito la chiusura del sinistro con numPratica=<num_pratica>”
mailBodyWithError += '\nOCS non ha restituito la chiusura del sinistro con numPratica='+s.caseId__r.NumeroPratica__c;
s.Flag_err__c = true;
}

if (s.Flag_err__c == true) {
sinistriWithError.add(s);
}

// FINE ELABORAZIONE SINISTRI DA FILE CHIUSURA


// FINE INSERIMENTO DEI CASE E DELLE NOTE DEI CASE
*/
    
    global void finish(Database.BatchableContext bc){

 
        System.debug('----------------------------------------------------------------------------------');
        System.debug('-- Class Name: CRMBatChiudiSinistroSecond  - Method Name : finish'); 
//        System.debug('sinistriWithError.size(): '+sinistriWithError.size());
//        System.debug('scarti.size(): '+scarti.size());

        XCS_CompassParameters__c c = XCS_CompassParameters__c.getValues('emailChiudiSinistro');
        System.debug('c' + c.value__c);

        String subject;
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {c.value__c}; //TODO: sostituire con email dell'admin
        String[] ccAddresses = new String[] {c.value__c};//TODO: verificare se necessario
                
                //se ci sono stati errori, invio email di errore 
                System.debug('sinistriFromScarti.size -> '+ sinistriFromScarti.size());
        if (sinistriFromScarti.size() > 0) {
            
            //                    toAddresses = new String[] {'Operations.ProdottiAssicurativi@compass.it', 'Maria.Curcio@compass.it', 'crm@compass.it'}; 
            toAddresses = new String[] {c.value__c}; 
                
                // CREO CSV CON SCARTI
                Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
            Blob csvBlob = Blob.valueOf(buildScartiCSV(sinistriFromScarti));
            csvAttc.setFileName(CSV_NAME);
            csvAttc.setBody(csvBlob);
            mail.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
            subject = MAIL_TITLE_SCARTI;
            mail.setPlainTextBody(mailBodyScarti);
        }else{
            subject = MAIL_TITLE_NOSCARTI;
            mail.setPlainTextBody(mailBodyNoScarti);
        }
        mail.setSubject(subject);
        mail.setToAddresses(toAddresses);
        mail.setCcAddresses(ccAddresses);
        mail.setReplyTo(c.value__c);
        mail.setSenderDisplayName('Salesforce Support');
        
        System.debug('MAIL - > '+ mail);
//        if(true)throw new BorisException('FINISH');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); //TODO: decommentare per abilitare invio email
        
        //TODO: aggiungere schedulazione batch successivo

        String hour;
        String min;
        String ss;
            
        CRMBatChiudiSinistroFirst bChiudi = new CRMBatChiudiSinistroFirst();
        
        DateTime dt = Datetime.now();
        DateTime dt2 = dt.addMinutes(15);
        System.debug('dt --> ' + dt);
        System.debug('new dt --> ' + dt.addMinutes(15));
        
        hour = String.valueOf(dt2.hour());
        min = String.valueOf(dt2.minute());
        ss = String.valueOf(dt2.second());
        System.debug('hour -> ' + hour);
        System.debug('min -> ' + min);
        System.debug('ss -> ' + ss);
        
        String nextTime = ss + ' ' + min + ' ' + hour + ' * * ?';
        System.debug('nextTime -> ' + nextTime);
//		String jobID = System.schedule('ChiusuraSinistro', nextTime, bChiudi);
        
    }

    global void execute(SchedulableContext sc) {
        CRMBatChiudiSinistroSecond b = new CRMBatChiudiSinistroSecond(); 
        Database.executebatch(b);
    }    
    public String buildScartiCSV(List<Chiusura_Sinistri_XLS__c> scarti) {
        System.debug('---------------------------------------------------------------------------------------');
        System.debug('-- Class Name: CRMBatChiudiSinistroSecond - Method Name: buildScartiCSV');
        System.debug('-- scarti.size -> ' + scarti.size());
        String finalStr = HEADER;
        for(Chiusura_Sinistri_XLS__c s: scarti){
//            String recordString = DELIMITATORE_INIZIO+ s.Name+DEL+s.caseId__r.Account.FirstName + s.caseId__r.Account.LastName+DEL+s.Anomalia__c+DEL+s.Assicurazione__c+DEL+s.Beneficiario__c+DEL+s.caseId__r.Categoria__c+DEL+s.Coda__c+DEL+DEL+s.Compagnia__c+DEL+s.Data_Apertura__c+DEL+s.Data_Chiusura__c+DEL+s.Data_Definizione__c+DEL+s.Data_Elaborazione__c+DEL+s.Data_Erogazione__c+DEL+s.Data_Fine_Copertura__c+DEL+s.Data_Inizio_Copertura__c+DEL+s.Data_Primo_Utilizzo__c+DEL+s.Data_Sinistro__c+DEL+s.Decorrenza__c+DEL+s.Descrizione_Scarto__c+DEL+s.Esito__c+DEL+s.Flag_err__c+DEL+s.Flag_Esito__c+DEL+s.hasAttachment__c+DEL+s.Importo_Indennizzato__c+DEL+s.isRead__c+DEL+s.Luogo_Elaborazione__c+DEL+s.caseId__r.Motivo__c+DEL+DEL+s.Note_Assicurazione__c+DEL+s.Note__c+DEL+Contratto__c+DEL+s.caseId__r.NumeroPratica__c+DEL+s.caseId__r.pan__c+DEL+s.Piano_Ammortamento__c+DEL+s.Polizza__c+DEL+s.Rata__c+DEL+s.Saldo_Residuo__c+DEL+s.caseId__r.Status+DEL+s.caseId__r.Subject+DEL+s.Tipologia_Sinistro__c+DEL+s.caseId__r.Pagamenti__c+DEL+s.caseId__r.Tipo_Pratica__c+DEL+s.Ultimo_Indennizzo__c +DELIMITATORE_FINE;
            String recordString = DELIMITATORE_INIZIO+ s.Name+DEL+s.Nome__c + 
            s.Cognome__c+DEL+s.Atto_Correttezza__c+DEL+s.Beneficiario__c+DEL+s.CausaRifiuto__c+DEL+s.CauseDiSinistro__c+DEL+
            s.CodiceGaranzia__c+DEL+s.CodiceProdotto__c+DEL+s.Contraente__c+DEL+s.Contratto__c+DEL+s.Convenzione__c+DEL+
            s.DataCaricamento__c+DEL+s.Contraente__c+s.DataDefinizione__c+DEL+s.DataDenuncia__c+DEL+s.descScartoOCS__c+DEL+
            s.Garanzia__c+DEL+s.Tipo__c+DELIMITATORE_FINE;
            
            recordString = recordString.replace(NULL_VALUE, BLANK_VALUE);
            recordString = recordString.replace(DATE_TIME, BLANK_VALUE);
            finalstr += recordString;
        }
        
        return finalstr;
    }
    
    //costruisce response mock per recuperaPraticheAssicurate
/*    public OCSRecuperaPraticheAssicurateResponse buildMockPratAssicResp() {
        
        system.debug('---------------------------------------------------------------------------------------');
        system.debug('-- Class Name: CRMBatChiudiSinistro - Method Name: buildMockPratAssicResp');
        OCSRecuperaPraticheAssicurateResponse resp = new OCSRecuperaPraticheAssicurateResponse();
        OCSRecuperaPraticheAssicurateResponse.PraticaAssicurataDTO pratica = new OCSRecuperaPraticheAssicurateResponse.PraticaAssicurataDTO();
        
        pratica.filiale = 'test';
        pratica.numPratica = 'test';
        pratica.tipoPratica = 'CO';
        pratica.statoPratica = 'test';
        pratica.bloccoPratica = 'test';
        pratica.codFiscale = 'test';
        pratica.dataRichiesta = 'test';
        pratica.assicurazione = 'AIGR4';            
        pratica.noteAssicurazione = 'test';
        pratica.dataInizioCopertura = 'test';
        pratica.dataFineCopertura = 'test';
        pratica.cognome = 'test';
        pratica.nome = 'test';
        pratica.denominazione = 'test';
        pratica.dataNascita = 'test';
        pratica.luogoNascita = 'test';
        pratica.codCliente = 'test';
        pratica.scaduto = 'test';
        
        resp.elencoPratiche.add(pratica);
        resp.resultCode = 0;
        
        return resp;
    }*/
    
    //buildMockChiusSinisResp
/*    public OCSChiusuraSinistroResponse buildMockChiusSinisResp() {
        
        system.debug('---------------------------------------------------------------------------------------');
        system.debug('-- Class Name: CRMBatChiudiSinistro - Method Name: buildMockChiusSinisResp');
        OCSChiusuraSinistroResponse resp = new OCSChiusuraSinistroResponse();
        OCSChiusuraSinistroResponse.chiusuraSinistroDTO sinistro = new OCSChiusuraSinistroResponse.chiusuraSinistroDTO();
        
        sinistro.compagnia = 'test';
        sinistro.numPratica = '16134504';
        sinistro.tipoPratica = 'test';
        sinistro.flagEsito = 'C';
        sinistro.esito = 'test';
        sinistro.motivo = 'test';
        sinistro.importoIndennizzato = 'test';
        sinistro.cognome = 'test';
        sinistro.nome  = 'test';
        sinistro.tipoSinistro = 'PII';
        sinistro.tipoPagamento  = 'test';
        sinistro.desScarto = 'OK';
        
        resp.datiChiusuraSinistroResponse.add(sinistro);
        resp.resultCode = 0;
        
        return resp;
    }*/
    
    public class KeySinistro{
        
        public String ident;
        public String tipoSinistro;
        public String numeroPratica;
        public Date dataSinistro;
        public Chiusura_Sinistri_XLS__c chiuSin;
        public Sinistro_Assicurativo__c sinistro;
        public Account acc;
        public Case cas;
        
        public String respCompagnia;
        public String respNumPratica;
        public String respTipoPratica;
        public String respFlagEsito;
        public String respEsito;
        public String respMotivo;
        public String respImportoIndennizzato;
        public String respCognome;
        public String respNome;
        public String respTipoSinistro;
        public String respTipoPagamento;
        public String respDesScarto;
        
        public KeySinistro(String ident, String b, String c, Date dDataEvento, Sinistro_Assicurativo__c sx){
            this.sinistro = sx;
            this.ident = sx.caseId__r.NumeroPratica__c + '-' + sx.Tipologia_Sinistro__c + '-' + sx.Data_Sinistro__c;
            this.tipoSinistro = sx.Tipologia_Sinistro__c;
            this.numeroPratica = sx.caseId__r.NumeroPratica__c;
            this.dataSinistro = sx.Data_Sinistro__c;
            cas = new Case();
            ChiuSin = new Chiusura_Sinistri_XLS__c();
            cas.id = sinistro.caseId__c;
        }
    }
    public class RequestList{
        
        public String flagEsito;
        public String numPratica;
        public String tipoPratica;
        public String esito;
        public String motivo;
        public String importoIndennizzato;
        public String cognome;
        public String nome;
        public String tipoSinistro;
        public String tipoPagamento;
    }
}