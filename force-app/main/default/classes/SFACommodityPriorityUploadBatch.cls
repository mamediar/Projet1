global class SFACommodityPriorityUploadBatch implements Database.Batchable<sObject>, Database.Stateful, Schedulable {

    global virtual Database.QueryLocator start(Database.BatchableContext bc) {
        String query='SELECT  Id, Priority, DueDate__c, Categoria_Riferimento__r.External_Id__c FROM Case where Status = \'New\' AND DueDate__c <> NULL AND Categoria_Riferimento__c <> NULL AND RecordType.DeveloperName = \''+SFACommodityUploadCSVController.RECORD_TYPE_COMMODITY+'\'';
        System.debug(query);
        return Database.getQueryLocator(query);
    }   


    
    private static final Map<Integer[],String> MAP_PRIORITY_ANOMALY_VARIAZIONE = new Map<Integer[],String>{ new Integer[]{30,1000} =>  'Low', new Integer[]{20,29} => 'Medium',new Integer[]{10,19}=>'High', new Integer[]{-999,9}=>'Critical'};
    private static final Map<Integer[],String> MAP_PRIORITY_CRITICAL = new Map<Integer[],String>{ new Integer[]{7,1000} =>  'Low', new Integer[]{4,6} => 'Medium',new Integer[]{2,3}=>'High', new Integer[]{-999,1}=>'Critical'};

    global static String calculatePriority(Case caso,String categoria) {
        Integer giorniAllaScadenza =  Date.today().daysBetween(caso.DueDate__c);
        System.debug('calculatePriority giorniAllaScadenza:'+giorniAllaScadenza);
        Map<Integer[],String> mapPriority = null;
        if (XCS_CategoriaUtil.COMMODITY_CHECK_ANOMALY.equals(categoria)) {
            mapPriority = MAP_PRIORITY_ANOMALY_VARIAZIONE;
        } else if (XCS_CategoriaUtil.COMMODITY_CHECK_CRITICAL.equals(categoria)) {
            mapPriority = MAP_PRIORITY_CRITICAL;
        } else if (XCS_CategoriaUtil.COMMODITY_CHECK_VARIAZIONE_ANAGRAFICA.equals(categoria)) {
            mapPriority = MAP_PRIORITY_ANOMALY_VARIAZIONE;
        }
        for (Integer[] interval : mapPriority.keySet()) {
            if (giorniAllaScadenza>=interval[0]  && giorniAllaScadenza<=interval[1]) {
                System.debug('calculatePriority FOUND:'+mapPriority.get(interval));
                return mapPriority.get(interval);
            }
        }
        // default
        return 'Low';
    }

    global virtual void execute(Database.BatchableContext bc, List<Case> listCase) {
        if (listCase!=null && listCase.size()>0) {
            for (Case caso:listCase) {
                caso.Priority = calculatePriority(caso,caso.Categoria_Riferimento__r.External_Id__c);
            }
            update listCase;
        }
    }

    global void execute(SchedulableContext sc) {
        SFACommodityPriorityUploadBatch b = new SFACommodityPriorityUploadBatch(); 
        Database.executebatch(b);
    }  
    
    global virtual void finish(Database.BatchableContext bc){ 
    }
}