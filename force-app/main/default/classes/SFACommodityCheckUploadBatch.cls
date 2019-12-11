global virtual class SFACommodityCheckUploadBatch implements Database.Batchable<sObject>, Database.Stateful {

    global SFACommodityCheckUploadBatch nextBatch;
    global String fileName;
    global String timestamp;
    global String[] colsHeader;

    global SFACommodityCheckUploadBatch(String[] colsHeader,String fileName,String timestamp){
        this.fileName = fileName;
        this.timestamp = timestamp;
        this.colsHeader = colsHeader;
    }
  
    global static final String OK='OK';


    global virtual String check(String[] cols,SFA_ComCheck__c sfacheck){
        return OK;
    }

     /**
    *  cerca l'indice del campo nomeCampo in base all header del tracciato
    *
    */
    protected Integer getIndexHeader(List<String> header,String nomeCampo) {
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
    protected Integer getKeyRecord(List<String> header) {
        Integer index = getIndexHeader(header,'PRATICA');
        if (index!=-1) {
            // esiste campo PRATICA
            return index;
        }
        // non esiste PRATICA, riprova con campo CARTA
        return getIndexHeader(header,'CARTA');
    } 
   

    /**
    *   verifica se è un tracciato di tipo Variazione sulla base dell'header
    *
    */
    protected Boolean isTracciatoVariazione() {
        Integer index = getIndexHeader(colsHeader,'COD_DEALER');
        if (index!=-1) {
            // esiste campo COD_DEALER: è un tracciato di Variazione Anagrafica
            return true;
        }
        // non esiste campo COD_DEALER: non è un tracciato di Variazione Anagrafica
        return false;
    } 
   


    global virtual Database.QueryLocator start(Database.BatchableContext bc) {
        String query='SELECT FileName__c, Index__c, Row__c, Status__c, Timestamp__c, DealerId__c, FilialeId__c, FilialeQueueName__c FROM SFA_ComCheck__c where FileName__c = \''+fileName+'\' AND Timestamp__c=\''+timestamp+'\' AND Status__c=\'\'';
        System.debug(query);
        return Database.getQueryLocator(query);
    }   

    global virtual void execute(Database.BatchableContext bc, List<SFA_ComCheck__c> listCheck) {
        if (listCheck!=null && listCheck.size()>0) {
            for (SFA_ComCheck__c check:listCheck) {
                String[] cols = check.Row__c.split(SFACommodityUploadCSVController.SEPARATOR);
                String status = check(cols,check);
                if (!OK.equals(status)) {
                    // aggiorna errore
                    System.debug('Row:'+check.Index__c+':Errore:'+status);
                    check.Status__c = status;
                }
            }
            update listCheck;
        }
    }

    global virtual void finish(Database.BatchableContext bc){ 
        if (nextBatch!=null) {
            Database.executeBatch(nextBatch);
        } else {
            // catena completata
            List<SFA_ComCheck__c> listCheck = [SELECT Timestamp__c, Status__c FROM SFA_ComCheck__c where FileName__c =: fileName  AND Timestamp__c=:timestamp];
            if (listCheck!=null && listCheck.size()>0) {
                for (SFA_ComCheck__c check:listCheck) {
                    if (String.isEmpty(check.Status__c)) {
                        // se non ci sono errori, metto lo stato finale a OK
                        check.Status__c = OK;
                    }
                }
                update listCheck;
            }
        }
    }
       
}