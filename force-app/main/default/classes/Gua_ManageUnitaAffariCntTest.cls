/**
 * @File Name          : Gua_ManageUnitaAffariCntTest.cls
 * @Description        : 
 * @Author             : Mame Bousso kane
 * @CreatedDate        : 09/09/2019
**/

@isTest
public class Gua_ManageUnitaAffariCntTest {
    
    @testSetup 
    static void testSetup() {
        Date myDate = Date.newInstance(1960, 2, 17);
        Account acct= new Account(FirstName='mame', LastName='kane', Sesso__pc='F', Data_Nascita__c=myDate,OCSAreaId__c=20);
        insert acct;
        
    }
    
    @isTest
    public static void getListZoneAndRegionTest(){
        List<Gua_ManageUnitaAffariCnt.dataZoneAndGegion> resultat = Gua_ManageUnitaAffariCnt.getListZoneAndRegion();
    }

    @isTest
    public static void getQueusTest(){
        Map<String ,Object> returnValue = Gua_ManageUnitaAffariCnt.getQueus();
    }
}