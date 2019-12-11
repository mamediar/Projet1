public class CRMReclamiInsDettagliAttribReclCtrl {
	@AuraEnabled
    public static List<Map<String,String>> getAttribuz(){
        List<Map<String,String>> res=new List<Map<String,String>>();
        Schema.DescribeFieldResult fieldResult=Case.Attribuzione__c.getDescribe();
        List<Schema.PicklistEntry> ple=fieldResult.getPicklistValues();
        for(Schema.PicklistEntry k:ple){
            res.add(new Map<String,String>{'label'=>k.getLabel(),'value'=>k.getLabel()});
        } 
        return res;
    }
}