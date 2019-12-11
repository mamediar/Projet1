public class OCSCensimentoCollegatiRequest extends OCSRequest  {
    
    @AuraEnabled
    public OCSCensimentoCollegatiRequestData censimentoCollegatiRequest{get;set;}
    
    public OCSCensimentoCollegatiRequest(){
        this.serviceId='censimentoCollegati';
        this.censimentoCollegatiRequest=new OCSCensimentoCollegatiRequestData();
    }
    
    public class OCSCensimentoCollegatiRequestData{
        @AuraEnabled
        public List<Elenco> elenco {get; set;}
        
        public OCSCensimentoCollegatiRequestData() {
            this.elenco=new List<Elenco>();
        }
    }


    
    public class Elenco {
       public String partimestp { get{	if(partimestp == null) partimestp = ''; return partimestp;}  set;} 
       public String nomefile { get{if(nomefile == null) nomefile = ''; return nomefile;}  set;}
       public String icoCodice { get{if(icoCodice == null) icoCodice = ''; return icoCodice;}  set;}
       public String icoCollegato { get{if(icoCollegato == null) icoCollegato = ''; return icoCollegato;}  set;}
       public String icoFirmatario { get{if(icoFirmatario == null) icoFirmatario = ''; return icoFirmatario;}  set;}
       public String icoRappresentante  { get{if(icoRappresentante  == null) icoRappresentante  = ''; return icoRappresentante ;}  set;}
       public String icoReferente  { get{if(icoReferente  == null) icoReferente  = ''; return icoReferente ;}  set;}
       public String icoSocio { get{if(icoSocio  == null) icoSocio  = ''; return icoSocio ;}  set;}
       public String icoTitolare { get{if(icoTitolare  == null) icoTitolare  = ''; return icoTitolare ;}  set;}
       public String icoResponsabileIsvap { get{if(icoResponsabileIsvap  == null) icoResponsabileIsvap  = ''; return icoResponsabileIsvap ;}  set;}
       public String icoCodIscrizIsvap { get{if(icoCodIscrizIsvap  == null) icoCodIscrizIsvap  = ''; return icoCodIscrizIsvap ;}  set;}
       public String icoDataIscrizIsvap { get{if(icoDataIscrizIsvap  == null) icoDataIscrizIsvap  = ''; return icoDataIscrizIsvap ;}  set;}
       public String icoDataApertura { get{if(icoDataApertura  == null) icoDataApertura  = ''; return icoDataApertura ;}  set;}
       public String icoDataChiusura { get{if(icoDataChiusura  == null) icoDataChiusura  = ''; return icoDataChiusura ;}  set;}
       public String icoPresAna { get{if(icoPresAna  == null) icoPresAna  = ''; return icoPresAna ;}  set;}
       public String icoPresProtesti { get{if(icoPresProtesti  == null) icoPresProtesti  = ''; return icoPresProtesti ;}  set;}
       public String icoPresEspBanca { get{if(icoPresEspBanca  == null) icoPresEspBanca  = ''; return icoPresEspBanca ;}  set;}
       public String icoTipoFirma { get{if(icoTipoFirma  == null) icoTipoFirma  = ''; return icoTipoFirma ;}  set;}
       public String icoNote01 { get{if(icoNote01  == null) icoNote01  = ''; return icoNote01 ;}  set;}
       public String icoNote02 { get{if(icoNote02  == null) icoNote02  = ''; return icoNote02 ;}  set;}
       public String icoEmail { get{if(icoEmail  == null) icoEmail  = ''; return icoEmail ;}  set;}
       
    }    
    
}