public class XCSScriptUtil 
{
	public static FINAL String RETENTIONSCRIPTINITIALNAME = 'RET CARTE';
    public static FINAL String RETENTIONSCRIPTALERT = 'RET CARTE ALERT';
    
    public static List<XCS_Script__c> getScriptForName(String InitialName)
    {
        String likeCondiction = InitialName + '%';
        return [SELECT Id,name, CaseActivityType__c, Text__c FROM XCS_Script__c where IsDeleted = false AND NAME Like :likeCondiction];
    }
    
    public static List<Map<String,String>> listScriptForCampaign(String codProdFiglio, String codProdPadre, String actionCode, String codTMK, String labelProd,String tipoCamp){
        List<Map<String,String>> ListscriptDataMap = new List<Map<String,String>>();
        List<XCS_Script__c> listScript = new List<XCS_Script__c>();
        if(tipoCamp == 'PP'){
           listScript= [SELECT Id,TipoCampagna__c,ActionCode__c,ActionCodeLvl2__c,Text__c,CodProd__c,CodProdLvl2__c FROM XCS_Script__c where  
        CodProdLvl2__c =:codProdFiglio and ActionCode__c =: actionCode and ActionCodeLvl2__c =: codTMK and EndDate__c > TODAY ];}
        else{
            listScript = [SELECT Id,TipoCampagna__c,ActionCode__c,ActionCodeLvl2__c,Text__c,CodProd__c,CodProdLvl2__c FROM XCS_Script__c where  
        CodProdLvl2__c =:codProdFiglio and ActionCode__c =: actionCode and EndDate__c > TODAY ];
        }
        for(XCS_Script__c scriptField: listScript){
            Map<String,String> scriptDataMap = new Map<String,String>();
            scriptDataMap.put('Id', scriptField.Id);
            scriptDataMap.put('tipologia',scriptField.TipoCampagna__c);
            scriptDataMap.put('codiceAzione',scriptField.ActionCode__c);
            scriptDataMap.put('codiceProdotto',scriptField.ActionCodeLvl2__c);
            scriptDataMap.put('codiceCRM',scriptField.CodProdLvl2__c);
            scriptDataMap.put('descrizione',labelProd);
            ListscriptDataMap.add(scriptDataMap);
        }
        
        return ListscriptDataMap;
    }
    public static List<AggregateResult> listScriptInCampaign(List<String> codProdFiglio, List<String> actionCode,List<String> codTMK, Set<Id> recId){
        List<RecordType> rec = [SELECT Name FROM RecordType where id in:recId];
        List<AggregateResult> ctrlScript = new List<AggregateResult>();
        String recPP;
        String recCC;
        for(RecordType r:rec){ if(r.Name == 'PP') recPP = r.Name; else recCC = r.Name; }
        if(String.isNotBlank(recPP)){
        ctrlScript = [SELECT Min(StartDate__c) startDate, Max(EndDate__c) endDate FROM XCS_Script__c where  
         CodProdLvl2__c in:codProdFiglio and ActionCode__c in: actionCode and ActionCodeLvl2__c in: codTMK];
        }
        if(String.isNotEmpty(recCC)){
        ctrlScript= [SELECT Min(StartDate__c) startDate, Max(EndDate__c) endDate FROM XCS_Script__c where  
         CodProdLvl2__c in:codProdFiglio and ActionCode__c in: actionCode ];
            
        }
        return ctrlScript;
    }
    
