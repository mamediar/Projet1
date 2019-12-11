public class OCSDinieghiSDDFlagLetturaRequest extends OCSRequest{
                      
    
    @AuraEnabled               
    public DinieghiSDDFlagLetturaRequestDTO dinieghiSDDFlagLetturaRequest{get;set;}
    
    public OCSDinieghiSDDFlagLetturaRequest(List<DiniegoSDDFlagLetturaDTO> lista) {
        serviceId = 'dinieghiSDDFlagLettura';
        dinieghiSDDFlagLetturaRequest = new DinieghiSDDFlagLetturaRequestDTO(lista);
    }
    
    public class DinieghiSDDFlagLetturaRequestDTO{
      
        @AuraEnabled
        public List<DiniegoSDDFlagLetturaDTO> elenco{get;set;}
        
        public DinieghiSDDFlagLetturaRequestDTO(List<DiniegoSDDFlagLetturaDTO> lista){
            this.elenco = lista;
            
        }

    }
    
    public class DiniegoSDDFlagLetturaDTO{
        @AuraEnabled
        public String canomanProgressivo{get;set;}
        @AuraEnabled
        public String canomanProgreMan{get;set;}
        
    }
}