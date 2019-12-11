@isTest
public class Gua_ServiceTest {
	 @isTest
    public static void getSelectOptionsTest(){
        SObject cases = new Case();
        List<String> listSelectOption = Gua_Service.getSelectOptions(cases,'Accolto__c');
        System.debug('---- list select option---'+listSelectOption);
        System.assertNotEquals(null, listSelectOption);
    }
    
    @isTest
    public static void getRecordTypeIdTest(){

       // Id recordTypId = Gua_Service.getRecordTypeId('COM_Filiali', 'Case');
       // System.assertNotEquals(null, recordTypId);
    }
}