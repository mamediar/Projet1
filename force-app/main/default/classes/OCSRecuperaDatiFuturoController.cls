public class OCSRecuperaDatiFuturoController {
    @AuraEnabled
    public static Map<String,List<Object>> getClienti(Map<String, String> data, String nameProcess){
        Map<String,List<Object>> res = new Map<String,List<Object>>();
        List<OCSCliente> clientiList = OCSObjectsFactory.makeClienti(OCSRecuperaDatiFuturoInvoker.callRecDatiFuturo(data));
        List<Account_Futuro_MBCS__c> accList = new List<Account_Futuro_MBCS__c>();
        system.debug('Futuro_clientiList: '+clientiList);
        if(clientiList.size() > 1){
          //  system.debug('Futuro_clientiList_1');
            for(OCSCliente c:clientiList){ 
         //       system.debug('Futuro_clientiList_2');
                accList.add(makeAccount(c));
            }  
        }
        else if(clientiList.size() == 1){ 
        //    system.debug('Futuro_clientiList_3');
           accList.add(getCliente(makeAccount(clientiList[0])));
        }
        
    /*     if(nameProcess != null && nameProcess.equalsIgnoreCase('Reclami')){ 
            for(Integer i=0; i<clientiList.size();){
                system.debug('OCSRecuperaDatiFuturoController'+ clientiList);
                system.debug(clientiList);
                if(clientiList[i].praticheFuturo.size() == 0){
                     system.debug('OCSRecuperaDatiFuturoController - Rimosso');
                    clientiList.remove(i);
                    accList.remove(i);
                }
                else i++;
            }
        }*/
        
        res.put('clienti', clientiList);
        res.put('accounts', accList);
        return res;
    }
    
    @AuraEnabled
    public static Account_Futuro_MBCS__c getCliente(Account_Futuro_MBCS__c acc){
        system.debug('OCSRecuperaDatiFuturoController - getCliente');
        return AccountUtilsFuturoMBCS.upsertAccount(acc, 'Futuro');
    }
    
   /* @AuraEnabled //Modificare il tipo di ritorno, dovrebbe essere OCSPraticaFuturo...
    public static List<OCSPratica> filtraPratiche(String pratiche,String filtroClass){
        OCSRecuperaDatiPVFiltroPraticheInterface filtro = (OCSRecuperaDatiPVFiltroPraticheInterface)Type.forName(filtroClass).newInstance();
        System.debug('OCSRecuperaDatiPostvenditaController filtraPratiche filtro: ' + filtro);
        List<OCSPratica> res = filtro.filtraPratiche((List<OCSPratica>)JSON.deserialize(pratiche, List<OCSPratica>.class)); 
        System.debug('OCSRecuperaDatiPostvenditaController filtraPratiche res: ' + res);
        return res;
    } */
    
    @TestVisible
    private static Account_Futuro_MBCS__c makeAccount(OCSCliente cm){
        system.debug('OCSRecuperaDatiFuturoController - makeAccount');
        return AccountUtilsFuturoMBCS.makeAccount(cm, 'Futuro');
    }
    
    @AuraEnabled
    public static String getInputAccountOCSId(String accountId){
        List<Account_Futuro_MBCS__c> l = [select External_Id__c from Account_Futuro_MBCS__c where Id =: accountId];
        return l.size() > 0? l[0].External_Id__c:'';
    }
  
}