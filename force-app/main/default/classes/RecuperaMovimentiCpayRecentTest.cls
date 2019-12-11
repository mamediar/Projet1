@isTest
public  class RecuperaMovimentiCpayRecentTest {

    @isTest
    static void testMehode(){

        Test.startTest();
       List<RecuperaMovimentiCpayRecent> listmivimenti = new List<RecuperaMovimentiCpayRecent>();
        RecuperaMovimentiCpayResponse.RecuperaMovimentiCpayRes rc = new RecuperaMovimentiCpayResponse.RecuperaMovimentiCpayRes();
        rc.dataCompetenza ='20190722';
         RecuperaMovimentiCpayResponse.RecuperaMovimentiCpayRes r2 = new RecuperaMovimentiCpayResponse.RecuperaMovimentiCpayRes();
        rc.dataCompetenza ='20190721';
         RecuperaMovimentiCpayResponse.RecuperaMovimentiCpayRes r3 = new RecuperaMovimentiCpayResponse.RecuperaMovimentiCpayRes();
        rc.dataCompetenza ='20190731';
        listmivimenti.add(new RecuperaMovimentiCpayRecent(rc) ); listmivimenti.add(new RecuperaMovimentiCpayRecent(r2)); listmivimenti.add(new RecuperaMovimentiCpayRecent(r2));
        listmivimenti.sort();
        System.assertEquals(listmivimenti[0].recuperaCpay.dataCompetenza, '20190731', '** pass **');
        Test.stopTest();
    }
    
}