    public static List<XCS_Script__c> listScriptForSecondCtrl(List<String> codProdFiglio, List<String> actionCode,List<String> codTMK, Set<Id> recId){
        List<RecordType> rec = [SELECT Name FROM RecordType where id in:recId];
        List<XCS_Script__c> ctrlScript = new List<XCS_Script__c>();
        String recPP;
        String recCC;
        for(RecordType r:rec){ if(r.Name == 'PP') recPP = r.Name; else recCC = r.Name; }
        if(String.isNotBlank(recPP)){
        ctrlScript = [SELECT StartDate__c,EndDate__c,ActionCode__c,ActionCodeLvl2__c,CodProdLvl2__c FROM XCS_Script__c where  
         CodProdLvl2__c in:codProdFiglio and ActionCode__c in: actionCode and ActionCodeLvl2__c in: codTMK];
        }
        if(String.isNotEmpty(recCC)){
        ctrlScript= [SELECT StartDate__c,EndDate__c,ActionCode__c,ActionCodeLvl2__c,CodProdLvl2__c FROM XCS_Script__c where  
         CodProdLvl2__c in:codProdFiglio and ActionCode__c in: actionCode ];
            
        }
        return ctrlScript;
    }

    public static List<AggregateResult> listScriptForCampaign(Set<Id> idScriptNew){
        
        return [SELECT Min(StartDate__c) startDate, Max(EndDate__c) endDate FROM XCS_Script__c where id in:idScriptNew];
        
    }
 
