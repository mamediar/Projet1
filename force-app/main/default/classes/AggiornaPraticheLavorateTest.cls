@IsTest(SeeAllData=true)
public class AggiornaPraticheLavorateTest {
    
    @IsTest
    public static void updateWorkedPracticesTest() {
        
        try {
            
            Map<String,List<String>> serviceIdResponseMap = new Map<String,List<String>>();
            
            ApiRest__c apiRest1 = [Select id, name, EndPoint__c, Test_Response__c, Method__c, Mock__c, Password__c, Ref__c, User__c from ApiRest__c where name = 'ocs.sbloccaRitorniPostali']; 
            
            apiRest1.EndPoint__c = 'ocs.sbloccaRitorniPostali';
            apiRest1.Test_Response__c = '';
            apiRest1.Method__c = 'POST'; 
            apiRest1.Mock__c = false; 
            apiRest1.Password__c = 'P00FLSDC';
            apiRest1.Ref__c = 'CompassInternal'; 
            apiRest1.User__c = 'CDSLF00';
            
            //update apiRest1; 
            
            List<String> responses = new List<String>();
            responses.add('{"resultCode":0,"resultMessage":"Ok","numRigheElaborate":"0"}');
            serviceIdResponseMap.put('sbloccaRitorniPostali', responses);
            //serviceIdResponseMap.put(apiRest1.EndPoint__c, responses);
            
            //System.Database.setSavepoint();
            
            Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));
            test.startTest();
            AggiornaPraticheLavorate updatePractices = new AggiornaPraticheLavorate();
            updatePractices.execute(null);
            test.stopTest(); 
            
        } catch (Exception e) {
            
            e.getMessage();
            
        } 
        
        
    }
    
}