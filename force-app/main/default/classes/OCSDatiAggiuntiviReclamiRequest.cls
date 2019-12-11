public class OCSDatiAggiuntiviReclamiRequest extends OCSRequest {
    
    public DatiAggiuntiviReclamiRequestDTO datiAggiuntiviReclamiRequest {get;set;}
    
    public OCSDatiAggiuntiviReclamiRequest(){
        serviceId = 'datiAggiuntiviReclami';
        datiAggiuntiviReclamiRequest = new DatiAggiuntiviReclamiRequestDTO();
    }
    
    public class DatiAggiuntiviReclamiRequestDTO{
        public String codCliente {get;set;}
        public String codPratica {get;set;}
        public String tipoPratica {get;set;}
    }
    
}