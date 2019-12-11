@isTest
public class OCSAPIResponseTest {
   
   @isTest
   static void getMessagetest(){
       Test.startTest();
       OCSAPIResponse ocs = new OCSAPIResponse();
    // String msg =   ocs.getMessage();
        String msg = ocs.getMessage();
          System.debug('********** msg '+msg);
          System.assertEquals('Errore nella chiamata: null', msg, 'pass');
       Test.stopTest();

   }
   @isTest
   static void isOktest(){
       Test.startTest();
        OCSAPIResponse ocs = new OCSAPIResponse();
        Boolean b = ocs.isOK();
        System.debug('********** b '+b);
        System.assertEquals(false, b, '***** pass ');

       Test.stopTest();

   }
}