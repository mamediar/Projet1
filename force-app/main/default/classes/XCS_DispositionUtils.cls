public class XCS_DispositionUtils {
	
    //SEGNALAZIONE DEALER:
    public static final String NON_INTERESSATO = 'AO310';
    public static final String NONFATTIBILE_PERSETTORE = 'AO311';
    public static final String NONFATTIBILE_ALTRO = 'AO312';
    public static final String RIFIUTO_DA_FILIALE = 'AO313';
    public static final String APPUNTAMENTO_FISSATOSEGNALAZ = 'AO314';
    public static final String PROCESSO_DI_CONVENZIONAMENTO = 'AO315';
    public static final String CONVENZ_GIA_ATTIVA = 'AO316';    
	public static final String PROSPECT_RESPINTO = 'AO17';
	public static final String IN_CONVENZIONAMENTO = 'AO18';
	public static final String PROSPECT_NON_INTERESSATO = 'AO20';
	public static final String NECESSARIA_ULTERIORE_VISITA = 'AO21';
    
    public static final String APPUNTAMENTO_FISSATO_ESITO = 'DP1044';

    //GESTIONE DOSSIER:
    public static final String NUOVO_DOSSIER = 'DP1908';
    public static final String NUOVO_ACCOLLO = 'DP1908';
    public static final String DOSSIER_COMPLETO_INSPEDIZIONE= 'DP1909';
    public static final String DOSSIER_INCOMPLETO_FI= 'DP1910';  
    public static final String DOSSIER_DISPONIBILE = 'DP1911';
    public static final String DOSSIER_INCOMPLETO_IDM = 'DP1912';
    public static final String DOSSIER_APPROVATO = 'DP1913';
    public static final String DOSSIER_INCOMPLETO_MD= 'DP1914';
    public static final String DOSSIER_RESPINTO = 'DP1915';

    public static final String NON_INTERESSATO_ALLA_PROPOSTA = 'DP1644';    
    public static final String DOSSIER_SOSPESO_MD= 'DP2086';
    public static final String RETENTION_INSERITA = 'DP2231';
    
    public static final String APPUNTAMENTO_FISSATO = 'ID26';
    
    public static FINAL String NO_APPUNTAMENTO = '';
	
  //  public static final String ACCOLLO_COMPLETO_INSPEDIZIONE= 'DP1909';
//    public static final String ACCOLLO_INCOMPLETO_FI= 'DP1910';  
 //   public static final String ACCOLLO_DISPONIBILE = 'DP1911';
    
    public static final String ACCOLLO_INCOMPLETO_IDM = 'DP3741';
    public static final String ACCOLLO_COMPLETO_IDM = 'DP3742';
   //public static final String ACCOLLO_APPROVATO = 'DP1913';
    
    public static final String ACCOLLO_COMPLETO_FILIALE= 'DP3740';
    
    public static final String ACCOLLO_INCOMPLETO_MD= 'DP3743';
    public static final String ACCOLLO_ANNULLATO_MD= 'DP5518';
    public static final String ACCOLLO_APPROVATO_MD= 'DP3745';
    public static final String ACCOLLO_RESPINTO_MD = 'DP3746';
    public static final String ACCOLLO_SOSPESO_MD = 'DP3744';
    
    
    // ACTIVITY ITEM DISPOSITION
    
    public static FINAL String ACTIVITY_ITEM_APPUNTAMENTO_FISSATO = 'ID26';
    
    
	public static Case aggiungiDispositionCase(Case c, String dispositionCode) { 
		XCS_Disposition__c disposition = new XCS_Disposition__c(External_Id__c = dispositionCode);
        c.Disposition__r = disposition;    
        return c;
    }
    
    public static XCS_Disposition__c getInstanceWithExternalID(String externalId)
    {
        return new XCS_Disposition__c(External_Id__c = externalId);
    }
    
    public static XCS_Disposition__c getDisposition(Id dispositionId){   //Disposition__c è una lookup verso l'oggetto XCS_Disposition
        return [SELECT Id, Name, External_Id__c FROM XCS_Disposition__c WHERE Id =:dispositionId][0];
    } 
    
    public static String getDispositionExternalId(Id dispositionId){   //Disposition__c è una lookup verso l'oggetto XCS_Disposition
        return [SELECT Id,  Name, External_Id__c FROM XCS_Disposition__c WHERE Id =:dispositionId][0].External_Id__c;
    }     
    
    public static XCS_Disposition__c findDispositionByExternalID(String dispositionExternalID){   //Disposition__c è una lookup verso l'oggetto XCS_Disposition
        return [SELECT Id, External_Id__c, name,Parent__c FROM XCS_Disposition__c WHERE External_Id__c =:dispositionExternalID][0];
    }
    
    public static String getParentHierarchy(String hierarchy, XCS_Disposition__c node)
    {
        if(String.isNotBlank(node.parent__c))
        {
            XCS_Disposition__c parentNode = [Select id,Name,Parent__c from XCS_Disposition__c where id = :node.Parent__c];
            hierarchy = getParentHierarchy(hierarchy,parentNode);
            hierarchy += parentNode.name + '/';
        }
        return hierarchy;
    }

}