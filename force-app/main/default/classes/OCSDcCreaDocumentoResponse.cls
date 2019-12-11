public class OCSDcCreaDocumentoResponse extends OCSResponse{
  
    
    public DcCreaDocumentoResponse dcCreaDocumentoResponse{get;set;}
    
    public class DcCreaDocumentoResponse{

        public List<DocumentoGenerato> documentoGenerato {get; set;}
        
        public DcCreaDocumentoResponse() {  
            this.documentoGenerato=new List<DocumentoGenerato>();
        }
    }    
    
 
    
    public class DocumentoGenerato {
        @AuraEnabled public String tipoDocumento {get;set;}
        @AuraEnabled public String allegatoAssicurativo {get;set;}
        @AuraEnabled public String stream {get;set;}
    }
    
}