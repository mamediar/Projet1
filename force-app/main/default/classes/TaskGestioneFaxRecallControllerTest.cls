@isTest
public class TaskGestioneFaxRecallControllerTest {
    
    @isTest
    public static void testGetRecallMax(){
        Task tsk = new Task(CategoriaID__c = 3678,
                            ProdottoID__c = 1416);
        Insert tsk;
        TaskGestioneFaxRecallController.getRecallMax(tsk.Id);
    }
    
}