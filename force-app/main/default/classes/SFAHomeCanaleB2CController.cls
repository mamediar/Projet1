public with sharing class SFAHomeCanaleB2CController {
    @AuraEnabled
    public static Map<String,Integer> getData() {
        Map<String,Integer> data = new Map<String,Integer>();
        Integer inadempimentiCount = [SELECT count() 
                                        FROM Case 
                                        WHERE Owner.Type='Queue' 
                                        AND Owner.Name = 'Inadempimento - Verifica Filiali'];
        data.put('inadempimentiCount', inadempimentiCount);
        return data;
    }
}