public class OCSRicercaStatoPraticaResponse extends OCSResponse
{

    public String statoPratica {get; set;}
    
    
    public override boolean isOK()
    {
        return resultCode == 0;
    }
    
    
     public boolean isFound()
    {
        return statoPratica != '';
    }
    
    	
}