    public static Set<CRMTelemarketingTripletta> MapTriplettaScriptForMasterCampaign(String fileTMK){
        Map<String,Boolean> triplettaMap= new Map<String,Boolean>();
        Set<String> tipoCamp = new Set<String>();
        Set<String> actionCode = new Set<String>();
        Set<String> codProd = new Set<String>();
        Set<String> codProdTMK = new Set<String>();
        List<String> triplettaString = new List<String>();
        List<AggregateResult> listConf = [SELECT TMKImportProcess__c, 
                                                ProductCode__r.RSS_External_Id__c prod,
                                                ProductCode__r.Name prodname,
                                                RecordType.Name rec, 
                                                ActionCode__c,
                                                TMKTarget__c,
                                                TMKProductCode__c, 
                                                CodPromotion__c,
                                                flagscriptassociati__c FROM Campaign where TMKImportProcess__c =:fileTMK  group by TMKImportProcess__c,ProductCode__r.RSS_External_Id__c,ProductCode__r.Name,TMKProductCode__c, CodPromotion__c, ActionCode__c,TMKTarget__c,flagscriptassociati__c,RecordType.Name
                                                order by TMKImportProcess__c,ProductCode__r.RSS_External_Id__c,ProductCode__r.Name,TMKProductCode__c, CodPromotion__c, ActionCode__c,TMKTarget__c,RecordType.Name,flagscriptassociati__c desc];
            Set<CRMTelemarketingTripletta> g = new Set<CRMTelemarketingTripletta>();
             
                for(AggregateResult d:listConf){
                    String chiave = String.valueOf(d.get('TMKProductCode__c'))+ ','
                    +String.valueOf(d.get('prod'))+','
                    +String.valueOf(d.get('ActionCode__c'));
                    triplettaMap.put(chiave, Boolean.valueOf(d.get('flagscriptassociati__c')));
                    CRMTelemarketingTripletta tripletta = new CRMTelemarketingTripletta(); 
                    tripletta.codiceTMK = String.valueOf(d.get('TMKProductCode__c'));
                    tripletta.codiceProdotto = String.valueOf(d.get('prod'));
                    tripletta.codiceAzione =String.valueOf(d.get('rec')) == 'PP'? String.valueOf(d.get('ActionCode__c')): String.valueOf(d.get('TMKTarget__c'))  ;
                    tripletta.tipologia = String.valueOf(d.get('rec'));
                    tripletta.flag = triplettaMap.get(chiave);
                    tripletta.descrizione = String.valueOf(d.get('prodname'));
                    
                    g.add(tripletta);
                    
                }
            
                System.debug(triplettaMap); 
                System.debug(g);
        return g;
    }
    public static List<XCS_Script__c> listScriptinModal(String codiceAzione, String codiceTMK,String codiceProdotto,String campType,Date startDate,Date endDate){
        /*
        List<XCS_Script__c> listFinal = new List<XCS_Script__c>();
        
        Set<XCS_Script__c> listUnique = new Set<XCS_Script__c>();
        List<XCS_Script__c> primaQuery = new List<XCS_Script__c>();
        List<XCS_Script__c> secondaQuery= new List<XCS_Script__c>();
        
        if(campType == 'PP'){
        primaQuery= [SELECT id, Text__c,CodProdLvl2__c,ActionCode__c, ActionCodeLvl2__c,EndDate__c,StartDate__c, TipoCampagna__c FROM XCS_Script__c where  
                            CodProdLvl2__c =:codiceProdotto and ActionCode__c =: codiceAzione and ActionCodeLvl2__c =: codiceTMK and TipoCampagna__c =:campType and (EndDate__c <: startDate and StartDate__c >:endDate)];
        secondaQuery = [SELECT id, Text__c,CodProdLvl2__c,ActionCode__c, ActionCodeLvl2__c,EndDate__c,StartDate__c, TipoCampagna__c FROM XCS_Script__c where  
                            CodProdLvl2__c =:codiceProdotto and ActionCode__c =: codiceAzione and ActionCodeLvl2__c =: codiceTMK and TipoCampagna__c =:campType and (EndDate__c >: startDate and StartDate__c <:endDate)];
        for(XCS_Script__c a:primaQuery){listUnique.add(a);} for(XCS_Script__c b:secondaQuery){listUnique.add(b);}
            for(XCS_Script__c r:listUnique){listFinal.add(r);}
        }
        else {
            primaQuery= [SELECT id, Text__c,CodProdLvl2__c,ActionCode__c, ActionCodeLvl2__c,EndDate__c,StartDate__c, TipoCampagna__c FROM XCS_Script__c where  
                            CodProdLvl2__c =:codiceProdotto and ActionCode__c =: codiceAzione and TipoCampagna__c =:campType and (EndDate__c <: startDate and StartDate__c >:endDate)];
        secondaQuery = [SELECT id, Text__c,CodProdLvl2__c,ActionCode__c, ActionCodeLvl2__c,EndDate__c,StartDate__c, TipoCampagna__c FROM XCS_Script__c where  
                            CodProdLvl2__c =:codiceProdotto and ActionCode__c =: codiceAzione and TipoCampagna__c =:campType and (EndDate__c >: startDate and StartDate__c <:endDate)];
        for(XCS_Script__c a:primaQuery){listUnique.add(a);} for(XCS_Script__c b:secondaQuery){listUnique.add(b);}
            for(XCS_Script__c r:listUnique){listFinal.add(r);}
            
        }
        */
        if (campType == 'PP') {
            return 
             [SELECT 
                id, 
                Text__c, 
                CodProdLvl2__c, 
                ActionCode__c, 
                ActionCodeLvl2__c, 
                StartDate__c, 
                EndDate__c, 
                TipoCampagna__c 
            FROM XCS_Script__c 
            WHERE  
                TipoCampagna__c =:campType and 
                CodProdLvl2__c =:codiceProdotto and 
                ActionCode__c =: codiceAzione and 
                ActionCodeLvl2__c =: codiceTMK and 
                EndDate__c > :startDate ];
        }
        else { // CC
            return
            [SELECT 
                id, 
                Text__c,
                CodProdLvl2__c,
                ActionCode__c, 
                ActionCodeLvl2__c,
                EndDate__c,
                StartDate__c, 
                TipoCampagna__c 
            FROM XCS_Script__c 
            WHERE  
                TipoCampagna__c =:campType and
                CodProdLvl2__c =:codiceProdotto and 
                ActionCode__c =: codiceAzione and 
                EndDate__c > :startDate ];
        }
       // return listFinal;
    }
    
    public static String preScript(String codPromotion){
        return [SELECT Text__c FROM XCS_Script__c where sectioncode__c =: codPromotion and  SectionType__c = 'PRE'].Text__c;
    }
    public static String scriptEDI0C(String codPromotion){
        return [SELECT Text__c FROM XCS_Script__c where sectioncode__c =:codPromotion].Text__c;
    }
}