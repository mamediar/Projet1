/**
* Class: COM_UploadCSVFilesUtilities
* @description: apex class contains implements method for contro and upload a file
* @date:09/10/2019
**/
public class COM_UploadCSVFilesUtilities {


    public static final List<String> prodotti = new List<String>{'PP','PAPF','CARTA','CONSUMO'};
    public static final List<String> tipiFile = new List<String>{'Esiti Critici','Esiti Anomali','Variazioni Anagrafiche'};

    public static final List<String> headerConsumoPP = new List<String>{'PRATICA','DIP','SOC','CLIENTE','COD_AG','AGENTE','COD_SA','SUBAGENTE','CATEGORIA','COD_ESITO','DESCR_ESITO','NOTA_SOC_ESTERNA','DATA_NOTIFICA'};
    public static final List<String> headerConsumoPAPF = new List<String>{'PRATICA','DIP','SOC','CLIENTE','COD_CV','CONVENZIONATO','COD_PV','PUNTO_VENDITA','CATEGORIA','COD_ESITO','DESCR_ESITO','NOTA_SOC_ESTERNA','DATA_NOTIFICA'};
    public static final List<String> headerCarta= new List<String>{'CARTA','DIP','SOC','CLIENTE','COD_CV','CONVENZIONATO','COD_PV','PUNTO_VENDITA','CATEGORIA','COD_ESITO','DESCR_ESITO','NOTA_SOC_ESTERNA','DATA_NOTIFICA'};
    public static final List<String> headerVariazoniAnagraficaConsumo = new List<String>{'REGIONE','AREA','PRODOTTO','PRATICA','DIP','SOC','CLIENTE','COD_DEALER','DEALER','CATEGORIA','COD_ESITO','DESCR_ESITO','NOTA_SOC_ESTERNA','DATA_NOTIFICA'};
    public static final List<String> headerVaziazioniAnagrafiaCarta = new List<String>{'REGIONE','AREA','PRODOTTO','CARTA','DIP','SOC','CLIENTE','COD_DEALER','DEALER','CATEGORIA','COD_ESITO','DESCR_ESITO','NOTA_SOC_ESTERNA','DATA_NOTIFICA'};

    private static final List<Account> filiali = [SELECT Id, OCS_External_Id__c, OCSAreaId__c, Region_Name__c FROM Account WHERE RecordType.Name = 'Branch' AND OCS_External_Id__c<>null];
    private static final List<Account> dealers = [SELECT Id, OCS_External_Id__c FROM Account WHERE RecordType.Name = 'Dealer' AND OCS_External_Id__c<>null];
    private static final List<Case> cases_commodity = [SELECT Id, NumeroPratica__c FROM Case WHERE RecordType.Name = 'Commodity_Check' AND NumeroPratica__c<>null];
    private static final String SEPARATOR = ';';

    public class Error {
       
        @AuraEnabled
        public Integer index {set;get;}
        
        @AuraEnabled
        public String description {set;get;}

        @AuraEnabled
        public String row {set;get;}

