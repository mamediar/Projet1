public class OCSPraticaFuturo {
	@AuraEnabled public String numPratica{get;set;}
    @AuraEnabled public String codCliente{get;set;}
    @AuraEnabled public String dataCaricamento{get {return DateUtils.parseFromYYYYMMDDStringToString(dataCaricamento);} set{dataCaricamento=value ;}}     
    @AuraEnabled public String tipoPratica{get;set;}
    @AuraEnabled public String codStatoPratica{get;set;}
    @AuraEnabled public String codAttributoPratica{get;set;}
    @AuraEnabled public String desStatoPratica{get;set;}
    @AuraEnabled public String desAttributoPratica{get;set;}
    @AuraEnabled public String dataContratto{get {return DateUtils.parseFromYYYYMMDDStringToString(dataContratto);} set{dataContratto=value ;}}   
    @AuraEnabled public String dataEstinzioneAnticipata{get {return DateUtils.parseFromYYYYMMDDStringToString(dataEstinzioneAnticipata);} set{dataEstinzioneAnticipata=value ;}}   
    @AuraEnabled public String flagRecupero{get;set;}
    @AuraEnabled public String classifRecupero{get;set;}
    @AuraEnabled public String codRecuperatore{get;set;}    
    @AuraEnabled public String desRecuperatore{get;set;}
    @AuraEnabled public String aziendaCod{get;set;}
    @AuraEnabled public String aziendaRagSoc{get;set;}
    @AuraEnabled public String aziendaIndirizzo{get;set;}
    @AuraEnabled public String aziendaCap{get;set;}
    @AuraEnabled public String aziendaLocalita{get;set;}
    @AuraEnabled public String aziendaProv{get;set;}
    @AuraEnabled public String aziendaSedeCod{get;set;}
    @AuraEnabled public String aziendaSedeRagSoc{get;set;}
    @AuraEnabled public String aziendaSedeIndirizzo{get;set;}
    @AuraEnabled public String aziendaSedeCap{get;set;}
    @AuraEnabled public String aziendaSedeLocalita{get;set;}
    @AuraEnabled public String aziendaSedeProv{get;set;}
    @AuraEnabled public String agenteCod{get;set;}
    @AuraEnabled public String agenteRagSoc{get;set;}
    @AuraEnabled public String subAgenteCod{get;set;}
    @AuraEnabled public String subAgenteRagSoc{get;set;}
    @AuraEnabled public String bancaCod{get;set;}
    @AuraEnabled public String bancaRagSoc{get;set;}
    @AuraEnabled public String filBancaCod{get;set;}
    @AuraEnabled public String filBancaRagSoc{get;set;}
    @AuraEnabled public String assicVitaCod{get;set;}
    @AuraEnabled public String assicVitaRagSoc{get;set;}
    @AuraEnabled public String assicImpiegoCod{get;set;}
    @AuraEnabled public String assicImpiegoRagSoc{get;set;}
}