//----------------------------------------------------------------------
//-- - Author       : Aminata GUEYE
//-- - Date         : 06/11/2019
//-- - Description  : Handle GUA_GUA_Dettaglio_DealerCntTest
//----------------------------------------------------------------------
@isTest
public class GUA_Dettaglio_DealerCntTest {

    @TestSetup
static void makeData(){
    
    Account[] acc = new List < Account > ();

    Account a1 = new Account(
    Name = 'acc1');
    acc.add(a1);
    insert acc;

    System.debug(' listAccount '+ acc );

     List<Case> c = new List<Case>{ new Case(
         CodiceDealer__c='400000',
        AccountId = acc[0].Id)
        };
        insert c;  
        System.debug(' case '+ c );

}
    @IsTest
static void getCaseDetailTest(){
    Test.startTest();
    List<Account> listAcc = [SELECT Id,Name  ,BillingCity  FROM Account ];
    String accountId = listAcc[0].Id;
    List<Case> listCase= GUA_Dettaglio_DealerCnt.getCaseDetail(accountId);
    
    System.assertEquals(0, listCase.size(), 'listCase.size()==1');
    Test.stopTest();
}

}