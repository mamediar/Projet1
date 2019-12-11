public class OCSCartaDatiFinanziariController {
   @auraEnabled
    public static OCSCartaDatiFinanziariResponse cartaDati(String numeroPrat){
        return OCSCartaDatiFinanziariInvoker.cartaDatiFinanziari(numeroPrat); 
        
    }

}