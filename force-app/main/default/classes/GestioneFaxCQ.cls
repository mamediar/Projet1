public class GestioneFaxCQ {
     
    public class ConfigurazioneCoda{                
        
        String queueId;
        String queueDeveloperName;	//developerName della coda associata alla email
        Double limitN; 				//calcoloco del check e del fax (algoritmo a fine classe)
        String queueCsi; 	//coda di CQ
        String queueCsiId;
        String idConfig;
        
        List<Case> toUpdate = new List<Case>();
        
        public Integer addCase(Case c){            
            Integer result = 0;
            if(limitN > 0){
                toUpdate.add(c);
                limitN--;
                result = 1;
            }
            return result;
        }
        
        public void changeOwner(Case c, String newOwnerId, String idConfig,recordtype rt){
            
            c.ownerId = newOwnerId;
            c.Queue_Mail_Fax_Config__c  = idConfig;
            c.status = 'Controllo qualità in corso';
            c.ProcessType__c = 'FaxCQ_Da_Controllare';
            c.recordtypeId = rt.id;
        }
    }
    
    public void execute(){ 
       
       	
        // Preparo e instanzio i dati necessari
        List<CRMFax_GroupCategoryProduct__c> listGroupCatProd = [SELECT Id, categoryId__r.External_id__c, groupid__r.External_Id__c, productid__r.Rss_External_Id__c FROM CRMFax_GroupCategoryProduct__c];
        List<CRMFax_Group__c> listGroup = [SELECT NumeroAttualeCampione__c, CampioneDaLavorare__c, prodottiGruppo__c, TotaliUltimo6Mesi__c, Fax_max__c, Fax_min__c, Outsourcer__c, External_Id__c, Id FROM CRMFax_Group__c];
        List<Case> listChildCaseToCQ = new List<Case>();
        List<Case> listParentCaseToCQ = new List<Case>();
        List<Task> taskToUpdate = new List<Task>();
        Set<String> listToQueryParentId = new Set<String>();
        List<String> listToQueryGroup = new List<String>();
        List<Group> listQueue = new List<Group>();
        List<CRM_QueueMailFaxConfig__c> config = [Select id,Queue_CSI__c, 
                                                  Queue_Outsourcer__c, 
                                                  DeveloperName__c from CRM_QueueMailFaxConfig__c 
                                                  where (Queue_CSI__c != null or
                                                         Queue_CSI__c != '') 
                                                  and (Queue_Outsourcer__c != null or
                                                       Queue_Outsourcer__c != '')
                                                  and type__c = 'fax'];    
        Map<Decimal,Integer> mapGroupRemainToSend = new Map<Decimal,Integer>();
        Map<Decimal,CRMFax_Group__c> mapGroup = new Map<Decimal,CRMFax_Group__c>();
        Map<String,Decimal> mapCatProdGroup = new Map<String,Decimal>();
        Map<String,CRM_QueueMailFaxConfig__c> mapConfig = new Map<String,CRM_QueueMailFaxConfig__c>();
        Map<String,Group> mapNameQueue = new Map<String,Group>();
        Map<Id,Group> mapIdQueue = new Map<Id,Group>();

        Integer dayToday = date.today().day() > 28 ? 28 : date.today().day();
        Integer arroundCaseTo = 0;
        Id rtFaxEmail = recordtypeUtil.getRecordType(recordtypeutil.API_NAME_CASE,'CRM_Gestione_Email' );
        Id rtCQ = recordtypeUtil.getRecordType(recordtypeutil.API_NAME_CASE,'CRM_Attivita_CQ');
        Id rTask = recordtypeUtil.getRecordType('Task','Attivita_Controllo_Qualita_Fax');
       	For(CRM_QueueMailFaxConfig__c conf : config)
        {
          	mapConfig.put(conf.DeveloperName__c,conf);
            listToQueryGroup.add(conf.DeveloperName__c);
            listToQueryGroup.add(conf.Queue_CSI__c);
        }
        listQueue = groupUtils.getQueueList(listToQueryGroup);
        For(Group g : listQueue)
        {
        	mapIdQueue.put(g.id,g);
            mapNameQueue.put(g.DeveloperName,g);
        }
		For(CRMFax_Group__c gr : listGroup)
        {
           if(dayToday == 1)
           {
               gr.NumeroAttualeCampione__c = 0;
               gr.TotaliUltimo6Mesi__c = 0;
           }
           arroundCaseTo =  Integer.valueOf(math.ceil(((gr.CampioneDaLavorare__c < gr.Fax_min__c ? gr.Fax_min__c : gr.CampioneDaLavorare__c > gr.Fax_max__c ? gr.Fax_max__c : gr.CampioneDaLavorare__c)/28)*dayToday )- gr.NumeroAttualeCampione__c);
           if(arroundCaseTo > 0)
           {
            	 mapGroupRemainToSend.put(gr.External_Id__c,arroundCaseTo); 
           }
           mapGroup.put(gr.External_Id__c,gr);
        }
        For(CRMFax_GroupCategoryProduct__c crPrCat : listGroupCatProd)
        {
           mapCatProdGroup.put(crPrCat.categoryId__r.External_id__c + '-' + crPrCat.productid__r.Rss_External_Id__c,crPrCat.groupid__r.External_Id__c); 
        }
        System.debug('MappaGroup' + mapGroupRemainToSend);
        System.debug('MappaCatProd' + mapCatProdGroup);
        
       	
        List<Case> caseFigli = [select Id,parentId,categoria_riferimento__r.External_Id__c,product__r.RSS_External_Id__c,ProcessType__c  from Case where  
                   ParentId != null
                   and Parent.RecordtypeId = :rtFaxEmail
				   AND Parent.Status = 'Gestito'
                   AND CALENDAR_MONTH(CreatedDate) = :Date.today().month() 
                   AND CALENDAR_YEAR(CreatedDate) = :Date.today().Year()
				   order by parentId];        
        
        if(dayToday == 1)
        {
            List<Case> caseSixMonth = [select Id,parentId,status,categoria_riferimento__r.External_Id__c,product__r.RSS_External_Id__c,ProcessType__c  from Case where  
                   ParentId != null
                   AND Parent.RecordtypeId = :rtCQ
                   AND CreatedDate = LAST_N_MONTHS:6
                   order by parentId];
            For(Case c : caseSixMonth)
            {
               	if(mapCatProdGroup.get(c.categoria_Riferimento__r.External_Id__c +'-'+c.product__r.RSS_External_Id__c) != null)
                {
                    mapGroup.get(mapCatProdGroup.get(c.categoria_Riferimento__r.External_Id__c +'-'+c.product__r.RSS_External_Id__c)).TotaliUltimo6Mesi__c ++;
                }
            }
            
        }
     /*   List<Case> caseFigli = [select Id,parentId,parent.ownerid,status,categoria_riferimento__r.External_Id__c,product__r.RSS_External_Id__c,ProcessType__c  from Case where  
                   ParentId != null
                   AND Parent.RecordtypeId = :rtFaxEmail
                   AND Parent.Status = 'Gestito'
                   order by parentId];        */
        System.debug('caseFigli ' + CaseFigli);
        For(Case c : caseFigli)
        {
            if(!mapGroupRemainToSend.isEmpty())
            {
                if(mapCatProdGroup.get(c.categoria_Riferimento__r.External_Id__c +'-'+c.product__r.RSS_External_Id__c) != null)
                {
                    Integer i = mapGroupRemainToSend.get(mapCatProdGroup.get(c.categoria_Riferimento__r.External_Id__c +'-'+c.product__r.RSS_External_Id__c));
                    if( i != null)
                    {
                        listChildCaseToCQ.add(caseChildToCQ(c,rtCQ,mapNameQueue.get(
                                                        mapConfig.get(
                                                            mapIdQueue.get(
                                                                c.parent.OwnerId).DeveloperName).Queue_CSI__c).id));
                        taskToUpdate.add(createTask(c.id,rTask));
                        listToQueryParentId.add(c.parentid);
                        i--;
                        mapGroup.get(mapCatProdGroup.get(c.categoria_Riferimento__r.External_Id__c +'-'+c.product__r.RSS_External_Id__c)).NumeroAttualeCampione__c ++;
                        if(i == 0)
                        {
                            mapGroupRemainToSend.remove(mapCatProdGroup.get(c.categoria_Riferimento__r.External_Id__c +'-'+c.product__r.RSS_External_Id__c));
                        }
                        else
                        {
                            mapGroupRemainToSend.put(mapCatProdGroup.get(c.categoria_Riferimento__r.External_Id__c +'-'+c.product__r.RSS_External_Id__c),i);
                        }
                    }
                }
			}
            else
            {
                break;
            }
        }
        
        listParentCaseToCQ = [Select id,ownerId from case where id in : listToQueryParentId];
        System.debug('********* Parent' + listParentCaseToCQ);
        for(Case parent : listParentCaseToCQ)
        {
        	caseParentToCQ(
                									parent,
                									mapNameQueue.get(
                                                        mapConfig.get(
                                                            mapIdQueue.get(
                                                                parent.OwnerId).DeveloperName).Queue_CSI__c).id,
                									mapConfig.get(mapIdQueue.get(parent.OwnerId).DeveloperName).id,
                									rtCQ
            									 );
                                  	 
        }
        
        System.debug('List ACTIVITY *************' + listChildCaseToCQ);
        System.debug('List PARENT ACTIVITY @@@@@@@@@@@@@' + listParentCaseToCQ);
        System.debug('List TASK #############' + taskToUpdate);
        
        for(Decimal d : mapGroupRemainToSend.keyset())
        {
            System.debug('MapRemains : ' + d + ' Values:' + mapGroupRemainToSend.get(d));
        }
        
        System.debug('MapRemains : ' + mapGroupRemainToSend);
        Update listChildCaseToCQ;
        Update listParentCaseToCQ;
        Update mapGroup.values();
        Insert taskToUpdate;
        
        /* 
        List<ConfigurazioneCoda> codaConfigList = new List<ConfigurazioneCoda>();   
        List<String> queueDevNameAll = new List<String>();
        List<String> ownerIdQueueCase = new List<String>();
        List<Case> caseToUpdate = new List<Case>();
        map<String,ConfigurazioneCoda> ownerToConfig = new  map<String,ConfigurazioneCoda>();
        List<Task> taskToUpdate = new List<Task>();
        list<CRM_QueueMailFaxConfig__c> configToUpdate = new List<CRM_QueueMailFaxConfig__c>();
        
        List<CRM_QueueMailFaxConfig__c> config = [Select id,Fax_to_check__c,Queue_CSI__c, 
                                                  Queue_Outsourcer__c, Checked_in_this_month__c, 
                                                  DeveloperName__c from CRM_QueueMailFaxConfig__c 
                                                  where (Queue_CSI__c != null or
                                                         Queue_CSI__c != '') 
                                                  and (Queue_Outsourcer__c != null or
                                                       Queue_Outsourcer__c != '')
                                                  and type__c = 'fax' and Fax_to_check__c > 0];              
        
        System.debug('inizio configurazione : configurazioni trovate = ' + config);
        
        Double globalConta = 0;
        
        for(CRM_QueueMailFaxConfig__c q : config){            
            ConfigurazioneCoda tmpCoda = new ConfigurazioneCoda();        
            tmpCoda.queueDeveloperName = q.DeveloperName__c;           
            tmpCoda.limitN = calculateNumberCase((Double)q.Checked_in_this_month__c,(Double)q.Fax_to_check__c); 
            globalConta += tmpCoda.limitN;                        
            tmpCoda.queueCsi = q.Queue_CSI__c;
            codaConfigList.add(tmpCoda);                  
            queueDevNameAll.add(q.developerName__c);
            queueDevNameAll.add(q.Queue_CSI__c);
            q.Checked_in_this_month__c = tmpCoda.limitN;
            configToUpdate.add(q);
            tmpCoda.idConfig = q.id;
        }
        update configToUpdate;
        
        System.debug('ConfigurazioneCoda settate allo step 1 : ' + codaConfigList);
        
        List<Group> code = [Select id, name, developerName from group
                            where developerName in: queueDevNameAll
                            and Type = 'Queue'];
        
        for(Group g : code){
            for(ConfigurazioneCoda confCoda : codaConfigList){ 
                if(confCoda.queueDeveloperName == g.DeveloperName)
                    confCoda.queueId = g.id;
                if(confCoda.queueCsi == g.DeveloperName)
                    confCoda.queueCsiId = g.id; 
            }                        
        } 
        
        for(ConfigurazioneCoda cd : codaConfigList)
            ownerIdQueueCase.add(cd.queueId);
        
        /* CONDIZIONE VERA DA USARE
        List<Case> caseToCheck = [Select id,ownerId, status from case
                                  where ownerId in: ownerIdQueueCase 
                                  and IsClosed = true
                                  and CreatedDate = LAST_MONTH order by ownerId];        
        */
        // usato per i test in quanto la created date deve essere di almeno un mese fa
        /*
         List<Case> caseToCheck = [Select id,ownerId, status from case
                                  where ownerId in: ownerIdQueueCase 
                                  and IsClosed = true
                                 ];
        
        System.debug('caseToCheck recuperati : ' + caseToCheck);        
        System.debug('ConfigurazioneCoda settate allo step 2 : ' + codaConfigList);
        
        
        RecordType rActivity = [select id, developerName from recordType 
                        where developerName = 'CRM_Attivita_CQ' AND SobjectType ='Case'];
        
        
        for(ConfigurazioneCoda confCoda : codaConfigList)
            ownerToConfig.put(confCoda.queueId,confCoda);        
        
        for(Case c : caseToCheck){         
            if(ownerToConfig.get(c.ownerId).queueId == c.ownerId){                
                globalConta -= ownerToConfig.get(c.ownerId).addCase(c);
                ownerToConfig.get(c.ownerId).changeOwner(c,ownerToConfig.get(c.ownerId).queueCsiId,ownerToConfig.get(c.ownerId).idConfig,rActivity);
                if(globalConta == 0)
                    break;                    
            }           
        }              
        
        for(String s : ownerToConfig.keySet())
            caseToUpdate.addAll(ownerToConfig.get(s).toUpdate);             
        
        System.debug('caseToUpdate' + caseToUpdate);
        
        update caseToUpdate;
        
        RecordType r = [select id, developerName from recordType 
                        where developerName = 'Attivita_Controllo_Qualita_Fax'];
       
        List<Case> caseActivity = [Select id,RecordTypeId From Case Where parentid IN :caseToUpdate];
        
        for(Case c: caseActivity){ 
          	c.RecordTypeId = rActivity.Id;
            c.ProcessType__c = 'FaxCQ_Da_Controllare';
            c.Status = 'Controllo qualità in corso';
            taskToUpdate.add(createTask(c.id,r.id));
          //taskToUpdate.add(createTask(c.id,r.id,c.ownerId));            
        }
        update caseActivity;
        insert taskToUpdate;
        */
    }
    
    public Double calculateNumberCase(Double casiControllati, Double casiDaControllare){
        
        final  integer ultimoGiornoUtileDelMese = 27; 
        Double casi = 0;
        for(integer i=1;i<=31; i++ ){        
            if(i==1){
                casiControllati = 0;      
            }            
            if(i>ultimoGiornoUtileDelMese){
                Continue;
            }
            
            casi = ((casiDaControllare  )*i/(ultimoGiornoUtileDelMese ))-casiControllati ;           
            system.debug(casi);
            
            if(casi>=1)
                casiControllati +=(integer)casi;
            
        }
        system.debug('casiControllati: '+casiControllati );  
        
        return casi;
    }
    
    public Case caseParentToCQ(Case c, String newOwnerId, String idConfig,Id rt)
    {
        c.ownerId = newOwnerId;
        c.Queue_Mail_Fax_Config__c  = idConfig;
        c.status = 'Controllo qualità in corso';
        c.ProcessType__c = 'FaxCQ_Da_Controllare';
        c.recordtypeId = rt;
        return c;
    }
    public Case caseChildToCQ(Case c,Id rt,String ownerid)
    {
        c.status = 'In corso';
        c.ProcessType__c = 'FaxCQ_Da_Controllare';
        c.recordtypeId = rt;
        c.ownerid = ownerid;
        return c;
    }
    public Task createTask(String caseId,Id recordTypeId){
        Task tsk = new Task();
        //tsk.ownerId = ownerCaseId;
        tsk.WhatId = caseId;   
        tsk.RecordTypeId = recordTypeiD;
        tsk.Subject = 'Task di controllo qualità';
        tsk.Type = 'Fax Controllo';
        tsk.Check_value_before_create_task__c = true;
        
        return tsk;      
    }  
}