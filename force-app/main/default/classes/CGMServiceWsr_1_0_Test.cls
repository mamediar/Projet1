//----------------------------------------------------------------------
//-- - Author       : SANA BADJI
//-- - Date         : 15/07/2019
//-- - Description  : Handle CGMServiceWsr_1_0_Test
//----------------------------------------------------------------------

@isTest
public  class CGMServiceWsr_1_0_Test {
    
@TestSetup
static void makeData(){
Integer resultCode;
CGMServiceWsr_1_0.CGMWSRResponse  cgm=  new CGMServiceWsr_1_0.CGMWSRResponse();
cgm.status='';
cgm.errorCode='';
cgm.errorMessage='';
cgm.errorStackTrace='';
cgm.resultCode=0;

CGMServiceWsr_1_0.CGMWSRResponse  cgm1=  
new CGMServiceWsr_1_0.CGMWSRResponse('status', 'errorCode');


CGMServiceWsr_1_0.CGMWSRResponse  objW=  new CGMServiceWsr_1_0.CGMWSRResponse
('status', 'errorCode', 'errorStackTrace');

CGMServiceWsr_1_0.CGMWSRResponse  objW1=  
new CGMServiceWsr_1_0.CGMWSRResponse('status','errorCode', 0);


CGMServiceWsr_1_0.ObjectWrapper  objW2=  new CGMServiceWsr_1_0.ObjectWrapper();
objW2.id='';
objW2.CaseNumber='';
objW2.AccountId='';

CGMServiceWsr_1_0.ObjectWrapper  objW3=  new CGMServiceWsr_1_0.ObjectWrapper('Id');
CGMServiceWsr_1_0.ObjectWrapper  objW4=  new CGMServiceWsr_1_0.ObjectWrapper('CaseNumber',  'AccountId');
//CGMServiceWsr_1_1.ObjectWrapper  objW3=  new CGMServiceWsr_1_1.ObjectWrapper(obj);
}

@IsTest
static void methodName(){
    
    Test.startTest();
    Test.stopTest();
    
}
}