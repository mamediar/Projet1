@isTest
public  class PraticheWrapperTest {
    
    @isTest
    static void testmethode(){
        Test.startTest();
         RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO pratiche1 = new  RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO();
         pratiche1.numPratica = 'numPratica1';
         pratiche1.dataCaricamento = '20190715';

          RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO pratiche2 = new  RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO();
         pratiche2.numPratica = 'numPratica2';
         pratiche2.dataCaricamento = '20190808';
          RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO pratiche3 = new  RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO();
         pratiche3.numPratica = 'numPratica3';
         pratiche3.dataCaricamento = '20180715';

        List<PraticheWrapper> oppwList = new List<PraticheWrapper>{
         new PraticheWrapper(pratiche1),
         new PraticheWrapper(pratiche2),
          new PraticheWrapper(pratiche3)
        };
      System.debug('**************** before sort ****************** '+oppwList);
      for (PraticheWrapper p : oppwList){
          System.debug('******* numPratica '+p.pratiche.numPratica +' date '+p.pratiche.dataCaricamento);
      }
      oppwList.sort();
       System.debug('**************** after sort ****************** '+oppwList);
        for (PraticheWrapper p : oppwList){
          System.debug('******* numPratica '+p.pratiche.numPratica +' date '+p.pratiche.dataCaricamento);
      }

    System.debug('******* numPratica '+oppwList[0].pratiche.numPratica +' date '+oppwList[0].pratiche.dataCaricamento);
    System.assertEquals('numPratica2', oppwList[0].pratiche.numPratica, '***** pass ***');
    Test.stopTest();
    
    }
}