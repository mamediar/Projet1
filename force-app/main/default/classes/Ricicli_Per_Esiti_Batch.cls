/**
* @Author Madicke Balde
* @Modified by Abdoulaye DIOP 11/10/2019
* @date  10/10/2019
**/
global  class Ricicli_Per_Esiti_Batch implements Database.Batchable<sObject>, Database.Stateful {
    public String query;
    public Set<Id> idsCase;
    public String developerNameQueue;
    public Integer numeroRecicli;
    public Integer numeroDiOreLavoro;
    
    /**
     * @Author Madicke Balde
     * @date  10/10/2019
     **/
    public Ricicli_Per_Esiti_Batch(Set<Id> idsCase, String developerNameQueue, Integer numeroRecicli, Integer numeroDiOreLavoro){
      this.idsCase = idsCase;
      this.developerNameQueue = developerNameQueue;
      this.numeroRecicli = numeroRecicli;
      this.numeroDiOreLavoro =  numeroDiOreLavoro;
      query =' SELECT Id, Tentativo__c, LastModifiedDate FROM Case WHERE Id IN : idsCase';
    }

    /**
     * @Author Madicke Balde
     * @date  10/10/2019
     **/
    global Database.QueryLocator start(Database.BatchableContext ctx){
       return Database.getQueryLocator(query);
    }
    
    /**
     * @Author Abdoulaye DIOP
     * @date  11/10/2019
     **/
    global void execute(Database.BatchableContext ctx, List<Case> cases){
        List<Case> caseToUpdates = new List<Case>();
        if(cases.size() > 0) {
            for(Case c : cases) {
                Datetime dateNow = System.now();
                integer intDays =  c.LastModifiedDate.Date().daysBetween(dateNow.Date());
                datetime sameDayEndDate = c.LastModifiedDate.addDays(intDays);
                decimal decHours = ((dateNow.getTime())/1000/60/60) - ((sameDayEndDate.getTime())/1000/60/60);
                System.debug('### decHours '+ decHours);

                if (c.Tentativo__c  <= this.numeroRecicli &&  decHours >= this.numeroDiOreLavoro ) {
                    caseToUpdates.add(c);
                }
            }
            if (caseToUpdates.size() > 0) {
                System.debug('#l caseToUpdates ### '+ JSON.serialize(caseToUpdates));                
                updateCase(developerNameQueue, caseToUpdates);
            }
        }
    }

    /**
     * @Author Madicke Balde
     * @date  10/10/2019
     **/
    global void finish(Database.BatchableContext bc){
        System.debug('######################### finish ');
    }

    /**
     * @Author Madicke Balde
     * @Modified by Abdoulaye DIOP 11/10/2019
     * @date  10/10/2019
     **/
    public static void updateCase (String developName, List<Case> caseToUpdate){
       Group gr = CaseService.getQueue(developName);
       for(Case c : caseToUpdate){
           c.OwnerId = gr.Id;
       }
       Recursion.isTriggerExecuting = true;
       update caseToUpdate;
       System.debug('################" case updated '+ caseToUpdate);
    }
}