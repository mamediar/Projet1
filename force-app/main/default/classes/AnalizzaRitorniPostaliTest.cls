@IsTest(SeeAllData=true)
public class AnalizzaRitorniPostaliTest {
    
    @IsTest
    public static void analyzeRitorniPostaliTest() {
        
        try {
            
            Map<String,List<String>> serviceIdResponseMap = new Map<String,List<String>>();
            
            ApiRest__c apiRest1 = [Select id, name, EndPoint__c, Test_Response__c, Method__c, Mock__c, Password__c, Ref__c, User__c from ApiRest__c where name = 'ocs.ritorniPostaliFlagLettura'];            
            apiRest1.EndPoint__c = 'ocs.ritorniPostaliFlagLettura';
            apiRest1.Test_Response__c = '';
            apiRest1.Method__c = 'POST'; 
            apiRest1.Mock__c = false; 
            apiRest1.Password__c = 'P00FLSDC';
            apiRest1.Ref__c = 'CompassInternal'; 
            apiRest1.User__c = 'CDSLF00';
            
            update apiRest1;
            
            List<String> responses = new List<String>();
            responses.add('{"resultCode":0,"resultMessage":"Ok","esito":"","erroreProgressivo":""}');
            serviceIdResponseMap.put('ritorniPostaliFlagLettura', responses);       
            
            Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));
            test.startTest();      
            AnalizzaRitorniPostali analyze = new AnalizzaRitorniPostali();
            analyze.execute(null);
            test.stopTest();  
            
        } catch (Exception e) {
            
            e.getMessage();
            
        }
        
        
    }
    
}