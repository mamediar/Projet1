public class SFAConvenz_NDA_VisualizTitolareCtroller {

    @AuraEnabled
    public static Id getTitolareId(String caseId) {  
        return SFAConvenzionamento.getTitolareId(SFAConvenzionamento.getDealer(caseId).Id);		
	}
    
    @AuraEnabled
    public static SFAConvenzionamento.CategoriaEStepLavorazione getCategoriaEStepLavorazione(String caseId) {
        return SFAConvenzionamento.getCategoriaEStepLavorazione(caseId);	
	}    
    
	@AuraEnabled
    public static void valutaNextStepLavorazione(String caseId) {
        Account dealer= SFAConvenzionamento.getDealer(caseId);
        Case caseAttivita = new Case(Id=caseId);
        if(dealer.Tipo_Intermediario__c=='SA'){
            caseAttivita.StepAttivitaConvenzionamento__c=SFAConvenzionamento.GDD_DocumentiObbligatori;   
            caseAttivita.ActivityType__c=CaseUtils.SFA_GESTIONE_DOSSIER_DEALER;   //new activity di Gestione Dossier 
            caseAttivita.Categoria_Riferimento__r = XCS_CategoriaUtil.getCategoryForExternalId(XCS_CategoriaUtil.SFA_CONVENZIONAMENTO_GESTIONE_DOSSIER_DEALER);
        	caseAttivita.Subject=CaseUtils.SFA_SUBJECT_GESTIONE_DOSSIER;
            caseAttivita=CaseShareUtil.emptyCaseShare(caseAttivita);
            caseAttivita.DataCreazioneDossier__c=datetime.now();
        } else {
			caseAttivita.StepAttivitaConvenzionamento__c=SFAConvenzionamento.NDA_VerificaAnagraficaECollegatiIBAN;
		}
		update caseAttivita;        
	}    

    
}