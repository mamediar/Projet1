/**
* Class: GD_InvioMailUtility
* @description: apex class contains implements method for 
* @date:14/08/2018
* @author:Mady COLY
* */
global class GD_Dealer_Isvap_Courses_Upload  implements Database.Batchable <String> , Database.Stateful{
    
    global List < String > listOfIterableRecords = new List < String > ();
    global List < String > csvFieldNames = new List < String > ();
    global IVASS_Dealer_Courses__c corso ;
    global static Boolean isSuccess = false;
    global  GD_Dealer_Isvap_Courses_Upload (String fileContent,IVASS_Dealer_Courses__c mycorso) {
        System.debug('*********************** Start constructor of CaricareListaDEmBatch  *********************');
        listOfIterableRecords = fileContent.split('\r\n');
        System.debug('size of listOfIterableRecords : '+listOfIterableRecords.size());
        System.debug('listOfIterableRecords : '+listOfIterableRecords);
        if (listOfIterableRecords.size()>0) {
            csvFieldNames = listOfIterableRecords[0].split( ';'); 
            listOfIterableRecords.remove(0);
        }
        this.corso = mycorso;
        System.debug('Corso : '+corso);
        
        System.debug('*********************** End constructor of CaricareListaDEmBatch  *********************'); 
    }
    global Iterable <String> start(Database.batchableContext bc) {
        System.debug('*********************** function start batch of CaricareListaDEmBatch  *********************');
        System.debug('size of listOfIterableRecords in function start batch: '+listOfIterableRecords.size());
        return listOfIterableRecords;
    }  
    
    global void execute(Database.batchableContext bc, List < String > scope) {
        System.debug('*********************** Start function CaricareListaDEmaBatch.execute  *********************');
        System.debug('---scope---= ' + scope);
        
        Map<String, Schema.RecordTypeInfo> accountRts = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName();
        System.debug('size accountRts : '+accountRts);
        System.debug('accountRts : '+accountRts);
        Schema.RecordTypeInfo dealerRt = accountRts.get('Dealer');
        Schema.RecordTypeInfo referenteRt = accountRts.get('Person Account');
        System.debug('dealerRt : '+dealerRt);
        System.debug('referenteRt : '+referenteRt);
        List < IVASS_Dealer_courses_Iscritti__c > lstRecord2Object = new List < IVASS_Dealer_courses_Iscritti__c > ();
        if (scope.size() <= 0) {
            //The file is empty.
            System.debug('GD_Dealer_Isvap_Courses_Upload.execute --> The file is empty');
        }
        else {			
            //The file is not empty.
            System.debug('The file is not empty.');
            lstRecord2Object = GD_Dealer_Isvap_Courses_Upload.elaborazioneFile(scope,this.corso);
        }
        if (lstRecord2Object != null && lstRecord2Object.size() > 1) {
            //Save Data From CSV File to Org            
            System.debug('---lstRecord2Object---= ' + lstRecord2Object);
            //	saveData(lstRecord2Object);
        }
        System.debug('*********************** End function CaricareListaDEmBatch.execute  *********************');
    }
    
    global void finish(Database.batchableContext bc) {
        System.debug('*********************** Start function CaricareListaDEmBatch.finish  *********************');
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
                            FROM AsyncApexJob
                            WHERE Id = :bc.getJobId()];
        System.debug('job : '+job);                    
        System.debug('*********************** End function CaricareListaDEmBatch.finish  *********************');
        
    }
    public static List<String> controlli_formali_contenuto_file(List < String > recordsFile, Integer rowPosition){
        System.debug('*********************** Start function controlli_formali_contenuto_file *********************');
        System.debug('size records file : '+recordsFile.size());
        System.debug('records file : '+recordsFile);
        System.debug('rowPosition : '+rowPosition);
        List<String> rowListFromCSV = new List<String>();
        for(Integer i = 0;i<recordsFile.size(); i++){
            String[] inputvalues = new String[]{};
                System.debug('recordsFile[i] : '+recordsFile[i]);
            inputvalues = recordsFile[i].split(';');
            System.debug('SIZE inputValues : '+inputvalues.size());
            System.debug('inputValues : '+inputvalues);
            if(inputvalues.size()==18){
                if(inputvalues[rowPosition]!=''){
                    rowListFromCSV.add(inputvalues[rowPosition]);
                }
            }
        }
        System.debug('size rowListFromCSV : '+rowListFromCSV.size());
        System.debug('rowListFromCSV : '+rowListFromCSV);
        
        System.debug('*********************** End function controlli_formali_contenuto_file *********************');
        return rowListFromCSV;
    }
    
    public static Map<String,Account> getDealersExist(List<String> dealersFromCSVFile) {
        System.debug('*********************** Start function getDealersExist *********************');
        System.debug('dealerList : '+ dealersFromCSVFile);
        Map<String, Account> myMapDealers= new Map<String, Account>();
        try{
            // dealers = [SELECT Id , Name, OCS_External_Id__c FROM Account WHERE RecordType.Name = 'Dealer' AND  OCS_External_Id__c IN : dealersFromCSVFile];
            Map<ID, Account> dealers = new Map<ID, Account>([SELECT Id,FirstName,LastName, OCS_External_Id__c,BusinessEmail__c , Name FROM Account WHERE RecordType.Name = 'Dealer' AND  OCS_External_Id__c <>'' AND OCS_External_Id__c IN : dealersFromCSVFile]);
            //System.debug('size of map : '+dealers.size());
            System.debug('dealers size : '+dealers.size());
            System.debug('dealers : '+dealers);
            for (ID idKey : dealers.keyset()) {
                Account a = dealers.get(idKey);
                myMapDealers.put(a.OCS_External_Id__c,a);
            }
            
            System.debug('dealers : '+myMapDealers);
        } catch(Exception e){
            myMapDealers= new Map<String, Account>();
        }
        System.debug('*********************** End function getDealersExist *********************');    
        return myMapDealers; 
    }
    
    public static Map<String,Account> getReferentesExist(List<String> referenteFromCSVFile) {
        System.debug('*********************** Start function getReferentesExist *********************');
        System.debug('referenteList : '+ referenteFromCSVFile);
        Map<String, Account> myMapReferentes= new Map<String, Account>();
        try{
            Map<ID, Account> referentes = new Map<ID, Account>([SELECT Id,FirstName,LastName,  OCS_External_Id__c,BusinessEmail__c FROM Account WHERE /*Recordtype.Name = 'Person Account' AND*/ OCS_External_Id__c  IN : referenteFromCSVFile]);
            //System.debug('size of map : '+dealers.size());
            System.debug('referentes : '+referentes);
            for (ID idKey : referentes.keyset()) {
                Account a = referentes.get(idKey);
                myMapReferentes.put(a.OCS_External_Id__c,a);
            }
            
                System.debug('myMapReferentes : '+myMapReferentes);
        } catch(Exception e){
            myMapReferentes= new Map<String, Account>();
        }
        System.debug('*********************** End function getReferentesExist *********************');        
        return myMapReferentes; 
    }
    public static Map<String,IVASS_Dealer_courses_Iscritti__c> getIscritiExist(List<String> referenteFromCSVFile) {
        System.debug('*********************** Start function getIscritiExist *********************');
        System.debug('referenteList : '+ referenteFromCSVFile);
        Map<String, IVASS_Dealer_courses_Iscritti__c> myMapIscritti= new Map<String, IVASS_Dealer_courses_Iscritti__c>();
        try{
            Map<ID, IVASS_Dealer_courses_Iscritti__c> iscitti = new Map<ID, IVASS_Dealer_courses_Iscritti__c>([SELECT Id, Name, CreatedDate, Corso__c, Codice_Fiscale__c, Codice_Intermediario__c, Cognome__c, Data_Iscrizione__c, Dealer__c, Esito_Outsourcer__c FROM IVASS_Dealer_courses_Iscritti__c WHERE Codice_Intermediario__c IN : referenteFromCSVFile]);
            //System.debug('size of map : '+dealers.size());
            System.debug('iscitti : '+iscitti);
            for (ID idKey : iscitti.keyset()) {
                IVASS_Dealer_courses_Iscritti__c a = iscitti.get(idKey);
                myMapIscritti.put(a.Codice_Intermediario__c,a);
            }
            
                System.debug('myMapIscritti : '+myMapIscritti);
        } catch(Exception e){
            myMapIscritti= new Map<String, IVASS_Dealer_courses_Iscritti__c>();
        }
        System.debug('*********************** End function getIscritiExist *********************');        
        return myMapIscritti; 
    }
    
    public static Map<String,Account> getFilialesExist(List<String> filialeFromCSVFile) {
        System.debug('*********************** Start function getFilialesExist *********************');    
        System.debug('filialeList : '+ filialeFromCSVFile);
        Map<String, Account> myMapFiliales= new Map<String, Account>();
        try{
            Map<ID, Account> filiales = new Map<ID, Account>([SELECT Id , FirstName,LastName, Name , Branch__c,BusinessEmail__c FROM Account WHERE RecordType.Name = 'Branch' AND OCS_External_Id__c  IN : filialeFromCSVFile]);
            //System.debug('size of map : '+dealers.size());
            System.debug('filiales : '+filiales);
            for (ID idKey : filiales.keyset()) {
                Account a = filiales.get(idKey);
                myMapFiliales.put(a.OCS_External_Id__c,a);
            }
            System.debug('myMapFiliales : '+myMapFiliales);
        } catch(Exception e){
            myMapFiliales= new Map<String, Account>();
        }
        System.debug('*********************** End function getFilialesExist *********************');        
        return myMapFiliales; 
    }
       
    public static  Map<String, Account> researchDealersNotExist(List < String > recordsFile, Map<String, Account> myMapDealersExist){
        System.debug('*********************** Start function researchDealersNotExist *********************'); 
        System.debug('SIZE recordsFile : '+recordsFile.size());
        System.debug('recordsFile : '+recordsFile);
        System.debug('size myMapDealersExist : '+myMapDealersExist.size());
        System.debug('myMapDealersExist : '+myMapDealersExist);
        Map<String, Account> myMapDealersNotExist = new Map<String, Account>();
        Map<String, Schema.RecordTypeInfo> accountRts = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName();
        for(Integer i=0;i<recordsFile.size();i++){
            String[] inputvalues = new String[]{};
                inputvalues = recordsFile[i].split(';');
            if(inputvalues.size()==18){
                System.debug('inputvalues size equals 18');
                if(inputvalues[3] !='' && !myMapDealersExist.containsKey((inputvalues[3]))){
                    Account dealer = new Account();
                    Schema.RecordTypeInfo dealerRt = accountRts.get('Dealer');
                    System.debug('dealerRt : '+dealerRt);
                    //dealer.Region_Name__c = inputvalues[0] ;
                    dealer.OCSAreaId__c = Integer.valueof(inputvalues[1]) ;
                    dealer.RecordTypeId = dealerRt.getRecordTypeId();
                    dealer.Name = inputvalues[3] ;
                    dealer.BusinessEmail__c = inputvalues[5];
                    //dealer.Branch__c = inputvalues[3] ;
                    dealer.OCS_External_Id__c = inputvalues[3] ;
                    System.debug ('dealer : '+dealer);
                    System.debug ('dealer BusinessEmail__c: '+dealer.BusinessEmail__c);
                    myMapDealersNotExist.put(dealer.OCS_External_Id__c,dealer);
                }
            }
        }
        System.debug('size myMapDealersNotExist : '+myMapDealersNotExist.size());
        System.debug('myMapDealersNotExist : '+myMapDealersNotExist);
        System.debug('*********************** End function researchDealersNotExist *********************'); 
        return myMapDealersNotExist;
    }
    
    public static  Map<String, Account> researchFilialesNotExist(List < String > recordsFile, Map<String, Account> myMapFilialesExist){
        System.debug('*********************** Start function researchDealersNotExist *********************'); 
        System.debug('SIZE recordsFile : '+recordsFile.size());
        System.debug('recordsFile : '+recordsFile);
        System.debug('size myMapFilialesExist : '+myMapFilialesExist.size());
        System.debug('myMapFilialesExist : '+myMapFilialesExist);
        Map<String, Account> myMapFilialesNotExist = new Map<String, Account>();
        Map<String, Schema.RecordTypeInfo> accountRts = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName();
        for(Integer i=0;i<recordsFile.size();i++){
            String[] inputvalues = new String[]{};
                inputvalues = recordsFile[i].split(';');
            if(inputvalues.size()==18){
                System.debug('inputvalues size equals 18');
                if(inputvalues[3] !='' && !myMapFilialesExist.containsKey((inputvalues[3]))){
                    Account filiale = new Account();
                    Schema.RecordTypeInfo branchRt = accountRts.get('Branch');
                    System.debug('branchRt : '+branchRt);
                    filiale.RecordTypeId = branchRt.getRecordTypeId();
                    filiale.Name = inputvalues[3] ;
                    filiale.OCS_External_Id__c = inputvalues[3] ;
                    System.debug ('filiale : '+filiale);
                    myMapFilialesNotExist.put(filiale.OCS_External_Id__c,filiale);
                }
            }
        }
        System.debug('size myMapFilialesNotExist : '+myMapFilialesNotExist.size());
        System.debug('myMapFilialesNotExist : '+myMapFilialesNotExist);
        System.debug('*********************** End function researchDealersNotExist *********************'); 
        return myMapFilialesNotExist;
    }
    
    public static  Map<String, Account> researchReferentesNotExist(List < String > recordsFile, Map<String, Account> myMapReferentesExist){
        System.debug('*********************** Start function researchReferentesNotExist *********************');
        Map<String, Account> myMapReferentesNotExist = new Map<String, Account>();
        Map<String, Schema.RecordTypeInfo> accountRts = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName();
        for(Integer i=0;i<recordsFile.size();i++){
            String[] inputvalues = new String[]{};
                inputvalues = recordsFile[i].split(';');
            if(inputvalues.size()==18){
                if(inputvalues[6] !='' && !myMapReferentesExist.containsKey(inputvalues[6])){
                    Account referente = new Account();
                    /* Schema.RecordTypeInfo referenteRt = accountRts.get('PersonAccount');
                    System.debug('referenteRt : '+referenteRt);
                    referente.RecordTypeId = referenteRt.getRecordTypeId();*/
                    referente.FirstName = inputvalues[8];
                    referente.LastName = inputvalues[7];
                    referente.BusinessEmail__c = inputvalues[10];
                    referente.OCS_External_Id__c = inputvalues[6];
                    referente.Codice_Fiscale__c = inputvalues[9];
                    myMapReferentesNotExist.put(referente.OCS_External_Id__c,referente);
                }
            }
        }
        System.debug('*********************** End function researchReferentesNotExist *********************');
        return myMapReferentesNotExist;
    }
     public static  Map<String, IVASS_Dealer_courses_Iscritti__c> researchIscrittiNotExist(List < String > recordsFile, Map<String, IVASS_Dealer_courses_Iscritti__c> myMapIscrittiExist,Map<String, Account> myMapDealers,  Map<String, Account> myMapReferentes, IVASS_Dealer_Courses__c corso){
        System.debug('*********************** Start function researchIscrittiNotExist *********************');
        Map<String, IVASS_Dealer_courses_Iscritti__c> myMapIscrittiNotExist = new Map<String, IVASS_Dealer_courses_Iscritti__c>();
        for(Integer i=0;i<recordsFile.size();i++){
            String[] inputvalues = new String[]{};
                inputvalues = recordsFile[i].split(';');
            if(inputvalues.size()==18){
                if(inputvalues[3] !='' && !myMapIscrittiExist.containsKey(inputvalues[3])){
                    IVASS_Dealer_courses_Iscritti__c obj =GD_Dealer_Isvap_Courses_Upload.createIscritto(inputvalues,myMapDealers,myMapReferentes,corso);
                    myMapIscrittiNotExist.put(obj.Codice_Intermediario__c,obj);
                        //obj.Note_x_Outsourcer__c = inputvalues[0];
                        System.debug('obj in position '+ i +' : '+obj);
                }else{
                    IVASS_Dealer_courses_Iscritti__c myIscritto = myMapIscrittiExist.get(inputvalues[3]);
                    System.debug('myIscritto : '+myIscritto);
                    System.debug('Corso : '+corso);
                    if(myIscritto.Corso__c!=corso.Id){
                       System.debug('myIscritto.Corso__c : '+myIscritto.Corso__c+' /corso.Id : '+corso.Id);
                        IVASS_Dealer_courses_Iscritti__c obj =GD_Dealer_Isvap_Courses_Upload.createIscritto(inputvalues,myMapDealers,myMapReferentes,corso);
                        myMapIscrittiNotExist.put(obj.Codice_Intermediario__c,obj);
                    }
                }
            }
        }
        System.debug('*********************** End function researchIscrittiNotExist *********************');
        return myMapIscrittiNotExist;
    }
    
    public static Map<String, Account> insertObjectNotExist(List<Account> objectsToCreated, Map<String, Account> myMapObjectsExist){
        System.debug('*********************** Start function insertDealersNotExist *********************');
        try{
            insert objectsToCreated;
        }catch(Exception e){
            objectsToCreated = NULL;
            System.debug('Message exception :'+e.getMessage());   
            System.debug('Cause exception : '+e.getCause());   
            System.debug('Line Number exception : '+e.getLineNumber());   
            System.debug('Trace exception : '+e.getStackTraceString());  
        }
        if(objectsToCreated.size()>0){
            for(Account obj : objectsToCreated){
                if(obj.OCS_External_Id__c!='' && !myMapObjectsExist.containsKey(obj.OCS_External_Id__c)){
                    myMapObjectsExist.put(obj.OCS_External_Id__c,obj);
                }
            }
        }
        System.debug('myMapObjectsExist : '+myMapObjectsExist);
        System.debug('*********************** End function insertDealersNotExist *********************');
        return myMapObjectsExist;
    }
    
    public static List <IVASS_Dealer_courses_Iscritti__c> insertObjectCoursesIscritti(List <IVASS_Dealer_courses_Iscritti__c> myCorsoIscrittiList){
        System.debug('*********************** Start function insertObjectCoursesIscritti *********************');
        try{
            if(myCorsoIscrittiList.size()>0)
            {
                insert myCorsoIscrittiList;
            }
            System.debug('size myCorsoIscrittiList : '+myCorsoIscrittiList.size());
            System.debug('myCorsoIscrittiList : '+myCorsoIscrittiList);
            return myCorsoIscrittiList;
        }catch(Exception e){
            System.debug('Message exception :'+e.getMessage());   
            System.debug('Cause exception : '+e.getCause());   
            System.debug('Line Number exception : '+e.getLineNumber());   
            System.debug('Trace exception : '+e.getStackTraceString()); 
        }
        System.debug('*********************** Start function insertObjectCoursesIscritti *********************');
        return new List <IVASS_Dealer_courses_Iscritti__c>();
    }
    
    public static IVASS_Dealer_courses_Iscritti__c createIscritto (String[] inputvalues, Map<String, Account> myMapDealers,  Map<String, Account> myMapReferentes, IVASS_Dealer_Courses__c corso){
        System.debug('*********************** Start function createIscritto *********************');
            IVASS_Dealer_courses_Iscritti__c obj = new IVASS_Dealer_courses_Iscritti__c();
                    if(inputvalues.size()==18){
                        if(inputvalues[0]!=''){
                            obj.Regione__c = inputvalues[0];
                        }
                        if(inputvalues[1]!=''){
                            obj.Area__c = Integer.valueof(inputvalues[1]);    
                        }
                        /* if(inputvalues[2]!=''){
                        // obj.Filiale__c = inputvalues[3]; 
                        }   */ 
                        if(inputvalues[3]!=''){
                            obj.Codice_Intermediario__c = inputvalues[3];
                            if(myMapDealers.containsKey(inputvalues[3])) {
                                // affect the Dealer Id to myObject.Dealer__c
                                obj.Dealer__c = myMapDealers.get(inputvalues[3]).ID;
                            }
                        }
                        if(inputvalues[4]!=''){
                            obj.Ragione_Sociale__c = inputvalues[4];
                        }
                        /* if(inputvalues[5]!=''){
                        // MAIL CON : --- Nothing for the moment ---
                        //obj.Ragione_Sociale__c = inputvalues[4];
                        } */ 
                        if(inputvalues[6] !=''){
                            obj.Name =inputvalues[6];
                            if(myMapReferentes.containsKey(inputvalues[6])){
                                obj.Referente__c = myMapReferentes.get(inputvalues[6]).ID;
                            }
                        }
                        if(inputvalues[7]!=''){
                            obj.Cognome__c = inputvalues[7];          
                        }
                        if(inputvalues[8]!=''){
                            obj.Nome__c = inputvalues[8];
                        }
                        if(inputvalues[9]!=''){
                            obj.Codice_Fiscale__c = inputvalues[9]; 
                        }
                        /*if(inputvalues[10]!=''){
                        //  MAIL REFERENTE : --- Nothing for the moment ---
                        // obj.mail_referente = inputvalues[9];              
                        }*/
                        if(inputvalues[10]!=''){
                            obj.Email_Referente__c = inputvalues[10];
                        }
                        if(inputvalues[11]!='')
                        {
                            String[] dateValues = inputvalues[11].split('/');
                            System.debug('date '+dateValues);
                            obj.Data_Iscrizione__c = date.newinstance(Integer.valueof(dateValues[2]),Integer.valueof(dateValues[1]),Integer.valueof(dateValues[0])) ;  
                        }
                        //Utenza
                        if(inputvalues[12]!='')
                        {
                            obj.Utenza__c = inputvalues[12];
                        }
                        //Password
                        if(inputvalues[13]!='')
                        {
                        obj.Password__c = inputvalues[13];         
                        }
                        if(inputvalues[17]!=''){
                            obj.Note__c = inputvalues[17];         
                        }
                        if(corso!=Null){
                            obj.Corso__c = corso.Id;
                        }
                    
                        System.debug('*********************** Start function createIscritto *********************');
                }
                return obj;
    }
    public static List <IVASS_Dealer_courses_Iscritti__c> convertRecordsToObject(List < String > recordsFile, Map<String, Account> myMapDealers,  Map<String, Account> myMapReferentes, IVASS_Dealer_Courses__c corso){
        System.debug('*********************** Start function convertRecordsToObject *********************');
        List <IVASS_Dealer_courses_Iscritti__c> myCorsoIscrittiList = new List<IVASS_Dealer_courses_Iscritti__c>(); 
        for(Integer i =0; i<recordsFile.size(); i++){
            IVASS_Dealer_courses_Iscritti__c obj = new IVASS_Dealer_courses_Iscritti__c();
            String[] inputvalues = new String[]{};
                inputvalues = recordsFile[i].split(';');
            if(inputvalues.size()==18){
                if(inputvalues[0]!=''){
                    obj.Regione__c = inputvalues[0];
                }
                if(inputvalues[1]!=''){
                    obj.Area__c = Integer.valueof(inputvalues[1]);    
                }
                /* if(inputvalues[2]!=''){
                // obj.Filiale__c = inputvalues[3];
                }   */ 
                if(inputvalues[3]!=''){
                    obj.Codice_Intermediario__c = inputvalues[3];
                    if(myMapDealers.containsKey(inputvalues[3])) {
                        // affect the Dealer Id to myObject.Dealer__c
                        obj.Dealer__c = myMapDealers.get(inputvalues[3]).ID;
                    }
                }
                if(inputvalues[4]!=''){
                    obj.Ragione_Sociale__c = inputvalues[4];
                }
                /* if(inputvalues[5]!=''){
                // MAIL CON : --- Nothing for the moment ---
                //obj.Ragione_Sociale__c = inputvalues[4];
                } */ 
                if(inputvalues[6] !=''){
                    if(myMapReferentes.containsKey(inputvalues[6])){
                        obj.Referente__c = myMapReferentes.get(inputvalues[6]).ID;
                    }
                }
                if(inputvalues[7]!=''){
                    obj.Cognome__c = inputvalues[7];          
                }
                if(inputvalues[8]!=''){
                    obj.Nome__c = inputvalues[8];
                }
                if(inputvalues[9]!=''){
                    obj.Codice_Fiscale__c = inputvalues[9]; 
                }
                /*if(inputvalues[10]!=''){
                //  MAIL REFERENTE : --- Nothing for the moment ---
                // obj.mail_referente = inputvalues[9];              
                }*/
                if(inputvalues[10]!=''){
                    obj.Email_Referente__c = inputvalues[10];
                }
                if(inputvalues[11]!='')
                {
                    String[] dateValues = inputvalues[11].split('/');
                    System.debug('date '+dateValues);
                    obj.Data_Iscrizione__c = date.newinstance(Integer.valueof(dateValues[2]),Integer.valueof(dateValues[1]),Integer.valueof(dateValues[0])) ;  
                }
                //Utenza
                if(inputvalues[12]!='')
                {
                    obj.Utenza__c = inputvalues[12];
                }
                //Password
                if(inputvalues[13]!='')
                {
                   obj.Password__c = inputvalues[13];         
                }
                if(inputvalues[17]!=''){
                    obj.Note__c = inputvalues[17];         
                }
                if(corso!=Null){
                    obj.Corso__c = corso.Id;
                }
                obj.Stato_Corso__c = 'ISCRITTO';
                myCorsoIscrittiList.add(obj);
                
                //obj.Note_x_Outsourcer__c = inputvalues[0];
                System.debug('obj in position '+ i +' : '+obj);
            }
        }
        System.debug('size myCorsoIscrittiList : '+myCorsoIscrittiList.size());
        System.debug('myCorsoIscrittiList : '+myCorsoIscrittiList);
        System.debug('*********************** End function convertRecordsToObject *********************');
        return myCorsoIscrittiList;
    }
    
    // Metodo2 (effettua l'elabolazione del file )
    public static List < IVASS_Dealer_courses_Iscritti__c > elaborazioneFile(List < String > scope, IVASS_Dealer_Courses__c corso)
    {
        try{
            System.debug('*********************** Start function elaborazioneFile *********************');    
            //ELABORAZIONE FILE
            List <IVASS_Dealer_courses_Iscritti__c> myCorsoIscrittiList = new List<IVASS_Dealer_courses_Iscritti__c>();
            // fetch list of COD. OCS CONV. from CSV file
            List<String> codOcsConv = GD_Dealer_Isvap_Courses_Upload.controlli_formali_contenuto_file(scope,3);
            System.debug('size of List cod_Ocs_Conv'+codOcsConv.size());
            System.debug('List cod_Ocs_Conv : '+codOcsConv);
            // fetch list of COD. OCS ref. from CSV file
            List<String> codOcsRef = GD_Dealer_Isvap_Courses_Upload.controlli_formali_contenuto_file(scope,6);
            System.debug('List cod_Ocs_Ref : '+codOcsRef);
            // fetch list of COD. OCS ref. from CSV file
            List<String> filialeList = GD_Dealer_Isvap_Courses_Upload.controlli_formali_contenuto_file(scope,2);
            System.debug('size of List filialeList'+filialeList.size());
            // Find The list of the dealer Exist in the system from CSV file.
            Map<String,Account> mapDealersExist = new  Map<String,Account>();
            mapDealersExist = GD_Dealer_Isvap_Courses_Upload.getDealersExist(codOcsConv);
            // Find the list of the referente Exist in the system from CSV file.
            Map<String,Account> mapReferentesExist = new  Map<String,Account>();
            mapReferentesExist = GD_Dealer_Isvap_Courses_Upload.getReferentesExist(codOcsRef);
            // Find the list of the iscritti Exist in the system from CSV file.
            Map<String,IVASS_Dealer_courses_Iscritti__c> mapIscrittiExist = new  Map<String,IVASS_Dealer_courses_Iscritti__c>();
            mapIscrittiExist = GD_Dealer_Isvap_Courses_Upload.getIscritiExist(codOcsConv);
            // Find the list of the filiale Exist in the system from CSV file.
            Map<String,Account> mapFilialesExist = new  Map<String,Account>();
            mapFilialesExist = GD_Dealer_Isvap_Courses_Upload.getFilialesExist(filialeList);
            System.debug('size mapFilialesExist : '+mapFilialesExist.size());
            if(mapDealersExist.size() >= 0){
                // research the dealers not Exist in the systme from CSV file.
                Map<String, Account> myMapDealersNotExist = new  Map<String, Account>();
                myMapDealersNotExist = GD_Dealer_Isvap_Courses_Upload.researchDealersNotExist(scope,mapDealersExist);
                if(myMapDealersNotExist.size()>0){
                    System.debug('size myMapDealersNotExist: '+myMapDealersNotExist.size());
                    System.debug('size mapDealerExist before insert mapDealersNotExist : '+mapDealersExist.size());
                    mapDealersExist = GD_Dealer_Isvap_Courses_Upload.insertObjectNotExist(myMapDealersNotExist.values(),mapDealersExist);
                    System.debug('size mapDealerExist after insert mapDealersNotExist : '+mapDealersExist.size());
                }
            }
            
            System.debug('size mapReferentesExist : '+mapReferentesExist.size());
            if(mapReferentesExist.size() >= 0){
                // research the referentes not Exist in the system from CSV file.
                Map<String, Account> myMapReferentesNotExist = new  Map<String, Account>();
                myMapReferentesNotExist = GD_Dealer_Isvap_Courses_Upload.researchReferentesNotExist(scope,mapReferentesExist);
                if(myMapReferentesNotExist.size()>0){
                    System.debug('size myMapReferentesNotExist: '+myMapReferentesNotExist.size());
                    System.debug('size myMapReferentesNotExist before insert myMapReferentesNotExist : '+myMapReferentesNotExist.size());
                    mapReferentesExist = GD_Dealer_Isvap_Courses_Upload.insertObjectNotExist(myMapReferentesNotExist.values(),mapReferentesExist);
                    System.debug('size myMapReferentesNotExist after insert myMapReferentesNotExist : '+mapReferentesExist.size());
                }
            }
             if(mapFilialesExist.size() >= 0){
                // research the referentes not Exist in the system from CSV file.
                Map<String, Account> mapFilialesNotExist = new  Map<String, Account>();
                mapFilialesNotExist = GD_Dealer_Isvap_Courses_Upload.researchFilialesNotExist(scope,mapFilialesExist);
                if(mapFilialesNotExist.size()>0){
                    System.debug('size mapFilialesNotExist: '+mapFilialesNotExist.size());
                    System.debug('size mapFilialesNotExist before insert mapFilialesNotExist : '+mapFilialesNotExist.size());
                   // mapFilialesExist = GD_Dealer_Isvap_Courses_Upload.insertObjectNotExist(mapFilialesNotExist.values(),mapFilialesExist);
                    System.debug('size myMapReferentesNotExist after insert mapFilialesExist : '+mapFilialesExist.size());
                }
            }
            if(mapDealersExist.size()>0 && mapReferentesExist.size()>0){
                //convert the records to onjects
                 System.debug('mapDealersExist : '+ mapDealersExist);
                 System.debug('mapDealersExist size: '+ mapDealersExist.size());
                System.debug('mapReferentesExist : '+ mapReferentesExist);
                 System.debug('mapDealersExist size: '+ mapReferentesExist.size());
                //myCorsoIscrittiList = GD_Dealer_Isvap_Courses_Upload.convertRecordsToObject(scope,mapDealersExist,mapReferentesExist,corso);
                mapIscrittiExist = GD_Dealer_Isvap_Courses_Upload.researchIscrittiNotExist(scope,mapIscrittiExist,mapDealersExist,mapReferentesExist,corso);
                System.debug('size of myCorsoIscrittiList : '+ myCorsoIscrittiList.size());
                System.debug('size of scope : '+ scope.size());
                System.debug('size of mapIscrittiExist : '+ mapIscrittiExist.size());
                //if(myCorsoIscrittiList.size()==scope.size()){
                    if(mapIscrittiExist.size()>0){
                        myCorsoIscrittiList=mapIscrittiExist.values();
                        if(myCorsoIscrittiList.size()>0){
                            System.debug('Converting records to object success');
                            myCorsoIscrittiList = GD_Dealer_Isvap_Courses_Upload.insertObjectCoursesIscritti(myCorsoIscrittiList);
                            GD_Dealer_Isvap_Courses_Upload.InvioMail(myCorsoIscrittiList,corso,mapDealersExist);
                            return myCorsoIscrittiList;

                        }else{
                            System.debug('Converting records to object don\'t success');
                            
                        }
                    }
                
            }
            System.debug('*********************** End function elaborazioneFile *********************');
            return myCorsoIscrittiList;
        }
        catch(Exception e){
            System.debug('Message exception :'+e.getMessage());   
            System.debug('Cause exception : '+e.getCause());   
            System.debug('Line Number exception : '+e.getLineNumber());   
            System.debug('Trace exception : '+e.getStackTraceString());  
            
        }
        return new List <IVASS_Dealer_courses_Iscritti__c>();
    }
    //Metodo4 (effettua l'invio delle mail )*/    
    public static void InvioMail (List < IVASS_Dealer_courses_Iscritti__c > iscritti, IVASS_Dealer_Courses__c corso,Map<String,Account> myMappAccount)
    {
        System.debug('  Start ****** InvioMail ****** : ');
        System.debug('  myMappAccount : ' +myMappAccount);
        try{
            EmailTemplate tempRef = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name ='GD Corso Base e Personalizzato per Referente'];
            for(IVASS_Dealer_courses_Iscritti__c iscritto : iscritti){
                List<String> sendingToRef = new List<String>();
            List<Messaging.SingleEmailMessage> lstMsgsRef = GD_InvioMailUtility.setupEmail(iscritto, tempRef.Id);            
            if( iscritto.Email_Referente__c != null ||iscritto.Email_Referente__c!='')
            {
                sendingToRef.add( iscritto.Email_Referente__c);
                GD_InvioMailUtility.sendAlertFromDealerIsvapUplodFile(lstMsgsRef, iscritto, corso, sendingToRef);
                GD_Dealer_Isvap_Courses_Upload.isSuccess = true;
            }
            System.debug('sendingToRef : '+sendingToRef);
            //String[] sendingToRef = new String[] {'madcoly94@gmail.com', 'mady.coly@terangacloud.com'};*/
            }
        }
         catch(Exception e){
            System.debug('Message exception :'+e.getMessage());   
            System.debug('Cause exception : '+e.getCause());   
            System.debug('Line Number exception : '+e.getLineNumber());   
            System.debug('Trace exception : '+e.getStackTraceString());  
            
        }
    }
    global Boolean  getIsSucess(){
        return GD_Dealer_Isvap_Courses_Upload.isSuccess;
    }
    /*// Metodo3 (effettua il caricamento dei record )
public static void CaricamentoDati()
{
// ELABORAZIONE DATI PER OGNI RECORD

// RIEMPIMENTO LISTA RECORD DA INSERIRE

//INSERIMENTO RECORD NEL DATABASE

}*/
    
}