//----------------------------------------------------------------------
//-- - Class Name   : CRMBatChiudiSinistro
//-- - Autor        : Daniele Segoloni(Lynx)
//-- - Date         : 02/07/2019
//-- - Description  : Batch per la chiusura dei Sinistri Assicurativi
//-- - Version      : 1.0
//----------------------------------------------------------------------

global class CRMBatChiudiSinistroFirst implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful ,Schedulable {

    public class BorisException extends Exception{}
    
    global String query;
    global String mailBodyWithError = '';
    global String mailBodyScarti; 
    global String mailBodyNoScarti;
    global String tipPra;
    global List<Chiusura_Sinistri_XLS__c> sinistriFromFile = new List<Chiusura_Sinistri_XLS__c>();
    global List<Sinistro_Assicurativo__c> sinistriGlobali  = new List<Sinistro_Assicurativo__c>();
    global List<Chiusura_Sinistri_XLS__c> sinDaXLS  = new List<Chiusura_Sinistri_XLS__c>();
    global List<Sinistro_Assicurativo__c> sinistriWithError = new List<Sinistro_Assicurativo__c>();
    global List<Sinistro_Assicurativo__c> scarti = new List<Sinistro_Assicurativo__c>();
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
    public final String HEADER = 'Nome Sinistro,Account,Anomalia,Assicurazione,Beneficiario,Categoria,Coda,Cognome,Nome,Compagnia,Data Apertura,Data Chiusura,Data Definizione,Data Elaborazione,Data Erogazione,Data Fine Copertura,Data Inizio Copertura,Data Primo Utilizzo,Data Sinistro,Decorrenza,Disposizioni,Esito,Flag err,Flag Esito,hasAttachment,Importo Indennizzato,isRead,Luogo Elaborazione,Motivo,Nominativo Assicurato,Note Assicurazione,Note, Contratto,Numero Pratica,PAN,Piano Ammortamento,Polizza,Rata,Saldo Residuo,Stato Sinistro,Subject,Tipologia Sinistro,Tipo Pagamento,Tipo Pratica,Ultimo Indennizzo \n';
    public final String CSV_NAME = 'scarti.csv';

    global Database.QueryLocator start(Database.BatchableContext bc){
        system.debug('---------------------------------------------------------------------------------------');
        system.debug('-- Class Name: CRMBatChiudiSinistroFirst - Method Name: start'); 
        
        mailBodyScarti = XCS_TemplateUtils.getBody('CRMBatChiudiSinistro_EsitoConScarti');
        mailBodyNoScarti = XCS_TemplateUtils.getBody('CRMBatChiudiSinistro_EsitoSenzaScarti');

        query = 'SELECT Id, Atto_correttezza__c, Beneficiario__c,CausaRifiuto__c, CauseDiSinistro__c, Name, CodiceGaranzia__c, CodiceProdotto__c, Cognome__c, ';
        query += 'Contraente__c,Contratto__c, Convenzione__c, Created__c, DataCaricamento__c, DataDefinizione__c, DataDenuncia__c, DataEvento__c, ';
        query += 'DataNascita__c, DataPerv__c, Data_ricezione_reclamo__c, Data_ricezione_ultimi_doc__c, Data_rifiuto__c, Data_ultima_richiesta__c, ';
        query += 'Decorrenza_Copertura_Assicurativa__c, descScartoOCS__c, desScartoXLS__c, Diff__c, doc_Completa__c, flagUltimoIndennizzo__c, ';
        query += 'Garanzia__c, GroupID__c, id__c, Incaricato__c, list_id__c, Nome__c, Note__c, Pagato__c, riga__c, Sinistro__c, statoRecord__c, ';
        query += 'Status__c, Tipo__c, updated__c ';
        query += 'FROM Chiusura_Sinistri_XLS__c '; 
        query += 'WHERE statoRecord__c = 2 OR (statoRecord__c <> 4 AND statoRecord__c <> 5)';

        system.debug('---------------------------------------------------------------------------------------');
        system.debug('-- Class Name: CRMBatChiudiSinistroFirst - Method Name: start'); 
        System.debug('-- query: '+query);
        
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<Chiusura_Sinistri_XLS__c> sinistriList){
        system.debug('---------------------------------------------------------------------------------------');
        system.debug('-- Class Name: CRMBatChiudiSinistroFirst - Method Name: execute'); 

		List<KeySinistro> listKey = new List<KeySinistro>();
        List<String> lGaranzia = new List<String>();
        List<String> lContratto = new List<String>();
        List<Date> lDataEvento = new List<Date>();

        String sdataApprovazione;
        
        
        // INIZIO ELABORAZIONE SINISTRI DA FILE CHIUSURA
        for (Chiusura_Sinistri_XLS__c s : sinistriList) {
            String Key = s.Garanzia__c + '-' + s.Contratto__c + '-' + s.DataEvento__c;

            lgaranzia.add(s.Garanzia__c);
            lContratto.add(s.Contratto__c);
            lDataEvento.add(s.DataEvento__c);
            
			KeySinistro temp = new KeySinistro(Key, s.Garanzia__c, s.Contratto__c,s.DataEvento__c, s);
            
            listkey.add(temp);

        }
        //Controllo se ho effettivamente inserito nel Wrapper
        system.debug('---------------------------------------------------------------------------------------');
        system.debug('-- Class Name: CRMBatChiudiSinistroFirst - Method Name: execute'); 
        System.debug('-- Lista '+listKey.size());
        for(KeySinistro ks : listKey) System.debug(ks);
        //Fino a qui tutto ok
        
        
        
//		List<Sinistro_Assicurativo__c> sxEsistenti = [SELECT Id, Data_Evento__c, Tipologia_Sinistro__c, caseId__r.NumeroPratica__c 
		List<Sinistro_Assicurativo__c> sxEsistenti = [SELECT Id, Data_Sinistro__c, Tipologia_Sinistro__c, caseId__r.NumeroPratica__c 
                                                      FROM Sinistro_Assicurativo__c
                                                      WHERE Data_Sinistro__c = : lDataEvento 
                                                      AND Tipologia_Sinistro__c = : lGaranzia
                                                      AND caseId__r.NumeroPratica__c = : lContratto];
        
        system.debug('---------------------------------------------------------------------------------------');
        system.debug('-- Class Name: CRMBatChiudiSinistroFirst - Method Name: execute'); 
        System.debug('sxEsistenti.size -> '+sxEsistenti.size());
        
        
        for(KeySinistro ks :listkey){
            for(Sinistro_Assicurativo__c sinAss : sxEsistenti){
                
                if(ks.dataSinistro == sinAss.Data_Sinistro__c 
                   && ks.tipoSinistro == sinAss.Tipologia_Sinistro__c 
                   && ks.numeroPratica == sinAss.caseId__r.NumeroPratica__c){
                       system.debug('---------------------------------------------------------------------------------------');
                       system.debug('-- Class Name: CRMBatChiudiSinistroFirst - Method Name: execute'); 
                       System.debug('-- SINISTRO ASSOCIATO ');
                       System.debug('-- ks.dataSinistro-> ' + sinAss.Data_Sinistro__c); 
                   	   System.debug('-- ks.tipoSinistro-> ' + sinAss.Tipologia_Sinistro__c); 
                       System.debug('-- ks.numeroPratica-> '+ sinAss.caseId__r.NumeroPratica__c);
                       ks.sinistro = sinAss; //SX Esistente
                }
            }
        }
        
        //QUI DA TESTARE CON UNA PRATICA ESISTENTE
        system.debug('---------------------------------------------------------------------------------------');
        system.debug('-- Lista KEY Sinistro dopo associazione CHIUSURA - ESISTENTI'); 
        for(KeySinistro ks :listkey) System.debug(ks);
        
        
        List<Chiusura_Sinistri_XLS__c> updChiu = new List<Chiusura_Sinistri_XLS__c>();
        Chiusura_Sinistri_XLS__c chiuSin = new Chiusura_Sinistri_XLS__c();
        Map<String, Sinistro_Assicurativo__c> mapSx = new Map<String, Sinistro_Assicurativo__c>();
        
        for(KeySinistro ks1 :listkey){
                
            chiuSin = ks1.chiuSin;

            if(ks1.sinistro == null){ //NULL da CENSIRE
                System.debug('---------------------------------------------------------------------------------------');
                System.debug('-- Class Name: CRMBatChiudiSinistroFirst - Method Name: execute'); 
                System.debug('-- Instanzio il sinistro e lo censisco');
				censisciAccount(ks1);
                if (chiuSin.Tipo__c == 'ALICO'){
                    System.debug('-- chiuSin.Tipo__c == ALICO');
                    if(ks1.acc != null){
                        // recuperadataapprovazione
                      
                        sDataApprovazione = getDataApprovazione(ks1.NumeroPratica,tipPra);
                        System.debug('-- ks1.acc != null '+sDataApprovazione);
                        System.debug('-- ks1.chiuSin.Cognome__c == ks1.Acc.LastName '+ks1.chiuSin.Cognome__c +'-'+ ks1.Acc.LastName);
                        if(ks1.chiuSin.Cognome__c == ks1.Acc.LastName){
                            //CENSISCO IL SINISTRO
                            System.debug('-- CENSISCO IL SINISTRO');
                            ks1.cas.Status = 'Sospeso';
                            ks1.Cas.Tipo_Pratica__c = tipPra;
                            ks1.Cas.NumeroPratica__c = ks1.NumeroPratica;

                            ks1.sinistro = new Sinistro_Assicurativo__c();
                          
                            ks1.Sinistro.Anomalia__c = ks1.chiuSin.descScartoOCS__c;
                            ks1.Sinistro.Data_Elaborazione__c =ks1.chiuSin.DataCaricamento__c;
                            ks1.Sinistro.Data_Erogazione__c =ks1.chiuSin.DataDefinizione__c;
                            ks1.Sinistro.Data_Primo_Utilizzo__c = null;
                            ks1.Sinistro.Luogo_Elaborazione__c = null;
                            ks1.Sinistro.Polizza__c = null;
                            ks1.Sinistro.Rata__c = null;
                            ks1.Sinistro.Saldo_Residuo__c = null;
                            ks1.Sinistro.Compagnia__c = ks1.chiuSin.Tipo__c;
                            ks1.Sinistro.Data_Sinistro__c =ks1.chiuSin.DataDenuncia__c;
                            ks1.Sinistro.Tipologia_Sinistro__c = ks1.chiuSin.garanzia__c;
                            ks1.Sinistro.Flag_err__c = false;
                            ks1.Sinistro.Coda__c = '84';
                            ks1.Sinistro.Data_Inizio_Copertura__c = date.valueOf(sDataApprovazione.mid(0,4)+'-'+sDataApprovazione.mid(4,2)+'-'+sDataApprovazione.mid(6,2));

                        }else{
                            System.debug('-- pratica associata a cliente diverso in OCS');
                            chiuSin.statoRecord__c = 1;
                            chiuSin.descScartoOCS__c = 'Pratica associata a cliente diverso in OCS';
                            updchiu.add(chiuSin);
                        }
                    }else{
                        System.debug('-- ks1.acc != null ');
                        System.debug('-- pratica non trovata in OCS');
                        chiuSin.statoRecord__c = 1;
                        chiuSin.descScartoOCS__c = 'Pratica non trovata in OCS';
                        updchiu.add(chiuSin);
                    }
                    
                }else if(chiuSin.Tipo__c == 'CARDIF'){
                    System.debug('CARDIF');
                    censisciAccountCARDIF(ks1);
                    if(ks1.acc != null){
                        // recuperadataapprovazione
                        sDataApprovazione = getDataApprovazione(ks1.NumeroPratica,tipPra);
                        if(ks1.chiuSin.Beneficiario__c == '(COMPASS SPA)'){
                            chiuSin.statoRecord__c = 1;
                            chiuSin.descScartoOCS__c = 'Indennizzo liquidato a Compass ma beneficiario è il Cliente';
                            updchiu.add(chiuSin);
                        }else{
                            if(ks1.chiuSin.Cognome__c == ks1.Acc.LastName){
                                //CENSISCO IL SINISTRO
                                ks1.cas.Status = 'Sospeso';
                                ks1.Cas.Tipo_Pratica__c = tipPra;
                                ks1.Cas.NumeroPratica__c = ks1.NumeroPratica;
                                
                                ks1.Sinistro.Anomalia__c = ks1.chiuSin.descScartoOCS__c;
                                ks1.Sinistro.Data_Elaborazione__c =ks1.chiuSin.DataCaricamento__c;
                                ks1.Sinistro.Data_Erogazione__c =ks1.chiuSin.DataDefinizione__c;
                                ks1.Sinistro.Data_Primo_Utilizzo__c = null;
                                ks1.Sinistro.Luogo_Elaborazione__c = null;
                                ks1.Sinistro.Polizza__c = null;
                                ks1.Sinistro.Rata__c = null;
                                ks1.Sinistro.Saldo_Residuo__c = null;
                                ks1.Sinistro.Compagnia__c = ks1.chiuSin.Tipo__c;
                                ks1.Sinistro.Data_Sinistro__c =ks1.chiuSin.DataDenuncia__c;
                                ks1.Sinistro.Tipologia_Sinistro__c = ks1.chiuSin.garanzia__c;
                                ks1.Sinistro.Flag_err__c = false;
                                ks1.Sinistro.Coda__c = '84';
                                ks1.Sinistro.Data_Inizio_Copertura__c = date.valueOf(sDataApprovazione.mid(0,4)+'-'+sDataApprovazione.mid(4,2)+'-'+sDataApprovazione.mid(6,2));
                                
                            }else{
                                chiuSin.statoRecord__c = 1;
                                chiuSin.descScartoOCS__c = 'Pratica associata a cliente diverso in OCS';
                                updchiu.add(chiuSin);
                            }
                        }
                    }else{
                        chiuSin.statoRecord__c = 1;
                        chiuSin.descScartoOCS__c = 'Pratica non trovata in OCS';
                        updchiu.add(chiuSin);
                    }
                }     
            }
        }
        System.debug('----------------------------------------------------------------------------------');
        System.debug('-- Class Name: CRMBatChiudiSinistriFirst  - Method Name : execute'); 
        System.debug('-- Stampo sx dopo averli censiti');
        for(Integer i=0 ;i<listKey.size();){
            if (listKey[i].sinistro==null) listKey.remove(i);
            else i++;
        }
//        if(true)throw new BorisException('AAAAAAA');
        
        
 		List<Account> updAcc = new List<Account>();
 		List<Case> updCas = new List<Case>();
 		List<Sinistro_Assicurativo__c> updSin = new List<Sinistro_Assicurativo__c>();
        
        Map<Account, Account> mappa = new Map<Account, Account>();
        
        
        for(KeySinistro ks:listKey){
            if(!String.isBlank(ks.Acc.LastName)){
                mappa.put(ks.Acc,null);
            }
        }
        Set <Account> kSet = new Set<Account>();
        kSet = mappa.keySet();

        System.debug('-- kSet.size -->' + kSet.size() + kSet);

        if(kSet.size()>0){
            XCSGestioneAnagrafica.deduplica(mappa, true);
        }
//        Map<String,Case> mCas = new Map<String,Case>();

        for(KeySinistro ks:listKey){
            ks.cas.AccountId = ks.acc.Id;
            updCas.add(ks.cas);
//            mcas.put(ks.ident,ks.cas);
        }
        
        if(updcas.size()>0)
//            insert mcas.values();
        	upsert updcas;
        
//        for(KeySinistro ks:listKey) ks.cas=mcas.get(ks.ident);
        
        
        for(KeySinistro ks:listKey){
            system.debug(ks.cas);
        }
        
        
        for(KeySinistro ks:listKey){
            system.debug(ks.sinistro);
            if(String.isBlank(ks.sinistro.caseId__c)){
                ks.sinistro.caseId__c = ks.cas.id;
            }
            updSin.add(ks.sinistro);
        }
        if(updSin.size()>0)
        	upsert updSin;

		update updchiu;        
    }

    global void finish(Database.BatchableContext bc){

        System.debug('-- TERMINE BATCH FIRST --');
        Database.executeBatch(new CRMBatChiudiSinistroSecond(), 200);
        
//        CRMBatChiudiSinistroSecond chiudiSinistro = new CRMBatChiudiSinistroSecond();
//        chiudiSinistro.execute();
    }

    global void execute(SchedulableContext sc) {
        CRMBatChiudiSinistroFirst b = new CRMBatChiudiSinistroFirst();
        database.executebatch(b);
    }

    public class KeySinistro{
       
        public String ident;
        public String tipoSinistro;
        public String numeroPratica;
        public Date dataSinistro;
        public String sAcc;
    	public Chiusura_Sinistri_XLS__c chiuSin;
 		public Sinistro_Assicurativo__c sinistro;
        public Account acc;
        public Case cas;
        
        public KeySinistro(String ident, String tipoSinistro, String numeroPratica, Date dataSinistro, Chiusura_Sinistri_XLS__c chiuSin){
            this.ident = ident;
            this.tipoSinistro = tipoSinistro;
            this.numeroPratica = numeroPratica;
            this.dataSinistro = dataSinistro;
            this.chiuSin = chiuSin;
            acc = new Account();
            cas = new Case();
        }
        
        public override String toString(){
             return ident+ ': ChiusuraSx '+chiuSin+' - Sinistro_Assic'+sinistro+' - Account'+acc +' - Case '+cas;
           // return ident+ ' - '+chiuSin.contratto__c+' - '+sinistro.coda__c +' - '+acc.FirstName+' - '+cas.numeroPratica__c;
        }
    }
 
    public void censisciAccount(KeySinistro ks){
        
        System.debug('---------------------------------------------------------------------------------------');
        System.debug('-- Class Name: CRMBatChiudiSinistroFirst - Method Name: censisciAccount'); 

        OCSRecuperaDatiPostVenditaResponse datiPostVendita;
        
        OCSRecuperaDatiPostvenditaRequest request=new OCSRecuperaDatiPostvenditaRequest();
        request.numPratica=ks.NumeroPratica;
        request.flagInfoCliente='';
        request.filtroTipoPratica='';
        request.codCliente='';
        request.cognomeCliente='';
        request.nomeCliente='';
        request.dataNascitaCliente='';
        request.codFiscaleCliente='';
        request.pan='';
        request.telefonoCliente='';
        request.faxCliente='';
        request.emailCliente='';
        request.provinciaCliente='';
        request.ragioneSociale='';
        
        datiPostVendita = OCSRecuperaDatiPostVenditaInvoker.callRecdatiPV(request);
        
        Account a = new Account();
        
        System.debug('-------DATI POST VENDITA-------');
        System.debug(datiPostVendita);

        if (datiPostVendita.cliente != null && datiPostVendita.cliente.size()>0){
            
            a.FirstName = datiPostVendita.cliente[0].nome;
            a.LastName = datiPostVendita.cliente[0].cognome;
            a.Codice_Cliente__c = datiPostVendita.cliente[0].codCliente;
            String sData = datiPostVendita.cliente[0].dataNascita;
            a.Data_Nascita__c = Date.valueOf(sData.mid(0, 4)+'-'+sData.mid(4, 2)+'-'+sData.mid(6, 2));
            a.Luogo_Nascita__pc = datiPostVendita.cliente[0].luogoNascita;
			a.Provincia_Nascita__pc = datiPostVendita.cliente[0].provNascita;
            a.Sesso__pc = datiPostVendita.cliente[0].sesso;
            a.Codice_Fiscale__pc = datiPostVendita.cliente[0].nome;
			a.PersonEmail = datiPostVendita.cliente[0].email;
            
            tipPra = datiPostVendita.pratiche[0].tipoPratica;
            
            ks.acc = a;
            
        }else{
            ks.acc = null;
        }
    }
    
    public String getDataApprovazione(String numPratica, String tipoPratica){
        system.debug('---------------------------------------------------------------------------------------');
        system.debug('-- Class Name: CRMBatChiudiSinistroFirst - Method Name: getDataApprovazione'); 
        OCSRecuperaDataApprovazioneResponse dataApprovazione;
        String dataApp;
        OCSRecuperaDataApprovazioneRequest reqdata=new OCSRecuperaDataApprovazioneRequest();
        reqdata.recuperaDataApprovazioneRequest.numPratica=numPratica;
        reqdata.recuperaDataApprovazioneRequest.tipoPratica=tipoPratica;
//        dataApprovazione = OCSRecuperaDataApprovazioneInvoker.invoke(reqdata); 
        dataApprovazione = OCSRecuperaDataApprovazioneInvoker.invoke(tipoPratica, numPratica); 
//        dataApp = dataApprovazione.RecuperaDataApprovazioneResponseDTO.dataApprovazione;
        dataApp = dataApprovazione.RecuperaDataApprovazioneResponse.dataApprovazione;
		return dataApp;
    }

    public void censisciAccountCARDIF(KeySinistro ks){
        system.debug('---------------------------------------------------------------------------------------');
        system.debug('-- Class Name: CRMBatChiudiSinistroFirst - Method Name: censisciAccountCARDIF'); 
        
        List<OCSRecuperaPraticheAssicurateResponse.PraticaAssicurataDTO> res;
        res = (List<OCSRecuperaPraticheAssicurateResponse.PraticaAssicurataDTO>) JSON.deserialize(SinistriAssicurativiCtrl.recuperaAnagraficaWS('', '', '', '', ks.NumeroPratica,'', '', ''), List<OCSRecuperaPraticheAssicurateResponse.PraticaAssicurataDTO>.class);
        
        Account a = new Account();
        
        if (res != null && res.size()>0){
            a.FirstName = res[0].nome;
            a.LastName = res[0].cognome;
            a.Codice_Cliente__c = res[0].codCliente;
            String sData = res[0].dataNascita;
            a.Data_Nascita__c = Date.valueOf(sData.mid(0, 4)+'-'+sData.mid(4, 2)+'-'+sData.mid(6, 2));
            a.Luogo_Nascita__pc = res[0].luogoNascita;
            a.Codice_Fiscale__pc = res[0].nome;
            tipPra = res[0].tipoPratica;
            ks.acc = a;
        }else{
            ks.acc = null;
        }
    }

}