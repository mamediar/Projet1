public class SFAConvenz_NDA_MetodoAccreditoCtroller {
    
    @AuraEnabled
    public static SFAConvenzionamento.Dati getCCDati(String caseId) {  
        return SFAConvenzionamento.getCCDati(caseId);		
	}    
        
    @AuraEnabled
    public static void eliminaCC(String CCSelezionatoId) {    
        XCS_CCAccredito__c CC = [SELECT Id, IsEliminato__c FROM XCS_CCAccredito__c WHERE id=:CCSelezionatoId][0];
        CC.IsEliminato__c=true;
        update CC;
	}
    
    @AuraEnabled
    public static OCSCensimentoCCConvenzionatoInvoker.DatiChiamataOCS inserisciAggiornaCCSuOCS(String CCSelezionatoId, String dealerId) {    
        return OCSCensimentoCCConvenzionatoInvoker.callCensimentoCCConvenzionato(CCSelezionatoId,dealerId);
	}    
    
    @AuraEnabled
    public static DatiSalvataggio controllaSeSalvareDatiAggPossibile(String caseId, String dealerId, String PagamentoTerzi, Integer TerzoDaLiquidare, String ErogatoMese, String VolumeAffari) {  
        DatiSalvataggio datiSalvataggio = new DatiSalvataggio();
        datiSalvataggio.erroreSalvataggio=false;
        datiSalvataggio.chiamataOK_OCS=true;
        datiSalvataggio.messaggio.add('Verificare i seguenti errori:');
        if(PagamentoTerzi=='S' && TerzoDaLiquidare==0){
            datiSalvataggio.erroreSalvataggio=true;
            datiSalvataggio.messaggio.add('- Terzo da Liquidare: dato obbligatorio con flag di Pagamento a Terzi impostato a S');
        }
        List<XCS_CCAccredito__c> ccList =[SELECT Id, Name, ABI__c, CAB__c, IBAN__c, Descrizione__c, Erogazione_RVD_CO__c, AccountId__c FROM XCS_CCAccredito__c WHERE AccountId__c=:dealerId];
        if(ccList.size()==0){  //recupera iban e vedere se ce n'è almeno una per 	quel dealer (master detail relation).
            datiSalvataggio.erroreSalvataggio=true;
            datiSalvataggio.messaggio.add('- Inserire dati di conto corrente');
        }
        if(String.isEmpty(ErogatoMese)){
            datiSalvataggio.erroreSalvataggio=true;
            datiSalvataggio.messaggio.add('- Erogato Mese: obbligatorio');            
        }
        if(String.isEmpty(VolumeAffari)){
            datiSalvataggio.erroreSalvataggio=true;
            datiSalvataggio.messaggio.add('- Volume Affari: obbligatorio');            
        }

        if(!datiSalvataggio.erroreSalvataggio){
            OCSCensimDatiAggConvenzionatoResponse response = OCSCensimDatiAggConvenzionatoInvoker.callCensimentoDatiAggConvenzionato(dealerId);
            OCSCensimDatiAggConvenzionatoInvoker.DatiChiamataOCS datiChiamataOCS= OCSCensimDatiAggConvenzionatoInvoker.processaResponse(response);
            if(!datiChiamataOCS.chiamataOK){
                datiSalvataggio.chiamataOK_OCS=false;
                datiSalvataggio.message_OCS=datiChiamataOCS.message;
            }            
        }        
        
        return datiSalvataggio;  
	}
    
 	public class DatiSalvataggio {
        @AuraEnabled
        public Boolean erroreSalvataggio {get; set;}
        @AuraEnabled
        public List<String> messaggio {get { if (messaggio == null ) messaggio = new List<String>(); return messaggio; } set;}  
        @AuraEnabled
        public Boolean chiamataOK_OCS {get; set;}    
        @AuraEnabled
        public String message_OCS {get; set;}         
    }     
    
}