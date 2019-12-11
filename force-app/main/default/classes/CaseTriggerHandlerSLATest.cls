@isTest
public class CaseTriggerHandlerSLATest {
    @isTest
    public static void closeCase(){
        FObject.setGlobalVerbose('none');
        FObject objCase=new  FObject('Case', 1);
        objCase.setDefinition('RecordTypeId','static value(Ticketing)');  
        //objCase.setDefinition('OwnerId','random lookup(User) source(salesforce)');
        objCase.setDefinition('OwnerId','random lookup(Group) field(DeveloperName) value(F101) source(salesforce)' );
       // objCase.setDefinition('OwnerId','random lookup(Group) field(type) value(Queue) source(salesforce)' );
        //objCase.setDefinition('OwnerId','static value(F101)' );
        objCase.insertRecords(true);
        //wait for a bit
        //Integer start = System.Now().millisecond();
        //wait 2 secondi
        //while(System.Now().millisecond()< start+10);
        Case c=(Case) objCase.getInsertedRecords()[0];        
        c.Status=CaseTriggerHandlerSLA.lstCaseStatusClosed[0];
        Datetime yesterday = Datetime.now().addHours(-1);        
        //imposta startdate 8/10/2019 11:00
        //Datetime yesterday = Datetime.newInstance(2019,10,8,11,0,0);
        Test.setCreatedDate(c.id, yesterday);
        Test.startTest();
        //c.LastModifiedDate=DateTime.newInstance(c.createdDate.getTime()+3600000);
        update c;
        Test.stopTest();
        c=[select id,lastModifiedById,createddate,lastmodifieddate,owner.name from case where id=:c.id];
        List<Performance__c> lstPerf=[select User__c,StartDateTime__c,EndDateTime__c,Coda__c,WorkingTimeSeconds__c from Performance__c];
        System.assertNotEquals(lstPerf.size(), 0,'NO RECORD FOUND IN PERFORMANCE');
        System.assertEquals(lstPerf.size(), 1, 'TOO MANY ROW INSERTED');
        Performance__c p=lstPerf[0];
        System.assertEquals(p.User__c, c.lastModifiedById, 'USERID NOT CORRESPONDENT');
        System.assertEquals(p.StartDateTime__c, c.Createddate, 'CREATEDDATE NOT CORRESPONDENT');
        System.assert(Math.abs(c.LastModifiedDate.getTime()-p.EndDateTime__c.getTime())<=1500, 'ModifiedDate NOT CORRESPONDENT');
        Group g=[select id,developername from group where id=:c.ownerId];
        System.assertEquals(p.Coda__c,g.developername,'CODA NON CORRISPONDENTE');
        //il time dipende da quando viene lanciato il test e dal BH
        //System.assert(Math.abs(p.WorkingTimeSeconds__c-3600)<2500,'WORKINGTIME NON CORRISPONDENTE - '+p.WorkingTimeSeconds__c);
        
    }

     @isTest
    public static void closeCaseBulk(){
        FObject.setGlobalVerbose('none');
        FObject objCase=new  FObject('Case', 3);
        objCase.setDefinition('RecordTypeId','static value(Ticketing)');  
        //objCase.setDefinition('OwnerId','random lookup(User) source(salesforce)');
        objCase.setDefinition('OwnerId','random lookup(Group) field(DeveloperName) value(F101) source(salesforce)' );
       // objCase.setDefinition('OwnerId','random lookup(Group) field(type) value(Queue) source(salesforce)' );
        //objCase.setDefinition('OwnerId','static value(F101)' );
        objCase.insertRecords(true);
        //wait for a bit
        //Integer start = System.Now().millisecond();
        //wait 2 secondi
        //while(System.Now().millisecond()< start+10);
        List<Case> lstCase=(List<Case>) objCase.getInsertedRecords();       
        for(Case c : lstCase)   c.Status=CaseTriggerHandlerSLA.lstCaseStatusClosed[0];
        Datetime yesterday = Datetime.now().addHours(-1);        
        //imposta startdate 8/10/2019 11:00
        //Datetime yesterday = Datetime.newInstance(2019,10,8,11,0,0);

        for(Case c : lstCase)  Test.setCreatedDate(c.id, yesterday);
        Test.startTest();
        //c.LastModifiedDate=DateTime.newInstance(c.createdDate.getTime()+3600000);
        update lstCase;
        Test.stopTest();
        //lstCase =[select id,lastModifiedById,createddate,lastmodifieddate,owner.name from case where id in lstCase];
        List<Performance__c> lstPerf=[select User__c,StartDateTime__c,EndDateTime__c,Coda__c,WorkingTimeSeconds__c from Performance__c];
        System.assertNotEquals(lstPerf.size(), 0,'NO RECORD FOUND IN PERFORMANCE');
        System.assertEquals(lstPerf.size(), 3, 'TOO MANY OR TOO LOW ROW INSERTED');        
        
    }

