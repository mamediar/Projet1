public class OCSCensimentoCollegatiInvoker {

   public static OCSCensimentoCollegatiResponse callCensimentoCollegati (String dealerId) {   
        List<OCSCensimentoCollegatiRequest.ELenco> elenco=processaDati(dealerId);
        OCSCensimentoCollegatiRequest req = new OCSCensimentoCollegatiRequest();
        req.censimentoCollegatiRequest.elenco = elenco;  
        OCSCensimentoCollegatiResponse response = (OCSCensimentoCollegatiResponse) ApiUtils.callApi('ocs.censimentoCollegati', req, OCSCensimentoCollegatiResponse.class);
        system.debug('Response: ' + response);
        return response;
    }
    
    /*public static DatiOCS processaResponse (OCSCensimentoCollegatiResponse response, List<Contact> collegatiList) {   
        DatiOCS datiOCS = new DatiOCS();
        datiOCS.chiamataOK=true;
        Map<Id, Contact> collegatiMap= new Map<Id, Contact>();
        for(Contact co:collegatiList){
            collegatiMap.put(co.Id,co);
        }
        for(OCSCensimentoCollegatiResponse.ELenco resElenco:response.censimentoCollegatiResponse.elenco){
                if(resElenco.segnala!='Anagrafica inserita CONTROLLARE MESSAGGIO!!!!!!!!!!!!'){   //risposta andata a buon fine
                   datiOCS.chiamataOK=false;
                   datiOCS.message.add('-Collegato "'+collegatiMap.get(resElenco.icoCollegato).LastName +' '+ collegatiMap.get(resElenco.icoCollegato).FirstName+ '": ' +resElenco.segnala);   
                }
                
         }
		return datiOCS; 
    }*/
    
    /*public static List<String> processaResponse (OCSCensimentoCollegatiResponse response, List<Contact> collegatiList) {   
        List<String> message = new List<String>();
        Map<Id, Contact> collegatiMap= new Map<Id, Contact>();
        for(Contact co:collegatiList){
            collegatiMap.put(co.Id,co);
        }
        for(OCSCensimentoCollegatiResponse.ELenco resElenco:response.censimentoCollegatiResponse.elenco){
            message.add('-Collegato "'+collegatiMap.get(resElenco.icoCollegato).LastName +' '+ collegatiMap.get(resElenco.icoCollegato).FirstName+ '": ' +resElenco.segnala);        
        }
		return message; 
    }*/   
    
    
    public static List<String> processaResponse (OCSCensimentoCollegatiResponse response, String dealerId) {   
        List<String> message = new List<String>();
        List<Contact> collegatiList=SFAConvenzionamento.getCollegati(dealerId);
        Map<Id, Contact> collegatiMap= new Map<Id, Contact>();
        for(Contact co:collegatiList){
            collegatiMap.put(co.Id,co);
        }
        for(OCSCensimentoCollegatiResponse.ELenco resElenco:response.censimentoCollegatiResponse.elenco){
            message.add('-Collegato "'+collegatiMap.get(resElenco.icoCollegato).LastName +' '+ collegatiMap.get(resElenco.icoCollegato).FirstName+ '": ' +resElenco.segnala);        
        }
		return message; 
    }    
    
    //CLASSE CORRETTA::
    public static List<OCSCensimentoCollegatiRequest.ELenco> processaDati (String dealerId) {
		List<OCSCensimentoCollegatiRequest.ELenco> elenco = new List<OCSCensimentoCollegatiRequest.ELenco>();  
        Map<String,Trascodifica_ruoli_collegati__mdt> trascodificaRuoliMap = new Map<String,Trascodifica_ruoli_collegati__mdt>();       
        List<SFAConvenzionamento.CollegatoERuoloObject> collegatoERuoliList=new List<SFAConvenzionamento.CollegatoERuoloObject>();
        Set<String> ruoli = new Set<String>();
        
        SFAConvenzionamento.CollegatiERuoli collegatiERuoli= SFAConvenzionamento.getCollegatiNonCancellatiERuoliPerOCS(dealerId);
        collegatoERuoliList=collegatiERuoli.collegati;
        ruoli=collegatiERuoli.ruoli;
        System.debug('collegatoERuoliList:: '+collegatoERuoliList);
        System.debug('ruoli:: '+ruoli);        
        
		List<Trascodifica_ruoli_collegati__mdt>  trascodificaRuoliList =[SELECT Id, DeveloperName, IcoFirmatario__c, IcoRappresentante__c, IcoReferente__c, 
                                                    IcoSocio__c, IcoTitolare__c 
                                                    FROM Trascodifica_ruoli_collegati__mdt WHERE  DeveloperName IN: ruoli];
        
        System.debug('trascodificaRuoliList:: '+trascodificaRuoliList);
        
        if(trascodificaRuoliList.size()>0){
                    
            for(Trascodifica_ruoli_collegati__mdt tr:trascodificaRuoliList){
                trascodificaRuoliMap.put(tr.DeveloperName,tr);
            }
            System.debug('trascodificaRuoliMap:: '+trascodificaRuoliMap);
            
            Account dealer=[SELECT id, OCS_External_Id__c  
                            FROM Account WHERE id=:dealerId][0];        
            System.debug('***collegatoERuoliList: '+collegatoERuoliList);
            for(SFAConvenzionamento.CollegatoERuoloObject co_ruolo:collegatoERuoliList){   //co_ruolo.contactCollegato---> collegato     co_ruolo.Ruolo---> ruolo            
                OCSCensimentoCollegatiRequest.ELenco elencoCollegato = new OCSCensimentoCollegatiRequest.ELenco();
                Trascodifica_ruoli_collegati__mdt trascodificaRuolo = new Trascodifica_ruoli_collegati__mdt();
                trascodificaRuolo=trascodificaRuoliMap.get(co_ruolo.Ruolo);
                System.debug('CICLO co_ruolo.Ruolo:: '+co_ruolo.Ruolo);
                System.debug('CICLO trascodificaRuolo:: '+trascodificaRuolo);
                System.debug('CICLO trascodificaRuoliMap.get(co_ruolo.Ruolo):: '+trascodificaRuoliMap.get(co_ruolo.Ruolo));
                elencoCollegato.icoCodice=dealer.OCS_External_Id__c.Substring(1);
                elencoCollegato.icoCollegato=co_ruolo.contactCollegato.OCS_External_Id__c;
                elencoCollegato.icoFirmatario=trascodificaRuolo.IcoFirmatario__c;          
                elencoCollegato.icoRappresentante=trascodificaRuolo.IcoRappresentante__c;
                elencoCollegato.icoReferente=trascodificaRuolo.IcoReferente__c;
                elencoCollegato.icoSocio=trascodificaRuolo.IcoSocio__c;
                elencoCollegato.icoTitolare=trascodificaRuolo.IcoTitolare__c;
                elencoCollegato.icoResponsabileIsvap='N';
                elencoCollegato.icoDataIscrizIsvap='0';	
                elencoCollegato.icoDataApertura='00000000';
                elencoCollegato.icoDataChiusura='00000000';		           
                elenco.add(elencoCollegato);            
            }
        }
        return elenco;
    }

}