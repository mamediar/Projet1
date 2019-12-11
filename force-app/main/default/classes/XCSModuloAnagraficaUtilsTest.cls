@IsTest
public class XCSModuloAnagraficaUtilsTest {
    private static String personRecordTypeId  = RecordTypeUtil.getPersonRecordType();

    @isTest 
    public static void coverageTest() {
        Account acc = new Account(recordTypeID = personRecordTypeId, PersonEmail='ciao', Phone='ciao');
        DealerAccount dAcc = new DealerAccount();
        dAcc.account = acc;
        
        XCSModuloAnagraficaUtils.isEmptyDealerAccount(dAcc);
        
        XCSModuloAnagraficaUtils.getCodiceOCSconPrefisso('12345', 'C');
        
        XCSModuloAnagraficaUtils.getFoundAccountsMap(new List<Account> {acc}, 'FirstName');
        
        try {XCSModuloAnagraficaUtils.checkValidEmail(null, acc, 'PersonEmail');} catch(Exception e) {}
        
        try {XCSModuloAnagraficaUtils.checkValidEmail(acc, 'PersonEmail');} catch(Exception e) {}
        
        try {XCSModuloAnagraficaUtils.checkValidPhone(acc, 'Phone');} catch(Exception e) {}
        
        XCSModuloAnagraficaUtils.getNoExternalIdAccountList(new List<Account> {acc});
        acc.OCS_External_Id__c = '1234';
        XCSModuloAnagraficaUtils.getExternalIdAccountMap(new List<Account> {acc});
        
        XCSModuloAnagraficaUtils.setDateField(acc, 'PersonBirthdate', '');
        XCSModuloAnagraficaUtils.setDateField(acc, 'PersonBirthdate', '1988-04-05');

        XCSModuloAnagraficaUtils.setPhoneField(acc, 'Phone', '');
        XCSModuloAnagraficaUtils.setPhoneField(acc, 'Phone', '123-346675');

        XCSModuloAnagraficaUtils.setBooleanField(acc, 'InvestFlag__pc', '');
        XCSModuloAnagraficaUtils.setBooleanField(acc, 'InvestFlag__pc', 'true');

        XCSModuloAnagraficaUtils.setNumberField(acc, 'Is_Ag__c', '');
        XCSModuloAnagraficaUtils.setNumberField(acc, 'Is_Ag__c', '1');
        
        XCSModuloAnagraficaUtils.setStringField(acc, 'FirstName', '');
        XCSModuloAnagraficaUtils.setStringField(acc, 'FirstName', 'Paperino');
    }

}