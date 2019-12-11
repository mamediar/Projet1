public class JobGestioneEmailFaxController {
    
    //Può esistere solo una schedulazione per nome: per schedulare più Job dello stesso processo, aggiungere un indice alla fine della stringa "jobPrefix"
    private static final String jobPrefix = 'FaxEmailJob'; 
        
    @AuraEnabled
    public static void lanciaJobsApex(){
        
        Set<String> jobName = new Set<String>();
        Set<Id> jobsIds = new Set<Id>();
        
        for(Integer i = 0; i < 12; i++){
            jobName.add(jobPrefix+i);
        }
                       
        for(CronJobDetail cjb : [SELECT Id, Name, JobType FROM CronJobDetail where name in: jobName])                   
            jobsIds.add(cjb.id);
        
        for(CronTrigger ctr : [SELECT Id FROM CronTrigger where CronJobDetailId in:jobsIds])
            System.abortJob(ctr.id);
                        
        ScheduledRouting s = new ScheduledRouting();
        for(Integer i = 0; i<12;i++)
            System.schedule(jobPrefix + i, '0 ' + i*5 + ' * * * ?', s);
                
    }
    
    @AuraEnabled
    public static void lanciaAlgoritmoApex(){
       RoutingEmailFaxUtils.avviaAlgoritmo();
        
    }
    
}