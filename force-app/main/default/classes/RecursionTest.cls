//----------------------------------------------------------------------
//-- - Author       : SANA BADJI
//-- - Date         : 02/08/2019
//-- - Description  : Handle Trigger RecursionTest
//----------------------------------------------------------------------
@IsTest
public  class RecursionTest {


@IsTest
static void test()
{
    Test.startTest();
   // Recursion recur= new Recursion();
    Recursion.isTriggerExecuting=false;
    Recursion.isBeforeTriggerExcecuting=true;
    System.assert(Recursion.isTriggerExecuting!=true,'') ;
    Test.stopTest();

}
}