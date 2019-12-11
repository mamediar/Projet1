//----------------------------------------------------------------------
//-- - Class Name   : CRMBatInserisciSinistro
//-- - Autor        : Daniele Segoloni(Lynx)
//-- - Date         : 1/7/2019
//-- - Description  : Batch che effettua l'inserimento dei Sinistri Assicurativi
//-- - Version      : 1.0
//----------------------------------------------------------------------


global class CRMBatInserisciSinistro implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful ,Schedulable {

    global String query;
    global String emailBodyEsitoOK;
    global String emailBodyEsitoKO;
    global String sDataSinistro;
    global List<Case> caseToUpdate = new List<Case>();
    global List<Case> caseWithError = new List<Case>();
    global List<Sinistro_Assicurativo__c> sinistriToUpdate = new List<Sinistro_Assicurativo__c>();
    global List<Sinistro_Assicurativo__c> sinistriWithError = new List<Sinistro_Assicurativo__c>();
    global final String NEXT_SCHEDULE = '0 0 0 3 9 ? 2022'; //TODO: settare adeguatamente


    
    global Database.QueryLocator start(Database.BatchableContext bc){
        system.debug('----------------------------------------------------------------------');
        system.debug('-- - Class Name  : CRMBatInserisciSinistro                      ');

        emailBodyEsitoOK = XCS_TemplateUtils.getBody('CRMBatInserisciSinistro_EsitoOK');
        emailBodyEsitoKO = XCS_TemplateUtils.getBody('CRMBatInserisciSinistro_EsitoKO');

        System.debug('emailBodyEsitoOK start: '+emailBodyEsitoOK);
        System.debug('emailBodyEsitoKO start: '+emailBodyEsitoKO);

        query = 'SELECT Id, caseId__r.Status,Anomalia__c,Data_Elaborazione__c,Data_Erogazione__c,';
        query += 'Data_Primo_Utilizzo__c,Luogo_Elaborazione__c, Polizza__c,Rata__c,Saldo_Residuo__c,';
        query += 'caseId__r.Tipo_Pratica__c,Piano_Ammortamento__c,Compagnia__c,caseId__r.NumeroPratica__c,Data_Sinistro__c,Tipologia_Sinistro__c,';
        query += 'caseId__r.Account.LastName, caseId__r.Account.firstname, Flag_err__c, caseId__c';
        query += ' FROM Sinistro_Assicurativo__c';
//        query += ' WHERE Stato_Sinistro__c = \'3\''; CAMPO Stato_Sinistro__c CAMBIATO IN PICKLIST 
        query += ' WHERE caseid__r.Status = \'Sospeso\''; 
        query += ' AND (Coda__c = \'84\' OR Coda__c = \'107\')';
        query += ' AND RecordType.Name = \'Standard\'';
      // begin modifica 29 08 2019
        // aggiunta filtro per skippare account null per errore reference object null 29 08 2019
        query += ' and CaseId__r.AccountId != null';	
        // end modifica 29 08 2019
        System.debug('query: '+query);
        return Database.getQueryLocator(query);
        
    }
    
    global void execute(Database.BatchableContext bc, List<Sinistro_Assicurativo__c> sinistriList){
        
        for (Sinistro_Assicurativo__c s : sinistriList) {
            
            system.debug('---------------------------------------------------------------------------------------');
            system.debug('-- Class Name: CRMBatInserisciSinistro - Method Name: Execute'); 
//            system.debug('-- SINISTRO -- ' + s);
            system.debug('-- compagnia = '+ s.Compagnia__c);
            system.debug('-- numPratica = ' + s.caseId__r.NumeroPratica__c);
            system.debug('-- tipoPratica = ' + s.caseId__r.Tipo_Pratica__c);
            system.debug('-- tipoSinistro = ' + s.Tipologia_Sinistro__c);
            System.debug('-- Cognome Nome -- : '+s.CaseId__r.Account.lastName + ' - '+s.caseId__r.Account.firstName);

            //set della request
            OCSAperturaSinistroRequest req = new OCSAperturaSinistroRequest();

            req.datiAperturaSinistroRequest.compagnia = s.Compagnia__c;
            req.datiAperturaSinistroRequest.numPratica = s.caseId__r.NumeroPratica__c;
            req.datiAperturaSinistroRequest.tipoPratica = s.caseId__r.Tipo_Pratica__c;
            sDataSinistro = creaDataPerReq(s.Data_Sinistro__c) ;
            system.debug('-- sDataSinistro = ' + sDataSinistro);
            req.datiAperturaSinistroRequest.dataSinistro = sDataSinistro;
            req.datiAperturaSinistroRequest.tipoSinistro = s.Tipologia_Sinistro__c;
            // begin modifica 29 08 2019
            // cognome e nome da Account lookup
           // req.datiAperturaSinistroRequest.cognome = s.Cognome__c;
           // req.datiAperturaSinistroRequest.nome = s.Nome__c;
            system.debug('---------------------------------------------------------------------------------------');
            system.debug('-- Class Name: CRMBatInserisciSinistro - Method Name: Execute'); 
            System.debug('-- Cognome Nome -- : '+s.CaseId__r.Account.lastName + ' - '+s.caseId__r.Account.firstName);
            req.datiAperturaSinistroRequest.cognome = s.CaseId__r.Account.lastName;
            req.datiAperturaSinistroRequest.nome = s.CaseId__r.Account.firstName;
			// end modifica 29 08 2019
            system.debug('---------------------------------------------------------------------------------------');
            system.debug('-- Class Name: CRMBatInserisciSinistro - Method Name: Execute'); 
            System.debug('-- Flag_err__c: '+s.Flag_err__c);

            OCSAperturaSinistroResponse apSinResp = new OCSAperturaSinistroResponse();


            if (s.Flag_err__c == false) {

                req.datiAperturaSinistroRequest.flagReadOnly = 'N';

//                if (Test.isRunningTest()) {
//                    apSinResp = buildMockResp();
//                }else{
//                    apSinResp = OCSAperturaSinistroInvoker.callApeSinistro(req); 
		            apSinResp= OCSAperturaSinistroInvoker.callApeSinistro(s.Compagnia__c, s.caseId__r.NumeroPratica__c, s.caseId__r.Tipo_Pratica__c, sDataSinistro, s.Tipologia_Sinistro__c, s.CaseId__r.Account.lastName, s.CaseId__r.Account.firstName,'N');
//                }
//                System.debug('callout response: '+apSinResp);

                s = flagErrFalseExecution(s, apSinResp);
            }else{
                //Flag_err=true
                req.datiAperturaSinistroRequest.flagReadOnly = 'S';

//                if (Test.isRunningTest()) {
//                    apSinResp = buildMockResp();
//                }else{
//                    apSinResp = OCSAperturaSinistroInvoker.callApeSinistro(req); 
		            apSinResp= OCSAperturaSinistroInvoker.callApeSinistro(s.Compagnia__c, s.caseId__r.NumeroPratica__c, s.caseId__r.Tipo_Pratica__c, sDataSinistro, s.Tipologia_Sinistro__c, s.CaseId__r.Account.lastName, s.CaseId__r.Account.firstName,'S');
//                }
                System.debug('callout response: '+apSinResp);

                if (apSinResp.resultCode == 0) {
                    system.debug('---------------------------------------------------------------------------------------');
                    system.debug('-- Class Name: CRMBatInserisciSinistro - Method Name: Execute'); 
                    system.debug('Resultcode = 0');
                    system.debug('apSinResp.datiAperturaSinistroResponse.scarti.size()' + apSinResp.datiAperturaSinistroResponse.scarti.size());
                    if (apSinResp.datiAperturaSinistroResponse.scarti.size()>0){
                        if(String.isBlank(apSinResp.datiAperturaSinistroResponse.scarti[0].desScarto) ||
                            apSinResp.datiAperturaSinistroResponse.scarti[0].desScarto == 'La pratica non presenta assicurazioni ALICO'){
                            //s = setSinistroFields(s, apSinResp, '1'); //lo faccio nel metodo flagErrFalseExecution
                            s.Flag_err__c = false;
                            s = flagErrFalseExecution(s, apSinResp);
                        }
                    }
                }    
                else{
                    emailBodyEsitoKO += '\nSu CRM non ho trovato la singola riga del sinistro pending, numPratica='+apSinResp.datiAperturaSinistroResponse.numPratica;
                    sinistriWithError.add(s);
                }
                
            }
            
        }
        update caseToUpdate;
        update caseWithError;
        update sinistriToUpdate;
        update sinistriWithError;
    }

    global void finish(Database.BatchableContext bc){
        System.debug('sinistriToUpdate.size(): '+sinistriToUpdate.size());
        System.debug('sinistriWithError.size(): '+sinistriWithError.size());
        System.debug('sinistriToUpdate: '+sinistriToUpdate);
        System.debug('sinistriWithError: '+sinistriWithError);

        XCS_CompassParameters__c c = XCS_CompassParameters__c.getValues('AdminInserisciSinistro');
        System.debug('c' + c.value__c);
        
        
        String subject;
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {c.value__c}; 
        String[] ccAddresses = new String[] {c.value__c};
        mail.setToAddresses(toAddresses);
        mail.setCcAddresses(ccAddresses);
        mail.setReplyTo(c.value__c);
        mail.setSenderDisplayName('Salesforce Support');

        //se ci sono stati errori, invio email di errore
        if (sinistriWithError.size() > 0) {

            subject = 'Presenza errori nel batch Inserisci Sinistro del : '+System.today().day() + '/' + System.today().month() + '/' + System.today().year() + ' ore : '+System.now().time();
            mail.setPlainTextBody(emailBodyEsitoKO);
        }else{
            //se non ci sono stati errori, invio email esito OK
            subject = 'batch Inserisci Sinistro del : '+System.today().day() + '/' + System.today().month() + '/' + System.today().year() + ' ore : '+System.now().time()+' effettuato senza errori';
            mail.setPlainTextBody(emailBodyEsitoOK);
        }
        mail.setSubject(subject);

        System.debug('mail: '+mail);
        System.debug('subject: '+subject);
        System.debug('emailBodyEsitoKO: '+emailBodyEsitoKO);
        System.debug('emailBodyEsitoOK: '+emailBodyEsitoOK);

        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); //TODO: decommentare per abilitare invio email
        String hour;
        String min;
        String ss;
            
        CRMBatInserisciSinistro bInserisci = new CRMBatInserisciSinistro();
        
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
//		String jobID = System.schedule('AperturaSinistro', nextTime, bInserisci);
        
//        if(Datetime.now().minute()<=45){
//            hour = String.valueOf(Datetime.now().hour());
//            min = String.valueOf(Datetime.now().minute()+15);
//            ss = String.valueOf(Datetime.now().second());
//        }else{
//            if(Datetime.now().hour()<23){
//                hour = String.valueOf(Datetime.now().hour()+1);
//            }else{
//                hour = String.valueOf(Datetime.now().hour()-23);
//            }
//            min = String.valueOf(Datetime.now().minute()-45);
//            ss = String.valueOf(Datetime.now().second());
//        }

        

    }

    global void execute(SchedulableContext sc) {
        CRMBatInserisciSinistro b = new CRMBatInserisciSinistro(); 
        Database.executebatch(b);
    }

    //set dei campi della response all'interno del sinistro
    public Sinistro_Assicurativo__c setSinistroFields(Sinistro_Assicurativo__c s, OCSAperturaSinistroResponse resp, String statoSinistro) {
        System.debug('---------------------------------------------------------------------------------------');
        System.debug('-- Class Name: CRMBatInserisciSinistro - Method Name: setSinistroFields');

//        s.Stato_Sinistro__c = statoSinistro;
        if(resp.datiAperturaSinistroResponse.scarti.size()>0){
            s.Anomalia__c = resp.datiAperturaSinistroResponse.scarti[0].desScarto;
        }else{
            s.Anomalia__c = '';
        }
        if(resp.datiAperturaSinistroResponse.dataElab==null){
            s.Data_Elaborazione__c = Date.valueOf(resp.datiAperturaSinistroResponse.dataElab);
        }else{
            s.Data_Elaborazione__c = Date.valueOf(creaDataPerInsert(resp.datiAperturaSinistroResponse.dataElab));
        }

        if(resp.datiAperturaSinistroResponse.dataErogazione==null){
            s.Data_Erogazione__c = Date.valueOf(resp.datiAperturaSinistroResponse.dataErogazione);
        }else{
            s.Data_Erogazione__c = Date.valueOf(creaDataPerInsert(resp.datiAperturaSinistroResponse.dataErogazione));
        }

        if(resp.datiAperturaSinistroResponse.dataPrimoUtilizzo==null){
            s.Data_Primo_Utilizzo__c = null;
//            s.Data_Primo_Utilizzo__c = Date.valueOf(resp.datiAperturaSinistroResponse.dataPrimoUtilizzo);
        }else{
            s.Data_Primo_Utilizzo__c = Date.valueOf(creaDataPerInsert(resp.datiAperturaSinistroResponse.dataPrimoUtilizzo));
        }

        s.Luogo_Elaborazione__c = resp.datiAperturaSinistroResponse.luogoElab;
//        s.Nominativo_Assicurato__c = resp.datiAperturaSinistroResponse.nominativoAssicurato;
        s.Polizza__c = resp.datiAperturaSinistroResponse.polizza;
        s.Rata__c = resp.datiAperturaSinistroResponse.rata;
        s.Saldo_Residuo__c = resp.datiAperturaSinistroResponse.saldoResiduo;
//        s.caseId__r.Tipo_Pratica__c = resp.datiAperturaSinistroResponse.tipoPratica; DA INSERIRE SU CASE
        s.Piano_Ammortamento__c = resp.datiAperturaSinistroResponse.pianoAmmortamento;
        return s;
    }

    //esecuzione in caso di Flag_err=false
    public Sinistro_Assicurativo__c flagErrFalseExecution(Sinistro_Assicurativo__c s, OCSAperturaSinistroResponse apSinResp) {
        system.debug('---------------------------------------------------------------------------------------');
        system.debug('-- Class Name: CRMBatInserisciSinistro - Method Name: flagErrFalseExecution');
        
        Case uCase = [SELECT Id, Status, Tipo_Pratica__c FROM Case WHERE id =:s.CaseId__c];

		System.debug('apSinResp' + apSinResp);
        System.debug('s.Tipologia_Sinistro__c -> ' + s.Tipologia_Sinistro__c);
        System.debug('s.CaseId__r.NumeroPratica__c -> ' + s.CaseId__r.NumeroPratica__c);
        System.debug('s.Data_Sinistro__c -> ' + s.Data_Sinistro__c);
        
        if (s.Tipologia_Sinistro__c == apSinResp.datiAperturaSinistroResponse.tipoSinistro &&
            s.CaseId__r.NumeroPratica__c	== apSinResp.datiAperturaSinistroResponse.numPratica &&
//            s.Data_Sinistro__c == Date.valueOf(apSinResp.datiAperturaSinistroResponse.dataSinistro)) {
            s.Data_Sinistro__c == Date.valueOf(creaDataPerInsert(apSinResp.datiAperturaSinistroResponse.dataSinistro))) {
            System.debug('---------------------------------------------------------------------------------------');
            System.debug('-- Class Name: CRMBatInserisciSinistro - Method Name: flagErrFalseExecution');
            System.debug('-- sinistro ed OCS coincidono');
//            System.debug('-- apSinResp.datiAperturaSinistroResponse.scarti.size()'+ apSinResp.datiAperturaSinistroResponse.scarti.size());
//            System.debug('-- Response.scarti[0].desScarto-> '+ apSinResp.datiAperturaSinistroResponse.scarti[0].desScarto);
            
            if(apSinResp.datiAperturaSinistroResponse.scarti.size()>0){
                if (String.isBlank(apSinResp.datiAperturaSinistroResponse.scarti[0].desScarto) ||
                    apSinResp.datiAperturaSinistroResponse.scarti[0].desScarto == 'La pratica non presenta assicurazioni ALICO' ||
                    apSinResp.datiAperturaSinistroResponse.scarti[0].desScarto == 'Data del sinistro maggiore di Data Scadenza e/o Data O') {
                        System.debug('scarti1');
                        s = setSinistroFields(s, apSinResp, 'Ricevuto');
                        uCase.Status = 'Ricevuto';
                        uCase.Tipo_Pratica__c = apSinResp.datiAperturaSinistroResponse.tipoPratica;
                        caseToUpdate.add(uCase);
                        sinistriToUpdate.add(s);
                }
            }else{
                System.debug('scarti2');
                s = setSinistroFields(s, apSinResp, 'Ricevuto');
                uCase.Status = 'Ricevuto';
                uCase.Tipo_Pratica__c = apSinResp.datiAperturaSinistroResponse.tipoPratica;
                caseToUpdate.add(uCase);
                sinistriToUpdate.add(s);
            }    
        }else{
            System.debug('dati non coerenti');
            emailBodyEsitoKO += '\ni dati tra Salesforce e OCS non sono coerenti, numPraticaOCS='+apSinResp.datiAperturaSinistroResponse.numPratica;
            s.Flag_err__c = true;
            sinistriWithError.add(s);
            System.debug('sinistriWithError size after add: '+sinistriWithError.size());
        }
        return s;
    }


    public String creaDataPerReq(Date d) {
        
		String dataReq;
		String sAnno;
    	String sMese;
    	string sGiorno;

    	sAnno =  String.valueOf(d.year());

        
        if(d.month()<10){
            sMese = '0' + d.month();
        }else{
            sMese = String.valueOf(d.month());
        }
        
        if(d.day()<10){
            sGiorno = '0' + d.day();
        }else{
            sGiorno = String.valueOf(d.day());
        }
        
        system.debug('---------------------------------------------------------------------------------------');
        system.debug('-- Class Name: CRMBatInserisciSinistro - Method Name: creaDataPerReq'); 
        system.debug('-- Data OK -> ' + sGiorno + sMese + sAnno );
        
		dataReq = sGiorno + sMese + sAnno;
        
        return dataReq;
    }

    public String creaDataPerInsert(String s) {
        
        String da;
        String daOK= '';
        if(s!=null){
            daOK = s.mid(6,4) + '-' + s.mid(3,2) + '-' + s.mid(0,2);
        }
        return daOK;
    }
}