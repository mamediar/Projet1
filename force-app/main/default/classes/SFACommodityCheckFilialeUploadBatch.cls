global class SFACommodityCheckFilialeUploadBatch extends SFACommodityCheckUploadBatch {

    private List<Account> filiali;

    global SFACommodityCheckFilialeUploadBatch(String[] colsHeader,String fileName,String timestamp){
        super(colsHeader,fileName,timestamp);
        filiali = [SELECT Id, OCS_External_Id__c, OCSAreaId__c, Region_Name__c FROM Account WHERE RecordType.Name = 'Branch' AND OCS_External_Id__c<>null];
        // setta il batch successivo : controllo dealer
        nextBatch = new SFACommodityCheckDealerUploadBatch(colsHeader,fileName,timestamp);
    }
  
 

    /**
    *
    *  Controlla se esiste sul CRM la filiale con i valori inseriti nel tracciato 
    */
    global override String check(String[] cols,SFA_ComCheck__c sfacheck){
        // DIP ci sta sempre nei tracciati
        Integer indexDIP =  getIndexHeader(colsHeader,'DIP');       
        String valueDIP = cols.get(indexDIP);
        // levo gli 0 davanti alla filiale con 2 cifre
        if (valueDIP!=null && valueDIP.isNumeric()) {
            valueDIP=String.valueof(Integer.valueOf(valueDIP.trim()));
        }
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
        String filialeTracciato=valueDIP;
        if (filiali!=null) {
            for (Account filiale:filiali) {
                if (valueAREA!=null && valueREGIONE!=null) {
                    filialeTracciato=valueDIP+'-'+valueAREA+'-'+valueREGIONE;
                    // controllo per la terna: DIP,REGIONE,AREA
                    if(filiale.OCS_External_Id__c == valueDIP && filiale.OCSAreaId__c ==valueAREA && filiale.Region_Name__c == valueREGIONE) {
                        sfacheck.FilialeId__c = filiale.Id;
                        sfacheck.FilialeQueueName__c = filiale.OCS_External_Id__c;
                        return OK;
                    }
                } else {
                    // controllo per DIP
                    if(filiale.OCS_External_Id__c == valueDIP) {
                        sfacheck.FilialeId__c = filiale.Id;
                        sfacheck.FilialeQueueName__c = filiale.OCS_External_Id__c;
                        return OK;
                    }
                }
            }
        }
        return 'Filiale ('+filialeTracciato+') non presente';
    }


    
}