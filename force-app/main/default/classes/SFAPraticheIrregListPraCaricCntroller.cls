public class SFAPraticheIrregListPraCaricCntroller {

    @AuraEnabled
    public static List<SFA_PraticaIrregolare__c> getAllPratiche(Id recordId)
        {   
           /*List<SFA_PraticaIrregolare__c> CDLs = [SELECT Name,EsitoCaricamento__c,DataMandatoLiquidazione__c,Targa__c,NoteAgenziaItalia__c,
                                              RiscontroFinale__c,DataTermineLavoro__c,DataPosticipo__c,Status__c,
                                              NumeroAllegati__c,FlagTargaTelaioDiversi__c,FlagModuloInterazioneVeicoliMI__c,StatusSemaforoImage__c 
                                              FROM SFA_PraticaIrregolare__c WHERE IdElaborazione__c = :recordId AND EsitoCaricamento__c=:'Pratica caricata'];*/
           /*List<SFA_PraticaIrregolare__c> CDLs = [SELECT Name, EsitoCaricamento__c
                                              FROM SFA_PraticaIrregolare__c WHERE IdElaborazione__c = :recordId AND EsitoCaricamento__c=:'Pratica caricata'];*/
		   List<Case> caseFigli = [SELECT Id FROM Case WHERE ParentId = :recordId];  
           Set<Id> caseFigliParentId=new Set<Id>();
           for(Case caseFiglio:caseFigli){
                caseFigliParentId.add(caseFiglio.Id);               
           }
		   List<SFA_PraticaIrregolare__c> CDLs = [SELECT Name, EsitoCaricamento__c
                                              FROM SFA_PraticaIrregolare__c WHERE ActivityId__c IN :caseFigliParentId AND EsitoCaricamento__c=:'Pratica caricata'];            
           return CDLs;
        }        
    
}