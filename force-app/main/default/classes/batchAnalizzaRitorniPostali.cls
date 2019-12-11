global class batchAnalizzaRitorniPostali implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {
    
    global final String EMPTY_STRING = '';
    global List<String> elencoLetterID = new List<String>();
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'Select Id, C_id__c, LetterId__c, LetterTypeId__c, ReturnedReason__c, ReturnedDate__c, OCSAnag__c, FlagResoMacero__c, OriginalAddress__c, OriginalCap__c, OriginalCity__c, OriginalProv__c, NewAddress__c, NewCap__c, FlagFornitore__c, NewCity__c, NewProv__c, Branch_id__c, LetterTypeCode__c, FlagBranchViewed__c, LoanNumber__c,OcsUpdated__c, LoanType__c, FlagNeedBranchCall__c, TipoPagamento__c, SmsSent__c, CellPhone__c,Cognome__c, Nome__c, SentDate__c, SentAddress__c, SentCap__c, SentCity__c, SentProv__c, OriginalAddressDate__c,Processato__c from RitorniPostali__c where Processato__c = 0 ';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<RitorniPostali__c> ritorniDaProcessare) {
        
        if (ritorniDaProcessare.size() > 0) {
            
            String strUserAlias = [select Alias from User where Id=:UserInfo.getUserId()].Alias;
            RecordType rt = [Select id from RecordType where DeveloperName = 'Note' and SobjectType = 'XCS_Messaggio__c' ];            
            List<XCS_Messaggio__c> listaOCSNote = new List<XCS_Messaggio__c>();
            Map<String, RitorniPostali__c> serviceMapRitorni = new Map<String, RitorniPostali__c>();
            Map<String, Case> serviceMapCase = new Map<String, Case>();
            Map<String, List<RitorniPostali__c>> serviceMapRitorniCheckPregresso = new Map<String, List<RitorniPostali__c>>();           
            Map<String, String> serviceNoteCase = new Map<String, String>();            
            String strRecordTypeID = RecordTypeUtil.getCaseRecordType(RitorniPostaliUtils.RITORNI_POSTALI_RECORD_TYPE);
            
            //mappa code
            Map<String, Id> mapQueue = new Map<String, Id>();
            mapQueue.put(RitorniPostaliUtils.QUEUE_95, GroupUtils.getQueue(RitorniPostaliUtils.QUEUE_95).id);
            mapQueue.put(RitorniPostaliUtils.QUEUE_85, GroupUtils.getQueue(RitorniPostaliUtils.QUEUE_85).id);
            mapQueue.put(RitorniPostaliUtils.QUEUE_RITORNI_POSTALI_VERIFICA_INDIRIZZO, GroupUtils.getQueue(RitorniPostaliUtils.QUEUE_RITORNI_POSTALI_VERIFICA_INDIRIZZO).id);
            
            //mappa account
            Map<String, Id> mapAccount = new Map<String, Id>();
            List<String> listOCSAnagID = new List<String>();
            for(RitorniPostali__c ritorno : ritorniDaProcessare) {
                if (!(String.isEmpty(ritorno.OCSAnag__c))) {
                    listOCSAnagID.add(AccountUtils.OCSCustomerChar + ritorno.OCSAnag__c);
                    
                }
            }           
            if (!(listOCSAnagID.isEmpty())) {
                mapAccount = AccountUtils.findAccountsByExtOCSListID(listOCSAnagID);
            }
            
            //mappa ritorni pregressi
            Map<String, List<RitorniPostali__c>> previousLetterMap = new Map<String, List<RitorniPostali__c>>();
            retrievePreviousLetterMap(previousLetterMap, mapQueue);
            integer x = 1;
            for (String strValue : previousLetterMap.Keyset()) {
                System.debug(x + ' OCS code : ' + strValue + ' - num ritorni pregressi : ' + previousLetterMap.get(strValue).size());
                x++;
            }
            
            //mappa categorie
            Map<String, Id> mapCategory = new Map<String, Id>();            
            mapCategory.put(RitorniPostaliUtils.CAT_ALTRI_SCARTI, XCS_CategoriaUtil.findCategoryByExternalID(RitorniPostaliUtils.CAT_ALTRI_SCARTI).Id);
            mapCategory.put(RitorniPostaliUtils.CAT_INVIO_COPIA, XCS_CategoriaUtil.findCategoryByExternalID(RitorniPostaliUtils.CAT_INVIO_COPIA).Id);
            mapCategory.put(RitorniPostaliUtils.CAT_INVIO_ORIGINALE, XCS_CategoriaUtil.findCategoryByExternalID(RitorniPostaliUtils.CAT_INVIO_ORIGINALE).Id);
            mapCategory.put(RitorniPostaliUtils.CAT_NO_CONTATTO, XCS_CategoriaUtil.findCategoryByExternalID(RitorniPostaliUtils.CAT_NO_CONTATTO).Id);
            
            //mappa esiti
            Map<String, Id> mapDisposition = new Map<String, Id>();
            mapDisposition.put(RitorniPostaliUtils.ESITO_DA_NON_CONTATTARE, XCS_DispositionUtils.findDispositionByExternalID(RitorniPostaliUtils.ESITO_DA_NON_CONTATTARE).Id);
            mapDisposition.put(RitorniPostaliUtils.ESITO_ATTESA_DOC_POSTE, XCS_DispositionUtils.findDispositionByExternalID(RitorniPostaliUtils.ESITO_ATTESA_DOC_POSTE).Id);
            mapDisposition.put(RitorniPostaliUtils.ESITO_NEGATIVO_GENERICO, XCS_DispositionUtils.findDispositionByExternalID(RitorniPostaliUtils.ESITO_NEGATIVO_GENERICO).Id);                       
            
            //list lettere dealer
            List<String> listLettereDealer = new List<String>();
            List<RitorniPostaliLettereDealer__mdt> lettereDealer = [Select LetterTypeCode__c from RitorniPostaliLettereDealer__mdt];
            if (!(lettereDealer.isEmpty())) {
                for (RitorniPostaliLettereDealer__mdt letteraDealer : lettereDealer) {
                    listLettereDealer.add(letteraDealer.LetterTypeCode__c);
                }
            } else {
                throw new UnexpectedException('Attenzione! Mancano i record di configurazione della tabella metadatatype RitorniPostaliLettereDealer__mdt');
            }
            
            for (RitorniPostali__c ritorno : ritorniDaProcessare) {
                String strInternalCustomerID = ritorno.C_id__c;
                String strExternalCustomerID = ritorno.OCSAnag__c;
                String strFlagResoMacero = ritorno.FlagResoMacero__c;
                String strCausaleRitorno = ritorno.ReturnedReason__c;
                
                Boolean isLetteraDealer = (listLettereDealer.contains(ritorno.LetterTypeCode__c))? true : false;
                
                if (RitorniPostaliUtils.LETTER_TYPE_WEL.equalsIgnoreCase(ritorno.LetterTypeId__c)) {
                    //tipo lettera WELCOME                  	
                    //verifica presenza codice OCS cliente, se il valore non è presente...
                    if (String.isEmpty(strExternalCustomerID)) {
                        
                        Map<String,String> params = new map<String,String>();
                        params.put('Subject', RitorniPostaliUtils.RITORNI_POSTALI_DEFAULT_CASE_SUBJECT);
                        //params.put('OwnerId', Null);  
                        params.put('RecordTypeId', strRecordTypeID);
                        params.put('Status', CaseUtils.CHIUSO);
                        params.put('Disposition__c', mapDisposition.get(RitorniPostaliUtils.ESITO_DA_NON_CONTATTARE));                        
                        String strAccountID = AccountUtils.getAccount(AccountUtils.PADummyCode).Id;
                        params.put('AccountId', strAccountID);
                        String strCatId = mapCategory.get(RitorniPostaliUtils.CAT_ALTRI_SCARTI);
                        params.put('Categoria_Riferimento__c', strCatId);
                        params.put('Tipo_Pratica__c', ritorno.LoanType__c);
                        params.put('NumeroPratica__c', ritorno.LoanNumber__c);   
                        
                        ritorno.C_id__c = strAccountID;
                        ritorno.CatId__c = strCatId;                      	
                        ritorno.Processato__c = 1;
                        
                        serviceMapRitorni.put(ritorno.Id, ritorno);
                        serviceMapCase.put(ritorno.Id, CaseUtils.createCaseRitornoPostale(params));
                        
                        String strNotaCase = 'Ritorno Postale \n';
                        strNotaCase += 'Cliente: ' + ritorno.OCSAnag__c + ' - ' + ritorno.Nome__c + ' ' + ritorno.Cognome__c + '\n';
                        strNotaCase += 'Pratica: ' + ritorno.LoanNumber__c + ' - ' + ritorno.LoanType__c + ' - ' + ritorno.TipoPagamento__c + '\n';
                        strNotaCase += 'Filiale: ' + ritorno.Branch_id__c + '\n';
                        strNotaCase += 'Codice Lettera: ' + ritorno.LetterId__c + '\n';
                        strNotaCase += 'Tipo Lettera: ' + ritorno.LetterTypeId__c + '\n';
                        strNotaCase += 'Motivo Ritorno: ' + ritorno.ReturnedReason__c + '\n';
                        strNotaCase += 'Operazione da eseguire: Altri scarti \n';
                        serviceNoteCase.put(ritorno.id, strNotaCase);                     
                        
                        elencoLetterID.add(ritorno.LetterId__c);
                        
                    } else {
                        
                        //verifica indirizzo origine e spedizione se è uguale a indirizzo compass
                        if (((RitorniPostaliUtils.COMPASS_LOCALITA.equalsIgnoreCase(ritorno.OriginalCity__c)) &&
                             (RitorniPostaliUtils.COMPASS_ADDRESS.equalsIgnoreCase(ritorno.OriginalAddress__c))) ||
                            ((RitorniPostaliUtils.COMPASS_LOCALITA.equalsIgnoreCase(ritorno.SentCity__c)) &&
                             (RitorniPostaliUtils.COMPASS_ADDRESS.equalsIgnoreCase(ritorno.SentAddress__c)))) {
                                 
                                 Map<String,String> params = new map<String,String>();
                                 params.put('Subject', RitorniPostaliUtils.RITORNI_POSTALI_DEFAULT_CASE_SUBJECT);                      
                                 params.put('RecordTypeId', strRecordTypeID);
                                 params.put('Status', CaseUtils.CHIUSO);
                                 params.put('Disposition__c', mapDisposition.get(RitorniPostaliUtils.ESITO_DA_NON_CONTATTARE));
                                 String strAccountID = mapAccount.get(AccountUtils.OCSCustomerChar + ritorno.OCSAnag__c);
                                 params.put('AccountId', strAccountID);
                                 String strCatId = mapCategory.get(RitorniPostaliUtils.CAT_ALTRI_SCARTI);
                                 params.put('Categoria_Riferimento__c', strCatId);
                                 params.put('Tipo_Pratica__c', ritorno.LoanType__c);
                                 params.put('NumeroPratica__c', ritorno.LoanNumber__c);   
                                 
                                 ritorno.C_id__c = strAccountID;
                                 ritorno.CatId__c = strCatId;                      	
                                 ritorno.Processato__c = 1;
                                 
                                 serviceMapRitorni.put(ritorno.Id, ritorno);
                                 serviceMapCase.put(ritorno.Id, CaseUtils.createCaseRitornoPostale(params));
                                 
                                 String strNotaCase = 'Ritorno Postale \n';
                                 strNotaCase += 'Cliente: ' + ritorno.OCSAnag__c + ' - ' + ritorno.Nome__c + ' ' + ritorno.Cognome__c + '\n';
                                 strNotaCase += 'Pratica: ' + ritorno.LoanNumber__c + ' - ' + ritorno.LoanType__c + ' - ' + ritorno.TipoPagamento__c + '\n';
                                 strNotaCase += 'Filiale: ' + ritorno.Branch_id__c + '\n';
                                 strNotaCase += 'Codice Lettera: ' + ritorno.LetterId__c + '\n';
                                 strNotaCase += 'Tipo Lettera: ' + ritorno.LetterTypeId__c + '\n';
                                 strNotaCase += 'Motivo Ritorno: ' + ritorno.ReturnedReason__c + '\n';
                                 strNotaCase += 'Operazione da eseguire: Altri scarti \n';
                                 serviceNoteCase.put(ritorno.id, strNotaCase);                       	
                                 
                                 elencoLetterID.add(ritorno.LetterId__c);
                                 
                             } else if(RitorniPostaliUtils.FLAG_FORNITORE_S.equalsIgnoreCase(ritorno.FlagFornitore__c)) {
                                 
                                 Map<String,String> params = new map<String,String>();
                                 params.put('Subject', RitorniPostaliUtils.RITORNI_POSTALI_DEFAULT_CASE_SUBJECT); 
                                 params.put('RecordTypeId', strRecordTypeID);
                                 params.put('Status', CaseUtils.CHIUSO);
                                 params.put('Disposition__c', mapDisposition.get(RitorniPostaliUtils.ESITO_DA_NON_CONTATTARE));
                                 String strAccountID = mapAccount.get(AccountUtils.OCSCustomerChar + ritorno.OCSAnag__c);
                                 params.put('AccountId', strAccountID);
                                 String strCatId = mapCategory.get(RitorniPostaliUtils.CAT_ALTRI_SCARTI);
                                 params.put('Categoria_Riferimento__c', strCatId);
                                 params.put('Tipo_Pratica__c', ritorno.LoanType__c);
                                 params.put('NumeroPratica__c', ritorno.LoanNumber__c);   
                                 
                                 ritorno.C_id__c = strAccountID;
                                 ritorno.CatId__c = strCatId;                      	
                                 ritorno.Processato__c = 1;
                                 
                                 serviceMapRitorni.put(ritorno.Id, ritorno);
                                 serviceMapCase.put(ritorno.Id, CaseUtils.createCaseRitornoPostale(params));
                                 
                                 String strNotaCase = 'Ritorno Postale \n';
                                 strNotaCase += 'Cliente: ' + ritorno.OCSAnag__c + ' - ' + ritorno.Nome__c + ' ' + ritorno.Cognome__c + '\n';
                                 strNotaCase += 'Pratica: ' + ritorno.LoanNumber__c + ' - ' + ritorno.LoanType__c + ' - ' + ritorno.TipoPagamento__c + '\n';
                                 strNotaCase += 'Filiale: ' + ritorno.Branch_id__c + '\n';
                                 strNotaCase += 'Codice Lettera: ' + ritorno.LetterId__c + '\n';
                                 strNotaCase += 'Tipo Lettera: ' + ritorno.LetterTypeId__c + '\n';
                                 strNotaCase += 'Motivo Ritorno: ' + ritorno.ReturnedReason__c + '\n';
                                 strNotaCase += 'Operazione da eseguire: Altri scarti \n';
                                 serviceNoteCase.put(ritorno.id, strNotaCase);                       	
                                 
                                 elencoLetterID.add(ritorno.LetterId__c);
                                 
                             } else if (isLetteraDealer) {
                                 
                                 Map<String,String> params = new map<String,String>();
                                 params.put('Subject', RitorniPostaliUtils.RITORNI_POSTALI_DEFAULT_CASE_SUBJECT);                          
                                 params.put('OwnerId', mapQueue.get(RitorniPostaliUtils.QUEUE_95));  
                                 params.put('RecordTypeId', strRecordTypeID);
                                 params.put('Status', CaseUtils.APERTO);
                                 params.put('Disposition__c', mapDisposition.get(RitorniPostaliUtils.ESITO_DA_NON_CONTATTARE));
                                 String strAccountID = mapAccount.get(AccountUtils.OCSCustomerChar + ritorno.OCSAnag__c);
                                 params.put('AccountId', strAccountID);
                                 String strCatId = mapCategory.get(RitorniPostaliUtils.CAT_ALTRI_SCARTI);
                                 params.put('Categoria_Riferimento__c', strCatId);
                                 params.put('Tipo_Pratica__c', ritorno.LoanType__c);
                                 params.put('NumeroPratica__c', ritorno.LoanNumber__c);
                                 
                                 ritorno.C_id__c = strAccountID;
                                 ritorno.CatId__c = strCatId;                      	
                                 ritorno.Processato__c = 1;
                                 
                                 serviceMapRitorni.put(ritorno.Id, ritorno);
                                 serviceMapCase.put(ritorno.Id, CaseUtils.createCaseRitornoPostale(params));
                                 
                                 String strNotaCase = 'Ritorno Postale \n';
                                 strNotaCase += 'Cliente: ' + ritorno.OCSAnag__c + ' - ' + ritorno.Nome__c + ' ' + ritorno.Cognome__c + '\n';
                                 strNotaCase += 'Pratica: ' + ritorno.LoanNumber__c + ' - ' + ritorno.LoanType__c + ' - ' + ritorno.TipoPagamento__c + '\n';
                                 strNotaCase += 'Filiale: ' + ritorno.Branch_id__c + '\n';
                                 strNotaCase += 'Codice Lettera: ' + ritorno.LetterId__c + '\n';
                                 strNotaCase += 'Tipo Lettera: ' + ritorno.LetterTypeId__c + '\n';
                                 strNotaCase += 'Motivo Ritorno: ' + ritorno.ReturnedReason__c + '\n';
                                 strNotaCase += 'Operazione da eseguire: Non contattare \n';
                                 strNotaCase += 'Indirizzo attuale in OCS (al ' + getFormattedDate(ritorno.ReturnedDate__c) + '): ' + ritorno.OriginalAddress__c + ' ' + 
                                     ritorno.OriginalCap__c + ' ' + ritorno.OriginalCity__c + ' ' + ritorno.OriginalProv__c + '\n';
                                 strNotaCase += 'Indirizzo della lettera: ' + ritorno.SentAddress__c + ' ' + 
                                     ritorno.SentCap__c + ' ' + ritorno.SentCity__c + ' ' + ritorno.SentProv__c + '\n';
                                 serviceNoteCase.put(ritorno.id, strNotaCase);                       	
                                 
                                 elencoLetterID.add(ritorno.LetterId__c);
                                 
                             } else if (RitorniPostaliUtils.RETURNED_REASON_DEC.equalsIgnoreCase(strCausaleRitorno)) {
                                 if (RitorniPostaliUtils.FLAG_RESO_MACERO_R.equals(strFlagResoMacero)) {
                                     
                                     Map<String,String> params = new map<String,String>();
                                     params.put('Subject', RitorniPostaliUtils.RITORNI_POSTALI_DEFAULT_CASE_SUBJECT);
                                     String strQueueID = mapQueue.get(RitorniPostaliUtils.QUEUE_85);                             
                                     params.put('OwnerId', strQueueID);  
                                     params.put('RecordTypeId', strRecordTypeID);
                                     params.put('Status', CaseUtils.APERTO);
                                     params.put('Disposition__c', mapDisposition.get(RitorniPostaliUtils.ESITO_DA_NON_CONTATTARE));
                                     String strAccountID = mapAccount.get(AccountUtils.OCSCustomerChar + ritorno.OCSAnag__c); 
                                     params.put('AccountId', strAccountID);
                                     String strCatId = mapCategory.get(RitorniPostaliUtils.CAT_INVIO_ORIGINALE);
                                     params.put('Categoria_Riferimento__c', strCatId);
                                     params.put('Tipo_Pratica__c', ritorno.LoanType__c);
                                     params.put('NumeroPratica__c', ritorno.LoanNumber__c);
                                     params.put('Branch__c', ritorno.Branch_id__c);
                                     
                                     ritorno.QueueId__c = strQueueID;
                                     ritorno.CatId__c = strCatId;                      	
                                     ritorno.Processato__c = 1;
                                     
                                     serviceMapRitorni.put(ritorno.Id, ritorno);
                                     serviceMapCase.put(ritorno.Id, CaseUtils.createCaseRitornoPostale(params));
                                     
                                     String strNotaCase = 'Ritorno Postale \n';
                                     strNotaCase += 'Cliente: ' + ritorno.OCSAnag__c + ' - ' + ritorno.Nome__c + ' ' + ritorno.Cognome__c + '\n';
                                     strNotaCase += 'Pratica: ' + ritorno.LoanNumber__c + ' - ' + ritorno.LoanType__c + ' - ' + ritorno.TipoPagamento__c + '\n';
                                     strNotaCase += 'Filiale: ' + ritorno.Branch_id__c + '\n';
                                     strNotaCase += 'Codice Lettera: ' + ritorno.LetterId__c + '\n';
                                     strNotaCase += 'Tipo Lettera: ' + ritorno.LetterTypeId__c + '\n';
                                     strNotaCase += 'Motivo Ritorno: ' + ritorno.ReturnedReason__c + '\n';
                                     strNotaCase += 'Operazione da eseguire: Non contattare \n';
                                     strNotaCase += 'Indirizzo attuale in OCS (al ' + getFormattedDate(ritorno.ReturnedDate__c) + '): ' + ritorno.OriginalAddress__c + ' ' + 
                                         ritorno.OriginalCap__c + ' ' + ritorno.OriginalCity__c + ' ' + ritorno.OriginalProv__c + '\n';
                                     strNotaCase += 'Indirizzo della lettera: ' + ritorno.SentAddress__c + ' ' + 
                                         ritorno.SentCap__c + ' ' + ritorno.SentCity__c + ' ' + ritorno.SentProv__c + '\n';
                                     serviceNoteCase.put(ritorno.id, strNotaCase);                       		
                                     
                                     String strNotaOCS = 'Caricato ritorno postale del ' + getFormattedDate(ritorno.ReturnedDate__c) + ', codice invio - ' + ritorno.LetterId__c + 
                                         ' - il cliente non sarà contattato da call center, si attende il rientro dell\'originale per l\'archiviazione.';
                                     listaOCSNote.add(OCSGestioneNoteInvoker.createOCSNote(rt, strUserAlias, 
                                                                                           strExternalCustomerID, 
                                                                                           '', 
                                                                                           '', 
                                                                                           'A', 
                                                                                           'P', 
                                                                                           strNotaOCS));
                                     
                                     elencoLetterID.add(ritorno.LetterId__c);
                                     
                                 } else {
                                     
                                     Map<String,String> params = new map<String,String>();
                                     params.put('Subject', RitorniPostaliUtils.RITORNI_POSTALI_DEFAULT_CASE_SUBJECT);                         
                                     params.put('OwnerId', mapQueue.get(RitorniPostaliUtils.QUEUE_95));  
                                     params.put('RecordTypeId', strRecordTypeID);
                                     params.put('Status', CaseUtils.CHIUSO);
                                     params.put('Disposition__c', mapDisposition.get(RitorniPostaliUtils.ESITO_DA_NON_CONTATTARE));
                                     String strAccountID = mapAccount.get(AccountUtils.OCSCustomerChar + ritorno.OCSAnag__c);
                                     params.put('AccountId', strAccountID);
                                     String strCatId = mapCategory.get(RitorniPostaliUtils.CAT_INVIO_COPIA);
                                     params.put('Categoria_Riferimento__c', strCatId);
                                     params.put('Tipo_Pratica__c', ritorno.LoanType__c);
                                     params.put('NumeroPratica__c', ritorno.LoanNumber__c);
                                     
                                     ritorno.C_id__c = strAccountID;
                                     ritorno.CatId__c = strCatId;                      	
                                     ritorno.Processato__c = 1;
                                     
                                     serviceMapRitorni.put(ritorno.Id, ritorno);
                                     serviceMapCase.put(ritorno.Id, CaseUtils.createCaseRitornoPostale(params));
                                     
                                     String strNotaCase = 'Ritorno Postale \n';
                                     strNotaCase += 'Cliente: ' + ritorno.OCSAnag__c + ' - ' + ritorno.Nome__c + ' ' + ritorno.Cognome__c + '\n';
                                     strNotaCase += 'Pratica: ' + ritorno.LoanNumber__c + ' - ' + ritorno.LoanType__c + ' - ' + ritorno.TipoPagamento__c + '\n';
                                     strNotaCase += 'Filiale: ' + ritorno.Branch_id__c + '\n';
                                     strNotaCase += 'Codice Lettera: ' + ritorno.LetterId__c + '\n';
                                     strNotaCase += 'Tipo Lettera: ' + ritorno.LetterTypeId__c + '\n';
                                     strNotaCase += 'Motivo Ritorno: ' + ritorno.ReturnedReason__c + '\n';
                                     strNotaCase += 'Operazione da eseguire: Contatto - Invio Copia \n';
                                     strNotaCase += 'Indirizzo attuale in OCS (al ' + getFormattedDate(ritorno.ReturnedDate__c) + '): ' + ritorno.OriginalAddress__c + ' ' + 
                                         ritorno.OriginalCap__c + ' ' + ritorno.OriginalCity__c + ' ' + ritorno.OriginalProv__c + '\n';
                                     strNotaCase += 'Indirizzo della lettera: ' + ritorno.SentAddress__c + ' ' + 
                                         ritorno.SentCap__c + ' ' + ritorno.SentCity__c + ' ' + ritorno.SentProv__c + '\n';
                                     serviceNoteCase.put(ritorno.id, strNotaCase);                       		
                                     
                                     String strNotaOCS = 'Caricato ritorno postale del ' + getFormattedDate(ritorno.ReturnedDate__c) + ', codice invio - ' + ritorno.LetterId__c + 
                                         ' - il cliente non sarà contattato da call center in quanto dichiarato deceduto.';
                                     listaOCSNote.add(OCSGestioneNoteInvoker.createOCSNote(rt, strUserAlias, 
                                                                                           strExternalCustomerID, 
                                                                                           '', 
                                                                                           '', 
                                                                                           'A', 
                                                                                           'P', 
                                                                                           strNotaOCS));
                                     
                                     elencoLetterID.add(ritorno.LetterId__c);
                                     
                                 }                         
                             } else if (!(RitorniPostaliUtils.RETURNED_REASON_DEC.equalsIgnoreCase(strCausaleRitorno))) {
                                 if (RitorniPostaliUtils.FLAG_RESO_MACERO_R.equals(strFlagResoMacero)) {
                                     
                                     RitorniPostali__c ritornoPregresso = null;
                                     
                                     List<RitorniPostali__c> ritorniPregressi = new List<RitorniPostali__c>();
                                     
                                     System.debug('MAPPPPPPPPP - ********************************* - ' + previousLetterMap);
                                     System.debug('DM - ********************************* - ' + ritorno.OCSAnag__c);
                                     ritorniPregressi = previousLetterMap.get(ritorno.OCSAnag__c);
                                     if ((ritorniPregressi != null) && (!(ritorniPregressi.isEmpty()))) {
                                         ritornoPregresso = RitorniPostaliUtils.findRitornoEsistenteByCustomer(ritorno, ritorniPregressi); 
                                     }   
                                     
                                     if (ritornoPregresso == null) {
                                         
                                         Map<String,String> params = new map<String,String>();
                                         params.put('Subject', RitorniPostaliUtils.RITORNI_POSTALI_DEFAULT_CASE_SUBJECT);
                                         String strQueueID = mapQueue.get(RitorniPostaliUtils.QUEUE_RITORNI_POSTALI_VERIFICA_INDIRIZZO);
                                         params.put('OwnerId', strQueueID);  
                                         params.put('RecordTypeId', strRecordTypeID);
                                         params.put('Status', CaseUtils.APERTO);
                                         //params.put('Disposition__c', XCS_DispositionUtils.findDispositionByExternalID(RitorniPostaliUtils.ESITO_DA_NON_CONTATTARE).Id);
                                         String strAccountID = mapAccount.get(AccountUtils.OCSCustomerChar + ritorno.OCSAnag__c);
                                         params.put('AccountId', strAccountID);                     			
                                         String strCatId = mapCategory.get(RitorniPostaliUtils.CAT_INVIO_ORIGINALE);
                                         params.put('Categoria_Riferimento__c', strCatId);
                                         params.put('Tipo_Pratica__c', ritorno.LoanType__c);
                                         params.put('NumeroPratica__c', ritorno.LoanNumber__c);
                                         params.put('Branch__c', ritorno.Branch_id__c);
                                         
                                         ritorno.C_id__c = strAccountID;
                                         ritorno.QueueId__c = strQueueID;
                                         ritorno.CatId__c = strCatId;                      	
                                         ritorno.Processato__c = 1;
                                         
                                         serviceMapRitorni.put(ritorno.Id, ritorno);
                                         serviceMapCase.put(ritorno.Id, CaseUtils.createCaseRitornoPostale(params));
                                         
                                         String strNotaCase = 'Ritorno Postale \n';
                                         strNotaCase += 'Cliente: ' + ritorno.OCSAnag__c + ' - ' + ritorno.Nome__c + ' ' + ritorno.Cognome__c + '\n';
                                         strNotaCase += 'Pratica: ' + ritorno.LoanNumber__c + ' - ' + ritorno.LoanType__c + ' - ' + ritorno.TipoPagamento__c + '\n';
                                         strNotaCase += 'Filiale: ' + ritorno.Branch_id__c + '\n';
                                         strNotaCase += 'Codice Lettera: ' + ritorno.LetterId__c + '\n';
                                         strNotaCase += 'Tipo Lettera: ' + ritorno.LetterTypeId__c + '\n';
                                         strNotaCase += 'Motivo Ritorno: ' + ritorno.ReturnedReason__c + '\n';
                                         strNotaCase += 'Operazione da eseguire: Contatto - Invio Originale \n';
                                         strNotaCase += 'Indirizzo attuale in OCS (al ' + getFormattedDate(ritorno.ReturnedDate__c) + '): ' + ritorno.OriginalAddress__c + ' ' + 
                                             ritorno.OriginalCap__c + ' ' + ritorno.OriginalCity__c + ' ' + ritorno.OriginalProv__c + '\n';
                                         strNotaCase += 'Indirizzo della lettera: ' + ritorno.SentAddress__c + ' ' + 
                                             ritorno.SentCap__c + ' ' + ritorno.SentCity__c + ' ' + ritorno.SentProv__c + '\n';
                                         serviceNoteCase.put(ritorno.id, strNotaCase);                     			
                                         
                                         String strNotaOCS = 'Caricato ritorno postale del ' + getFormattedDate(ritorno.ReturnedDate__c) + ', codice invio - ' + ritorno.LetterId__c + 
                                             ' - il cliente sarà contattato da call center per l\'invio della lettera originale.';
                                         listaOCSNote.add(OCSGestioneNoteInvoker.createOCSNOte(rt, strUserAlias, 
                                                                                               strExternalCustomerID, 
                                                                                               '', 
                                                                                               '', 
                                                                                               'A', 
                                                                                               'P', 
                                                                                               strNotaOCS));
                                         
                                         elencoLetterID.add(ritorno.LetterId__c);
                                         
                                     } else {
                                         
                                         Boolean esitoTrovato = false;
                                         for (RitorniPostaliUtils.ESITI_POSITIVI esitoPositivo : RitorniPostaliUtils.ESITI_POSITIVI.values()) {
                                             if (esitoPositivo.name().equalsIgnoreCase(ritornoPregresso.CallDispCode__c)) {
                                                 
                                                 String strPreviousLetterId = ritornoPregresso.LetterId__c;
                                                 ritorno.NewAddress__c = ritornoPregresso.NewAddress__c;
                                                 ritorno.NewCity__c = ritornoPregresso.NewCity__c;
                                                 ritorno.NewCap__c = ritornoPregresso.NewCap__c;
                                                 ritorno.NewProv__c = ritornoPregresso.NewProv__c;
                                                 
                                                 Map<String,String> params = new map<String,String>();
                                                 params.put('Subject', RitorniPostaliUtils.RITORNI_POSTALI_DEFAULT_CASE_SUBJECT);
                                                 String strQueueID = mapQueue.get(RitorniPostaliUtils.QUEUE_85);
                                                 params.put('OwnerId', strQueueID);  
                                                 params.put('RecordTypeId', strRecordTypeID);
                                                 params.put('Status', CaseUtils.APERTO);
                                                 params.put('Disposition__c', mapDisposition.get(RitorniPostaliUtils.ESITO_ATTESA_DOC_POSTE));
                                                 String strAccountID = mapAccount.get(AccountUtils.OCSCustomerChar + ritorno.OCSAnag__c);
                                                 params.put('AccountId', strAccountID);
                                                 String strCatId = mapCategory.get(RitorniPostaliUtils.CAT_INVIO_ORIGINALE);
                                                 params.put('Categoria_Riferimento__c', strCatId);
                                                 params.put('Tipo_Pratica__c', ritorno.LoanType__c);
                                                 params.put('NumeroPratica__c', ritorno.LoanNumber__c); 
                                                 params.put('Branch__c', ritorno.Branch_id__c);                                           
                                                 
                                                 ritorno.PreviousLetterId__c = strPreviousLetterId;
                                                 ritorno.C_id__c = strAccountID;
                                                 ritorno.QueueId__c = strQueueID;
                                                 ritorno.CatId__c = strCatId;                      	
                                                 ritorno.Processato__c = 1;
                                                 
                                                 serviceMapRitorni.put(ritorno.Id, ritorno);
                                                 serviceMapCase.put(ritorno.Id, CaseUtils.createCaseRitornoPostale(params));
                                                 
                                                 String strNotaCase = 'Ritorno Postale \n';
                                                 strNotaCase += 'Cliente: ' + ritorno.OCSAnag__c + ' - ' + ritorno.Nome__c + ' ' + ritorno.Cognome__c + '\n';
                                                 strNotaCase += 'Pratica: ' + ritorno.LoanNumber__c + ' - ' + ritorno.LoanType__c + ' - ' + ritorno.TipoPagamento__c + '\n';
                                                 strNotaCase += 'Filiale: ' + ritorno.Branch_id__c + '\n';
                                                 strNotaCase += 'Codice Lettera: ' + ritorno.LetterId__c + '\n';
                                                 strNotaCase += 'Tipo Lettera: ' + ritorno.LetterTypeId__c + '\n';
                                                 strNotaCase += 'Motivo Ritorno: ' + ritorno.ReturnedReason__c + '\n';
                                                 strNotaCase += 'Operazione da eseguire: Contatto - Invio Originale \n';
                                                 strNotaCase += 'ATTENZIONE! il cliente è stato già contattato dal call center per la lettera ' + strPreviousLetterId + ' con esito positivo.';
                                                 strNotaCase += 'Si attende il rientro della lettera per il re-invio dell\'originale \n';
                                                 strNotaCase += 'Indirizzo attuale in OCS (al ' + getFormattedDate(ritorno.ReturnedDate__c) + '): ' + ritorno.OriginalAddress__c + ' ' + 
                                                     ritorno.OriginalCap__c + ' ' + ritorno.OriginalCity__c + ' ' + ritorno.OriginalProv__c + '\n';
                                                 strNotaCase += 'Indirizzo della lettera: ' + ritorno.SentAddress__c + ' ' + 
                                                     ritorno.SentCap__c + ' ' + ritorno.SentCity__c + ' ' + ritorno.SentProv__c + '\n';
                                                 serviceNoteCase.put(ritorno.id, strNotaCase);                      					
                                                 
                                                 String strNotaOCS = 'Caricato ritorno postale del ' + getFormattedDate(ritorno.ReturnedDate__c) + ', codice invio - ' + ritorno.LetterId__c + 
                                                     ' - il cliente è stato già contattato dal call center per la lettera ' + strPreviousLetterId + ' con esito positivo. Si attende il rientro della lettera per il re-invio dell\'originale';
                                                 listaOCSNote.add(OCSGestioneNoteInvoker.createOCSNote(rt, strUserAlias, 
                                                                                                       strExternalCustomerID, 
                                                                                                       '', 
                                                                                                       '', 
                                                                                                       'A', 
                                                                                                       'P', 
                                                                                                       strNotaOCS));
                                                 
                                                 elencoLetterID.add(ritorno.LetterId__c);
                                                 
                                                 esitoTrovato = true;                                           
                                                 break;
                                             }
                                         }
                                         
                                         if (!(esitoTrovato)) {
                                             
                                             for (RitorniPostaliUtils.ESITI_NEGATIVI esitoNegativo : RitorniPostaliUtils.ESITI_NEGATIVI.values()) {
                                                 if (esitoNegativo.name().equalsIgnoreCase(ritornoPregresso.CallDispCode__c)) {
                                                     
                                                     String strPreviousLetterId = ritornoPregresso.LetterId__c;
                                                     Map<String,String> params = new map<String,String>();
                                                     params.put('Subject', RitorniPostaliUtils.RITORNI_POSTALI_DEFAULT_CASE_SUBJECT);
                                                     String strQueueID = mapQueue.get(RitorniPostaliUtils.QUEUE_95);
                                                     params.put('OwnerId', strQueueID);  
                                                     params.put('RecordTypeId', strRecordTypeID);
                                                     params.put('Status', CaseUtils.APERTO);
                                                     if (RitorniPostaliUtils.ESITO_DOC_NON_REINVIATA.equalsIgnoreCase(ritornoPregresso.CallDispCode__c)) {
                                                         params.put('Disposition__c', mapDisposition.get(RitorniPostaliUtils.ESITO_NEGATIVO_GENERICO));
                                                     } else {
                                                         params.put('Disposition__c', XCS_DispositionUtils.findDispositionByExternalID(ritornoPregresso.CallDispCode__c).Id);
                                                     }   
                                                     String strAccountID = mapAccount.get(AccountUtils.OCSCustomerChar + ritorno.OCSAnag__c);
                                                     params.put('AccountId', strAccountID);
                                                     String strCatId = mapCategory.get(RitorniPostaliUtils.CAT_INVIO_ORIGINALE);
                                                     params.put('Categoria_Riferimento__c', strCatId);
                                                     params.put('Tipo_Pratica__c', ritorno.LoanType__c);
                                                     params.put('NumeroPratica__c', ritorno.LoanNumber__c);                                                  
                                                     
                                                     ritorno.C_id__c = strAccountID;
                                                     ritorno.QueueId__c = strQueueID;
                                                     ritorno.CatId__c = strCatId;                      	
                                                     ritorno.Processato__c = 1;
                                                     
                                                     serviceMapRitorni.put(ritorno.Id, ritorno);
                                                     serviceMapCase.put(ritorno.Id, CaseUtils.createCaseRitornoPostale(params));
                                                     
                                                     String strNotaCase = 'Ritorno Postale \n';
                                                     strNotaCase += 'Cliente: ' + ritorno.OCSAnag__c + ' - ' + ritorno.Nome__c + ' ' + ritorno.Cognome__c + '\n';
                                                     strNotaCase += 'Pratica: ' + ritorno.LoanNumber__c + ' - ' + ritorno.LoanType__c + ' - ' + ritorno.TipoPagamento__c + '\n';
                                                     strNotaCase += 'Filiale: ' + ritorno.Branch_id__c + '\n';
                                                     strNotaCase += 'Codice Lettera: ' + ritorno.LetterId__c + '\n';
                                                     strNotaCase += 'Tipo Lettera: ' + ritorno.LetterTypeId__c + '\n';
                                                     strNotaCase += 'Motivo Ritorno: ' + ritorno.ReturnedReason__c + '\n';
                                                     strNotaCase += 'Operazione da eseguire: Contatto - Invio Originale \n';
                                                     strNotaCase += 'ATTENZIONE! il cliente è stato già contattato dal call center per la lettera ' + strPreviousLetterId + ' con esito negativo.';
                                                     strNotaCase += 'Si attende il rientro della lettera per l\' archiviazione.';
                                                     strNotaCase += 'Indirizzo attuale in OCS (al ' + getFormattedDate(ritorno.ReturnedDate__c) + '): ' + ritorno.OriginalAddress__c + ' ' + 
                                                         ritorno.OriginalCap__c + ' ' + ritorno.OriginalCity__c + ' ' + ritorno.OriginalProv__c + '\n';
                                                     strNotaCase += 'Indirizzo della lettera: ' + ritorno.SentAddress__c + ' ' + 
                                                         ritorno.SentCap__c + ' ' + ritorno.SentCity__c + ' ' + ritorno.SentProv__c + '\n';
                                                     serviceNoteCase.put(ritorno.id, strNotaCase);                       						
                                                     
                                                     String strNotaOCS = 'Caricato ritorno postale del ' + getFormattedDate(ritorno.ReturnedDate__c) + ', codice invio - ' + ritorno.LetterId__c + 
                                                         ' - il cliente è stato già contattato dal call center per la lettera ' + strPreviousLetterId + ' con esito negativo. Si attende il rientro della lettera per l\' archiviazione';
                                                     listaOCSNote.add(OCSGestioneNoteInvoker.createOCSNote(rt, strUserAlias, 
                                                                                                           strExternalCustomerID, 
                                                                                                           '', 
                                                                                                           '', 
                                                                                                           'A', 
                                                                                                           'P', 
                                                                                                           strNotaOCS));
                                                     
                                                     elencoLetterID.add(ritorno.LetterId__c);
                                                     
                                                     break;
                                                 }
                                                 
                                             }
                                             
                                         }                                                                     
                                         
                                     }
                                     
                                 } else {
                                     
                                     RitorniPostali__c ritornoPregresso = null;
                                     List<RitorniPostali__c> ritorniPregressi = new List<RitorniPostali__c>();
                                     ritorniPregressi = previousLetterMap.get(ritorno.OCSAnag__c);
                                     if ((ritorniPregressi != null) && (!(ritorniPregressi.isEmpty()))) {
                                         ritornoPregresso = RitorniPostaliUtils.findRitornoEsistenteByCustomer(ritorno, ritorniPregressi); 
                                     }  
                                     
                                     if (ritornoPregresso == null) {
                                         
                                         Map<String,String> params = new map<String,String>();
                                         params.put('Subject', RitorniPostaliUtils.RITORNI_POSTALI_DEFAULT_CASE_SUBJECT);
                                         String strQueueID = mapQueue.get(RitorniPostaliUtils.QUEUE_RITORNI_POSTALI_VERIFICA_INDIRIZZO);
                                         params.put('OwnerId', strQueueID);  
                                         params.put('RecordTypeId', strRecordTypeID);
                                         params.put('Status', CaseUtils.APERTO);
                                         //params.put('Disposition__c', XCS_DispositionUtils.findDispositionByExternalID(RitorniPostaliUtils.ESITO_DA_NON_CONTATTARE).Id);
                                         String strAccountID = mapAccount.get(AccountUtils.OCSCustomerChar + ritorno.OCSAnag__c);
                                         params.put('AccountId', strAccountID);
                                         String strCatId = mapCategory.get(RitorniPostaliUtils.CAT_INVIO_COPIA);
                                         params.put('Categoria_Riferimento__c', strCatId);
                                         params.put('Tipo_Pratica__c', ritorno.LoanType__c);
                                         params.put('NumeroPratica__c', ritorno.LoanNumber__c);
                                         params.put('Branch__c', ritorno.Branch_id__c);
                                         
                                         ritorno.C_id__c = strAccountID;
                                         ritorno.QueueId__c = strQueueID;
                                         ritorno.CatId__c = strCatId;                      	
                                         ritorno.Processato__c = 1;
                                         
                                         serviceMapRitorni.put(ritorno.Id, ritorno);
                                         serviceMapCase.put(ritorno.Id, CaseUtils.createCaseRitornoPostale(params));
                                         
                                         String strNotaCase = 'Ritorno Postale \n';
                                         strNotaCase += 'Cliente: ' + ritorno.OCSAnag__c + ' - ' + ritorno.Nome__c + ' ' + ritorno.Cognome__c + '\n';
                                         strNotaCase += 'Pratica: ' + ritorno.LoanNumber__c + ' - ' + ritorno.LoanType__c + ' - ' + ritorno.TipoPagamento__c + '\n';
                                         strNotaCase += 'Filiale: ' + ritorno.Branch_id__c + '\n';
                                         strNotaCase += 'Codice Lettera: ' + ritorno.LetterId__c + '\n';
                                         strNotaCase += 'Tipo Lettera: ' + ritorno.LetterTypeId__c + '\n';
                                         strNotaCase += 'Motivo Ritorno: ' + ritorno.ReturnedReason__c + '\n';
                                         strNotaCase += 'Operazione da eseguire: Contatto - Invio Copia'; 
                                         serviceNoteCase.put(ritorno.id, strNotaCase);                       			
                                         
                                         String strNotaOCS = 'Caricato ritorno postale del ' + getFormattedDate(ritorno.ReturnedDate__c) + ', codice invio - ' + ritorno.LetterId__c + 
                                             ' - il cliente sarà contattato da call center per una riemissione di una copia della lettera da OCS.';
                                         listaOCSNote.add(OCSGestioneNoteInvoker.createOCSNote(rt, strUserAlias, 
                                                                                               strExternalCustomerID, 
                                                                                               '', 
                                                                                               '', 
                                                                                               'A', 
                                                                                               'P', 
                                                                                               strNotaOCS));
                                         
                                         elencoLetterID.add(ritorno.LetterId__c);
                                         
                                     } else {
                                         
                                         Boolean esitoTrovato = false;
                                         for (RitorniPostaliUtils.ESITI_POSITIVI esitoPositivo : RitorniPostaliUtils.ESITI_POSITIVI.values()) {
                                             if (esitoPositivo.name().equalsIgnoreCase(ritornoPregresso.CallDispCode__c)) {
                                                 
                                                 String strPreviousLetterId = ritornoPregresso.LetterId__c;
                                                 ritorno.NewAddress__c = ritornoPregresso.NewAddress__c;
                                                 ritorno.NewCity__c = ritornoPregresso.NewCity__c;
                                                 ritorno.NewCap__c = ritornoPregresso.NewCap__c;
                                                 ritorno.NewProv__c = ritornoPregresso.NewProv__c;
                                                 
                                                 Map<String,String> params = new map<String,String>();
                                                 params.put('Subject', RitorniPostaliUtils.RITORNI_POSTALI_DEFAULT_CASE_SUBJECT);
                                                 String strQueueID = mapQueue.get(RitorniPostaliUtils.QUEUE_RITORNI_POSTALI_VERIFICA_INDIRIZZO);
                                                 params.put('OwnerId', strQueueID);  
                                                 params.put('RecordTypeId', strRecordTypeID);
                                                 params.put('Status', CaseUtils.APERTO);
                                                 params.put('Disposition__c', mapDisposition.get(RitorniPostaliUtils.ESITO_ATTESA_DOC_POSTE));
                                                 String strAccountID = mapAccount.get(AccountUtils.OCSCustomerChar + ritorno.OCSAnag__c);
                                                 params.put('AccountId', strAccountID);
                                                 String strCatId = mapCategory.get(RitorniPostaliUtils.CAT_INVIO_COPIA);
                                                 params.put('Categoria_Riferimento__c', strCatId);
                                                 params.put('Tipo_Pratica__c', ritorno.LoanType__c);
                                                 params.put('NumeroPratica__c', ritorno.LoanNumber__c);
                                                 params.put('Branch__c', ritorno.Branch_id__c);
                                                 
                                                 ritorno.PreviousLetterId__c = strPreviousLetterId;
                                                 ritorno.PreviousLetterNote__c = 'ATTENZIONE:  - il cliente e gia stato contattato dal call center per la lettera' + strPreviousLetterId + 'con esito positivo. Eseguire solo la riemissione di una copia della lettera da OCS';
                                                 ritorno.C_id__c = strAccountID;
                                                 ritorno.QueueId__c = strQueueID;
                                                 ritorno.CatId__c = strCatId;                      	
                                                 ritorno.Processato__c = 1;
                                                 
                                                 serviceMapRitorni.put(ritorno.Id, ritorno);
                                                 serviceMapCase.put(ritorno.Id, CaseUtils.createCaseRitornoPostale(params));
                                                 
                                                 String strNotaCase = 'Ritorno Postale \n';
                                                 strNotaCase += 'Cliente: ' + ritorno.OCSAnag__c + ' - ' + ritorno.Nome__c + ' ' + ritorno.Cognome__c + '\n';
                                                 strNotaCase += 'Pratica: ' + ritorno.LoanNumber__c + ' - ' + ritorno.LoanType__c + ' - ' + ritorno.TipoPagamento__c + '\n';
                                                 strNotaCase += 'Filiale: ' + ritorno.Branch_id__c + '\n';
                                                 strNotaCase += 'Codice Lettera: ' + ritorno.LetterId__c + '\n';
                                                 strNotaCase += 'Tipo Lettera: ' + ritorno.LetterTypeId__c + '\n';
                                                 strNotaCase += 'Motivo Ritorno: ' + ritorno.ReturnedReason__c + '\n';
                                                 strNotaCase += 'Operazione da eseguire: Contatto - Invio Originale \n';
                                                 strNotaCase += 'ATTENZIONE! il cliente è stato già contattato dal call center per la lettera ' + strPreviousLetterId + ' con esito positivo.';
                                                 strNotaCase += 'Il call center eseguirà la ri-emissione di una copia della lettera da OCS.';
                                                 strNotaCase += 'Indirizzo attuale in OCS (al ' + getFormattedDate(ritorno.ReturnedDate__c) + '): ' + ritorno.OriginalAddress__c + ' ' + 
                                                     ritorno.OriginalCap__c + ' ' + ritorno.OriginalCity__c + ' ' + ritorno.OriginalProv__c + '\n';
                                                 strNotaCase += 'Indirizzo della lettera: ' + ritorno.SentAddress__c + ' ' + 
                                                     ritorno.SentCap__c + ' ' + ritorno.SentCity__c + ' ' + ritorno.SentProv__c + '\n';
                                                 serviceNoteCase.put(ritorno.id, strNotaCase);                       					
                                                 
                                                 String strNotaOCS = 'Caricato ritorno postale del ' + getFormattedDate(ritorno.ReturnedDate__c) + ', codice invio - ' + ritorno.LetterId__c + 
                                                     ' - il cliente è stato già contattato dal call center per la lettera ' + strPreviousLetterId + ' con esito positivo. Il call center eseguirà la ri-emissione di una copia della lettera da OCS.';
                                                 listaOCSNote.add(OCSGestioneNoteInvoker.createOCSNote(rt, strUserAlias, 
                                                                                                       strExternalCustomerID, 
                                                                                                       '', 
                                                                                                       '', 
                                                                                                       'A', 
                                                                                                       'P', 
                                                                                                       strNotaOCS));
                                                 
                                                 elencoLetterID.add(ritorno.LetterId__c);
                                                 
                                                 esitoTrovato = true;                                           
                                                 break;
                                             }
                                         }
                                         
                                         if (!(esitoTrovato)) {
                                             
                                             for (RitorniPostaliUtils.ESITI_NEGATIVI esitoNegativo : RitorniPostaliUtils.ESITI_NEGATIVI.values()) {
                                                 if (esitoNegativo.name().equalsIgnoreCase(ritornoPregresso.CallDispCode__c)) {
                                                     
                                                     String strPreviousLetterId = ritornoPregresso.LetterId__c;
                                                     Map<String,String> params = new map<String,String>();
                                                     params.put('Subject', RitorniPostaliUtils.RITORNI_POSTALI_DEFAULT_CASE_SUBJECT);
                                                     //String strQueueID = GroupUtils.getQueue(RitorniPostaliUtils.QUEUE_85).id;
                                                     //params.put('OwnerId', strQueueID);  
                                                     params.put('RecordTypeId', strRecordTypeID);
                                                     params.put('Status', CaseUtils.CHIUSO);
                                                     if (RitorniPostaliUtils.ESITO_DOC_NON_REINVIATA.equalsIgnoreCase(ritornoPregresso.CallDispCode__c)) {
                                                         params.put('Disposition__c', mapDisposition.get(RitorniPostaliUtils.ESITO_NEGATIVO_GENERICO));
                                                     } else {
                                                         params.put('Disposition__c', XCS_DispositionUtils.findDispositionByExternalID(ritornoPregresso.CallDispCode__c).Id);
                                                     }  
                                                     String strAccountID = mapAccount.get(AccountUtils.OCSCustomerChar + ritorno.OCSAnag__c);
                                                     params.put('AccountId', strAccountID);
                                                     String strCatId = mapCategory.get(RitorniPostaliUtils.CAT_INVIO_COPIA);
                                                     params.put('Categoria_Riferimento__c', strCatId);
                                                     params.put('Tipo_Pratica__c', ritorno.LoanType__c);
                                                     params.put('NumeroPratica__c', ritorno.LoanNumber__c);                                                      				
                                                     
                                                     //ritorno.QueueId__c = strQueueID;
                                                     ritorno.C_id__c = strAccountID;
                                                     ritorno.CatId__c = strCatId;                      	
                                                     ritorno.Processato__c = 1;
                                                     
                                                     serviceMapRitorni.put(ritorno.Id, ritorno);
                                                     serviceMapCase.put(ritorno.Id, CaseUtils.createCaseRitornoPostale(params));
                                                     
                                                     String strNotaCase = 'Ritorno Postale \n';
                                                     strNotaCase += 'Cliente: ' + ritorno.OCSAnag__c + ' - ' + ritorno.Nome__c + ' ' + ritorno.Cognome__c + '\n';
                                                     strNotaCase += 'Pratica: ' + ritorno.LoanNumber__c + ' - ' + ritorno.LoanType__c + ' - ' + ritorno.TipoPagamento__c + '\n';
                                                     strNotaCase += 'Filiale: ' + ritorno.Branch_id__c + '\n';
                                                     strNotaCase += 'Codice Lettera: ' + ritorno.LetterId__c + '\n';
                                                     strNotaCase += 'Tipo Lettera: ' + ritorno.LetterTypeId__c + '\n';
                                                     strNotaCase += 'Motivo Ritorno: ' + ritorno.ReturnedReason__c + '\n';
                                                     strNotaCase += 'Operazione da eseguire: Contatto - Invio Copia \n';
                                                     strNotaCase += 'ATTENZIONE! il cliente è stato già contattato dal call center per la lettera ' + strPreviousLetterId + ' con esito negativo.';                                          	
                                                     strNotaCase += 'Indirizzo attuale in OCS (al ' + getFormattedDate(ritorno.ReturnedDate__c) + '): ' + ritorno.OriginalAddress__c + ' ' + 
                                                         ritorno.OriginalCap__c + ' ' + ritorno.OriginalCity__c + ' ' + ritorno.OriginalProv__c + '\n';
                                                     strNotaCase += 'Indirizzo della lettera: ' + ritorno.SentAddress__c + ' ' + 
                                                         ritorno.SentCap__c + ' ' + ritorno.SentCity__c + ' ' + ritorno.SentProv__c + '\n';
                                                     serviceNoteCase.put(ritorno.id, strNotaCase);                       						
                                                     
                                                     String strNotaOCS = 'Caricato ritorno postale del ' + getFormattedDate(ritorno.ReturnedDate__c) + ', codice invio - ' + ritorno.LetterId__c + 
                                                         ' - il cliente è stato già contattato dal call center per la lettera ' + strPreviousLetterId + ' con esito negativo.';
                                                     listaOCSNote.add(OCSGestioneNoteInvoker.createOCSNote(rt, strUserAlias, 
                                                                                                           strExternalCustomerID, 
                                                                                                           '', 
                                                                                                           '', 
                                                                                                           'A', 
                                                                                                           'P', 
                                                                                                           strNotaOCS));
                                                     
                                                     elencoLetterID.add(ritorno.LetterId__c);
                                                     
                                                     break;
                                                 }
                                                 
                                             }
                                             
                                         }
                                         
                                     }                                                                                           
                                 }   
                             }                                              
                    }
                    
                } else {
                    //tipo lettera NON WELCOME                                                       
                    if (RitorniPostaliUtils.RETURNED_REASON_DEC.equalsIgnoreCase(strCausaleRitorno)) {
                        //causale ritorno = DEC
                        Map<String,String> params = new map<String,String>();
                        params.put('Subject', RitorniPostaliUtils.RITORNI_POSTALI_DEFAULT_CASE_SUBJECT);                     
                        params.put('OwnerId',GroupUtils.getQueue(RitorniPostaliUtils.QUEUE_95).id);  
                        params.put('RecordTypeId', strRecordTypeID);
                        params.put('Status', CaseUtils.APERTO);
                        params.put('Disposition__c', XCS_DispositionUtils.findDispositionByExternalID(RitorniPostaliUtils.ESITO_DA_NON_CONTATTARE).Id);
                        System.debug('DM - ************************** - ' + ritorno.OCSAnag__c);
                        String strAccountID = AccountUtils.getCliente(ritorno.OCSAnag__c)[0].Id;
                        params.put('AccountId', strAccountID);
                        String strCatId = XCS_CategoriaUtil.getCategoryForExternalId(RitorniPostaliUtils.CAT_NO_CONTATTO).Id;
                        params.put('Categoria_Riferimento__c', strCatId);
                        params.put('Tipo_Pratica__c', ritorno.LoanType__c);
                        params.put('NumeroPratica__c', ritorno.LoanNumber__c);   
                        
                        ritorno.C_id__c = strAccountID;
                        ritorno.CatId__c = strCatId;                      	
                        ritorno.Processato__c = 1;
                        
                        serviceMapRitorni.put(ritorno.Id, ritorno);
                        serviceMapCase.put(ritorno.Id, CaseUtils.createCaseRitornoPostale(params));
                        
                        String strNotaCase = 'Ritorno Postale \n';
                        strNotaCase += 'Cliente: ' + ritorno.OCSAnag__c + ' - ' + ritorno.Nome__c + ' ' + ritorno.Cognome__c + '\n';
                        strNotaCase += 'Pratica: ' + ritorno.LoanNumber__c + ' - ' + ritorno.LoanType__c + ' - ' + ritorno.TipoPagamento__c + '\n';
                        strNotaCase += 'Filiale: ' + ritorno.Branch_id__c + '\n';
                        strNotaCase += 'Codice Lettera: ' + ritorno.LetterId__c + '\n';
                        strNotaCase += 'Tipo Lettera: ' + ritorno.LetterTypeId__c + '\n';
                        strNotaCase += 'Motivo Ritorno: ' + ritorno.ReturnedReason__c + '\n';
                        strNotaCase += 'Operazione da eseguire: Non contattare \n';
                        strNotaCase += 'Indirizzo attuale in OCS (al ' + getFormattedDate(ritorno.ReturnedDate__c) + '): ' + ritorno.OriginalAddress__c + ' ' + 
                            ritorno.OriginalCap__c + ' ' + ritorno.OriginalCity__c + ' ' + ritorno.OriginalProv__c + '\n';
                        strNotaCase += 'Indirizzo della lettera: ' + ritorno.SentAddress__c + ' ' + 
                            ritorno.SentCap__c + ' ' + ritorno.SentCity__c + ' ' + ritorno.SentProv__c + '\n';
                        serviceNoteCase.put(ritorno.id, strNotaCase);
                        
                        String strNotaOCS = 'Caricato ritorno postale del ' + getFormattedDate(ritorno.ReturnedDate__c) + ', codice invio - ' + ritorno.LetterId__c + 
                            ' - il cliente non sarà contattato da call center. il cliente inoltre è stato dichiarato deceduto.';
                        listaOCSNote.add(OCSGestioneNoteInvoker.createOCSNote(rt, strUserAlias, 
                                                                              strExternalCustomerID, 
                                                                              '', 
                                                                              '', 
                                                                              'A', 
                                                                              'P', 
                                                                              strNotaOCS));
                        
                        elencoLetterID.add(ritorno.LetterId__c);
                        
                    } else {
                        //causale ritorno <> DEC & flagResoMacero = R                      
                        if (RitorniPostaliUtils.FLAG_RESO_MACERO_R.equals(strFlagResoMacero)) {
                            
                            Map<String,String> params = new map<String,String>();                         
                            params.put('Subject', RitorniPostaliUtils.RITORNI_POSTALI_DEFAULT_CASE_SUBJECT);                          
                            params.put('OwnerId', mapQueue.get(RitorniPostaliUtils.QUEUE_95));  
                            params.put('RecordTypeId', strRecordTypeID);
                            params.put('Status', CaseUtils.APERTO);
                            params.put('Disposition__c', mapDisposition.get(RitorniPostaliUtils.ESITO_DA_NON_CONTATTARE));
                            String strAccountID = mapAccount.get(AccountUtils.OCSCustomerChar + ritorno.OCSAnag__c);
                            params.put('AccountId', strAccountID);
                            String strCatId = mapCategory.get(RitorniPostaliUtils.CAT_INVIO_ORIGINALE);
                            params.put('Categoria_Riferimento__c', strCatId);
                            params.put('Tipo_Pratica__c', ritorno.LoanType__c);
                            params.put('NumeroPratica__c', ritorno.LoanNumber__c);   
                            
                            ritorno.C_id__c = strAccountID;
                            ritorno.CatId__c = strCatId;                      	
                            ritorno.Processato__c = 1;
                            
                            serviceMapRitorni.put(ritorno.Id, ritorno);
                            serviceMapCase.put(ritorno.Id, CaseUtils.createCaseRitornoPostale(params));
                            
                            String strNotaCase = 'Ritorno Postale \n';
                            strNotaCase += 'Cliente: ' + ritorno.OCSAnag__c + ' - ' + ritorno.Nome__c + ' ' + ritorno.Cognome__c + '\n';
                            strNotaCase += 'Pratica: ' + ritorno.LoanNumber__c + ' - ' + ritorno.LoanType__c + ' - ' + ritorno.TipoPagamento__c + '\n';
                            strNotaCase += 'Filiale: ' + ritorno.Branch_id__c + '\n';
                            strNotaCase += 'Codice Lettera: ' + ritorno.LetterId__c + '\n';
                            strNotaCase += 'Tipo Lettera: ' + ritorno.LetterTypeId__c + '\n';
                            strNotaCase += 'Motivo Ritorno: ' + ritorno.ReturnedReason__c + '\n';
                            strNotaCase += 'Operazione da eseguire: Contatto - Invio Originale \n';
                            strNotaCase += 'Indirizzo attuale in OCS (al ' + getFormattedDate(ritorno.ReturnedDate__c) + '): ' + ritorno.OriginalAddress__c + ' ' + 
                                ritorno.OriginalCap__c + ' ' + ritorno.OriginalCity__c + ' ' + ritorno.OriginalProv__c + '\n';
                            strNotaCase += 'Indirizzo della lettera: ' + ritorno.SentAddress__c + ' ' + 
                                ritorno.SentCap__c + ' ' + ritorno.SentCity__c + ' ' + ritorno.SentProv__c + '\n';
                            serviceNoteCase.put(ritorno.id, strNotaCase);
                            
                            String strNotaOCS = 'Caricato ritorno postale del ' + getFormattedDate(ritorno.ReturnedDate__c) + ', codice invio - ' + ritorno.LetterId__c + 
                                ' - il cliente non sarà contattato da call center, si attende il rientro dell\'originale per l\'archiviazione.';
                            listaOCSNote.add(OCSGestioneNoteInvoker.createOCSNote(rt, strUserAlias, 
                                                                                  strExternalCustomerID, 
                                                                                  '', 
                                                                                  '', 
                                                                                  'A', 
                                                                                  'P', 
                                                                                  strNotaOCS));
                            
                            elencoLetterID.add(ritorno.LetterId__c);
                            
                        } else {
                            
                            //causale ritorno <> DEC & flagResoMacero <> R
                            Map<String,String> params = new map<String,String>();
                            params.put('Subject', RitorniPostaliUtils.RITORNI_POSTALI_DEFAULT_CASE_SUBJECT);                           
                            params.put('OwnerId', mapQueue.get(RitorniPostaliUtils.QUEUE_95));  
                            params.put('RecordTypeId', strRecordTypeID);
                            params.put('Status', CaseUtils.APERTO);
                            params.put('Disposition__c', mapDisposition.get(RitorniPostaliUtils.ESITO_DA_NON_CONTATTARE));
                            String strAccountID = mapAccount.get(AccountUtils.OCSCustomerChar + ritorno.OCSAnag__c);
                            params.put('AccountId', strAccountID);
                            String strCatId = mapCategory.get(RitorniPostaliUtils.CAT_NO_CONTATTO);
                            params.put('Categoria_Riferimento__c', strCatId);
                            params.put('Tipo_Pratica__c', ritorno.LoanType__c);
                            params.put('NumeroPratica__c', ritorno.LoanNumber__c);   
                            
                            ritorno.C_id__c = strAccountID;
                            ritorno.CatId__c = strCatId;                      	
                            ritorno.Processato__c = 1;
                            
                            serviceMapRitorni.put(ritorno.Id, ritorno);
                            serviceMapCase.put(ritorno.Id, CaseUtils.createCaseRitornoPostale(params));
                            
                            String strNotaCase = 'Ritorno Postale \n';
                            strNotaCase += 'Cliente: ' + ritorno.OCSAnag__c + ' - ' + ritorno.Nome__c + ' ' + ritorno.Cognome__c + '\n';
                            strNotaCase += 'Pratica: ' + ritorno.LoanNumber__c + ' - ' + ritorno.LoanType__c + ' - ' + ritorno.TipoPagamento__c + '\n';
                            strNotaCase += 'Filiale: ' + ritorno.Branch_id__c + '\n';
                            strNotaCase += 'Codice Lettera: ' + ritorno.LetterId__c + '\n';
                            strNotaCase += 'Tipo Lettera: ' + ritorno.LetterTypeId__c + '\n';
                            strNotaCase += 'Motivo Ritorno: ' + ritorno.ReturnedReason__c + '\n';
                            strNotaCase += 'Operazione da eseguire: Non contattare \n';
                            strNotaCase += 'Indirizzo attuale in OCS (al ' + getFormattedDate(ritorno.ReturnedDate__c) + '): ' + ritorno.OriginalAddress__c + ' ' + 
                                ritorno.OriginalCap__c + ' ' + ritorno.OriginalCity__c + ' ' + ritorno.OriginalProv__c + '\n';
                            strNotaCase += 'Indirizzo della lettera: ' + ritorno.SentAddress__c + ' ' + 
                                ritorno.SentCap__c + ' ' + ritorno.SentCity__c + ' ' + ritorno.SentProv__c + '\n';
                            serviceNoteCase.put(ritorno.id, strNotaCase);
                            
                            String strNotaOCS = 'Caricato ritorno postale del ' + getFormattedDate(ritorno.ReturnedDate__c) + ', codice invio - ' + ritorno.LetterId__c + 
                                ' - il cliente non sarà contattato da call center.';
                            listaOCSNote.add(OCSGestioneNoteInvoker.createOCSNote(rt, strUserAlias, 
                                                                                  strExternalCustomerID, 
                                                                                  '', 
                                                                                  '', 
                                                                                  'A', 
                                                                                  'P', 
                                                                                  strNotaOCS));
                            
                            elencoLetterID.add(ritorno.LetterId__c);
                            
                        }
                        
                    }
                    
                }
                
            }
            
            List<Case> listaCasi = serviceMapCase.values();           
            Insert listaCasi;
            Set<String> idRitorni = serviceMapRitorni.keySet();           
            Map<String, ContentNote> mapNote = new Map<String, ContentNote>();
            List<ContentDocumentLink> listLinks = new List<ContentDocumentLink>();
            
            for (String strIDRitorno : idRitorni) {
                
                Case casoRitornoPostale = serviceMapCase.get(strIDRitorno);
                RitorniPostali__c ritornoPostale = serviceMapRitorni.get(strIDRitorno);
                ritornoPostale.CasoCorrispondente__c = casoRitornoPostale.Id;
                mapNote.put(casoRitornoPostale.Id, XCSNoteUtils.createCaseNote('Nota', serviceNoteCase.get(strIDRitorno)));
                
            }
            Integer x1 = 1;
            for (ContentNote a : mapNote.values()) {
                system.debug('Nota ' + x1 + ' : ' + a.Content);
                x1++;
            }
            try {
                Insert mapNote.values();
            } catch(Exception e)  {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[]{'dario.mosca@lynxspa.com'};
                    mail.setToAddresses(toAddresses);
                mail.setSubject('Compass: Analizza Ritorni Postali ERRORE');
                mail.setPlainTextBody(e.getMessage() + '\n' + e.getStackTraceString() + '\n' + e.getCause());
                EmailUtils.sendEmail(mail);
            }
            
            Set<String> idCases = mapNote.keyset();
            for (String strCaseID : idCases) {
                listLinks.add(XCSNoteUtils.createDocumentLink(mapNote.get(strCaseID).Id, strCaseID));
            }
            
            Insert listLinks;
            Insert listaOCSNote;
            List<RitorniPostali__c> ritorniPostali = serviceMapRitorni.values();
            Update ritorniPostali;
                                         
        }
        
    } 
    
    global void finish(Database.BatchableContext BC) {
        
        final Integer MAX_NUMBER_RECORD_LIMIT = 1000;        
        final String OK_VALUE = 'OK';
        String strFlagError = EMPTY_STRING;
        List<Messaging.SingleEmailMessage> emailToSend = new List<Messaging.SingleEmailMessage>();
        
        integer subindex = 0;
        List<String> subsetFlagLettura = new List<String>(); 
        OCSRitorniPostaliFlagLetturaResponse objEsito;
        for (integer index = 0;index<=elencoLetterID.size() - 1;index++) {
            subsetFlagLettura.add(elencoLetterID.get(index));
            subindex++;
            if ((subindex == MAX_NUMBER_RECORD_LIMIT) || (index == (elencoLetterID.size() - 1))) {
                               
                try {
                    objEsito = OCSRitorniPostaliFlagLetturaInvoker.ritorniPostaliFlagLettura(subsetFlagLettura); 
                } catch (Exception e) {
                    strFlagError = 'MESSAGGIO : ' + e.getMessage() + '\n STACK TRACE : ' + e.getStackTraceString() + '\n CAUSA : ' + e.getCause(); 
                }
             
                if (String.isEmpty(strFlagError)) {
                    String strEsito = objEsito.esito;
                    String strErroreProgressivo = objEsito.esitoProgressivo;
                    if((strEsito != null) && (!(OK_VALUE.equals(strEsito)))) {
                        strFlagError = strErroreProgressivo;
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        String[] toAddresses = new String[]{'crm@compass.it'};
                            mail.setToAddresses(toAddresses);
                        mail.setSubject('Compass: Ritorni Postali ERRORE');
                        mail.setPlainTextBody('Errore set Flag Lettura su OCS progressivo: ' + strFlagError);
                        emailToSend.add(mail);
                    } else {
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        String[] toAddresses = new String[]{'crm@compass.it'};
                            mail.setToAddresses(toAddresses);
                        mail.setSubject('Compass: Creazione Ritorni Postali TERMINATO');
                        mail.setPlainTextBody('Ritorni Postali processati : ' + elencoLetterID.size());
                        emailToSend.add(mail);
                    }
                    
                } else {
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    String[] toAddresses = new String[]{'crm@compass.it'};
                        mail.setToAddresses(toAddresses);
                    mail.setSubject('Compass: ERRORE Creazione Ritorni');
                    mail.setPlainTextBody(strFlagError);
                    emailToSend.add(mail);
                }
                
                subsetFlagLettura.clear();
                subindex = 0;
            }
            
        }
        
        if ((emailToSend != null) && (emailToSend.size() > 0)) {
            EmailUtils.sendEmail(emailToSend);
        }
              
    }
    
    private String getFormattedDate(Datetime sourceDate) {
        
        return sourceDate.format('dd-MM-yyyy');
        
    }
    
    public void retrievePreviousLetterMap(Map<String, List<RitorniPostali__c>> previousLetterMap, Map<String, Id> mapQueue) {
        
        id queue85Id = mapQueue.get(RitorniPostaliUtils.QUEUE_85);        
        List<RitorniPostali__c> ritorni = [Select Id, OCSAnag__c, QueueId__c, LetterId__c, SentDate__c, CallDispCode__c, NewProv__c, NewCity__c, NewCap__c, NewAddress__c from RitorniPostali__c where Processato__c = 1];
        
        if (!(ritorni.isEmpty())) {
            
            for (RitorniPostali__c ritorno : ritorni) {
                
                if ((queue85Id.equals(ritorno.QueueId__c)) || (ritorno.QueueId__c == null)) {
                    
                    if (!(RitorniPostaliUtils.ESITO_DA_NON_CONTATTARE.equalsIgnoreCase(ritorno.CallDispCode__c))) {
                        
                        List<RitorniPostali__c> listaRitorniCliente = previousLetterMap.get(ritorno.OCSAnag__c);
                        if (listaRitorniCliente == null) {
                            List<RitorniPostali__c> nuovaListaRitorniCliente = new List<RitorniPostali__c>();
                            nuovaListaRitorniCliente.add(ritorno);
                            previousLetterMap.put(ritorno.OCSAnag__c, nuovaListaRitorniCliente);
                        } else {
                            listaRitorniCliente.add(ritorno);
                        }
                        
                    }                    
                    
                }
                
            }
            
        } 
        
    }
    
}