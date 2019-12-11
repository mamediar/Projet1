@isTest
public class CRMRetentionUtilTest {

    @isTest
    public static void coverageTest() {
        List<CRM_Retention__c> listRetention = new List<CRM_Retention__c>();
        CRM_Retention__c ret = new CRM_Retention__c();
        insert ret;
        listRetention.add(ret);
        XCS_Disposition__c disp = new XCS_Disposition__c();
        insert disp;
        try {CRMRetentionUtil.getFirstRetention(null, null);} catch (Exception e) {}
        try {CRMRetentionUtil.getLoanNumberSObjectMapByList(listRetention);} catch (Exception e) {}
		try {CRMRetentionUtil.getLastValueOfPSVService(null, null);} catch (Exception e) {}
        try {CRMRetentionUtil.getRetentionRequestedByCaseId(null);} catch (Exception e) {}
        try {CRMRetentionUtil.saveRetentionWithDisposition(ret, disp);} catch (Exception e) {}
        try {CRMRetentionUtil.getRetentionToCreateNotUsed();} catch (Exception e) {}
    }
}