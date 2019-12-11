public class RitorniPostaliEventsManager {
    
    public static Integer queryOpen (Id strCaseID) {
        
        Boolean isNegative = false;   
        // -caseOpenCode- decodifica
        // 0 : nessuna apertura del case
        // 1 : apertura del case con gestione totale
        // 2 : apertura del case con solo gestione del campo invio doc a sistema   
        Integer caseOpenCode = 1;
        
       // String strCaseID = currentRPCase.Id;
        Case casoCorrispondente = new Case(Id = strCaseID);

        //recupero via relazione inversa del record RitorniPostali__c collegato al Case
        List<RitorniPostali__c> ritorni = [Select PreviousLetterId__c, PreviousLetterNote__c,
                        CasoCorrispondente__r.Categoria_Riferimento__c,
                        CasoCorrispondente__r.Categoria_Riferimento__r.External_Id__c from RitorniPostali__c where CasoCorrispondente__c = :strCaseID];
        if (!(ritorni.isEmpty())) {
            RitorniPostali__c ritorno = ritorni[0];
            if (!(String.isEmpty(ritorno.PreviousLetterNote__c))) {
                
                RitorniPostali__c ritornoPrecedente = [Select LetterId__c, CallDispCode__c from RitorniPostali__c where LetterId__c = :ritorno.PreviousLetterId__c];
                if (ritornoPrecedente != null) {
                    String strPreviousDispositionID = XCS_DispositionUtils.findDispositionByExternalID(ritornoPrecedente.CallDispCode__c).Id;
                                       
                    if (RitorniPostaliUtils.CAT_INVIO_COPIA.equals(ritorno.CasoCorrispondente__r.Categoria_Riferimento__r.External_Id__c)) {
                        
                        for (RitorniPostaliUtils.ESITI_NEGATIVI esitoNegativo : RitorniPostaliUtils.ESITI_NEGATIVI.values()) {
                            
                        	if (esitoNegativo.name().equalsIgnoreCase(ritornoPrecedente.CallDispCode__c)) {
                            	isNegative = true;
                            	break;
                        	}
                            
                    	}
                        
                        if (isNegative == false) {                          
                            caseOpenCode = 2;
                        } else {                          
                            caseOpenCode = 0;           
                        }
                                         
                    } else {                     
                        caseOpenCode = 0;
                    }
                    
                    if (caseOpenCode == 0) {
                        casoCorrispondente.Disposition__c = strPreviousDispositionID;
                        casoCorrispondente.Status = CaseUtils.CHIUSO;
                        update casoCorrispondente;
                    }
                	
                } 
                
            }    
                             
        }
        
        return caseOpenCode;
    }

}