@isTest
private  class RecuperaElencoMovWrapperTest {
    
    @isTest
    static void testRecuperaElencoMovWrapper(){
      Test.startTest();
       RecuperaElencoMovimentiResponse.MovimentiEstrattoContoDTO m1 = new RecuperaElencoMovimentiResponse.MovimentiEstrattoContoDTO();
       m1.dataAcquisto = '20190718';
       RecuperaElencoMovimentiResponse.MovimentiEstrattoContoDTO m2 = new RecuperaElencoMovimentiResponse.MovimentiEstrattoContoDTO();
       m2.dataAcquisto = '20190719';
       RecuperaElencoMovimentiResponse.MovimentiEstrattoContoDTO m3 = new RecuperaElencoMovimentiResponse.MovimentiEstrattoContoDTO();
       m3.dataAcquisto = '20190716';
       List<RecuperaElencoMovWrapper> listRp = new List<RecuperaElencoMovWrapper>{
           new RecuperaElencoMovWrapper(m1),
           new RecuperaElencoMovWrapper(m2),
           new RecuperaElencoMovWrapper(m3)
       };
       System.debug('*************** before sort *****'+listRp[0].movimentis.dataAcquisto);
       listRp.sort();
       System.debug('*************** after sort *****'+listRp[0].movimentis.dataAcquisto);
       System.assertEquals('20190719', listRp[0].movimentis.dataAcquisto, 'pass');
      Test.stopTest();

    }
}