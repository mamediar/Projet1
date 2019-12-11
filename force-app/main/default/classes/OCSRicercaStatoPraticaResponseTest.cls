@isTest
public class OCSRicercaStatoPraticaResponseTest 
{
	@isTest
    static void test()
    {
		OCSRicercaStatoPraticaResponse crspr = new OCSRicercaStatoPraticaResponse();
        crspr.statoPratica = '30RE';
        crspr.resultCode = 0;
        crspr.isOK();
        crspr.isFound();
        
    }
}