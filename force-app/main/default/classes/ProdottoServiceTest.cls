@isTest
public  class ProdottoServiceTest {

    @TestSetup
    static void makeData(){
        List<Product2> listproduit = new List<Product2>{
            new Product2(Name='P1', ProductCode='145', Family='PP_ONLINE_COMPASS_DS' , Livello__c = 0 ),
            new Product2(Name='P2', ProductCode='146', Family='PP_ONLINE_PARTNER_DS' , Livello__c = 0 ),
            new Product2(Name='P3', ProductCode='147', Family='PP_ONLINE_PARTNER_DS' , Livello__c = 1 )
        };
      insert listproduit;
        
    }
    @isTest
    static void getProdottoByCodetest(){
        Test.startTest();
        Product2 p = ProdottoService.getProdottoByCode('1;145');
        System.assertEquals('PP_ONLINE_COMPASS_DS', p.Family, '****** passs ');
        Test.stopTest();

    }
    @isTest
    static void getProdottoByCodeException(){
        Test.startTest();
       Product2 p = ProdottoService.getProdottoByCode('147');
        System.assertEquals(null, p.Id, '****** passs ');
        Test.stopTest();
    }

    @isTest
    static void getProduct2test(){
        Product2 product = [select Name,Livello__c from Product2 limit 1];
        Test.startTest();
        List<Product2> listproduit = ProdottoService.getProduct2(0,product.Id);
		List<Product2> listproduit2 = ProdottoService.getProduct2(1,product.Id);

        Test.stopTest();

    }
    
    @isTest
    static void getProduct2testException(){
        Product2 product = [select Name,Livello__c from Product2 limit 1];
        Test.startTest();
        List<Product2> listproduit = ProdottoService.getProduct2(0,product.Id);
        List<Product2> listproduit2 = ProdottoService.getProduct2(1,product.Id);
        System.assertEquals(2, listproduit.size(), '** pass ** ');
        ProdottoService.getProdottoById(listproduit[0].Id);
        ProdottoService.getProdottoByCodeProdotto('145');
        Test.stopTest();

    }
    
    @isTest
    static void getProvinceCommuneAll(){

        Test.startTest();
        List<XCS_Town__c> listprovince = ProdottoService.getProvinceCommuneAll();
        System.assertEquals(0, listprovince.size(), '***** pass ');

        Test.stopTest();

    }
   
}