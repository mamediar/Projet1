public  class RecuperaMovimentiCpayResponse  extends OCSAPIResponse{
    public  RecuperaMovimentiCpayResponseDTO recuperaMovimentiCpayResponse {get;set;}
    public RecuperaMovimentiCpayResponse() {
        this.recuperaMovimentiCpayResponse = new RecuperaMovimentiCpayResponseDTO();
        this.recuperaMovimentiCpayResponse.elenco = new List<RecuperaMovimentiCpayRes>();

    }
    public class RecuperaMovimentiCpayResponseDTO{
       
      @AuraEnabled    public List<RecuperaMovimentiCpayRes> elenco;
    }

    public class RecuperaMovimentiCpayRes {
        @AuraEnabled      public String  progressivo {get;set;}
        @AuraEnabled      public String causale {get;set;}
        @AuraEnabled      public String segno {get;set;}

        @AuraEnabled      public String  importo {get;set;}
        @AuraEnabled      public String dataCompetenza {get;set;}
        @AuraEnabled      public String progressivoMovimento {get;set;}

        @AuraEnabled      public String  progressivoFase {get;set;}
        @AuraEnabled      public String evento {get;set;}
        @AuraEnabled      public String flagAbbinato {get;set;}

        @AuraEnabled      public String  tipoMovimento {get;set;}
        @AuraEnabled      public String dataFattura {get;set;}
        @AuraEnabled      public String progressivoFattura {get;set;}
         /*   public RecuperaMovimentiCpayRes(String  progressivo, String causale,
                                            String segno, String importo,
                                            String dataCompetenza, String progressivoMovimento,
                                            String  progressivoFase,  String evento,
                                            String flagAbbinato, String  tipoMovimento,
                                            String dataFattura, String progressivoFattura ){
            this.progressivo = progressivo;
            this.causale = causale;
            this.segno = segno;
            this.dataCompetenza = dataCompetenza;
            this.progressivoMovimento = progressivoMovimento;
            this.progressivoFase = progressivoFase;

            this.evento = evento;
            this.flagAbbinato = flagAbbinato;

            this.tipoMovimento = tipoMovimento;
            this.dataFattura = dataFattura;
            this.progressivoFattura = progressivoFattura;


                                            } */

    }
}