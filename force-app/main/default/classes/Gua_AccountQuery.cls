/**
 * @File Name          : Gua_AccountQuery
 * @Description        : Class for Managing Account Query
 * @Author             : Abdoulaye DIOP (AD)
 * @CreatedDate        : 16/09/2019
**/
public with sharing class Gua_AccountQuery {
    
    /**
     * @author AD
     * @date  20/09/2019
     * @description 
     * @param none
     **/
    public static List<Account> getAreaAffari(){
        String name = 'Affari e Delibere%';
        Id recordTypeId = Gua_Service.getRecordTypeId('Branch', 'Account');
        List<Account> areasAffari = [SELECT Id, Name, Region_Name__c, OCSAreaId__c FROM Account 
                    WHERE recordTypeId =:recordTypeId AND Name LIKE :name];
        return areasAffari;
    }

    /**
     * @author AD
     * @date  02/10/2019
     * @description 
     * @param String pageSize
     * @param String pageNumber
     **/
    public static List<Account> getAreaAffari(String pageSize, String pageNumber){
        Integer psize = Integer.valueOf(pageSize);
        Integer pnumber = Integer.valueOf(pageNumber)-1;
        String name = 'Affari e Delibere%';
        Id recordTypeId = Gua_Service.getRecordTypeId('Branch', 'Account');
        List<Account> areasAffari = [SELECT Id, Name, Region_Name__c, OCSAreaId__c FROM Account WHERE Name LIKE :name 
                     AND recordTypeId =:recordTypeId LIMIT :Integer.valueOf(psize) OFFSET :(psize*pnumber)];
        return areasAffari;
    }
}