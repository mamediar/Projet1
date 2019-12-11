@IsTest
public with sharing class GUA_recuperaUltimePraticheCnt_Test {
    
    @IsTest
    static void retrieveAllPraticheTest(){
        
        String numPratica = '';
        String tipo ='CP';
        String codiceCliente = '';
        
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ocs.recuperaDatiPostvendita');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, mock);
            Map<String,Object> response = GUA_recuperaUltimePraticheCnt.retrieveAllPraticheCarta(numPratica,tipo,codiceCliente);
        Test.stopTest();
        
    }
    
}