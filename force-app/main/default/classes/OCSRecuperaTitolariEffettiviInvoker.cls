public class OCSRecuperaTitolariEffettiviInvoker {
    
    public static OCSRecuperaTitolariEffettiviResponse callRecuperaTitolariEffettivi(OCSRecuperaTitolariEffettiviRequest request){
        return (OCSRecuperaTitolariEffettiviResponse)ApiUtils.callApi('ocs.recuperaTitolariEffettivi',request,OCSRecuperaTitolariEffettiviResponse.class);
    }    

    public static OCSRecuperaTitolariEffettiviResponse callRecuperaTitolariEffettivi(String codiceCliente){   //NB: per il processo di convenzionamento codiceCliente sarebbe il codice del dealer
        OCSRecuperaTitolariEffettiviRequest request=new OCSRecuperaTitolariEffettiviRequest();        
		request.recuperaTitolariEffettiviRequest.codCliente = codiceCliente;
        return(callRecuperaTitolariEffettivi(request));
    }
    
    public static DatiChiamataOCS processaResponse(OCSRecuperaTitolariEffettiviResponse response, String dealerId){
        DatiChiamataOCS datiChiamataOCS = new DatiChiamataOCS();
        List<String> titolariOCS= new List<String>(); 
        Integer lastInsert=0;   
        String titolareRecuperatoOCS;        
        datiChiamataOCS.chiamataOK=false;
        datiChiamataOCS.isTitolareTrovatoSuDB=false; 
        datiChiamataOCS.isTitolareTrovatoSuOCS=false; 
        if(response.isOK()){
            datiChiamataOCS.chiamataOK=true;
            if(response.recuperaTitolariEffettiviResponse.elencoTitolari!=null){
                for(OCSRecuperaTitolariEffettiviResponse.ElencoTitolari resElenco:response.recuperaTitolariEffettiviResponse.elencoTitolari){
                    if(!String.isEmpty(resElenco.codAnaSecondaria)){
                        if(resElenco.tipoAnaSecondaria!= null && resElenco.tipoAnaSecondaria.equals('T')){
                            datiChiamataOCS.isTitolareTrovatoSuOCS=true; //lo metto dentro il ciclo e dentro la condizione che l'OCS non sia nullo!
                            if(lastInsert < Integer.valueof(resElenco.dataInserimento.trim())){
                                titolareRecuperatoOCS = resElenco.codAnaSecondaria.trim();
                                lastInsert =Integer.valueof(resElenco.dataInserimento.trim());
                            }
						}                            
                    }                    
                }
                if(!String.IsEmpty(titolareRecuperatoOCS)){
                    List<Contact> titolare=[SELECT id,AccountId, OCS_External_Id__c FROM Contact WHERE OCS_External_Id__c=:titolareRecuperatoOCS];
                    if(titolare.size()>0){  
                        datiChiamataOCS.isTitolareTrovatoSuDB=true;
                        datiChiamataOCS.titolareRecuperato=titolare[0];
                        
                        if(String.isEmpty(titolare[0].AccountId)){   //se il contact recuperato non è associato ad alcun account (AccountId=null), allora lo associo al dealer che sto convenzionando, altrimenti l'AccountContactRelation non può essere creata
                            titolare[0].AccountId=dealerId;  
                            update titolare[0];
                            AccountContactRelation acc_con =[SELECT id, ContactId, AccountId, Roles FROM AccountContactRelation WHERE AccountId=:dealerId AND ContactId=:titolare[0].Id][0]; 
                            acc_con.Roles=SFAConvenzionamento.titolareEffettivo;
                            update acc_con;                            
                        } else if(titolare[0].AccountId==dealerId){
                            AccountContactRelation acc_con =[SELECT id, ContactId, AccountId, Roles FROM AccountContactRelation WHERE AccountId=:dealerId AND ContactId=:titolare[0].Id][0]; 
                            acc_con.Roles=SFAConvenzionamento.titolareEffettivo;
                            update acc_con;
                        } else {
                          	AccountContactRelation acc_con = new AccountContactRelation();
                            acc_con.ContactId=titolare[0].Id;
                            acc_con.AccountId=dealerId;
                            acc_con.Roles=SFAConvenzionamento.titolareEffettivo;
                            insert acc_con;                             
                        }
                       
                    }                    
                }
            }
            System.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@òtitolareRecuperatoOCS:: '+titolareRecuperatoOCS);
        } else {
            datiChiamataOCS.message=response.resultMessage;
        }
        System.debug('datiChiamataOCS:: '+datiChiamataOCS);
        return datiChiamataOCS;
    }
    
    public class DatiChiamataOCS {
        @AuraEnabled public Boolean chiamataOK {get; set;}
        @AuraEnabled public Boolean isTitolareTrovatoSuOCS {get;set;}   //su OCS è stato trovato il titolare
        @AuraEnabled public Boolean isTitolareTrovatoSuDB {get;set;}    //il titolare recuperato da OCS potrebbe non essere presente sul CRM (è una probabilità mooolto bassa ma lo speculiamo comunque)
        @AuraEnabled public Contact titolareRecuperato {get;set;}    //contiene i dati del titolare recuperato da oCS e trovato nel CRM
        @AuraEnabled public String message {get;set;}
    }
    
   
}