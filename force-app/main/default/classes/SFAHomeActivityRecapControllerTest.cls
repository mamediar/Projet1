@isTest
public class SFAHomeActivityRecapControllerTest {
    static Id ProfileId= [select Id from Profile where Name='System Administrator'].Id;
    static User u=new User(Username='test@compass.com.test', LastName= 'test', Email= 'test@test.com', Alias= 'test', CommunityNickname= 'test', TimeZoneSidKey= 'Europe/Rome' , LocaleSidKey= 'it_IT', EmailEncodingKey= 'ISO-8859-1', ProfileId= ProfileId, LanguageLocaleKey= 'en_US');
    @TestSetup
    static void setup(){
        List<AggregateResult> l=[SELECT COUNT(id) x FROM Case];
        if(l[0].get('x')==0){
            Case a= new Case(Subject= 'SubjectTest1');
            Case b= new case(Subject= 'SubjectTest2');
            Case[] updateValues= new List<Case>();
            updateValues.add(a);
            updateValues.add(b);
            insert updateValues;
        }
    }
	@isTest
    public static void TestDoInitApexEmptyInput(){
        SFAHomeActivityRecapController.returnWrapper ret;
        System.runAs(SFAHomeActivityRecapControllerTest.u){
            Test.startTest();
            ret = SFAHomeActivityRecapController.doInitApex('');
            Test.stopTest();
        }
        System.assertEquals('Nessuna Configuazione Selezionata', ret.title); 
    }

    @isTest
    public static void TestDoInitApexWithInvalidInput(){
        SFAHomeActivityRecapController.returnWrapper ret;
        System.runAs(SFAHomeActivityRecapControllerTest.u){
            Test.startTest(); 
            ret = SFAHomeActivityRecapController.doInitApex('notFoundConfig');
            Test.stopTest();
        }
        System.assertEquals('Nessuna configurazione Corrispndente a notFoundConfig è stata trovata', ret.title);
    }

    @isTest
    public static void TestDoInitApexWithValidInput(){
        SFAHomeActivityRecapController.returnWrapper ret;
        System.runAs(SFAHomeActivityRecapControllerTest.u){
            Test.startTest(); 
            ret = SFAHomeActivityRecapController.doInitApex('forClassTest');
            Test.stopTest();
        }
        System.assertEquals('forClassTest', ret.title);
        System.assertEquals(2, ret.total);
    }
}