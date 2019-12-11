@IsTest
public  class RecuperaDatiCatColDealerRuoliInvokerTest {


    @isTest static void testOK() {

        String responseApi = '{"resultCode":0,"resultMessage":"Ok","recuperaDatiCatenaCollegatiDealerRuoliResponse":{"elenco":[{"codCollegato":"5149594","ragioneSociale":"DAIUL ERNESTO ALDO","cognome":"DAIUL","nome":"ERNESTO ALDO","dataApertura":"20070418"}]}}';
        
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,
                                          Test_Response__c= responseApi,
                                          Test_Request__c = 'testRequest',
                                          Mock__c = false,
                                          User__c = 'CDSLF00',
                                          Password__c = 'P00FLSDC' ,
                                          Name =RecuperaDatiCatColDealerRuoliInvoker.SERVICE_NAME,
                                          Ref__c='CompassInternal',
                                          EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
        insert test1;

        ApiUtil__c uti = new ApiUtil__c(Name = 'CompassInternal' ,EndPoint__c ='https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute' ,Password__c = 'P00FLSDC',User__c = 'CDSLF00');      

        insert uti;
        test.startTest();
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname=RecuperaDatiCatColDealerRuoliInvoker.SERVICE_NAME;
        Test.setMock(HttpCalloutMock.class,UMR);
        RecuperaDatiCatColDealerRuoliInvoker.Response res = RecuperaDatiCatColDealerRuoliInvoker.invoke('14498');
        System.debug('isOK:'+res.isOK());
        System.debug('getMessage():'+res.getMessage());
        boolean isFound=false;
        if (res.RecuperaDatiCatenaCollegatiDealerRuoliResponse!=null && res.recuperaDatiCatenaCollegatiDealerRuoliResponse.elenco!=null) {
            for (RecuperaDatiCatColDealerRuoliInvoker.DatiCatenaCollegatiDealerRuoliDTO dto:res.recuperaDatiCatenaCollegatiDealerRuoliResponse.elenco) {
               isFound=true;
            }
        }   
        system.assert(isFound);   
        test.stopTest();

    }


    @isTest static void readDTO() {
        test.startTest();
        RecuperaDatiCatColDealerRuoliInvoker.DatiCatenaCollegatiDealerRuoliDTO dto = new RecuperaDatiCatColDealerRuoliInvoker.DatiCatenaCollegatiDealerRuoliDTO();
        System.debug(dto.codConvenzionato);
        System.debug(dto.codFiscale);
        System.debug(dto.codIscrizioneIvass);
        System.debug(dto.cognome);
        System.debug(dto.dataApertura);
        System.debug(dto.dataChiusura);
        System.debug(dto.dataConvenzione);
        System.debug(dto.dataNascita);
        System.debug(dto.email);
        System.debug(dto.flagPresenzaAnagrafica);
        System.debug(dto.firmatario);
        System.debug(dto.flagPresenzaEsponentiBanca);
        System.debug(dto.indirizzo);
        System.debug(dto.localita);
        System.debug(dto.luogoNascita);
        System.debug(dto.nome);
        System.debug(dto.note1);
        System.debug(dto.note2);
        System.debug(dto.piva);
        System.debug(dto.provincia);
        System.debug(dto.provNascita);
        System.debug(dto.sesso);
        System.debug(dto.socio);
        System.debug(dto.tipoFirma);
        System.debug(dto.tipoIntermediario);
        System.debug(dto.titolare);
        System.debug(dto.codAgente);
        System.debug(dto.cap);
        System.debug(dto.paeseEstero);
        System.debug(dto.dataIscrizioneIvass);
        System.debug(dto.dataScadenzaIscrizioneIvass);
        System.debug(dto.flagPresenzaProtesti);    
        System.debug(dto.codCollegato);
        System.debug(dto.ragioneSociale);         
        System.debug(dto.referente); 
        System.debug(dto.responsabileISVAP);   
        System.debug(dto.codIntermediario);                 
        test.stopTest();
    }
}