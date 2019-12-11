global class SFACommodityCheckRecordsUploadBatch extends SFACommodityCheckUploadBatch {


    private  List<String> listRecordsOK = new List<String>();
    private  static final List<String> listCodiciEsitiPermessi =  new List<String>{'C20','C40'};

    global SFACommodityCheckRecordsUploadBatch(String[] colsHeader,String fileName,String timestamp){
          super(colsHeader,fileName,timestamp);
          // setta il batch successivo : controllo filiale
          nextBatch = new SFACommodityCheckFilialeUploadBatch(colsHeader,fileName,timestamp);
    }

    /**
    *  controlli sul csv 
    *
    */
    global override String check(String[] cols,SFA_ComCheck__c sfacheck){
        // controllo che numero dei campi del record corrisponde al numero delle colonne dell header
        if (cols.size()!=colsHeader.size()) {
            System.debug('riga KO: row size'+cols.size()+':header size:'+colsHeader.size());
            return 'Errore numero campi';                     
        }
        // controllo formato campi
        // controllo Data Notifica
        try {
            Integer indexDataNot= getIndexHeader(colsHeader,'DATA_NOTIFICA'); 
            String stringData = cols.get(indexDataNot);
            Date dataNotifica = Date.parse(stringData);  
        } catch (Exception ex) {
            return 'Campo DATA_NOTIFICA non nel formato DD/MM/YYYY'; 
        }
        Integer indexCodiceEsito = getIndexHeader(colsHeader,'COD_ESITO');
        String valueCodiceEsito = cols[indexCodiceEsito];
        // controllo campo codice esito non sia vuoto
        if (String.isBlank(valueCodiceEsito)) {
            System.debug('riga KO: CODICE ESITO VUOTO ');
            return 'Campo COD_ESITO vuoto';                     
        }
        // per le variazioni anagrafiche vengono esclusi dalla lettura i record con COD_ESITO diversi da C20 e C40 
        if (isTracciatoVariazione() && !listCodiciEsitiPermessi.contains(valueCodiceEsito)) {
            System.debug('riga KO: per le variazioni anagrafiche vengono esclusi dalla lettura i record con COD_ESITO diversi da '+listCodiciEsitiPermessi);
            return 'Campo COD_ESITO ('+valueCodiceEsito+') diverso da '+listCodiciEsitiPermessi+' per i tracciati di variazione';                     
        }
        Integer keyRecord = getKeyRecord(colsHeader);
        String valueKeyRecord = cols[keyRecord];
        // controllo che campo chiave (PRATICA o CARTA) non sia vuoto
        if (String.isBlank(valueKeyRecord)) {
            System.debug('riga KO: Numero Pratica o Carta vuoto ');
            return 'Campo PRATICA o CARTA vuoto';                     
        }
        Integer indexDIP = getIndexHeader(colsHeader,'DIP');
        String valueDip = cols[indexDIP];
        // controllo che campo chiave DIP non sia vuoto
        if (String.isBlank(valueDip)) {
            System.debug('riga KO: DIP vuoto ');
            return 'Campo DIP vuoto';                     
        }
        // controllo che nel csv stesso non ci siano records duplicati 
        for (String recordOK:listRecordsOK) {
            String[] fieldRecordOK = recordOK.split(SFACommodityUploadCSVController.SEPARATOR);
            if (valueKeyRecord.trim().equalsIgnoreCase(fieldRecordOK[keyRecord].trim())) {
                System.debug('Errore record duplicato nel tracciato');
                return 'Record duplicato nel tracciato';                       
            }
        }
        // record is OK
        String recordOK = '';
        for (String col:cols) {
            recordOK+=col+SFACommodityUploadCSVController.SEPARATOR;
        }
        recordOK = recordOK.substring(0, recordOK.length()-1);
        listRecordsOK.add(recordOK);
        return OK;
    }
}