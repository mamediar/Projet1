public with sharing class DinieghiSDDCtrl {

    public final static String QUEUE_DINIEGHI = 'Q190';    
    public final static String CATEGORIA_CASE_SINISTRO = '2234';   
    public final static String RECORD_TYPE_CASE_SINISTRI = 'CRM_Sinistri_Assicurativi';   

    private static final Map<String, String> decodeDisposition = new Map<String, String>{
        'variatoAbi' => 'DP3492',
        'variatoCab' => 'DP3493',
        'variatoCc' => 'DP3494',
        'variatoInt' => 'DP3495',
        'variatoIban' => 'DP3496',
        'inviatoNuoMan' => 'DP3497',
        'attivatoStatoMan' => 'DP3498',
        'gestitoAltroUte' => 'DP3500',
        'altro' => 'DP3501',
        'chiuVarBP' => 'DP3505',
        'verificheFil' => 'DP3503',
        'noRecapito' => 'DP3507',
        'numErrato' => 'DP3508',
        'nonRisponde' => 'DP3509',
        'irraggiungibile' => 'DP3510',
        'richiamare' => 'DP3511',
        'noInfo' => 'DP3533',
        'nonChiamare' => 'DP3490',
        'Diniego non risolto' => 'DP3502',
        'Diniego risolto' => 'DP3491'};


     private static final Map<String, String> decodeInterlocutorePickList = new Map<String, String>{
        'cliente' => 'Cliente - Coobbligato',
        'banca' => 'Banca',
        'filiale' => 'Filiale',
        'altro' => 'Altro'};



    @AuraEnabled
    public static Map<String,List<Mandati_SDD__c>> getCases(String userId, String sProfile, String sFiliale){

        List<Group> idFiliale = [SELECT Id FROM Group WHERE DeveloperName =:sFiliale Limit 1];
        List<Group> idDinieghi = [SELECT Id FROM Group WHERE DeveloperName =: QUEUE_DINIEGHI LIMIT 1];

        Id idUser = UserInfo.getUserId();
        
        Map<String,List<Mandati_SDD__c>> myMap = new Map<String,List<Mandati_SDD__c>>(); 

        if(sProfile=='Branch Employee'||sProfile=='Branch Manager'){
            List<Mandati_SDD__c> lManF =  [SELECT Id, Caseid__c,Name, PraticaNum__c, Progressivo__c, ProgreMan__c, Codice_Cliente__c, Ragione_Sociale_Cliente__c, Intestatario_cc__c, Ragione_Sociale_Intest_cc__c, 
                Modalita_Pagamento__c, Gruppo__c, Denominazione_Banca__c, Abi__c, Cab__c, ContoCorrente__c, Iban__c, Motivo_Diniego__c, Accettato__c, Stato_Mandato__c, Stato_Pratica__c, CreatedDate, Ausilio__c,
                Attrib_Pratica__c, Data_Inserimento__c, Data_Invio__c, Data_Rientro__c, Caseid__r.RecallDate__c, Filiale__c, Convenzionato__c, Telefono_Banca__c, Disposition__r.Name, Mandato__c, Provenienza__c, Numero_Tentativi__c, 
                Ultimo_Contatto__c, Note_Banca__c, Azioni_Interne__c, Mandato_SDD_OCS__c, Tipo_Messaggio__c, FORMAT(LastModifiedDate) LMD, Caseid__r.Interlocutore__c, Caseid__r.InterlocutoreAltro__c, Caseid__r.Status,
                Codice_Cliente__r.FirstName, Codice_Cliente__r.LastName, Codice_Cliente__r.OCS_External_Id__c, Codice_Cliente__r.CodiceClienteFilled__c, Codice_Cliente__r.DealerPersonaRiferimento__c, Caseid__r.Owner_User__r.Name, Caseid__r.Owner.Name
                FROM Mandati_SDD__c 
                WHERE Caseid__r.ownerID = :idFiliale[0].Id AND CaseId__r.RecordType.DeveloperName='Dinieghi_SDD_Verifiche_Filiale'
                LIMIT 1000];
            List<Mandati_SDD__c> lManF1 = new List<Mandati_SDD__c>(); 
            for (Mandati_SDD__c m : lManF){
                m.CreatedDate.addHours(1);
                lManF1.add(m);
            }
            myMap.put('All',lManF1);

        }else if(sProfile=='Backoffice'||sProfile=='System Administrator'){
            List<Mandati_SDD__c> lMan =  [SELECT Id, Caseid__c,Name, PraticaNum__c, Progressivo__c, ProgreMan__c, Codice_Cliente__c, Ragione_Sociale_Cliente__c, Intestatario_cc__c, Ragione_Sociale_Intest_cc__c, 
                Modalita_Pagamento__c, Gruppo__c, Denominazione_Banca__c, Abi__c, Cab__c, ContoCorrente__c, Iban__c, Motivo_Diniego__c, Accettato__c, Stato_Mandato__c, Stato_Pratica__c, CreatedDate, Ausilio__c,
                Attrib_Pratica__c, Data_Inserimento__c, Data_Invio__c, Data_Rientro__c, Caseid__r.RecallDate__c, Filiale__c, Convenzionato__c, Telefono_Banca__c, Disposition__r.Name, Mandato__c, Provenienza__c, Numero_Tentativi__c, 
                Ultimo_Contatto__c, Note_Banca__c, Azioni_Interne__c, Mandato_SDD_OCS__c, Tipo_Messaggio__c, LastModifiedDate, Caseid__r.Interlocutore__c, Caseid__r.InterlocutoreAltro__c, Caseid__r.Status,
                Codice_Cliente__r.FirstName, Codice_Cliente__r.LastName, Codice_Cliente__r.OCS_External_Id__c, Codice_Cliente__r.CodiceClienteFilled__c, Codice_Cliente__r.DealerPersonaRiferimento__c, Caseid__r.Owner_User__r.Name
                FROM Mandati_SDD__c 
                WHERE Caseid__r.ownerId = :idDinieghi[0].Id AND CaseId__r.RecordType.DeveloperName='Dinieghi_SDD_Verifiche_Filiale' 
                LIMIT 1000];
            List<Mandati_SDD__c> lMan2 = new List<Mandati_SDD__c>();
            for (Mandati_SDD__c m : lMan){
                m.CreatedDate.addHours(1);
                lMan2.add(m);
            }
            myMap.put('All',lMan2);


            List<Mandati_SDD__c> lMan3 =  [SELECT Id, Caseid__c,Name, PraticaNum__c, Progressivo__c, ProgreMan__c, Codice_Cliente__c, Ragione_Sociale_Cliente__c, Intestatario_cc__c, Ragione_Sociale_Intest_cc__c, 
                Modalita_Pagamento__c, Gruppo__c, Denominazione_Banca__c, Abi__c, Cab__c, ContoCorrente__c, Iban__c, Motivo_Diniego__c, Accettato__c, Stato_Mandato__c, Stato_Pratica__c, CreatedDate, Ausilio__c,
                Attrib_Pratica__c, Data_Inserimento__c, Data_Invio__c, Data_Rientro__c, Caseid__r.RecallDate__c, Filiale__c, Convenzionato__c, Telefono_Banca__c, Disposition__r.Name, Mandato__c, Provenienza__c, Numero_Tentativi__c, 
                Ultimo_Contatto__c, Note_Banca__c, Azioni_Interne__c, Mandato_SDD_OCS__c, Tipo_Messaggio__c, FORMAT(LastModifiedDate) LMD, Caseid__r.Interlocutore__c, Caseid__r.InterlocutoreAltro__c, Caseid__r.Status,
                Codice_Cliente__r.FirstName, Codice_Cliente__r.LastName, Codice_Cliente__r.OCS_External_Id__c, Codice_Cliente__r.CodiceClienteFilled__c, Codice_Cliente__r.DealerPersonaRiferimento__c, Caseid__r.Owner_User__r.Name, Caseid__r.Owner.Name
                FROM Mandati_SDD__c  
                WHERE Caseid__r.Owner_user__c = :userId 
                AND Caseid__r.ownerId = :idDinieghi[0].Id 
                LIMIT 1000];
            List<Mandati_SDD__c> lMan4 = new List<Mandati_SDD__c>();
            for (Mandati_SDD__c m2 : lMan3){
                m2.CreatedDate.addHours(1);
                lMan4.add(m2);
            }
            myMap.put('User',lMan4);
        }



		return myMap; 

    }

    @AuraEnabled
    public static List<User> getUserRole(){
        system.debug('---------------------------------------------------------');
        system.debug('-- Class Name: DinieghiSDDCtrl - Method Name: getUserRole'); 
        
        Id idGroup = [SELECT Id FROM Group WHERE developerName = 'Q190'].Id;
        System.debug('idGroup -> '+ idGroup);
        List<GroupMember> lGM = [SELECT UserOrGroupId FROM GroupMember WHERE GroupId = :idGroup];
        System.debug('lGM -> ' + lGM);
        List<Id> lGroup = new List<Id>();
        for(GroupMember g : [SELECT UserOrGroupId FROM GroupMember WHERE GroupId = :idGroup]){
            System.debug('g.UserOrGroupId -> ' + g.UserOrGroupId);
            Id iRel = [SELECT RelatedId FROM Group where id=:g.UserOrGroupId].RelatedId;
            System.debug('iRel -> ' + iRel);
            lGroup.add(iRel);
        }
        System.debug('lgroup -> ' + lGroup);
        List<User> lUser = [SELECT Name FROM User WHERE UserRoleId IN :lGroup];
        System.debug('User -> ' + lUser);
        return lUser;
    }



    @AuraEnabled
    public static Map<String,String>  getUserMap(){
        Map<String,String> sMap = new Map<String,String>();
        Id idUser = UserInfo.getUserId();
      
        sMap.put('idUser', idUser);

        String sProfile = [SELECT Profile.Name FROM User WHERE Id = :idUser].Profile.Name;
        System.debug('-- sProfile --> '+ sProfile);
        sMap.put('Profile', sProfile);

        String sFiliale = [SELECT DefaultQueueId__c FROM User WHERE Id = :idUser].DefaultQueueId__c;
        System.debug('-- sFiliale --> '+ sFiliale);
        sMap.put('Filiale', sFiliale);


        return sMap;

    }




    @AuraEnabled
    public static List<ContentNote> getNotes(Id caseId){
        system.debug('------------------------------------------------------');
        system.debug('-- Class Name: DinieghiSDDCtrl - Method Name: getNotes'); 

        return XCSNoteUtils.getAllNotes(caseId);
    }
    @AuraEnabled
    public static List<Account> getAccounts(Id manId){
        system.debug('--------------------------------------------------------');
        system.debug('-- Class Name: DinieghiSDDCtrl - Method Name: getAccount'); 
        system.debug('manId -> ' + manId);
        return [
            SELECT Id, Name, LastName, FirstName, Type, RecordTypeId, ParentId, 
            OCS_External_Id__c, Codice_Cliente__c, Data_Nascita__c, Denominazione_Azienda__c, Telefono_Casa__c, Telefono_Cellulare__c, 
            Status__c, Codice_Fiscale__c, Partita_IVA__c, Birthstate__c, Zone__c, Note__c,  
            RSS_External_Id__c, CodiceClienteFilled__c, Codice_Fiscale__pc,  
            Numero_Documento__pc, Partita_IVA__pc,  
            Sesso__pc, Tipo_Anagrafica__pc, Tipo_Documento__pc,  OCS_External_Id__pc, status__pc, RagioneSociale__pc
            FROM Account
            WHERE id = :manId LIMIT 1
            ];
    }

    @AuraEnabled
    public static String getContacts(Id manId){
        system.debug('---------------------------------------------------------------------------------------');
        system.debug('-- Class Name: DinieghiSDDCtrl - Method Name: getContacts'); 
        system.debug('-- manId -> ' + manId);
        List<Account> lAcc = [SELECT id FROM Account where id =: manId];
        List<Contact> lCon = [SELECT Name FROM Contact where Accountid =: lAcc[0].Id];

        System.debug(lCon[0].Name);
        return lCon[0].Name;
        
    }
    
    @AuraEnabled
    public static Boolean getRiassegna(Id manId, Id idU){
        system.debug('---------------------------------------------------------------------------------------');
        system.debug('-- Class Name: DinieghiSDDCtrl - Method Name: getRiassegna'); 
        system.debug('manId -> ' + manId);
        system.debug('idU -> ' + idU);

		Id idCas = [SELECT CaseId__c FROM Mandati_SDD__c WHERE id = :manId].CaseId__c;
        List<Case> upCas = new List<Case>();
        System.debug('idcas ' + idCas);
        Case cas=[SELECT Owner_User__c FROM Case WHERE Id=:idCas];
        
        cas.Owner_User__c = idU;
        
        upCas.add(cas);
        
        try{
            update upCas;
            return true;
        }catch(exception e){
            return false;
        }
//        return true;
    }




    @AuraEnabled
    public static List<Account> getFiliale(String filId){
        system.debug('---------------------------------------------------------------------------------------');
        system.debug('-- Class Name: DinieghiSDDCtrl - Method Name: getFiliale'); 
        system.debug('filId -> ' + filId);

        if (filId.length()<3){
            filId = '0'+filId;
        }

        return [
            SELECT Id, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry, ShippingLatitude, ShippingLongitude, ShippingGeocodeAccuracy, ShippingAddress, phone
            FROM Account
            WHERE CodiceClienteFilled__c  = :filId LIMIT 1
            ];
    }

   
    @AuraEnabled
    public static boolean upgradeTelNumber(String abi,  String cab, String telefono, Id idMandati){
       System.debug('abi cab telefono '+abi+' - '+cab+' - '+telefono );
        
//        abi = '01000';
//        cab = '01001';
//       telefono = '011 560456';
        OCSVariazioneTelefonoBancaResponse response = OCSVariazioneTelefonoBancaInvoker.callVariazioneTelefonoBancaSDD( abi,  cab,  telefono);
        Mandati_SDD__c m = new Mandati_SDD__c();
        
        m.Id = idMandati;
        m.Telefono_Banca__c = telefono;
        boolean result = false;
        System.debug('result response '+response.variazioneTelefoniResponse.as400Status);
        if(response.variazioneTelefoniResponse.as400Status.equals('OK')){
            result = true;
            update m;
        }
       
        System.debug('result response '+response.variazioneTelefoniResponse.as400Status);
        return  result ;        
    }
    
    @AuraEnabled
    public static String valDisposition(Id vId){
        system.debug('---------------------------------------------------------------------------------------');
        system.debug('-- Class Name: DinieghiSDDCtrl - Method Name: valDisposition'); 
        system.debug('-- vId -> ' + vId);
        
        XCS_Disposition__c disp = XCS_DispositionUtils.getDisposition(vId);
       
        
        System.debug('getDisposition Response '+ disp.External_id__c);
        return disp.External_id__c;
    }



    private static XCS_Disposition__c decodeEsito (String esito) {
        XCS_Disposition__c disposition = null;

        if (esito!=null) {
            if(esito=='risolto'){
                esito='Diniego risolto';
            }else if(esito=='nonRisolto'){
                esito='Diniego non risolto';
            }
            
            String codDisposition = decodeDisposition.get(esito);
            if (codDisposition!=null) {
                    disposition =XCS_DispositionUtils.findDispositionByExternalID(codDisposition); 
            }
        }
        return disposition;
    }



    private static OCSGestioneNoteResponse invioNoteOCS(String notaOCS,String codiceCliente, String numPratica, String tipoMessaggio){
        String strUserAlias = [select Alias from User where Id=:UserInfo.getUserId()].Alias;
        return OCSGestioneNoteInvoker.gestioneNote(strUserAlias,codiceCliente,numPratica, tipoMessaggio, 'A','P',notaOCS ); // SCRIVO NOTA OCS 
    }


    @AuraEnabled
    public static boolean upgradeMandato(String sAusilio, String esito, String nota, Id idMandato, Datetime nData, String interlocutore,String altroInterlocutore, Boolean sUser){
        system.debug('---------------------------------------------------------------------------------------');
        system.debug('-- Class Name: DinieghiSDDCtrl - Method Name: upgradeMandato'); 
        System.debug('-- Ausilio '+sAusilio);
        System.debug('-- Esito '+esito);
        System.debug('-- Nota '+nota);
        System.debug('-- Id '+idMandato);
        System.debug('-- nData '+nData);
        System.debug('-- interlocutore '+interlocutore);
        System.debug('-- altroInterlocutore '+altroInterlocutore);
        System.debug('-- userIsBO '+sUser);

        Boolean result = false;
        String as400Status;
    	String as400Errore;
        String sNota;
        String titleNote;
        
        Mandati_SDD__c man = [select id,PraticaNum__c, Stato_Mandato__c,Abi__c, Cab__c, Tipo_Messaggio__c, Modalita_Pagamento__c, ContoCorrente__c, Iban__c, Intestatario_cc__c,
                             Caseid__c, Ausilio__c, Filiale__c FROM Mandati_SDD__c
                             WHERE Id =:idMandato];
        Case caseDin = [SELECT ID,RecallDate__c, Tipo_Pratica__c FROM Case WHERE ID=:man.Caseid__c];
		
        if(sUser==true){ // UTENTE CRM
            if(esito=='richiamare'){
                result = true;
            }
            if(esito=='variatoAbi' || esito=='variatoCab' || esito=='variatoCc' || esito=='variatoInt' || esito=='variatoIban' || esito=='inviatoNuoMan' ||
               esito=='attivatoStatoMan' || esito=='gestitoAltroUte' || esito=='altro'){
                   caseDin.Status = 'Gestito';
                   man.Stato_Mandato__c = 'Gestito';
                   man.Ausilio__c = sAusilio;
                   Nota = Nota + 'Diniego Risolto - Esito: ' + esito; 
                   result = true;    	
               }
            if(esito=='noRecapito' || esito=='numErrato' || esito=='nonRisponde' || esito=='irraggiungibile' || esito=='noInfo'){
                result = true;    	
            }

            // update case
            if (nData !=null && esito=='richiamare') {
                caseDin.RecallDate__c = nData;
            }                 
            if (String.isNotEmpty(interlocutore)) {
                interlocutore = decodeInterlocutorePickList.get(interlocutore);
                if (interlocutore!=null) {
                    caseDin.Interlocutore__c = interlocutore;
                }
            }
            if (esito=='verificheFil') {
                result = true;
                String devName = 'F'+man.Filiale__c;
                List<Group> idFil = [SELECT Id FROM Group WHERE DeveloperName =:devName LIMIT 1];
                System.debug('idFil --> '+ idFil[0].Id);
                caseDin.OwnerId = idFil[0].Id;
                man.Ausilio__c = sAusilio;

            }
            if (esito=='chiuVarBP') {
                if(caseDin.Tipo_Pratica__c !='CA'){
                    // INVOCO SERVIZIO variazioneDatiPagamento
                    OCSVariazioneDatiPagamentoRequest req = new OCSVariazioneDatiPagamentoRequest();
                    req.VariazioneDatiPagamentoRequest.provenienza = man.Tipo_Messaggio__c;
                    req.VariazioneDatiPagamentoRequest.tipoIntermediario = '';
                    req.VariazioneDatiPagamentoRequest.intermediario = '';
                    req.VariazioneDatiPagamentoRequest.procedura = man.Tipo_Messaggio__c;
                    req.VariazioneDatiPagamentoRequest.numPratica = man.PraticaNum__c;
                    req.VariazioneDatiPagamentoRequest.pagForma = man.Modalita_Pagamento__c;
                    req.VariazioneDatiPagamentoRequest.ecFrequenza = '';
                    req.VariazioneDatiPagamentoRequest.abi = man.Abi__c;
                    req.VariazioneDatiPagamentoRequest.cab = man.Cab__c ;
                    req.VariazioneDatiPagamentoRequest.cc = man.ContoCorrente__c ;
                    req.VariazioneDatiPagamentoRequest.cinBban = '';
                    req.VariazioneDatiPagamentoRequest.cinIban = '';
                    req.VariazioneDatiPagamentoRequest.paeseIban = '';
                    req.VariazioneDatiPagamentoRequest.iban = man.Iban__c ;
                    req.VariazioneDatiPagamentoRequest.intCc = man.Intestatario_cc__c;
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
                    
                    man.Modalita_Pagamento__c = 'BP';
                    //CONTROLLO CODE RESPONSE
                    
                    if (varDatiPagamento.resultCode == 0){
                        // CONTROLLO MESSAGGIO DI STATUS
                        if(as400Status == 'KO'){
                            // CONTROLLO MESSAGGIO DI ERRORE
                            if(as400Errore.contains('6316') || as400Errore.contains('5907')){
                                //non segnalo errore
                                system.debug('NON SEGNALO ERRORE');
                            }
                            sNota = 'Diniego NON RISOLTO - Esito : ' + esito;
                        }
                    }
                }
				caseDin.Status = 'Gestito';
				man.Stato_Mandato__c = 'Chiuso';                
                man.Ausilio__c = sAusilio;
                result = true;
            }
            if (String.isNotEmpty(altroInterlocutore)) {
                caseDin.InterlocutoreAltro__c = altroInterlocutore;
            }
            // update note e invio note OCS  
            if (String.isNotEmpty(nota)){
                String ufficioDinieghi = CompassParametersUtils.getValue('ufficio.dinieghi');  
                titleNote = 'cc - '+ufficioDinieghi+' - '+UserInfo.getUserName()+': '+interlocutore;
                invioNoteOCS(nota,'',man.PraticaNum__c,man.Tipo_Messaggio__c);
                XCSNoteUtils.postANote(man.id,titleNote,nota);
            }
            // update diniego
//            XCS_Disposition__c disposition = decodeEsito(esito);
//            if (disposition!=null) {
//                man.Disposition__c = disposition.id;           
//            }
//            update caseDin;
//            update man;
            
        }else if(sUser==false){ // UTENTE SFA
            if (esito=='risolto') {
                result = true;
                List<Group> idDin = [SELECT Id FROM Group WHERE DeveloperName =: QUEUE_DINIEGHI LIMIT 1];
                caseDin.OwnerId = idDin[0].Id;
                titleNote = 'Dinieghi';
                sNota = 'Verifiche effettuate da Filiale ' + '- Diniego Risolto - Note della filiale:' + nota + ' si prega di esitare e chiudere la posizione';
                invioNoteOCS(sNota,'',man.PraticaNum__c,man.Tipo_Messaggio__c);
                XCSNoteUtils.postANote(man.id,titleNote,sNota);
            }else if(esito=='nonRisolto'){
                caseDin.Status = 'Gestito';
                man.Stato_Mandato__c = 'Chiuso';
                if(caseDin.Tipo_Pratica__c !='CA'){
                    // INVOCO SERVIZIO variazioneDatiPagamento
                    // 	            //set della request
                    OCSVariazioneDatiPagamentoRequest req = new OCSVariazioneDatiPagamentoRequest();
                    req.VariazioneDatiPagamentoRequest.provenienza = man.Tipo_Messaggio__c;
                    req.VariazioneDatiPagamentoRequest.tipoIntermediario = '';
                    req.VariazioneDatiPagamentoRequest.intermediario = '';
                    req.VariazioneDatiPagamentoRequest.procedura = man.Tipo_Messaggio__c;
                    req.VariazioneDatiPagamentoRequest.numPratica = man.PraticaNum__c;
                    req.VariazioneDatiPagamentoRequest.pagForma = man.Modalita_Pagamento__c;
                    req.VariazioneDatiPagamentoRequest.ecFrequenza = '';
                    req.VariazioneDatiPagamentoRequest.abi = man.Abi__c;
                    req.VariazioneDatiPagamentoRequest.cab = man.Cab__c ;
                    req.VariazioneDatiPagamentoRequest.cc = man.ContoCorrente__c ;
                    req.VariazioneDatiPagamentoRequest.cinBban = '';
                    req.VariazioneDatiPagamentoRequest.cinIban = '';
                    req.VariazioneDatiPagamentoRequest.paeseIban = '';
                    req.VariazioneDatiPagamentoRequest.iban = man.Iban__c ;
                    req.VariazioneDatiPagamentoRequest.intCc = man.Intestatario_cc__c;
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
                    
                    man.Modalita_Pagamento__c = 'BP';
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
                                sNota = 'Diniego NON RISOLTO - rilevata modalità di pagamento già a BP';
                            }else{
                                sNota = 'Diniego NON RISOLTO - Effettuata variazione Modalità pagamento a BP';
                            }
                        }
                    }
                }else{
                    sNota = 'Diniego NON RISOLTO';
                }
                titleNote = 'Dinieghi';
                sNota = sNota + 'La posizione è chiusa';
                invioNoteOCS(sNota,'',man.PraticaNum__c,man.Tipo_Messaggio__c);
                XCSNoteUtils.postANote(man.id,titleNote,sNota);
                
            }
        }
        
        XCS_Disposition__c disposition = decodeEsito(esito);
        if (disposition!=null) {
            man.Disposition__c = disposition.id;           
        }
        update man;
        update caseDin;
        return  result ;           
    }     

    @AuraEnabled
    public static List<ContentDocumentLink> finishUploadFile(String recordId, String documentId, String nameFile){  
        
        ContentVersion cv = [select id from contentversion where contentdocumentid = :documentId];
        ContentDistribution cd = new ContentDistribution();

        cd.Name = nameFile;
        cd.ContentVersionId = cv.id;
        cd.PreferencesAllowViewInBrowser= true;
        cd.PreferencesLinkLatestVersion=true;
        cd.PreferencesNotifyOnVisit=false;
        cd.PreferencesPasswordRequired=false;
        cd.PreferencesAllowOriginalDownload= true;        
        insert cd;
        
//        return createRecordForUploadFile();
        return getFile(recordId);
    }

        @AuraEnabled
    public static List<ContentDocumentLink> getFile(String recordId){  
        
        System.debug('recordId '+ recordId);
        List<ContentDocumentLink> cdl = [SELECT id,ContentDocumentId,LinkedEntityId,ContentDocument.title,ContentDocument.FileExtension, ContentDocument.FileType,  ContentDocument.CreatedDate, ContentDocument.ArchivedDate 
                                         FROM ContentDocumentLink 
                                         WHERE LinkedEntityId  = : recordId];
       
        return cdl;
    }
        @AuraEnabled   

    public static string Attachment(Id DownloadAttachmentID, String s){
        
		String fullFileURL;
        String URlDownload;

        if(s == 'D'){
            ContentVersion oldCV = [Select Id,Title from ContentVersion Where ContentDocumentId=:DownloadAttachmentID and IsLatest = true ];
            System.Debug('Old LV INitial :'+ oldCV.Id);
            fullFileURL = URL.getSalesforceBaseUrl().toExternalForm();
            URlDownload = fullFileURL+'/sfc/servlet.shepherd/version/download/'+oldCV.Id;
            system.debug('Download URL:' +URlDownload);
            return URlDownload;
        }else{
//            ContentVersion dCV = [Select Id,Title from ContentVersion Where ContentDocumentId=:DownloadAttachmentID and IsLatest = true ];
//            delete dCV;
            ContentDocument dCD = [SELECT Id FROM ContentDocument WHERE id=:DownloadAttachmentID ];
            delete dCD;
            return 'delete';
            
        }

    }     
    
    
}