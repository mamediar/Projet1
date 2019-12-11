/**
* Class: SFACommodityUploadCSVController
* @description: apex class contains implements method for contro and upload a file
* @date:09/10/2019
**/
public class SFACommodityUploadCSVController {


    public static final List<String> prodotti = new List<String>{'PP','PAPF','CARTA','CONSUMO'};
    public static final List<String> tipiFile = new List<String>{'Esiti Critici','Esiti Anomali','Variazioni Anagrafiche'};

    public static final List<String> headerConsumoPP = new List<String>{'PRATICA','DIP','SOC','CLIENTE','COD_AG','AGENTE','COD_SA','SUBAGENTE','CATEGORIA','COD_ESITO','DESCR_ESITO','NOTA_SOC_ESTERNA','DATA_NOTIFICA'};
    public static final List<String> headerConsumoPAPF = new List<String>{'PRATICA','DIP','SOC','CLIENTE','COD_CV','CONVENZIONATO','COD_PV','PUNTO_VENDITA','CATEGORIA','COD_ESITO','DESCR_ESITO','NOTA_SOC_ESTERNA','DATA_NOTIFICA'};
    public static final List<String> headerCarta= new List<String>{'CARTA','DIP','SOC','CLIENTE','COD_CV','CONVENZIONATO','COD_PV','PUNTO_VENDITA','CATEGORIA','COD_ESITO','DESCR_ESITO','NOTA_SOC_ESTERNA','DATA_NOTIFICA'};
    public static final List<String> headerVariazoniAnagraficaConsumo = new List<String>{'REGIONE','AREA','PRODOTTO','PRATICA','DIP','SOC','CLIENTE','COD_DEALER','DEALER','CATEGORIA','COD_ESITO','DESCR_ESITO','NOTA_SOC_ESTERNA','DATA_NOTIFICA'};
    public static final List<String> headerVaziazioniAnagrafiaCarta = new List<String>{'REGIONE','AREA','PRODOTTO','CARTA','DIP','SOC','CLIENTE','COD_DEALER','DEALER','CATEGORIA','COD_ESITO','DESCR_ESITO','NOTA_SOC_ESTERNA','DATA_NOTIFICA'};

    public static final String SEPARATOR = ';';

    private static final  XCS_Categoria__c categoriaCritical =  XCS_CategoriaUtil.findCategoryByExternalID(XCS_CategoriaUtil.COMMODITY_CHECK_CRITICAL);
    private static final  XCS_Categoria__c categoriaAnomaly =  XCS_CategoriaUtil.findCategoryByExternalID(XCS_CategoriaUtil.COMMODITY_CHECK_ANOMALY);
    private static final  XCS_Categoria__c categoriaVariazione =  XCS_CategoriaUtil.findCategoryByExternalID(XCS_CategoriaUtil.COMMODITY_CHECK_VARIAZIONE_ANAGRAFICA);


    public final static String RECORD_TYPE_COMMODITY ='Commodity_Check';
    public class Result {
       
        
        @AuraEnabled
        public String error {set;get;}

        @AuraEnabled
        public String timeStamp {set;get;}

        @AuraEnabled
        public String[] header {set;get;}

        public Result() {
        }

        public Result(String error,String timeStamp) {
            this.error = error;
            this.timeStamp = timeStamp;
        }
    }

    /**
    *  decodifica il tipo di header per prodotto / tipo file
    */
    private static List<String> decodeTipoHeader(String prodotto,String tipoFile){
        Integer prodIndex = prodotti.indexOf(prodotto);
        if (prodIndex==0) {
            return headerConsumoPP;
        } else if (prodIndex==1) {
            return headerConsumoPAPF;
        } else if (prodIndex==2) {
            Integer tipiFileIndex = tipiFile.indexOf(tipoFile);
            if (tipiFileIndex==0 || tipiFileIndex==1) {
                return headerCarta;
            } else if (prodIndex==2) {
                return headerVaziazioniAnagrafiaCarta;
            }
        } else if (prodIndex==3) {
            return headerVariazoniAnagraficaConsumo;
        }
        return null;
    }


