@isTest
private  class MovementiWrapperCompareDateTest {
    
    @isTest
    static void movementiWrapperCompareDatetest(){
       Test.startTest();
        RecuperaMovAutViaggiantiResponse.MovimentoViaggianteDTO m1 = new RecuperaMovAutViaggiantiResponse.MovimentoViaggianteDTO();
        m1.dataOperazione ='20190714';
         RecuperaMovAutViaggiantiResponse.MovimentoViaggianteDTO m2 = new RecuperaMovAutViaggiantiResponse.MovimentoViaggianteDTO();
        m2.dataOperazione ='20190718';
         RecuperaMovAutViaggiantiResponse.MovimentoViaggianteDTO m3 = new RecuperaMovAutViaggiantiResponse.MovimentoViaggianteDTO();
        m3.dataOperazione ='20190716';

        List<MovementiWrapperCompareDate> listMovi = new List<MovementiWrapperCompareDate>{
            new MovementiWrapperCompareDate(m1),
            new MovementiWrapperCompareDate(m2),
            new MovementiWrapperCompareDate(m3)
        };
        listMovi.sort();
        System.debug('************ recent movimenti **** '+listMovi[0].movementi.dataOperazione);

       Test.stopTest();

    }
}