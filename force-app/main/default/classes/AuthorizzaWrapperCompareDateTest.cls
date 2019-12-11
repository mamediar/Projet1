@isTest
private class AuthorizzaWrapperCompareDateTest {
    @isTest
   static void compareDateTest(){
       Test.startTest();
        RecuperaMovAutViaggiantiResponse.AutorizzazioneViaggianteDTO a1 = new RecuperaMovAutViaggiantiResponse.AutorizzazioneViaggianteDTO();
        a1.data = '20190715';
        RecuperaMovAutViaggiantiResponse.AutorizzazioneViaggianteDTO a2 = new RecuperaMovAutViaggiantiResponse.AutorizzazioneViaggianteDTO();
        a2.data = '20190714';
        RecuperaMovAutViaggiantiResponse.AutorizzazioneViaggianteDTO a3 = new RecuperaMovAutViaggiantiResponse.AutorizzazioneViaggianteDTO();
        a3.data = '20190718';
     List<AuthorizzaWrapperCompareDate> wp = new List<AuthorizzaWrapperCompareDate>{
         new AuthorizzaWrapperCompareDate(a1),
         new AuthorizzaWrapperCompareDate(a2),
         new AuthorizzaWrapperCompareDate(a3)
     };
     //  wp.add(a1);  wp.add(a2);  wp.add(a3);
        System.debug('********** before sort *********** '+wp);
        wp.sort();
        System.debug('********** after sort *********** '+wp);
        System.debug('********** recent *********** '+wp[0].authori.data);


       Test.stopTest();

   }
}