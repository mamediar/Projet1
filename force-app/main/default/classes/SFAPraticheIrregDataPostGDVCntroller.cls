public class SFAPraticheIrregDataPostGDVCntroller {
  @AuraEnabled
  public static Date recuperaDataPosticipoRichiestaDaFiliale(String praticaId) {
	Boolean disabilita=true;      
    SFA_PraticaIrregolare__c pratica=[SELECT Id,DataPosticipoRichiestadaFiliale__c FROM SFA_PraticaIrregolare__c WHERE Id = :praticaId];
    Date dataPosticipoRichiestadaFiliale=pratica.DataPosticipoRichiestadaFiliale__c;
     
    return dataPosticipoRichiestadaFiliale;
      
  }
    
  @AuraEnabled
  public static void salvaDataPosticipo(String praticaId, String dataPosticipoDaSalvareString) {
    Date dataPosticipoDaSalvare = Date.valueOf(dataPosticipoDaSalvareString);
    SFA_PraticaIrregolare__c pratica=[SELECT Id,DataPosticipo__c FROM SFA_PraticaIrregolare__c WHERE Id = :praticaId];      
    pratica.DataPosticipo__c=dataPosticipoDaSalvare; 
    update pratica;
      
  }      
    
    
}