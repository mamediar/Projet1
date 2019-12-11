/**
 * @author Mame bousso
 * @Modified by Abdoulaye DIOP 05/11/2019    
 * @date 2019/09/19
 * @description web service Appuntamento lista ComuFilialini
 */
@RestResource(UrlMapping = '/AppuntamentoListaFiliali/')
global with sharing class AppuntamentoListaFiliali {
    
    @HttpGet
    global static void listFilialis(){
        final RestRequest req = RestContext.request;
        final RestResponse res = Restcontext.response;
        try {
            AppuntamentoListaFilialiResponse response = execute();
            /*res.statusCode = 200;
            res.responseBody = Blob.valueOf(response);*/
            
        } catch (Exception e) {
            System.debug('******** errorMessage '+e.getMessage());
            System.debug('******** errorMessage '+e.getStackTraceString());
        }
    }

    public static AppuntamentoListaFilialiResponse execute (){
        /*ListFiliali fialialiList = new ListFiliali();
        String responseService;*/
        AppuntamentoListaFilialiResponse response = new AppuntamentoListaFilialiResponse();
        try {
            List<Fialiali> listaFiliali = getListFiliali();
            /*fialialiList.lista=listaFiliali;
            fialialiList.codRes='0';   
            fialialiList.desRes='ok';*/
            response.resultCode = 0;
            response.resultMessage = 'Success';
            response.lista = listaFiliali;
            //responseService= JSON.serialize(fialialiList);
        } catch (Exception e) {
            System.debug('******* errorMessage execute '+e.getMessage());
            System.debug('******* errorMessage execute '+e.getStackTraceString());
            response.resultCode = 1;
            response.resultMessage = 'Failed';
        }
        return response;
    }
        
    public static List<Fialiali> getListFiliali(){
    	List<Fialiali> filiali = new List<Fialiali>();
        
        list<Account> listFiliali = [SELECT Id,Name, LastName, ShippingPostalCode, FirstName,Phone,CittaSede__pc,getCodice_Cliente__c,
                    			Sesso__pc,ShippingCountry,ShippingCity,ShippingStreet FROM Account
                                WHERE RecordType.Name='Branch'];
        for(Account account: listFiliali){
            Fialiali acct= new Fialiali();
            acct.cap = account.ShippingPostalCode ;
            acct.codice =account.getCodice_Cliente__c;
            acct.comune = account.ShippingCity;
            acct.indirizzo = account.ShippingStreet;
            acct.nome = account.Name;
            acct.provincia = account.ShippingCountry;
            acct.telefono = account.Phone;
        	filiali.add(acct);
        }
   		return filiali;
    }

    global class ListFiliali{
        List<Fialiali> lista {get;set;}
        String codRes {get;set;}
        String desRes {get;set;}
    }

    global class Fialiali{
    	String cap {get;set;}
        String codice {get;set;}
        String comune {get;set;}
        String indirizzo {get;set;}
        String nome {get;set;}
        String provincia {get;set;}
        String telefono {get;set;}
    }

    /**
     * @author Abdoulaye DIOP    
     * @date 05/11/2019
     * @description web service Response
     */
    global class AppuntamentoListaFilialiResponse extends GenericResponse {
        global String errorCode {get;set;}
        global String errorMessage {get;set;}
        global List<Fialiali> lista {get;set;}
        global AppuntamentoListaFilialiResponse (){
            super();
        }
    }
}