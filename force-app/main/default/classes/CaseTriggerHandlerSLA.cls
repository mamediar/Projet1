public class CaseTriggerHandlerSLA extends TriggerHandler {
       
    final static public List<String> lstCaseStatusClosed=new List<String>{'Inoltrato','Gestito','Spam','Annullato'};
    final static string CASICHIUSI='Q524';
    final static Id queueClosedId = [select id, developername from group where developername=:CASICHIUSI].id;
    final static Map<Id,Group> mapGroup =new Map<Id,Group>([select id, developername from group ]);
    final static Map<id,user> mapUser=new map<id,user>([select id,name from user]);
    final static BusinessHours bh = [select id from businesshours where IsDefault=true];
    final static List<BusinessHours> lstBH = [select id,name,IsDefault from businesshours where isActive=true];
    /*
    public CaseTriggerHandlerSLA (){
        this.setMaxLoopCount(2);
    }
*/
    private  Map<String,Id> getBHMap(){
        Map<String,Id> mapBH=new Map<String,Id>();
        for(BusinessHours bh : lstBH)
            if(bh.isDefault)   mapBH.put('Default',bh.id);
            else  mapBH.put(bh.name,bh.id);    
        return mapBH;
    }     
/****GET HISTORY QUERY */
    private Map<Id,List<CaseHistory>> getHistory(List<Case> lstCase){
        Map<Id,List<CaseHistory>> mapCaseHistory=new Map<Id,List<CaseHistory>>();       
        //query history with order by createddate desc to be sure to get in the first the most recent
        List<CaseHistory> lstHistory= (!Test.isRunningTest()) ? [SELECT CaseId,CreatedById,CreatedDate,Field,Id,NewValue,OldValue 
                                        FROM CaseHistory where caseid =:lstCase and Field in('Owner','RecallDate__c','Status')                                        
                                order by createddate desc  ] : CaseTriggerHandlerSLATest.getHistory();
       // System.debug('---LIST HISTORY '+lstHistory.size());
        for(CaseHistory h : lstHistory){
          //  System.debug('--history created '+h.createddate);
            if(h.Field!='Status' || Test.isRunningTest() ||
                    (lstCaseStatusClosed.contains( String.valueOf(h.oldValue )) && 
                        !lstCaseStatusClosed.contains( String.valueOf (h.newValue) )))
                if(mapCaseHistory.get(h.CaseId)==null)mapCaseHistory.put(h.CaseId, new List<CaseHistory>{h});
                else mapCaseHistory.get(h.CaseId).add(h);           
        }
        // System.debug('--MAP HISTORY '+mapCaseHistory.keySet());
        return mapCaseHistory;
    }

    public override void afterUpdate() {
        
        //gestione dei casi per SLA
        //viene gestito solo il caso riverstar 10
        
        //CASO IN CUI ESCE DALLA CODA O PASSA A STATO FINALE e PRECEDENTEMENTE ERA ASSEGNATO A QUALCUNO
       // (NEW.queue_id IS NULL OR (OLD.queue_id <> NEW.queue_id)) AND (OLD.queue_id IS NOT NULL AND OLD.queue_id > 0)
	    //	OR (NEW.status_id IN (123,2,124,126) AND (OLD.queue_id IS NOT NULL AND OLD.queue_id > 0) ) 
        Map<Id,Case> mapOldCase=(Map<Id,Case>) Trigger.oldMap;
        List<Case> lstNewCase=(List<Case>) Trigger.new; 
        //lstNewCase=[select id,recordtype.developername,ownerId,status,createddate,lastmodifieddate,lastmodifiedbyid from case where id=:lstNewCase];
        Map<Id,List<CaseHistory>> mapCaseHistory=getHistory(lstNewCase);
        Map<String,Id> mapBH=getBHMap();
        List<Performance__c> lstPerformance=new List<Performance__c>(); //performance to fill
       // Id recordTypeId =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('CRM Master').getRecordTypeId();
        for(Case c : lstNewCase){
            //System.debug('---TRIGGER RECORDTYPE'+c.recordtype.developername);           
           // if(c.recordtypeId!=recordTypeId) continue;
             //è stato effettuato un cambio di coda || siamo passati ad uno stato finale
            boolean oldNOTNull=mapOldCase.get(c.id).ownerid!=null && mapOldCase.get(c.id).ownerid!=queueClosedId && c.ownerId!=queueClosedId && c.ownerId != null;
            boolean isQueue=mapGroup.keyset().contains(mapOldCase.get(c.id).ownerid);
            boolean queueChanged=c.ownerId!=mapOldCase.get(c.id).OwnerId;
            boolean statusChanged=c.Status!=mapOldCase.get(c.id).Status;
           /* System.debug('oldNOTNull-->'+oldNOTNull);
            System.debug('isQueue-->'+isQueue);
            System.debug('queueChanged-->'+queueChanged);
            System.debug('statusChanged && lstCaseStatusClosed.contains(c.status)-->'+(statusChanged && lstCaseStatusClosed.contains(c.status)));
            System.debug('c.RecallDate__c!=mapOldCase.get(c.id).RecallDate__c)-->'+(c.RecallDate__c!=mapOldCase.get(c.id).RecallDate__c));
            System.debug('c.Status-->'+c.Status);
            System.debug('mapOldCase.get(c.id).Status-->'+mapOldCase.get(c.id).Status);*/
            if(oldNOTNull && isQueue &&
                (queueChanged || (statusChanged && lstCaseStatusClosed.contains(c.status)) || c.RecallDate__c!=mapOldCase.get(c.id).RecallDate__c)){
               // System.debug('---INSIDE CHANGES '+c.status+' CONTAIN '+lstCaseStatusClosed.contains(c.status));
               DateTime ultimaData; //data di uscita dalla coda
               // se non c'è uno storico recuperaro la data di creazione case
               if(mapCaseHistory.get(c.id)==null )  {
                        ultimaData=c.createddate;
                        //System.debug('NO mapCaseHistory -- '+ultimaData);
               }
               else {
                  List<CaseHistory> lstHistory= mapCaseHistory.get(c.id);
                  CaseHistory h=lstHistory[0];

                  if(h.field!='RecallDate__c' )  ultimaData=h.createddate;                     
                  else{
                      //l'ultima variazione è stata una recallDate quindi calcolo il tempo dalla recallDate ad ora
                      //String v=String.valueOf(h.newValue);
                      //System.debug('HistoryTracking '+v);                      
                        //ultimaData=Datetime.valueOf(v);
                       //ultima data è la vecchia recallDate
                       ultimaData=mapOldCase.get(c.id).RecallDate__c;

                  }
                  //System.debug('mapCaseHistory VALORIZZATA-- '+ultimaData);
               }
               //se NON richiestaonline questa info dovrebbe essere deducibile dalla coda
               //if(c.Categoria_Riferimento__c.External_Id__c<>'1324')
                          
                //TODO INSERISCO IN PERFORMANCE --
                //verifico circa la coda
                String queueName;
                String oldOwner=mapOldCase.get(c.id).ownerId;
                if(mapGroup.get(oldOwner)!=null){ //l'owner è presente nel group
                   queueName= mapGroup.get(mapOldCase.get(c.id).ownerId).developerName;
                  // System.debug('mapGroup not null '+mapGroup.get(oldOwner));
                }
                else queueName=mapUser.get(mapOldCase.get(c.id).ownerId).name;
                //System.debug('---QUEUE '+queueName+' OLD QUEUE '+mapOldCase.get(c.id).owner.name+' NEW QUEUE '+c.owner.name + ' OWNERID '+c.ownerId);
                Id bhId=mapBH.get(queueName);
                //la coda non è tra quelle riconosciute utilizzo quella di default
                if(c.Categoria_Riferimento__r.External_Id__c<>'1324'|| bhId==null) bhId=mapBH.get('Default'); //se non è richiesta online uso coda di default
                
                Long inputMillisecs = BusinessHours.diff(bhId, ultimaData, c.LastModifiedDate); //calcolo i milliscondi con i BH della coda
                Integer total_duration_in_seconds = (inputMillisecs/1000).intValue(); //duration in seconds  
                
                //inserisco performance
                lstPerformance.add(new Performance__c(
                    Case__c=c.id,
                    StartDateTime__c=ultimaData,
                    EndDateTime__c=c.lastModifiedDate,
                    User__c=c.lastmodifiedById,                    
                    coda__c=queueName,
                    WorkingTimeSeconds__c=total_duration_in_seconds

                ));

            }
            //else System.debug('---NO CHANGES '+c.status+' CONTAIN '+lstCaseStatusClosed.contains(c.status));                        
        }
        if(lstPerformance.size()>0)     insert lstPerformance;
        

    }
}