public class CodiceFiscaleValidationUtils {

    public static Boolean isCodiceFiscaleValido(String codice_Fiscale, CodiceFiscaleAnagrafica.anagrafica anagrafica){
		Boolean codiceFiscaleValido=true;
        codiceFiscaleValido=ValidationUtils.isCodiceFiscaleValido(codice_Fiscale);
        if(codiceFiscaleValido){ 
            System.debug('!!!!!!!!CF valido');
            CF codiceFiscaleObject= getCodiceFiscale(codice_Fiscale);
            AnagraficaPerCodiceFiscale anagraficaObject= getAnagraficaPerCodiceFiscale(anagrafica);  
            if(anagrafica.dataNascita!=null && anagraficaObject.annoNascita!=codiceFiscaleObject.annoNascita){
                codiceFiscaleValido=false;
                System.debug('!!!!!!!!CF valido 1');
            } else if(anagrafica.dataNascita!=null && anagraficaObject.meseNascitaToLetter!=codiceFiscaleObject.meseNascitaLetter){
                System.debug('!!!!!!!!CF valido 2 anagraficaObject.meseNascitaLetter: '+anagraficaObject.meseNascitaToLetter); 
                System.debug('!!!!!!!!CF valido 2 codiceFiscaleObject.meseNascitaLetter: '+codiceFiscaleObject.meseNascitaLetter); 
                codiceFiscaleValido=false;
                System.debug('!!!!!!!!CF valido 2'); 
            } else if(anagrafica.dataNascita!=null && !String.isEmpty(anagrafica.sesso)) {
                if(anagrafica.sesso=='M' && anagraficaObject.giornoNascita!=codiceFiscaleObject.giornoNascitaM){
                    codiceFiscaleValido=false;
                    System.debug('!!!!!!!!CF valido 3');
                } else if(anagrafica.sesso=='F' && anagraficaObject.giornoNascita!=codiceFiscaleObject.giornoNascitaF){
                    codiceFiscaleValido=false;
                    System.debug('!!!!!!!!CF valido 4');
                }
            }
        } else {
            System.debug('!!!!!!!!CF NON valido');
        }    
        System.debug('CFValido:: '+codiceFiscaleValido);
        return codiceFiscaleValido;
    }
    
    

    
    
    public static AnagraficaPerCodiceFiscale getAnagraficaPerCodiceFiscale(CodiceFiscaleAnagrafica.anagrafica anagrafica){
		Boolean codiceFiscaleValido=false;  
        String dataNascita;
        Map<Integer,String> mapMesiToLetter= new Map<Integer,String>{1 => 'A', 2 => 'B', 3 => 'C', 4 => 'D', 5 => 'E', 6 => 'H', 7 => 'L', 8 => 'M', 9 => 'P', 10 => 'R', 11 => 'S', 12 => 'T'};        
        AnagraficaPerCodiceFiscale anagraficaPerCodiceFiscale = new AnagraficaPerCodiceFiscale();
        if(anagrafica.dataNascita!=null){
            dataNascita=DateUtils.formatDateYYYYscoreMMscoreDD(anagrafica.dataNascita);
            System.debug('dataNascita: '+dataNascita);
            System.debug('integer.valueof(dataNascita.substring(5,7)): '+integer.valueof(dataNascita.substring(5,7)));
            anagraficaPerCodiceFiscale.giornoNascita=integer.valueof(dataNascita.substring(8,10));
            anagraficaPerCodiceFiscale.annoNascita=integer.valueof(dataNascita.substring(2,4));  
            anagraficaPerCodiceFiscale.meseNascitaToLetter=mapMesiToLetter.get(integer.valueof(dataNascita.substring(5,7)));
        }        
        anagraficaPerCodiceFiscale.codiceComune=anagrafica.codiceComune;   
        anagraficaPerCodiceFiscale.sesso=anagrafica.sesso; 
        return anagraficaPerCodiceFiscale;
    }
    
    
            
    public static String getFirstThreeConsonants(String s){
        String str='';
        List<String> vowels = new list<String> {'a','e','i','o','u','A','E','I','O','U'};
        List<String> lstString = s.split('');  
        for(Integer i=0; i<s.length() && i<=3 ;i++){
            if(!vowels.contains(lstString[i])){
                str=str+lstString[i]; 
            }                      
        }
        return str;    
 
    } 
    
    
   
    
    public static CF getCodiceFiscale(String codice_Fiscale){
        CF cf= new CF();
		cf.cognome=codice_Fiscale.substring(0,3);  
        cf.nome=codice_Fiscale.substring(3,6); 
        cf.giornoNascitaM=integer.valueof(codice_Fiscale.substring(9,11)); 
        cf.giornoNascitaF=integer.valueof(codice_Fiscale.substring(9,11))-40;
        cf.annoNascita=integer.valueof(codice_Fiscale.substring(6,8));
        cf.meseNascitaLetter=codice_Fiscale.substring(8,9);
		return cf;
    }
    
    
 	public class CF {
        public String cognome {get; set;}
        public String nome {get; set;}      
        public Integer giornoNascitaM {get; set;}      
        public Integer giornoNascitaF {get; set;}      
        public Integer annoNascita {get; set;} 
        public String meseNascitaLetter{get; set;} 
    }    
    
    public class AnagraficaPerCodiceFiscale{        
        public String cognome{get; set;}
        public String nome{get; set;}
        public String sesso{get; set;}
        public Integer giornoNascita{get; set;}
        public Integer annoNascita{get; set;}
        public String meseNascitaToLetter{get; set;} 
        public String codiceComune{get; set;}   //potrebbe essere ad esempio "002"
        
    }    
    
	
}