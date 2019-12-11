public class AsyncRecuperaRitorniPostali implements Queueable {
    
    public void execute(QueueableContext context) {
        
        System.debug('Avviamento...');
        retrieveRitorniPostali();
        
    }
    //next methods
    @Future(callout=true)
    private static void retrieveRitorniPostali() {
        final String EMPTY_STRING = ''; 
        final String ZERO_VALUE = '0';        
        String strFlagError = null;
        
        OCSRecuperaRitorniPostaliResponse data;
        try {
            data = OCSRecuperaRitorniPostaliInvoker.recuperaRitorniPostali();           
        } catch (Exception e) {
            strFlagError = e.getMessage();
        }
        
        if (strFlagError == null) {
            List<OCSRecuperaRitorniPostaliResponse.RitornoPostaleDTO> ritorniJson = data.ritorniPostali;
            if ((ritorniJson != null) && (ritorniJson.size() > 0)) {
                List<RitorniPostali__c> ritorniPostaliDaInserire = new List<RitorniPostali__c>();
            	Map<Account, Account> accountMap = new Map<Account, Account>();
                Boolean pickListsHaveRightValues = false;
            	Schema.DescribeFieldResult fieldResult = RitorniPostali__c.LetterTypeId__c.getDescribe();
            	List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                Map<String, Id> branchesMap = AccountUtils.getBranchMapByOCSCode();
                
                for (OCSRecuperaRitorniPostaliResponse.RitornoPostaleDTO ritornoJson: ritorniJson) {
                    pickListsHaveRightValues = pickListHasRightValue(ple, ritornoJson.tipoLettera);
                    if (pickListsHaveRightValues) {
                        Account acc = new Account(OCS_External_Id__c = ritornoJson.codCliente,                                                
                                                  FirstName = ritornoJson.nome,
                                                  LastName = ritornoJson.cognome,
                                                  Codice_Fiscale__pc = ritornoJson.codFiscale,
                                                  PersonEmail = ritornoJson.email,
                                                  PersonBirthdate = getDateValue(ritornoJson.dataNascita),
                                                  Birthcity__c = ritornoJson.luogoNascita,
                                                  Birthprovince__c = ritornoJson.provNascita,
                                                  Sesso__pc = ritornoJson.sesso,
                                                  ShippingStreet = ritornoJson.IndirizzoInvio,
                                                  ShippingCity = ritornoJson.LocalitaInvio,
                                                  ShippingCountry = ritornoJson.ProvinciaInvio,
                                                  Phone = ritornoJson.telefonoCasa,
                                                  PersonMobilePhone = ritornoJson.telCellulare
                                                 );
                        
                        accountMap.put(acc, null);
                        
                        RitorniPostali__c objRitornoPostale = new RitorniPostali__c();
                        objRitornoPostale.LetterId__c = ritornoJson.progressivoPostel;
                        objRitornoPostale.LetterTypeId__c = ritornoJson.tipoLettera;
                        objRitornoPostale.ReturnedReason__c = ritornoJson.causaleRitorno;
                        objRitornoPostale.ReturnedDate__c = getDateValue(ritornoJson.dataRitorno);
                        objRitornoPostale.OCSAnag__c = ritornoJson.codCliente;
                        objRitornoPostale.OriginalAddress__c = ritornoJson.indirizzo;
                        objRitornoPostale.OriginalCap__c = ritornoJson.cap;
                        objRitornoPostale.OriginalCity__c = ritornoJson.localita;
                        objRitornoPostale.OriginalProv__c = ritornoJson.provincia;
                        objRitornoPostale.NewAddress__c = ritornoJson.indirizzo;
                        objRitornoPostale.NewCap__c = ritornoJson.cap;
                        objRitornoPostale.NewCity__c = ritornoJson.localita;
                        objRitornoPostale.NewProv__c = ritornoJson.provincia;
                        String strCodFiliale = ritornoJson.codFiliale;
                        if (!(ZERO_VALUE.equals(strCodFiliale))) {
                            
                            String strSearchBranchKey = AccountUtils.OCSBranchChar + strCodFiliale;
                            String strBranchID = branchesMap.get(strSearchBranchKey);
                            if (!(String.isEmpty(strBranchID))) {
                                objRitornoPostale.Branch_id__c = strBranchID;
                            }
                            
                        }
                        objRitornoPostale.LetterTypeCode__c = ritornoJson.codLettera;
                        objRitornoPostale.FlagBranchViewed__c = 0;                  	                  
                        objRitornoPostale.LoanNumber__c = ritornoJson.NumPratica;                    
                        objRitornoPostale.OcsUpdated__c = 0;
                        objRitornoPostale.LoanType__c = ritornoJson.procedura;
                        objRitornoPostale.FlagNeedBranchCall__c = 0;
                        objRitornoPostale.TipoPagamento__c = ritornoJson.TipoPagamento;
                        objRitornoPostale.SmsSent__c = 0;
                        objRitornoPostale.CellPhone__c = ritornoJson.TelCellulare;
                        String strCognome = ritornoJson.Cognome;
                        if (String.isEmpty(strCognome)) {
                            objRitornoPostale.Cognome__c = ritornoJson.denominazioneAzienda; 
                        } else {
                            objRitornoPostale.Cognome__c = strCognome;
                        }
                        objRitornoPostale.Cognome__c = ritornoJson.Cognome;
                        objRitornoPostale.Nome__c = ritornoJson.Nome;
                        objRitornoPostale.SentDate__c = getDateValue(ritornoJson.DataInvio);
                        objRitornoPostale.SentAddress__c = ritornoJson.IndirizzoInvio;
                        objRitornoPostale.SentCap__c = ritornoJson.CapInvio;
                        objRitornoPostale.SentCity__c = ritornoJson.LocalitaInvio;
                        objRitornoPostale.SentProv__c = ritornoJson.ProvinciaInvio;
                        objRitornoPostale.OriginalAddressDate__c = getDateValue(ritornoJson.dataVariazioneIndirizzo);                   
                        objRitornoPostale.FlagResoMacero__c = ritornoJson.flagResoMacero;
                        objRitornoPostale.FlagFornitore__c = ritornoJson.flagFornitore;
                        objRitornoPostale.Processato__c = 0;
                        ritorniPostaliDaInserire.add(objRitornoPostale);                                                                     
                    }          
                }
                //fuori dal ciclo for
                if ((ritorniPostaliDaInserire != null) && (ritorniPostaliDaInserire.size() > 0)) {
                    Map<String, Account> accountVerifiedMap = new Map<String, Account>();
                    if ((accountMap != null) && (accountMap.size()>0)) {
                        XCSGestioneAnagrafica.deduplica(accountMap, true);                      
                    	for (Account acc : AccountMap.values()) {                       
                    		accountVerifiedMap.put(decodeOcsExternalId(acc.OCS_external_id__c), acc);
                    	}
                        for (RitorniPostali__c currRitorno : ritorniPostaliDaInserire) {
                    		currRitorno.C_id__c = accountVerifiedMap.get(currRitorno.OCSAnag__c).id;
                    	}
                    }
                    Insert ritorniPostaliDaInserire;                  	
                    System.debug('Elaborazione conclusa: Inseriti ' + String.valueOf(ritorniPostaliDaInserire.size()) + ' ritorni postali.');                    
                }
                
            } else {
                System.debug('Non ci sono ritorni postali disponibili.');               
            }                       
        } else {
            //strFlagError valorizzato...
            //mail tecnica per segnalazione errore in fase di recupero ritorni via soap
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            //String[] toAddresses = new String[]{'crm@compass.it'};
            String[] toAddresses = new String[]{'dario.mosca@lynxspa.com'};
            mail.setToAddresses(toAddresses);
            mail.setSubject('Compass: Creazione Ritorni Postali ERRORE');
            mail.setPlainTextBody('Errore: '+ strFlagError);
            EmailUtils.sendEmail(mail);
        }  
        
    }
    
    
    private static Date getDateValue(String strDate) {
               
        if (!(String.isEmpty(strDate))) {
            
            if (strDate.length() == 8) {
                return Date.newInstance(Integer.valueOf(strDate.substring(0,4)), Integer.valueOf(strDate.substring(4,6)), Integer.valueOf(strDate.substring(6,8)));   
            } else {
                throw new UnexpectedException('Errore formato data non riconosciuto.');
            }
            
        } else {
            
            return null;
            
        }
        
    }
    
    private static Boolean pickListHasRightValue(List<Schema.PicklistEntry> ple, String strValue) {
        
        Boolean ret = false;
        
        for( Schema.PicklistEntry f : ple) {
            String strPickListValue = f.getValue();        	
            if (f.getValue().equalsIgnoreCase(strValue)) {
                ret = true;
                break;
            }
        }
        return ret;
        
    }
    
    private static String decodeOcsExternalId(String OcsExternalID) {
        
        String ret = null;
        final String CHAR_C = 'C';
        
        if (CHAR_C.equalsIgnoreCase(OcsExternalID.substring(0,1))) {
            ret = OcsExternalID.substring(1);
        }
        
        return ret;
    }
}