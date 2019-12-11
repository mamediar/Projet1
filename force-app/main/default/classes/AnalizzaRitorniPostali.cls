public class AnalizzaRitorniPostali implements Schedulable {
    
    //esecuzione a valle del batch RecuperaRitorniPostali
    public void execute(SchedulableContext ctx) {
        
        Database.executeBatch(new batchAnalizzaRitorniPostali());
               
    }
}