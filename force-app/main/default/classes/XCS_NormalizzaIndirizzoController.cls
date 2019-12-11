public class XCS_NormalizzaIndirizzoController {
    
    @AuraEnabled
    public static List<XCS_Indirizzo> recuperaIndirizzi(XCS_Indirizzo input){
        List<XCS_Indirizzo> respIndirizzi = new List<XCS_Indirizzo>();        
        
        OCSNormalizzaIndirizzoResponse response = OCSNormalizzaIndirizzoInvoker.callNormalizzaIndirizzo(input.tipoIndirizzo,input.indirizzo,input.civico,input.cap,input.localita,input.provincia,input.nazione,input.capRischio);
        OCSNormalizzaIndirizzoInvoker.DatiChiamataOCS datiChiamataOCS=OCSNormalizzaIndirizzoInvoker.processaResponse(response);  
        
        if(datiChiamataOCS.chiamataOK){   
            if(datiChiamataOCS.indirizziElenco.size()==1){   
                XCS_Indirizzo ind = new XCS_Indirizzo();
                
                ind.nazione = datiChiamataOCS.indirizziElenco[0].nazione;                           
                ind.cap = datiChiamataOCS.indirizziElenco[0].cap;
                ind.localita = datiChiamataOCS.indirizziElenco[0].localita;
                ind.provincia = datiChiamataOCS.indirizziElenco[0].provincia;        
                ind.indirizzo = datiChiamataOCS.indirizziElenco[0].indirizzo;
                
                respIndirizzi.add(ind);                
            }  
            else {
                for(OCSNormalizzaIndirizzoInvoker.IndirizzoOCS i : datiChiamataOCS.indirizziElenco){
                    XCS_Indirizzo indTmp = new XCS_Indirizzo();
                    
                    indTmp.nazione = i.nazione;
                    indTmp.cap = i.cap;
                    indTmp.localita = i.localita;
                    indTmp.provincia = i.provincia;
                    indTmp.indirizzo = i.indirizzo;
                    
                    respIndirizzi.add(indTmp); 
                }                                
            }            
        }        
        return respIndirizzi;
    }    
}