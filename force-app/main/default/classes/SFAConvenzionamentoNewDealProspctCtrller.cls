public class SFAConvenzionamentoNewDealProspctCtrller {

	private static final String PRESENTE = 'Presente';
	private static final String RICHIESTO = 'Richiesto';
	private static final String QUICK_REPORT = 'Quick Report';
	private static final String GLOBAL_EXPERT = 'Global Expert';
    private static final String ATTIVO = 'A';
    private static final String ISCRITTO = 'I';
    private static final String CHIUSO = 'C';
    private static final String STEP_INIZIALE = 'NewDealerProspect_StepIniziale';
    private static final String REPORT_PRESENTE = 'NewDealerProspect_ReportPresente';
    private static final String QUICK_REPORT_RICHIESTO = 'NewDealerProspect_QuickReportRichiesto';
    private static final String GLOBAL_EXPERT_RICHIESTO = 'NewDealerProspect_GlobalExpertRichiesto';
    private static final String RICHIEDI_QUICK_REPORT = 'NewDealerProspect_RichiediQuickReport';
	private static final String RICHIEDI_GLOBAL_EXPERT = 'NewDealerProspect_RichiediGlobalExpert';
    private static final String IN_ISCRIZIONE = 'NewDealerProspect_DealerInIscrizione';
    private static final String ESITA_CASE = 'NewDealerProspect_EsitaCase';
    private static final String RUOLO_SOC = 'SOC';
    private static final String READ_TIMED_OUT = 'Read timed out';


    @AuraEnabled
    public static DatiDealerProspect getDealerProspect(String caseId) {

		Case c = 
			[SELECT Id, AccountId, StepAttivitaConvenzionamento__c
			FROM Case 
			WHERE Id = :caseId AND Categoria_Riferimento__r.External_Id__c = :XCS_CategoriaUtil.SFA_CONVENZIONAMENTO_NEW_DEALER_PROSPECT][0];
        
        DatiDealerProspect datiDealerProspect = new DatiDealerProspect();

        System.debug('*** AccountId :: ' + c.AccountId);
        System.debug('*** caseId :: ' + caseId);

        if (RICHIEDI_QUICK_REPORT.equals(c.StepAttivitaConvenzionamento__c) || 
            RICHIEDI_GLOBAL_EXPERT.equals(c.StepAttivitaConvenzionamento__c)) {
            datiDealerProspect.dealer = new Account();
            Account dealerProspect = 
                [SELECT Id, Name, ShippingStreet, ShippingPostalCode, ShippingState, ShippingCity, Partita_IVA__c, Codice_Fiscale__c, Forma_Giuridica__c, IscrizioneCCIAA__c, NumeroREA__c, Desc_Ateco__c, DescriptionOfBusinessStatus__c, DescriptionOfLegalEntityType__c
                FROM Account
                WHERE Id = :c.AccountId][0];

            datiDealerProspect.dealer = dealerProspect;
        }

        else if (GLOBAL_EXPERT_RICHIESTO.equals(c.StepAttivitaConvenzionamento__c)) {

            List<ReportCerved__c> lstReport = 
			[SELECT Id, Status__c, Tipo__c, FileId__c
			FROM ReportCerved__c 
			WHERE DealerId__c = :c.AccountId AND Tipo__c = :GLOBAL_EXPERT AND IsReportValido__c = true];

            if (lstReport.size() > 0) {

                ReportCerved__c report = lstReport.get(0);

                if (PRESENTE.equals(report.Status__c)) {
                    // controllo il formato del file e, se è PDF, lo mostro
                    // Mi faccio tornare l'url al file
                    datiDealerProspect.reportUrl = [SELECT Id, DistributionPublicUrl FROM ContentDistribution WHERE ContentVersionId = :report.FileId__c][0].DistributionPublicUrl;
                    
                    c.StepAttivitaConvenzionamento__c = REPORT_PRESENTE;
                    update c;
                }
            }

        }

        else if (REPORT_PRESENTE.equals(c.StepAttivitaConvenzionamento__c)) {

            List<ReportCerved__c> lstReport = 
			[SELECT Id, Status__c, Tipo__c, FileId__c
			FROM ReportCerved__c 
			WHERE DealerId__c = :c.AccountId AND IsReportValido__c = true];

            if (lstReport.size() > 0) {

                ReportCerved__c report = lstReport.get(0);

                if (PRESENTE.equals(report.Status__c)) {
                    // controllo il formato del file e, se è PDF, lo mostro
                    // Mi faccio tornare l'url al file
                    datiDealerProspect.reportUrl = [SELECT Id, DistributionPublicUrl FROM ContentDistribution WHERE ContentVersionId = :report.FileId__c][0].DistributionPublicUrl;
                }
            }

        }

        datiDealerProspect.attivita = c;

        System.debug('*** datiDealerProspect :: ' + JSON.serialize(datiDealerProspect));

		return datiDealerProspect;
		
	}

	@AuraEnabled
    public static CheckPresenzaReportResult checkPresenzaReport(String caseId, String dealerProspectId, String codiceFiscale, String partitaIva) {

        System.debug('*** dealerProspectId :: ' + dealerProspectId);
        
        CheckPresenzaReportResult cprr = new CheckPresenzaReportResult();

		List<ReportCerved__c> lstReport = 
			[SELECT Id, Status__c, Tipo__c, FileId__c
			FROM ReportCerved__c 
			WHERE DealerId__c = :dealerProspectId AND IsReportValido__c = true];

		// C'è un record associato al Dealer
		if (lstReport.size() > 0) {

			ReportCerved__c report = lstReport.get(0);

			if (PRESENTE.equals(report.Status__c)) {
				// controllo il formato del file e, se è PDF, lo mostro
				// Mi faccio tornare l'url al file
				cprr.step = REPORT_PRESENTE;
                cprr.reportUrl = [SELECT Id, DistributionPublicUrl FROM ContentDistribution WHERE ContentVersionId = :report.FileId__c][0].DistributionPublicUrl;
			}

			else if (RICHIESTO.equals(report.Status__c)) {

				if (QUICK_REPORT.equals(report.Tipo__c)) {
                    cprr.step = QUICK_REPORT_RICHIESTO;
				}

				else if (GLOBAL_EXPERT.equals(report.Tipo__c)) {
                    cprr.step = GLOBAL_EXPERT_RICHIESTO;
				}

			}

		}
		//Non c'è un record associato al Dealer, bisogna fare una nuova richiesta
		else {   
			cprr.step = callEreimu(codiceFiscale, partitaIva, dealerProspectId);
		}

        if (cprr.step != null) {
            if (IN_ISCRIZIONE.equals(cprr.step))
                SFAConvenzionamento.updateStepLavorazione(caseId, STEP_INIZIALE);
            else
                SFAConvenzionamento.updateStepLavorazione(caseId, cprr.step);
        }

        System.debug('*** cprr :: ' + JSON.serialize(cprr));
        
        return cprr;
		
	}
    

    @AuraEnabled
    public static CheckPresenzaReportResult richiediQuickReport(String caseId, String dealerProspectId, String partitaIva) {

        System.debug('*** richiediQuickReport()');

        CheckPresenzaReportResult cprr = new CheckPresenzaReportResult();

       try {

            Case c = [SELECT Id, StepAttivitaConvenzionamento__c FROM Case WHERE Id = :caseId][0];
            ReportCerved__c reportCerved;
            List<ReportCerved__c> lstReportCerved = 
                [SELECT Id, IdDifferita__c
                FROM ReportCerved__c 
                WHERE DealerId__c = :dealerProspectId AND IsReportValido__c = true ORDER BY CreatedDate DESC];
            if (lstReportCerved.size() > 0)
                reportCerved = lstReportCerved.get(0);
            String step = c.StepAttivitaConvenzionamento__c;
            String idDifferita;
            String requestType = 'DOCUMENT';
            if (QUICK_REPORT_RICHIESTO.equals(step)) {
                System.debug('*** ' + QUICK_REPORT_RICHIESTO);                
                if (reportCerved != null) {
                    idDifferita = reportCerved.IdDifferita__c;
                    requestType = 'DEFERRED';
                }
            }
            CervedRichDocExecuteResponse response = new CervedRichDocExecuteResponse();
            system.debug('PIVA :');
        	response = CervedRichDocExecuteInvoker.richiediQuickReport(partitaIva, idDifferita, requestType);
            if (response != null) {
                if (response.statusCode == -900) {
                    cprr.errorCode = response.statusCode;
                    cprr.errorMessage = response.status;
                }
                else if (response.cervedRichDocExecuteResponse != null) {

                    System.debug('*** richiediQuickReport - response :: ' + JSON.serialize(response));

                    if (response.cervedRichDocExecuteResponse.richDocOutput != null) {
                        ReportCerved__c nuovoQuickReport = new ReportCerved__c();
                        if (reportCerved != null) {
                            nuovoQuickReport.Id = reportCerved.Id;
                        }
                        nuovoQuickReport.Tipo__c = QUICK_REPORT;
                        nuovoQuickReport.DealerId__c = dealerProspectId;
                        nuovoQuickReport.IdAttivita__c = caseId;
                        System.debug('*** response.cervedRichDocExecuteResponse.richDocOutput != null');

                        if (response.cervedRichDocExecuteResponse.richDocOutput.deferredId == null) {

                            if (response.cervedRichDocExecuteResponse.richDocOutput.resultXML != null) {
                                System.debug('*** response.cervedRichDocExecuteResponse.richDocOutput.resultXML != null');
                                // estrae i collegati e li aggiunge a DB
                                System.debug('*** response: dealerProspectId, caseId: '+ dealerProspectId+'___'+ caseId );
                                 System.debug('*** response: resultXML: '+ response.cervedRichDocExecuteResponse.richDocOutput.resultXML);
                                uploadXML(response.cervedRichDocExecuteResponse.richDocOutput.resultXML, partitaIva, 'q');
                                DatiReportCervedDaQuickReport datiDaQRP = salvaDatiDaQuickReport(response.cervedRichDocExecuteResponse.richDocOutput.resultXML, dealerProspectId, caseId);
                                nuovoQuickReport.Rating__c = datiDaQRP.rating;
                                nuovoQuickReport.Protesti__c = datiDaQRP.protesti;
                                nuovoQuickReport.Pregiudizievoli__c = datiDaQRP.pregiudizievoli; 
                            }

                            if (response.cervedRichDocExecuteResponse.richDocOutput.resultPDF != null) {
                                System.debug('*** response.cervedRichDocExecuteResponse.richDocOutput.resultPDF != null');
                                // carica pdf, mette id del file in ReportCerved e torna url
                                nuovoQuickReport.Status__c = PRESENTE;
                                upsert nuovoQuickReport;
                                String fileId = uploadPDF(response.cervedRichDocExecuteResponse.richDocOutput.resultPDF, partitaIva, 'q', nuovoQuickReport.Id);
                                nuovoQuickReport.FileId__c = fileId;
                                c.StepAttivitaConvenzionamento__c = REPORT_PRESENTE;
                                cprr.step = REPORT_PRESENTE;
                                cprr.reportUrl = [SELECT Id, DistributionPublicUrl FROM ContentDistribution WHERE ContentVersionId = :fileId][0].DistributionPublicUrl;
                            }
                        }
                        else {
                            nuovoQuickReport.Status__c = RICHIESTO;
                            nuovoQuickReport.IdDifferita__c = response.cervedRichDocExecuteResponse.richDocOutput.deferredId;
                            c.StepAttivitaConvenzionamento__c = QUICK_REPORT_RICHIESTO;
                            cprr.step = QUICK_REPORT_RICHIESTO;
                        }

                        upsert nuovoQuickReport;
                        update c;

                    }
                    else if (response.cervedRichDocExecuteResponse.error != null) {
                        System.debug('*** response.cervedRichDocExecuteResponse.richDocOutput == null');

                        cprr.errorCode = response.cervedRichDocExecuteResponse.error.errorCode;
                        cprr.errorMessage = response.cervedRichDocExecuteResponse.error.errorMessage; 
                        
                    }

                }
            }
       }
        catch (Exception e) {
            System.debug('*** errorMessage :: '+e.getMessage() );
            cprr.errorCode = -10;
            cprr.errorMessage = 'Si è verificato un errore durante il recupero del Quick Report.';
        }

        return cprr;

    }

    @AuraEnabled
    public static String richiediGlobalExpert(String caseId, String dealerProspectId, String ragioneSociale, String partitaIva, String codiceFiscale, String indirizzo, String cap, String provincia, String citta) {

        Case c = [SELECT Id, StepAttivitaConvenzionamento__c FROM Case WHERE Id = :caseId][0];

        CervedOneStepBuyResponse response = new CervedOneStepBuyResponse();

        /* Passare anche le note a richiediGlobalExpert */
        response = CervedOneStepBuyInvoker.richiediGlobalExpert(ragioneSociale, partitaIva, codiceFiscale, indirizzo, cap, provincia, citta);

        System.debug('*** CervedOneStepBuy RESPONSE :: ' + JSON.serialize(response));

        if (response != null && response.cervedOneStepBuyResponse != null) {
            ReportCerved__c nuovoGlobalExpert = new ReportCerved__c();
            nuovoGlobalExpert.IdAttivita__c = caseId;
            nuovoGlobalExpert.Tipo__c = GLOBAL_EXPERT;
            nuovoGlobalExpert.Status__c = RICHIESTO;
            nuovoGlobalExpert.IdDifferita__c = String.valueOf(response.cervedOneStepBuyResponse.requestCode);
            nuovoGlobalExpert.DealerId__c = dealerProspectId;
            insert nuovoGlobalExpert;
            c.StepAttivitaConvenzionamento__c = GLOBAL_EXPERT_RICHIESTO;
            update c;
            return GLOBAL_EXPERT_RICHIESTO;
        }

        return null;
    }

    @AuraEnabled
    public static QuickReportResponseAndXPath getQuickReportResponseFromFixedXML(String base64strXML){

        /**
            Scopo di questo metodo è prendere in ingresso l'XML di Cerved, toglierne i nodi che, oltre a non essere di interesse 
            per il processo, si sono dimostrati problematici per il parsing XML di Salesforce. Infine tornare l'oggetto parserizzato al chiamante.
            lstXpathDaEliminare contiene la lista dei nodi che, prima ancora della conversione da XML a JSON, vengono eliminati dall'XML.
            E' stato aggiunto anche ShareholdersList perché, nonostante sia d'interesse per il processo, in un caso, era presente come tag
            autochiudente e quindi questo faceva rompere il parsing. Per precauzione, è stato aggiunto anche un controllo su IndividualList.

            Inoltre, se si dovesse verificare un'eccezione System.JSONException: Illegal value for primitive durante la conversione XML->JSON, bisogna accertarsi che non ci sono altri tag con lo stesso nome e nello stesso XPATH che abbiano struttura diversa. Si può risolvere andando a limitare al minimo indispensabile (quelli strettamente sufficienti per mappare i nodi di interesse) le classi e i rispettivi attributi che modellano il QRP.
         */

        Blob blobXML = EncodingUtil.base64decode(base64strXML);
        HttpRequest tmp = new HttpRequest();
        tmp.setBodyAsBlob(blobXML);
        String strXML = tmp.getBody();

        Dom.Document doc = new DOM.Document();
        doc.load(strXML);
        XPath xpath = new XPath(doc);
		System.debug('*** strXMLPre Eliminzazione Path :: ' + strXML);
        QuickReportResponseAndXPath qrpandxp = new QuickReportResponseAndXPath();

        List<String> lstXpathDaEliminare = new List<String>();
        lstXpathDaEliminare.add('/s2xResponse/s2xData/Budgets');
        if((xpath.findFirst('/s2xResponse/s2xData/Shareholders/ShareholdersList')).getChildElements().size() == 0)
            lstXpathDaEliminare.add('/s2xResponse/s2xData/Shareholders/ShareholdersList');
        if((xpath.findFirst('/s2xResponse/s2xData/Representatives/IndividualList')).getChildElements().size() == 0)
            lstXpathDaEliminare.add('/s2xResponse/s2xData/Representatives/IndividualList');

        for (String xpathDaEliminare : lstXpathDaEliminare) {
            Dom.XmlNode child = xpath.findFirst(xpathDaEliminare);
            Boolean remove = child.getParent().removeChild(child);
        }

        strXML = doc.toXmlString();

        System.debug('*** strXML :: ' + strXML);
       
        Set<String> deSerializeNodesAsArray = new Set<String>();
        deSerializeNodesAsArray.add('Individual');
        deSerializeNodesAsArray.add('Shareholder');
        deSerializeNodesAsArray.add('Ateco2007');

        XMLSerializer xmls = new XMLSerializer();
        QuickReportResponse quickReportResponse = new QuickReportResponse();

        System.debug('*** prima di xmls.deserialize()');
        quickReportResponse = (QuickReportResponse) xmls.deserialize(strXML, QuickReportResponse.class, deSerializeNodesAsArray);
        System.debug('*** dopo xmls.deserialize()'+ quickReportResponse);
        //System.debug('*** quickReportResponse :: ' + JSON.serialize(quickReportResponse));

        qrpandxp.quickReportResponse = quickReportResponse;
        qrpandxp.xpath = xpath;

        return qrpandxp;
    }
    
    @AuraEnabled
    public static DatiReportCervedDaQuickReport salvaDatiDaQuickReport(String base64strXML, String dealerProspectId, String caseId){

        System.debug('*** salvaDatiDaQuickReport()');

        //System.debug('*** base64strXML :: ' + base64strXML);

        QuickReportResponseAndXPath qrpandxp = getQuickReportResponseFromFixedXML(base64strXML);
        
        QuickReportResponse quickReportResponse = qrpandxp.quickReportResponse;
        Xpath xpath = qrpandxp.xpath;
        
        List<AccountContactRelation> lstAccountContactRelation = new List<AccountContactRelation>();

        Map<String, Contact> mapCFtoContact = new Map<String, Contact>();
        Map<String, String> mapCFToRole = new Map<String, String>();

        //List<Contact> lstContactIL = new List<Contact>();
        //List<Contact> lstContactSL = new List<Contact>();

        Account account = 
            [SELECT Id, Name, Sae__c, Rae__c, ShippingStreet, ShippingPostalCode, ShippingState, ShippingCity, Partita_IVA__c, Codice_Fiscale__c, DataInizioAttivita__c, Desc_Ateco__c, Tipo_Intermediario__c, Type_Anag__c 
            FROM Account
            WHERE Id = :dealerProspectId][0];

        Case c = 
            [SELECT Id, Fido__c, DataAnalisi__c, Pagamenti__c 
            FROM Case 
            WHERE Id = :caseId][0];

        DatiReportCervedDaQuickReport datiReport = new DatiReportCervedDaQuickReport();
        
        //System.debug('*** quickReportResponse :: ' + JSON.serialize(quickReportResponse));
        //System.debug('*** quickReportResponse.s2xResponse :: ' + JSON.serialize(quickReportResponse.s2xResponse));
        //System.debug('*** quickReportResponse.s2xResponse.s2xData :: ' + JSON.serialize(quickReportResponse.s2xResponse.s2xData));
        //System.debug('*** quickReportResponse.s2xResponse.s2xData.EconomicalActivity :: ' + JSON.serialize(quickReportResponse.s2xResponse.s2xData.EconomicalActivity));
        //System.debug('*** quickReportResponse.s2xResponse.s2xData.EconomicalActivity.SAECode2007 :: ' + JSON.serialize(quickReportResponse.s2xResponse.s2xData.EconomicalActivity.SAECode2007));
        account.Sae__c = quickReportResponse.s2xResponse.s2xData.EconomicalActivity.SAECode2007;
        account.Rae__c = quickReportResponse.s2xResponse.s2xData.EconomicalActivity.RAECode2007;
        
        String formaGiuridicaFromCerved = quickReportResponse.s2xResponse.s2xData.IdentifyingData.CervedProspectAdditionalInformations.RegisteredHeadOfficeIdentification.CompanyTitle;
        if (formaGiuridicaFromCerved != null)
            account.Forma_Giuridica__c = getFormaGiuridica(dealerProspectId, formaGiuridicaFromCerved);
        
        if ('DIN'.equals(account.Forma_Giuridica__c))
            account.Type_Anag__c = 'F';
        else
            account.Type_Anag__c = 'G';
                    
        account.Name = quickReportResponse.s2xResponse.s2xData.IdentifyingData.CervedProspectAdditionalInformations.RegisteredHeadOfficeIdentification.CompanyName;

        //System.debug('*** quickReportResponse.s2xResponse.s2xData.IdentifyingData.CervedProspectAdditionalInformations.RegisteredHeadOfficeLocation.Address.ToponymCode :: ' + JSON.serialize(quickReportResponse.s2xResponse.s2xData.IdentifyingData.CervedProspectAdditionalInformations.RegisteredHeadOfficeLocation.Address.ToponymCode));
        account.ShippingStreet = quickReportResponse.s2xResponse.s2xData.IdentifyingData.CervedProspectAdditionalInformations.RegisteredHeadOfficeLocation.Address.ToponymCode + ' ' + quickReportResponse.s2xResponse.s2xData.IdentifyingData.CervedProspectAdditionalInformations.RegisteredHeadOfficeLocation.Address.StreetName + ' ' +
        quickReportResponse.s2xResponse.s2xData.IdentifyingData.CervedProspectAdditionalInformations.RegisteredHeadOfficeLocation.Address.StreetNo;

        //System.debug('*** quickReportResponse.s2xResponse.s2xData.IdentifyingData.CervedProspectAdditionalInformations.RegisteredHeadOfficeLocation.Address.Postcode :: ' + JSON.serialize(quickReportResponse.s2xResponse.s2xData.IdentifyingData.CervedProspectAdditionalInformations.RegisteredHeadOfficeLocation.Address.Postcode));
        account.ShippingPostalCode = quickReportResponse.s2xResponse.s2xData.IdentifyingData.CervedProspectAdditionalInformations.RegisteredHeadOfficeLocation.Address.Postcode;

        //System.debug('*** quickReportResponse.s2xResponse.s2xData.IdentifyingData.CervedProspectAdditionalInformations.RegisteredHeadOfficeLocation.Address.ProvinceCode :: ' + JSON.serialize(quickReportResponse.s2xResponse.s2xData.IdentifyingData.CervedProspectAdditionalInformations.RegisteredHeadOfficeLocation.Address.ProvinceCode));
        account.ShippingState = quickReportResponse.s2xResponse.s2xData.IdentifyingData.CervedProspectAdditionalInformations.RegisteredHeadOfficeLocation.Address.ProvinceCode;

        //System.debug('*** quickReportResponse.s2xResponse.s2xData.IdentifyingData.CervedProspectAdditionalInformations.RegisteredHeadOfficeLocation.Address.DescriptionCityIfNotISTAT :: ' + JSON.serialize(quickReportResponse.s2xResponse.s2xData.IdentifyingData.CervedProspectAdditionalInformations.RegisteredHeadOfficeLocation.Address.DescriptionCityIfNotISTAT));
        account.ShippingCity = quickReportResponse.s2xResponse.s2xData.IdentifyingData.CervedProspectAdditionalInformations.RegisteredHeadOfficeLocation.Address.DescriptionCityIfNotISTAT;

        //System.debug('*** quickReportResponse.s2xResponse.s2xData.IdentifyingData.CervedProspectAdditionalInformations.RegisteredHeadOfficeIdentification.VATRegistrationNo :: ' + JSON.serialize(quickReportResponse.s2xResponse.s2xData.IdentifyingData.CervedProspectAdditionalInformations.RegisteredHeadOfficeIdentification.VATRegistrationNo));
        account.Partita_IVA__c = (String.isNotBlank(quickReportResponse.s2xResponse.s2xData.IdentifyingData.CervedProspectAdditionalInformations.RegisteredHeadOfficeIdentification.VATRegistrationNo) ? quickReportResponse.s2xResponse.s2xData.IdentifyingData.CervedProspectAdditionalInformations.RegisteredHeadOfficeIdentification.VATRegistrationNo : quickReportResponse.s2xResponse.s2xData.IdentifyingData.VATNo);

        //System.debug('*** riga 313');
        account.Codice_Fiscale__c = quickReportResponse.s2xResponse.s2xData.IdentifyingData.CervedProspectAdditionalInformations.RegisteredHeadOfficeIdentification.TaxCode;

        //System.debug('*** riga 316');
        account.dataInizioAttivita__c = DateUtils.parseFromYYYYMMDDString(quickReportResponse.s2xResponse.s2xData.CharacteristicData.ActivityStartDate);

        //System.debug('*** riga 319');
        account.Desc_Ateco__c = quickReportResponse.s2xResponse.s2xData.EconomicalActivity.CompanyActivity.Ateco2007List.Ateco2007[0].Code + ' - ' + xpath.findFirst('/s2xResponse/s2xData/EconomicalActivity/CompanyActivity/Ateco2007List/Ateco2007/Code').getAttributeValue('Description', null);
        
        //System.debug('*** riga 322');
        account.COD_Ateco__c = quickReportResponse.s2xResponse.s2xData.EconomicalActivity.CompanyActivity.Ateco2007List.Ateco2007[0].Code;

        update account;

        //System.debug('*** riga 327');
        c.Fido__c = quickReportResponse.s2xResponse.s2xData.AssessmentSummary.RecommendedMaximumCreditLimit;
        c.DataAnalisi__c = DateUtils.parseFromYYYYMMDDString(quickReportResponse.s2xResponse.s2xData.InfocomData.DateOfUpdate);
        
        if((xpath.findFirst('/s2xResponse/s2xData/Payline')).getChildElements().size() == 0)
            c.Pagamenti__c = xpath.getText('/s2xResponse/s2xData/Payline');
        else
            c.Pagamenti__c = xpath.getText('/s2xResponse/s2xData/Payline/Score');

        update c;

        if (xpath.findFirst('/s2xResponse/s2xData/AssessmentSummary/CervedGroupRating') != null) {
            Integer cervedRating = Integer.valueOf(xpath.findFirst('/s2xResponse/s2xData/AssessmentSummary/CervedGroupRating').getAttributeValue('Code', null));

            if (cervedRating >= 1 && cervedRating <= 10) {
                datiReport.rating = 'CGS_' + String.valueOf(cervedRating);
            }
        }
        else if (xpath.findFirst('/s2xResponse/s2xData/AssessmentSummary/Rating') != null) {
            String rating = xpath.findFirst('/s2xResponse/s2xData/AssessmentSummary/Rating').getAttributeValue('Code', null);
            datiReport.rating = rating;
        }

        String protesti = quickReportResponse.s2xResponse.s2xData.ProtestsAndPrejudicialEvents.Protests.FlagAlarm;
        String pregiudizievoli = quickReportResponse.s2xResponse.s2xData.ProtestsAndPrejudicialEvents.PrejudicialEvents.FlagAlarm;

        datiReport.protesti = ('1'.equals(protesti)) ? 'S' : 'N'; 
        datiReport.pregiudizievoli = ('1'.equals(pregiudizievoli)) ? 'S' : 'N'; 

        Contact contactDiRiferimento = SFAConvenzionamento.getContactDiRiferimentoDealer(dealerProspectId);
        contactDiRiferimento.Email = quickReportResponse.s2xResponse.s2xData.IdentifyingData.Email;

        //Map<String, QuickReportResponse.IndividualList> mapCFtoIL = new Map<String, QuickReportResponse.IndividualList>();
        
        Integer i = 0;

        if (quickReportResponse.s2xResponse.s2xData.Representatives.IndividualList != null) {

            for (QuickReportResponse.Individual il : quickReportResponse.s2xResponse.s2xData.Representatives.IndividualList.Individual) {
                Contact contact = new Contact();
                contact.AccountId = dealerProspectId;
                
                contact.LastName = il.PersonalData.LastName;
                contact.FirstName = il.PersonalData.FirstName;
                contact.Codice_Fiscale__c = il.PersonalData.TaxCode;
                contact.Birthdate = DateUtils.parseFromYYYYMMDDString(il.PersonalData.Birth.BirthDate);
                contact.Provincia_Nascita__c = il.PersonalData.Birth.BirthplaceProvinceCode;
                contact.Luogo_Nascita__c = il.PersonalData.Birth.City;
                contact.Sesso__c = il.PersonalData.Sex;
                
                if ( 'DIN'.equals(account.Forma_Giuridica__c) && i == 0 ) {
                    contactDiRiferimento.LastName = il.PersonalData.LastName;
                    contactDiRiferimento.FirstName = il.PersonalData.FirstName;
                    contactDiRiferimento.Codice_Fiscale__c = il.PersonalData.TaxCode;
                    contactDiRiferimento.Birthdate = DateUtils.parseFromYYYYMMDDString(il.PersonalData.Birth.BirthDate);
                    contactDiRiferimento.Provincia_Nascita__c = il.PersonalData.Birth.BirthplaceProvinceCode;
                    contactDiRiferimento.Luogo_Nascita__c = il.PersonalData.Birth.City;
                    contactDiRiferimento.Sesso__c = il.PersonalData.Sex;
                }
                
                contact.Tipo_Anagrafica__c = 'F';
                //contact.Email = il.PersonalData.FirstName;
                //System.debug('*** il.PersonalData :: ' + JSON.serialize(il.PersonalData));
                //System.debug('*** il.PersonalData.Domicile :: ' + JSON.serialize(il.PersonalData.Domicile));

                if (il.PersonalData.TaxDomicile != null) {

                    if (String.isNotBlank(il.PersonalData.TaxDomicile.ForeignCountryCode)) {
                        contact.MailingStreet = il.PersonalData.TaxDomicile.StreetName + ' ' + il.PersonalData.TaxDomicile.StreetNo;
                        contact.MailingCountry = il.PersonalData.TaxDomicile.ForeignCountryCode;
                    }
                    else {
                        contact.MailingStreet = il.PersonalData.TaxDomicile.ToponymCode + ' ' + il.PersonalData.TaxDomicile.StreetName + ' ' + il.PersonalData.TaxDomicile.StreetNo;
                    }

                    contact.MailingPostalCode = il.PersonalData.TaxDomicile.Postcode;
                    contact.MailingState = il.PersonalData.TaxDomicile.ProvinceCode;
                    contact.MailingCity = il.PersonalData.TaxDomicile.City;
                }

                else if (il.PersonalData.Domicile != null) {

                    if (String.isNotBlank(il.PersonalData.Domicile.ForeignCountryCode)) {
                        contact.MailingStreet = il.PersonalData.Domicile.StreetName + ' ' + il.PersonalData.Domicile.StreetNo;
                        contact.MailingCountry = il.PersonalData.Domicile.ForeignCountryCode;
                    }
                    else {
                        contact.MailingStreet = il.PersonalData.Domicile.ToponymCode + ' ' + il.PersonalData.Domicile.StreetName + ' ' + il.PersonalData.Domicile.StreetNo;
                    }

                    contact.MailingPostalCode = il.PersonalData.Domicile.Postcode;
                    contact.MailingState = il.PersonalData.Domicile.ProvinceCode;
                    contact.MailingCity = il.PersonalData.Domicile.City;
                }

                //lstContactIL.add(contact);

                System.debug('*** riga 393');
                //mapCFtoIL.put(il.PersonalData.TaxCode, il);
                mapCFtoContact.put(contact.Codice_Fiscale__c, contact);

                System.debug('*** riga 397');
                String role = xpath.getText('/s2xResponse/s2xData/Representatives/IndividualList/Individual/OfficesAndAuthority/OfficesInGroup/OfficeHeldList/Office/Code');
                System.debug('*** riga 399');
                mapCFToRole.put(contact.Codice_Fiscale__c, role);
                i++;
            }

        }
        
        update contactDiRiferimento; 

 		system.debug('*** Valuto shareholders');
        
        if (quickReportResponse.s2xResponse.s2xData.Shareholders.ShareholdersList != null) {
            for (QuickReportResponse.Shareholder sl : quickReportResponse.s2xResponse.s2xData.Shareholders.ShareholdersList.Shareholder ){
                Contact contact = new Contact();
                contact.AccountId = dealerProspectId;
                contact.LastName = sl.LastName != null ? sl.LastName : sl.Name;
                contact.FirstName = sl.FirstName;
                contact.Codice_Fiscale__c = sl.TaxCode;
                
                if(sl.LastName != null && sl.FirstName != null) {
                    
                    system.debug('***  Elaborazione Persona fisica');
                    string VerifIData = xpath.getText('/s2xResponse/s2xData/Shareholders/ShareholdersList/Shareholder/OtherIdentificationData/IdentificationData');
                    if(VerifIData != null && VerifIData != ''){
                        contact.Birthdate = DateUtils.parseFromYYYYMMDDString(xpath.getText('/s2xResponse/s2xData/Shareholders/ShareholdersList/Shareholder/OtherIdentificationData/IdentificationData/BirthDate'));
                        contact.Luogo_Nascita__c = xpath.getText('/s2xResponse/s2xData/Shareholders/ShareholdersList/Shareholder/OtherIdentificationData/IdentificationData/BirthPlace');
                        contact.Provincia_Nascita__c = xpath.findFirst('/s2xResponse/s2xData/Shareholders/ShareholdersList/Shareholder/OtherIdentificationData/IdentificationData/BirthProvince').getAttributeValue('Code', null);
                        contact.Tipo_Anagrafica__c = 'F';
                        contact.Sesso__c = getSessoFromCodiceFiscale(sl.TaxCode);
                    }
                   
                    
                }
                
                else {
                    system.debug('***  Elaborazione Persona giuridica');
                    contact.DataInizioAttivita__c = DateUtils.parseFromYYYYMMDDString(xpath.getText('/s2xResponse/s2xData/Shareholders/ShareholdersList/Shareholder/Company/ActivityStatus/Date'));
                    contact.RagioneSociale__c = sl.Name;
                    contact.Partita_IVA__c = sl.TaxCode;
                    contact.Tipo_Anagrafica__c = 'G';
                }

                //lstContactSL.add(contact);

                //mapCFtoSL.put(sl.Shareholder.TaxCode, sl);

                mapCFtoContact.put(contact.Codice_Fiscale__c, contact);

                mapCFToRole.put(contact.Codice_Fiscale__c, RUOLO_SOC);
            }
        }
        
		/* listaCollegati è la lista definitiva di collegati presi dal QRP */
        List<Contact> listaCollegati = mapCFtoContact.values();
        
        insert listaCollegati;
        
        List<Contact> listaCollegatiConId = new List<Contact>();

        System.debug('*** listaCollegati :: ' + JSON.serialize(listaCollegati));
                
        List<Contact> listaCollegatiDaServizioEsistenti = new List<Contact>();
        
        Set<String> setCodiceFiscale = new Set<String>();
        setCodiceFiscale = mapCFtoContact.keySet();
        List<String> lstCodiceFiscale = new List<String>();
        lstCodiceFiscale.addAll(setCodiceFiscale);

        System.debug('*** lstCodiceFiscale :: ' + JSON.serialize(lstCodiceFiscale));
        
        List<String> lstCFCollegatiDaAggiornare = new List<String>();
        
        Map<String, String> mapCFToId = new Map<String, String>();
        
        listaCollegatiDaServizioEsistenti = [SELECT Id, Codice_Fiscale__c FROM Contact WHERE Codice_Fiscale__c IN :lstCodiceFiscale];
        System.debug('*** listaCollegatiDaServizioEsistenti :: ' + JSON.serialize(listaCollegatiDaServizioEsistenti));
        
        for (Contact collegato : listaCollegatiDaServizioEsistenti) {
            lstCFCollegatiDaAggiornare.add(collegato.Codice_Fiscale__c);
            mapCFToId.put(collegato.Codice_Fiscale__c, collegato.Id);
        }

        System.debug('*** lstCFCollegatiDaAggiornare :: ' + JSON.serialize(lstCFCollegatiDaAggiornare));
        System.debug('*** mapCFToId :: ' + JSON.serialize(mapCFToId));
        
        for (Contact collegato : listaCollegati) {
            if (lstCFCollegatiDaAggiornare.contains(collegato.Codice_Fiscale__c))
                collegato.Id = mapCFToId.get(collegato.Codice_Fiscale__c);
            listaCollegatiConId.add(collegato);
        }
        
        System.debug('*** listaCollegatiConId :: ' + JSON.serialize(listaCollegatiConId));
        upsert listaCollegatiConId;

        List<AccountContactRelation> listACR = 
            [SELECT Id, AccountId, ContactId, Contact.Codice_Fiscale__c, Roles 
            FROM AccountContactRelation
            WHERE AccountId = :dealerProspectId AND IsDeleted = false AND isCollegatoEliminato__c = false];

        for (AccountContactRelation acr : listACR) {
            acr.Roles = mapCFToRole.get(acr.Contact.Codice_Fiscale__c);
        }

        update listACR;

        return datiReport;
    }

    @AuraEnabled
	public static String getSessoFromCodiceFiscale(String codiceFiscale) {
        String sesso;
        if (codiceFiscale != null && codiceFiscale.length() == 16) {
            String strGiorno = codiceFiscale.substring(9, 11);
            Integer giorno = Integer.valueOf(strGiorno);
            System.debug('*** giorno :: ' + giorno);
            if (giorno >= 1 && giorno <= 31)
                return 'M';
            else if (giorno >= 40 && giorno <= 71)
                return 'F';
            else
                return null;
        }
        else {
            return null;
        }
    }
    
    @AuraEnabled
	public static String getFormaGiuridica(String dealerProspectId, String formaGiuridicaFromCerved) {
        List<dealer_conv_nat_giur__mdt> lstFormaGiudirica = 
            [SELECT nat_giur_desc__c, nat_giur_hv__c, nat_giur_ocs__c
             FROM dealer_conv_nat_giur__mdt
             WHERE nat_giur_hv__c = :formaGiuridicaFromCerved];
        if (lstFormaGiudirica.size() > 0) {
            String formaGiuridica = lstFormaGiudirica[0].nat_giur_ocs__c;
            return formaGiuridica;
        }
        else {
            return null;
        }
    }

    @AuraEnabled
    public static String uploadPDF(String base64encodedPDF, String partitaIva, String titleLastLetter, String reportCervedId) {
        Blob pdfBlob = EncodingUtil.base64Decode(base64encodedPDF);
        
        Date dateToday = Date.today();
        String sMonth = String.valueof(dateToday.month());
        String sDay = String.valueof(dateToday.day());
        if(sMonth.length()==1){
        sMonth = '0' + sMonth;
        }
        if(sDay.length()==1){
        sDay = '0' + sDay;
        }
        String sToday = String.valueof(dateToday.year()) + sMonth + sDay;

        String fileName = partitaIva+'_'+sToday+'_'+ titleLastLetter;

        String fileId = CompassUtils.createFile(pdfBlob, fileName, 'pdf', reportCervedId);

        return fileId;

    }

    @AuraEnabled
    public static void uploadXML(String base64encodedXML, String partitaIva, String titleLastLetter) {
        //Blob xmlBlob = EncodingUtil.base64Decode(base64encodedXML);
        
        Date dateToday = Date.today();
        String sMonth = String.valueof(dateToday.month());
        String sDay = String.valueof(dateToday.day());
        if(sMonth.length()==1){
            sMonth = '0' + sMonth;
        }
        if(sDay.length()==1){
            sDay = '0' + sDay;
        }
        String sToday = String.valueof(dateToday.year()) + sMonth + sDay;

        String fileName = partitaIva+'_'+sToday+'_'+ titleLastLetter;

        Id fileId = CompassUtils.fileNewInstance(base64encodedXML, fileName, 'xml');

        ContentDistribution cd = new ContentDistribution();
        cd.name = fileName;
        cd.ContentVersionId = fileId;
        cd.PreferencesAllowOriginalDownload = true;
        cd.PreferencesAllowPDFDownload = false;
        cd.PreferencesAllowViewInBrowser = true;
        cd.PreferencesNotifyOnVisit = false;
        cd.PreferencesNotifyRndtnComplete = false;
        
        insert cd;

        System.debug('*** XML filename :: ' + filename + '.xml');

        List<ContentDistribution> lstXmlUrl = [SELECT Id, DistributionPublicUrl FROM ContentDistribution WHERE ContentVersionId = :fileId];
        
        if (lstXmlUrl != null && lstXmlUrl.size() > 0) {
            String xmlUrl = lstXmlUrl[0].DistributionPublicUrl;
            System.debug('*** XML url :: ' + xmlUrl);
        }

    }
    
    @AuraEnabled
    public static CervedEreimuResponse.GeneralCompanyDetails getElementoSignificativo(List<CervedEreimuResponse.GeneralCompanyDetails> lstGeneralCompanyDetails) {

        if (lstGeneralCompanyDetails != null) {
            if (lstGeneralCompanyDetails.size() == 1) {
            	return lstGeneralCompanyDetails.get(0);
            }
            else {
                // logica che ordina la lista e decide quale elemento tornare
                lstGeneralCompanyDetails.sort();
                for (CervedEreimuResponse.GeneralCompanyDetails cer : lstGeneralCompanyDetails) {
                    if (ATTIVO.equals(cer.BusinessStatus) || ISCRITTO.equals(cer.BusinessStatus)) {
                        return cer;
                    }
                }
                return lstGeneralCompanyDetails.get(0);
        	}
        }
        return null;
    }
    
    @AuraEnabled
    public static String callEreimu(String codiceFiscale, String partitaIva, String dealerProspectId) {

        System.debug('*** callEreimu() - prima del controllo - codiceFiscale :: ' + codiceFiscale);
        System.debug('*** callEreimu() - prima del controllo - partitaIva :: ' + partitaIva);

        if (String.isBlank(codiceFiscale) && partitaIva != null) {
            codiceFiscale = partitaIva;
        }

        System.debug('*** callEreimu() - dopo il controllo - codiceFiscale :: ' + codiceFiscale);
        System.debug('*** callEreimu() - dopo il controllo - partitaIva :: ' + partitaIva);
        
        CervedEreimuResponse cervedEreimuResponse = new CervedEreimuResponse();

        cervedEreimuResponse = CervedEreimuInvoker.getDatiEreimu(codiceFiscale);

        System.debug('*** cervedEreimuResponse :: ' + JSON.serialize(cervedEreimuResponse));
        
        Integer numberOfRecordsExtractedFromDatabank = cervedEreimuResponse.s2xResponse.s2xData.ResultsReport.NumberOfRecordsExtractedFromDatabank;

        System.debug('*** numberOfRecordsExtractedFromDatabank :: ' + numberOfRecordsExtractedFromDatabank);
    
        if (numberOfRecordsExtractedFromDatabank == 0) {
            System.debug('*** riga 118');
            if (partitaIva != null) {
                if (!partitaIva.equals(codiceFiscale)) {
                    System.debug('*** riga 120');
                    cervedEreimuResponse = CervedEreimuInvoker.getDatiEreimu(partitaIva);
                    numberOfRecordsExtractedFromDatabank = cervedEreimuResponse.s2xResponse.s2xData.ResultsReport.NumberOfRecordsExtractedFromDatabank;
                    if (numberOfRecordsExtractedFromDatabank == 0) {
                        System.debug('*** riga 124');
                        return callEreima(codiceFiscale, partitaIva); 
                    } 
                    
                    else if (numberOfRecordsExtractedFromDatabank >= 1) {
                        System.debug('*** riga 129');

                        /*
                        Logica che mi estrae l'array, me lo ordina e mi prende l'elmento piu' recente
                        */
                
                        CervedEreimuResponse.GeneralCompanyDetails generalCompanyDetails = getElementoSignificativo(cervedEreimuResponse.s2xResponse.s2xData.GeneralCompanyDetails);
                
                        if (generalCompanyDetails != null) {
                            System.debug('*** riga 137');
                            salvaDatiDaEreimu(dealerProspectId, generalCompanyDetails);

                            if (CHIUSO.equals(generalCompanyDetails.BusinessStatus)) {
                                System.debug('*** riga 139');
                                return RICHIEDI_GLOBAL_EXPERT; // Innesco richiesta GE
                            } 
                            
                            else if (ATTIVO.equals(generalCompanyDetails.BusinessStatus) || ISCRITTO.equals(generalCompanyDetails.BusinessStatus)) {
                                System.debug('*** riga 144');
                                if ('PF'.equals(generalCompanyDetails.LegalEntityType)) {
                                    System.debug('*** riga 146');
                                    return RICHIEDI_GLOBAL_EXPERT; // Innesco richiesta GE
                                } 
                                
                                else {
                                    System.debug('*** riga 151');
                                    return RICHIEDI_QUICK_REPORT; // Innesco richiesta QRP
                                }
                            }

                        }
                
                    }
                }
                else {
                    return callEreima(codiceFiscale, partitaIva); 
                }
            }
    
        } 
        
        else if (numberOfRecordsExtractedFromDatabank >= 1) {
            System.debug('*** riga 163');
            
            /*
            Logica che mi estrae l'array, me lo ordina e mi prende l'elmento piu' recente
            */
    
            CervedEreimuResponse.GeneralCompanyDetails generalCompanyDetails = getElementoSignificativo(cervedEreimuResponse.s2xResponse.s2xData.GeneralCompanyDetails);
    
            if (generalCompanyDetails != null) {
                System.debug('*** riga 171');
                salvaDatiDaEreimu(dealerProspectId, generalCompanyDetails);
                if (CHIUSO.equals(generalCompanyDetails.BusinessStatus)) {
                    System.debug('*** riga 173');
                    return RICHIEDI_GLOBAL_EXPERT; // Innesco richiesta GE
                } 
                
                else if (ATTIVO.equals(generalCompanyDetails.BusinessStatus) || ISCRITTO.equals(generalCompanyDetails.BusinessStatus)) {
                    System.debug('*** riga 178');
                    if ('PF'.equals(generalCompanyDetails.LegalEntityType)) {
                        System.debug('*** riga 180');
                        return RICHIEDI_GLOBAL_EXPERT; // Innesco richiesta GE
                    } 
                    
                    else {
                        System.debug('*** riga 185');
                        return RICHIEDI_QUICK_REPORT; // Innesco richiesta QRP
                    }
                }

            }
    
        }
        
        System.debug('*** riga 192');
        return null;
    
    }
    
    @AuraEnabled
    public static String callEreima(String codiceFiscale, String partitaIva) {

        System.debug('*** callEreima() - prima del controllo - codiceFiscale :: ' + codiceFiscale);
        System.debug('*** callEreima() - prima del controllo - partitaIva :: ' + partitaIva);

        if (String.isBlank(codiceFiscale) && partitaIva != null) {
            codiceFiscale = partitaIva;
        }

        System.debug('*** callEreima() - dopo il controllo - codiceFiscale :: ' + codiceFiscale);
        System.debug('*** callEreima() - dopo il controllo - partitaIva :: ' + partitaIva);
        
        CervedEreimaResponse cervedEreimaResponse = new CervedEreimaResponse();
        cervedEreimaResponse = CervedEreimaInvoker.getDatiEreima(codiceFiscale);

        System.debug('*** cervedEreimaResponse :: ' + JSON.serialize(cervedEreimaResponse));

        String businessStatus;
        
        Integer numberOfRecordsExtractedFromDatabase = cervedEreimaResponse.s2xResponse.s2xData.ResearchIndicator.ReportResults.NumberRecordsExtractedFromDatabase;
    
        if (numberOfRecordsExtractedFromDatabase == 0) {
            
            if (partitaIva != null && !partitaIva.equals(codiceFiscale)) {
                cervedEreimaResponse = CervedEreimaInvoker.getDatiEreima(partitaIva);
                numberOfRecordsExtractedFromDatabase = cervedEreimaResponse.s2xResponse.s2xData.ResearchIndicator.ReportResults.NumberRecordsExtractedFromDatabase;
                if (numberOfRecordsExtractedFromDatabase == 0) {
                    return RICHIEDI_GLOBAL_EXPERT;
                }
                else if (numberOfRecordsExtractedFromDatabase == 1) {
            
                    businessStatus = cervedEreimaResponse.s2xResponse.s2xData.ResearchIndicator.CompanyIdentification[0].BusinessStatus;
                    if (!CHIUSO.equals(businessStatus)) {
                        return IN_ISCRIZIONE;
                    }
                    else {
                        return RICHIEDI_GLOBAL_EXPERT;
                    }
                    
                }
                
            }
            
            else {
                return RICHIEDI_GLOBAL_EXPERT;
            }
            
        }
        
        else if (numberOfRecordsExtractedFromDatabase == 1) {
            
            businessStatus = cervedEreimaResponse.s2xResponse.s2xData.ResearchIndicator.CompanyIdentification[0].BusinessStatus;
            if (!CHIUSO.equals(businessStatus)) {
                return IN_ISCRIZIONE;
            }
            else {
                return RICHIEDI_GLOBAL_EXPERT;
            }
            
        }
        
        return null;
    
    }

    @AuraEnabled
    public static void salvaDatiDaEreimu(String dealerProspectId, CervedEreimuResponse.GeneralCompanyDetails gcd) {
        System.debug('*** salvaDatiDaEreimu()');
        Account dealer = [SELECT Id, Name, DescriptionOfBusinessStatus__c, DescriptionOfLegalEntityType__c,IscrizioneCCIAA__c, NumeroREA__c, Desc_Ateco__c, ShippingStreet, ShippingState, ShippingCity FROM Account WHERE Id = :dealerProspectId][0];
        dealer.Name = gcd.CompanyName;
        dealer.NumeroREA__c = gcd.REA;
        dealer.IscrizioneCCIAA__c = gcd.REARegistrationDate;
        dealer.DescriptionOfBusinessStatus__c = gcd.DescriptionOfBusinessStatus;
        dealer.DescriptionOfLegalEntityType__c = gcd.DescriptionOfLegalEntityType;
        if (gcd.OtherCompanyInformation != null) {
                dealer.Desc_Ateco__c = gcd.OtherCompanyInformation.MainActivityCodeDescription;
                dealer.ShippingStreet = gcd.OtherCompanyInformation.ToponymCode + ' ' + gcd.OtherCompanyInformation.Address + ' ' + gcd.OtherCompanyInformation.StreetNumber;
        }
        dealer.ShippingState = gcd.HQProvinceAcronym;
        dealer.ShippingCity = gcd.FullNameOfMunicipality;
        System.debug('*** numero REA :: ' + dealer.NumeroREA__c);
        System.debug('*** iscrizione CCIAA :: ' + dealer.IscrizioneCCIAA__c);
        System.debug('*** DescriptionOfBusinessStatus__c :: ' + dealer.DescriptionOfBusinessStatus__c);
        System.debug('*** DescriptionOfLegalEntityType__c :: ' + dealer.DescriptionOfLegalEntityType__c);
        //dealer.Forma_Giuridica__c = gcd.DescriptionOfLegalEntityType;
        //creare il campo business status sull'account
        /************************************** */
        update dealer;

    }

    @AuraEnabled
    public static void salvaProvinciaECitta(String dealerId, String provincia, String citta) { 
        System.debug('*** dealerId :: ' + dealerId); 
        System.debug('*** provincia :: ' + provincia);
        System.debug('*** citta :: ' + citta);      
		Account dealer =[SELECT Id, ShippingCity, ShippingState FROM Account  WHERE Id = :dealerId][0];
        dealer.ShippingState=provincia; 
        dealer.ShippingCity=citta; 
		update dealer;
    }

    @AuraEnabled
    public static String setRichiediGlobalExpert(String caseId) {
        Case c = new Case();
        c.Id = caseId;
        c.StepAttivitaConvenzionamento__c = SFAConvenzionamento.NewDealerProspect_RichiediGlobalExpert;
        update c;

        return c.StepAttivitaConvenzionamento__c;
    }

    @AuraEnabled
    public static String vaiAEsitaCase(String caseId) {
        SFAConvenzionamento.updateStepLavorazione(caseId, ESITA_CASE);

        return ESITA_CASE;
    }

    @AuraEnabled
    public static String esitaCase(String caseId, XCS_Disposition__c disposition) {

        Case c = [SELECT Id, Status, Subject, StepAttivitaConvenzionamento__c FROM Case WHERE Id = :caseId][0];

        if (XCS_DispositionUtils.PROSPECT_RESPINTO.equals(disposition.External_Id__c) || XCS_DispositionUtils.PROSPECT_NON_INTERESSATO.equals(disposition.External_Id__c)) {
            c.Status = CaseUtils.CHIUSO;
        }

        else if (XCS_DispositionUtils.NECESSARIA_ULTERIORE_VISITA.equals(disposition.External_Id__c)) {
			c.Status = CaseUtils.APERTO;
        }

        else if (XCS_DispositionUtils.IN_CONVENZIONAMENTO.equals(disposition.External_Id__c)) {
            c.ActivityType__c = CaseUtils.SFA_NEW_DEALER_ACQUISITION;
            c.Categoria_Riferimento__r = XCS_CategoriaUtil.getCategoryForExternalId(XCS_CategoriaUtil.SFA_CONVENZIONAMENTO_NEW_DEALER_ACQUISITION);
            c.Status = CaseUtils.APERTO;
		    c.Subject = CaseUtils.SFA_SUBJECT_NEW_DEALER_ACQUISITION;
            c.StepAttivitaConvenzionamento__c = SFAConvenzionamento.NDA_CompletaInfoEControlli1;
        }

        c = XCS_DispositionUtils.aggiungiDispositionCase(c, disposition.External_Id__c);
        
        System.debug('*** case :: ' + JSON.serialize(c));

        update c;

        Case cUpdated = [SELECT Id, Status, Subject, StepAttivitaConvenzionamento__c, Categoria_Riferimento__r.External_Id__c FROM Case WHERE Id = :caseId][0];

        return cUpdated.Categoria_Riferimento__r.External_Id__c;
    }

    public class DatiDealerProspect {
        @AuraEnabled public Case attivita {get;set;} 
		@AuraEnabled public Account dealer {get;set;}
        @AuraEnabled public String reportUrl {get;set;}
    }
    
    public class CheckPresenzaReportResult {
		@AuraEnabled public String step {get;set;} 
		@AuraEnabled public String reportUrl {get;set;}
        @AuraEnabled public Integer errorCode {get;set;}
        @AuraEnabled public String errorMessage {get;set;}
	}

    public class DatiReportCervedDaQuickReport {
        @AuraEnabled public String rating {get;set;}
		@AuraEnabled public String protesti {get;set;} 
		@AuraEnabled public String pregiudizievoli {get;set;}
	}

    public class QuickReportResponseAndXPath {
        @AuraEnabled public QuickReportResponse QuickReportResponse {get;set;}
		@AuraEnabled public XPath xpath {get;set;} 
	}

}