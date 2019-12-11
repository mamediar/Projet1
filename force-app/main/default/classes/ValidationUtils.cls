public class ValidationUtils {
     
    public static final String TELEFONORegex = '[0-9]{1,14}$';
    public static final String EMAILRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$';
    public static final String PIVARegex = '^[0-9]{11}$';
    public static final String CFRegex = '(?i)^[A-Z]{6}[A-Z0-9]{2}[A-Z][A-Z0-9]{2}[A-Z][A-Z0-9]{3}[A-Z]$';
    public static final String DATE_REGEX = '^[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$';
    public static final String CELL_REGEX = '^[3][0-9]{4,}$';
    public static final String PECEMAIL_REGEX = '\\b@pec.|\\b@arubapec|\\b@gigapec.it|\\b@mypec|\\b@legalmail';
    
    public static Boolean isTelefonoValido(String telefono){
		return Pattern.matches(TELEFONORegex, telefono);        
    } 
    
    public static Boolean isCellValido(String cell){
        return Pattern.matches(CELL_REGEX, cell);
    }
    public static Boolean isDataValida(String data) {
        //il pattern è yyyy-MM-dd
        return Pattern.matches(DATE_REGEX, data);
    }
    
    public static Boolean isEmailValida(String email){
		return Pattern.matches(EMAILRegex, email);        
    }
    
    
    public static Boolean isPartitaIVAValida(String partita_IVA){
        return Pattern.matches(PIVARegex, partita_IVA); 
    } 
    

    public static Boolean isCodiceFiscaleValido(String codiceFiscale){
		return Pattern.matches(CFRegex, codiceFiscale);        
    }


    public static Boolean isIBANValido(String iban){        
    	return IbanValidation.checkIban(iban);  
    }
    
    public static Boolean isEmailPECValida(String email){
		return Pattern.compile(PECEMAIL_REGEX).matcher(email.toLowerCase()).find();
        //return Pattern.matches(PECEMAIL_REGEX, email.toLowerCase());     
    }        
       
}