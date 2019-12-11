@isTest
public  class AnomalieDocServiceTest {
    
    
     @TestSetup
    static void makeData(){
         List<Case> cases = new List<Case>{
         new Case(NumeroPratica__c='10000008',RO_Vecchio_Cellulare__c='773739676'),
         new Case(NumeroPratica__c='100',RO_Vecchio_Cellulare__c='773739676')
     };
     insert cases;
    XCS_CompassParameters__c cp = new XCS_CompassParameters__c(Name='Number_of_hours', Execution_Anomalie_Batch_Time__c=2);
    insert cp;

    List<Anomalie_Doc__c> anomalies = new List<Anomalie_Doc__c>{
         new Anomalie_Doc__c(CaseId__c= Cases[0].Id , Descrizione_Anomalia_Op__c='des' ),
         new Anomalie_Doc__c(CaseId__c= cases[1].Id , Descrizione_Anomalia_Op__c='des' )
     };
     insert anomalies;
   
        
    }

    @isTest
    static void checkAnomalietest(){
        XCS_CompassParameters__c cp =  XCS_CompassParameters__c.getValues('Number_of_hours');
        cp.Execution_Anomalie_Batch_Time__c = 4;
        Test.startTest();
         List<Anomalie_Doc__c> anomalies = [SELECT Id , Descrizione_Anomalia_Op__c FROM Anomalie_Doc__c];
         Boolean b = AnomalieDocService.checkAnomalie(anomalies);
         System.assertEquals(true, b, '*  pass ');

        Test.stopTest();

    }
    @isTest
    static void gestatoAnomalieDoctest(){
        List<Anomalie_Doc__c> anomalies = [SELECT Id,codice_Anomalia__c , Descrizione_Anomalia_Op__c FROM Anomalie_Doc__c];
        Test.startTest();
        AnomalieDocService.gestatoAnomalieDoc(anomalies);
        System.assertNotEquals(0, anomalies.size(), '*  pass ');

        Test.stopTest();

    }
   
   @isTest
   static void insertAnomaliesTest(){
        List<Case> cases = new List<Case>{
         new Case(NumeroPratica__c='10000008',RO_Vecchio_Cellulare__c='773739676'),
         new Case(NumeroPratica__c='100',RO_Vecchio_Cellulare__c='773739676')
     };
     insert cases;
    List<Anomalie_Doc__c> anomalies = new List<Anomalie_Doc__c>{
         new Anomalie_Doc__c(CaseId__c= Cases[0].Id , Descrizione_Anomalia_Op__c='des1' ),
         new Anomalie_Doc__c(CaseId__c= cases[1].Id , Descrizione_Anomalia_Op__c='des2' )
     };

       Test.startTest();
       Map<String, Object>  returnValue = AnomalieDocService.insertAnomalies(anomalies);
       System.debug('################## returnValue '+ ((List<Anomalie_Doc__c>) returnValue.get('anomalies')).size() );
       System.assertEquals(2, ((List<Anomalie_Doc__c>) returnValue.get('anomalies')).size(), '######### passs');
       Test.stopTest();
   }
   @isTest
   static void insertAnomaliesExceptionTest(){
        List<Anomalie_Doc__c> anomalies = [SELECT Id,codice_Anomalia__c , Descrizione_Anomalia_Op__c FROM Anomalie_Doc__c];
       Test.startTest();
        Map<String, Object>  returnValue = AnomalieDocService.insertAnomalies(anomalies);
        System.debug('############### exception '+returnValue.get('exception'));
        System.assertEquals(true, returnValue.get('exception'), '########## passs');

       Test.stopTest();
   }
}