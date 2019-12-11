public class RecordTypeUtil {
    
    public static FINAL String RETENTIONCLIENTE = 'CRMRetentionCliente';
    public static FINAL String SFA_CONVENZIONAMENTO = 'SFA_Convenzionamento';
    public static FINAL String SMS = 'SMS';
    public static FINAL String XCSMESSAGGIO = 'XCS_Messaggio__c';
    public static FINAL String CRM_POSTVENDITA_RT = 'XCS_Post_Vendita';
    public static FINAL String CUSTOMER_SATISFACTION_ESITO = 'Customer_Satisfaction_Esito';
    public static FINAL String CRM_ATTIVITA_FAX = 'CRM_Attivita_Fax';

    
    //object name
    public static FINAL String API_NAME_CASE = 'Case';

    
    public static Id getRecordType(String objectApiName, String recordTypeDeveloperName) {        
        return Schema.getGlobalDescribe().get(objectApiName).getDescribe()
            .getRecordTypeInfosByDeveloperName()
            .get(recordTypeDeveloperName)
            .getRecordTypeId();
    }
    
    public static Id getDealerRecordType()
    {
        return getRecordType( 'Account', 'Dealer' );
    }
    
    public static Id getBranchRecordType()
    {
        return getRecordType( 'Account', 'Branch' );
    }
    
    public static Id getCaseRecordType(String recordTypeDeveloperName)
    {
        return getRecordType( 'Case', recordTypeDeveloperName );
    }

    public static Id getPersonRecordType()
    {
        return getRecordType( 'Account', 'PersonAccount' );
    }
}