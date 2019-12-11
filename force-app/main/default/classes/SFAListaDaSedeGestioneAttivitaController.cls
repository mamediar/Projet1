public class SFAListaDaSedeGestioneAttivitaController {

    public static final String POSITIVO = '1732';
    public static final String NEGATIVO = '1733';
    public static final String SOSPESO = '1734';
    public static final String SOSPESO_TO_EXCLUDE = '1801';

    public static final String BLANK = '';
    
    /*
    @AuraEnabled
    public static List<XCS_dealers_conv_activity_disp__c> getCategoryList(){
    
        //String query = 'SELECT Id,Name FROM XCS_Categoria__c WHERE ListaDaSedeActive__c = true ORDER BY Name ASC';
        //String query = 'SELECT SFA_TipologiaLista__c,SFA_TipologiaLista__r.Name ';
        //query += 'FROM XCS_dealers_conv_activity_disp__c GROUP BY SFA_TipologiaLista__c, SFA_TipologiaLista__r.Name';
        //String query = 'SELECT XCS_Attivita__c,XCS_Attivita__r.Name FROM XCS_dealers_conv_activity_disp__c GROUP BY XCS_Attivita__c, XCS_Attivita__r.Name';
        //String query = 'SELECT Id,Name FROM XCS_Attivita__c ORDER BY Name ASC';
        String query = 'SELECT Codice_Attivita_Lista_da_Sede__c,Codice_Attivita_Lista_da_Sede__r.Name, Codice_Attivita_Lista_da_Sede__r.Descrizione__c';
        query += 'FROM XCS_dealers_conv_activity_disp__c GROUP BY Codice_Attivita_Lista_da_Sede__c, Codice_Attivita_Lista_da_Sede__r.Name';
        return Database.query(query);
    }*/

    @AuraEnabled
    public static List<XCS_dealers_conv_activity_disp__c> getCategoryList(){
    
        //String query = 'SELECT Id,Name FROM XCS_Categoria__c WHERE ListaDaSedeActive__c = true ORDER BY Name ASC';
        //String query = 'SELECT SFA_TipologiaLista__c,SFA_TipologiaLista__r.Name ';
        //query += 'FROM XCS_dealers_conv_activity_disp__c GROUP BY SFA_TipologiaLista__c, SFA_TipologiaLista__r.Name';
        //String query = 'SELECT XCS_Attivita__c,XCS_Attivita__r.Name FROM XCS_dealers_conv_activity_disp__c GROUP BY XCS_Attivita__c, XCS_Attivita__r.Name';
        //String query = 'SELECT Id,Name FROM XCS_Attivita__c ORDER BY Name ASC';
        String query = 'SELECT Descrizione__c,Name,RSS_External_Id_act_code__c FROM SFA_TipologiaLista__c ';
        return Database.query(query);
    }

    @AuraEnabled
    public static List<XCS_Disposition__c> getDispositionLevel1(){

        String query = 'SELECT Id,Name FROM XCS_Disposition__c ';
        query += 'WHERE External_Id__c LIKE \'%'+POSITIVO+'%\' OR External_Id__c LIKE \'%'+NEGATIVO+'%\' OR External_Id__c LIKE \'%'+SOSPESO+'%\' ';
        //query += 'WHERE External_Id__c LIKE \'%1734%\' OR External_Id__c LIKE \'%1732%\' OR External_Id__c LIKE \'%1733%\'';
        return Database.query(query);
    }
    
    @AuraEnabled
    public static List<XCS_Disposition__c> getDispositionList(Id firstLevel){
        
        //String query = 'SELECT Name, Id, Flag_Disposition_ListaDaSede__c, Categoria__r.Name, Parent__r.Name '; 
        String query = 'SELECT Name, Id, Categoria__r.Name, Parent__r.Name '; 
        query += 'FROM XCS_Disposition__c ';
        //query += 'WHERE Flag_Disposition_ListaDaSede__c = true ';
        query += 'WHERE (Parent__r.External_Id__c LIKE \'%'+POSITIVO+'%\' OR Parent__r.External_Id__c LIKE \'%'+NEGATIVO+'%\' OR Parent__r.External_Id__c LIKE \'%'+SOSPESO+'%\' )';
        
        query += 'AND (NOT External_Id__c LIKE \'%'+SOSPESO_TO_EXCLUDE+'%\') ';

        if(firstLevel != null){
            //query += 'AND Parent__r.Name =: firstLevel ';
            query += 'AND Parent__c =: firstLevel ';
        }

        system.debug('getDispositionList');
        return Database.query(query);
    }
    
    //@AuraEnabled
    //public static List<XCS_dealers_conv_activity_disp__c> createGestisciAttivita(Id categoryId, Id dispositionId){
    //    
    //    List<XCS_dealers_conv_activity_disp__c> itemToInsert = new List<XCS_dealers_conv_activity_disp__c>();
    //    //prendo tutti gli esiti creati per una determinata attività
    //    List<XCS_dealers_conv_activity_disp__c> existentActivity = getGestisciAttivita(categoryId, dispositionId);
    //    
    //    if(!existentActivity.isEmpty()){
    //        //controllo in fase di inserimento se un esito per un tipo di attività è presente nell'ogetto XCS_dealers_conv_activity_disp__c
    //        for(XCS_dealers_conv_activity_disp__c activity : existentActivity){
    //            if(activity.XCS_Categoria__c == categoryId && activity.XCS_Disposition__c == dispositionId){
    //                return new List<XCS_dealers_conv_activity_disp__c>(); 
    //            }
    //        }
    //        
    //        //se l'esito non è presente il recod viene creato 
    //        XCS_dealers_conv_activity_disp__c newActivity = new XCS_dealers_conv_activity_disp__c();
    //        newActivity.XCS_Categoria__c = categoryId;
    //        newActivity.XCS_Disposition__c = dispositionId;
    //        insert newActivity;
    //        
    //        itemToInsert.add(newActivity);
    //    }
    //    
    //    return itemToInsert;
    //}

    @AuraEnabled
    public static Boolean createGestisciAttivita(Id categoryId, Id levelId, Id dispositionId){
    //public static List<XCS_dealers_conv_activity_disp__c> createGestisciAttivita(Id categoryId, Id dispositionId){

        system.debug('APEX_RETURNED_categoryId: '+categoryId);
        system.debug('APEX_RETURNED_dispositionId: '+dispositionId);
        //system.debug('APEX_RETURNED_outputList'+outputList);

        List<XCS_dealers_conv_activity_disp__c> itemToInsert = new List<XCS_dealers_conv_activity_disp__c>();
        //prendo tutti gli esiti creati per una determinata attività
        List<XCS_dealers_conv_activity_disp__c> existentActivity = getGestisciAttivita(categoryId, dispositionId);
        
        if(!existentActivity.isEmpty()){
            //controllo in fase di inserimento se un esito per un tipo di attività è presente nell'ogetto XCS_dealers_conv_activity_disp__c
            for(XCS_dealers_conv_activity_disp__c activity : existentActivity){
                //if(activity.SFA_TipologiaLista__c == categoryId && activity.XCS_Disposition__c == dispositionId){
                //if(activity.SFA_TipologiaLista__c == categoryId && activity.Esito_2__c == dispositionId){ 
                if(activity.Codice_Attivita_Lista_da_Sede__c == categoryId && activity.Esito_1__c == levelId && activity.Esito_2__c == dispositionId){  
                //if(activity.XCS_Attivita__c == categoryId && activity.XCS_Disposition__c == dispositionId){
                //if(activity.XCS_Categoria__c == categoryId && activity.XCS_Disposition__c == dispositionId){
                //TO-BE: if(activity.SFA_TipologiaLista__c == categoryId && activity.XCS_Disposition__c == dispositionId){    
                    //return new List<XCS_dealers_conv_activity_disp__c>(); 
                    system.debug('APEX_RETURNED_FALSE');
                    return false;
                }
            }
            
            //se l'esito non è presente il recod viene creato 
            //XCS_dealers_conv_activity_disp__c newActivity = new XCS_dealers_conv_activity_disp__c();
            //newActivity.XCS_Categoria__c = categoryId;
            //newActivity.XCS_Disposition__c = dispositionId;
            //insert newActivity;
            
            //itemToInsert.add(newActivity);
            //existentActivity.add(newActivity);
        }
        
        //return itemToInsert;
        //return existentActivity;
        return true;
    }
    
    @AuraEnabled
    public static List<XCS_dealers_conv_activity_disp__c> getGestisciAttivita(Id categoryId, Id dispositionId){
        
		//ritorna la lista di tutti gli esiti creati per una attività
        //String query = 'SELECT Id,Name,XCS_Attivita__c,XCS_Disposition__c, XCS_Attivita__r.Name, XCS_Disposition__r.Name, ';
        //String query = 'SELECT Id,Name,XCS_Categoria__c,XCS_Disposition__c, XCS_Categoria__r.Name, XCS_Disposition__r.Name, ';
        //String query = 'SELECT Id,Name,SFA_TipologiaLista__c,XCS_Disposition__c, SFA_TipologiaLista__r.Name, XCS_Disposition__r.Name, '; 
        //String query = 'SELECT Id,Name,Codice_Attivita_Lista_da_Sede__c,Codice_Attivita_Lista_da_Sede__r.Name, ';        
        String query = 'SELECT Id,Name,Codice_Attivita_Lista_da_Sede__c, Codice_Attivita_Lista_da_Sede__r.Name, Codice_Attivita_Lista_da_Sede__r.Descrizione__c, ';        
        query += 'Esito_1__c,Esito_1__r.Name,Esito_2__c,Esito_2__r.Name ';
        query += 'FROM XCS_dealers_conv_activity_disp__c ';
        query += 'WHERE Codice_Attivita_Lista_da_Sede__c =: categoryId ';
        //query += 'WHERE XCS_Attivita__c =: categoryId ';
        //query += 'WHERE XCS_Categoria__c =: categoryId ';
        return Database.query(query);

    }

    @AuraEnabled
    public static Boolean insertRecord(List<Map<String,String>> recordToInsert, Id idActivity){

        //inserimento record di esiti selezionati nell'ogetto di join 
        List<XCS_dealers_conv_activity_disp__c> insertList = new List<XCS_dealers_conv_activity_disp__c>();
        system.debug('idActivity'+idActivity);
        Boolean newCategoryId = idActivity != null ? true : false;

        if(!recordToInsert.isEmpty()){

            for(Integer i=0; i<recordToInsert.size(); i++){

                XCS_dealers_conv_activity_disp__c newActivity = new XCS_dealers_conv_activity_disp__c();
                //newActivity.XCS_Attivita__c = newCategoryId ? idActivity : recordToInsert[i].get('catId');
                //newActivity.XCS_Categoria__c = newCategoryId ? idActivity : recordToInsert[i].get('catId');
                newActivity.Codice_Attivita_Lista_da_Sede__c = newCategoryId ? idActivity : recordToInsert[i].get('catId');
                newActivity.Esito_1__c = recordToInsert[i].get('levId');
                //newActivity.XCS_Disposition__c = recordToInsert[i].get('disId');
                newActivity.Esito_2__c = recordToInsert[i].get('disId');
                insertList.add(newActivity);

            }

            if(!insertList.isEmpty()){
                insert insertList;
                system.debug('true');
                return true;
            }
        }
        system.debug('false');
        return false;
    }

    @AuraEnabled
    public static Id insertCategory(String categoryName, Id dispositionId){

        Boolean notExist = findCategoryByName(categoryName);
        system.debug('notExist--------'+notExist);
        system.debug('notExist--------categoryName: '+categoryName);
        if(notExist){

            if(String.isNotBlank(categoryName)){
                //XCS_Attivita__c newCategory = new XCS_Attivita__c();
                //XCS_Categoria__c newCategory = new XCS_Categoria__c();
                SFA_TipologiaLista__c newCategory = new SFA_TipologiaLista__c();
                //newCategory.Name = categoryName;
                newCategory.Descrizione__c = categoryName;
                //newCategory.XCS_Disposition__c=dispositionId;
                //newCategory.ListaDaSedeActive__c = true;
                insert newCategory;
                return newCategory.Id;
            }
        }
        return null;
    }
    
    @AuraEnabled
    public static Boolean removeActivity(List<XCS_dealers_conv_activity_disp__c> recordToDelete){
        system.debug('recordToDelete:'+recordToDelete);
        if(!recordToDelete.isEmpty()){
            delete [SELECT Id FROM XCS_dealers_conv_activity_disp__c WHERE Id IN :recordToDelete];
            system.debug('true');
            return true;
        }
        system.debug('false');
        return false;
    }

    @AuraEnabled
    public static String getCategoryName(Id categoryId){
        
        //String categoryName = [SELECT Name FROM XCS_Attivita__c WHERE Id =: categoryId].Name;
        //String categoryName = [SELECT Name FROM XCS_Categoria__c WHERE Id =: categoryId].Name;
        //String categoryName = [SELECT Name FROM SFA_TipologiaLista__c WHERE Id =: categoryId].Name;
        String categoryName = [SELECT Descrizione__c FROM SFA_TipologiaLista__c WHERE Id =: categoryId].Descrizione__c;
        system.debug('APEX_categoryName: '+categoryName);
        if(String.isNotBlank(categoryName)){
            return categoryName;
        }
        return BLANK;
    }

    @AuraEnabled
    public static String getLevel1Name(Id levelId){

        String levelName =  [SELECT Name FROM XCS_Disposition__c WHERE Id =: levelId].Name;
        system.debug('APEX_levelName: '+levelName);
        if(String.isNotBlank(levelName)){
            return levelName;
        }
        return BLANK;
    }

    @AuraEnabled
    public static String getDispositionName(Id dispositionId){

        String dispositionName =  [SELECT Name FROM XCS_Disposition__c WHERE Id =: dispositionId].Name;
        system.debug('APEX_dispositionName: '+dispositionName);
        if(String.isNotBlank(dispositionName)){
            return dispositionName;
        }
        return BLANK;
    }

    @AuraEnabled
    public static Boolean findCategoryByName(String categoryName){

        //Integer categoryNamefounded = [SELECT count() FROM XCS_attivita__c WHERE Name =: categoryName];
        //Integer categoryNamefounded = [SELECT count() FROM XCS_Categoria__c WHERE Name =: categoryName AND ListaDaSedeActive__c = true];
        //Integer categoryNamefounded = [SELECT count() FROM SFA_TipologiaLista__c WHERE Name =: categoryName];
        Integer categoryNamefounded = [SELECT count() FROM SFA_TipologiaLista__c WHERE Descrizione__c =: categoryName];
        system.debug('APEX_categoryNamefounded: '+categoryNamefounded);
        if(categoryNamefounded > 0){
            return false;
        }
        return true;
    }



}