public without sharing class RecuperaPratichePerVisitaInvoker {
    

    public static RecuperaPratichePerVisitaResponse invoke (RecuperaPratichePerVisitaRequest data){
        return (RecuperaPratichePerVisitaResponse)ApiUtils.callApi('recuperaPratichePerVisita',data,RecuperaPratichePerVisitaResponse.class);
    }

    public static RecuperaPratichePerVisitaResponse invoke(Map<String,String> data){
        

        System.debug('RecuperaPratichePerVisitaInvoker invoke(Map) data: '+data);
        
 
        for(String key:data.keySet()){
            System.debug('RecuperaPratichePerVisitaInvoker invoke(Map) data: '+data.get(key));
        }

        RecuperaPratichePerVisitaRequest request=new RecuperaPratichePerVisitaRequest();
        request.recuperaPratichePerVisitaRequest.codFiliale=data.keySet().contains('codCliente')?data.get('codCliente'):null;
        request.recuperaPratichePerVisitaRequest.paAuto=data.keySet().contains('paAuto')?data.get('paAuto'):null;
        request.recuperaPratichePerVisitaRequest.pfMobili=data.keySet().contains('pfMobili')?data.get('pfMobili'):null;
        request.recuperaPratichePerVisitaRequest.pfNoMobili=data.keySet().contains('pfNoMobili')?data.get('pfNoMobili'):null;
        request.recuperaPratichePerVisitaRequest.ppRete=data.keySet().contains('ppRete')?data.get('ppRete'):null;
        request.recuperaPratichePerVisitaRequest.ppBanche=data.keySet().contains('ppBanche')?data.get('ppBanche'):null;
        request.recuperaPratichePerVisitaRequest.ppAss=data.keySet().contains('ppAgeAss')?data.get('ppAgeAss'):null;
        request.recuperaPratichePerVisitaRequest.ppPoste=data.keySet().contains('ppPoste')?data.get('ppPoste'):null;
        request.recuperaPratichePerVisitaRequest.codDealer=data.keySet().contains('codOcsDealer')?data.get('codOcsDealer'):null;
        request.recuperaPratichePerVisitaRequest.dataLiquidazioneDal=data.keySet().contains('dataLiquidazioneDa')?data.get('dataLiquidazioneDa'):null;
        request.recuperaPratichePerVisitaRequest.dataLiquidazioneAl=data.keySet().contains('dataLiquidazioneA')?data.get('dataLiquidazioneA'):null;

        System.debug('RecuperaPratichePerVisitaInvoker invoke(Map) request: '+request);
        
        RecuperaPratichePerVisitaResponse res=invoke(request);
        System.debug('RecuperaPratichePerVisitaInvoker invoke(Map) res: '+res);
        return res;
    }

    public class RecuperaPratichePerVisitaRequest extends OCSRequest{
        public RecuperaPratichePerVisitaRequestDTO recuperaPratichePerVisitaRequest {get; set;}
        
        public RecuperaPratichePerVisitaRequest() {
            serviceId = 'recuperaPratichePerVisita';
            recuperaPratichePerVisitaRequest = new RecuperaPratichePerVisitaRequestDTO();
        }

    }

    public class RecuperaPratichePerVisitaRequestDTO {
        public String codFiliale {get;set;}
        public String paAuto {get;set;}
        public String pfMobili {get;set;}
        public String pfNoMobili {get;set;}
        public String ppRete {get;set;}
        public String ppBanche {get;set;}
        public String ppAss {get;set;}
        public String ppPoste {get;set;}
        public String codDealer {get;set;}
        public String dataLiquidazioneDal {get;set;}
        public String dataLiquidazioneAl {get;set;}

    }

    public class RecuperaPratichePerVisitaResponse extends OCSResponse{
        public String resultCode {get;set;}
        public String resultMessage {get;set;}
        public List<PraticaPerVisitaDTO> elencoPratiche {get;set;}
       
        public override boolean isOK() {   
            return resultCode!= null && resultCode.equalsIgnoreCase('0');
        }
                
        public override string getMessage() {
            return super.getMessage().equalsIgnoreCase('Ok') && isOK() ? super.getMessage() : resultMessage;
        } 
    }

    public class PraticaPerVisitaDTO{
        public String timestamp {get;set;}
        public String tipologia {get;set;}
        public String procedura {get;set;}
        public String numPratica {get;set;}
        public String canale {get;set;}
        public String tipoProdotto {get;set;}
        public String prodotto {get;set;}
        public String codCliente {get;set;}
        public String ragioneSociale {get;set;}
        public String finanziato {get;set;}
        public String dataLiquidazione {get;set;}
        public String codFiliale {get;set;}
        public String parametri {get;set;}
        public String intermediario {get;set;}
    }
}