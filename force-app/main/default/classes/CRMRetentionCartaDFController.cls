public class CRMRetentionCartaDFController 
{
	@AuraEnabled
    public static OCSCartaDatiFinanziariResponse getDatiFinanziari(String codiceCarta)
    {
        return  OCSCartaDatiFinanziariInvoker.cartaDatiFinanziari(codiceCarta);
    }
}