public class OCSRecuperaLettereFaxHostRequest extends OCSRequest {
    public RecuperaLettereFaxHostRequestDTO recuperaLettereFaxHostRequestDTO {get; set;}
    
    public OCSRecuperaLettereFaxHostRequest(){
        serviceId = 'recuperaLettereFaxHost';
        recuperaLettereFaxHostRequestDTO = new RecuperaLettereFaxHostRequestDTO();
    }
    
    public class RecuperaLettereFaxHostRequestDTO{
        public String numPratica {get; set;}
        public String tipoPratica {get; set;}
        public String codCliente {get; set;}
        public String dataDa {get; set;}        
    }
    
    public void setDataDa(Datetime d){
        recuperaLettereFaxHostRequestDTO.dataDa = d.format('YYMMdd');
    }
}