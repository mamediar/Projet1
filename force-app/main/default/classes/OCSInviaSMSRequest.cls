public class OCSInviaSMSRequest extends OCSRequest {
    
    public SMS inviaSMSRequest {get; set;}
    
    public  OCSInviaSMSRequest()
    {
        serviceId = 'inviaSMS';
        inviaSMSRequest = New SMS();
    }   
    
    public class SMS {
    public String tipo {get; set;}
    public String numero {get; set;}
    public String emettitore {get; set;}
    public String pan {get; set;}
    public String testo {get; set;}
    }
}