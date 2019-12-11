@isTest
public class RecuperaEstrattoContoPDFcontroller_Test {

    @isTest
    public static void test_RecuperaEstrattoContoPDFcontroller(){
        Test.startTest();
		RecuperaEstrattoContoPDFcontroller.getContoPDF('1234','12345678','01','2018'); 
        
        Test.stopTest();
    }
}