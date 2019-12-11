public class OCSRecuperaDominiRiservatiInvoker {


//********************
// REQUEST
//********************
	public class Request extends OCSRequest {

		public DatiRecuperaDominiRiservatiRequestDTO recuperaDominiRiservatiRequest {get; set;}

		public Request() {
			serviceId = 'recuperaDominiRiservati';
			recuperaDominiRiservatiRequest = new DatiRecuperaDominiRiservatiRequestDTO();
		}

	}

    
    public class DatiRecuperaDominiRiservatiRequestDTO {      				
			public String flagNazione {get; set;}
			public String flagCittadinanza {get; set;}
			public String flagProvincia {get; set;}
			public String flagComune {get; set;}
			public String flagDocumentoIdentita {get; set;}
			public String flagTipoAttivita {get; set;}
			public String flagSettoreAttivita {get; set;}
			public String flagOccupazioneAttivita {get; set;}
			public String flagTipoRedditoAttivita {get; set;}
			public String flagStatoCivile {get; set;}
			public String flagTitoloStudio {get; set;}
			public String flagTipoAbitazione {get; set;}
			public String flagRapportoBancario {get; set;}
			public String flagTipoCartaCredito {get; set;}
			public String flagParentela {get; set;}
			public String flagBanca {get; set;}
    }
	
	
	

//********************
// RESPONSE DTO
//********************

	public class Response extends OCSResponse {
		@AuraEnabled
		public DatiRecuperaDominiRiservatiResponseDTO recuperaDominiRiservatiResponse {get; set;} 
    
	}
	
	
	
	
	public class DatiRecuperaDominiRiservatiResponseDTO {       
    @AuraEnabled public NazioneDTO[] elencoNazione{get;set;} 
		@AuraEnabled public CodiceDescrizioneDTO[] elencoBanche{get;set;}
		@AuraEnabled public CittadinanzaDTO[] elencoCittadinanza{get;set;}
		@AuraEnabled public CodiceDescrizioneDTO[] elencoProvincia{get;set;}
		@AuraEnabled public ComuneLTDTO[] elencoComune{get;set;}
		@AuraEnabled public CodiceDescrizioneDTO[] elencoDocumentoIdentita{get;set;}
		@AuraEnabled public CodiceDescrizioneDTO[] elencoTipoAttivita{get;set;}
		@AuraEnabled public SettoreAttivitaDTO[] elencoSettoreAttivita{get;set;}
		@AuraEnabled public OccupazioneAttivitaDTO[] elencoOccupazioneAttivita{get;set;}
		@AuraEnabled public TipoRedditoAttivitaDTO[] elencoTipoRedditoAttivita{get;set;}		
		@AuraEnabled public CodiceDescrizioneDTO[] elencoStatoCivile{get;set;}
		@AuraEnabled public CodiceDescrizioneDTO[] elencoTitoloStudio{get;set;}
		@AuraEnabled public CodiceDescrizioneDTO[] elencoTipoAbitazione{get;set;}		
		@AuraEnabled public RapportoBancarioDTO[] elencoRapportoBancario{get;set;}
		@AuraEnabled public CodiceDescrizioneDTO[] elencoTipoCartaCredito{get;set;}
		@AuraEnabled public CodiceDescrizioneDTO[] elencoParentela{get;set;}
	
         
		public DatiRecuperaDominiRiservatiResponseDTO(){
            
            
            
			elencoNazione = new List<NazioneDTO>();
			elencoBanche= new List<CodiceDescrizioneDTO>();
			elencoCittadinanza = new List<CittadinanzaDTO>();
			elencoProvincia = new List<CodiceDescrizioneDTO>();
			elencoComune = new List<ComuneLTDTO>(); 
			elencoDocumentoIdentita = new List<CodiceDescrizioneDTO>(); 
			elencoTipoAttivita = new List<CodiceDescrizioneDTO>();            
			elencoSettoreAttivita = new List<SettoreAttivitaDTO>(); 
			elencoOccupazioneAttivita = new List<OccupazioneAttivitaDTO>(); 
			elencoTipoRedditoAttivita = new List<TipoRedditoAttivitaDTO>();             
			elencoStatoCivile = new List<CodiceDescrizioneDTO>(); 
			elencoTitoloStudio = new List<CodiceDescrizioneDTO>(); 
			elencoTipoAbitazione = new List<CodiceDescrizioneDTO>();             
			elencoRapportoBancario = new List<RapportoBancarioDTO>(); 
			elencoTipoCartaCredito = new List<CodiceDescrizioneDTO>(); 
			elencoParentela = new List<CodiceDescrizioneDTO>(); 		
		}
  }
	  
   
    
  public class NazioneDTO{
		@AuraEnabled public String nazione {get;set;}
		@AuraEnabled public String provincia {get;set;}
	}
    
    
  public class ComuneLTDTO{
		@AuraEnabled public String codice {get;set;}
		@AuraEnabled public String descrizione {get;set;}
		@AuraEnabled public String flagSoppresso {get;set;}
	}
   
   
  public class CittadinanzaDTO{
		@AuraEnabled public String codice {get;set;}
		@AuraEnabled public String descrizione {get;set;}
		@AuraEnabled public String flagExtracomunitaria {get;set;}
	}


  public class SettoreAttivitaDTO{
		@AuraEnabled public String codice {get;set;}
		@AuraEnabled public String descrizione {get;set;}
		@AuraEnabled public String codiceTipoAttivita {get;set;}
		
	}
    
    
  public class OccupazioneAttivitaDTO{
		@AuraEnabled public String codice {get;set;}
		@AuraEnabled public String descrizione {get;set;}
		@AuraEnabled public String codiceTipoAttivita {get;set;}
		@AuraEnabled public String codiceSettoreAttivita {get;set;}		
	}
    
     
  public class TipoRedditoAttivitaDTO{
		@AuraEnabled public String codice {get;set;}
		@AuraEnabled public String descrizione {get;set;}
		@AuraEnabled public String codiceTipoAttivita {get;set;}
		@AuraEnabled public String codiceSettoreAttivita {get;set;}	
		@AuraEnabled public String codiceOccupazioneAttivita {get;set;}			
	}
 
    
  public class RapportoBancarioDTO{
		@AuraEnabled public String codice {get;set;}
		@AuraEnabled public String descrizione {get;set;}
		@AuraEnabled public String flagAnzianita {get;set;}			
	}
    
 
    
  public class CodiceDescrizioneDTO{
		@AuraEnabled public String codice {get;set;}
		@AuraEnabled public String descrizione {get;set;}
	}
    	
	    

//********************
// INVOKER
//********************

	public static Response invoke (DatiRecuperaDominiRiservatiRequestDTO objectIn){

		  Request req = new Request();		
			req.recuperaDominiRiservatiRequest = objectIn; 
			return 	(Response)ApiUtils.callApi ('ocs.'+req.serviceId,req, Response.class, 'C' );
	}

	
/***********************
*   CHIAMATA PER TEST
************************/
/*
OCSRecuperaDominiRiservatiInvoker.Request req = new OCSRecuperaDominiRiservatiInvoker.Request();

	  
req.recuperaDominiRiservatiRequest.flagNazione = 'S';
req.recuperaDominiRiservatiRequest.flagCittadinanza = 'N';
req.recuperaDominiRiservatiRequest.flagProvincia = 'N';
req.recuperaDominiRiservatiRequest.flagComune = 'N';
req.recuperaDominiRiservatiRequest.flagDocumentoIdentita = 'N';
req.recuperaDominiRiservatiRequest.flagTipoAttivita = 'N';
req.recuperaDominiRiservatiRequest.flagSettoreAttivita = 'N';
req.recuperaDominiRiservatiRequest.flagOccupazioneAttivita = 'N';
req.recuperaDominiRiservatiRequest.flagTipoRedditoAttivita = 'N';
req.recuperaDominiRiservatiRequest.flagStatoCivile = 'N';
req.recuperaDominiRiservatiRequest.flagTitoloStudio = 'N';
req.recuperaDominiRiservatiRequest.flagTipoAbitazione = 'N';
req.recuperaDominiRiservatiRequest.flagRapportoBancario = 'N';
req.recuperaDominiRiservatiRequest.flagTipoCartaCredito = 'N';
req.recuperaDominiRiservatiRequest.flagParentela = 'N';
req.recuperaDominiRiservatiRequest.flagBanca = 'S';

OCSRecuperaDominiRiservatiInvoker.Response resp = OCSRecuperaDominiRiservatiInvoker.invoke(req.recuperaDominiRiservatiRequest);
system.debug ('*****'+resp.recuperaDominiRiservatiResponse.elencoNazione[0]);
system.debug ('*****'+resp.recuperaDominiRiservatiResponse.elencoBanche[0]);    
*/
}