/**
 * ***********************************************************************************
 *     * @author abdoulaye.diopdev3@compass.com.dev
 *     * @date  11/10/2019
 *     * @description Wizard Schedulable for the batch Ricicli_Per_Esiti_Batch
 * ************************************************************************************
 **/
global with sharing class RicicliPerEsitiSchedulable implements Schedulable {
    public Set<Id> idsCase;
    public String developerName;
    public Integer numeroReciicli;
    public Integer numeroDiOre;

    /**
     * @Author Abdoulaye DIOP
     * @date  12/10/2019
     **/
    public RicicliPerEsitiSchedulable(Set<Id> idsCase, String developerName, Integer numeroReciicli, Integer numeroDiOre){
        this.idsCase = idsCase;
        this.developerName = developerName;
        this.numeroReciicli = numeroReciicli;
        this.numeroDiOre = numeroDiOre;
    }

    /**
     * @Author Abdoulaye DIOP
     * @date  11/10/2019
     **/
    global void execute(SchedulableContext ctx) {
        Ricicli_Per_Esiti_Batch rpeBatch = new Ricicli_Per_Esiti_Batch(idsCase,  developerName, numeroReciicli, numeroDiOre);
        Id batchId = Database.executeBatch(rpeBatch, 100);
        System.debug('#l batchId ### '+ batchId);
    }
}