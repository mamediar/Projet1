@isTest
public class APIResponseTest {
    @isTest static void test(){
        APIResponse a=new APIResponse();
        a.status='OK';
        a.statusCode=200;
        System.assert(a.isOk()==true);
    }
}