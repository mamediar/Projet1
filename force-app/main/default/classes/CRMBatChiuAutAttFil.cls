//----------------------------------------------------------------------
//-- - Class Name   : CRMBatChiuAutAttFil
//-- - Autor        : Fabio Giuliani(Lynx)
//-- - Date         : 12/07/2019
//-- - Description  : Batch per la chiusura automatica attività filiale
//-- - Version      : 1.0
//----------------------------------------------------------------------

global class CRMBatChiuAutAttFil implements Database.Batchable<sObject>, Database.AllowsCallouts, Schedulable, Database.Stateful {

    global String query;
    global final String NOTA1 = 'Il diniego non è stato gestito dalla filiale entro i 7 giorni previsti - il sistema chiuderà il diniego come non risolto in automatico. è stata rilevata una modalità di pagamento a BP già presente';
    global final String NOTA2 = 'Il diniego non è stato gestito dalla filiale entro i 7 giorni previsti - il sistema chiuderà il diniego come non risolto in automatico. Verrà effettuata la variazione della modalità di pagamento a BP';
    global final String NOTA3 = 'Il diniego non è stato gestito dalla filiale entro i 7 giorni previsti - il sistema chiuderà il diniego come non risolto in automatico.';
 	global String notaIncident;
	global String notaOCS;
    global String as400Status;
    global String as400Errore;
    global final static String QUEUE_DINIEGHI = 'Q190';
    global XCS_Template__c noteTemplate;
    global final static String STATO_GESTITO = 'Gestito';

    private class MandatiNote {
        public ContentNote contentNote;
        public Id ident;
        public MandatiNote(Id ident, String note,String title) {
            ContentNote cn=new ContentNote();
      		cn.Title=title;
      		cn.Content=Blob.valueOf(note.escapeXML());
            this.contentNote = cn;
            this.ident = ident;
        }

    }

    
    
    private void chiudeCase_Mandati(List<Mandati_SDD__c> listMandati){
        if (listMandati!=null) {
            List<Case> listCaseUpdate = new List<Case>();
            for (Mandati_SDD__c mandato:listMandati) {
                Case caso = [SELECT ID, Status FROM Case WHERE ID=:mandato.Caseid__c];
                caso.Status = STATO_GESTITO;
                listCaseUpdate.add(caso);
            }
            update listCaseUpdate;
        }
    }

    private void aggiornaNote(List<MandatiNote> listaMandatiNote){
        List<ContentNote> listaContentNote = new List<ContentNote>();
        for(MandatiNote mandatiNote: listaMandatiNote) {
            listaContentNote.add(mandatiNote.contentNote);
		}
		insert listaContentNote;
        List<ContentDocumentLink> listaContentDocumentLink = new List<ContentDocumentLink>();
        for(MandatiNote mandatiNote: listaMandatiNote){
			ContentDocumentLink link=new ContentDocumentLink();
      		link.ContentDocumentId=mandatiNote.contentNote.id;
  //          system.debug('link.ContentDocumentId:'+link.ContentDocumentId);
      		link.LinkedEntityId=mandatiNote.ident;
      		link.ShareType='I';
     		link.Visibility='AllUsers';
            listaContentDocumentLink.add(link);
		}
		insert listaContentDocumentLink;
      
    }
    
//    global final String EXTERNALID = 'DP3505'; 

    global Database.QueryLocator start(Database.BatchableContext bc){
        noteTemplate = [SELECT Id, Name, Body__c FROM XCS_Template__c where name = 'NOTE.CRMBatChiuAutAttFil' limit 1];

        Id queueId = [SELECT Id FROM Group WHERE DeveloperName =:QUEUE_DINIEGHI LIMIT 1].Id;
		system.debug('---------------------------------------------------------------------------------------');
		system.debug('-- Class Name: CRMBatChiuAutAttFil - Method Name: start'); 

        Date date7 = date.today().adddays(-7);
        String sDate7 = String.valueof(date7);

        query = 'SELECT Id, Abi__c, Accettato__c, Attrib_Pratica__c, Cab__c, codice_cliente__c, contocorrente__c, convenzionato__c, ';
        query += 'Data_Inserimento__c, Data_invio__c, Data_rientro__c, Denominazione_banca__c, filiale__c, gruppo__c, iban__c, intestatario_cc__c, ';
        query += 'name, modalita_pagamento__c, motivo_diniego__c, Praticanum__c, Progreman__c, Progressivo__c, Ragione_Sociale_cliente__c, ';        
        query += 'ragione_sociale_intest_cc__c, Stato_mandato__c, Stato_pratica__c, telefono_banca__c, Disposition__c, tipo_messaggio__c, Caseid__c ';
        query += 'FROM Mandati_SDD__c ';
        query += 'WHERE Data_Inserimento__c <= '+sDate7;  
        // correzione Dotti
        query += ' AND Stato_Mandato__c = \''+CRMBatLoadDinieghi.STATO_RICEVUTO+'\''; 
        query += ' AND caseId__r.ownerId = \''+queueId+'\'';

		system.debug('----------------------------------------------------------------------------------');
		system.debug('-- Class Name: CRMBatChiuAutAttFil  - Method Name : start'); 
		system.debug('-- Variable Name: query  - Value: ' + query); 
        
        return Database.getQueryLocator(query);

    }

    global void execute(Database.BatchableContext bc, List<Mandati_SDD__c> mandatiList){
		system.debug('---------------------------------------------------------------------------------------');
		system.debug('-- Class Name: CRMBatChiuAutAttFil - Method Name: execute'); 
		
        RecordType rt = [Select id from RecordType where DeveloperName = 'Note' and SobjectType = 'XCS_Messaggio__c' ];
		system.debug('-- Variable Name: rt  - Value: ' + rt); 
        

        XCS_Disposition__c disp =XCS_DispositionUtils.findDispositionByExternalID('DP3505');

        
		system.debug('-- Variable Name: disp.Id  - Value: ' + disp.Id); 
        
        List<Mandati_SDD__c> updList = new List<Mandati_SDD__c>();
        List<MandatiNote> listaMandatiNote = new List<MandatiNote>();
            
        for (Mandati_SDD__c m : mandatiList) {
             XCS_Template__c notaTemp = noteTemplate.clone();

            // MEMORIZZO L'ESITO "Chiusura/variazione BP" // Inserito un campo nuovo nell'oggetto Mandati_SDD__c - Disposition__c che è 
            // una lookup verso XCS_Disposition__c  'Chiusura/variazione BP';
            m.Disposition__c = disp.Id;
            
            m.Stato_Mandato__c = STATO_GESTITO;

            
            notaTemp.Body__c =notaTemp.Body__c.replace('{numeroMandato}', m.ProgreMan__c);
            notaTemp.Body__c =notaTemp.Body__c.replace('{tipoPratica}', m.Tipo_Messaggio__c);
            notaTemp.Body__c =notaTemp.Body__c.replace('{numPratica}', m.PraticaNum__c);

            notaIncident='';
            if(m.Tipo_Messaggio__c!='CA'){  
	            //set della request
                OCSVariazioneDatiPagamentoRequest req = new OCSVariazioneDatiPagamentoRequest();
                req.VariazioneDatiPagamentoRequest.provenienza = m.Tipo_Messaggio__c;
                req.VariazioneDatiPagamentoRequest.tipoIntermediario = '';
                req.VariazioneDatiPagamentoRequest.intermediario = '';
                req.VariazioneDatiPagamentoRequest.procedura = m.Tipo_Messaggio__c;
                req.VariazioneDatiPagamentoRequest.numPratica = m.PraticaNum__c;
                req.VariazioneDatiPagamentoRequest.pagForma = m.Modalita_Pagamento__c;
                req.VariazioneDatiPagamentoRequest.ecFrequenza = '';
                req.VariazioneDatiPagamentoRequest.abi = m.Abi__c;
                req.VariazioneDatiPagamentoRequest.cab = m.Cab__c ;
                req.VariazioneDatiPagamentoRequest.cc = m.ContoCorrente__c ;
                req.VariazioneDatiPagamentoRequest.cinBban = '';
                req.VariazioneDatiPagamentoRequest.cinIban = '';
                req.VariazioneDatiPagamentoRequest.paeseIban = '';
                req.VariazioneDatiPagamentoRequest.iban = m.Iban__c ;
                req.VariazioneDatiPagamentoRequest.intCc = m.Intestatario_cc__c;
                req.VariazioneDatiPagamentoRequest.intestConto = '';
                req.VariazioneDatiPagamentoRequest.codiceRid = '';
                req.VariazioneDatiPagamentoRequest.firmaSuRid = '';
                req.VariazioneDatiPagamentoRequest.bancaInterna = '';
                req.VariazioneDatiPagamentoRequest.pagGGValuta = '';
                req.VariazioneDatiPagamentoRequest.lettera = '';
                req.VariazioneDatiPagamentoRequest.tipoContatto = '';
                req.VariazioneDatiPagamentoRequest.ammin = '';
                req.VariazioneDatiPagamentoRequest.dataIniziale = '';
                req.VariazioneDatiPagamentoRequest.variazScadRata = '';
                req.VariazioneDatiPagamentoRequest.speseIncasso = '';
                req.VariazioneDatiPagamentoRequest.speseIncFlg = '';
                req.VariazioneDatiPagamentoRequest.codiceRifExt2 = '';
                req.VariazioneDatiPagamentoRequest.utente = '';
                req.VariazioneDatiPagamentoRequest.pan = '';
                req.VariazioneDatiPagamentoRequest.lunghezzaPan = '';
                req.VariazioneDatiPagamentoRequest.dataScadenza = '';

                OCSVariazionedatiPagamentoResponse varDatiPagamento;

                varDatiPagamento = OCSVariazioneDatiPagamentoInvoker.callVariazioneDatiPagamento(req);
                // correzione Dotti 
                as400Status = varDatiPagamento.variazioneDatiPagamentoResponse.AS400Status;
                as400Errore = varDatiPagamento.variazioneDatiPagamentoResponse.AS400Errore;
                
                m.Modalita_Pagamento__c = 'BP';
                //CONTROLLO CODE RESPONSE
                
                if (varDatiPagamento.resultCode == 0){
                    // CONTROLLO MESSAGGIO DI STATUS
                    if(as400Status == 'KO'){
                        // CONTROLLO MESSAGGIO DI ERRORE
                        if(as400Errore.contains('6316') || as400Errore.contains('5907')){
                            //non segnalo errore
                            system.debug('NON SEGNALO ERRORE');
                        }
                        if(as400Errore.contains('6316')){
                            notaIncident = NOTA1;
                        }else{
                        	notaIncident = NOTA2;
                        }
                    }
                }
                
            }else{
				notaIncident = NOTA3;
            }
            
            notaTemp.Body__c =notaTemp.Body__c.replace('{messaggio}',notaIncident);
            notaOCS = notaTemp.Body__c;
            
			listaMandatiNote.add(new MandatiNote(m.id,notaTemp.Body__c,'Chiusura Automatica Attività Filiale'));
		            
            String strUserAlias = [select Alias from User where Id=:UserInfo.getUserId()].Alias;
            if (!Test.isRunningTest()) {
                OCSGestioneNoteInvoker.gestioneNote(strUserAlias, m.Codice_Cliente__c, m.PraticaNum__c, m.Tipo_Messaggio__c, 'A','P',notaOCS ); // SCRIVO NOTA OCS 
            }
           
            system.debug('Disposition --> '+ m.Disposition__c);
            system.debug('Stato --> '+ m.Stato_Mandato__c);
            System.debug('NotaIncident --> '+notaIncident);
            
            updList.add(m); // AGGIUNGO LISTA DINIEGO DA AGGIORNARE
            
    	}

        update(updList); // AGGIORNO DINIEGO
        chiudeCase_Mandati(updList);  // chiude Cases
      	aggiornaNote(listaMandatiNote);
    }
    global void finish(Database.BatchableContext bc){
		system.debug('---------------------------------------------------------------------------------------');
		system.debug('-- Class Name: CRMBatChiuAutAttFil - Method Name: finish'); 

        CRMBatChiuAutAttFil sch = new CRMBatChiuAutAttFil();
        // correzione Dotti expression CRON
        String CRON = '0 50 8 * * ?';
        if (!Test.isRunningTest()) {
            String nomeJob = 'Chiusura Automatica Attivita Filiale '+(system.today()+1);
            List<CronTrigger> cronTrigger = [SELECT Id, CronJobDetail.Name FROM CronTrigger WHERE  CronJobDetail.Name =:nomeJob];
            if (cronTrigger==null) {
                System.Schedule(nomeJob, CRON, sch);
            }
        }

        
    }

    global void execute(SchedulableContext sc) {
		system.debug('---------------------------------------------------------------------------------------');
		system.debug('-- Class Name: CRMBatChiuAutAttFil - Method Name: execute x richiamo'); 

        Type t = Type.forName('CRMBatChiuAutAttFil');
        Database.Batchable<sObject> batchClass = ((Database.Batchable<sObject>) t.newInstance());
        database.executebatch(batchClass, 200);
    }

    //costruisce response mock per recuperaPraticheAssicurate
    public OCSVariazioneDatiPagamentoResponse buildMockVarDatiPagResp() {

        system.debug('---------------------------------------------------------------------------------------');
        system.debug('-- Class Name: CRMBatChiuAutAttFil - Method Name: buildMockVarDatiPagResp');

        OCSVariazioneDatiPagamentoResponse resp = new OCSVariazioneDatiPagamentoResponse();
        OCSVariazioneDatiPagamentoResponse.variazioneDatiPagamentoResponseDTO varDatiPag = new OCSVariazioneDatiPagamentoResponse.variazioneDatiPagamentoResponseDTO();

        varDatiPag.AS400Status = 'test';
        varDatiPag.AS400Errore = 'test';
        resp.resultCode = 0;
        
        return resp;
    }

}