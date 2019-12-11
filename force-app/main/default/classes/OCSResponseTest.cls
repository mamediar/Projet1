@isTest
public class OCSResponseTest {
    @isTest static void test(){
        OCSResponse r=new OCSResponse();
        r.resultCode=-2; r.resultMessage='TEsT ERROR'; r.status='NOT SUCCESS'; r.statusCode=500;
        r.isOK();
        r.getMessage();
        OCSResponse r2=new OCSResponse();
        r2.resultCode=-1; r2.resultMessage='TEST Error';  r2.status='SUCCESS'; r2.statusCode=200;
        r2.isOK();
        r2.getMessage();
    }
}