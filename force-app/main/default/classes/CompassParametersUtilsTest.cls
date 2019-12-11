@isTest
public class CompassParametersUtilsTest {
    
    @isTest
    public static void test() {
        
        XCS_CompassParameters__c dataTest = new XCS_CompassParameters__c();
        dataTest.Name='Object Name';
        dataTest.Group__c = 'WS.prova.test';
        dataTest.Value__c='value';
        dataTest.Label__c='prova';
        insert dataTest; 
        
        CompassParametersUtils.getLabelFromService('prova','test','value');
        CompassParametersUtils.getValue('Object Name');
        CompassParametersUtils.getListValues('Object Name');
         CompassParametersUtils.getParameterByGroup('WS.prova.test');
    }

}