/**
 * @File Name          : Gua_ManageUnitaAffariZoneQueueCntTest
 * @Description        : Class for testing Gua_ManageUnitaAffariZoneQueueCnt
 * @Author             : Abdoulaye DIOP (AD)
 * @CreatedDate        : 20/09/2019
**/
@isTest
public with sharing class Gua_ManageUnitaAffariZoneQueueCntTest {
    
    @TestSetup
    static void makeData(){
        Id recordTypeId = Gua_Service.getRecordTypeId('Branch', 'Account');
        Account acc1 = new Account(Name='Affari e Delibere 1', Region_Name__c = 'RA', OCSAreaId__c=16, recordTypeId = recordTypeId);
        Account acc2 = new Account(Name='Affari e Delibere 1', Region_Name__c = 'RA', OCSAreaId__c=17, recordTypeId = recordTypeId);
        List<Account> unitaAffari = new List<Account>();
        unitaAffari.add(acc1);
        unitaAffari.add(acc2);
        insert unitaAffari;
    }

    /**
     * @author AD
     * @date  23/09/2019
     * @description
     **/
    @isTest
    static void getRegionNameValuesTest(){
        String pageSize = '5';
        String pageNumber = '1';
        Test.startTest();
            Map<String, Object> response = Gua_ManageUnitaAffariZoneQueueCnt.getRegionNameValues(pageSize, pageNumber);
        Test.stopTest();
        List<String> regions = (List<String>) response.get('regions');
        System.assertNotEquals(0, regions.size());
        System.assertEquals(false, response.get('error'));
    }

    /**
     * @author AD
     * @date  14/10/2019
     * @description
     **/
    @isTest
    static void getAreaAffariTest(){
        String pageSize = '5';
        String pageNumber = '1';
        Test.startTest();
            Map<String, Object> response = Gua_ManageUnitaAffariZoneQueueCnt.getAreaAffari(pageSize, pageNumber);
        Test.stopTest();
        List<Account> oldAreasAffari = (List<Account>) response.get('oldAreasAffari');
        System.assertNotEquals(0, oldAreasAffari.size());
        System.assertEquals(false, response.get('error'));
    }

    /**
     * @author AD
     * @date  20/09/2019
     * @description Method used to test saveZonesToQueue
     **/
    @isTest
    static void saveZonesToQueueTest(){
        Id recordTypeId = Gua_Service.getRecordTypeId('Branch', 'Account');
        Account acc1 = new Account(Name='Affari e Delibere 1', Region_Name__c = 'RA', OCSAreaId__c=18, recordTypeId = recordTypeId);
        List<Account> unitaAffari = new List<Account>();
        unitaAffari.add(acc1);
        Test.startTest();
            Map<String, Object> response1 = Gua_ManageUnitaAffariZoneQueueCnt.saveZonesToQueue(unitaAffari);
            Map<String, Object> response2 = Gua_ManageUnitaAffariZoneQueueCnt.saveZonesToQueue(unitaAffari);
        Test.stopTest();
        List<Account> areasAffari = (List<Account>) response1.get('areasAffari');
        System.assertEquals(false, response1.get('error'));
        System.assertNotEquals(0, areasAffari.size());
        System.assertEquals(true, response2.get('error'));
    }

    /**
     * @author AD
     * @date  26/09/2019
     * @description Method used to test delete Unita Affari
     **/
    @isTest
    static void deleteZonesToQueueTest(){
        Id recordTypeId = Gua_Service.getRecordTypeId('Branch', 'Account');
        Account acc1 = [SELECT Id FROM Account WHERE RecordTypeId =:recordTypeId LIMIT 1]; 
        Test.startTest();
            Map<String, Object> response = Gua_ManageUnitaAffariZoneQueueCnt.deleteZoneToQueue(acc1.Id);
        Test.stopTest();
        System.assertEquals(false, response.get('error'));
    }
}