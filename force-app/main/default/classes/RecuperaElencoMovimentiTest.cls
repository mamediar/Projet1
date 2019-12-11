//----------------------------------------------------------------------
//-- - Author       : SANA BADJI
//-- - Date         : 12/07/2019
//-- - Description  : Handle WS_RecuperaElencoMovimentiTest
//----------------------------------------------------------------------
@isTest
public  class RecuperaElencoMovimentiTest {

    @TestSetup
    static void makeData(){
    String response = '{"resultCode": 0,"resultMessage": "Ok","recuperaElencoMovimentiResponse": {"movimenti": [{ "dataValuta": "20180131","dataRegistrazione": "20180108","dataAcquisto": "20180103","causale": "10","importo": "1275"}]}}';
    ApiRest__c apiRest = new ApiRest__c(Method__c = 'POST' ,
                                        Test_Response__c= response ,
                                        Test_Request__c = 'testRequest',
                                        Mock__c = false, 
                                        User__c = 'CDSLF00',
                                        Password__c = 'P00FLSDC' ,
                                        Name ='recuperaElencoMovimenti',
                                        EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
    insert apiRest;  
    System.debug('apiRest '+ apiRest);
    }

    @isTest   static void testInvoke(){
        
        Test.startTest();
        String jsonString = '{"serviceId" : "recuperaElencoMovimenti","companyType" : { "value" : "COMPASS"},  "recuperaElencoMovimentiRequest" : {"numPratica" : "8136075878","tipoPratica" : "CA","dataValutaDa" : "20180101","dataValutaA" : "20180228","elencoCausali" : ""}}';
                ApiRest__c apiObj = ApiRest__c.getValues('recuperaElencoMovimenti');
                System.debug(' ************** apiObj recuperaElencoMovimenti ' +apiObj);
        RecuperaElencoMovimentiRequest rest = (RecuperaElencoMovimentiRequest) JSON.deserializeStrict(jsonString, RecuperaElencoMovimentiRequest.class);
        System.debug('****** api '+ apiObj);
        RecuperaElencoMovimentiResponse res = RecuperaElencoMovimentiService.invoke(rest);
        List<RecuperaElencoMovimentiResponse.MovimentiEstrattoContoDTO> listrecu = 
        res.RecuperaElencoMovimentiResponse.movimenti;

        RecuperaElencoMovimentiResponse resp2 =
        RecuperaElencoMovimentiService.buildRecuperaElencoMovimentiResponse(
            'CA','8136075878',
            '20180101',
            '20180228','');
            
        RecuperaElencoMovimentiResponse.MovimentiEstrattoContoDTO mvDTO=new RecuperaElencoMovimentiResponse.MovimentiEstrattoContoDTO();
        mvDTO.dataValuta='20180131';
        mvDTO.dataRegistrazione='20180108';
        mvDTO.dataAcquisto='20180103';
        mvDTO.causale='10';
        mvDTO.importo='1275';
        listrecu.add(mvDTO);
    
        System.assertEquals('20180131', listrecu[0].dataValuta,'') ;
        System.assertEquals('20180108', listrecu[0].dataRegistrazione,'') ;
        System.assertEquals('20180103', listrecu[0].dataAcquisto,'') ;
        System.assertEquals('10', listrecu[0].causale,'') ;
        System.assertEquals('1275', listrecu[0].importo,'') ;
        System.debug('****** listrecu '+ listrecu);
        System.debug('****** resp2 '+ resp2);
        Test.stopTest();
    }
    @isTest
    static void validateResponsetest(){
    Test.startTest();
    String jsonString = '{"resultCode": 1,"resultMessage": "KO","recuperaElencoMovimentiResponse": {"movimenti": []}}';
    RecuperaElencoMovimentiResponse response = (RecuperaElencoMovimentiResponse) JSON.deserializeStrict(jsonString, RecuperaElencoMovimentiResponse.class);
    Boolean bool=RecuperaElencoMovimentiService.validateResponse(response);
    System.debug(' ************** bool ' +bool);
    System.assertEquals(false, bool,'') ;
    Test.stopTest();
    }

    @isTest
    static void gestitoRecuperaElencoMovimentitest(){
    System.debug('******************** test gestitoRecuperaElencoMovimentitest ');
     Test.startTest();
     RecuperaElencoMovimentiResponse.MovimentiEstrattoContoDTO m1 = new RecuperaElencoMovimentiResponse.MovimentiEstrattoContoDTO();
     m1.importo='25000-';
     m1.dataAcquisto='20190718';
     RecuperaElencoMovimentiResponse.MovimentiEstrattoContoDTO m2 = new RecuperaElencoMovimentiResponse.MovimentiEstrattoContoDTO();
     m2.importo='25000-';
    m2.dataAcquisto='20190719';
     RecuperaElencoMovimentiResponse.MovimentiEstrattoContoDTO m3 = new RecuperaElencoMovimentiResponse.MovimentiEstrattoContoDTO();
     m3.importo='25000-';
     m3.dataAcquisto='20190717';
     List<RecuperaElencoMovimentiResponse.MovimentiEstrattoContoDTO> movimentis = new List<RecuperaElencoMovimentiResponse.MovimentiEstrattoContoDTO>();
     movimentis.add(m1); movimentis.add(m2); movimentis.add(m3);
     RecuperaElencoMovimentiService.gestitoRecuperaElencoMovimenti(movimentis);
     Test.stopTest();

    }
}