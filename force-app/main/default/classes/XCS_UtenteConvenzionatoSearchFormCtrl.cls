public class XCS_UtenteConvenzionatoSearchFormCtrl {
    
    private static final String dueParametriMancanti = 'Inserire un parametro di ricerca';
    private static final String dueParametriInsieme = 'Inserire un solo parametro di ricerca';
    private static final String utenzaOIntermediarioNonTrovato = 'Nessuna utenza trovata o nessun intermediario trovato';
    
    @AuraEnabled
    public static Map<String,String> getToastMessage(){
        Map<String,String> messaggi = new Map<String,String>();
        messaggi.put('dueParametriMancanti',dueParametriMancanti);
        messaggi.put('dueParametriInsieme',dueParametriInsieme);
        messaggi.put('utenzaOIntermediarioNonTrovato',utenzaOIntermediarioNonTrovato);
        
        return messaggi;
    }
        
    @AuraEnabled
    public static List<RecuperaUtenzeIntermediarioInvoker.UtenzaIntermediarioDTO> callOCS(String codIntermediario, String utenza){
        
        // creo la request
        RecuperaUtenzeIntermediarioInvoker.Request req = new RecuperaUtenzeIntermediarioInvoker.Request();
        req.recuperaUtenzeIntermediarioRequest.codiceIntermediario = codIntermediario;    
        req.recuperaUtenzeIntermediarioRequest.codiceUtenza = utenza; 
        
        //istanzio la response e invoco il servizio
        RecuperaUtenzeIntermediarioInvoker.Response resp = new RecuperaUtenzeIntermediarioInvoker.Response();            
        resp = RecuperaUtenzeIntermediarioInvoker.invoke(req.recuperaUtenzeIntermediarioRequest);
        
        
        List<RecuperaUtenzeIntermediarioInvoker.UtenzaIntermediarioDTO> utenti = new List<RecuperaUtenzeIntermediarioInvoker.UtenzaIntermediarioDTO>();
        //devo evitare il null point exeption.. la response non è mai vuota (resultCode, ecc..), ma ciò che io considero per verificare
        // se una response è "vuota" è la lista utenti
        
        if( resp.recuperaUtenzeIntermediarioResponse != null)
            utenti = resp.recuperaUtenzeIntermediarioResponse.utenze;
        
        
        //Map<String,RecuperaUtenzeIntermediarioInvoker.UtenzaIntermediarioDTO> matchOCS = new Map<String,RecuperaUtenzeIntermediarioInvoker.UtenzaIntermediarioDTO>();
        Set<String> matchOcs = new Set<String>();
        
        for(RecuperaUtenzeIntermediarioInvoker.UtenzaIntermediarioDTO  u : utenti){
            matchOCS.add(u.codiceIntermediario);
            u.profiloAri = setProfiloAri(u.flagAuth);
        }
        
        //in realtà mi basta questa come condizione per distinguere l input della request, e lo faccio per evitare chiamate al db inutili
        if(''.equalsIgnoreCase(codIntermediario)){
            
            List<Account> acc = [Select id, Branch__r.Name, Tipo_intermediario__c, Status__c, Partita_IVA__c, OCS_External_Id__c 
                                 from Account 
                                 where OCS_External_Id__c in: matchOCS];
                        
            for(RecuperaUtenzeIntermediarioInvoker.UtenzaIntermediarioDTO  u : utenti){                
                for(Account a : acc){
                    if(u.codiceIntermediario == a.OCS_External_Id__c){
                        u.partitaIva = a.Partita_IVA__c;
                        u.filiale = a.Branch__r.Name;
                        u.tipo = a.Tipo_intermediario__c;
                        u.statoDealer = a.Status__c;                        
                    }
                }
            }            
        }
        return utenti;        
    }    
    
    private static String setProfiloAri(String flag){
        
        if(flag == null || ''.equalsIgnoreCase(flag) || ' '.equalsIgnoreCase(flag))
            return flag;                
        else if('B'.equalsIgnoreCase(flag.substring(1,2)))
            return 'Basic';
        else if('M'.equalsIgnoreCase(flag.substring(1,2)))
            return 'Master';
        else
            return '';        
    }
    
}