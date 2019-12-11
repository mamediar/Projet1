global class SFACommodityCheckCaseUploadBatch extends SFACommodityCheckUploadBatch{
  
    private List<Case> cases_commodity;

    global SFACommodityCheckCaseUploadBatch(String[] colsHeader,String fileName,String timestamp){
        super(colsHeader,fileName,timestamp);
        cases_commodity = [SELECT Id, NumeroPratica__c FROM Case WHERE RecordType.DeveloperName = 'Commodity_Check' AND NumeroPratica__c != null];
    }
 

    /**
    *
    *  Controlla se esiste sul già sul CRM questa attività
    *  (controllo per 'PRATICA' o 'CASE')
    *
    */
    global override String check(String[] cols,SFA_ComCheck__c sfacheck){
        Integer keyRecord = getKeyRecord(colsHeader);
        String valueKEY = cols.get(keyRecord);
        valueKEY=valueKEY.trim();
        if (cases_commodity!=null) {
            for (Case case_comm:cases_commodity) {
                // controllo per Numero pratica
                if(case_comm.NumeroPratica__c == valueKEY) {
                    return 'Case gia\' esistente';
                }
            }
        }
        return OK;
    }

}