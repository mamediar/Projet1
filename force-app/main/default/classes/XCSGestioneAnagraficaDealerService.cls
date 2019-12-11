@RestResource (urlMapping='/GestioneAnagraficaDealer/*')
global with sharing class XCSGestioneAnagraficaDealerService {
    
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
            jsonResponse = executeService(requestStr.trim());
            res.responseBody = Blob.valueOf(jsonResponse);
            res.statusCode = 200;
        }
        catch(Exception e) {
            res.responseBody = Blob.valueOf(e.getMessage());
            res.statusCode = 500;
            return;
        }
    }

    public static String executeService(final String jsonRequest) {
        final AnagraficaDealerRequest request = (AnagraficaDealerRequest) JSON.deserialize(jsonRequest, AnagraficaDealerRequest.class);
        
        System.debug(LoggingLevel.DEBUG, 'Input JSON deserialized in ' + request);
        
        final DealerAccountData[] accountDataArr = request.ACCOUNTS;
        Account[] inputAccounts = new Account[accountDataArr.size()];

        System.debug(LoggingLevel.DEBUG, 'Creating ' + accountDataArr.size() + ' input Dealer Accounts');

        final Map<Account, DealerAccount> accountMap = new Map<Account, DealerAccount>();

        for (Integer i = 0; i < accountDataArr.size(); i++) {
            inputAccounts[i] = createInputAccount(accountDataArr[i]);
            accountMap.put(inputAccounts[i], null);
        }

        XCSGestioneAnagraficaDealer.executeFromWS(accountMap, isFromOCS(request));

        final AnagraficaDealerResponse response = new AnagraficaDealerResponse();
        response.ACCOUNTS = new DealerAccountData[inputAccounts.size()];

        for (Integer i = 0; i < inputAccounts.size(); i++) {  
            DealerAccount dealerAcc = accountMap.get(inputAccounts[i]);

            response.ACCOUNTS[i] = new DealerAccountData();
            setOutputAccountData(dealerAcc, response.ACCOUNTS[i]);
        }
        return JSON.serialize(response);
    }

    private static Account createInputAccount(DealerAccountData inputAccountData) {
        Account account = new Account(RecordTypeID = dealerRecordTypeId);
        XCSModuloAnagraficaUtils.setStringField(account, 'OCS_External_Id__c', inputAccountData.OCS_ID);
        XCSModuloAnagraficaUtils.setStringField(account, 'Codice_Fiscale__c', inputAccountData.FISCALCODE);
        XCSModuloAnagraficaUtils.setStringField(account, 'Partita_IVA__c', inputAccountData.P_IVA);
        XCSModuloAnagraficaUtils.setStringField(account, 'Name', inputAccountData.RAGIONE_SOC);
        XCSModuloAnagraficaUtils.setStringField(account, 'BusinessEmail__c', inputAccountData.EMAIL);
        XCSModuloAnagraficaUtils.setDateField  (account, 'Tipo_Intermediario__c', inputAccountData.TIPO_INTERM);
        XCSModuloAnagraficaUtils.setNumberField(account, 'Is_Ag__c', inputAccountData.IS_AG);
        XCSModuloAnagraficaUtils.setNumberField(account, 'Is_Sa__c', inputAccountData.IS_SA);
        XCSModuloAnagraficaUtils.setNumberField(account, 'Is_Pv__c', inputAccountData.IS_PV);
        XCSModuloAnagraficaUtils.setNumberField(account, 'is_cv__c', inputAccountData.IS_CV);
        XCSModuloAnagraficaUtils.setStringField(account, 'Tipo_Accordo_New__c', inputAccountData.TIPO_ACCORDO);
        XCSModuloAnagraficaUtils.setStringField(account, 'Type_Anag__c', inputAccountData.TIPO_ANAG);
        XCSModuloAnagraficaUtils.setStringField(account, 'CodiceAgente__c', inputAccountData.COD_AGENTE);
        XCSModuloAnagraficaUtils.setStringField(account, 'Macroarea__c', inputAccountData.MACRO_AREA);
        XCSModuloAnagraficaUtils.setStringField(account, 'ProdottoDominanteMacroarea__c', inputAccountData.PROD_DOM);
        XCSModuloAnagraficaUtils.setStringField(account, 'ShippingStreet', inputAccountData.STREET);
        XCSModuloAnagraficaUtils.setStringField(account, 'ShippingCity', inputAccountData.CITY);
        XCSModuloAnagraficaUtils.setStringField(account, 'ShippingCountry', inputAccountData.PROVINCE);
        XCSModuloAnagraficaUtils.setStringField(account, 'ShippingPostalCode', inputAccountData.CAP);
        XCSModuloAnagraficaUtils.setPhoneField(account, 'Phone', inputAccountData.PHONE);
        XCSModuloAnagraficaUtils.setPhoneField(account, 'Telefono_Cellulare__c', inputAccountData.MOBILE);
        XCSModuloAnagraficaUtils.setPhoneField(account, 'Fax', inputAccountData.FAX);
        return account;
    }

    private static void setOutputAccountData(DealerAccount dealerAcc, DealerAccountData outputAccountData) {
        if (dealerAcc == null) return;
        final Account account = dealerAcc.account;
        
        if (account == null) return;
        if (account.Id <> null) outputAccountData.ID = String.valueOf(account.Id);
        if (account.OCS_External_Id__c <> null) outputAccountData.OCS_ID = String.valueOf(account.OCS_External_Id__c);
        if (account.Codice_Fiscale__c <> null) outputAccountData.FISCALCODE = String.valueOf(account.Codice_Fiscale__c);
        if (account.Partita_IVA__c <> null) outputAccountData.P_IVA = String.valueOf(account.Partita_IVA__c);
        if (account.Name <> null) outputAccountData.RAGIONE_SOC = String.valueOf(account.Name);
        if (account.BusinessEmail__c <> null) outputAccountData.EMAIL = String.valueOf(account.BusinessEmail__c);
        if (account.Tipo_Intermediario__c <> null) outputAccountData.TIPO_INTERM = String.valueOf(account.Tipo_Intermediario__c);
        if (account.Is_Ag__c <> null) outputAccountData.IS_AG = String.valueOf(account.Is_Ag__c);
        if (account.Is_Sa__c <> null) outputAccountData.IS_SA = String.valueOf(account.Is_Sa__c);
        if (account.Is_Pv__c <> null) outputAccountData.IS_PV = String.valueOf(account.Is_Pv__c);
        if (account.is_cv__c <> null) outputAccountData.IS_CV = String.valueOf(account.is_cv__c);
        if (account.Tipo_Accordo_New__c <> null) outputAccountData.TIPO_ACCORDO = String.valueOf(account.Tipo_Accordo_New__c);
        if (account.Type_Anag__c <> null) outputAccountData.TIPO_ANAG  = String.valueOf(account.Type_Anag__c);
        if (account.CodiceAgente__c <> null) outputAccountData.COD_AGENTE = String.valueOf(account.CodiceAgente__c);
        if (account.Macroarea__c <> null) outputAccountData.MACRO_AREA = String.valueOf(account.Macroarea__c);
        if (account.ProdottoDominanteMacroarea__c <> null) outputAccountData.PROD_DOM = String.valueOf(account.ProdottoDominanteMacroarea__c);
        if (account.ShippingStreet <> null) outputAccountData.STREET = String.valueOf(account.ShippingStreet);
        if (account.ShippingCity <> null) outputAccountData.CITY = String.valueOf(account.ShippingCity);
        if (account.ShippingCountry <> null) outputAccountData.PROVINCE = String.valueOf(account.ShippingCountry);
        if (account.ShippingPostalCode <> null) outputAccountData.CAP = String.valueOf(account.ShippingPostalCode);
        if (account.Phone <> null) outputAccountData.PHONE = String.valueOf(account.Phone);
        if (account.Telefono_Cellulare__c <> null) outputAccountData.MOBILE = String.valueOf(account.Telefono_Cellulare__c);
        if (account.Fax <> null) outputAccountData.FAX = String.valueOf(account.Fax);
        
        final Contact contact = dealerAcc.contact;
        if (contact == null) return;
        if (contact.Id <> null) outputAccountData.CONTACT_ID = String.valueOf(contact.Id);
    }

    public static Boolean isFromOCS(AnagraficaDealerRequest request) {
        return 'OCS'.equalsIgnoreCase(request.DATA_SOURCE) ? true : false;
    }

    public class AnagraficaDealerRequest {
        public String DATA_SOURCE;
        public DealerAccountData[] ACCOUNTS; 
    }

    public class AnagraficaDealerResponse {
        public DealerAccountData[] ACCOUNTS; 
    }

    public class DealerAccountData {
        public String ID;
        public String CONTACT_ID;
        public String OCS_ID;
        public String FISCALCODE;
        public String P_IVA;
        public String RAGIONE_SOC;
        public String EMAIL;
        public String TIPO_INTERM;
        public String IS_AG;
        public String IS_SA;
        public String IS_PV;
        public String IS_CV;
        public String TIPO_ACCORDO;
        public String TIPO_ANAG;
        public String COD_AGENTE;
        public String MACRO_AREA;
        public String PROD_DOM;
        public String STREET;
        public String CITY;
        public String PROVINCE;
        public String CAP;
        public String PHONE;
        public String MOBILE;
        public String FAX;
    }

    private static String dealerRecordTypeId  = RecordTypeUtil.getDealerRecordType();

}