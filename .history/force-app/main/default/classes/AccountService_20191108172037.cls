public with sharing class AccountService {
    
    /**
    * @description get Account by this Id
    *
    * @param idAccount :  Id account
    *
    * @return Account
    */
    public static Account getAccountById(String idAccount){
            Account acc = new Account();
                try {
                    acc = [SELECT Id,PersonEmail, Codice_Cliente__c,Codice_Fiscale__pc,LastName, FirstName,Phone,Data_Nascita__c,PersonMobilePhone,
                    Sesso__pc,Provincia_Nascita__pc,Luogo_Nascita__pc FROM Account WHERE Id =: idAccount];     
                } 
                catch (Exception e) {
                    System.debug('errorMessage getAccountById '+e.getMessage() );
                }
                return acc;
        }

/**
  * @description search account by codice Fiscal/ Codice Cliente 
  *
  * @param codiceFiscale : Codice Fiscale
  *
  * @param  codeCliente : Codice Cliente
  *
  * @return a Account
  */
   public static Account getAccount(String codiceFiscale, String codeCliente){
       System.debug(' **************** getAccount ********* ');
       Account account = new Account();
       if (!String.isBlank(codiceFiscale))  {
      
            account = [SELECT Id, Codice_Cliente__c, Codice_Fiscale__pc FROM Account WHERE 	Codice_Fiscale__pc =: codiceFiscale];   
            System.debug('case with codice fiscale ' + account);
            return account;
       }
       else if (!String.isBlank(codeCliente)){
            account = [SELECT Id, Codice_Cliente__c, Codice_Fiscale__pc FROM Account WHERE Codice_Cliente__c =: codeCliente]; 
            System.debug(' case with codice cliente ' + account);

            return account;
       }

      return account;
   } 

	/*
  * @description search account by codice Fiscal/ Codice Cliente / Case ID
  *
  * @param codiceFiscale : Codice Fiscale
  * @param  codeCliente : Codice Cliente
  * @param   accountId : the Id of Account
  *
  */
    public static Account getAccount(String codeCliente, String codiceFiscale,String accountId){
       Account account = new Account();
       if (!String.isBlank(codiceFiscale))  {
      
            account = [SELECT Id, Codice_Cliente__c, Codice_Fiscale__pc FROM Account WHERE 	Codice_Fiscale__pc =: codiceFiscale];   
            System.debug('case with codice fiscale ' + account);
            return account;
       }
       else if (!String.isBlank(accountId)){
            account = [SELECT Id, Codice_Cliente__c, Codice_Fiscale__pc FROM Account WHERE Id =: accountId]; 
            System.debug(' case with account Id ' + account); 
            return account;
       }
       else if (!String.isBlank(codeCliente)){
            account = [SELECT Id, Codice_Cliente__c, Codice_Fiscale__pc FROM Account WHERE Codice_Cliente__c =: codeCliente]; 
            System.debug(' case with codice cliente ' + account);
            return account;
       }
      return account;
   }  
	@AuraEnabled
	public static  String getPickListValuesIntoList(String apiName){
           String value='' ;
	       List<String> pickListValuesList= new List<String>();
	        Schema.DescribeFieldResult fieldResult = Account.Occupation_Lvl1__c.getDescribe();
	        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
	        for( Schema.PicklistEntry pickListVal : ple){
                 System.debug(pickListVal.getValue());
                 if(pickListVal.getValue() == apiName){
                     value =  pickListVal.getLabel();
                    break;
                 }
	           
	        }    
	        return value;
}
    /**
    *@Description: add new account
    */
    @AuraEnabled
    public static Account createAccount(Account account){
         try {
             insert account;
         } catch (Exception e) {
             System.debug('errorMessage AccountService createAccount '+e.getMessage());
        }
        return account;
     }
    @AuraEnabled
    public static Account getFilialeByName(String nameFialiale){
            Account account = new Account();
                try {
                    account = [SELECT Id,Name, LastName, FirstName,Phone,CittaSede__pc,OCS_External_Id__c,
                    			Sesso__pc,Provincia_Nascita__pc,Luogo_Nascita__pc,BillingAddress
                           		FROM Account WHERE RecordType.Name='Branch'
                                AND Name=:nameFialiale];     
                } 
                catch (Exception e) {
                    System.debug('errorMessage getFilialeByName '+e.getMessage() );
                }
                return account;
        }

    @AuraEnabled
    public static Account getFilialeById(String idFialiale){
            Account account = new Account();
                try {
                    account = [SELECT Id,Name, LastName, FirstName,Phone,CittaSede__pc,OCS_External_Id__c,
                    			Sesso__pc,Provincia_Nascita__pc,Luogo_Nascita__pc,BillingAddress
                           		FROM Account WHERE RecordType.Name='Branch'
                                AND Id=:idFialiale];     
                } 
                catch (Exception e) {
                    System.debug('errorMessage getFilialeByName '+e.getMessage() );
                }
                return account;
        }
}