     @isTest
    public static void closeCaseBulk10(){
        integer N=200;
        FObject.setGlobalVerbose('none');
        FObject objCase=new  FObject('Case', N);
        //objCase.setDefinition('RecordTypeId','static value(Ticketing)');  
        objCase.setDefinition('RecordTypeId','static value(Dinieghi_SDD_Verifiche_Filiale)');  
        //objCase.setDefinition('OwnerId','random lookup(User) source(salesforce)');
        objCase.setDefinition('OwnerId','random lookup(Group) field(DeveloperName) value(F101) source(salesforce)' );
       // objCase.setDefinition('OwnerId','random lookup(Group) field(type) value(Queue) source(salesforce)' );
        //objCase.setDefinition('OwnerId','static value(F101)' );
        objCase.setDefinition('Status','static value(Closed)' );
        objCase.insertRecords(true);
        System.assertEquals([select id from case].size(),N,'NON SONO STATI CREATI '+N);
        //wait for a bit
        //Integer start = System.Now().millisecond();   
        //wait 2 secondi
        //while(System.Now().millisecond()< start+10);
        List<Case> lstCase=(List<Case>) objCase.getInsertedRecords();       
        for(Case c : lstCase)   c.Status='Gestito';//CaseTriggerHandlerSLA.lstCaseStatusClosed[0];
        Datetime yesterday = Datetime.now().addHours(-1);        
        //imposta startdate 8/10/2019 11:00
        //Datetime yesterday = Datetime.newInstance(2019,10,8,11,0,0);

        for(Case c : lstCase)  Test.setCreatedDate(c.id, yesterday);
        Test.startTest();
        //c.LastModifiedDate=DateTime.newInstance(c.createdDate.getTime()+3600000);
        update lstCase;
        Test.stopTest();
        //lstCase =[select id,lastModifiedById,createddate,lastmodifieddate,owner.name from case where id in lstCase];
        List<Performance__c> lstPerf=[select User__c,StartDateTime__c,EndDateTime__c,Coda__c,WorkingTimeSeconds__c from Performance__c];
        System.assertNotEquals(lstPerf.size(), 0,'NO RECORD FOUND IN PERFORMANCE');
        System.assertEquals(lstPerf.size(), N, 'TOO MANY OR TOO LOW ROW INSERTED');        
        
    }

    @isTest
    public static void changeQueue(){
       Case c=  generateCase();
       // c.Status=CaseTriggerHandlerSLA.lstCaseStatusClosed[0];
        Datetime yesterday = Datetime.now().adddays(-1);        
        Test.setCreatedDate(c.id, yesterday);
        Test.startTest();
        //c.LastModifiedDate=DateTime.newInstance(c.createdDate.getTime()+3600000);
        Group g=[select id,developername from group where developerName='F102'];
        c.ownerId=g.id;
        update c;
        c=[select id,lastModifiedById,createddate,lastmodifieddate,owner.name from case where id=:c.id];
        List<Performance__c> lstPerf=[select User__c,StartDateTime__c,EndDateTime__c,Coda__c,WorkingTimeSeconds__c from Performance__c];
        System.assertNotEquals(lstPerf.size(), 0,'NO RECORD FOUND IN PERFORMANCE');
        System.assertEquals(lstPerf.size(), 1, 'TOO MANY ROW INSERTED');
        Performance__c p=lstPerf[0];
        System.assertEquals(p.User__c, c.lastModifiedById, 'USERID NOT CORRESPONDENT');
        System.assertEquals(p.StartDateTime__c, c.Createddate, 'CREATEDDATE NOT CORRESPONDENT');
        System.assert(Math.abs(c.LastModifiedDate.getTime()-p.EndDateTime__c.getTime())<=1500, 'ModifiedDate NOT CORRESPONDENT');
        g=[select id,developername from group where developername='F101'];
        System.assertEquals(p.Coda__c,g.developername,'CODA NON CORRISPONDENTE');
        //System.assertEquals(p.WorkingTimeSeconds__c,3600,'WORKINGTIME NON CORRISPONDENTE');
        Test.stopTest();
    }

