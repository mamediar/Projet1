public class RoutingEmailFaxUtils {
    
    public static void avviaAlgoritmo(){
        System.debug('Avviamento...');
        
        Group g = GroupUtils.getQueue('Q501');
        List<Case> cases = [Select id, ownerId, AccountId, Sla_Date__c, origin, 
                            ActivityType__c, recordType.Developername, status 
                            from Case where OwnerId =: g.id];
        if(cases.size() > 0){
            RoutingEmailFax routing = new RoutingEmailFax();       
            routing.init();    
            System.debug('i cases sono ' + cases);
            routing.routing(cases);  
        }
    }
    
}