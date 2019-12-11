public abstract class XCSReclamiInput implements XCSReclamiInputInterface{
	@AuraEnabled
    public XCSReclamiDettagliOutputDTO dettagliOutputObj;
    @AuraEnabled
    public OCSCliente clienteSelezionatoContainer;
    @AuraEnabled
    public OCSPratica praticaSelezionataContainer; // da eliminare se non va bene
    @AuraEnabled
    public List<XCS_Mittente__c> mittentiList;
    @AuraEnabled
    public List<Attachment> fileList;   
    @AuraEnabled
    public String isSconosciuto;

}