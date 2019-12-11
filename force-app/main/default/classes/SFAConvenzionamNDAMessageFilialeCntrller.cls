public class SFAConvenzionamNDAMessageFilialeCntrller {
    
    @AuraEnabled
    public static String getMessage(String caseId ) {
        
		String message;
		Case caseAttivita = 
			[SELECT Id, AccountId, Disposition__c, OCSExternalFilialeConvenzionato__c, OwnerId, StepAttivitaConvenzionamento__c  
			FROM Case 
			WHERE Id = :caseId][0];

        
        
        XCS_Disposition__c disposition = [SELECT Id, Name, External_Id__c FROM XCS_Disposition__c WHERE Id = :caseAttivita.Disposition__c][0]; 
        
        List<SFA_ConvenzionamentoMessaggioAttivita__mdt> lstMessage = [SELECT Id, Message__c, ProfileName__c, Disposition__c FROM SFA_ConvenzionamentoMessaggioAttivita__mdt WHERE ProfileName__c='Branch Employee' AND Disposition__c=:disposition.External_Id__c];
        
        if(lstMessage.size()==1){
            message=lstMessage[0].Message__c;
        } else {
            if (caseAttivita.StepAttivitaConvenzionamento__c==SFAConvenzionamento.NDA_CompletaInfoEControlli2) {
                message='Il convenzionamento deve essere valutato dall\'ufficio DCR/AV. Inserire eventuali note e allegati.';
            } else {
                message='Il convenzionamento deve essere valutato dall\'ufficio DCR/AV.';    //ricado nella schermata in cui la filiale può solo ANNULLARE l'attività aspettandpo una risposta da AV. Questo messaggio viene visualizzato solo nel caso in cui non trova nessuna disposition/message , e per ora la troverà solo nel caso .
            }
            	
        }
		return message;
		
	}    
    
    
}