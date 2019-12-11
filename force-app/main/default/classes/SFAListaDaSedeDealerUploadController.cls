public class SFAListaDaSedeDealerUploadController {
    public static Integer recordInError=0;
    public static String idTipoLista='';

    @AuraEnabled
    public static Datetime preventInitForm() {
        return (Datetime)Cache.Session.get('datacaricamento');
           
    }


    @AuraEnabled
    public static String initForm() {
        String query = 'SELECT Nome_Lista__c, Id FROM SFA_ListeCaricate__c';
        
        System.debug(LoggingLevel.DEBUG, 'Executing query: ' + query);
 
        List<SFA_ListeCaricate__c> listaTipologia = Database.query(query);
        
        //query = 'SELECT Name, Id FROM SFA_TipologiaLista__c';
        query = 'SELECT Name, Id, Descrizione__c FROM SFA_TipologiaLista__c';
        List<SFA_TipologiaLista__c> listaCategorie = Database.query(query);
        List<List<sObject>> lists = new List<List<sObject>>();
        lists.add(listaTipologia);
        lists.add(listaCategorie);
        return JSON.serialize(lists);
    }
    @AuraEnabled
    public static String reportUpload(Datetime data_elaborazione) {
        List<SFA_ListeCaricate__c> listaCaricate = [SELECT Id, Nome_Lista__c, Numero_righe__c, Data_Caricamento__c, Data_Visibilita__c FROM SFA_ListeCaricate__c WHERE Data_Caricamento__c =: data_elaborazione];
        if(listaCaricate.isEmpty())
            return JSON.serialize(new SFA_ListeCaricate__c());
        else {
            return JSON.serialize(listaCaricate.get(0));
        }
    }
    @AuraEnabled(cacheable=true)
    public static List<SFA_ListaCheck__c> getListaCheckWithOffset(String pageSize, String pageNumber, Datetime data_elaborazione){
        Integer ps = Integer.valueOf(pageSize);
        Integer pn = Integer.valueOf(pageNumber)-1;
        if(data_elaborazione==null) return new List<SFA_ListaCheck__c>();
        List<SFA_ListaCheck__c> listaCheck = [SELECT
               ErrorMessage__c, OCS_Code__c, P_IVA__c, Name, CodiceFiscale__c, LastModifiedDate, SFA_ListeCaricate__c, SFA_ListeCaricate__r.Nome_Lista__c, SFA_ListeCaricate__r.Tipo_Attivita__r.Descrizione__c 
               FROM SFA_ListaCheck__c WHERE LastModifiedDate >=: data_elaborazione ORDER BY LastModifiedDate desc LIMIT :Integer.valueOf(ps) OFFSET :(ps*pn)];
        // WHERE LastModifiedDate >=: datetime.newinstance(long.valueOf(data_elaborazione))
        return listaCheck;
    }
    @AuraEnabled(cacheable=true)
    public static List<SFA_ListaCheck__c> getListaCheckByNameListWithOffset(String pageSize, String pageNumber){
        Integer ps = Integer.valueOf(pageSize);
        Integer pn = Integer.valueOf(pageNumber)-1;
        
        if(!Cache.Session.contains('nomeLista'))
        	return new List<SFA_ListaCheck__c>();
        String nomeLista = (String)Cache.Session.get('nomeLista');
        List<SFA_ListaCheck__c> listaCheck = [SELECT
               ErrorMessage__c, OCS_Code__c, P_IVA__c, Name, CodiceFiscale__c, LastModifiedDate, SFA_ListeCaricate__c, SFA_ListeCaricate__r.Nome_Lista__c, SFA_ListeCaricate__r.Tipo_Attivita__r.Descrizione__c 
               FROM SFA_ListaCheck__c WHERE SFA_ListeCaricate__r.Nome_Lista__c =: nomeLista ORDER BY LastModifiedDate desc LIMIT :Integer.valueOf(ps) OFFSET :(ps*pn)];
        // WHERE LastModifiedDate >=: datetime.newinstance(long.valueOf(data_elaborazione))
        System.debug('Nome Lista: '+nomeLista);
        return listaCheck;
    }
    @AuraEnabled
    public static SFA_ListeCaricate__c processData(String fileData,List<String> fields, String tipo_attivita, String nome_lista, String tipo_lista, Date data_visibilita) {
        Datetime datacaricamento = System.now();
        Cache.Session.put('nomeLista', nome_lista);
        SFA_ListeCaricate__c listeCaricate = new SFA_ListeCaricate__c();
        if(nome_lista!=null && !nome_lista.trim().equals('')) {
            List<SFA_ListeCaricate__c> listeC = [SELECT ID, Chiuso__c FROM SFA_ListeCaricate__c where Nome_Lista__c =: nome_lista];
            if(listeC.isEmpty()) {
                listeCaricate.Nome_Lista__c = nome_lista;
            }
            else {
                listeCaricate.Id=listeC.get(0).Id;
                listeCaricate.Chiuso__c=listeC.get(0).Chiuso__c;
            }
        }
        else {
            List<SFA_ListeCaricate__c> listeC = [SELECT Chiuso__c FROM SFA_ListeCaricate__c where Id =: tipo_lista];
			listeCaricate.Chiuso__c=listeC.get(0).Chiuso__c;
			listeCaricate.Id=tipo_lista;
        }
		listeCaricate.Ordine_Visualizzazione__c = 1;
        listeCaricate.Tipo_Attivita__c=tipo_attivita;
        listeCaricate.Numero_righe__c=-1;
        listeCaricate.Data_Caricamento__c=datacaricamento;
        listeCaricate.Data_Visibilita__c=data_visibilita;
        upsert listeCaricate;
        Cache.Session.put('datacaricamento', listeCaricate.Data_Caricamento__c);

        ID jobID = System.enqueueJob(new SFAListaDaSedeReadFileCSVBatch(fileData, fields, tipo_attivita, nome_lista, listeCaricate.Id, data_visibilita));
        return listeCaricate;
    }
    @AuraEnabled
    public static Id getTipologiaAttivitaFromLista(String tipo_lista ) {
        List<SFA_ListeCaricate__c> listaCaric = [SELECT Tipo_Attivita__r.Id FROM SFA_ListeCaricate__c WHERE Id =: tipo_lista];
        if (listaCaric!=null && listaCaric.size()>0) {
            return listaCaric.get(0).Tipo_Attivita__r.Id;
        } else {
            return null;
        }
    }
    /*
    private static void setStringField(Account account, String fieldName, String fieldValue) {
        if (fieldValue == null) return;
        if (fieldValue.trim().equals('')) account.put(fieldName, null);
        else account.put(fieldName, fieldValue);
    }
 
    private static void setBooleanField(Account account, String fieldName, String fieldValue) {
        if (fieldValue == null) return;
        if (fieldValue.trim().equals('')) account.put(fieldName, null);
        else account.put(fieldName, Boolean.valueOf(fieldValue));
    }
 
    private static void setDateField(Account account, String fieldName, String fieldValue) {
        if (fieldValue == null) return;
        if (fieldValue.trim().equals('')) account.put(fieldName, null);
        else if (XCSDataUtils.checkYYYYMMddWithDashes(fieldValue)) {
            account.put(fieldName, DateUtils.parseFromYYYYMMDDString(fieldValue.replaceAll('\\-','')));
        }
    }
 
    private static void setPhoneField(Account account, String fieldName, String fieldValue) {
        if (fieldValue == null) return;
        if (fieldValue.trim().equals('')) account.put(fieldName, null);
        else account.put(fieldName, fieldValue.replaceAll('[^\\d]', ''));
    }
    */
    public static Integer ricercaPerOcsID(Account account) {
        String fieldName = 'OCS_External_Id__c';
        return search(account, fieldName);
    }
    public static Integer ricercaPerPIva(Account account) {
        String fieldName = 'Partita_IVA__c';
        return search(account, fieldName);
    }
    private static Integer search(Account account, String fieldName) {
        System.debug(LoggingLevel.DEBUG, 'Searching by ' + fieldName);
        SObject c = (SObject)account;
        String fieldValue = (String)c.get(fieldName);
        String query = BASE_QUERY + fieldName + ' = \''+fieldValue+'\'';
        
        System.debug(LoggingLevel.DEBUG, 'Executing query: ' + query);
        return Database.countQuery(query);
 
    }
    /*
    private static Map<String, Account> getInputAccountMap(Map<Account, Account> accountMap, String fieldName) {
        Map<String, Account> fieldAccountMap = new Map<String, Account>();
 
        List<Account> inputAccounts = new List<Account>(accountMap.keySet());
        for (Account account : inputAccounts) {
            if (accountMap.get(account) == null && account.get(fieldName) <> null) {
                fieldAccountMap.put(String.valueOf(account.get(fieldName)), account);
            }
        }
 
        return fieldAccountMap;
    }
    
    private static String getOrderByConditions(final String fieldName) {
        return ' ORDER BY ' + fieldName + ', CreatedDate ASC';
    }
    */
    
    private static final String BASE_QUERY = 'SELECT count() FROM Account WHERE RecordType.Name = \'Dealer\' AND ';
    private static final String personRecordTypeId  = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
     
}