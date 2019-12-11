/**
*@author 		Dieynaba Diallo
*created 		05/11/2019
*descripttion 	test of the ResetPasswordPasscomInvoker class
*/
@isTest
public class ResetPasswordPasscomInvokerTest {
    @isTest
    public static void requestTest1(){
        new ResetPasswordPasscomInvoker.Request();
    }
    
    @isTest
    public static void requestTest2(){
        new ResetPasswordPasscomInvoker.Request('utenza');
    }
     
    @isTest
    public static void responseIsOkTest1(){
        ResetPasswordPasscomInvoker.Response response = new ResetPasswordPasscomInvoker.Response();
        boolean ok = response.isOK();
    }
    
    @isTest
    public static void responseGetMessageTest1(){
        ResetPasswordPasscomInvoker.Response response = new ResetPasswordPasscomInvoker.Response();
        String message = response.getMessage();
    }
    @isTest
    public static void invokeTest1(){
        ResetPasswordPasscomInvoker resetPasswordPasscomInvoker = new ResetPasswordPasscomInvoker();
        ResetPasswordPasscomInvoker.Response response = resetPasswordPasscomInvoker.invoke('utenza');
    }
    @isTest
    public static void resetPasswordPasscomResponseDTOTest(){
		ResetPasswordPasscomInvoker.ResetPasswordPasscomResponseDTO  rt= new ResetPasswordPasscomInvoker.ResetPasswordPasscomResponseDTO();
        rt.resultCode = '40';
        rt.resultMessage = 'dfghjklmù';
        rt.resetPasswordPasscomResponseDTO = new ResetPasswordPasscomInvoker.ResetPasswordPasscomResponse();
        
    }
    @isTest
    public static void resetPasswordPasscomResponseTest(){
        ResetPasswordPasscomInvoker.ResetPasswordPasscomResponse rr = new ResetPasswordPasscomInvoker.ResetPasswordPasscomResponse();
        rr.codErrore = 'gjlmùljh';
        rr.desErrore = 'hjlhlggbj';
        rr.esito = 'bvjkbjk';
        
    }
     
}