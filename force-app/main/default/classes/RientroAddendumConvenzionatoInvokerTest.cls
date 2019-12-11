@IsTest
private class RientroAddendumConvenzionatoInvokerTest {

     @testSetup
	 private static void testsetup(){
        String responseApi = '{"resultCode":0,"resultMessage":"Ok","rientroAddendumConvenzionatoResponse":{"elenco":[{"partimestp":"20190924145651829507","codice":"16039294","stato":"003","tipint":"5","datainv":"20190911","nota":"003"}]}}';
        
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,
                                          Test_Response__c= responseApi,
                                          Test_Request__c = 'testRequest',
                                          Mock__c = false,
                                          User__c = 'CDSLF00',
                                          Password__c = 'P00FLSDC' ,
                                          Name =RientroAddendumConvenzionatoInvoker.SERVICE_NAME,
                                          Ref__c='CompassInternal',
                                          EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
        insert test1;

        ApiUtil__c uti = new ApiUtil__c(Name = 'CompassInternal' ,EndPoint__c ='https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute' ,Password__c = 'P00FLSDC',User__c = 'CDSLF00');      

        insert uti;
        
    }

    @IsTest
     public static void testOK() {


        test.startTest();
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname=RientroAddendumConvenzionatoInvoker.SERVICE_NAME;
        Test.setMock(HttpCalloutMock.class,UMR);

        RientroAddendumConvenzionatoInvoker.RientroAddendumConvenzionatoDTO dto1 = new RientroAddendumConvenzionatoInvoker.RientroAddendumConvenzionatoDTO();
        dto1.codice = '16039294';
        dto1.stato = '003';
        dto1.tipint = '5'; //required
        dto1.nota = 'nota';
        dto1.datainv = '20190911'; //required
        dto1.segnala = '';
        dto1.partimestp = '';
        RientroAddendumConvenzionatoInvoker.RientroAddendumConvenzionatoDTO[] lista = new RientroAddendumConvenzionatoInvoker.RientroAddendumConvenzionatoDTO[]{dto1};
        RientroAddendumConvenzionatoInvoker.RientroAddendumConvenzionatoRequestDTO rientro = new RientroAddendumConvenzionatoInvoker.RientroAddendumConvenzionatoRequestDTO();
        rientro.elenco = lista;
        RientroAddendumConvenzionatoInvoker.Request req = new RientroAddendumConvenzionatoInvoker.Request();
        req.rientroAddendumConvenzionatoRequest = rientro;

        RientroAddendumConvenzionatoInvoker.Response res = RientroAddendumConvenzionatoInvoker.invoke(req);
        System.debug('isOK:'+res.isOK());
        System.debug('getMessage():'+res.getMessage());
        Boolean isFound = false;
        if (res.rientroAddendumConvenzionatoResponse!=null && res.rientroAddendumConvenzionatoResponse.elenco!=null) {
            for (RientroAddendumConvenzionatoInvoker.RientroAddendumConvenzionatoDTO dto:res.rientroAddendumConvenzionatoResponse.elenco) {
                isFound = true;
            }
        }        
        test.stopTest();
        System.assert(isFound);
    }


    @IsTest 
    public static void testOK2() {

        test.startTest();
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname=RientroAddendumConvenzionatoInvoker.SERVICE_NAME;
        Test.setMock(HttpCalloutMock.class,UMR);


        RientroAddendumConvenzionatoInvoker.Response res = RientroAddendumConvenzionatoInvoker.invoke('16039294',6);
        System.debug('isOK:'+res.isOK());
        System.debug('getMessage():'+res.getMessage());
        Boolean isFound = false;
        if (res.rientroAddendumConvenzionatoResponse!=null && res.rientroAddendumConvenzionatoResponse.elenco!=null) {
            for (RientroAddendumConvenzionatoInvoker.RientroAddendumConvenzionatoDTO dto:res.rientroAddendumConvenzionatoResponse.elenco) {
                isFound = true;
            }
        }        
        test.stopTest();
        System.assert(isFound);
    }


}