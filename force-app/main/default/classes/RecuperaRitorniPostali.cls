public class RecuperaRitorniPostali implements Schedulable {
    
    //esecuzione tutti i giorni, festivi compresi, ogni 3 ore
    public void execute(SchedulableContext ctx) {
        System.enqueueJob(new AsyncRecuperaRitorniPostali());        
    }
        
}