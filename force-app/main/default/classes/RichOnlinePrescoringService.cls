public with sharing class RichOnlinePrescoringService {
    /*
    * @description create Rich_Online_Prescoring__c
    *
    * @param Case
    *
    * @param pricing
    *
    * @param channel
    *
    * @return RO_CRMRich_online_prescoring__c
    */
    public static RO_CRMRich_online_prescoring__c createCrmOnlinePrescoring(case cas){
        System.debug('******** data Running  createCrmOnlinePrescoring '+RequestOnlineApexClass.data);
        RO_CRMRich_online_prescoring__c log =  (RO_CRMRich_online_prescoring__c) RequestOnlineApexClass.data.get('rop');
        try {
                List<RO_CRMRich_online_prescoring__c> listLog = [SELECT Id, Pricing__c FROM RO_CRMRich_online_prescoring__c WHERE RO_CRMRichiesta_Online__c=: cas.Id]; 
               // Integer nameLog = listLog.size() + 1;
                Date createdate =  Date.today();
                log.RO_CRMData__c = createdate;
                System.debug('case Id '+cas.Id);
                log.RO_CRMRichiesta_Online__c = cas.Id;
              //  log.Name = nameLog+ '';
                insert log;
        }  
        catch (Exception e)  {
            System.debug('************* createCrmOnlinePrescoring errorMessage  '+e.getMessage());
            System.debug('************* createCrmOnlinePrescoring errorMessage  '+e.getStackTraceString() );
            //throw new CGMWSUtils_1_0.CGMWSRException('[KO-ROCRMRichLogPresc0001]');
        }
        System.debug('#################### log Prescoring '+log);
        return log;

    }
}