public class XCS_CategoriaUtil 
{
  public static final String BACKOFFICEINBOUNDCATEGORYCODE = '1036';
    public static final String PV_DA_CUSTOMER_SERVICE_A_FILIALE = '1772';
    
    //CATEGORIE PER PROCESSO DI CONVENZIONAMENTO
    public static final String SFA_CONVENZIONAMENTO_SEGNALAZ_DEALER = 'AT0111';
    public static final String SFA_CONVENZIONAMENTO_NEW_DEALER_PROSPECT = '3127';
  public static final String SFA_CONVENZIONAMENTO_NEW_DEALER_ACQUISITION = '3128';    
    public static final String SFA_CONVENZIONAMENTO_GESTIONE_DOSSIER_DEALER = '1879'; 
    public static final String SFA_CONVENZIONAMENTO_GESTIONE_ACCOLLO_DEALER = '3709';
    public static final String SFA_CONVENZIONAMENTO_GESTIONE_DOSSIER_ACCOLLO_FITT ='2324';
    
    //CATEGORIE PER AUI
    public static final String AUI_RECUPERO_DOCUMENTI_SCADUTI = '5616';
    public static final String AUI_GESTIONE_FAX_MAIL = '5622';

  //CATEGORIA ACTIVITY
  
     public static final String OUTBOUND_CALLING_RETENTION = 'AT0117'; 
    
    // CATEGORIA COMMODITY CHECK
     public static final String COMMODITY_CHECK_ANOMALY = 'AT0090'; 
     public static final String COMMODITY_CHECK_CRITICAL = 'AT0089'; 
     public static final String COMMODITY_CHECK_VARIAZIONE_ANAGRAFICA = 'AT0091'; 
 


    //Metodo che instanzia un oggetto da utilizzare con la SMART LOOKUP
    public static XCS_Categoria__c getCategoryForExternalId(String externalId)
    {
        return new XCS_Categoria__c(External_Id__c = externalId);
    }
    
    public static XCS_Categoria__c findCategoryByExternalID(String strOCSExternalID) {
                
        List<XCS_Categoria__c> categories = [Select Id, Name, TKTOfficeType__c, Parent__c, Parent__r.Name,External_Id__c from XCS_Categoria__c where External_Id__c = :strOCSExternalID];
        if (!(categories.isEmpty())) {
            return categories[0];
        }  else {
            throw new UnexpectedException('Categoria '+ strOCSExternalID +' mancante.');
        }
                     
    } 
}