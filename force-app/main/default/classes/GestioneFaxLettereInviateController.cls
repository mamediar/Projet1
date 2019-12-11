public class GestioneFaxLettereInviateController {
    
    @AuraEnabled
    public static List<OCSRecuperaLettereFaxHostResponse.LetteraFaxHostDTO> getComunicazioni(String numPratica, String tipoPratica, String codCliente) {

        OCSRecuperaLettereFaxHostResponse res=  OCSRecuperaLettereFaxHostInvoker.recuperaLettereFaxHost(numPratica, tipoPratica,codCliente);
       
        System.debug('*** elencoLettere :: ' + JSON.serialize(res.recuperaLettereFaxHostResponseDTO.elencoLettere));
        
        return res.recuperaLettereFaxHostResponseDTO.elencoLettere; 
        
    }
}