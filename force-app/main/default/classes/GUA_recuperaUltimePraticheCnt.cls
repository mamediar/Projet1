public with sharing class GUA_recuperaUltimePraticheCnt {

    @AuraEnabled(cacheable=true)
    public static Map<String, Object> retrieveAllPraticheCarta(String numPratica,String tipo,String codiceCliente){

        Map<String, Object> response = new Map<String, Object>();
        response.put('error',false);

        try {
            RecuperaDatiPostvenditaResponse data = RecuperaDatiPostvenditaService.buildRecuperaDatiPostvenditaRequest(numPratica, 'true',tipo, codiceCliente,'', '','','', '', '','', '','', '');
            System.debug('#### data ####'+ JSON.serialize(data));
            response.put('data',JSON.serialize(data));

        } catch (Exception e) {
            response.put('error',true);
            response.put('message',e.getMessage());
            System.debug('## Erreur log ## '+e.getMessage());
        }

        return response;

    }


}