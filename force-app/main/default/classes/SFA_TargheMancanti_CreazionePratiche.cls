public class SFA_TargheMancanti_CreazionePratiche implements Queueable {

    private String fileId;
    private String caseId;
    private Date dataScadenza;
    
    public SFA_TargheMancanti_CreazionePratiche(String fileId, String caseId, Date dataScadenza) {
        this.fileId = fileId;
        this.caseId = caseId;
        this.dataScadenza = dataScadenza;
    }

    public void execute(QueueableContext context) {
        Map<String, Integer> fieldNumberMap = new Map<String, Integer>();

		Integer fieldNumber;

		String fieldValue;

		List<String> lstFieldNames = new List<String>();

		List<Case> lstChildCasesOK = new List<Case>();
        List<Case> lstChildCasesProdKO = new List<Case>();
        List<Case> lstChildCasesDealerNotFound = new List<Case>();

        List<SFATargaMancante__c> lstPraticheOK = new List<SFATargaMancante__c>();
        List<SFATargaMancante__c> lstPraticheProdKO = new List<SFATargaMancante__c>();
        List<SFATargaMancante__c> lstPraticheDealerNotFound = new List<SFATargaMancante__c>();

        List<Account> lstDealer = [SELECT Id, RecordType.Name, OCS_External_Id__c, ParentId, Branch__r.OCS_External_Id__c 
                                    FROM Account 
                                    WHERE RecordType.Name = 'Dealer'];

        List<Group> lstCoda = [SELECT Id, DeveloperName FROM Group];

        Case case1 = [SELECT Id, Status, CaseNumber FROM Case WHERE Id = :caseId][0];

        Savepoint sp = Database.setSavepoint();

        try {

            List<ContentVersion> conVer = [SELECT VersionData FROM ContentVersion WHERE Id = :fileId AND IsLatest = true];

            String fileContents = conVer[0].VersionData.toString();

            //Blob blob1 = EncodingUtil.base64Decode(base64);

            List<String> csvRows = fileContents.split('\r');
            List<String> lstDealerId = new List<String>();
            for (Account acc : lstDealer) {
                String dealerId = acc.OCS_External_Id__c;
                lstDealerId.add(dealerId);
            }

            List<String> csvFieldNames = csvRows[0].split(';');
            for (Integer i = 0; i < csvFieldNames.size(); i++) {
                fieldNumberMap.put(csvFieldNames[i], i);
                lstFieldNames.add(csvFieldNames[i].trim());
            }

            for (Integer i = 1; i < csvRows.size(); i++) {
                string[] csvRecordData = csvRows[i].split(';');

                SFATargaMancante__c pratica = new SFATargaMancante__c();
                pratica.DataTermineLavoro__c = dataScadenza;
                pratica.DataTermineScadenziario__c = Date.newInstance(3999, 12, 31);
                pratica.IdElaborazione__c = caseId;
                for (String fieldName: csvFieldNames) {
                    fieldNumber = fieldNumberMap.get(fieldName);
                    fieldValue = csvRecordData[fieldNumber];
                    if (fieldName == 'ragione_sociale')
                        pratica.RagioneSociale__c = fieldValue;
                    else if (fieldName == 'pratica') {
                        pratica.NumeroPratica__c = fieldValue;
                        pratica.Name = fieldValue;
                    }
                    else if (fieldName == 'prodotto')
                        pratica.Prodotto__c = fieldValue;
                    else if (fieldName == 'data_liquidazione')
                        pratica.DataLiquidazione__c = Date.parse(fieldValue);
                    else if (fieldName == 'targa')
                        pratica.Targa__c = fieldValue;
                    else if (fieldName == 'telaio')
                        pratica.Telaio__c = fieldValue;
                    else if (fieldName == 'c_anacli')
                        pratica.CodiceCliente__c = fieldValue;
                    else if (fieldName == 'DESCRIZIONE_BENE')
                        pratica.DescrizioneBene__c = fieldValue;
                    else if (fieldName == 'convenzionato')
                        pratica.DealerId__c = fieldValue;
                    else if (fieldName == 'nome_cliente')
                        pratica.DescrizioneCliente__c = fieldValue;
                    else if (fieldName == 'c_serv1')
                        pratica.Cserv1__c = fieldValue;
                    else if (fieldName == 'c_serv2')
                        pratica.Cserv2__c = fieldValue;
                    else if (fieldName == 'c_dipend')
                        pratica.Dipendenza__c = fieldValue;
                }
                                
                if (csvRecordData[fieldNumberMap.get('prodotto')] != '1U' && csvRecordData[fieldNumberMap.get('prodotto')] != '1N' &&
                    csvRecordData[fieldNumberMap.get('prodotto')] != '2U' && csvRecordData[fieldNumberMap.get('prodotto')] != '2N')
                {
                    lstPraticheProdKO.add(pratica);
                    continue;
                }

                if (!lstDealerId.contains('D' + csvRecordData[fieldNumberMap.get('convenzionato')])) {
                    lstPraticheDealerNotFound.add(pratica);
                    continue;
                }

                lstPraticheOK.add(pratica);
            }

            for (SFATargaMancante__c pratica: lstPraticheOK) {
                //string[] csvRecordData = csvRows[i].split(';');
                Case childCase = new Case();
                /*for (String fieldName: csvFieldNames) {
                    fieldNumber = fieldNumberMap.get(fieldName);
                    fieldValue = csvRecordData[fieldNumber];
                    //childCase.put(fieldName.trim(), fieldValue.trim());
                    childCase.ParentId = caseId;
                    childCase.Note__c = 'Nota della riga ' + i;
                    System.debug('*** Riga ' + i + ' | Campo :: ' + fieldName);
                }*/
                childCase.ActivityType__c = 'SFA_TARMAN';
                childCase.Subject = 'Targhe Mancanti';
                childCase.ParentId = caseId;
                childCase.NumeroPratica__c = pratica.NumeroPratica__c;
                for (Account dealer : lstDealer) {
                    if (dealer.OCS_External_Id__c == 'D' + pratica.DealerId__c) {
                        childCase.AccountId = dealer.Id;
                        for (Group coda : lstCoda) {
                            if (coda.DeveloperName == dealer.Branch__r.OCS_External_Id__c) {
                                childCase.OwnerId = coda.Id;
                                break;
                            }
                        }
                        break;
                    }
                }
                lstChildCasesOK.add(childCase);                
            }

            for (SFATargaMancante__c pratica: lstPraticheDealerNotFound) {
                Case childCase = new Case();
                childCase.ActivityType__c = 'SFA_TARMAN';
                childCase.Status = 'DealerIDNotFound';
                childCase.Subject = 'Targhe Mancanti';
                childCase.ParentId = caseId;
                childCase.NumeroPratica__c = pratica.NumeroPratica__c;
                lstChildCasesDealerNotFound.add(childCase);                
            }

            for (SFATargaMancante__c pratica: lstPraticheProdKO) {
                Case childCase = new Case();
                childCase.ActivityType__c = 'SFA_TARMAN';
                childCase.Status = 'ProdottoKO';
                childCase.Subject = 'Targhe Mancanti';
                childCase.ParentId = caseId;
                childCase.NumeroPratica__c = pratica.NumeroPratica__c;
                lstChildCasesProdKO.add(childCase);                
            }

            insert lstChildCasesOK;
            insert lstChildCasesDealerNotFound;
            insert lstChildCasesProdKO;

            for (Case c : lstChildCasesOK) {
                for (SFATargaMancante__c pratica: lstPraticheOK) {
                    if (pratica.NumeroPratica__c == c.NumeroPratica__c) {
                        pratica.IdAttivita__c = c.Id;
                        break;
                    }
                }
            }

            for (Case c : lstChildCasesDealerNotFound) {
                for (SFATargaMancante__c pratica: lstPraticheDealerNotFound) {
                    if (pratica.NumeroPratica__c == c.NumeroPratica__c) {
                        pratica.IdAttivita__c = c.Id;
                        break;
                    }
                }
            }

            for (Case c : lstChildCasesProdKO) {
                for (SFATargaMancante__c pratica: lstPraticheProdKO) {
                    if (pratica.NumeroPratica__c == c.NumeroPratica__c) {
                        pratica.IdAttivita__c = c.Id;
                        break;
                    }
                }
            }

            insert lstPraticheOK;
            insert lstPraticheDealerNotFound;
            insert lstPraticheProdKO;

            List<SFAConfigurazioneDecadeTargheMancanti__c> lstSFAcdtm = new List<SFAConfigurazioneDecadeTargheMancanti__c>();

            SFAConfigurazioneDecadeTargheMancanti__c SFAcdtm1 = new SFAConfigurazioneDecadeTargheMancanti__c(IdElaborazione__c = caseId, InizioDecade__c = 1, FineDecade__c = 10, DataLimite__c = Date.newInstance(3999, 12, 31));
            lstSFAcdtm.add(SFAcdtm1);

            SFAConfigurazioneDecadeTargheMancanti__c SFAcdtm2 = new SFAConfigurazioneDecadeTargheMancanti__c(IdElaborazione__c = caseId, InizioDecade__c = 11, FineDecade__c = 20, DataLimite__c = Date.newInstance(3999, 12, 31));
            lstSFAcdtm.add(SFAcdtm2);

            SFAConfigurazioneDecadeTargheMancanti__c SFAcdtm3 = new SFAConfigurazioneDecadeTargheMancanti__c(IdElaborazione__c = caseId, InizioDecade__c = 21, FineDecade__c = 31, DataLimite__c = Date.newInstance(3999, 12, 31));
            lstSFAcdtm.add(SFAcdtm3);

            insert lstSFAcdtm;

            case1.Status = 'Closed';
        }
        catch (Exception ex) {
            String n = case1.CaseNumber;
            String exceptionMessage = ex.getMessage();
            String caseDescription;
            //System.debug('*** Case Number :: ' + n);
            //System.debug('*** caseDescription :: ' + caseDescription);
            if (exceptionMessage != null && exceptionMessage.contains('DUPLICATE_VALUE'))
                caseDescription = 'Errore durante il caricamento del caso ' + n +': numero pratica duplicato.\n Rivolgersi all\'amministratore del sistema comunicando il numero del caso.\n';
            else
                caseDescription = 'Errore durante il caricamento del caso ' + n +'.\n Rivolgersi all\'amministratore del sistema comunicando il numero del caso.\n';
            caseDescription += exceptionMessage;
            
            //System.debug('*** exceptionMessage :: ' + exceptionMessage);
                
            case1.Description = caseDescription;
            
            Database.rollback(sp);
		}
        finally {
            update case1;
        }
    }
    
}