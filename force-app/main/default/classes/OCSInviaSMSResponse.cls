public class OCSInviaSMSResponse extends OCSResponse {

   public String flagEsito {get; set;}  
    
  public override boolean isOK()
    {
        return  super.isOk() && flagEsito == 'OK';
    }


}