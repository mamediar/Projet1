public class CRMReclamiFrodeForwardAndTrackingCtrl {
    
    @AuraEnabled
    public static Case getReclamo(String reclamoId){
        system.debug('hai chiamaton getReclamo');
        Case c = [Select id, subject, caseNumber from case where id =: reclamoId]; 
        System.debug('il case è = '+c);
       	return c;
    }  
    
    @AuraEnabled
    public static void test(){
        System.debug('sono nell apex');
    }
    
}