    @isTest
    //il test si riferisce al caso di un ticket quando viene messo a inoltrato e poi ripreso
    //TESTCASE 1
    public static void changeDoubleStatusTicketing(){
        Case c=  generateCase();
       // c.Status=CaseTriggerHandlerSLA.lstCaseStatusClosed[0];
        Datetime yesterday = Datetime.now().addDays(-1);        
        Test.setCreatedDate(c.id, yesterday);
        Test.startTest();
        c.status='Inoltrato';
        update c; //viene creato un record di chiusura per il cambio stato
        TESTCASE=1;
        CASEID=c.id;
        c.status='New'; //viene ripristinato lo stato
        update c;
        c.status='Inoltrato'; //nuovo stato di chiusura;
        update c;
        Test.stopTest();
        c=[select id,lastModifiedById,createddate,lastmodifieddate,owner.name from case where id=:c.id];
        List<Performance__c> lstPerf=[select User__c,StartDateTime__c,EndDateTime__c,Coda__c,WorkingTimeSeconds__c from Performance__c order by createddate desc];
        System.assertNotEquals(lstPerf.size(), 0,'NO RECORD FOUND IN PERFORMANCE');
        System.assertNotEquals(lstPerf.size(), 1,'TOO LOWFOUND IN PERFORMANCE');
        System.assertEquals(lstPerf.size(), 2, 'TOO MANY ROW INSERTED');
        Performance__c p=lstPerf[0]; // la prima riga dovrebbe essere la + recente e quindi contenere i dati della history
        System.assertEquals(p.User__c, c.lastModifiedById, 'USERID NOT CORRESPONDENT');
        CaseHistory h=getHistory()[0];
        System.assertEquals(p.StartDateTime__c, h.Createddate, 'CREATEDDATE NOT CORRESPONDENT');
        System.assert(Math.abs(c.LastModifiedDate.getTime()-p.EndDateTime__c.getTime())<=1500, 'ModifiedDate NOT CORRESPONDENT');        
                
        //System.assertEquals(p.WorkingTimeSeconds__c,3600,'WORKINGTIME NON CORRISPONDENTE');       
    }

