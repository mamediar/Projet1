@isTest
    public class GD_PersonAccountRecordIvassCntrTest {
    @testSetup
    static void setup(){
        /*RecordType rt = new RecordType(Name ='Person Account');
        insert rt;*/
       
       Account a = new Account(Name = 'testName');
        insert a;
        List<IVASS_Dealer_courses_script_risp__c> coursesScript = new  List<IVASS_Dealer_courses_script_risp__c>();
        for(Integer i=0;i<10;i++){
            coursesScript.add(new IVASS_Dealer_courses_script_risp__c(Risposta__c = 'risposte '+i));
        }
        insert coursesScript;
        List<IVASS_Dealer_courses_script_option__c> coursesScriptOpt =new List<IVASS_Dealer_courses_script_option__c>();
        for(Integer i=0;i<10;i++){
            coursesScriptOpt.add(new IVASS_Dealer_courses_script_option__c(Id_risp__c=i,User_question__c='questio '+i));
        }
        insert coursesScriptOpt;
        List<IVASS_Dealer_courses_answer_group__c> coursesAnswer = new List<IVASS_Dealer_courses_answer_group__c>();
        for(Integer i=0;i<10;i++){
            coursesAnswer.add(new IVASS_Dealer_courses_answer_group__c(Type__c='ALL_ISCR',Id_Option__c=i));
        }
        insert coursesAnswer;
    }
    @isTest
    static void testGetPersonAccountById(){
       Account accountTest = [Select Id,Name,Codice_Fiscale__c, PersonBirthdate FROM Account Limit 1];
        Test.startTest();
        //	GD_PersonAccountRecordIvassController.getPersonAccountById(accountTest.Id);
         RecordType rt = [Select Id,Name FROM recordtype where name = 'person account'];
       	 accountTest.RecordtypeId = rt.Id;
      	GD_PersonAccountRecordIvassController.getPersonAccountById(accountTest.Id);
        Test.stopTest();
    }
     @isTest
    static void testGetAllRisposta(){
        Test.startTest();
      	 GD_PersonAccountRecordIvassController.getAllRisposta();
        Test.stopTest();
    }
     @isTest
    static void testGetIscrittiByReferente(){
        Test.startTest();
      	 GD_PersonAccountRecordIvassController.getIscrittiByReferente('DEF');
        Test.stopTest();
    }
    @isTest
    static void testGetIscrittiByReferenteIsStatoNotIscritto(){
        Test.startTest();
      	 GD_PersonAccountRecordIvassController.getIscrittiByReferenteIsStatoNotIscritto('DEF');
        Test.stopTest();
    }
    @isTest
    static void testGetCoursesAnswerInTypeForMyType(){
        Test.startTest();
      	 GD_PersonAccountRecordIvassController.getCoursesAnswerInTypeForMyType('ALL_ISCR');
        Test.stopTest();
    }



}