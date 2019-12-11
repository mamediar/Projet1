public class CRMReclamiTabReclamiAssociatiController {
    
    @AuraEnabled
    public static List<Case> doInit(String recordId){    
        List<String> ownerIdList = new List<String>();
        List<String> categoriaReclamo = new List<String>();
        Map<String,String> groupMap = new Map<String,String>();
        Map<String,String> categoriaMap = new Map<String,String>();
        
        Case reclamo = [select Numero_Reclamo__c from Case where id =: recordId];
        //String prefisso = reclamo.Numero_Reclamo__c.subString(0,4);
        List<String> prefissoSplittato = reclamo.Numero_Reclamo__c.split('-');
        
        System.debug('Tab Reclami Associati: prefisso = ' + prefissoSplittato);
        List<Case> reclamiAssociati = [select Id,NumeroPratica__c, Numero_Reclamo__c, CreatedDate, 
                                       Status, Categoria__c, ownerId, Subject, Categoria_Riferimento__c, CaseNumber
                                       from case where Numero_Reclamo__c like: prefissoSplittato[0] + '%'];  
        
        for(Case c : reclamiAssociati){
            ownerIdList.add(c.OwnerId);
            categoriaReclamo.add(c.Categoria_Riferimento__c);
        }
        
        //voglio mostrare l'owner.name del caso nella datatable.
        //Sul case recupero l owenrId, faccio una query sull oggetto group e poi uso questo trucchetto:
        //ciclo la lista, e valorizzo un campo "Sterile o non utilizzato" con il nome della coda
        //in questo caso uso il campo subject, che valorizzerò con il nome corretto
        //tutto questo perchè il campo owner.name is not writable
        
        List<Group> groupList = [SELECT id, Name FROM Group WHERE id IN: ownerIdList AND type = 'queue'];
        List<XCS_Categoria__c> categoriaList = [Select Name from XCS_Categoria__c where id in: categoriaReclamo];
        
        for(group g : groupList)
            groupMap.put(g.id, g.name);
        
        for(XCS_Categoria__c cat : categoriaList)
            categoriaMap.put(cat.id,cat.name);
        
        for(Case c : reclamiAssociati){
            if(groupMap.keySet().contains(c.ownerId))
                c.Subject = groupMap.get(c.ownerId);
            if(categoriaMap.keySet().contains(c.Categoria_Riferimento__c))
                c.Motivo__c = categoriaMap.get(c.Categoria_Riferimento__c);
        }
        
        return reclamiAssociati;
    }
    
    
    @AuraEnabled
    public static XCSMenuActionResult preRedirect(String recordId){
        
        String recordIdClean = recordId.remove('"').remove('/').trim();
        System.debug('RECORDIDCLEAN :::::::::::::::::> ' + recordIdClean);
        XCSMenuActionResult res = new XCSMenuActionResult('standard__recordPage');            
        res.getAttributes().setRecordId(recordIdClean);
        res.getAttributes().setObjectApiName(res.CASEAPINAME);	
        res.getAttributes().setActionName(res.VIEWACTION);	
        
        return res;
    }    
    
}