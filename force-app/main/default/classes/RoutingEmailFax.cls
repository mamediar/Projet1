public class RoutingEmailFax {
    
    public Map<String,QueueFaxMail> queueMailFaxMap = new Map<String,QueueFaxMail>();
    
    public Map<String,Group> devGroupMap = new Map<String,Group>();
    public Map<String,Group> idGroupMap = new Map<String,Group>();
    Map<String,String> idWithAddressAllCases = new Map<String,String>();
    public Map<String,EmailQueueTotal> queueMailWrap = new Map<String,EmailQueueTotal>();
    
    
    
 	   
    public Map<String,Mail> mailsMap = new Map<String,Mail>();
    public Map<String,List<QueueFaxMail>> queueMailFaxMapList = new Map<String,List<QueueFaxMail>>();
    
    public class CustomAggregates{
        public String ownerDeveloperName;
        public Integer caseCount;
        public String ownerName;
    } 
    
    public class EmailQueueTotal
    {
     	public Integer total;
        public Map<String,QueueFaxMail> mapQueue;
        public EmailQueueTotal(Integer total,Map<String,QueueFaxMail> mapQueue)
        {
            this.total = total;
            this.mapQueue = mapQueue;
        }
        public void incrementaCount(){
            total += 1;           
        }
        public void incrementaCountCoda(String devName)
        {
            mapQueue.get(devName).incrementaCount();
            incrementaCount();
        }
        public void routingCase(Case c,Map<String,Group> devGroupMap)
        {
            For(QueueFaxMail qfm : mapQueue.values())
            {
                qfm.impostaPercentualeTotale(total);
                if(qfm.percentActual <= qfm.percentStatic)
                {
                 	c.ownerId = devGroupMap.get(qfm.devQueueName).id;
                    c.Categoria_Riferimento__r = XCS_CategoriaUtil.getCategoryForExternalId(qfm.categoriaExternalId);
                    qfm.incrementaCount();
                    incrementaCount();
                    break;
                }
            }
        }
    }
    
    public class QueueFaxMail{
        public String categoriaExternalId;
       // public String idQueueSalesforce;
        public String devQueueName;
        public String casellaMail;
        public Integer count{get {if(count == null) count = 0; return count;}set;}
        public Double percentStatic{get {if(percentStatic == null) percentStatic = 0; return percentStatic;}set;}
        public double percentActual{get {if(percentActual == null) percentActual = 0; return percentActual;}set;}
        
        public void impostaPercentualeTotale(Double totale){
            percentActual = totale == 0 ? 0 : ((Double)(count) / (double)(totale)) * 100; 
            System.debug('percentActual ' + percentActual);
        }
        
        public Double getCarico(){
            System.debug('getCarico ' + (percentStatic - percentActual));
            return (percentStatic - percentActual);
            
        }
        public void incrementaCount(){
            count += 1;           
        }
        
    }
    
    public void init(){
        System.debug('recupero mail configurate');
       
        List<CRM_QueueMailFaxConfig__c> queueMailFaxConfigList = [select MailBox__c, DeveloperName__c, Balancing__c, Categoria_Ext_Id_Reference__c 
                                                                  from CRM_QueueMailFaxConfig__c where Balancing__c > 0];
        set<String> setDevelopernameToQuery = new set<String>();
        List<String> OwnerIdList = new List<String>();
        System.debug('trovate ' + queueMailFaxConfigList.size() + ' mail. comincio riempimento');
       
        for(CRM_QueueMailFaxConfig__c q : queueMailFaxConfigList){
            QueueFaxMail tmpConf = new QueueFaxMail();
            tmpConf.categoriaExternalId = q.Categoria_Ext_Id_Reference__c;
            tmpConf.percentStatic = q.Balancing__c;
            tmpConf.casellaMail = q.MailBox__c.toLowerCase();
            tmpConf.devQueueName = q.DeveloperName__c;
            if(queueMailWrap.get(q.MailBox__c.toLowerCase()) != null)
            {
                queueMailWrap.get(q.MailBox__c.toLowerCase()).mapQueue.put(tmpConf.devQueueName,tmpConf);
            }
            else
            {
                queueMailWrap.put(q.MailBox__c.toLowerCase(),new EmailQueueTotal(0,new map<String,QueueFaxMail>{tmpConf.devQueueName => tmpConf}));
            }
            setDevelopernameToQuery.add(q.DeveloperName__c);
        }
        
        System.debug('recuper code Salesforce');
        List<String> developernameToQuery = new List<String>(setDevelopernameToQuery);
        List<Group> codeSfdc = GroupUtils.getQueueList(developernameToQuery);
        for(Group g : codeSfdc){
            devGroupMap.put(g.developerName,g);
            idGroupMap.put(g.id,g);
            OwnerIdList.add(g.id);
            System.debug(OwnerIdList);
        }
        System.debug('code salesforce recuperate ' + codeSfdc.size());
        System.debug('calcolo del carico delle code');
        List<Case> listAllCase = [Select id,OwnerId from case where OwnerId IN :OwnerIdList and isClosed != true];
        List<EmailMessage> emailMessages = [select ToAddress, parentId, fromAddress from EmailMessage where ParentId IN: listAllCase];      
        for(EmailMessage e : emailMessages) {
            idWithAddressAllCases.put(e.parentId,e.toAddress);    
        }
        for(Case c : listAllCase)
        {
        	if(queueMailWrap.get(idWithAddressAllCases.get(c.id)) != null)
            {
				queueMailWrap.get(idWithAddressAllCases.get(c.id)).incrementaCountCoda(idGroupMap.get(c.OwnerId).developerName);      
            }        
        }

        System.debug('aggregates.size() = ' + queueMailWrap);
        
       // List<CustomAggregates> listAgg = new List<CustomAggregates>();      
        List<String> listOwnerName = new List<String>();        
        
      /*  for(AggregateResult result : aggregates){
            for(Group g : codeSfdc){
                if(g.name.equalsIgnoreCase((String)result.get('Name'))){
                    CustomAggregates customAgg = new CustomAggregates();
                    customAgg.ownerName = (String)result.get('Name');
                    customAgg.caseCount = (Integer)result.get('n');
                    customAgg.ownerDeveloperName = g.developerName;
                    listOwnerName.add((String)result.get('Name'));
                    listAgg.add(customAgg);
                }
            }
        }
        */
        /*
for(AggregateResult result : aggregates){
System.debug('result name ' + (String)result.get('Name'));
System.debug('result n ' + (Integer)result.get('n'));
//if(queueMailFaxMap.get((String)result.get('Name')) != null){
QueueFaxMail coda = queueMailFaxMap.get((String)result.get('Name'));
coda.count = (Integer)result.get('n');            
System.debug('nome coda = ' + coda.devName + ' con count = ' + coda.count);
//}
}
*/               
      /*  for(CustomAggregates ca : listAgg){
            QueueFaxMail coda = queueMailFaxMap.get(ca.ownerDeveloperName);
            coda.count = ca.caseCount;            
            System.debug('nome coda = ' + coda.devName + ' con count = ' + coda.count);   
        }
        
        
        System.debug('Inizializzazione percentuale');
        for(String mail : mailsMap.keySet())
            getMail(mail).calcolaPercentuale();    */
    }  
    
    public void routing(List<Case> cases){
       
        //routing
        System.debug('inizio routing');
        Map<String,String> idWithAddress = new Map<String,String>();
        List<EmailMessage> emailMessages = [select ToAddress, parentId, fromAddress from EmailMessage where ParentId IN: cases];    
        for(EmailMessage e : emailMessages) {
            idWithAddress.put(e.parentId,e.toAddress.toLowerCase());    
        }
        
        List<BusinessHours> bhId = [Select Id from BusinessHours where name = 'CRM_SLA_Fax'];
        
        for(Case cc : cases){    
            //String devName = cc.recordtype.DeveloperName; MODIFICATO perchè non accetta questo tipo di stringa
            String RTDeveloperName = Schema.SObjectType.Case.getRecordTypeInfosById().get(cc.RecordTypeId).getDeveloperName();
            
            if('fax'.equalsIgnoreCase(cc.origin) && 'CRM_Gestione_Email'.equalsIgnoreCase(RTDeveloperName)){
                cc.ActivityType__c = 'CRM_Gestione_Fax';
                if(bhId.size() > 0){
                    cc.SLA_Date__c =  BusinessHours.add(bhId[0].id,DateTime.now(),28800000);
                }                
            }            
            if('email'.equalsIgnoreCase(cc.origin)  && 'CRM_Gestione_Email'.equalsIgnoreCase(RTDeveloperName))
                cc.ActivityType__c = 'CRM_Gestione_Email';           
        }
        System.debug('inizio assegnamento');
        for(Case c : cases)
        {
            queueMailWrap.get(idWithAddress.get(c.Id)).routingCase(c,devGroupMap);
        }
        
        
        /*
        for(Case c : cases){
            String toAddress = idWithAddress.get(c.id);
            if(mailsMap.get(toAddress) != null){
                Mail mailToAssign = mailsMap.get(toAddress);                
                QueueFaxMail queueToAssign = mailToAssign.getQueueToAssign();
              //  c.ownerId = queueToAssign.idSalesforce;
                XCS_Categoria__c cat = new XCS_Categoria__c();
                cat.External_Id__c = queueToAssign.categoriaExternalId;
                c.Categoria_Riferimento__r = cat;
                queueToAssign.incrementaCount();            
                mailToAssign.calcolaPercentuale();
           
            }
            
        }
        */
        System.debug('fine assegnamento');
        update cases;
        System.debug('fine routing');
    }
    
    public void routing(List<Case> cases, String casellaMail){
        System.debug('inizio routing');
        Map<String,String> idWithAddress = new Map<String,String>();
        
        List<EmailMessage> emailMessages = [select ToAddress, parentId, fromAddress from EmailMessage where ParentId IN: cases];      
        for(EmailMessage e : emailMessages) {
            idWithAddress.put(e.parentId,e.toAddress);           
        }                
        System.debug('inizio assegnamento');
        for(Case c : cases){
            String toAddress = casellaMail;
            if(mailsMap.get(casellaMail) != null){
                Mail mailToAssign = mailsMap.get(casellaMail);                
                QueueFaxMail queueToAssign = mailToAssign.getQueueToAssign();
              //  c.ownerId = queueToAssign.idSalesforce;
                queueToAssign.incrementaCount();            
                mailToAssign.calcolaPercentuale();
            }                
        }
        System.debug('fine assegnamento');
        update cases;
        System.debug('fine routing');
    }
    
    
    public QueueFaxMail getQueue(String key){        
        QueueFaxMail q = queueMailFaxMap.get(key);
        if(q == null){
            q = new QueueFaxMail();
          //  q.devName = key;
          //  queueMailFaxMapList.put(key,q);            
        }
        
        return q;      
    } 
    
    public Mail getMail(String key){        
        Mail m = mailsMap.get(key);
        if(m == null){
            m = new Mail();
            m.mailName = key;
            mailsMap.put(key,m);            
        }     
        
        return m;      
    }
    
    public class Mail{
        String mailName;
        Map<String,QueueFaxMail> queuesMap = new Map<String,QueueFaxMail>();
        
        public void addQueue(QueueFaxMail coda){
       //     queuesMap.put(coda.devName,coda);
        }
        
        public QueueFaxMail getCoda(String name){
            return queuesMap.get(name);
        }
        
        public void calcolaPercentuale(){
            Integer totale = getNumeroCase(); 
            System.debug('totale ' + totale);
            for(String code : queuesMap.keySet())
                getCoda(code).impostaPercentualeTotale(totale);           
        }
        
        public Integer getNumeroCase(){
            Integer count = 0;
            for(String code : queuesMap.keySet()){
                count += getCoda(code).count;
                System.debug('count numeroCase = ' + count);
            }            
            return count == 0 ? 1 : count;           
        }
        
        public QueueFaxMail getQueueToAssign(){
            double max = -999;
            QueueFaxMail resultCoda = null;
            for(String code : queuesMap.keySet()){              
                double carico = getCoda(code).getCarico();
                System.debug('caricoQueueToassign = ' + carico);
                double currentmax = math.max(carico,max);
                System.debug('currentMax = ' + currentmax);                
                if(currentmax != max){
                    resultCoda = getCoda(code);
                    max = currentmax;
                }               
            }
            return resultCoda;
        }
        
    }
    
}