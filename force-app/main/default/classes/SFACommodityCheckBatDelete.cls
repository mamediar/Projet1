global class SFACommodityCheckBatDelete implements Database.Batchable <sObject>, Schedulable {
	
	global Database.QueryLocator start(Database.BatchableContext bcx){
		
		return Database.getQueryLocator([Select Id from sfa_commodity_check_activity_details__c]);
	
	}
	
	global void execute(Database.BatchableContext bcx, List<sfa_commodity_check_activity_details__c> scope){
		if(scope.size()>0){
		delete scope;
		}
	
	}
	
	global void execute(SchedulableContext sc) {
        SFACommodityCheckBatDelete batch = new SFACommodityCheckBatDelete(); 
        Database.executebatch(batch);
    }
	
	global void finish(Database.BatchableContext bcx){
		
	}

}