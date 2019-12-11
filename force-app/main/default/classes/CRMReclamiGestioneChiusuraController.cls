public class CRMReclamiGestioneChiusuraController {
    
    @AuraEnabled
    public static Map<String,List<Object>> getInitValues(case idcase){
        
        Map<String,List<Object>> res=new Map<String,List<Object>>();
        List<String> accolto =new List<String>();
        Schema.DescribeFieldResult fieldResultMod=Case.Accolto__c.getDescribe();
        List<Schema.PicklistEntry> ple=fieldResultMod.getPicklistValues();
        for(Schema.PicklistEntry pickListVal:ple){
            accolto.add(pickListVal.getLabel());
        }
        
        List<String> Decisione =new List<String>();
        Schema.DescribeFieldResult fieldResultModD=Case.Decisione__c.getDescribe();
        List<Schema.PicklistEntry> pleD=fieldResultModD.getPicklistValues();  
        for(Schema.PicklistEntry pickListVal:pleD){
            Decisione.add(pickListVal.getLabel());
        }
        
        List<String> InterventoAut =new List<String>();
        Schema.DescribeFieldResult fieldResultModI=Case.Intervento_Autorita__c.getDescribe();
        List<Schema.PicklistEntry> pleI=fieldResultModI.getPicklistValues();  
        for(Schema.PicklistEntry pickListVal:pleI){
            InterventoAut.add(pickListVal.getLabel());
        }
        
        List<String> Sic =new List<String>();
        Schema.DescribeFieldResult fieldResultModSic=Case.SIC__c.getDescribe();
        List<Schema.PicklistEntry> pleSic=fieldResultModSic.getPicklistValues();  
        for(Schema.PicklistEntry pickListVal:pleSic){
            Sic.add(pickListVal.getLabel());
        }
        
        List<String> SocietaAss =new List<String>();
        Schema.DescribeFieldResult fieldResultModAss=Case.Societa_Assicurative__c.getDescribe();
        List<Schema.PicklistEntry> pleAss=fieldResultModAss.getPicklistValues();  
        for(Schema.PicklistEntry pickListVal:pleAss){
            SocietaAss.add(pickListVal.getLabel());
        }
        
        List<String> SocietaRec =new List<String>();
        Schema.DescribeFieldResult fieldResultModRec=Case.Societa_di_Recupero__c.getDescribe();
        List<Schema.PicklistEntry> pleRec=fieldResultModRec.getPicklistValues();  
        for(Schema.PicklistEntry pickListVal:pleRec){
            SocietaRec.add(pickListVal.getLabel());
        }
        
        List<String> Responsabilita = AccountUtils.parsgetBranchFromId(XCSReclamiUtils.parsResponsabilitaBranch(idcase));
         
        res.put('Responsabilita',Responsabilita);
        res.put('SocietaRec',SocietaRec);
        res.put('SocietaAss',SocietaAss);
        res.put('Sic',Sic);   
        res.put('InterventoAut',InterventoAut);  
        res.put('decisione',Decisione);  
        res.put('accolto',accolto);
        
        System.debug('------------------------CHIUSURA--------------------');
        System.debug('res = ' + res);

        
        return res;
        
    }
}