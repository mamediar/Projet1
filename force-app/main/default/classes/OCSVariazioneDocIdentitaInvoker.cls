public class OCSVariazioneDocIdentitaInvoker {   

    public static OCSVariazioneDocIdentitaResponse callVariazioneDocIdentita(OCSVariazioneDocIdentitaRequest request){
        return (OCSVariazioneDocIdentitaResponse)ApiUtils.callApi('ocs.variazioneDocIdentita',request,OCSVariazioneDocIdentitaResponse.class);
    }
    
    public static OCSVariazioneDocIdentitaResponse callVariazioneDocIdentita(String contactId){
        OCSVariazioneDocIdentitaRequest request=new OCSVariazioneDocIdentitaRequest();
        Contact contatto=[SELECT Id, Data_Rilascio__c, Ente_Doc_ID__c, Numero_Documento__c, OCS_External_Id__c, 
                          Tipo_Documento__c, Data_Scadenza__c, Luogo_Rilascio__c, Provincia_Rilascio__c 
                          FROM Contact WHERE Id=:contactId][0];
        
		request.datiVariazioneDocIdentitaRequest.codCliente = contatto.OCS_External_Id__c;
        request.datiVariazioneDocIdentitaRequest.tipoDoc = contatto.Tipo_Documento__c;
        request.datiVariazioneDocIdentitaRequest.numeroDoc = contatto.Numero_Documento__c;
        request.datiVariazioneDocIdentitaRequest.ufficioRilascio = contatto.Ente_Doc_ID__c;
        request.datiVariazioneDocIdentitaRequest.localitaRilascio = contatto.Luogo_Rilascio__c;
        request.datiVariazioneDocIdentitaRequest.provinciaRilascio = contatto.Provincia_Rilascio__c;
        request.datiVariazioneDocIdentitaRequest.dataRilascio = String.isEmpty(String.valueof(contatto.Data_Rilascio__c))?'0':DateUtils.formatDateYYYYMMDD(contatto.Data_Rilascio__c);
        request.datiVariazioneDocIdentitaRequest.dataScadenza = String.isEmpty(String.valueof(contatto.Data_Scadenza__c))?'0':DateUtils.formatDateYYYYMMDD(contatto.Data_Scadenza__c); 
        
        return(callVariazioneDocIdentita(request));
    }    
    
    
}