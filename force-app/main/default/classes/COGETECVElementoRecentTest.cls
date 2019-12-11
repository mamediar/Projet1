@isTest
private  class COGETECVElementoRecentTest {
    
    @istest
    static void cogetiElementoRecenttest(){
      Test.startTest();
      List<COGETECVElementoRecent> mylist = new List<COGETECVElementoRecent>();
      COGETECV1Response.MFTCOECO_ELEMENTO e1 = new COGETECV1Response.MFTCOECO_ELEMENTO();
      e1.mftcoecoDATASCADENZA ='20190718';
      e1.mftcoecoSALDO = 0;
       COGETECV1Response.MFTCOECO_ELEMENTO e2 = new COGETECV1Response.MFTCOECO_ELEMENTO();
      e2.mftcoecoDATASCADENZA ='20190720';
      e2.mftcoecoSALDO = 3;
       COGETECV1Response.MFTCOECO_ELEMENTO e3 = new COGETECV1Response.MFTCOECO_ELEMENTO();
      e3.mftcoecoDATASCADENZA ='20190721';
      e3.mftcoecoSALDO = 0;
       COGETECV1Response.MFTCOECO_ELEMENTO e4 = new COGETECV1Response.MFTCOECO_ELEMENTO();
      e4.mftcoecoDATASCADENZA ='20190722';
      e3.mftcoecoSALDO = 1;
      mylist.add(new COGETECVElementoRecent(e1)); mylist.add(new COGETECVElementoRecent(e2)); mylist.add(new COGETECVElementoRecent(e3));
      mylist.add(new COGETECVElementoRecent(e4));
      System.debug('******** before sort *** '+mylist[0].mftCoecoElement.mftcoecoDATASCADENZA);
      mylist.sort();
      System.debug('******** after sort *** '+mylist[0].mftCoecoElement.mftcoecoDATASCADENZA);
      System.debug('******** after sort *** '+mylist[3].mftCoecoElement.mftcoecoDATASCADENZA);
      Test.stopTest();

    }
}