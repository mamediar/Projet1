@isTest
public  class Schedulable_Di_Allineam_Test {
    

    @TestSetup
    static void makeData(){
            List<Product2> listproduit = new List<Product2>{
            new Product2(Name='Produit1', Family='PF_ECOMMERCE_STANDARD'),
            new Product2(Name='Produit2', Family='PP_ONLINE_PARTNER_DS'),
            new Product2(Name='Produit3', Family='PP_ONLINE_COMPASS_DS'),
            new Product2(Name='Produit4', Family='PF_ECOMMERCE_STANDARD'),
            new Product2(Name='Produit5', Family='PP_ONLINE_PARTNER_DS'),
            new Product2(Name='Produit6', Family='PP_ONLINE_COMPASS_DS'),
            new Product2(Name='Produit7', Family='PP_ONLINE_COMPASS_DS'),
            new Product2(Name='Produit8', Family='PP_ONLINE_COMPASS_DS'),
            new Product2(Name='Produit9', Family='PP_ONLINE_COMPASS_DS'),
            new Product2(Name='Produit10', Family='PF_ECOMMERCE_STANDARD'),
            new Product2(Name='Produit11', Family='PF_ECOMMERCE_STANDARD')
    };
    insert listproduit;
   //******************************************** 
 
   List<Case> listCases = new List<Case>{
       new Case(Product__c=listproduit[0].Id, Status='On Hold', NumeroPratica__c='18866725'),
       new Case(Product__c=listproduit[1].Id, Status='Closed', NumeroPratica__c='18866725'),
       new Case(Product__c=listproduit[2].Id, Status='Closed' , NumeroPratica__c='18866725xx'),
       new Case(Product__c=listproduit[3].Id, Status='Gestito', NumeroPratica__c='18866725'),
       new Case(Product__c=listproduit[4].Id, Status='Closable', NumeroPratica__c='18866725xx'),
       new Case(Product__c=listproduit[5].Id, Status='Pending', NumeroPratica__c='18866725'),
       new Case(Product__c=listproduit[6].Id, Status='Gestito', NumeroPratica__c='18866725'),
       new Case(Product__c=listproduit[7].Id, Status='On Hold', NumeroPratica__c='18866725'),
       new Case(Product__c=listproduit[8].Id, Status='Gestito', NumeroPratica__c='18866725'),
       new Case(Product__c=listproduit[9].Id, Status='Gestito', NumeroPratica__c='18866725'),
       new Case(Product__c=listproduit[10].Id, Status='On Hold', NumeroPratica__c='18866725')
   };
    insert  listCases;
      String response = '{"resultCode": 0,"resultMessage": "Ok","recuperaPraticheAggiornateResponse": {"elenco": [{"numPratica": "18866725","statoAttuale": "20","attributoAttuale": "RT","dataUltimoAggiornamento": "20180525","oraUltimoAggiornamento": "22552902"}]}}';
         ApiRest__c test2 = new ApiRest__c(Method__c = 'POST' ,
                                           Test_Response__c= response ,
                                           Test_Request__c = 'testRequest',
                                            Mock__c = false, 
                                            User__c = 'CDSLF00',
                                            Password__c = 'P00FLSDC' ,
                                            Name ='recuperaPraticheAggiornate',
                                            EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
         
           insert test2;  
           System.debug(' ************** test2 '+test2);
        
    }
    
    @isTest
    static void schedulable_Di_Allineamento_executeTest(){
     Test.startTest();
      UtilityMockResponse UMR = new UtilityMockResponse();
      UMR.apiname='recuperaPraticheAggiornate';
      Test.setMock(HttpCalloutMock.class,UMR);
     // String query = 'SELECT Id, Status FROM Case WHERE Product__r.Family= \'PP_ONLINE_COMPASS_DS\'  AND Status!=\'Gestito\'';
      String executionDate  = CGMWSUtils_1_0.formatDate(Datetime.now(), 3);
      System.schedule('testSchedulable', executionDate,  new Schedulable_Di_Allineamento_Stato_OCS_Pr() );
      Test.stopTest();
    }

   
}