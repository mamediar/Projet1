public class AccountUtils {
    
    public static Final String PADummyCode = 'N00000';
    private static Final String branchDummyCode = 'N00001';
    private static Final String dealerDummyCode = 'N00002';
    public static FINAL String OCSBranchChar = 'F';
    public static FINAL String OCSCustomerChar = 'C';
    private static FINAL String OCSDealerChar = 'D';
    
    public static Account getAccountFromId(String accountId)
    {
        return [select id,FirstName,Lastname,getCodice_Cliente__c,PersonEmail,Privacy_SMS__pc,telefono_cellulare__c,OCS_External_Id__c from Account where Id = :accountId];
    }
    
    //getAccountFromId con campi variabili - Prende in input la lista dei campi tramite il parametro fieldList
    // ES: fieldList = 'id,FirstName,Lastname, ... '
    //[DR:290419]
    public static List<Account> getAccountFromId(String accountId, String fieldList){
        String myStatement = '';
        String myAccountID = '';
        String myFieldList = '';
        List<Account> rtnAccount = new List<Account>();

        myAccountID = accountId.trim();
        myFieldList = fieldList.trim();

		if (!String.isEmpty(myAccountID)){
            if (!String.isEmpty(myFieldList)){
                myStatement = 'SELECT ' + myFieldList + ' FROM Account WHERE Id = :myAccountID';
                rtnAccount = Database.query(myStatement);
            }else{
                System.debug('AccountUtils -> getAccountFromId: Manca la lista di campi "fieldList" per impostare la Query');
            }
		}else{
			System.debug('AccountUtils -> getAccountFromId: Manca il parametro "accountId" per impostare la Query');
       	}
		return rtnAccount;
	}

    public static List<Account> getDealer( String ocsCode ){
        String fieldList='';
        List<Account> accountList = getDealer(fieldList, ocsCode);
        return accountList;
    }
    
    public static String getDealerExternalId( String ocsCode ){
        return OCSDealerChar+ocsCode;
    }
    
    public static String getBranchExternalId( String ocsCode ){
        return OCSBranchChar+ocsCode;
    } 
    
    
    public static List<Account> getDealer( String fieldList, String ocsCode ){
        
        String part1= 'SELECT Id, Name, OCS_External_id__c';
        ocsCode=OCSDealerChar+ocsCode;
        String part2= ' FROM Account WHERE RecordType.Name = \'Dealer\' AND OCS_External_id__c=:ocsCode';
        String query;
        if (!String.isEmpty(fieldList)){
            query =part1+','+fieldList+part2;
            System.debug('part1:: '+query);
        } else {
            query =part1+part2;
            System.debug('part2:: '+query);
        }
        List<Account> accountList = Database.query(query);
        System.debug('accountList AccountUtils:: '+accountList);
        return accountList;
    }
    
    public static List<Account> getBranch( String ocsCode ){
        String fieldList='';
        List<Account> accountList = getBranch(fieldList, ocsCode);
        return accountList;
    }    
    
    public static List<Account> getBranchList()
    {
        return [Select id,Name,OCS_External_Id__c,nameRoleReference__c from Account Where OCS_External_Id__c like 'F%' and recordtype.name ='Branch'];  
    }
    
    public static Map<Id,Account> getBranchMap()
    {
        return new Map<Id,Account>(getBranchList());
    }
    
    public static Map<String, Id> getBranchMapByOCSCode() {
		
        Map<String, Id> branchesMap = new Map<String, Id>();
		List<Account> branches = getBranchList();
        for (Account branch : branches) {
            branchesMap.put(branch.OCS_External_Id__c, branch.Id);
        }        
       	return branchesMap; 
    }

    public static Map<Id, String> getBranchMapById() {
		
        Map<Id, String> branchesMap = new Map<Id, String>();
		List<Account> branches = getBranchList();
        for (Account branch : branches) {
            branchesMap.put(branch.Id, branch.OCS_External_Id__c);
        }        
       	return branchesMap; 
    }
    
    public static List<Account> getBranch( String fieldList, String ocsCode ){
        
        String part1= 'SELECT Id, Name, OCS_External_id__c';
        ocsCode=OCSBranchChar+ocsCode;
        String part2= ' FROM Account WHERE RecordType.Name = \'Branch\' AND OCS_External_id__c=:ocsCode';
        String query;
        if (!String.isEmpty(fieldList)){
            query =part1+','+fieldList+part2;
            System.debug('part1:: '+query);
        } else {
            query =part1+part2;
            System.debug('part2:: '+query);
        }
        List<Account> accountList = Database.query(query);
        System.debug('accountList AccountUtils:: '+accountList);
        return accountList;
    }
    
    public static List<Account> getCliente( String ocsCode ){
        String fieldList='';
        List<Account> accountList = getCliente(fieldList, ocsCode);
        return accountList;
    } 
    
    public static Map<String, Id> findAccountsByExtOCSListID(List<String> listOCSAnagID) {
        
        String query = 'SELECT Id, OCS_External_id__c FROM Account WHERE RecordType.Name = \'Person Account\' AND OCS_External_id__c IN :listOCSAnagID';
        List<Account> accountList = Database.query(query);
        Map<String, Id> mapAccount = new Map<String, Id>();
        if (!(accountList.isEmpty())) {
            for (Account acc : accountList) {
                mapAccount.put(acc.OCS_External_Id__c, acc.Id);
            }
        }
        
        return mapAccount;
    }
    
    public static List<Account> getCliente( String fieldList, String ocsCode ){
        
        String part1= 'SELECT Id, Name, OCS_External_id__c';
        ocsCode=OCSCustomerChar+ocsCode;
        String part2= ' FROM Account WHERE RecordType.Name = \'Person Account\' AND OCS_External_id__c=:ocsCode';
        String query;
        if (!String.isEmpty(fieldList)){
            query =part1+','+fieldList+part2;
            System.debug('part1:: '+query);
        } else {
            query =part1+part2;
            System.debug('part2:: '+query);
        }
        List<Account> accountList = Database.query(query);
        System.debug('accountList AccountUtils:: '+accountList);
        return accountList;
    }
    
    public static List<Account> getClienteByName(String nome,String cognome){
        List<Account> res=[select Id,Name from Account where FirstName=:nome and LastName=:cognome];
        return res;
    }
    
    public static Account makeAccount(Map<String,String> data,String societa){
         system.debug('MakeAccount - DatiIngresso: '+data);
        Account res=new Account(
            LastName = String.isEmpty(data.get('cognome'))?data.get('denominazioneAzienda'):data.get('cognome'),
            OCS_External_id__c = data.get('codCliente') != null ? 'C'+data.get('codCliente') : null,
            FirstName = data.get('nome'),
            Data_Nascita__c = dateToParse(data.get('dataNascita')),
            Luogo_Nascita__pc = data.get('luogoNascita'),
            Provincia_Nascita__pc = data.get('provNascita'),
            Sesso__pc =data.get('sesso'),
            Codice_Fiscale__pc = data.get('codFiscale'),
            Partita_IVA__pc = data.get('piva'),
            PersonMailingStreet = data.get('indirizzo'),
            PersonMailingPostalCode = data.get('cap'),
            PersonMailingCity =data.get('localita'),
            PersonMailingCountry = data.get('provincia'),
            PersonEmail = (data.get('email') == null || !ValidationUtils.isEmailValida(data.get('email'))) ? getEmail(data.get('codCliente')) : data.get('email'),
            Tipo_documento__pc = data.get('tipoDocumento'),
            Numero_Documento__pc = data.get('numDocumento'),
            Ufficio_Rilascio__c = data.get('ufficioRilascio'),
            Luogo_Rilascio__pc = data.get('luogoRilascio'),
            Provincia_Rilascio__pc = data.get('provRilascio'),
            Data_Rilascio__pc = dateToParse(data.get('dataRilascio')),
            Denominazione_Azienda__c = data.get('denominazioneAzienda'),
            Forma_Giuridica__c = data.get('formaGiuridica'),
            Tipo_Anagrafica__pc = data.get('tipoAnagrafica'),
            Data_Scadenza__pc = dateToParse(data.get('dataScadenza')),
            Phone = data.get('telefonoCasa') != null ? data.get('telefonoCasa').replaceAll('[^\\d]', '') : null,
            PersonMobilePhone = data.get('telCellulare') != null ? data.get('telCellulare').replaceAll('[^\\d]', '') : null,
            Tipo_Rapporto__c = data.get('tipoRapporto'),
            Data_Depennamento__c = dateToParse(data.get('dataDepennamento')),
            ndg__c = data.get('ndg'),
            Customer_Type__c=societa
        );
        System.debug('AccountUtils makeAccount res: '+res);
        return res;
    }
    
    public static Account makeAccount(OCSCliente cm,String company){
         system.debug('MakeAccount - OCSCliente: '+cm);
        Account res=new Account(
            LastName = String.isEmpty(cm.cognome)?cm.denominazioneAzienda:cm.cognome,
            OCS_External_id__c = cm.codCliente != null ? OCSCustomerChar+cm.codCliente : null,
            FirstName = cm.nome,
            Data_Nascita__c = dateToParse(cm.dataNascita),
            Luogo_Nascita__pc = cm.luogoNascita,
            Provincia_Nascita__pc = cm.provNascita,
            Sesso__pc = cm.sesso,
            Codice_Fiscale__pc = cm.codFiscale,
            Partita_IVA__pc = cm.piva,
            PersonMailingStreet = cm.indirizzo,
            PersonMailingPostalCode = cm.cap,
            PersonMailingCity = cm.localita,
            PersonMailingCountry = cm.provincia,
            PersonEmail = (cm.email != null && ValidationUtils.isEmailValida(cm.email)) ? cm.email : null,
            Tipo_documento__pc = cm.tipoDocumento,
            Numero_Documento__pc = cm.numDocumento,
            Ufficio_Rilascio__c = cm.ufficioRilascio,
            Luogo_Rilascio__pc = cm.luogoRilascio,
            Provincia_Rilascio__pc = cm.provRilascio,
            Data_Rilascio__pc = dateToParse(cm.dataRilascio),
            Denominazione_Azienda__c = cm.denominazioneAzienda,
            Forma_Giuridica__c = cm.formaGiuridica,
            Tipo_Anagrafica__pc = cm.tipoAnagrafica,
            Data_Scadenza__pc = dateToParse(cm.dataScadenza),
            Phone = cm.telefonoCasa != null ? cm.telefonoCasa.replaceAll('[^\\d]', '') : null,
            PersonMobilePhone = cm.telCellulare != null ? cm.telCellulare.replaceAll('[^\\d]', '') : null,
            Tipo_Rapporto__c = cm.tipoRapporto,
            Data_Depennamento__c = dateToParse(cm.dataDepennamento),
            ndg__c = cm.ndg,
            Customer_Type__c=company
        );
        System.debug('AccountUtils makeAccount res: '+res);
        return res;
    }

    public static Account makeDealerAccount(OCSCliente cm, String company){
        Account res=new Account(
            OCS_External_id__c = getDealerExternalId(cm.codCliente),
            Name = String.isNotEmpty(cm.denominazioneAzienda) ? cm.denominazioneAzienda : cm.cognome,
            Codice_Fiscale__c = cm.codFiscale,
            Partita_IVA__c = cm.piva,
            ShippingStreet = cm.indirizzo,
            ShippingPostalCode = cm.cap,
            ShippingCountry = cm.provincia,
            BusinessEmail__c = cm.email,
            Type_Anag__c = cm.tipoAnagrafica,
            Phone = cm.telefonoCasa == null ? null : (ValidationUtils.isTelefonoValido(cm.telefonoCasa) ? cm.telefonoCasa : null),
            Telefono_Cellulare__c = cm.telCellulare == null ? null : (ValidationUtils.isCellValido(cm.telCellulare) ? cm.telCellulare : null)
        );
        System.debug('AccountUtils makeAccount res: '+res);
        return res;
    }
 
    public static Account upsertAccount(Account acc,String company){
        system.debug('upsertAccount - Account: '+acc);
        Account res = new Account(                	
            recordtypeid = recordtypeUtil.getPersonRecordType(),
            LastName = String.isEmpty(acc.LastName)?acc.Denominazione_Azienda__c:acc.LastName,
            OCS_External_Id__c = acc.OCS_External_Id__c,
            FirstName = acc.FirstName,
            Data_Nascita__c = acc.Data_Nascita__c,
            Luogo_Nascita__pc = acc.Luogo_Nascita__pc,
            Provincia_Nascita__pc = acc.Provincia_Nascita__pc,
            Sesso__pc = acc.Sesso__pc,
            Codice_Fiscale__pc = acc.Codice_Fiscale__pc,
            Partita_IVA__pc = acc.Partita_IVA__pc,
            PersonMailingStreet = acc.PersonMailingStreet,
            PersonMailingPostalCode = acc.PersonMailingPostalCode,
            PersonMailingCity = acc.PersonMailingCity,
            PersonMailingCountry = acc.PersonMailingCountry,
            //PersonEmail = acc.PersonEmail,
            Tipo_Documento__pc = acc.Tipo_Documento__pc,
            Numero_Documento__pc = acc.Numero_Documento__pc,
            Ufficio_Rilascio__c = acc.Ufficio_Rilascio__c,
            Luogo_Rilascio__pc = acc.Luogo_Rilascio__pc,
            Provincia_Rilascio__pc = acc.Provincia_Rilascio__pc,
            Data_Rilascio__pc = acc.Data_Rilascio__pc,
            Denominazione_Azienda__c = acc.Denominazione_Azienda__c,
            Forma_Giuridica__c = acc.Forma_Giuridica__c,
            Tipo_Anagrafica__pc = acc.Tipo_Anagrafica__pc,
            Data_Scadenza__pc = acc.Data_Scadenza__pc,
            //Telefono_Casa__c = acc.Telefono_Casa__c,
            //Telefono_Cellulare__c = acc.Telefono_Cellulare__c,
            Tipo_Rapporto__c = acc.Tipo_Rapporto__c,
            Data_Depennamento__c = acc.Data_Depennamento__c,
            ndg__c = acc.ndg__c,
            Customer_Type__c=company
        );
        //TODO - Verificare le condizioni e le tipolgie di anagrafica
        System.debug('AccountUtils upsertAccount res: '+res);
       	upsert res OCS_External_Id__c;
        System.debug('AccountUtils upsertAccount res ID: '+res.Id);
        return res;
    }

    public static Account upsertAccount2(Account acc,String company){
        system.debug('upsertAccount2 - Account: '+acc);
        Account res = new Account(                	
            recordtypeid = recordtypeUtil.getPersonRecordType(),
            LastName = String.isEmpty(acc.LastName)?acc.Denominazione_Azienda__c:acc.LastName,
            OCS_External_Id__c = acc.OCS_External_Id__c,
            FirstName = acc.FirstName,
            Data_Nascita__c = acc.Data_Nascita__c,
            Luogo_Nascita__pc = acc.Luogo_Nascita__pc,
            Provincia_Nascita__pc = acc.Provincia_Nascita__pc,
            Sesso__pc = acc.Sesso__pc,
            Codice_Fiscale__pc = acc.Codice_Fiscale__pc,
            Partita_IVA__pc = acc.Partita_IVA__pc,
            PersonMailingStreet = acc.PersonMailingStreet,
            PersonMailingPostalCode = acc.PersonMailingPostalCode,
            PersonMailingCity = acc.PersonMailingCity,
            PersonMailingCountry = acc.PersonMailingCountry,
            PersonEmail = acc.PersonEmail,
            Tipo_Documento__pc = acc.Tipo_Documento__pc,
            Numero_Documento__pc = acc.Numero_Documento__pc,
            Ufficio_Rilascio__c = acc.Ufficio_Rilascio__c,
            Luogo_Rilascio__pc = acc.Luogo_Rilascio__pc,
            Provincia_Rilascio__pc = acc.Provincia_Rilascio__pc,
            Data_Rilascio__pc = acc.Data_Rilascio__pc,
            Denominazione_Azienda__c = acc.Denominazione_Azienda__c,
            Forma_Giuridica__c = acc.Forma_Giuridica__c,
            Tipo_Anagrafica__pc = acc.Tipo_Anagrafica__pc,
            Data_Scadenza__pc = acc.Data_Scadenza__pc,
            Telefono_Casa__c = acc.phone,
            Telefono_Cellulare__c = acc.PersonMobilePhone,
            Tipo_Rapporto__c = acc.Tipo_Rapporto__c,
            Data_Depennamento__c = acc.Data_Depennamento__c,
            ndg__c = acc.ndg__c,
            Customer_Type__c=company
        );
        //TODO - Verificare le condizioni e le tipolgie di anagrafica
        System.debug('AccountUtils upsertAccount res: '+res);
        upsert res;
        System.debug('AccountUtils upsertAccount res ID: '+res.Id);
        return res;
    }	
    
    public static List<Account> makeAccounts(List<OCSCliente> data,String company){
        List<Account> res=new List<Account>();
        for(OCSCliente c:data){
            res.add(makeAccount(c,company));
        }
        return res;
    }

    public static List<Account> makeDealerAccounts(List<OCSCliente> data, String company) {
        List<Account> res = new List<Account>();

        for (OCSCliente c : data) {
            res.add(makeDealerAccount(c, company));
        }
        return res;
    }
     
    public static List<Account> getBranchFromId(list<String> accountId)
    {    
          return [select ID, Name from account where id =:accountId];
    }
    
    public static List<string> parsgetBranchFromId (list<String> accountId)
    {  
       List<String> lString = new List<String>();
       for(Account r : getBranchFromId(accountId))
       {
          lString.add(r.Name); 
       }
        return lString;
    }
    
    public static void saveNote(String accountId, String note ){
        Account a = [SELECT Id,Note__c FROM Account WHERE Id =: accountId];
        a.Note__c=note;
        update(a);
    }
    
    public static boolean isDummy(Account a)
    {
        String OCS = String.isBlank(a.OCS_External_Id__c) ? '' : a.OCS_External_Id__c;
        return (OCS.equals(PADummyCode) || OCS.equals(branchDummyCode)|| OCS.equals(dealerDummyCode)) ? true : false;
    }
    public static Account getAccount(String OCSCODE)
    {
        return [select id from Account Where OCS_External_Id__c = :OCSCODE];
    }
    
	//Filtra una lista di account restituendo solo gli Account Dealer
	public static List<Account> filterDealer(List<Account> listAccount)
    {
        List<Account> listDealer = new List<Account>();
        Id dealerRecordTypeId = RecordTypeUtil.getDealerRecordType();
        for(Account a : listAccount)
        {
            if(a.RecordTypeid.Equals(dealerRecordTypeId))
            {
                listDealer.add(a);   
            }
        }
        return listDealer;
    }
    public static Map<id,Account> listToMap(List<Account> listAccount)
    {
     	Map<id,Account> accountMap = new Map<id,Account>();
        for(Account a : listAccount)
        {
            accountMap.put(a.id, a);
        }
        return accountMap;
    }

    public static Account getFilialeAccount(final String queueName) {
        final String recordTypeName = 'Branch';
        final Account acc = [SELECT Id, Region_Name__c, OCSAreaId__c, OCS_External_Id__c from Account where RecordType.Name =: recordTypeName and OCS_External_Id__c =: queueName];
        return acc;
    }
    
    
    
    @TestVisible
    private static Date dateToParse(String dateOCS){
        System.debug('OCSRecuperaDatiPostvenditaController dateToParse input: '+dateOCS);
        Date res = null; 
        try{
                if(dateOCS != '0' && dateOCS != null)
                { 
                
                    if(dateOCS.contains('/')){ 
                   		res =  Date.parse(dateOCS);
                    }
                    else if(dateOCS.contains('-')){
                    System.debug('anno' + Integer.valueOf(dateOCS.substring(0, 4)) + ' mese' + Integer.valueOf(dateOCS.substring(5,7)) + 'Giorno ' + Integer.valueOf(dateOCS.substring(8,10)));	
                     res = Date.newInstance(Integer.valueOf(dateOCS.substring(0, 4)), 
                                     	Integer.valueOf(dateOCS.substring(5,7)),
                                     	Integer.valueOf(dateOCS.substring(8,10)));
                    }
                    else{ 
                   		res =  Date.newInstance(Integer.valueOf(dateOCS.substring(0, 4)), 
                                     	Integer.valueOf(dateOCS.substring(4,6)),
                                     	Integer.valueOf(dateOCS.substring(6)));
                    }
                }
                else
                	res = null;

        }
        catch(Exception e){
            System.debug('AccountUtils dateToParse Exception, message: '+e.getCause()+'\n'+e.getStackTraceString());
        }
        return res;
    }
    
    @TestVisible
    private static String getEmail(String codCliente) {
        String res = '';
        List<Account> listAcc = [select Id, PersonEmail from Account where getCodice_Cliente__c = :codCliente];
        if(listAcc.size() > 0) {
            res = listAcc[0].PersonEmail;
        }
        return res;
    } 
}