        public final Integer GENERALE = -1;
        public Error() {
        }
        public Error(Integer index,String description,String row) {
            this.index = index;
            this.description = description;
            this.row = row;
        }
        public Error(String description) {
            this.index = GENERALE;
            this.description = description;
            this.row = 'GENERALE';
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

    /**
    *
    *  Controlla se esiste sul CRM la filiale con i valori inseriti nel tracciato 
    */
    private static Boolean checkFiliale(String[] cols,String[] colsHeader){
        // DIP ci sta sempre nei tracciati
        Integer indexDIP =  getIndexHeader(colsHeader,'DIP');       
        String valueDIP = cols.get(indexDIP);
        // aggiunge prefisso 'F'
        valueDIP=AccountUtils.getBranchExternalId(valueDIP.trim());
        // AREA e REGIONE possono esserci in base ai tracciati
        Integer indexREGIONE =  getIndexHeader(colsHeader,'REGIONE');
        String valueREGIONE = null;
        if (indexREGIONE!=-1) {
            valueREGIONE = cols.get(indexREGIONE);
            valueREGIONE = valueREGIONE.trim();
        }
        Integer indexAREA =  getIndexHeader(colsHeader,'AREA');
        Decimal valueAREA = null;
        if (indexAREA!=-1) {
             String valueAREAString = cols.get(indexAREA);
             valueAREA = Decimal.valueOf(valueAREAString.trim());
        }  
        if (filiali!=null) {
            for (Account filiale:filiali) {
                if (valueAREA!=null && valueREGIONE!=null) {
                    // controllo per la terna: DIP,REGIONE,AREA
                    if(filiale.OCS_External_Id__c == valueDIP && filiale.OCSAreaId__c ==valueAREA && filiale.Region_Name__c == valueREGIONE) {
                        return true;
                    }
                } else {
                    // controllo per DIP
                    if(filiale.OCS_External_Id__c == valueDIP) {
                        return true;
                    }
                }
            }
        }
        return false;
    }


    /**
    *
    *  Controlla se esiste sul CRM il Dealer
    */
    private static Boolean checkDealer(String[] cols,String[] colsHeader,Integer indexCOD_DEALER){
        String valueCOD_DEALER = cols.get(indexCOD_DEALER);
        valueCOD_DEALER=AccountUtils.getDealerExternalId(valueCOD_DEALER.trim());
        if (dealers!=null) {
            for (Account dealer:dealers) {
                // controllo per DIP
                if(dealer.OCS_External_Id__c == valueCOD_DEALER) {
                    return true;
                }
            }
        }
        return false;
    }


    /**
    *
    *  Controlla se esiste sul già sul CRM questa attività
    *  (controllo per 'PRATICA' o 'CASE')
    *
    */
    private static Boolean checkCaseCommodity(String[] cols,String[] colsHeader,Integer keyRecord){
        String valueKEY = cols.get(keyRecord);
        valueKEY=valueKEY.trim();
        if (cases_commodity!=null) {
            for (Case case_comm:cases_commodity) {
                // controllo per DIP
                if(case_comm.NumeroPratica__c == valueKEY) {
                    return true;
                }
            }
        }
        return false;
    }


    /**
    *
    *   controllo singolo record
    */
    private static Error checkSingleRecord(String row,String[] colsHeader,Integer index,List<String> listRecordsOK){
        String[] cols = row.split(SEPARATOR);
        // controllo che numero dei campi del record corrisponde al numero delle colonne dell header
        if (cols.size()!=colsHeader.size()) {
            System.debug('riga KO: row size'+cols.size()+':header size:'+colsHeader.size());
            return new Error(index,'Errore numero campi',row);                       
        }
        // controllo che nel csv stesso non ci siano records duplicati 
        Integer keyRecord = getKeyRecord(colsHeader);
        for (String recordOK:listRecordsOK) {
            String[] fieldRecordOK = recordOK.split(SEPARATOR);
            if (cols[keyRecord].trim().equalsIgnoreCase(fieldRecordOK[keyRecord].trim())) {
                System.debug('Errore record duplicato nel tracciato:'+row);
                return new Error(index,'Record duplicato nel tracciato',row);                       
            }
        }
        // controllo di persistenza: esistenza della Filiale indicata nel tracciato nel CRM
        if (!checkFiliale(cols,colsHeader)) {
            System.debug('Errore Filiale non trovata:'+row);
            return new Error(index,'Filiale non trovata:',row);                               
        }
        // controllo di persistenza: verifica della presenza del Dealer (solo se presente nel tracciato)
        Integer indexCOD_DEALER =  getIndexHeader(colsHeader,'COD_DEALER'); 
        if (indexCOD_DEALER!=-1 && !checkDealer(cols,colsHeader,indexCOD_DEALER)) {  
            System.debug('Errore Dealer non trovato:'+row);
            return new Error(index,'Dealer non trovato',row);                                           
        }
        // ccontrollo di persistenza: verifico se già esiste il case di tipo commodity check
        if (checkCaseCommodity(cols,colsHeader,keyRecord)) {
            System.debug('Errore Case già esistente:'+row);
            return new Error(index,'Case già esistente',row);                               
        }
        return null;
    }

    /**
    *
    *  metodo principale per tutti i controlli del CSV
    */
    @AuraEnabled
    public static Error[] checkRecordsCSV(String fileData,String prodotto,String tipoFile) {
        List<Error> errors = new List<Error>(); 
        String[] rows = null;  
        System.debug(':prodotto:'+prodotto+':tipoFile:'+tipoFile);
        if (!String.isEmpty(fileData)) {
           System.debug('fileData non vuoto');
           rows = fileData.split('\n');
           System.debug('fileData rows:'+rows.size());
           if (rows!=null && rows.size()>=2 && rows[0].contains(SEPARATOR)) {
               if(!checkHeader(rows[0],prodotto,tipoFile)) {
                    errors.add(new Error('Header non corretto per prodotto '+prodotto+' tipoFile '+tipoFile));
                    return errors;
               }
               System.debug('inizio controllo righe');
               String[] colsHeader = rows[0].split(SEPARATOR);
               List<String> listRecordsOK = new  List<String>();
               for (Integer i=1;i<rows.size();i++) {
                    Error error = checkSingleRecord(rows[i],colsHeader,i,listRecordsOK);
                    if (error!=null) {
                        // se ci sono errori sul single error, aggiungo alla lista di errori
                        errors.add(error);                       
                    } else {
                        // lista records Ok
                        listRecordsOK.add(rows[i]);
                    }
                }                
           } else {
                errors.add(new Error('CSV senza record oppure campi non separati dal carattere speciale '+SEPARATOR));
           }
        } else {
            // CSV vuoto
            errors.add(new Error('CSV vuoto'));
        }
        return errors;
    }

    @AuraEnabled
    public static List<String> listTipiFile() {
        return tipiFile;
    }

    @AuraEnabled
    public static List<String> listProdotti() {
        return prodotti;
    }

}