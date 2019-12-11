//----------------------------------------------------------------------
//-- - Class Name   : CRMBatLoadDinieghi
//-- - Autor        : Mauro Dotti(Lynx)
//-- - Date         : 30/07/2019
//-- - Description  : Batch per la creazione dei dinieghi
//-- - Version      : 1.0
//----------------------------------------------------------------------

global class CRMBatLoadDinieghi implements  Database.AllowsCallouts, Schedulable {

    
    global final static String QUEUE_DINIEGHI = 'Q190';
    private final static Integer LIMIT_DINIEGHI = 10000;

    public final static String STATO_RICEVUTO = 'Ricevuto';

    private Date getDateFromString(String dataString){
        if (dataString!=null && dataString.length()>=7) {
            Date data = Date.newInstance(Integer.valueof(dataString.mid(0,4)), Integer.valueof(dataString.mid(4,2)), Integer.valueof(dataString.mid(6,2)));
  //          system.debug('getDateFromString data:' + data);
            return data;

        }
        return null;
    }   


    
    global void execute(SchedulableContext sc) {
        OCSRecuperaDinieghiSDDResponse res= OCSrecuperaDinieghiSDDInvoker.callRecuperaDinieghiSDD(new OCSRecuperaDinieghiSDDRequest());
      
        Map <String,OCSRecuperaDinieghiSDDResponse.DiniegoSDDDTO> mapDinieghi= new Map<String,OCSRecuperaDinieghiSDDResponse.DiniegoSDDDTO>();
       	List <String> listProgreMan = new List<String>(); 
        List <String> listProgressivo = new List<String>(); 
        Map<Account, Account> mappaAccount = new Map<Account, Account>();  // mappa con tutti gli account da creare o da controllare
        Map<String, String> mandatiErrati = new  Map<String, String>();   // mappa delle keys dei dinieghi da scartare con motivo scarto
		Map<String, String> mappaDinieghiAccount = new  Map<String, String>();  
		Map<String, String> mappaAccountDinieghi = new  Map<String, String>();  
        

        Integer indexMan = 0;
        if (res.recuperaDinieghiSDDResponse!=null && res.recuperaDinieghiSDDResponse.elenco!=null && res.recuperaDinieghiSDDResponse.elenco.size()>0) {  
            // CREO MAPPA PER CONTROLLO DUPLICATI E ACCOUNT        
            for(OCSRecuperaDinieghiSDDResponse.DiniegoSDDDTO r : res.recuperaDinieghiSDDResponse.elenco){
                listProgreMan.add(r.canomanProgreMan);
                listprogressivo.add(r.canomanProgressivo);
                String key = r.canomanProgreMan +'-'+ r.canomanProgressivo;
                if (String.isBlank(r.acCognome) || String.isBlank(r.acNome) || String.isBlank( r.canomanCliente)) {
                    //Deve essere tracciato il motivo dello scarto
                    mandatiErrati.put(key, 'Anagrafica non corretta');
                    continue;
                }
                listProgreMan.add(r.canomanProgreMan);
                listprogressivo.add(r.canomanProgressivo);
            
            
                // GESTIONE ANAGRAFICA INIZIO
                Account acc = new Account();
                acc.FirstName = r.acNome;
                acc.Lastname = r.acCognome;
                acc.Data_Nascita__c = getDateFromString(r.acNascitadata);
                acc.Luogo_Nascita__pc = r.acNascitaLuogo;
                acc.Provincia_Nascita__pc = r.acNascitaProv;
                acc.Sesso__pc = r.acSesso;
                acc.PersonEmail = r.acEmail;
                acc.Codice_Fiscale__pc = r.canomanCodFiscale;
                acc.Telefono_Casa__c = r.canomanTel;
                acc.Telefono_Cellulare__c = r.canomanCell;
                acc.OCS_External_Id__c = r.canomanCliente;
                mappaAccount.put(acc, null);
                System.debug('mappaAccount acc:'+acc);
                System.debug('PersonEmail: '+acc.get('PersonEmail'));
                System.debug('isFound: ' + acc.get('PersonEmail') <> null);
                mapDinieghi.put(key,r);
                mappaAccountDinieghi.put('C'+acc.OCS_External_Id__c, key); // OCS_External_Id__c has prefix 'C'
                //if 10.000 Termino
                if (indexMan >=LIMIT_DINIEGHI) {
                    break;
                }
                indexMan ++;
            }
        }
        if (!mappaAccount.isEmpty()) {
            System.debug('mappaAccount:'+mappaAccount);
            XCSGestioneAnagrafica.deduplica(mappaAccount, true);
        }
        //Variabile utilizzata solo dentro il for
        List<Account> listaTemp = [SELECT Id, OCS_External_Id__pc, OCS_External_Id__c FROM Account Where id in:mappaAccount.values()];
       for(Account temp : listaTemp){         
//            System.debug('mappaDinieghiAccount key:'+mappaAccountDinieghi.get(temp.OCS_External_Id__c)+' val '+temp.id+ ' temp OCS_External_Id__pc:'+temp.OCS_External_Id__pc+' OCS_External_Id__c:'+temp.OCS_External_Id__c);    
            System.debug('mappaDinieghiAccount key:'+mappaAccountDinieghi.get(temp.OCS_External_Id__c)+' val '+temp.id+ ' temp OCS_External_Id__c:'+temp.OCS_External_Id__c);    
            mappaDinieghiAccount.put(mappaAccountDinieghi.get(temp.OCS_External_Id__c), temp.id);    
        }
        
        // SELEZIONO MANDATI GIA PRESENTI
		List<Mandati_SDD__c> listMandatiDuplicati = [SELECT id, ProgreMan__c, Progressivo__c 
                                            FROM Mandati_SDD__c 
                                            WHERE ProgreMan__c = :listProgreMan 
                                            AND Progressivo__c = :listProgressivo]; 

        // ESTRAGGO MANDATI PRESENTI DALLA LISTA ARRIVATA DAL SERVIZIO 
        // Creazione Lista lettura   
        List<Mandati_SDD__c> mandatiDuplicati = new List<Mandati_SDD__c>();
        for(Mandati_SDD__c m : listMandatiDuplicati){
            String key = m.ProgreMan__c+'-'+m.Progressivo__c;
            if (mapDinieghi.get(key)!=null){ //Scarto il diniego duplicato
                mandatiErrati.put(key, 'Mandato già presente');
                m.IsSendOCS__c=false;
                mandatiDuplicati.add(m);
                mapDinieghi.remove(key); 
            }
        }
		update mandatiDuplicati;
                                                     
        List<Case> listaCase = new List<Case>();
        //CREO L'INCIDENT
		List<Mandati_SDD__c> mandatiOk = new List<Mandati_SDD__c>();
        RecordType rt = [Select id from RecordType where SobjectType = 'Case' AND DeveloperName = 'Dinieghi_SDD_Verifiche_Filiale'];
        
        Id queueId = [SELECT Id FROM Group WHERE DeveloperName =: QUEUE_DINIEGHI LIMIT 1].Id;

        Map<String, Case> mappaDiniegoCase = new Map<String, Case>();
        for(OCSRecuperaDinieghiSDDResponse.DiniegoSDDDTO d : mapDinieghi.values()){
            String keyMan = d.canomanProgreMan +'-'+ d.canomanProgressivo;
            Case caso = new Case();
            caso.Subject = 'Mandato Diniego '+keyMan;
            caso.Status = 'New';
            caso.NumeroPratica__c = d.canomanPratica;
            caso.External_Id__c = keyMan;
            caso.OwnerId = queueId;  
            caso.RecordTypeId = rt.Id;

            listaCase.add(caso);
            mappaDiniegoCase.put(keyMan, caso);
        }
         // inserimento CASES
        insert listaCase;
        
        for(OCSRecuperaDinieghiSDDResponse.DiniegoSDDDTO d : mapDinieghi.values()){
            String keyMan = d.canomanProgreMan +'-'+ d.canomanProgressivo;
        	Mandati_SDD__c man = new Mandati_SDD__c();
            man.Abi__c = d.canomanAbi;
            man.Accettato__c = d.canomanAccepted;
            man.Attrib_Pratica__c = d.canomanAttrPr;
            man.Cab__c = d.canomancab;
            man.Codice_Cliente__c = mappaDinieghiAccount.get(keyMan);
            man.ContoCorrente__c = d.canomanContocorrente;
            man.Convenzionato__c = d.canomanConvenz;
            // GESTIONE DATE
            man.Data_Inserimento__c = getDateFromString(d.canomanDataIns);
            man.Data_Invio__c = getDateFromString(d.canomanDataInv);
            man.Data_Rientro__c = getDateFromString(d.canomanDataRie);

            man.Denominazione_Banca__c = d.canomanDenBanca;
            String codiceFiliale = d.canomanFiliale;
            if (String.isNotEmpty(codiceFiliale)) {
                codiceFiliale = codiceFiliale.replaceAll('0', '');
            }            
            man.Filiale__c = codiceFiliale;
            man.Gruppo__c = d.canomanGruppo;
            man.Iban__c = d.canomaIban;
            man.Intestatario_cc__c = d.canomanIntest;
            man.Mandato__c = d.canomanMandato;
            man.Modalita_Pagamento__c = d.canomanPagamento;
            man.Motivo_Diniego__c = d.canomanReason;
            man.PraticaNum__c = d.canomanPratica;
            man.ProgreMan__c = d.canomanProgreMan;
            man.Progressivo__c = d.canomanProgressivo;
            man.Ragione_Sociale_Cliente__c = d.canomanRagione;
            man.Ragione_Sociale_Intest_cc__c = '';
            man.Stato_Mandato__c = (d.canomanStato!=null && d.canomanStato=='00')?STATO_RICEVUTO:d.canomanStato;
            man.Stato_Pratica__c = d.canomanStatoPr;
            man.Telefono_Banca__c = d.canomanTelCab;
            man.Tipo_Messaggio__c = d.canomanProvenienza;
            man.Caseid__c = mappaDiniegoCase.get(keyMan).Id;
            mandatiOk.add(man);
            // Creo case e aggiungo a lista

        }
        
       


        // inserimento Dinighi (Mandati_SDD) 
        List<Database.SaveResult> resultInsertMandati = Database.insert(mandatiOk, false) ;
        Set<Id> inseritiConSuccesso = new Set<Id>();
        Integer index = 0;
        for(Database.SaveResult result : resultInsertMandati){
            if(result.isSuccess()){
                inseritiConSuccesso.add(result.getId());
            } 
            
            else{
                Mandati_SDD__c m = mandatiOk[index];
                String key = m.ProgreMan__c+'-'+m.Progressivo__c;
                String mess = null;
                for(Database.Error err : result.getErrors()) {
                    mess = err.getStatusCode() + ': ' + err.getMessage();
                    mess+='\t'+ 'Mandato fields that affected this error: ' + err.getFields();
                }
                if(mess!=null)mandatiErrati.put(key, mess);

            } 
            index++;
            List<Case> listaCaseOrfani = new List<Case>();
            for(Mandati_Sdd__c mandato : mandatiOk){
               if(mandato.id == null && mandato.caseId__c != null) listaCaseOrfani.add(new Case(Id = mandato.caseId__c));
            }
            
            delete listaCaseOrfani;
        }

        CRMBatProcessDiniego bat = new  CRMBatProcessDiniego(res.recuperaDinieghiSDDResponse.elenco.size(),mandatiOk.size(),mandatiErrati);
        if (!Test.isRunningTest()) {
            Id batchJobId = Database.executeBatch(bat, 10);
        }
    }


}