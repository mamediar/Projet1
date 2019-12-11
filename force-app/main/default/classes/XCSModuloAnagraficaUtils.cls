public class XCSModuloAnagraficaUtils {

    public static Boolean isEmptyDealerAccount(final DealerAccount acc) {
        return acc == null || acc.Account == null;
    }

    public static String getCodiceOCSconPrefisso(final String ocsCode, final String prefix) {
        String ocsId = ocsCode;
        if (String.isNotBlank(ocsCode) && ocsCode.length() > 1 && ocsCode.substring(0,1).isNumeric()) {
            ocsId = prefix + ocsCode;
        }
        return ocsId;
    }

    public static Map<String, Account> getFoundAccountsMap (final List<Account> foundAccounts, final String fieldName) {
        final Map<String, Account> foundAccountsMap = new Map<String, Account>();
        for (Account foundAccount : foundAccounts) {
            System.debug('found Account: ' + foundAccount);
            String fieldValue = (String)foundAccount.get(fieldName);
            System.debug('found fieldValue: ' + fieldValue);
            foundAccountsMap.put(fieldValue, foundAccount);
        }
        return foundAccountsMap;
    }

    public static void checkValidEmail(Map<String, Object> populatedFieldsMap, Account inputAccount, String emailField) {
        System.debug(LoggingLevel.DEBUG, 'Checking email on field ' + emailField);
        String email = (String) inputAccount.get(emailField);
        System.debug(LoggingLevel.DEBUG, 'Email value: ' + email);
        if (String.isEmpty(email)) return;
        if (String.isEmpty((String) populatedFieldsMap.get(emailField))) return;
        final Boolean isEmailValida = ValidationUtils.isEmailValida(email);
        
        if (!isEmailValida) {
            System.debug(LoggingLevel.DEBUG, 'Email value not valid');
            populatedFieldsMap.put('EmailNonConforme__c', populatedFieldsMap.get(emailField));
            populatedFieldsMap.remove(emailField);
        }
    }

    public static void checkValidEmail(final Account inputAccount, String emailField) {
        System.debug(LoggingLevel.DEBUG, 'Checking email on field ' + emailField);
        String email = (String) inputAccount.get(emailField);
        System.debug(LoggingLevel.DEBUG, 'Email value: ' + email);
        if (String.isEmpty(email)) return;
        Boolean isEmailValida = ValidationUtils.isEmailValida(email);
        if (!isEmailValida) {
            System.debug(LoggingLevel.DEBUG, 'Email value not valid');
            inputAccount.EmailNonConforme__c = email;
            inputAccount.put(emailField, null);
        }    
    }

    public static void checkValidPhone(Map<String, Object> populatedFieldsMap, Account inputAccount, String phoneField) {
        String phone = (String) inputAccount.get(phoneField);
        if (String.isEmpty(phone)) return;
        if (String.isEmpty((String)populatedFieldsMap.get(phoneField))) return;
        populatedFieldsMap.put(phoneField, phone.replaceAll('[^\\d]', ''));
    }

    public static void checkValidPhone(final Account inputAccount, String phoneField) {
        String phone = (String) inputAccount.get(phoneField);
        if (String.isEmpty(phone)) return;
        inputAccount.put(phoneField, phone.replaceAll('[^\\d]', '')); 
    }
    
    public static List<Account> getNoExternalIdAccountList(List<Account> accountList) {
        List<Account> noExternalIdAccountList = new List<Account>();
        for (Account account : accountList) {
            if (account.OCS_External_Id__c == null)
                noExternalIdAccountList.add(account);
        }
        return noExternalIdAccountList;
    }

    public static Map<String, Account> getExternalIdAccountMap(List<Account> accountToCreateList) {
        final Map<String, Account> externalIdAccountMap = new Map<String, Account>();
        for (Account account : accountToCreateList) {
            if (account.OCS_External_Id__c <> null && externalIdAccountMap.get(account.OCS_External_Id__c) == null)
                externalIdAccountMap.put(account.OCS_External_Id__c, account);
        }
        return externalIdAccountMap;
    }

    public static void setStringField(Account account, String fieldName, String fieldValue) {
        if (fieldValue == null) return;
        if (fieldValue.trim().equals('')) account.put(fieldName, null);
        else account.put(fieldName, fieldValue);
    }

    public static void setNumberField(Account account, String fieldName, String fieldValue) {
        if (fieldValue == null) return;
        if (fieldValue.trim().equals('')) { account.put(fieldName, null); return; }
        if (!fieldValue.isNumeric()) return;
        account.put(fieldName, Integer.valueOf(fieldValue));
    }

    public static void setBooleanField(Account account, String fieldName, String fieldValue) {
        if (fieldValue == null) return;
        if (fieldValue.trim().equals('')) account.put(fieldName, null);
        else account.put(fieldName, Boolean.valueOf(fieldValue));
    }

    public static void setDateField(Account account, String fieldName, String fieldValue) {
        if (fieldValue == null) return;
        if (fieldValue.trim().equals('')) account.put(fieldName, null);
        else if (XCSDataUtils.checkYYYYMMddWithDashes(fieldValue)) {
            account.put(fieldName, DateUtils.parseFromYYYYMMDDString(fieldValue.replaceAll('\\-','')));
        }
    }

    public static void setPhoneField(Account account, String fieldName, String fieldValue) {
        if (fieldValue == null) return;
        if (fieldValue.trim().equals('')) account.put(fieldName, null);
        else account.put(fieldName, fieldValue.replaceAll('[^\\d]', ''));
    }

    public static final String PERSON_FIELDS = 
    'Id, PersonContactId, Name, OCS_External_Id__c, Codice_Fiscale__pc, RSS_External_Id__c, FirstName, LastName, PersonEmail, EmailNonConforme__c, PersonBirthdate, Birthcity__c, Birthprovince__c, Birthstate__c, Sesso__pc, ShippingStreet, ShippingCity, ShippingCountry, ShippingPostalCode, Phone, PersonMobilePhone, PersonOtherPhone, Occupation_Lvl1__c, Occupation_Lvl2__c, Status__pc, InvestFlag__pc, Qualitydetectionflag__pc, Interncommoffer__pc, Extcommoffer__pc, OtherService__pc, Privacy_Profilazione__pc';
  
    public static final String BASE_QUERY = 'SELECT ' + XCSModuloAnagraficaUtils.PERSON_FIELDS + ' FROM Account WHERE RecordType.Name = \'Person Account\' AND ';

}