public class XCSCompassConstants {
	//Classe dedicata all'archiviazione delle costanti utilizzate nelle varie classi e metodi apex del progetto
	
    //Stringhe di comparazione usate nel processo di Reclami
    public static final String COMPASS = 'Compass';
    public static final String FUTURO = 'Futuro';
    public static final String MBC = 'MBCredit Solutions';
    public static final String ASSICURAZIONE = 'Assicurazione';
    public static final String DECISIONE = 'Decisione';
    public static final String SI = 'Si';
    public static final String TRATTABILE = 'Trattabile';
    public static final String RESPINTO = 'Respinto'; //Usato per la picklist Autorizzazione_Livello
    public static final String NESSUNO = 'Nessuno'; // Come sopra
    public static final String IDM_RESPONSE_STAFF = 'IDM Response Staff'; //Per code
    public static final String AUTORITA = 'AUTORITA'; //Per regole aggiuntive filtro code
    public static final String RECLAMO = 'RECLAMO'; //Come sopra
    public static final String ASS_RECLAMO = 'ASS. RECLAMO'; //Come sopra
    public static final String ADMIN = 'Admin';
    public static final String SYSTEM_ADMIN = 'System Administrator';
    public static final String CUSTOM_OPERATION_MANAGER = 'Customer Operations Manager';
    public static final String RECLAMI_MANAGER = 'Reclami Manager';
    public static final String RECLAMI_USER = 'Reclami User';
    
    //Case Type
    public static FINAL String CASETYPESFA = 'SFA';
    public static FINAL String CASETYPECRM = 'CRM';
    
    //Try-Catch
    public static FINAL STRING MESSAGGIOERRORECONNESSIONE = 'Errore di comunicazione con OCS, contattare il system amministrator';
    public static FINAL STRING CODICEERRORECONNESSIONE = '900';
    public static FINAL STRING STATUSERRORECONNESSIONE = 'KO';
    
    //Esito Messaggio
    public static FINAL STRING SUCCESSO_CHIUDERE_CHIAMATA = 'Caso esitato, chiudere la chiamata';

    //Task Constant
    public static FINAL String TASK_STATUS_CLOSED  = 'Completato';
    
    //API Utils
    public static final Integer TIMEOUT = 120000; 
    
	//Component Name
	public static FINAL String POSTVENDITA_LAUNCHER_COMPONENT = 'PostvenditaFlowLauncher';
    
    // Postvendita id
    
    public static FINAL String POSTVENDITA_ID_ESTINZIONE_ANTICIPATA = '3707';

	
}