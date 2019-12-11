public with sharing class SFAUtenzeNominativePDFController {
 
 
    public String idCase {get;set;}
   
    public List<Comunicazione_Utenze__c> utenzeNominaliList {get;set;}

    public SFAUtenzeNominativePDFController(ApexPages.StandardController std){
        this.idCase =ApexPages.currentPage().getParameters().get('IdCase');
        System.debug('idCase:'+this.idCase);
    }

    public void init(){
        // la query DEVE essere la stessa del controller del componente
        this.utenzeNominaliList = SFAComunicazioneUtenzeController.listUtenzeNominative(this.idCase);
    }

}