    /**
    *
    *   controllo validità header del csv caricato
    */
    private static Boolean checkHeader(String rowHeader,String prodotto,String tipoFile){
        List<String> header = decodeTipoHeader(prodotto,tipoFile);
        System.debug('header richiesto:'+header);
        if (header==null) {
            System.debug('header non trovato per prodotto '+prodotto+' tipoFile '+tipoFile);
            return false;           
        }
        if (rowHeader!=null && rowHeader.contains(SEPARATOR) ) {           
            String[] colsHeader = rowHeader.split(SEPARATOR);
            // check numero field header
            if (header.size()==colsHeader.size()) {
                 for (Integer i=0;i<header.size();i++) {                    
                    String col = colsHeader.get(i).trim();
                    String head = header.get(i).trim();

                    // check ogni campo header
                    if (!col.equalsIgnoreCase(head)) {
                        System.debug('Non trovata corrispondenza tra header:'+head+': field csv:'+col);
                        return false;
                    }
                 }
                 // controlli finiti:OK
                 return true;
            } else {
                 System.debug('Non corrisponde il numero '+header.size()+' dei campi dell header richiesto');
            }
        }
        return false;
    }  
 


    private static String writeRecords(String fileName,String[] rows){
       Datetime dt = Datetime.now();
       Long start = dt.getTime()*1000+dt.millisecond();
       String timestamp = String.valueOf(start);
       if (rows!=null && rows.size()>0) {
           List<SFA_ComCheck__c> listCheck = new  List<SFA_ComCheck__c>();
           for (Integer i=1;i<rows.size();i++) {
                SFA_ComCheck__c sfaCheck = new SFA_ComCheck__c();
                sfaCheck.Index__c = i;
                sfaCheck.Status__c = '';
                sfaCheck.FileName__c = fileName;
                sfaCheck.Row__c = rows[i];
                sfaCheck.Timestamp__c = timestamp;
                listCheck.add(sfaCheck);
           }
           insert listCheck;
       }
       return timestamp;

    }

    private static String runBatchCheckUpload(String fileName, String[] rows){
        String timestamp = writeRecords(fileName,rows);
        String[] colsHeader = rows[0].split(SEPARATOR);
        ID jobID = Database.executeBatch(new SFACommodityCheckRecordsUploadBatch(colsHeader,fileName,timestamp));  
        return timestamp;           
    }

    /**
    *
    *  metodo principale per tutti i controlli del CSV
    */
    @AuraEnabled
    public static Result checkRecordsCSV(String fileData,String prodotto,String tipoFile,String fileName) {
        Result result = new Result();
        String[] rows = null;  
        System.debug(':prodotto:'+prodotto+':tipoFile:'+tipoFile);
        if (!String.isEmpty(fileData)) {
           System.debug('fileData non vuoto');
           rows = fileData.split('\n');
           System.debug('fileData rows:'+rows.size());
           if (rows!=null && rows.size()>=2 && rows[0].contains(SEPARATOR)) {
               result.header = decodeTipoHeader(prodotto,tipoFile);
               if(!checkHeader(rows[0],prodotto,tipoFile)) {
                    result.error = 'Header non corretto per prodotto '+prodotto+' tipoFile '+tipoFile;
                    return result;
               }
               System.debug('inizio controllo righe');
               result.timeStamp = runBatchCheckUpload(fileName,rows);
               System.debug(' result timeStamp:'+ result.timeStamp);
           } else {
                result.error = 'CSV senza record oppure campi non separati dal carattere speciale '+SEPARATOR;
                return result;
           }
        } else {
            // CSV vuoto
            result.error = 'CSV vuoto';
            return result;
        }
        return result;
    }

    @AuraEnabled
    public static List<String> listTipiFile() {
        return tipiFile;
    }

    @AuraEnabled
    public static List<String> listProdotti() {
        return prodotti;
    }

