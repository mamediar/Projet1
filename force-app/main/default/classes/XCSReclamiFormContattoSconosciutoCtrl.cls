public class XCSReclamiFormContattoSconosciutoCtrl {
     
    @AuraEnabled
    public static OCSCliente makeCliente(Map<String, String> data, String societa){
        
        OCSCliente res=OCSObjectsFactory.makeCliente(data);
        if(societa.equals(XCSCompassConstants.COMPASS)){
            system.debug('XCSReclamiFormContattoSconosciutoCtrl - DatiCliente');
            system.debug(data);
            Account a = AccountUtils.upsertAccount2(AccountUtils.makeAccount(data, societa), societa);
            res.SFId = a.Id;
        } else {
            Account_Futuro_MBCS__c a = AccountUtilsFuturoMBCS.upsertAccount(AccountUtilsFuturoMBCS.makeAccount(data, societa), societa);
            res.SFId=a.Id;   
        }
        return res;
    }
}