    public static Integer TESTCASE=0;
    public static ID CASEID;
    public static List<CaseHistory> getHistory(){
        List<CaseHistory> lstHistory=new List<CaseHistory>();
        switch on TESTCASE{
            when 0{ }            
            when 1{
               //Stirng jCaseHistory='{"attributes" : {"type" : "CaseHistory","url" : "/services/data/v45.0/sobjects/CaseHistory/" }, "createddate":"'+Datetime.now().format()+'"}';              
                //String jCaseHistory='{"attributes" : {"type" : "CaseHistory", "url" : "/services/data/v46.0/sobjects/CaseHistory/0170Q00003VCOrMQAX" },"Id" : "0170Q00003VCOrMQAX","createddate":"2019-10-07T10:32:16.000+0000", "Field":"Owner"}';
                Object oldValue='Innoltrato';
                String jCaseHistory='{"attributes" : {"type" : "CaseHistory", "url" : "/services/data/v46.0/sobjects/CaseHistory/0170Q00003VCOrMQAX" },';
                    jCaseHistory+='"Id" : "0170Q00003VCOrMQAX","caseId":"'+CASEID+'","createddate":"'+Datetime.now().addHours(-12).format('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ')+'", "Field":"Status" }';
                
                /*
                CaseHistory h=new CaseHistory();
               /// h.createddate=Datetime.now();
                h.field='Owner';     
                */    
                CaseHistory h=(CaseHistory)JSON.deserialize(jCaseHistory, CaseHistory.class)    ;  
                
                lstHistory.add(h);
            }
            
            when 2{  //RECALLDATE                               
                String jCaseHistory='{"attributes" : {"type" : "CaseHistory", "url" : "/services/data/v46.0/sobjects/CaseHistory/0170Q00003VCOrMQAX" },';
                    jCaseHistory+='"Id" : "0170Q00003VCOrMQAX","caseId":"'+CASEID+'","createddate":"'+Datetime.now().addHours(-1).format('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ')+'", "Field":"RecallDate__c" }';
                               
                CaseHistory h=(CaseHistory)JSON.deserialize(jCaseHistory, CaseHistory.class)    ;  
                
                lstHistory.add(h);
            
            }

        }
        return lstHistory;
    }
    /*****NO HISTORY MANAGED**
    @isTest
    public static void changeQueueWithStatus(){
       Case c=  generateCase();
       // c.Status=CaseTriggerHandlerSLA.lstCaseStatusClosed[0];
        Datetime yesterday = Datetime.now().addHours(-1);        
        Test.setCreatedDate(c.id, yesterday);
        Test.startTest();
        //c.LastModifiedDate=DateTime.newInstance(c.createdDate.getTime()+3600000);
        Group g=[select id,developername from group where developerName='F102'];
        c.ownerId=g.id;
        //update c; eseguo un singolo update ma simulo 2 history
   
        c.status=c.Status=CaseTriggerHandlerSLA.lstCaseStatusClosed[0];

        Long startingTime = System.now().getTime(); // Num milliseconds since Jan 1 1970
        Integer delayInMilliseconds = 1000; // One-second delay
        while (System.now().getTime() - startingTime < delayInMilliseconds) ;          

        TESTCASE=1;
        update c;
        

        c=[select id,lastModifiedById,createddate,lastmodifieddate,owner.name from case where id=:c.id];
        List<Performance__c> lstPerf=[select createddate,User__c,StartDateTime__c,EndDateTime__c,Coda__c,WorkingTimeSeconds__c,Case__c from Performance__c order by createddate ];
        System.assertNotEquals(lstPerf.size(), 0,'NO RECORD FOUND IN PERFORMANCE');
        System.assertEquals(lstPerf.size(), 2, 'WRONG ROW INSERTED');
        Performance__c p=lstPerf[0];
        Performance__c p1=lstPerf[1];
        System.debug('----PERFORMANCE CREATED '+p.createddate+' - '+ p1.createddate);
        System.debug('----PERFORMANCE STARTDATE '+p.startdatetime__c+' - '+p1.startdatetime__c);
        for(Performance__c pp : lstPerf) System.assertEquals(pp.Case__c, c.id, 'ID CASE NOT CORRESPONDENT');

        System.assertEquals(p.StartDateTime__c, c.createddate, 'STARTDATETIME VS LAST NOT CORRISPONDENT');
        ///System.assertEquals(p.StartDateTime__c, c.createddate, 'CREATEDDATE NOT CORRISPONDENT');
        //System.assertEquals(p1.EndDateTime__c, c.lastmodifieddate, 'LASTMODIFIED NOT CORRESPONDENT');
        

        System.assertEquals(p.User__c, c.lastModifiedById, 'USERID NOT CORRESPONDENT');
        System.assertEquals(p.StartDateTime__c, p1.EndDateTime__c, 'STARTDATETIME NOT CORRESPONDENT');
        System.assert(Math.abs(c.LastModifiedDate.getTime()-p.EndDateTime__c.getTime())<=1500, 'ModifiedDate NOT CORRESPONDENT');
        g=[select id,developername from group where developername='F102'];
        System.assertEquals(p.Coda__c,g.developername,'CODA NON CORRISPONDENTE');
        System.assertEquals(p.WorkingTimeSeconds__c,1,'WORKINGTIME NON CORRISPONDENTE');
        Test.stopTest();
    }
***************/