    @AuraEnabled
    public static List<SFA_ComCheck__c> listRecordsCompleted(String fileName,String timestamp) {
          System.debug(' listRecordsCompleted fileName:'+fileName+':timestamp:'+timestamp);
         // tutti i records completati hanno lo stato valorizzato
         List<SFA_ComCheck__c> listCheckDaElaborare = [SELECT Timestamp__c FROM SFA_ComCheck__c where FileName__c =: fileName  AND Timestamp__c=:timestamp AND Status__c = ''];
         List<SFA_ComCheck__c> listCheckElaborati = [SELECT Index__c, Row__c, Status__c, Timestamp__c FROM SFA_ComCheck__c where FileName__c =: fileName  AND Timestamp__c=:timestamp AND Status__c <> ''];
         if (listCheckDaElaborare.size()==0 && listCheckElaborati.size()>0) {
             return listCheckElaborati;
         }
         return null;
    }


     /**
    *  cerca l'indice del campo nomeCampo in base all header del tracciato
    *
    */
    private static Integer getIndexHeader(List<String> header,String nomeCampo) {
        if (header!=null) {
            for (Integer i=0;i<header.size();i++) {
                if (nomeCampo.equalsIgnoreCase(header[i].trim())) {
                       return i; 
                }
            }
        }
        return -1;
    } 

    /**
    *  cerca l'indice del campo (PRATICA o CARTA a seconda del tracciato)
    *  che rappresenta una chiave univoca per i records del tracciato
    *
    */
    private static Integer getKeyRecord(List<String> header) {
        Integer index = getIndexHeader(header,'PRATICA');
        if (index!=-1) {
            // esiste campo PRATICA
            return index;
        }
        // non esiste PRATICA, riprova con campo CARTA
        return getIndexHeader(header,'CARTA');
    } 



    private static Case createCaseCommodity(SFA_ComCheck__c check,String prodotto,String tipoFile, List<Group> queues){
        String[] cols = check.Row__c.split(SEPARATOR); 
        List<String> header = decodeTipoHeader(prodotto,tipoFile);
        Case caseCommodity = new Case();
        Integer indexKey = getKeyRecord(header); 
        caseCommodity.NumeroPratica__c = cols.get(indexKey);
        // controllo se tracciato è di tipo pratica o carta
        Integer indexPratica = getIndexHeader(header,'PRATICA');
        if (indexPratica!=-1) {
            caseCommodity.Tipo_Pratica__c = 'P';
        } else {
            caseCommodity.Tipo_Pratica__c = 'C';
        }
        // setta la filiale
        caseCommodity.Branch__c = check.FilialeId__c;
        // setta il dealer di riferimento (Intermediario)
        caseCommodity.AccountId = check.DealerId__c;
        Integer indexCodDealer = getIndexHeader(header,'COD_DEALER'); 
        if (indexCodDealer!=-1) {
            caseCommodity.CodiceDealer__c=  cols.get(indexCodDealer);
        }
   
        caseCommodity.RecordTypeId = RecordTypeUtil.getCaseRecordType(RECORD_TYPE_COMMODITY);
        caseCommodity.Status = 'New';
        Integer indexCategoria = getIndexHeader(header,'CATEGORIA'); 
     
        XCS_Categoria__c categoria = null;
        Date dataScadenza = Date.today();
        String descrizione = '';
        // gestione categoria, data scadenza, descrizione sulla base del tipo file in input
        
        if ('Esiti Critici'.equals(tipoFile)) {
           categoria = categoriaCritical;
           // La due date impostata di default per questa tipologia di attivita e' di 7 giorni. 
           dataScadenza = dataScadenza.addDays(7);
           //  La descrizione dell’attività dipende dal tipo di file caricato -	Esiti critici o anomali: <prodotto> - <numero_pratica/carta> - <categoria>
           descrizione = prodotto+' - '+caseCommodity.NumeroPratica__c+' - '+cols.get(indexCategoria);

        } else if ('Esiti Anomali'.equals(tipoFile)) {
           categoria = categoriaAnomaly;
           // La due date impostata di default per questa tipologia di attivita e' di 30 giorni. 
           dataScadenza = dataScadenza.addDays(30);
           //  La descrizione dell’attività dipende dal tipo di file caricato -	Esiti critici o anomali: <prodotto> - <numero_pratica/carta> - <categoria>
           descrizione = prodotto+' - '+caseCommodity.NumeroPratica__c+' - '+cols.get(indexCategoria);
 
        } else if ('Variazioni Anagrafiche'.equals(tipoFile)){
           categoria = categoriaVariazione;
           // La due date impostata di default per questa tipologia di attivita' e' l ultimo giorno del mese successivo alla data di caricamento. 
           dataScadenza = dataScadenza.addMonths(1);
           dataScadenza = Date.newInstance(dataScadenza.year(),dataScadenza.month(),1);
           dataScadenza = dataScadenza.addDays(-1);
           //  La descrizione dell’attività dipende dal tipo di file caricato -	Variazione anagrafica: <numero_pratica/carta>
           descrizione = caseCommodity.NumeroPratica__c;
        }
        if (categoria!=null) {
            caseCommodity.Categoria_Riferimento__c = categoria.Id;
            caseCommodity.Subject = categoria.Name;
        }
        caseCommodity.DueDate__c = dataScadenza;
        caseCommodity.Description = descrizione;
        // assegna case alla coda della filiale
        if (queues!=null && queues.size()>0) {
            for (Group queue:queues) {
                if (queue.DeveloperName !=null &&  queue.DeveloperName.equalsIgnoreCase(check.FilialeQueueName__c)) {
                        caseCommodity.OwnerId = queue.Id;
                }
            }
        }
        caseCommodity.Priority = SFACommodityPriorityUploadBatch.calculatePriority(caseCommodity,categoria.External_Id__c);
        return caseCommodity;
    }

