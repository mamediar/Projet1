public class EasyCMClass {
	
	@AuraEnabled
	public static InitWrapper initApex(Id caseId){ 
        InitWrapper initWrapper;
        //String ocsCode = '229370';// fido OK
        //'2419539';//'C18389650';
        //'1231236';
        //String telephoneNumber = '334 3355026';//'327 8364355';

        Case theCase = getCase(caseId);

        Map<String,String> inputMap = getJsonInfo(theCase);    

        String ocsCode = inputMap.get('ocsCode');
        String telephoneNumber = inputMap.get('telephoneNumber');
        System.debug('ocsCode-->'+ocsCode);

        if(String.isNotBlank(ocsCode)){
            OCSSchedaClienteResponse res= OCSSchedaClienteInvoker.callGetSchedaCliente(ocsCode);
            System.debug('res.isOK():'+res.isOK());
            System.debug('res.cliente:'+res.cliente);
            if(res.isOK()&& res.cliente != null && res.cliente.size() == 1){
                
                //callout 
                OCSSchedaClienteResponse.PSVDatiClienteDTO datiCliente = res.cliente[0];
                System.debug('datiCliente-->'+datiCliente);
                List<OCSSchedaClienteResponse.PSVDatiPraticaDTO> praticheList = res.pratiche;
                DatiCommercialiWrapper datiCommerciali = new DatiCommercialiWrapper(ocsCode);

                // dml, non puoi più fare chiamate ws
                Account account = invokeModuloAnagrafica(res.cliente[0]);
                datiCommerciali.populateRetention(account);
                theCase.AccountId = account.Id;
                StoricoChiamateWrapper storicoChiamate = new StoricoChiamateWrapper(theCase); // ha bisogno dell account id nel case
                update theCase; 
                List<DataTableWrapperRow> privacyList = getPrivacyList(res.cliente[0],account);
                initWrapper = new InitWrapper(account,storicoChiamate,privacyList,datiCliente,praticheList,telephoneNumber,datiCommerciali);	
            }
            else{
                initWrapper = new InitWrapper(telephoneNumber);

            }
        }
        else{
            initWrapper = new InitWrapper(telephoneNumber);
        }

        return initWrapper;
	}

    @AuraEnabled
	public static InitWrapper initFromAccount(Id caseId,Account theAccount){ 
        Case theCase = getCase(caseId);

        Map<String,String> inputMap = getJsonInfo(theCase);        

        String telephoneNumber = inputMap.get('telephoneNumber');

        InitWrapper initWrapper;
        theCase.AccountId = theAccount.Id;
        StoricoChiamateWrapper storicoChiamate = new StoricoChiamateWrapper(theCase);
        
        if(String.isNotBlank(theAccount.OCS_External_id__c)){
            OCSSchedaClienteResponse res= OCSSchedaClienteInvoker.callGetSchedaCliente(theAccount.OCS_External_id__c);
            System.debug('status ' + res.status + ' cliente' + res.cliente);
            System.debug('res.isOK():'+res.isOK());
            if(res.isOK()&& res.cliente != null && res.cliente.size() == 1){
                DatiCommercialiWrapper datiCommerciali = new DatiCommercialiWrapper(theAccount.OCS_External_id__c);
                theAccount = invokeModuloAnagrafica(res.cliente[0]);
                theCase.AccountId = theAccount.Id;//se il modulo anagrafica ci restituisce un account diverso
                datiCommerciali.populateRetention(theAccount);
                List<DataTableWrapperRow> privacyList = getPrivacyList(res.cliente[0],theAccount);
                OCSSchedaClienteResponse.PSVDatiClienteDTO datiCliente = res.cliente[0];
                List<OCSSchedaClienteResponse.PSVDatiPraticaDTO> praticheList = res.pratiche;
                
                initWrapper = new InitWrapper(theAccount,storicoChiamate,privacyList,datiCliente,praticheList,telephoneNumber,datiCommerciali);	
            }
            else{
                OCSSchedaClienteResponse.PSVDatiClienteDTO datiCliente = createResponseFromAccount(theAccount);
                List<DataTableWrapperRow> privacyList = getPrivacyList(datiCliente,theAccount);
                initWrapper = new InitWrapper(theAccount,storicoChiamate,privacyList,datiCliente,null,telephoneNumber,null);
            }
        }
        else{
            OCSSchedaClienteResponse.PSVDatiClienteDTO datiCliente = createResponseFromAccount(theAccount);
            List<DataTableWrapperRow> privacyList = getPrivacyList(datiCliente,theAccount);
            initWrapper = new InitWrapper(theAccount,storicoChiamate,privacyList,datiCliente,null,telephoneNumber,null);	
        }

        update theCase;

        return initWrapper;
	}

    @AuraEnabled 
    public static VerificaFidoUtilClass.CheckFidoWrapper getFidoWrapper(OCSSchedaClienteResponse.PSVDatiPraticaDTO thePratica){
        
        return VerificaFidoUtilClass.VerifyAumentoFido(thePratica);
    }

    @AuraEnabled
    public static void updateAccountEmail(Account theAccount, String theMail){
        theAccount.PersonEmail = theMail;
        update theAccount;
    }

	public class InitWrapper {
        
        @AuraEnabled
        public Account account;
        @AuraEnabled
        public StoricoChiamateWrapper storicoChiamate;
        @AuraEnabled
        public List<DataTableWrapperRow> privacyList;
        @AuraEnabled
        public OCSSchedaClienteResponse.PSVDatiClienteDTO datiCliente;
        @AuraEnabled
        public List<OCSSchedaClienteResponse.PSVDatiPraticaDTO> praticheList;
        @AuraEnabled
        public List<ButtonWrapper> buttonList;
        @AuraEnabled
        public String telephoneNumber;
        @AuraEnabled
        public DatiCommercialiWrapper datiCommerciali;
       
        public InitWrapper( Account account,
                            StoricoChiamateWrapper storicoChiamate,
                            List<DataTableWrapperRow> privacyList,
                            OCSSchedaClienteResponse.PSVDatiClienteDTO datiCliente,
                            List<OCSSchedaClienteResponse.PSVDatiPraticaDTO> praticheList,
                            String telephoneNumber,
                            DatiCommercialiWrapper datiCommerciali){
            this.storicoChiamate = storicoChiamate;
			this.privacyList = privacyList;
            this.datiCliente = datiCliente;
            this.praticheList = praticheList;
            this.buttonList = getButtonList();
            this.account = account;
            this.telephoneNumber = telephoneNumber;
            this.datiCommerciali = datiCommerciali;
        }

        public InitWrapper(String telephoneNumber){
            this.telephoneNumber = telephoneNumber;
        }

	}

    public class ButtonWrapper {
	  
        @AuraEnabled
        public String buttonLabel;
        @AuraEnabled
        public Boolean checkIncomingCall;
        @AuraEnabled
        public String pvCategory;

        public ButtonWrapper(String buttonLabel,Boolean checkIncomingCall,String pvCategory){

			this.buttonLabel = buttonLabel;
			this.checkIncomingCall = checkIncomingCall;
            this.pvCategory = pvCategory;
        }

	}

	public class StoricoChiamateWrapper {
	  
        @AuraEnabled
        public Date ultimaChiamata;
        @AuraEnabled
        public String esitoSurvey;
        @AuraEnabled
        public String esitoUltimaChiamata;

        public StoricoChiamateWrapper(Case theCase){
        List<Case> lastCases = [SELECT Id,CreatedDate,Esito__c,RisultatoSurvey__c FROM Case WHERE RecordTypeId =: theCase.recordTypeId AND AccountId =: theCase.accountId AND Id !=: theCase.Id ORDER BY CreatedDate DESC LIMIT 1];

            this.ultimaChiamata = lastCases.isEmpty() ? null : lastCases[0].CreatedDate.date();
            this.esitoUltimaChiamata = lastCases.isEmpty() ? null : lastCases[0].Esito__c;
            this.esitoSurvey = lastCases.isEmpty() ? null : lastCases[0].RisultatoSurvey__c;
            
        }
	}

    public class DatiCommercialiWrapper {
	  
        @AuraEnabled
        public String retention;
        @AuraEnabled
        public String retentionCarte;

        public DatiCommercialiWrapper(String ocsCode){
        
            this.retentionCarte = getRetentionCarte(ocsCode);
            
        }
        public void populateRetention(Account theAccount){
        
            this.retention = getRetention(theAccount);
            
        }
 
       
	}

    public class DataTableWrapperRow {
	  
        @AuraEnabled
        public String label;
        @AuraEnabled
        public String value;
        
        public DataTableWrapperRow(String label,String value){

			this.label = label;
			this.value = value;
        }
    }

    private static Map<String,String> getJsonInfo(Case theCase){
        String jsonInputString = theCase.Description;
        if(String.isBlank(jsonInputString)){
            AuraHandledException e = new AuraHandledException('campo di input non valorizzato');
			e.setMessage('campo di input non valorizzato');
			throw e;
        }

        Map<String,String> inputMap;

        try{
            inputMap = (Map<String,String>)JSON.deserialize(jsonInputString,Map<String,String>.class);
        }
        catch(Exception eccex){
            AuraHandledException e = new AuraHandledException('campo di input non valido');
			e.setMessage('campo di input non valido');
			throw e;
        }

        return inputMap;
    }

    private static List<DataTableWrapperRow> getPrivacyList(OCSSchedaClienteResponse.PSVDatiClienteDTO datiCliente,Account theAccount){
        List<DataTableWrapperRow> labelList = new List<DataTableWrapperRow>();
        labelList.add(new DataTableWrapperRow('Opt-in Globale',theAccount.Ma_Opt_In__pc ? 'S' : 'N'));
        labelList.add(new DataTableWrapperRow('Privacy SMS',theAccount.Privacy_SMS__pc ? 'S' : 'N'));
        labelList.add(new DataTableWrapperRow('istruttoria pratiche',datiCliente.flagIstruttoriPratiche));
        labelList.add(new DataTableWrapperRow('società rilevazione qualità',datiCliente.flagRilevaQualit));
        labelList.add(new DataTableWrapperRow('offerte commerciali int',datiCliente.flagOffCommInt));
        labelList.add(new DataTableWrapperRow('offerte commerciali int.aut',datiCliente.flagOffCommIntAut));
        labelList.add(new DataTableWrapperRow('offerte commerciali est',datiCliente.flagOffCommEst));
        labelList.add(new DataTableWrapperRow('offerte commerciali est.aut',datiCliente.flagOffCommEstAut));
        System.debug('datiCliente.flagOffCommEstAut-->'+datiCliente.flagOffCommEstAut);
        System.debug('datiCliente.flagDatiSensibili-->'+datiCliente.flagDatiSensibili);
        labelList.add(new DataTableWrapperRow('offerte servizi altri',datiCliente.flagDatiSensibili));
        
        return labelList;
    }
 
    private static List<ButtonWrapper> getButtonList(){
        List<ButtonWrapper> buttonList = new List<ButtonWrapper>();
        buttonList.add(new ButtonWrapper('Variazione Telefono',true,'3261'));
        buttonList.add(new ButtonWrapper('Attivazione Carta',true,'3481'));
        buttonList.add(new ButtonWrapper('Variazione Email',false,'3388'));
        buttonList.add(new ButtonWrapper('Variazione Cellulare',false,'3261'));
        buttonList.add(new ButtonWrapper('Variazione Indirizzi',false,'3267'));
        buttonList.add(new ButtonWrapper('Ric Info Assicurative',false,'6203'));
        return buttonList;
    }

    private static Account invokeModuloAnagrafica(OCSSchedaClienteResponse.PSVDatiClienteDTO cm){
        String codCliente = 'C'+cm.codCliente;

        List<Account> accList = [SELECT Id,PersonEmail,Privacy_SMS__pc,Ma_Opt_In__pc FROM Account WHERE OCS_External_id__c =: codCliente];

        // mock in attesa del modulo anagrafica0
        Account account = new Account(
                	//Name = (String.isBlank(cm.denominazioneAzienda))?(cm.cognome + ' ' + cm.nome):cm.denominazioneAzienda,
                    LastName = cm.cognome,
                    OCS_External_id__c = 'C'+cm.codCliente,
                    FirstName = cm.nome,
                	Data_Nascita__c = dateToParse(cm.dataNascita),  //cm.dataNascita == '0' ?  date.today() : date.parse(cm.dataNascita),
                    Luogo_Nascita__pc = cm.luogoNascita,
                    Provincia_Nascita__pc = cm.provNascita,
                    Sesso__pc = cm.sesso,
                    Codice_Fiscale__pc = cm.codFiscale,
                    Partita_IVA__pc = cm.piva,
                    PersonMailingStreet = cm.indirizzo,
                    PersonMailingPostalCode = cm.cap,
                    PersonMailingCity = cm.localita,
                    PersonMailingCountry = cm.provincia,
                    PersonEmail = !accList.isEmpty() && String.isNotBlank(accList[0].PersonEmail) ? accList[0].PersonEmail : cm.email,
                    Tipo_documento__pc = cm.tipoDocumento,
                    Numero_Documento__pc = cm.numDocumento,
                    Ufficio_Rilascio__c = cm.ufficioRilascio,
                    Luogo_Rilascio__pc = cm.luogoRilascio,
                    Provincia_Rilascio__pc = cm.provRilascio,
                    Data_Rilascio__pc = dateToParse(cm.dataRilascio),
                    Denominazione_Azienda__c = cm.denominazioneAzienda,
                    Forma_Giuridica__c = cm.formaGiuridica,
                    Tipo_Anagrafica__pc = cm.tipoAnagrafica,
                    Data_Scadenza__pc = dateToParse(cm.dataScadenza),
                    Telefono_Casa__c = cm.telefonoCasa,
                    Telefono_Cellulare__c = cm.telCellulare,
                    Fax = cm.telFax,
                    Tipo_Rapporto__c = cm.tipoRapporto,
                    Ma_Opt_In__pc = !accList.isEmpty() && null != accList[0].Ma_Opt_In__pc ? accList[0].Ma_Opt_In__pc : false,
                    Privacy_SMS__pc = !accList.isEmpty() && null != accList[0].Privacy_SMS__pc ? accList[0].Privacy_SMS__pc : false,
                    Data_Depennamento__c = dateToParse(cm.dataDepennamento),
                    InvestFlag__pc = 'S'.equalsIgnoreCase(cm.flagIstruttoriPratiche) ? true : false,
                    Qualitydetectionflag__pc = 'S'.equalsIgnoreCase(cm.flagRilevaQualit) ? true : false,
                    Interncommoffer__pc = 'S'.equalsIgnoreCase(cm.flagOffCommInt) ? true : false,
                    Privacy_Profilazione__pc = 'S'.equalsIgnoreCase(cm.flagOffCommIntAut) ? true : false,
                    Extcommoffer__pc = 'S'.equalsIgnoreCase(cm.flagOffCommEst) ? true : false,
                    OtherService__pc = 'S'.equalsIgnoreCase(cm.flagDatiSensibili) ? true : false                                                 
        );
        upsert account OCS_External_id__c;
        return account;
    }

    private static OCSSchedaClienteResponse.PSVDatiClienteDTO createResponseFromAccount(Account acc){

        OCSSchedaClienteResponse.PSVDatiClienteDTO datiCliente = new OCSSchedaClienteResponse.PSVDatiClienteDTO();
            datiCliente.denominazioneAzienda = acc.Name;
            datiCliente.cognome = acc.LastName;
            datiCliente.codCliente = '';
            datiCliente.nome = acc.FirstName;
            datiCliente.dataNascita = acc.Data_Nascita__c == null ? null : acc.Data_Nascita__c.format();
            datiCliente.luogoNascita = acc.Luogo_Nascita__pc;
            datiCliente.provNascita = acc.Provincia_Nascita__pc;
            datiCliente.sesso = acc.Sesso__pc;
            datiCliente.codFiscale = acc.Codice_Fiscale__pc;
            datiCliente.piva = acc.Partita_IVA__pc;
            datiCliente.indirizzo = acc.PersonMailingStreet;
            datiCliente.cap = acc.PersonMailingPostalCode;
            datiCliente.localita = acc.PersonMailingCity;
            datiCliente.provincia = acc.PersonMailingCountry;
            datiCliente.email = '';
            datiCliente.tipoDocumento = acc.Tipo_documento__pc;
            datiCliente.numDocumento = acc.Numero_Documento__pc;
            datiCliente.ufficioRilascio = acc.Ufficio_Rilascio__c;
            datiCliente.luogoRilascio = acc.Luogo_Rilascio__pc;
            datiCliente.provRilascio = acc.Provincia_Rilascio__pc;
            datiCliente.dataRilascio = acc.Data_Rilascio__pc == null ? null : acc.Data_Rilascio__pc.format();
            datiCliente.denominazioneAzienda = acc.Denominazione_Azienda__c;
            datiCliente.formaGiuridica = acc.Forma_Giuridica__c;
            datiCliente.tipoAnagrafica = acc.Tipo_Anagrafica__pc;
            datiCliente.dataScadenza = acc.Data_Scadenza__pc == null ? null : acc.Data_Scadenza__pc.format();
            datiCliente.telefonoCasa = acc.Telefono_Casa__c;
            datiCliente.telCellulare = acc.Telefono_Cellulare__c;
            datiCliente.tipoRapporto = acc.Tipo_Rapporto__c;
            datiCliente.dataDepennamento = acc.Data_Depennamento__c == null ? null : acc.Data_Depennamento__c.format();
            datiCliente.flagIstruttoriPratiche = acc.InvestFlag__pc ? 'S' : 'N';
            datiCliente.flagRilevaQualit = acc.Qualitydetectionflag__pc ? 'S' : 'N';
            datiCliente.flagOffCommInt = acc.Interncommoffer__pc ? 'S' : 'N';
            //datiCliente.flagOffCommIntAut = acc.Privacy_Profilazione__pc ? 'Y' : 'N';
            datiCliente.flagOffCommEst = acc.Extcommoffer__pc ? 'S' : 'N';
            datiCliente.flagDatiSensibili = acc.OtherService__pc ? 'S' : 'N';

        return datiCliente;
    }

    // da rimuovere
    private static Date dateToParse(String dateOCS){
        Date res = null;
        res = (dateOCS != '0' && dateOCS != null) ? 
              Date.newInstance(Integer.valueOf(dateOCS.substring(0, 4)), 
                               Integer.valueOf(dateOCS.substring(4,6)),
                               Integer.valueOf(dateOCS.substring(6))) : null;
        System.debug(res);
        return res;
    }

    private static String getRetentionCarte(String ocsCode){
        ocsCode = ocsCode.replace('C','');
        OCSRecuperaRetentionCarteResponse response = OCSRecuperaRetentionCarteInvoker.invoke(ocsCode);
        String retentionCarte = 'KO';
        if (response != null && response.recuperaRetentionCarteResponse != null && response.recuperaRetentionCarteResponse.elencoCarte != null){
            for(OCSRecuperaRetentionCarteResponse.CartaResponse carta : response.recuperaRetentionCarteResponse.elencoCarte){
                if('ok'.equalsIgnoreCase(carta.esitoRetention) || 'con'.equalsIgnoreCase(carta.esitoRetention)){
                    retentionCarte = 'OK';
                    break;
                }    
            }
        }
        return retentionCarte;
    }

    private static Case getCase(Id caseId){
        return [SELECT Id,CreatedDate,Esito__c,RecordTypeId,accountId,Description FROM Case WHERE Id =: caseId];
    }

    private static String getRetention(Account theAccount){
        List<Account_Retention__c> listAccRet = [SELECT Id,Esito__c FROM Account_Retention__c WHERE Customer__c =: theAccount.Id];
        return listAccRet.isEmpty() ? null : listAccRet[0].Esito__c;
    }

}