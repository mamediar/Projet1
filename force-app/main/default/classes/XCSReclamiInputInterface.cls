public interface XCSReclamiInputInterface{
	Object getPratica();
    List<Map<String,String>> getPacchettiAssicurativi(); 
    OCSCliente getCliente();
    XCSReclamiDettagliOutputDTO getDettagliOutput();
    List<XCS_Mittente__c> getMittenti();
    List<Attachment> getFiles();
    Boolean isSconosciuto(); 

}