    private static Sfa_commodity_check_activity_details__c createCommodityDetail(SFA_ComCheck__c check,String prodotto,String tipoFile){
        String[] cols = check.Row__c.split(SEPARATOR); 
        List<String> header = decodeTipoHeader(prodotto,tipoFile);
        Sfa_commodity_check_activity_details__c commodityDetail = new Sfa_commodity_check_activity_details__c();
//        System.debug('createCommodityDetail header:'+header);
        Integer indexKey = getKeyRecord(header); 
        commodityDetail.Num_Pratica__c = cols.get(indexKey);
        Integer indexSoc = getIndexHeader(header,'SOC'); 
        commodityDetail.Societa__c = cols.get(indexSoc);
        Integer indexCategoria = getIndexHeader(header,'CATEGORIA'); 
        commodityDetail.Categoria__c =  cols.get(indexCategoria);
        Integer indexCodAgente = getIndexHeader(header,'COD_AG'); 
        if (indexCodAgente!=-1) {
            commodityDetail.Cod_agente_convenzionato__c =  cols.get(indexCodAgente);
        }
        Integer indexCliente = getIndexHeader(header,'CLIENTE'); 
        if (indexCliente!=-1) {
            commodityDetail.Debitore__c =  cols.get(indexCliente);
        }
        Integer indexAgente = getIndexHeader(header,'AGENTE'); 
        if (indexAgente!=-1) {
            commodityDetail.Rag_sociale_agente_convenzionato__c =  cols.get(indexAgente);
        }
        Integer indexCodSubAge= getIndexHeader(header,'COD_SA'); 
        if (indexCodSubAge!=-1) {
            commodityDetail.Cod_subagente_pv__c =  cols.get(indexCodSubAge);
        }
        Integer indexSubAgente = getIndexHeader(header,'SUBAGENTE'); 
        if (indexSubAgente!=-1) {
            commodityDetail.Rag_sociale_subagente_pv__c =  cols.get(indexSubAgente);
        }
        Integer indexCodConvenz= getIndexHeader(header,'COD_CV'); 
        if (indexCodConvenz!=-1) {
            commodityDetail.Cod_agente_convenzionato__c =  cols.get(indexCodConvenz);
        }
        Integer indexConvenzionato = getIndexHeader(header,'CONVENZIONATO'); 
        if (indexConvenzionato!=-1) {
            commodityDetail.Rag_sociale_agente_convenzionato__c =  cols.get(indexConvenzionato);
        }
        Integer indexCodPuntoV = getIndexHeader(header,'COD_PV'); 
        if (indexCodPuntoV!=-1) {
            commodityDetail.Cod_subagente_pv__c =  cols.get(indexCodPuntoV);
        }
        Integer indexPuntoV= getIndexHeader(header,'PUNTO_VENDITA'); 
        if (indexPuntoV!=-1) {
            commodityDetail.Rag_sociale_subagente_pv__c =  cols.get(indexPuntoV);
        }
        Integer indexCodEsito = getIndexHeader(header,'COD_ESITO'); 
        commodityDetail.Cod_esito__c =  cols.get(indexCodEsito);
        Integer indexDescEsito = getIndexHeader(header,'DESCR_ESITO'); 
        commodityDetail.Esito__c =  cols.get(indexDescEsito);
        Integer indexNotaSoc = getIndexHeader(header,'NOTA_SOC_ESTERNA'); 
        commodityDetail.Nota_societa_esterna__c = cols.get(indexNotaSoc);
        Integer indexDataNot= getIndexHeader(header,'DATA_NOTIFICA'); 
        String stringData = cols.get(indexDataNot);
        try {
            Date dataNotifica = Date.parse(stringData);  
            commodityDetail.Data_notifica__c = dataNotifica;
        }  catch (TypeException e) {}
        commodityDetail.Tipo_prodotto__c = prodotto;

        // controllo se tracciato è di tipo pratica o carta
        Integer indexPratica = getIndexHeader(header,'PRATICA');
        if (indexPratica!=-1) {
            commodityDetail.pratica_carta__c = 'P';
        } else {
            commodityDetail.pratica_carta__c = 'C';
        }
        return commodityDetail;
    }


