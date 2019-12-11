@isTest
public class Schedulable_chuisuraAutomaticaROTest {
    
    @IsTest
    static void executeshedulableTest()
    {
           String sch = '0 0 2 * * ?';
           Schedulable_chuisuraAutomaticaRichOnline SchedulableROIstance = new Schedulable_chuisuraAutomaticaRichOnline();  
           String jobIDAfterFiveDaysDSP = System.schedule('ROafterFiveDays_',sch, SchedulableROIstance);
    
    }

}