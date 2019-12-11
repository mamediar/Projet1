public class XCSReclamiFormInserimentoMBCreditCtrl {
    
	@AuraEnabled
    public static OCSCliente makeCliente(Map<String, String> clienteMap, Map<String, String> praticaMap){
        OCSCliente res = OCSObjectsFactory.makeCliente(clienteMap);
        OCSPratica p = OCSObjectsFactory.makePratica(praticaMap);
        res.pratiche.add(p);
        Account_Futuro_MBCS__c a = AccountUtilsFuturoMBCS.upsertAccount(AccountUtilsFuturoMBCS.makeAccount(res, 'MBCS'), 'MBCS');
        res.SFId = a.Id;
        return res;
    }
}