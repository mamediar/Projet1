@isTest
    private class Schedulable_AutomaticaRichOnlineTest {
        
        @TestSetup
        static void setup(){
        System.debug('***************** hello **************** ');
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
        new Case(Product__c=listproduit[0].Id),
        new Case(Product__c=listproduit[1].Id),
        new Case(Product__c=listproduit[2].Id),
        new Case(Product__c=listproduit[3].Id),
        new Case(Product__c=listproduit[4].Id),
        new Case(Product__c=listproduit[5].Id),
        new Case(Product__c=listproduit[6].Id),
        new Case(Product__c=listproduit[7].Id),
        new Case(Product__c=listproduit[8].Id),
        new Case(Product__c=listproduit[9].Id),
        new Case(Product__c=listproduit[10].Id)
        };
        insert  listCases;
        Test.setCreatedDate(listCases[0].Id, DateTime.newInstance(2019,07,21));
        Test.setCreatedDate(listCases[2].Id, DateTime.newInstance(2019,05,12));
        Test.setCreatedDate(listCases[3].Id, DateTime.newInstance(2019,06,04));
        Test.setCreatedDate(listCases[6].Id, DateTime.newInstance(2019,07,22));
        Test.setCreatedDate(listCases[7].Id, DateTime.newInstance(2019,07,22));
        Test.setCreatedDate(listCases[8].Id, DateTime.newInstance(2019,06,17));
        Test.setCreatedDate(listCases[9].Id, DateTime.newInstance(2019,06,19));
        Test.setCreatedDate(listCases[10].Id, DateTime.newInstance(2019,07,27,17,05,11));
        /**   date d = system.today().addDays(-7);
        Compass_query__c  compassQuer  = new  Compass_query__c (Name='Case_with_empty_numberPratica', query__c='SELECT Id, CreatedDate,Status, Product__r.Family, NumeroPratica__c FROM Case WHERE NumeroPratica__c= null AND  CreatedDate <= :d AND  ( Product__r.Family=\'PP_ONLINE_COMPASS_DS\' OR Product__r.Family=\'PP_ONLINE_PARTNER_DS\')');
        insert compassQuer; */
}







        @isTest
        static void testSchedulable(){
        Test.startTest();
        Schedulable_chuisuraAutomaticaRichOnline sh = new Schedulable_chuisuraAutomaticaRichOnline();
        String sch = '0  00 1 3 * ?';
        System.schedule('jobName', sch, sh);
        Test.stopTest();
        }

        @isTest
        static void testSchedulableNight(){
            Test.startTest();
             Schedulable_chuisuraAutomaticaRichOnline sh = new Schedulable_chuisuraAutomaticaRichOnline();
             String sch = '0  00 1 3 * ?';
             sh.currentDateTime = Datetime.newInstance(2019, 07, 27, 22, 15, 25);
             System.schedule('jobName', sch, sh);

            Test.stopTest();
        }

    }