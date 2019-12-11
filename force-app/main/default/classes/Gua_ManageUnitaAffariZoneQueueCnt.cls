/**
 * @File Name          : Gua_ManageUnitaAffariZoneQueueCnt
 * @Description        : Class for Managing Gestione Unita
 * @Author             : Abdoulaye DIOP (AD)
 * @CreatedDate        : 16/09/2019
**/
public with sharing class Gua_ManageUnitaAffariZoneQueueCnt {
    
    /**
     * @author AD
     * @date  16/09/2019
     * @description Method used to get Region_Name__c values
     * @param none
     **/
    @AuraEnabled
    public static Map<String, Object> getRegionNameValues(String pageSize, String pageNumber){
        Map<String, Object> response = new Map<String, Object>();
        try {
            Account acc = new Account();
            List<String> regions = Gua_Service.getSelectOptions(acc, 'Region_Name__c');
            List<Account> areasAffari = Gua_AccountQuery.getAreaAffari(pageSize, pageNumber);
            response.put('oldAreasAffari', areasAffari);
            response.put('regions', regions);
            response.put('error', false);
        } catch (Exception e) {
            response.put('regions', null);
            response.put('error', true);
        }
        return response;
    }

    /**
     * @author AD
     * @date  17/09/2019
     * @description Method used to save zone to queue when Account recordTypeName is Branch
     * @param List<Account> areasAffari, the list of unita affari
     **/
    @AuraEnabled
    public static Map<String, Object> saveZonesToQueue(List<Account> areasAffari){
        Map<String, Object> response = new Map<String, Object>();
        try {
            Id recordTypeId = Gua_Service.getRecordTypeId('Branch', 'Account');
            Set<String> newNameSet = new Set<String>();
            Set<String> newRegionSet = new Set<String>();
            Set<Decimal> newOCSAreaIdSet = new Set<Decimal>();
            for (Account newAreaAffari: areasAffari) {
                newNameSet.add(newAreaAffari.Name);
                newRegionSet.add(newAreaAffari.Region_Name__c);
                newOCSAreaIdSet.add(newAreaAffari.OCSAreaId__c);
            }
            
            List<Account> oldAreasAffari = [SELECT Id, Name, Region_Name__c, OCSAreaId__c FROM Account WHERE recordTypeId =:recordTypeId AND
             (Name IN :newNameSet OR Region_Name__c IN :newRegionSet OR OCSAreaId__c IN :newOCSAreaIdSet)];

            for (Account areaAffari : areasAffari) {
                for (Account oldAreaAffari : oldAreasAffari) {
                    if (areaAffari.Name == oldAreaAffari.Name && areaAffari.Region_Name__c == oldAreaAffari.Region_Name__c && areaAffari.OCSAreaId__c == oldAreaAffari.OCSAreaId__c) {
                        response.put('message', 'the region '+ areaAffari.Region_Name__c +' with the area '+
                         areaAffari.OCSAreaId__c +' and the Queue '+ areaAffari.Name +' already exist');
                        response.put('error', true);
                        return response;
                    }
                }
                areaAffari.recordTypeId = recordTypeId;
            }
            upsert areasAffari;
            response.put('areasAffari', areasAffari);
            response.put('error', false);
        } catch (Exception e) {
            response.put('message', e.getCause() +' '+ e.getMessage()+ ' '+ e.getLineNumber());
            response.put('error', true);
        }
        return response;
    }

    /**
     * @author AD
     * @date  26/09/2019
     * @description Method used to delete unita affari
     * @param String id, the id of the unita affari to delete
     **/
    @AuraEnabled
    public static Map<String, Object> deleteZoneToQueue(String id) {
        Map<String, Object> response = new Map<String, Object>();
        try {
            Account acc = [SELECT Id FROM Account WHERE Id =:id];
            delete acc;
            response.put('error', false);
        } catch (Exception e) {
            response.put('message', e.getCause() +' '+ e.getMessage()+ ' '+ e.getLineNumber());
            response.put('error', true);
        }
        return response;
    }

    /**
     * @author AD
     * @date  02/10/2019
     * @description 
     * @param none
     **/
    @AuraEnabled
    public static Map<String, Object> getAreaAffari(String pageSize, String pageNumber){
        Map<String, Object> response = new Map<String, Object>();
        try {
            Account acc = new Account();
            List<Account> areasAffari = Gua_AccountQuery.getAreaAffari(pageSize, pageNumber);
            response.put('oldAreasAffari', areasAffari);
            response.put('error', false);
        } catch (Exception e) {
            response.put('error', true);
            response.put('message', e.getCause() +' '+ e.getMessage()+ ' '+ e.getLineNumber());
        }
        return response;
    }
}