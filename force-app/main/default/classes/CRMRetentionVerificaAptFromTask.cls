public class CRMRetentionVerificaAptFromTask implements Schedulable
{
	Public Static Void execute(SchedulableContext ct)
    {
       List<Event> listaApp = [Select id,Desk__r.branch__c,customer__c,customer__r.getCodice_Cliente__c  From Event Where isChild= False AND isRetention__c = true AND activityDate = YESTERDAY  AND (Disposition__r.External_Id__c in('AP1','AP19','AP22','AP29') OR Disposition__c = null)] ;
       List<CRM_Retention__c> listRetention = new List<CRM_Retention__C>();
       List<AggregateResult> caseGroup = new List<AggregateResult>() ;
       Map<String,AggregateResult> mapAgg = new map<String,AggregateResult>();
       set<String> lSAccountId = new set<String>(); 
        for(Event e : listaApp){
            lSAccountId.add(e.Customer__c);
        }
        if(!lSAccountId.isEmpty()){
            caseGroup = [Select Max(CreatedDate) maxDate ,AccountId from Case where Accountid IN :lSAccountId AND ProcessType__C = 'RetentionPrestiti_RetentionOK' group by AccountId];
        }
        for(AggregateResult agg : caseGroup){
         	mapAgg.put((String)agg.get('accountId'),agg);   
        }
        for(Event e : listaApp){
       		OCSRecuperaDatiPostvenditaResponse res = OCSRecuperaDatiPostvenditaInvoker.callRecDatiPV(e.customer__r.getCodice_Cliente__c);
        	boolean createTask = true;
            for(OCSRecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO r : res.pratiche)
            {
                if('PE'.equals(r.prodotto))
                {
                    createTask = false;
                    break;
                }
            }
            if(createTask)
            {
                listRetention.add(
                                            new CRM_Retention__c( 
                                                customer__c  =  e.customer__c,
                                                Branch__c = e.desk__r.branch__c,
                                                type__c = CRMRetentionUtil.RETENTION_TYPE_TO_CREATE,
                                                loanNumber__c = e.Pratica__c
                                                )
                			);
            }
        }
        if(!listRetention.isEmpty()){
            insert listRetention;
        }
        
    }
}