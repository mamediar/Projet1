@isTest
public  class RecuperaStatiAttributiPrtServiceTest {
    
    @isTest
    static void validateResponsetest(){
        String jsonResponse = '{"resultCode": 1,"resultMessage": "KO","recuperaStatiAttributiPrtResponse": {  "elencoPratiche": [{"tipoPratica": "CA","numPratica": "33190097388","statoPratica": "60","attributoPratica": "RT","canale": "MAE"}]}}';
        RecuperaStatiAttributiPrtResponse response = (RecuperaStatiAttributiPrtResponse) JSON.deserializeStrict(jsonResponse, RecuperaStatiAttributiPrtResponse.class);
        Test.startTest();
        Boolean b = RecuperaStatiAttributiPrtService.validateResponse(response);
        System.debug(' ********** response '+ response.recuperaStatiAttributiPrtResponse.elencoPratiche[0].numPratica);
        System.debug(' ********** response '+ response.recuperaStatiAttributiPrtResponse.elencoPratiche[0].statoPratica);
        System.debug(' ********** response '+ response.recuperaStatiAttributiPrtResponse.elencoPratiche[0].tipoPratica);
        System.debug(' ********** response '+ response.recuperaStatiAttributiPrtResponse.elencoPratiche[0].attributoPratica);
        Test.stopTest();

    }

    @isTest
    static void validateResponsetestNull(){
        String jsonResponse = '{"resultCode": 0,"resultMessage": "OK","recuperaStatiAttributiPrtResponse": {  "elencoPratiche": [{}]}}';
        RecuperaStatiAttributiPrtResponse response = (RecuperaStatiAttributiPrtResponse) JSON.deserializeStrict(jsonResponse, RecuperaStatiAttributiPrtResponse.class);
        Test.startTest();
        RecuperaStatiAttributiPrtResponse res = new RecuperaStatiAttributiPrtResponse ();
        res.recuperaStatiAttributiPrtResponse.elencoPratiche = new List<RecuperaStatiAttributiPrtResponse.RecuperaStatiAttributiPrtRes>();
        Boolean b = RecuperaStatiAttributiPrtService.validateResponse(res);

        System.debug(' ********** response '+ res.recuperaStatiAttributiPrtResponse.elencoPratiche.size());
      /*  System.debug(' ********** response '+ response.recuperaStatiAttributiPrtResponse.elencoPratiche[0].statoPratica);
        System.debug(' ********** response '+ response.recuperaStatiAttributiPrtResponse.elencoPratiche[0].tipoPratica);
        System.debug(' ********** response '+ response.recuperaStatiAttributiPrtResponse.elencoPratiche[0].attributoPratica); */
        Test.stopTest();
    }
    
    @isTest
    static void validateResponsetestException(){
        String jsonResponse = '{"resultCode": 0,"resultMessage": "OK","recuperaStatiAttributiPrtResponse": {  "elencoPratiche": [{}]}}';
        RecuperaStatiAttributiPrtResponse response = new  RecuperaStatiAttributiPrtResponse();
        Test.startTest();
        Boolean b = RecuperaStatiAttributiPrtService.validateResponse(response);
       /* System.debug(' ********** response '+ response.recuperaStatiAttributiPrtResponse.elencoPratiche[0].numPratica);
        System.debug(' ********** response '+ response.recuperaStatiAttributiPrtResponse.elencoPratiche[0].statoPratica);
        System.debug(' ********** response '+ response.recuperaStatiAttributiPrtResponse.elencoPratiche[0].tipoPratica);
        System.debug(' ********** response '+ response.recuperaStatiAttributiPrtResponse.elencoPratiche[0].attributoPratica); */
        Test.stopTest();

    }
}