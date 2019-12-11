public class OCSRecuperaDinieghiSDDResponse extends OCSResponse {
   
    public class provadto{
	    public List<DiniegoSDDDTO> elenco;
        
    }
    
    public provadto recuperaDinieghiSDDResponse {get;set;}
    
    
    @AuraEnabled
    public List<DiniegoSDDDTO> elenco;
    
    
    public OCSRecuperaDinieghiSDDResponse(){
        this.elenco = new  List<DiniegoSDDDTO>();
    }
    
    public class DiniegoSDDDTO{
        @AuraEnabled
        public String canomanProvenienza {get;set;}
        @AuraEnabled
        public String canomanPratica {get;set;}
        @AuraEnabled
        public String canomanProgressivo {get;set;}
        @AuraEnabled
        public String canomanProgreMan {get;set;}
        @AuraEnabled
        public String canomanTipo {get;set;}
        @AuraEnabled
        public String canomanMandato {get;set;}
        @AuraEnabled
        public String canomanCid {get;set;}
        @AuraEnabled
        public String canomanCliente {get;set;}
        @AuraEnabled
        public String canomanRagione {get;set;}
        @AuraEnabled
        public String canomanIntest {get;set;}
        @AuraEnabled
        public String canomanIntestRag {get;set;}
        @AuraEnabled
        public String canomanCodFiscale {get;set;}
        @AuraEnabled
        public String canomanTel {get;set;}
        @AuraEnabled
        public String canomanTel2 {get;set;}
        @AuraEnabled
        public String canomanCell {get;set;}
        @AuraEnabled
        public String canomanSed {get;set;}
        @AuraEnabled
        public String canomanPagamento{get;set;}
        @AuraEnabled
        public String canomanGruppo{get;set;}
        @AuraEnabled
        public String canomanDenBanca{get;set;}
        @AuraEnabled
        public String canomanAbi{get;set;}
        @AuraEnabled
        public String canomanCab{get;set;}
        @AuraEnabled
        public String canomanContoCorrente{get;set;}
        @AuraEnabled
        public String canomaIban{get;set;}
        @AuraEnabled
        public String canomanReason{get;set;}
        @AuraEnabled
        public String canomanAccepted{get;set;}
        @AuraEnabled
        public String canomanStato {get;set;}
        @AuraEnabled
        public String canomanStatoPr {get;set;}
        @AuraEnabled
        public String canomanAttrPr {get;set;}
        @AuraEnabled
        public String canomanDataIns {get;set;}
        @AuraEnabled
        public String canomanDataInv {get;set;}
        @AuraEnabled
        public String canomanDataRie {get;set;}
        @AuraEnabled
        public String canomanFiliale {get;set;}
        @AuraEnabled
        public String canomanFilialeDes {get;set;}
        @AuraEnabled
        public String canomanConvenz {get;set;}
        @AuraEnabled
        public String canomanConvenzDes {get;set;}
        @AuraEnabled
        public String canomanTelCab {get;set;}
        @AuraEnabled
        public String acCognome {get;set;}
        @AuraEnabled
        public String acNome {get;set;}
        @AuraEnabled
        public String acNascitaData {get;set;}
        @AuraEnabled
        public String acNascitaLuogo {get;set;}
        @AuraEnabled
        public String acNascitaProv {get;set;}
        @AuraEnabled
        public String acSesso {get;set;}
        @AuraEnabled
        public String acEmail {get;set;}
        
        
    }
    
}