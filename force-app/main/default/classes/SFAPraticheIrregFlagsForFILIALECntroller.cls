public class SFAPraticheIrregFlagsForFILIALECntroller {

     
  @AuraEnabled
  public static void checkFlagTargaTelaio(String praticaId) {

    SFA_PraticaIrregolare__c pratica=[SELECT Id,FlagTargaTelaioDiversi__c FROM SFA_PraticaIrregolare__c WHERE Id = :praticaId];
    pratica.FlagTargaTelaioDiversi__c=True;
    update pratica;
      
  }  
    
  @AuraEnabled
  public static void uncheckFlagTargaTelaio(String praticaId) {

    SFA_PraticaIrregolare__c pratica=[SELECT Id,FlagTargaTelaioDiversi__c FROM SFA_PraticaIrregolare__c WHERE Id = :praticaId];
    pratica.FlagTargaTelaioDiversi__c=False;
    update pratica;
      
  }
    
  @AuraEnabled
  public static void checkFlagModuloInterazione(String praticaId) {

    SFA_PraticaIrregolare__c pratica=[SELECT Id,FlagModuloInterazioneVeicoliMI__c FROM SFA_PraticaIrregolare__c WHERE Id = :praticaId];
    pratica.FlagModuloInterazioneVeicoliMI__c=True; 
    update pratica;
  }
    
  @AuraEnabled
  public static void uncheckFlagModuloInterazione(String praticaId) {

    SFA_PraticaIrregolare__c pratica=[SELECT Id,FlagModuloInterazioneVeicoliMI__c FROM SFA_PraticaIrregolare__c WHERE Id = :praticaId];
    pratica.FlagModuloInterazioneVeicoliMI__c=False; 
    update pratica;
  }    
    
	@AuraEnabled
	public static FlagToReturn getFlags(String praticaId) {
        Date today=Date.today();        
    	SFA_PraticaIrregolare__c pratica=[SELECT Id,FlagTargaTelaioDiversi__c,FlagModuloInterazioneVeicoliMI__c,DataTermineLavoro__c,Status__c,RiscontroFinale__c FROM SFA_PraticaIrregolare__c WHERE Id = :praticaId][0];
		FlagToReturn flagToReturn = new FlagToReturn();
        flagToReturn.disabilitaFlags=true;
		flagToReturn.flagTargaTelaioDiversi = pratica.FlagTargaTelaioDiversi__c;
		flagToReturn.flagModuloInterazioneVeicoliMI = pratica.FlagModuloInterazioneVeicoliMI__c;
        if (today<pratica.DataTermineLavoro__c){
            flagToReturn.setFlags=true;            
        } else {
            flagToReturn.setFlags=false;      
        }

		System.debug('disabilita::'+flagToReturn.disabilitaFlags);
    	if ((((pratica.Status__c == 'Pratica - da Gestire' || pratica.Status__c == 'Pratica - Richiesta Maggiori Informazioni')&& pratica.RiscontroFinale__c!='RIC') || pratica.RiscontroFinale__c=='INF' || pratica.RiscontroFinale__c=='POS') && today<pratica.DataTermineLavoro__c) {
        	flagToReturn.disabilitaFlags=false;
            System.debug('qui::'+flagToReturn.disabilitaFlags);    
            
        }    
        System.debug('disabilita2::'+flagToReturn.disabilitaFlags);    
            
		return flagToReturn;
	}
    
    public class FlagToReturn {
        @AuraEnabled
        public Boolean flagTargaTelaioDiversi {get; set;}
        @AuraEnabled
        public Boolean flagModuloInterazioneVeicoliMI {get; set;}
        @AuraEnabled
        public Boolean setFlags {get; set;}
        @AuraEnabled
        public Boolean disabilitaFlags {get; set;}        
       
    }  

}