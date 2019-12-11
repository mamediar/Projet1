public class IbanValidation {
    
    //VALIDAZIONE DELL'IBAN MEDIANTE IL METODO "mod-97", SECONDO LO STANDARD ISO 7064
    @AuraEnabled
    public static Boolean checkIban (String iban) {                        //....Se la stringa "iban" è meno lunga di 4 caratteri non potrà effettuare il substring 
        if(iban.length() > 4 && iban.isAlphanumeric()) {                  //....nel metodo rearrangeIban, quindi si deve effettuare questa verifica all'inizio.   
            iban = rearrangeIban(iban);                                   //STEP #1 : si riordina l'Iban mettendo le prime 4 cifre alla fine della stringa
            if(iban.length() == 27 && ! iban.contains('^[\\W]|_')) {      //....L'iban italiano è lungo 27 caratteri, il controllo  "^[\\W]|_" è per escludere tutti i caratteri non alfanumerici
                iban = convertCharToNumbers(iban);                        //STEP #2 : si convertono le lettere nel numero corrispondente
                Long result = performModulos(iban);                       //STEP #3 : Si effettua il modulo per 97 di ogni sezione della stringa Iban
                return result == 1;                                       //....Se il risultato è 1, allora l'iban è valido.
            }
            else 
                return false;
        } 
        else{
            return false;
        } 
    }  
    
    /*  Per effettuare la validazione dell'IBAN si devono inizialmente spostare i primi 4 caratteri alla fine della Stringa
	Tolgo gli eventuali spazi con Trim e trasformo tutto in Maiuscolo, inoltre rimuovo eventuali backslash*/
    private static String rearrangeIban(String iban) {
        //     iban= iban.replaceAll('^[\\W]|_', ''); //rimpiazza tutti i caratteri non alfarumerici con '' 
        iban= iban.replaceAll('(\\s+)', ''); //corrisponde ad una sequenza di uno o più whitespace characters
        iban = iban.trim().toUpperCase();
        String start = iban.substring(0,4);
        String ending = iban.substring(4);
        String rearrangedIban = ending + start;
        return rearrangedIban;
    }
    
    /*  Medoto convertCharToNumbers:
    Sostituisco tutti i caratteri presenti nell'Iban con il relativo valore ASCII 
    corrispondente sottratto di 55 (Ad esempio il carattere "A" corrisponde a 65. 
    65 - 55 = 10, quindi al posto di A dovrà essere messa la stringa 10  */
    private static String convertCharToNumbers(String iban) {
        
        iban = iban.replaceAll('A', '10');
        iban = iban.replaceAll('B', '11');
        iban = iban.replaceAll('C', '12');
        iban = iban.replaceAll('D', '13');
        iban = iban.replaceAll('E', '14');
        iban = iban.replaceAll('F', '15');
        iban = iban.replaceAll('G', '16');
        iban = iban.replaceAll('H', '17');
        iban = iban.replaceAll('I', '18');
        iban = iban.replaceAll('J', '19');
        iban = iban.replaceAll('K', '20');
        iban = iban.replaceAll('L', '21');
        iban = iban.replaceAll('M', '22');
        iban = iban.replaceAll('N', '23');
        iban = iban.replaceAll('O', '24');
        iban = iban.replaceAll('P', '25');
        iban = iban.replaceAll('Q', '26');
        iban = iban.replaceAll('R', '27');
        iban = iban.replaceAll('S', '28');
        iban = iban.replaceAll('T', '29');
        iban = iban.replaceAll('U', '30');
        iban = iban.replaceAll('V', '31');
        iban = iban.replaceAll('W', '32');
        iban = iban.replaceAll('X', '33');
        iban = iban.replaceAll('Y', '34');
        iban = iban.replaceAll('Z', '35');
        
        return iban;
    }
    
    /*  Metodo performModulos:
    Non è possibile calcolare il Math.mod(iban,97) perché la lunghezza della stringa è troppo grande. Quindi seziono la stringa in diverse parti
    e per ogni parte sezionata effettuo il Math.mod(PartN, 97). Il modulo ottenuto verrà aggiunto in testa alla stringa e verrà calcolato così il
    successivo modulo delle successive N cifre, fino a che non verrà eseguito il modulo di tutte le cifre dell'Iban */
    private static Long performModulos(String iban) {
        
        //Modulo 97 delle prime 9 cifre
        String part1 = iban.substring(0,9);
        System.debug('####part1 : ' + part1);
        Long result1 = Math.mod(Long.valueOf(part1) , Long.valueOf('97') );
        
        Integer currentPosition = 9;
        Boolean digitsRemaining = true;
        Long result = result1;
        String partN;
        
        //Modulo 97 delle successive 7 cifre o dell'ultima sezione, se ne sono rimaste meno di 7 cifre
        while (digitsRemaining) {
            if (iban.length() < (currentPosition+7) ) {
                digitsRemaining = false;
            }
            if (digitsRemaining) {
                partN = String.valueOf(result) + iban.substring(currentPosition,currentPosition+7);
                System.debug('####part ' + currentPosition + ' to ' + (currentPosition+7));
                result = Math.mod(Long.valueOf(partN) , Long.valueOf('97') );
            } else {
                partN = String.valueOf(result) + iban.substring(currentPosition);
                System.debug('####part ' + currentPosition + ' to end');
                result = Math.mod(Long.valueOf(partN) , Long.valueOf('97') ); 
            }
            currentPosition+=7;          } 
        return result;
    }
    
}