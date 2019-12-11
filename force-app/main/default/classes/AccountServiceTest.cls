//----------------------------------------------------------------------
//-- - Author       : SANA BADJI
//-- - Date         : 30/07/2019
//-- - Description  : Handle CodaDiscordanzaCellulareTest
//----------------------------------------------------------------------
@isTest
public  class AccountServiceTest {

@TestSetup
static void makeData(){
        
    Account[] accts = new List < Account > ();

    Account a1 = new Account(
    Name = 'test1', DEM_Da_Inviare__c = false,  Codice_Cliente__c='CodiceCliente1', 
    Codice_Fiscale__c='CodiceFiscale1', BillingCity ='San Francisco', OCS_External_Id__c = 'C11911134');

    Account a2 = new Account(
    Name = 'test2', DEM_Da_Inviare__c = true, Codice_Cliente__c='CodiceCliente2', 
    Codice_Fiscale__c='CodiceFiscale2',
    BillingCity = 'San Francisco', OCS_External_Id__c = 'C11911135');

    Account a3 = new Account(
    Name = 'test3', DEM_Da_Inviare__c = false, Codice_Cliente__c='CodiceCliente3',
    Codice_Fiscale__c='CodiceFiscale3', 
    BillingCity = 'San Francisco', OCS_External_Id__c = 'C11911136');

    Account a4 = new Account(
    Name = 'test4', DEM_Da_Inviare__c = false, Codice_Cliente__c='CodiceCliente4', Codice_Fiscale__c='CodiceFiscale4',
    BillingCity = 'San Francisco', OCS_External_Id__c = 'C11911137');

    Account a5 = new Account(
    Name = 'test5', DEM_Da_Inviare__c = true, Codice_Cliente__c='CodiceCliente5',Codice_Fiscale__c='CodiceFiscale5',
    BillingCity = 'San Francisco', OCS_External_Id__c = 'C11911138');
    
    Account a6 = new Account(
    Name = 'test6' , DEM_Da_Inviare__c = true , Codice_Cliente__c = 'CodiceCliente6',Codice_Fiscale__c='CodiceFiscale6',
    BillingCity = 'San Francisco', OCS_External_Id__c = 'C11911139',RecordtypeId = getAccountRecordTypeId());

    accts.add(a1);
    accts.add(a6);
   // accts.add(a2);
    //accts.add(a3);
    //accts.add(a4);
    //accts.add(a5);

    insert accts;
    System.debug(' listAccount '+ accts );


}


@IsTest
static void getAccountByIdTest(){
  
    List<Account> listAccount = [SELECT Id  FROM Account ];
    String idAccount;
    Test.startTest();
    for(Account c : listAccount){
        System.debug('Id  '+ c.id );
        idAccount=c.Id ;
        System.debug('idAccount  '+ idAccount );
        }
    AccountService.getAccountById(idAccount);
    System.assertEquals(2, listAccount.size(), 'listCase.size()==1');
    Test.stopTest();
}

@IsTest
static void getAccountcodiceFiscaleExistTest(){
  
    List<Account> listAccount = [SELECT Id,Codice_Cliente__c, Codice_Fiscale__c  FROM Account ];
    String codiceFiscale;
    String codiceCliente;
    String idAccount;
    Test.startTest();
    for(Account c : listAccount){
        System.debug('Id  '+ c.id );
        codiceFiscale=c.Codice_Fiscale__c ;
        codiceCliente=c.Codice_Cliente__c ;
        idAccount=c.Id ;
        System.debug('codiceFiscale  '+ codiceFiscale );
        System.debug('codiceCliente  '+ codiceCliente );
        System.debug('idAccount  '+ idAccount );
        }
    AccountService.getAccount(codiceFiscale,'');
    AccountService.getAccount('',codiceFiscale,'');
    System.assertEquals(2, listAccount.size(), 'listCase.size()==1');
    Test.stopTest();
}


@IsTest
static void getAccountcodiceClienteExistTest(){
    List<Account> listAccount = [SELECT Id,Codice_Cliente__c, Codice_Fiscale__c  FROM Account limit 1];
    String codiceFiscale;
    String codiceCliente;
    String idAccount;
    Test.startTest();
    for(Account c : listAccount){
        System.debug('Id  '+ c.id );
        codiceFiscale=c.Codice_Fiscale__c ;
        codiceCliente=c.Codice_Cliente__c ;
        idAccount=c.Id ;
        System.debug('codiceFiscale  '+ codiceFiscale );
        System.debug('codiceCliente  '+ codiceCliente );
        System.debug('idAccount  '+ idAccount );
        }
    AccountService.getAccount('',codiceCliente);
    AccountService.getAccount(codiceCliente,'','');
    System.assertEquals(1, listAccount.size(), 'listCase.size()==1');
    Test.stopTest();
}



@IsTest
static void getAccountidAccountExistTest(){
    List<Account> listAccount = [SELECT Id,Codice_Cliente__c, Codice_Fiscale__c  FROM Account ];
    String codiceFiscale;
    String codiceCliente;
    String idAccount;
    Test.startTest();
    for(Account c : listAccount){
        System.debug('Id  '+ c.id );
        codiceFiscale=c.Codice_Fiscale__c ;
        codiceCliente=c.Codice_Cliente__c ;
        idAccount=c.Id ;
        System.debug('codiceFiscale  '+ codiceFiscale );
        System.debug('codiceCliente  '+ codiceCliente );
        System.debug('idAccount  '+ idAccount );
        }
    AccountService.getAccount('','',idAccount);
    System.assertEquals(2, listAccount.size(), 'listCase.size()==1');
    Test.stopTest();
}



@IsTest
static void createAccountTest(){
    Test.startTest();
    List<Account> listAccount = [SELECT Id,Codice_Cliente__c, Codice_Fiscale__c  FROM Account ];
    Account  account =[SELECT Id,Codice_Cliente__c, Codice_Fiscale__c  FROM Account limit 1 ];
    AccountService.createAccount(account);
    System.assertEquals(2, listAccount.size(), 'listCase.size()==1');
    Test.stopTest();
}

@IsTest
static void getPickListValuesIntoListTest(){
    List<Account> listAccount = [SELECT Id,Codice_Cliente__c, Codice_Fiscale__c,Occupation_Lvl1__c FROM Account ];
    String occupationLvl1c;
    Test.startTest();
    for(Account c : listAccount){
        System.debug('Id  '+ c.id );
        occupationLvl1c=c.Occupation_Lvl1__c ;
        }
    AccountService.getPickListValuesIntoList(occupationLvl1c);
    System.assertEquals(2, listAccount.size(), 'listCase.size()==1');
    Test.stopTest();
}
 
@IsTest    
static void getFilialeByNameTest()
{
    Test.startTest();
    List<Account> listAccount = [SELECT Id,Name,Codice_Cliente__c, Codice_Fiscale__c , BillingCity ,
                                        OCS_External_Id__c,RecordtypeId,Recordtype.Name
                                 FROM Account WHERE RecordtypeId =: getAccountRecordTypeId()];
    AccountService.getFilialeByName(listAccount[0].Name);
    AccountService.getFilialeById(listAccount[0].Id);
    //System.assertEquals(1, listAccount.size(), 'listCase.size()==1');
    Test.stopTest();
    
}   
    
    
static Id getAccountRecordTypeId() 
{
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Branch').getRecordTypeId();
        return RecordTypeId;
}

}