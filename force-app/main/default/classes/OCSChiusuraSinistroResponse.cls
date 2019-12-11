//----------------------------------------------------------------------
//-- - Class Name   : OCSChiusuraSinistroResponse
//-- - Autor        : Fabio Giuliani(Lynx)
//-- - Date         : 02/07/2019
//-- - Description  : Classe Response per ChiusuraSinistro
//-- - Version      : 1.0
//----------------------------------------------------------------------

public class OCSChiusuraSinistroResponse extends OCSResponse{
    public List<ChiusuraSinistroDTO> datiChiusuraSinistroResponse{get;set;}
    
    public OCSChiusuraSinistroResponse(){
        datiChiusuraSinistroResponse=new List<ChiusuraSinistroDTO>();
    }
    
    public class chiusuraSinistroDTO{
        public String compagnia{get;set;}
        public String numPratica{get;set;}
        public String tipoPratica{get;set;}
        public String flagEsito{get;set;}
        public String esito{get;set;}
        public String motivo{get;set;}
        public String importoIndennizzato{get;set;}
        public String cognome{get;set;}
        public String nome {get;set;}
        public String tipoSinistro{get;set;}
        public String tipoPagamento {get;set;}
        public String desScarto{get;set;}

    }
}