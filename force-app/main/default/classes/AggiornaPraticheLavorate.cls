public class AggiornaPraticheLavorate implements Schedulable {

    //esecuzione a valle del batch AnalizzaRitorniPostali
    public void execute(SchedulableContext ctx) {
        
        Database.executeBatch(new batchAggiornaPraticheLavorate());
                
    }
           
}