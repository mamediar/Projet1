@isTest
public class GD_CaricamentoCorsoControllerTest {

    @testSetup
    static void setup(){
        List<IVASS_Dealer_Courses__c> coursesTest = new List<IVASS_Dealer_Courses__c>();
        for(Integer i =0; i<10; i++){
        coursesTest.add(new IVASS_Dealer_Courses__c(Name ='test course '+i));
        }
        insert coursesTest;
		
    }
	@isTest
    static void testGetAllAggiungiCorso(){
        Test.startTest();
        try{
               Map<String,Object> responseTest = GD_CaricamentoCorsoController.getAllAggiungiCorso();
        }
        catch(Exception e){
           system.assert(e.getMessage().contains('Last Name'));
        }
        Test.stopTest();
         //List<IVASS_Dealer_Courses__c> recordsTest = responseTest.get('data');
    } 
    @isTest
    static void testGetAllTipologiaCorso(){
         Test.startTest();
        Map<String,Object> responseTest = GD_CaricamentoCorsoController.getAllTipologiaCorso();
        Test.stopTest();
         //List<IVASS_Dealer_Courses__c> recordsTest = responseTest.get('data');
    } 
     @isTest
    static void testGetAllDealerCourses(){
         Test.startTest();
        Map<String,Object> responseTest = GD_CaricamentoCorsoController.getAllDealerCourses();
        Test.stopTest();
         //List<IVASS_Dealer_Courses__c> recordsTest = responseTest.get('data');
    } 
     @isTest
    static void testProcessData(){
        IVASS_Dealer_Courses__c testDealerCorso = [Select Id,Name FROM IVASS_Dealer_Courses__c Limit 1];
       List<String> fieldsTest =  new List<String>();
		fieldsTest.add('test 1');       
        fieldsTest.add('test 2');    
        fieldsTest.add('test 3');    
        Id batchTest = GD_CaricamentoCorsoController.processData('Test FileData', fieldsTest, testDealerCorso);
         Test.startTest();
        Map<String,Object> responseTest = GD_CaricamentoCorsoController.isCompleted(batchTest);
        Test.stopTest();
         //List<IVASS_Dealer_Courses__c> recordsTest = responseTest.get('data');
    } 
         @isTest
    static void testGetDealers(){
        List<IVASS_Dealer_Courses__c> dealerCorsoTest =[Select Id,Name FROM IVASS_Dealer_Courses__c Limit 10];
        List<String> dealerCorsoIdTest = new  List<String>();
         List<String> dealerCorsoIdWithErrorTest = new  List<String>();
        for(IVASS_Dealer_Courses__c corso : dealerCorsoTest){
            dealerCorsoIdTest.add(corso.Id);
        }
        dealerCorsoIdWithErrorTest.add('fdfffd');
        dealerCorsoIdWithErrorTest.add('fdfffdfsdd');
         Test.startTest();
        Map<String,Object> responseTest = GD_CaricamentoCorsoController.getDealers(dealerCorsoIdTest);
         Map<String,Object> responseTestWithError = GD_CaricamentoCorsoController.getDealers(dealerCorsoIdWithErrorTest);
        Test.stopTest();
        //List<IVASS_Dealer_Courses__c> recordsTest = responseTest.get('data');
    } 
    @isTest
    static void testResearchDealerCoursesAttachments(){
         Test.startTest();
        GD_CaricamentoCorsoController.researchDealerCoursesAttachments('DEF');
        Test.stopTest(); 
        //List<IVASS_Dealer_Courses__c> recordsTest = responseTest.get('data');
    } 
}