public class CRMReclamiInsDettagliContainerController {
	@AuraEnabled
    public static List<String> getContattiPrecedenti(){
        List<String> res=new List<String>();
        Schema.DescribeFieldResult fieldResult=Case.Contatto_Precedente__c.getDescribe();
        List<Schema.PicklistEntry> ple=fieldResult.getPicklistValues();
        for(Schema.PicklistEntry pickListVal:ple){
            res.add(pickListVal.getLabel());
        }    
        return res;
    }
}