public class OCSRecuperaDatiPostvenditaController {
    @AuraEnabled
    public static Map<String,List<Object>> getClienti(Map<String,String> data, String nameProcess){
        Map<String,List<Object>> res=new Map<String,List<Object>>();
        System.debug('OCSRecuperaDatiPostvenditaInvoker.callRecDatiPV: ' +data);
        List<OCSCliente> clientiList=OCSObjectsFactory.makeClienti(OCSRecuperaDatiPostvenditaInvoker.callRecDatiPV(data));
        List<Account> accList=new List<Account>();
        if(clientiList.size()>1){
            for(OCSCliente c:clientiList){ 
                accList.add(makeAccount(c));
            }  
        }
        else if(clientiList.size()==1){ 
           accList.add(getCliente(makeAccount(clientiList[0]), '').account);
        }
       /* if(nameProcess != null && nameProcess.equalsIgnoreCase('Reclami')){
            for(Integer i=0; i<clientiList.size();){
                if(clientiList[i].pratiche.size() == 0){
                    clientiList.remove(i);
                    accList.remove(i);
                }
                else i++;
            }
        }*/
        
        res.put('clienti',clientiList);
        res.put('accounts',accList);
        return res;
    }
    
    @AuraEnabled
    public static SelectClienteResponse getCliente(Account acc, String tipoPratica ){
        System.debug('OCSRecuperaDatiPostvenditaController getCliente acc code: '+acc.OCS_External_Id__c);
        SelectClienteResponse res=new SelectClienteResponse();
        res.pratiche=OCSObjectsFactory.makePratiche(OCSRecuperaDatiPostvenditaInvoker.callRecDatiPV(acc.OCS_External_Id__c.substring(1), tipoPratica ).pratiche);
        res.account=AccountUtils.upsertAccount(acc,'Compass');
        System.debug('OCSRecuperaDatiPostvenditaController getCliente res.pratiche: '+res.pratiche);
        return res;
    }
     @AuraEnabled
    public static SelectClienteResponse getCliente(Account acc, String tipoPratica, string InfoCli ){
        System.debug('OCSRecuperaDatiPostvenditaController callRecDatiCoobligati acc code: '+acc.OCS_External_Id__c);
        SelectClienteResponse res=new SelectClienteResponse();
        res.pratiche=OCSObjectsFactory.makePratiche(OCSRecuperaDatiPostvenditaInvoker.callRecDatiCoobligati(acc.OCS_External_Id__c.substring(1), tipoPratica,InfoCli ).pratiche);
        res.account=AccountUtils.upsertAccount(acc,'Compass');
        System.debug('OCSRecuperaDatiPostvenditaController callRecDatiCoobligati res.pratiche: '+res.pratiche);
        return res;
    } 

    @AuraEnabled
    public static SelectClienteResponse getClienteOCS(OCSCliente acc){
        System.debug('OCSRecuperaDatiPostvenditaController getClienteOCS acc code: '+acc.codCliente);
        SelectClienteResponse res=new SelectClienteResponse();
        //res.pratiche=OCSObjectsFactory.makePratiche(OCSRecuperaDatiPostvenditaInvoker.callRecDatiPV(acc.OCS_External_Id__c.substring(1)).pratiche);
        //res.account=AccountUtils.upsertAccount(acc,'Compass');
        System.debug('OCSRecuperaDatiPostvenditaController getCliente res.pratiche: '+res.pratiche);
        return res;
    } 
    
    @AuraEnabled
    public static List<OCSPratica> filtraPratiche(String pratiche,String filtroClass){
        OCSRecuperaDatiPVFiltroPraticheInterface filtro = (OCSRecuperaDatiPVFiltroPraticheInterface)Type.forName(filtroClass).newInstance();
        System.debug('OCSRecuperaDatiPostvenditaController filtraPratiche filtro: '+filtro);
        List<OCSPratica> res=filtro.filtraPratiche((List<OCSPratica>)JSON.deserialize(pratiche,List<OCSPratica>.class)); 
        System.debug('OCSRecuperaDatiPostvenditaController filtraPratiche res: '+res);
        return res;
    } 
    
    @TestVisible
    private static Account makeAccount(OCSCliente cm){
        return AccountUtils.makeAccount(cm,'Compass');
    }
    
    @AuraEnabled
    public static String getInputAccountOCSId(String accountId){
        List<Account> l=[select getCodice_Cliente__c from Account where Id=:accountId];
        return l.size()>0?l[0].getCodice_Cliente__c:'';
    }
    
    public class SelectClienteResponse{
        @AuraEnabled
        public Account account {get;set;}
        @AuraEnabled
        public List<OCSPratica> pratiche {get;set;}
    }
}