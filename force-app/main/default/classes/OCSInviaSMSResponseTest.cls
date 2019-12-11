@isTest
public class OCSInviaSMSResponseTest {
    	@isTest
    static void test()
    {
		OCSInviaSMSResponse SMS = new OCSInviaSMSResponse();
        SMS.flagEsito = 'Ok';  
        SMS.isOK();
    }

}