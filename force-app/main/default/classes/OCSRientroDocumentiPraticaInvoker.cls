public class OCSRientroDocumentiPraticaInvoker {
    private static final String R='R';
    private static final String M='M';
    
    
    public static OCSRientroDocumentiPraticaResponse cambioStatoDocumento(OCSRientroDocumentiPraticaRequest request){
        return (OCSRientroDocumentiPraticaResponse)APIUtils.callApi
            ('ocs.modificaStatoDocumento', request, OCSRientroDocumentiPraticaResponse.class);
    }
    
    public static ContractResult cambioStatoDocumenti(Contract c){
        List<Documento__c> docs=[	select Id,CodiceDocumento__c,SituazioneDocumento__c
                                	from Documento__c
                                	where Contract__c=:c.Id and SituazioneDocumento__c!=:M];
        List<DocumentResult> dList=null;
        for(Documento__c d:docs){
            OCSRientroDocumentiPraticaRequest tempReq=new OCSRientroDocumentiPraticaRequest();
            tempReq.procedura=c.Procedure__c;
            tempReq.numPratica=c.ContractNumber__c;
            tempReq.codDocumento=d.CodiceDocumento__c;
            tempReq.situazioneDocumento=R;
              
            DocumentResult tempRes=new DocumentResult();
            tempRes.response=cambioStatoDocumento(tempReq);
            tempRes.codiceDocumento=d.CodiceDocumento__c;
            
            if(dList==null)
            {
                dList=new List<DocumentResult>();
            }
			dList.add(tempRes);
        }
        ContractResult res=new ContractResult();
        res.contract=c;
        res.setDocResult(dList);
        return res;
    }
    
    public static List<ContractResult> cambioStatoDocumenti(List<Contract> cList){
        List<ContractResult> res=null;
        for(Integer i=0;i<cList.size();i++){
            ContractResult temp=cambioStatoDocumenti(cList.get(i));
            if(res==null){
                res=new List<ContractResult>();
            }
            res.add(temp);
        }
        return res;
    }
}