    @isTest
    public static void setRecallDate(){
       Case c=  generateCase();
       //c.RecallDate__c=Datetime.now().addHours(-1);        
       // c.Status=CaseTriggerHandlerSLA.lstCaseStatusClosed[0];
        Datetime yesterday = Datetime.now().addDays(-1);        
        Test.setCreatedDate(c.id, yesterday);
        Test.startTest();
        
        //c.status=c.Status=CaseTriggerHandlerSLA.lstCaseStatusClosed[0];
        /*
        Long startingTime = System.now().getTime(); // Num milliseconds since Jan 1 1970
        Integer delayInMilliseconds = 1000; // One-second delay
        while (System.now().getTime() - startingTime < delayInMilliseconds) ;          
        */    
        c.recallDate__c= Datetime.now().addHours(+1); 
        update c;  //creo record performance per la recallDate
        TESTCASE=2; //RECALLDATE
        CASEID=c.id;
        c.status='Inoltrato'; // stato chiusura
        update c;
        Test.stopTest();

        c=[select id,lastModifiedById,createddate,lastmodifieddate,owner.name,recallDate__c from case where id=:c.id];
        List<Performance__c> lstPerf=[select createddate,User__c,StartDateTime__c,EndDateTime__c,Coda__c,WorkingTimeSeconds__c,Case__c from Performance__c order by createddate desc ];
        System.assertNotEquals(lstPerf.size(), 0,'NO RECORD FOUND IN PERFORMANCE');
        System.assertEquals(lstPerf.size(), 2, 'WRONG ROW INSERTED');
        Performance__c p=lstPerf[0];
        Performance__c p1=lstPerf[1];
        System.debug('----PERFORMANCE CREATED '+p.createddate+' - '+ p1.createddate);
        System.debug('----PERFORMANCE STARTDATE '+p.startdatetime__c+' - '+p1.startdatetime__c);
        for(Performance__c pp : lstPerf) System.assertEquals(pp.Case__c, c.id, 'ID CASE NOT CORRESPONDENT');        

        System.assertEquals(p.User__c, c.lastModifiedById, 'USERID NOT CORRESPONDENT');
        System.assertEquals(p.StartDateTime__c, c.recallDate__c, 'STARTDATETIME NOT CORRESPONDENT');
        System.assert(Math.abs(c.LastModifiedDate.getTime()-p.EndDateTime__c.getTime())<=1500, 'ModifiedDate NOT CORRESPONDENT');
       // Group g=[select id,developername from group where developername='F102'];
       // System.assertEquals(p.Coda__c,g.developername,'CODA NON CORRISPONDENTE');
        //System.assertEquals(p.WorkingTimeSeconds__c,1,'WORKINGTIME NON CORRISPONDENTE');        
    }

    private static Case generateCase(){
         FObject.setGlobalVerbose('none');
        FObject objCase=new  FObject('Case', 1);
        objCase.setDefinition('RecordTypeId','static value(CRM_Master)');  
        objCase.setDefinition('OwnerId','random lookup(Group) field(DeveloperName) value(F101) source(salesforce)' );
       // objCase.setDefinition('OwnerId','random lookup(Group) field(type) value(Queue) source(salesforce)' );
        //objCase.setDefinition('OwnerId','static value(F101)' );
        objCase.insertRecords(true);
        //wait for a bit
        //Integer start = System.Now().millisecond();
        //wait 2 secondi
        //while(System.Now().millisecond()< start+10);
        Case c=(Case) objCase.getInsertedRecords()[0];     
        return c;
    }

    /**** 
    @isTest
    static void testConv(){
        FObject.setGlobalVerbose('none');
        //create Dossier
        FObject objDossier=new FObject('Dossier__c',1);
        objDossier.insertRecords(true);
        List<Dossier__c>lstDossier=(List<Dossier__c>) objDossier.getInsertedRecords();
        System.assert(lstDossier.size()>0);        
        FObject objCase=new  FObject('Case', 1);
        objCase.setDefinition('RecordTypeId','static value(CRM_Master)');  
        //objCase.setDefinition('OwnerId','random lookup(Group) field(DeveloperName) value(F101) source(salesforce)' );
       // objCase.setDefinition('OwnerId','random lookup(Group) field(type) value(Queue) source(salesforce)' );
        //objCase.setDefinition('OwnerId','static value(F101)' );
        objCase.insertRecords(true);
        
        List<Case> lstCase=(List<Case>) objCase.getInsertedRecords();    
        System.assert(lstCase.size()>0);      
        SFAConvenzGestioneAccolloController.assignToIDM(lstDossier[0].id,lstCase[0].id);
    }
    **/
}