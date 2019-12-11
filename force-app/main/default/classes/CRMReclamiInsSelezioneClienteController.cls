public class CRMReclamiInsSelezioneClienteController {
    
    @AuraEnabled
    public static SelectAccoutResponse makeAccount(OCSCliente c, String societa){
        System.debug('CRMReclamiInsSelezioneClienteController makeAccount START');
        SelectAccoutResponse res=new SelectAccoutResponse();
        if(societa.equals('Compass')){
            System.debug('CRMReclamiInsSelezioneClienteController makeAccount-MakePRatiche-GetReclami');
            List<OCSPratica> pratiche=OCSObjectsFactory.makePratiche(OCSRecuperaDatiPostvenditaInvoker.getReclamiPratica(c.codCliente, societa).pratiche);
            Account a = AccountUtils.upsertAccount(AccountUtils.makeAccount(c, societa), societa); 
            c.SFId = a.Id;
            c.pratiche=pratiche;
        } 
        else{
            List<OCSPraticaFuturo> pratiche=OCSObjectsFactory.makePratiche(OCSRecuperaDatiFuturoInvoker.callRecDatiFuturo(c.codCliente).pratiche);
            Account_Futuro_MBCS__c a = AccountUtilsFuturoMBCS.upsertAccount(AccountUtilsFuturoMBCS.makeAccount(c, societa), societa);
            c.SFId = a.Id;
            c.praticheFuturo=pratiche;
        }
        res.cliente=c;
        System.debug('CRMReclamiInsSelezioneClienteController makeAccount res: '+res);
        return res;
    }
    
    public class SelectAccoutResponse{
        @AuraEnabled
        public OCSCliente cliente {get;set;}
    }
}