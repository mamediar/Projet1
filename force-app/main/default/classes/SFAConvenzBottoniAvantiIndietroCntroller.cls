public class SFAConvenzBottoniAvantiIndietroCntroller {

    @AuraEnabled
    public static void handleCase(String recordId,String newDispositionExternalId,String newStep, Boolean assignActivity, String queueToAssignCase, String newCategoria, String newOggetto){

        Case c = new Case(Id=recordId);
        c.StepAttivitaConvenzionamento__c = newStep;
        if(!String.isEmpty(newDispositionExternalId)){    
            c=XCS_DispositionUtils.aggiungiDispositionCase(c,newDispositionExternalId);
        }
        
        if(!String.isEmpty(newCategoria)){    
            c.Categoria_Riferimento__r = XCS_CategoriaUtil.getCategoryForExternalId(newCategoria);
            if(newCategoria==XCS_CategoriaUtil.SFA_CONVENZIONAMENTO_GESTIONE_DOSSIER_DEALER){
                c=CaseShareUtil.emptyCaseShare(c);
                c.DataCreazioneDossier__c=datetime.now();
            }
        }  
        
        if(!String.isEmpty(newOggetto)){    
            c.Subject =newOggetto;
        }
        
        if(assignActivity){   
            c =SFAConvenzionamento.utenteLavorazione(c,queueToAssignCase,false,true); 
        }        

        update(c);    
        
    }
    
    @AuraEnabled
    public static SFAConvenzionamento.CategoriaEStepLavorazione getCategoriaEStepLavorazione(String caseId) {
        return SFAConvenzionamento.getCategoriaEStepLavorazione(caseId);	
	}    

}