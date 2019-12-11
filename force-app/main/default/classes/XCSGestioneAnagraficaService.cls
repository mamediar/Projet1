@RestResource (urlMapping='/GestioneAnagrafica/*')
global with sharing class XCSGestioneAnagraficaService {

    @HttpPost
    global static void execute() {
        final RestRequest req = RestContext.request;
        final RestResponse res = Restcontext.response;
        
        if (req == null || req.requestBody == null) {
            res.responseBody = Blob.valueOf('Null request received');
            res.statusCode = 400;
            return;
        }
        String requestStr = req.requestBody.toString();
        if (requestStr == null || requestStr.trim().equals('')) {
            res.responseBody = Blob.valueOf('Empty request body received');
            res.statusCode = 400;
            return;
        }

        String jsonResponse = '';
        
        try {
            jsonResponse = execute(requestStr.trim());
            res.responseBody = Blob.valueOf(jsonResponse);
            res.statusCode = 200;
        }
        catch(Exception e) {
            res.responseBody = Blob.valueOf(e.getMessage());
            res.statusCode = 500;
            return;
        }
    }

    public static String execute(final String jsonRequest) {
        final AnagraficaRequest request = (AnagraficaRequest) JSON.deserialize(jsonRequest, AnagraficaRequest.class);
        
        System.debug(LoggingLevel.DEBUG, 'Input JSON deserialized in ' + request);
        
        final AccountData[] accountDataArr = request.ACCOUNTS;
        Account[] inputAccounts = new Account[accountDataArr.size()];

        System.debug(LoggingLevel.DEBUG, 'Creating ' + accountDataArr.size() + ' input Accounts');

        Map<Account, Account> accountMap = new Map<Account, Account>();

        for (Integer i = 0; i < accountDataArr.size(); i++) {
            inputAccounts[i] = createInputAccount(accountDataArr[i]);
            accountMap.put(inputAccounts[i], null);
        }

        XCSGestioneAnagrafica.executeFromWS(accountMap, isFromOCS(request), isProspect(request));

        final AnagraficaResponse response = new AnagraficaResponse();
        response.ACCOUNTS = new AccountData[inputAccounts.size()];

        for (Integer i = 0; i < inputAccounts.size(); i++) {  
            Account account = accountMap.get(inputAccounts[i]);
            //if (account == null) {
            //    account = XCSRicercaAnagrafica.ricercaAccount(inputAccounts[i]);
            //}

            response.ACCOUNTS[i] = new AccountData();
            setOutputAccountData(account, response.ACCOUNTS[i]);
        }
        return JSON.serialize(response);
    }

    private static Account createInputAccount(AccountData inputAccountData) {
        Account account = new Account(RecordTypeID = personRecordTypeId);
        XCSModuloAnagraficaUtils.setStringField(account, 'OCS_External_Id__c', inputAccountData.OCS_ID);
        XCSModuloAnagraficaUtils.setStringField(account, 'Codice_Fiscale__pc', inputAccountData.FISCALCODE);
        XCSModuloAnagraficaUtils.setStringField(account, 'RSS_External_Id__c', inputAccountData.CRM_ID);
        XCSModuloAnagraficaUtils.setStringField(account, 'FirstName', inputAccountData.FIRSTNAME);
        XCSModuloAnagraficaUtils.setStringField(account, 'LastName', inputAccountData.LASTNAME);
        XCSModuloAnagraficaUtils.setStringField(account, 'PersonEmail', inputAccountData.EMAIL);
        XCSModuloAnagraficaUtils.setDateField(account, 'PersonBirthdate', inputAccountData.BIRTHDATE);
        XCSModuloAnagraficaUtils.setStringField(account, 'Birthcity__c', inputAccountData.BIRTHCITY);
        XCSModuloAnagraficaUtils.setStringField(account, 'Birthprovince__c', inputAccountData.BIRTHPROVINCE);
        XCSModuloAnagraficaUtils.setStringField(account, 'Birthstate__c', inputAccountData.BIRTHSTATE );
        XCSModuloAnagraficaUtils.setStringField(account, 'Sesso__pc', inputAccountData.SEX);
        XCSModuloAnagraficaUtils.setStringField(account, 'ShippingStreet', inputAccountData.STREET);
        XCSModuloAnagraficaUtils.setStringField(account, 'ShippingCity', inputAccountData.CITY);
        XCSModuloAnagraficaUtils.setStringField(account, 'ShippingCountry', inputAccountData.PROVINCE);
        XCSModuloAnagraficaUtils.setPhoneField(account, 'Phone', inputAccountData.PHONE);
        XCSModuloAnagraficaUtils.setPhoneField(account, 'PersonMobilePhone', inputAccountData.MOBILE);
        XCSModuloAnagraficaUtils.setPhoneField(account, 'PersonOtherPhone', inputAccountData.OFFICEPHONE);
        XCSModuloAnagraficaUtils.setStringField(account, 'Occupation_Lvl1__c', inputAccountData.OCCUPATION_LVL1);
        XCSModuloAnagraficaUtils.setStringField(account, 'Occupation_Lvl2__c', inputAccountData.OCCUPATION_LVL2);
        XCSModuloAnagraficaUtils.setStringField(account, 'Status__pc', inputAccountData.STATUS);
        XCSModuloAnagraficaUtils.setBooleanField(account, 'InvestFlag__pc', inputAccountData.INVEST_FLAG);
        XCSModuloAnagraficaUtils.setBooleanField(account, 'Qualitydetectionflag__pc', inputAccountData.QUALITYDETECTION_FLAG);
        XCSModuloAnagraficaUtils.setBooleanField(account, 'Interncommoffer__pc', inputAccountData.INTERNCOMMOFFER_FLAG);
        XCSModuloAnagraficaUtils.setBooleanField(account, 'Extcommoffer__pc', inputAccountData.EXTCOMMOFFER_FLAG);
        XCSModuloAnagraficaUtils.setBooleanField(account, 'OtherService__pc', inputAccountData.OTHERSERVICE_FLAG);
        XCSModuloAnagraficaUtils.setBooleanField(account, 'Privacy_Profilazione__pc', inputAccountData.PRIVACY_PROFILING);
        return account;
    }

    private static void setOutputAccountData(Account account, AccountData outputAccountData) {
        if (account == null) return;
        if (account.Id <> null) outputAccountData.ID = String.valueOf(account.Id);
        if (account.PersonContactId <> null) outputAccountData.CONTACT_ID = String.valueOf(account.PersonContactId);
        if (account.OCS_External_Id__c <> null) outputAccountData.OCS_ID = String.valueOf(account.OCS_External_Id__c);
        if (account.Codice_Fiscale__pc <> null) outputAccountData.FISCALCODE = String.valueOf(account.Codice_Fiscale__pc);
        if (account.RSS_External_Id__c <> null) outputAccountData.CRM_ID = String.valueOf(account.RSS_External_Id__c);
        if (account.FirstName <> null) outputAccountData.FIRSTNAME = String.valueOf(account.FirstName);
        if (account.LastName <> null) outputAccountData.LASTNAME = String.valueOf(account.LastName);
        if (account.PersonEmail <> null) outputAccountData.EMAIL = String.valueOf(account.PersonEmail);
        if (account.PersonBirthdate <> null) outputAccountData.BIRTHDATE = String.valueOf(account.PersonBirthdate);
        if (account.Birthcity__c <> null) outputAccountData.BIRTHCITY = String.valueOf(account.Birthcity__c);
        if (account.Birthprovince__c <> null) outputAccountData.BIRTHPROVINCE = String.valueOf(account.Birthprovince__c);
        if (account.Birthstate__c <> null) outputAccountData.BIRTHSTATE  = String.valueOf(account.Birthstate__c);
        if (account.Sesso__pc <> null) outputAccountData.SEX = String.valueOf(account.Sesso__pc);
        if (account.ShippingStreet <> null) outputAccountData.STREET = String.valueOf(account.ShippingStreet);
        if (account.ShippingCity <> null) outputAccountData.CITY = String.valueOf(account.ShippingCity);
        if (account.ShippingCountry <> null) outputAccountData.PROVINCE = String.valueOf(account.ShippingCountry);
        if (account.ShippingPostalCode <> null) outputAccountData.CAP = String.valueOf(account.ShippingPostalCode);
        if (account.Phone <> null) outputAccountData.PHONE = String.valueOf(account.Phone);
        if (account.PersonMobilePhone <> null) outputAccountData.MOBILE = String.valueOf(account.PersonMobilePhone);
        if (account.PersonOtherPhone <> null) outputAccountData.OFFICEPHONE = String.valueOf(account.PersonOtherPhone);
        if (account.Occupation_Lvl1__c <> null) outputAccountData.OCCUPATION_LVL1 = String.valueOf(account.Occupation_Lvl1__c);
        if (account.Occupation_Lvl2__c <> null) outputAccountData.OCCUPATION_LVL2 = String.valueOf(account.Occupation_Lvl2__c);
        if (account.Status__pc <> null) outputAccountData.STATUS = String.valueOf(account.Status__pc);
        if (account.InvestFlag__pc <> null) outputAccountData.INVEST_FLAG = String.valueOf(account.InvestFlag__pc);
        if (account.Qualitydetectionflag__pc <> null) outputAccountData.QUALITYDETECTION_FLAG = String.valueOf(account.Qualitydetectionflag__pc);
        if (account.Interncommoffer__pc <> null) outputAccountData.INTERNCOMMOFFER_FLAG = String.valueOf(account.Interncommoffer__pc);
        if (account.Extcommoffer__pc <> null) outputAccountData.EXTCOMMOFFER_FLAG = String.valueOf(account.Extcommoffer__pc);
        if (account.OtherService__pc <> null) outputAccountData.OTHERSERVICE_FLAG = String.valueOf(account.OtherService__pc);
        if (account.Privacy_Profilazione__pc <> null) outputAccountData.PRIVACY_PROFILING = String.valueOf(account.Privacy_Profilazione__pc);
    }

    public static Boolean isFromOCS(AnagraficaRequest request) {
        return 'OCS'.equalsIgnoreCase(request.DATA_SOURCE) ? true : false;
    }

    public static Boolean isProspect(AnagraficaRequest request) {
        return request.PROSPECT == null ? false : Boolean.valueOf(request.PROSPECT);
    }

    public class AnagraficaRequest {
        public String DATA_SOURCE;
        public Boolean PROSPECT;
        public AccountData[] ACCOUNTS; 
    }

    public class AnagraficaResponse {
        public AccountData[] ACCOUNTS; 
    }

    public class AccountData {
        public String ID;
        public String CONTACT_ID;
        public String OCS_ID;
        public String FISCALCODE;
        public String CRM_ID;
        public String FIRSTNAME;
        public String LASTNAME;
        public String EMAIL;
        public String BIRTHDATE;
        public String BIRTHCITY;
        public String BIRTHPROVINCE;
        public String BIRTHSTATE ;
        public String SEX;
        public String STREET;
        public String CITY;
        public String PROVINCE;
        public String CAP;
        public String PHONE;
        public String MOBILE;
        public String OFFICEPHONE;
        public String OCCUPATION_LVL1;
        public String OCCUPATION_LVL2;
        public String STATUS;
        public String INVEST_FLAG;
        public String QUALITYDETECTION_FLAG;
        public String INTERNCOMMOFFER_FLAG;
        public String EXTCOMMOFFER_FLAG;
        public String OTHERSERVICE_FLAG;
        public String PRIVACY_PROFILING;
    }

    private static final String personRecordTypeId  = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
}