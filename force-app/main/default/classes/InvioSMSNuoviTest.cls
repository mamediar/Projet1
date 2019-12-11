@IsTest(SeeAllData=true)
public class InvioSMSNuoviTest {
    
    @IsTest
    public static void sendNewSMSTest() {
        
        try {
            
            test.startTest();      
            InvioSMSNuovi sendSMS = new InvioSMSNuovi();
            sendSMS.execute(null);
            test.stopTest(); 
            
        } catch (Exception e) {
            
            e.getMessage();
            
        }
        
        
    }
    
}