//----------------------------------------------------------------------
//-- - Author       : SANA BADJI
//-- - Date         : 15/07/2019
//-- - Description  : Handle CGMServiceWsr_1_1Test
//----------------------------------------------------------------------
@isTest
public  class CGMServiceWsr_1_1Test {
    
@TestSetup
static void makeData(){
Integer resultCode;
CGMServiceWsr_1_1.CGM_WSR_Response  cgm=  new CGMServiceWsr_1_1.CGM_WSR_Response();
cgm.resultCode=0;
cgm.resultMessage='';
cgm.errorCode='';
cgm.errorMessage='';

CGMServiceWsr_1_1.CGM_WSR_Response  cgm1=  
new CGMServiceWsr_1_1.CGM_WSR_Response(0, 'resultMessage', 'errorCode');


CGMServiceWsr_1_1.ObjectWrapper  objW=  new CGMServiceWsr_1_1.ObjectWrapper();
objW.id='';
objW.CaseNumber='';
objW.AccountId='';
//SObject obj  ;
CGMServiceWsr_1_1.ObjectWrapper  objW1=  new CGMServiceWsr_1_1.ObjectWrapper('Id');
CGMServiceWsr_1_1.ObjectWrapper  objW2=  new CGMServiceWsr_1_1.ObjectWrapper('CaseNumber',  'AccountId');
//CGMServiceWsr_1_1.ObjectWrapper  objW3=  new CGMServiceWsr_1_1.ObjectWrapper(obj);
}
@IsTest
static void objectWrapperTest(){
    Test.startTest();
  
    Test.stopTest();
}
}