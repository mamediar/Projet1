public class CRMReclamiInsDettagliCampiAggiuntiviCtrl {
    @AuraEnabled
    public static Map<String,List<String>> getInitValues(){
        Map<String,List<String>> res=new Map<String,List<String>>();
        Map<String,List<Schema.PicklistEntry>> valMap=new Map<String,List<Schema.PicklistEntry>>();
        valMap.put('prodVita',Case.Tipo_Prodotto_Vita__c.getDescribe().getPicklistValues());
        valMap.put('prodDanni',Case.Tipo_Prodotto_Danni__c.getDescribe().getPicklistValues());
        valMap.put('areaAz',Case.Area_Aziendale__c.getDescribe().getPicklistValues());
        valMap.put('prop',Case.Tipo_Proponente__c.getDescribe().getPicklistValues());
        valMap.put('areaProp',Case.Area_Geo_Proponente__c.getDescribe().getPicklistValues());
        valMap.put('recl',Case.Tipo_Reclamante__c.getDescribe().getPicklistValues());
        for(String k:valMap.keySet()){
            List<String> temp=new List<String>();
            for(Schema.PicklistEntry s:valMap.get(k)){
                temp.add(s.getLabel());
            }
            res.put(k,temp);
        }
        return res;
    }
    
    @AuraEnabled
    public static Map<String,String> initGestione(String recordId){
        Map<String,String> res = new Map<String,String>();
        Case c = [Select Trattabile__c, Tipo_Prodotto_Vita__c, Tipo_Prodotto_Danni__c, Area_Aziendale__c, Tipo_Proponente__c,
                  Area_Geo_Proponente__c, Tipo_Reclamante__c from Case where id =: recordId];
        
        res.put('prodVita',c.Tipo_Prodotto_Vita__c);
        res.put('prodDanni',c.Tipo_Prodotto_Danni__c);
        res.put('areaAz',c.Area_Aziendale__c);
        res.put('prop',c.Tipo_Proponente__c);
        res.put('areaProp',c.Area_Geo_Proponente__c);
        res.put('recl',c.Tipo_Reclamante__c);
        
        if(c.Trattabile__c == true)
            res.put('tratt','Trattabile');
        else
            res.put('tratt','Non Trattabile');
        
        return res;
    }
    
    @AuraEnabled
    public static void salvaReclamoCampiAggiuntiviApex(String recordId, String trattabile, String tipoProdottoVita,
                                                       String tipoProdottoDanni, String tipoProponente, String areaGeograficaProponente,
                                                       String tipoReclamante)
    { 
        /*
        Boolean boolTrattabile;
        
        if('Trattabile'.equalsIgnoreCase(trattabile))
            boolTrattabile = true;
        else
            boolTrattabile = false;
        
        Case c = new Case(Id = recordId,
                          Trattabile__c = boolTrattabile,
                          Tipo_Prodotto_Vita__c = tipoProdottoVita,
                          Tipo_Prodotto_Danni__c = tipoProdottoDanni,
                          Tipo_Proponente__c = tipoProponente,
                          Area_Geo_Proponente__c = areaGeograficaProponente,
                          Tipo_Reclamante__c = tipoReclamante
                         );
        
        update c;
        */
    }
}