/**
 *@author Mame bousso    
 *@date 2019/08/07
 *@description web service Appuntamento lista Comuni
 */
@RestResource(UrlMapping = '/AppuntamentoListaComuni')
global with sharing class AppuntamentoListaComuni {
    	
    @HttpPost
    global static void listComuni(){
            final RestRequest req = RestContext.request;
            final RestResponse res = Restcontext.response;
          /*  String province = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
            System.debug('province '+province); */
            try {
               String response = execute(req.requestBody);
               res.statusCode = 200;
               res.responseBody = Blob.valueOf(response);
                
            } catch (Exception e) {
                System.debug('******** errorMessage '+e.getMessage());
                System.debug('******** errorMessage '+e.getStackTraceString());
            }
        }
        
    public static String execute (Blob jsonRequest){
           // ListXcsTown listXcsTown = new ListXcsTown();
            String responseService;
            try {
                        ListaComunaWrapper lc = deserializationRequest(jsonRequest);

                        List<XcsTown> listaXcstTow = getLisXcsTown(lc.provinvia);

                        if(listaXcstTow.size() != 0){
                                AppuntamentoListaComuniResponseDTO dto  = new AppuntamentoListaComuniResponseDTO(listaXcstTow);
                               
                                dto.resultCode = 0;
                                
                                dto.resultMessage ='OK';
                                
                                responseService= JSON.serialize(dto);
                        }
                        else {
                              AppuntamentoListaComuniResponseDTO dto  = new AppuntamentoListaComuniResponseDTO();
                               
                                dto.resultCode = 1;
                                
                                dto.resultMessage ='KO';
                                
                                responseService= JSON.serialize(dto);
                            
                        }
                        System.debug('#################### responseService '+responseService);
            } catch (Exception e) {
                    AppuntamentoListaComuniResponseDTO dto  = new AppuntamentoListaComuniResponseDTO();
                    dto.resultCode = 1;
                    dto.resultMessage ='KO';
                    responseService= JSON.serialize(dto);
                    System.debug('******* errorMessage execute '+e.getMessage());
                    System.debug('******* errorMessage execute '+e.getStackTraceString());
            } 
            return responseService;
    }

    public static ListaComunaWrapper deserializationRequest(Blob jsonRequest){

        ListaComunaWrapper wrapper = new ListaComunaWrapper();

        try {
                String stringRequest = jsonRequest.toString().trim();
                wrapper = (ListaComunaWrapper) JSON.deserializeStrict(stringRequest, ListaComunaWrapper.class);
            
           } catch (Exception e) {
               
                AppuntamentoError.hasError = true;

                AppuntamentoError.errorMessage = CGMWSUtils_1_0.ERROR_MESSAGE_MAP.get('[KO-CREQ0005]');

                System.debug('############# errorMessage '+e.getMessage());

                System.debug('############### error '+e.getStackTraceString());  
        }
        return wrapper;
    }

    public class ListaComunaWrapper {
        public String provinvia {get;set;}
    }
        
    public static List<XcsTown> getLisXcsTown(String provincia){
    	List<XcsTown> lista = new List<XcsTown>();
        
        list<XCS_Town__c> xcsTowns= [select Id, CAP__c, Catastale__c, Comune__c from XCS_Town__c where Provincia__c =:provincia];
       
        for(XCS_Town__c town: xcsTowns){
                XcsTown xcsTow= new XcsTown(town.CAP__c, town.Comune__c);
               /* xcsTow.codice=town.CAP__c;
                xcsTow.descrizione=town.Comune__c; */
                lista.add(xcsTow);
        }

   		return lista;
   }

   global class AppuntamentoListaComuniResponseDTO extends GenericResponse {
       List<XcsTown> lista {get;set;}
       global AppuntamentoListaComuniResponseDTO(){
           super();
       }
       global AppuntamentoListaComuniResponseDTO( List<XcsTown> lista){
           super();
           this.lista = lista;
          // this.descrizione = descrizione;
       }

   }
		
  /*  global class ListXcsTown{
          List<XcsTown> lista {get;set;}
          String codRes {get;set;}
          String desRes {get;set;}
    } */
	global class XcsTown{
    	String codice {get;set;}
        String descrizione {get;set;}
        global XcsTown(String codice, String descrizione){
            this.codice = codice;
            this.descrizione = descrizione;
        }
    }
}