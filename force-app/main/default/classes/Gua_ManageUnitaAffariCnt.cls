/**
 * @File Name          : Gua_ManageUnitaAffariCnt.cls
 * @Description        : 
 * @Author             : Mame Bousso kane
 * @CreatedDate        : 09/09/2019
 */

public class Gua_ManageUnitaAffariCnt {
    
   @AuraEnabled
    public static List<dataZoneAndGegion> getListZoneAndRegion(){
        Map<String,List<Account>> resultats= new Map<String,List<Account>>();
        List<dataZoneAndGegion> listdt= new List<dataZoneAndGegion>();
        List<Account> accounts = new List<Account>();
        
        try {
            accounts = Gua_ManageUnitaAffariQuery.getAccount();
        } catch (Exception e) {
            System.debug('Gua_ManageUnitaAffariCnt getListZoneAndRegion error '+ e.getMessage()+' '+ e.getLineNumber());
        }
       if(accounts.size()>0){
            for(Account accnt : accounts){
                if(!resultats.containsKey(accnt.Region_Name__c)){
                    resultats.put(accnt.Region_Name__c, new List<Account>());
                }
                resultats.get(accnt.Region_Name__c).add(accnt);
            }
           for (String key : resultats.keySet()) {
               List<DataZone> dataZones = new List<DataZone>();
               for(Account act: resultats.get(key)){
                   if(act.OCSAreaId__c!=null)
                   dataZones.add(new DataZone(''+act.OCSAreaId__c,''+act.Id));
               }
               if(resultats.get(key)[0].OCSAreaId__c!=null)
               listdt.add(new dataZoneAndGegion(key,dataZones));
		   }

        }else{
            resultats=null;
        }
        return listdt;
    }
    
    @AuraEnabled
    public static Map<String ,Object> getQueus(){
        Map<String ,Object> returnValue = new  Map<String ,Object>();
        returnValue.put('erreur', false);
       try {
           List<Group> queus = Gua_ManageUnitaAffariQuery.getQueus();
           returnValue.put('resultat',queus);
       } catch (Exception e) {
            System.debug('errorMessage Gua_ManageUnitaAffariCnt Gua_ManageUnitaAffariCnt '+e.getMessage());
             returnValue.put('message', e.getMessage()+' '+e.getCause()+' '+e.getLineNumber());
             returnValue.put('erreur', true);
       }
        return returnValue;
    }
    
    public class dataZoneAndGegion{
        @AuraEnabled
        public String Region {set;get;}
        @AuraEnabled
        public List<DataZone> listData {set;get;}
        
        public dataZoneAndGegion(String Region,List<DataZone> listData){
            this.Region=Region;
        	this.listData=listData;
        }
    }
    public class DataZone{
        @AuraEnabled
        public String label {set;get;}
        @AuraEnabled
        public String value {set;get;}
        
        public DataZone(String label,String value){
            this.label=label;
            this.value=value;
        }
    }
}