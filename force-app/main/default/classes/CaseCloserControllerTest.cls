@isTest
public class CaseCloserControllerTest {
    
    @isTest
    public static void isCloseTest(){
        Case tempCase = new Case(status = 'Closed');
        insert tempCase;
        System.assert(CaseCloserController.isClose(tempCase.Id));
    } 
    @isTest
    public static void closeCaseTest(){
        Case tempCase = new Case(Status = 'New');
        insert tempCase;
        System.assert(CaseCloserController.closeCase(tempCase.Id, false));
    }
}