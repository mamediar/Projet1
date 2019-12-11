//----------------------------------------------------------------------
//-- - Author       : SANA BADJI
//-- - Date         : 15/07/2019
//-- - Description  : Handle WS_RecuperaInfoInserimentoBloccoTest
//----------------------------------------------------------------------
@isTest
public  class COGETECV1Test {
    
    @TestSetup
    static void makeData(){
    //String response = '{"resultCode": 0,"resultMessage": "Ok","OCS_COGETEC_V1": {"movimenti": [{ "dataValuta": "20180131","dataRegistrazione": "20180108","dataAcquisto": "20180103","causale": "10","importo": "1275"}]}}';

    String response = '{"resultCode": 0,"resultMessage": "Ok","cogetecv1Response": {"mftcoecoOCCURS": [{"mftcoecoELEMENTO": [{"mftcoecoPARTITA": 1,"mftcoecoPARTITATIPO": "RP","mftcoecoIMPORTO": 53530,"mftcoecoIMPORTOS": "","mftcoecoNUMERORATA": "1","mftcoecoSALDOS": ""}]}]}}';
    ApiRest__c apiRest = new ApiRest__c(Method__c = 'POST',
                                        Test_Response__c= response,
                                        Test_Request__c = 'testRequest',
                                        Mock__c = false, 
                                        User__c = 'CDSLF00',
                                        Password__c = 'P00FLSDC' ,
                                        Name ='OCS_COGETEC_V1',
                                        EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
    insert apiRest;  
    System.debug('apiRest '+ apiRest);
    }

    @isTest   static void testInvoke(){
        
        Test.startTest();
        UtilityMockResponse UTM = new UtilityMockResponse();
        UTM.apiname ='OCS_COGETEC_V1';
        Test.setMock(HttpCalloutMock.class, UTM);
        COGETECV1Response resp2 =
        COGETECV1Service.buildCOGETECV1Response(
            '16132993',null,null,null,null,null, null, null,
                                                    null,
                                                    null,
                                                    null,
                                                    null,
                                                    null,
                                                    null,
                                                    '12',
                                                '',
                                                'ES');
                                                System.debug('****************** resp2 '+ resp2);
    //     System.debug(' ************** resp2 ' +resp2);
        // List<COGETECV1Response.MFTCOECO_ELEMENTO> listmftcoecoELEMENTO = 
        //         mftcoECO.mftcoecoELEMENTO;
        // COGETECV1Response.MFTCOECO_ELEMENTO mftcoecoELEMENTO= new COGETECV1Response.MFTCOECO_ELEMENTO();
        // mftcoecoELEMENTO.mftcoecoPARTITA=1;
        // mftcoecoELEMENTO.mftcoecoPARTITATIPO='RP';
        // mftcoecoELEMENTO.mftcoecoIMPORTO=53530;
        // mftcoecoELEMENTO.mftcoecoIMPORTOS='';
        // mftcoecoELEMENTO.mftcoecoNUMERORATA='1';
        // mftcoecoELEMENTO.mftcoecoDATASCADENZA=20160615;
        // mftcoecoELEMENTO.mftcoecoMORAMATURATA=0;
        // mftcoecoELEMENTO.mftcoecoSALDO=0;
        // mftcoecoELEMENTO.mftcoecoSALDOS='';
        // listmftcoecoELEMENTO.add(mftcoecoELEMENTO);

    //     System.assertEquals(1, listmftcoecoELEMENTO[0].mftcoecoPARTITA,'') ;
    //     System.assertEquals('RP', listmftcoecoELEMENTO[0].mftcoecoPARTITATIPO,'') ;
    //     System.assertEquals(53530, listmftcoecoELEMENTO[0].mftcoecoIMPORTO,'') ;
    //     System.assertEquals('', listmftcoecoELEMENTO[0].mftcoecoIMPORTOS,'') ;
    //     System.assertEquals('1', listmftcoecoELEMENTO[0].mftcoecoNUMERORATA,'') ;
    //     System.assertEquals(20160615, listmftcoecoELEMENTO[0].mftcoecoDATASCADENZA,'') ;
    //     System.assertEquals(0, listmftcoecoELEMENTO[0].mftcoecoMORAMATURATA,'') ;
    //     System.assertEquals(0, listmftcoecoELEMENTO[0].mftcoecoSALDO,'') ;
    //     System.assertEquals('', listmftcoecoELEMENTO[0].mftcoecoSALDOS,'') ;
    //     System.debug('****** listmftcoecoELEMENTO '+ listmftcoecoELEMENTO);
    //     System.debug('****** resp2 '+ resp2);
        Test.stopTest();
    }

    @isTest
        static void validateResponsetest(){
        Test.startTest();
        String jsonString = '{"resultCode":1,"resultMessage": "KO","cogetecv1Response": {"mftcoecoOCCURS": [],"mfterrOMSFERROCCURS": null,\n'+
                '"msfologonERROREDES": "","msfologonSTATUS": "","msfologonSESSIONID": "","msfologonERRORE": ""}}';
        System.debug(' ************** jsonString ' +jsonString);
        COGETECV1Response response = (COGETECV1Response) JSON.deserializeStrict(jsonString, COGETECV1Response.class);
        Boolean bool=COGETECV1Service.validateResponse(response);
        System.debug(' ************** bool ' +bool);
        System.assertEquals(false, bool,'') ;
        Test.stopTest();
        }
        @isTest
        static void getElementoWithSoldeZerotest(){
        //  Test.startTest();
            List<COGETECV1Response.MFTCOECO_ELEMENTO> mylist = new List<COGETECV1Response.MFTCOECO_ELEMENTO>();
        COGETECV1Response.MFTCOECO_ELEMENTO e1 = new COGETECV1Response.MFTCOECO_ELEMENTO();
        e1.mftcoecoDATASCADENZA ='20190718';
        e1.mftcoecoSALDO = 0;
        COGETECV1Response.MFTCOECO_ELEMENTO e2 = new COGETECV1Response.MFTCOECO_ELEMENTO();
        e2.mftcoecoDATASCADENZA ='20190720';
        e2.mftcoecoSALDO = 3;
        COGETECV1Response.MFTCOECO_ELEMENTO e3 = new COGETECV1Response.MFTCOECO_ELEMENTO();
        e3.mftcoecoDATASCADENZA ='20190721';
        e3.mftcoecoSALDO = 0;
        COGETECV1Response.MFTCOECO_ELEMENTO e4 = new COGETECV1Response.MFTCOECO_ELEMENTO();
        e4.mftcoecoDATASCADENZA ='20190722';
        e4.mftcoecoSALDO = 1;
        mylist.add(e1); mylist.add(e2); mylist.add(e3);
        mylist.add(e4);
        List<COGETECV1Response.MFTCOECO_ELEMENTO> test = COGETECV1Service.getElementoWithSoldeZero(mylist);
        System.debug('************* size '+test.size());
        for(COGETECV1Response.MFTCOECO_ELEMENTO e : test){
            System.debug('xxxxx ele'+e.mftcoecoDATASCADENZA);
            }

    
        }
        
}