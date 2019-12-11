public class RitorniPostaliUtils {
    
    //record_type
    public static final String RITORNI_POSTALI_RECORD_TYPE = 'CRMRitorniPostali';
    
    //code
    public static final String QUEUE_95 = 'Q95';
    public static final String QUEUE_RITORNI_POSTALI_VERIFICA_INDIRIZZO = 'Q80';
    public static final String QUEUE_85 = 'Q85';
    
	//letter_type_id
	public static final String LETTER_TYPE_WEL = 'WEL';
    
    //returned_reasons
    public static final String RETURNED_REASON_DEC = 'DEC';
    
    //categories
    public static final String CAT_NO_CONTATTO = '2270';
    public static final String CAT_INVIO_COPIA = '2272';
    public static final String CAT_INVIO_ORIGINALE = '2273';
    public static final String CAT_ALTRI_SCARTI = '2274';
    
    //disposition positive
    public static final String ESITO_DOC_NON_RIPRODOTTA = 'DP2286';
    public static final String ESITO_CLIENTE_PASSATO_A_RID = 'DP2294';
    public static final String ESITO_BP_RISPEDITI_RICEVUTI = 'DP2295';
    public static final String ESITO_PRATICA_ESTINTA = 'DP2296';
    public static final String ESITO_CLIENTE_RIFIUTA_CARTA = 'DP2297';
    public static final String ESITO_CARTA_RISPEDITA_RICEVUTA = 'DP2298';
    public static final String ESITO_DOC_NON_RIPRODOTTA_ALTRO = 'DP2299';
    public static final String ESITO_ATTESA_DOC_POSTE = 'DP2287';
    public static final String ESITO_DOC_REINVIATA = 'DP2288';
    public static final String ESITO_DOC_RIPRODOTTA = 'DP2303';
    public static final String ESITO_ATTESA_INVIO_EC = 'DP2475';
     public static final String ESITO_RECALL='DP1146';
    public enum ESITI_POSITIVI {DP2286,DP2294,DP2295,DP2296,DP2297,DP2298,DP2299,DP2287,DP2288,DP2303,DP2475}
    
    //disposition negative
    public static final String ESITO_NEGATIVO_GENERICO = 'DP2283';
    public static final String ESITO_CLIENTE_NON_COLLABORA = 'DP2289';
    public static final String ESITO_DICHIARATO_DECESSO = 'DP2290';
	public static final String ESITO_DA_RID_A_BP = 'DP2291';
    public static final String ESITO_NESSUN_RECAPITO = 'DP2292';
    public static final String ESITO_DOC_NON_REINVIATA = 'DP2293';
    public static final String ESITO_NUMERO_ERRATO = 'DP2300';
    public static final String ESITO_NEGATIVO_ALTRO = 'DP2301';
    public static final String ESITO_RAGGIUNTO_LIMITE_TENTATIVI_CONTATTO = 'DP2302';
    public static final String ESITO_IRRAGGIUNGIBILE = 'DP2330';
    public static final String ESITO_NC_SE_RIENTRA_DOC_ARCHIVIARE = 'DP2778';
    public static final String ESITO_DA_NON_CONTATTARE = 'DP2333';
    public enum ESITI_NEGATIVI {DP2289,DP2290,DP2291,DP2292,DP2293,DP2300,DP2301,DP2302,DP2330,DP2778}
    
    //disposition verifica_esito_contatto
    public enum ESITI_CONTATTO {DP2778,DP2289,DP2290,DP2292,DP2294,DP2295,DP2296,DP2297,DP2298,DP2299,DP2302}
  
    //flag
    public static final String FLAG_RESO_MACERO_R = 'R';
    public static final String FLAG_FORNITORE_S = 'S';
    
    //compass_address
    public static final String COMPASS_LOCALITA = 'MILANO';
    public static final String COMPASS_ADDRESS = 'VIA CALDERA 21';
    
    //case default subject    
    public static final String RITORNI_POSTALI_DEFAULT_CASE_SUBJECT = 'Ritorni Postali - Verifica Indirizzo';
    
    public static RitorniPostali__c findRitornoEsistenteByCustomer(String strOcsCode, String strCurrLetterId) {
        
        List<RitorniPostali__c> ritorniEsistenti = [Select LetterId__c, OCSAnag__c, CallDispCode__c, NewAddress__c, NewCity__c, NewCap__c, NewProv__c from RitorniPostali__c where OCSAnag__c = :strOcsCode and LetterId__c != :strCurrLetterId];
        if (ritorniEsistenti.isEmpty()) {
            return Null;
        } else {
            //l'analisi parla solo della presenza di 1 documento pregresso
            //e se fossero più di uno i doc pregressi?
            return ritorniEsistenti[0];
        }
        
    }
    
    public static RitorniPostali__c findRitornoEsistenteByCustomer(RitorniPostali__c currentRitorno, List<RitorniPostali__c> ritorniPregressi) {
       
        RitorniPostali__c retValue = null;
        String strLetterID = currentRitorno.LetterId__c;
        
        if (!(ritorniPregressi.isEmpty())) {
            
            for (RitorniPostali__c ritorno : ritorniPregressi) {
                if (!(strLetterID.equalsIgnoreCase(ritorno.LetterId__c))) {
                    if (ritorno.SentDate__c <= currentRitorno.SentDate__c) {
                        retValue = ritorno;
                    	break;
                    }                   
                }
            }
        } 
        
        return retValue;
    }
    
    public static Boolean hasRitorniPregressi(String strOcsCode) {
        
        Boolean result = false;
        
        List<RitorniPostali__c> ritorniEsistenti = [Select OCSAnag__c from RitorniPostali__c where OCSAnag__c = :strOcsCode];
        if (!(ritorniEsistenti.isEmpty())) {
            result = true;
        }
        
        return result;
        
    }
    
    
    public static List<RitorniPostali__c> findRitorniConEsitoPositivoByCustomer(String strOcsCode) {
        
        List<RitorniPostali__c> ritorniEsistenti = [Select OCSAnag__c, CallDispCode__c from RitorniPostali__c where OCSAnag__c = :strOcsCode and CallDispCode__c IN ('DP2286','DP2294','DP2295','DP2296','DP2297','DP2298','DP2299','DP2287','DP2288','DP2303','DP2475')];
        return ritorniEsistenti;
    }
    
    public static List<RitorniPostali__c> findRitorniConEsitoNegativoByCustomer(String strOcsCode) {
        
        List<RitorniPostali__c> ritorniEsistenti = [Select OCSAnag__c, CallDispCode__c from RitorniPostali__c where OCSAnag__c = :strOcsCode and CallDispCode__c IN ('DP2289','DP2290','DP2291','DP2292','DP2293','DP2300','DP2301','DP2302','DP2330','DP2778','DP2333')];
        return ritorniEsistenti;
    }
    
    
}