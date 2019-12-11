@isTest
public class SFALottoUtilsTest {
    @isTest
    public static void changeStatusTest()
    {
		SFALotto__c lotto = new SFALotto__c();
        lotto.Status__c = '3';
        insert lotto;
        System.assert(SFALottoUtils.receiveLot(lotto).Status__c =='4');
    }
}