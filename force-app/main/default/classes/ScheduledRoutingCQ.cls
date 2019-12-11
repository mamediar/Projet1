public class ScheduledRoutingCQ implements Schedulable{
    
    public void execute(SchedulableContext ctx){
        
        System.debug('sto per avviare l algoritmo di CQ...');
        GestioneFaxCQ routingCQ = new GestioneFaxCQ();       
        routingCQ.execute();
        System.debug('Job eseguito');
        
    }
}