    private class Commodity {
        public Case caseCommodity;
        public Sfa_commodity_check_activity_details__c detailCommodity;
        public Commodity (Case caseCommodity, Sfa_commodity_check_activity_details__c detailCommodity){
            this.caseCommodity = caseCommodity;
            this.detailCommodity = detailCommodity;
        }

    }  

    @AuraEnabled
    public static String createCasesCommodity(String fileName,String timestamp,String prodotto,String tipoFile) {        
         try {
            System.debug(' createCaseCommodityfileName:'+fileName+':timestamp:'+timestamp);
            List<SFA_ComCheck__c> listCheckOK = [SELECT Index__c, Row__c, Status__c, Timestamp__c, FilialeId__c, DealerId__c,FilialeQueueName__c FROM SFA_ComCheck__c where FileName__c =: fileName  AND Timestamp__c=:timestamp AND Status__c =:SFACommodityCheckUploadBatch.OK];
            if (listCheckOK!=null && listCheckOK.size()>0) {
                List<Group> queues = [SELECT Id, Name, DeveloperName from Group where Type='queue' AND DeveloperName<>null];
                List<Case> listaCases = new  List<Case>(); 
                List<Commodity> listaCommodity = new  List<Commodity>(); 
                for (SFA_ComCheck__c check:listCheckOK) {
                    Case caseCommodity = createCaseCommodity(check,prodotto,tipoFile,queues);
                    listaCases.add(caseCommodity);
                    Sfa_commodity_check_activity_details__c commodityDetail = createCommodityDetail(check,prodotto,tipoFile);
                    Commodity commodity = new Commodity(caseCommodity,commodityDetail);                 
                    listaCommodity.add(commodity);
                }
                // inserimento CASE
                insert listaCases;
                List<Sfa_commodity_check_activity_details__c> listaCommodityDetails = new  List<Sfa_commodity_check_activity_details__c>(); 
                for (Commodity commodity:listaCommodity) {
                    commodity.detailCommodity.Activity_id__c = commodity.caseCommodity.Id;
                    listaCommodityDetails.add(commodity.detailCommodity);
                }
                // inserimento dettaglio CASE 
                insert listaCommodityDetails;
            }
            // ripulizia tabella SFA_ComCheck__c
            delete listCheckOK;
         } catch (Exception ex) {
             System.debug('createCasesCommodity Errore Generale:'+ex);
             throw ex;
             //return 'Errore Generale:'+ex.getMessage();
         }
         return null;
    }


}