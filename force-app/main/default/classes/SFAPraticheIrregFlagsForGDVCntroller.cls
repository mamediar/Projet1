public class SFAPraticheIrregFlagsForGDVCntroller {

     
  @AuraEnabled
  public static void checkFlagImportante(String praticaId) {

    SFA_PraticaIrregolare__c pratica=[SELECT Id,FlagImportante__c FROM SFA_PraticaIrregolare__c WHERE Id = :praticaId];
    pratica.FlagImportante__c=True;
    update pratica;
      
  }  
    
  @AuraEnabled
  public static void uncheckFlagImportante(String praticaId) {

    SFA_PraticaIrregolare__c pratica=[SELECT Id,FlagImportante__c FROM SFA_PraticaIrregolare__c WHERE Id = :praticaId];
    pratica.FlagImportante__c=False;
    update pratica;
      
  }
    
  @AuraEnabled
  public static void checkFlagSosp(String praticaId) {

    SFA_PraticaIrregolare__c pratica=[SELECT Id,FlagSospensioneAttivitaTemporaneaGDV__c FROM SFA_PraticaIrregolare__c WHERE Id = :praticaId];
    pratica.FlagSospensioneAttivitaTemporaneaGDV__c=True; 
    update pratica;
  }
    
  @AuraEnabled
  public static void uncheckFlagSosp(String praticaId) {

    SFA_PraticaIrregolare__c pratica=[SELECT Id,FlagSospensioneAttivitaTemporaneaGDV__c FROM SFA_PraticaIrregolare__c WHERE Id = :praticaId];
    pratica.FlagSospensioneAttivitaTemporaneaGDV__c=False; 
    update pratica;
  }    
    
	@AuraEnabled
	public static FlagToReturn getFlags(String praticaId) {
    	SFA_PraticaIrregolare__c pratica=[SELECT Id,FlagTargaTelaioDiversi__c,FlagModuloInterazioneVeicoliMI__c,FlagImportante__c,FlagSospensioneAttivitaTemporaneaGDV__c FROM SFA_PraticaIrregolare__c WHERE Id = :praticaId][0];
		FlagToReturn flagToReturn = new FlagToReturn();
		flagToReturn.flagTargaTelaioDiversi = pratica.FlagTargaTelaioDiversi__c;
		flagToReturn.flagModuloInterazioneVeicoliMI = pratica.FlagModuloInterazioneVeicoliMI__c;
        flagToReturn.flagImportante = pratica.FlagImportante__c;
        flagToReturn.flagSospensioneAttivitaTemporaneaGDV = pratica.FlagSospensioneAttivitaTemporaneaGDV__c;
		return flagToReturn;
	}
    
    public class FlagToReturn {
        @AuraEnabled
        public Boolean flagTargaTelaioDiversi {get; set;}
        @AuraEnabled
        public Boolean flagModuloInterazioneVeicoliMI {get; set;}
        @AuraEnabled
        public Boolean flagImportante {get; set;}
        @AuraEnabled
        public Boolean flagSospensioneAttivitaTemporaneaGDV {get; set;}        
    }  

}