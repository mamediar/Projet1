@isTest
public class OCSDinieghiSDDFlagLetturaInvokerTest {
 
    @isTest
    public static void callFlagLetturaSDD(){
		
       
        
        String response = '{    "resultCode": 0, "resultMessage": "Ok",    "dinieghiSDDFlagLetturaResponse": {"esito": "OK","erroreCanomanProgressivo": "",       "erroreCanomanProgreMan": ""    }}';
         String canomanProgressivo = '1';
        String canomanProgreMan = '2549260';
        List<OCSDinieghiSDDFlagLetturaRequest.DiniegoSDDFlagLetturaDTO> lista = new List<OCSDinieghiSDDFlagLetturaRequest.DiniegoSDDFlagLetturaDTO>();
        OCSDinieghiSDDFlagLetturaRequest.DiniegoSDDFlagLetturaDTO dto = new OCSDinieghiSDDFlagLetturaRequest.DiniegoSDDFlagLetturaDTO();
        lista.add(dto);
        OCSDinieghiSDDFlagLetturaRequest request = new OCSDinieghiSDDFlagLetturaRequest(lista);
      

        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,ref__c = 'CompassInternal', Name ='ocs.dinieghiSDDFlagLettura',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
        ApiUtil__c test2 = new ApiUtil__c(Name = 'CompassInternal' ,EndPoint__c ='https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute' ,Password__c = 'P00FLSDC',User__c = 'CDSLF00');      
        insert test1;
        insert test2;
        Test.startTest();
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname='ocs.dinieghiSDDFlagLettura';
        Test.setMock(HttpCalloutMock.class,UMR);
        System.debug('request '+request);
        OCSDinieghiSDDFlagLetturaResponse res = OCSDinieghiSDDFlagLetturaInvoker.callFlagLetturaSDD(request);
        System.debug('response   : '+res);
        system.assertEquals('OK', res.dinieghiSDDFlagLetturaResponse.esito);
        Test.stopTest();
    }
}