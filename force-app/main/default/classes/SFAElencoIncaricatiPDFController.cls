public class SFAElencoIncaricatiPDFController {

    public String idCase {get;set;}
   
    public List<RecuperaDatiCatColDealerRuoliInvoker.DatiCatenaCollegatiDealerRuoliDTO> listaCollegati {get;set;}

    private final static String DATA_AVVITO_UTENZE_NOMINALI = '20161018';

    public SFAElencoIncaricatiPDFController(ApexPages.StandardController std){
        this.idCase =ApexPages.currentPage().getParameters().get('IdCase');
        System.debug('idCase:'+this.idCase);
    }

    public void init(){
 
 
        // 2.	Recupera i collegati al dealer tramite il servizio B2BSOAP “recuperaDatiCatenaCollegatiDealerRuoli”
        this.listaCollegati = new  List<RecuperaDatiCatColDealerRuoliInvoker.DatiCatenaCollegatiDealerRuoliDTO>();

        Case caso = [SELECT Account.OCS_External_Id__c  FROM CASE WHERE ID=:idCase];
        String codIntermediario = caso.Account.OCS_External_Id__c;
        if (codIntermediario!=null && codIntermediario.length()>0 && !codIntermediario.substring(0,1).isNumeric()) {
            codIntermediario =codIntermediario.substring(1);
        }
        RecuperaDatiCatColDealerRuoliInvoker.Response res = RecuperaDatiCatColDealerRuoliInvoker.invoke(codIntermediario);
//      DATO DI TEST!! lasciare commentato
 //       RecuperaDatiCatColDealerRuoliInvoker.Response res = RecuperaDatiCatColDealerRuoliInvoker.invoke('14498');
        System.debug('getPDFElencoIncaricati isOK:'+res.isOK());
        if (res.isOK() && res.RecuperaDatiCatenaCollegatiDealerRuoliResponse!=null && res.recuperaDatiCatenaCollegatiDealerRuoliResponse.elenco!=null) {
            for (RecuperaDatiCatColDealerRuoliInvoker.DatiCatenaCollegatiDealerRuoliDTO dto:res.recuperaDatiCatenaCollegatiDealerRuoliResponse.elenco) {
                System.debug('(1) dto:'+dto); 
                // a.	Elimina i collegati che non hanno almeno uno tra ruolo Firmatario (getFirmatario()) o Rappresentate (getRappresentante()) uguale a ‘S’
                if ('S'.equalsIgnorecase(dto.firmatario) || 'S'.equalsIgnorecase(dto.rappresentante)){                   
                      System.debug('(2) dto:'+dto); 
                   // b. Se la data di aggiunta del collegato (getDataApertura()) è maggiore alla data di avvito delle utenze nominali (20161018)
                    if (dto.dataApertura!=null && Integer.valueOf(dto.dataApertura)>= Integer.valueOf(DATA_AVVITO_UTENZE_NOMINALI)) {
                        System.debug('(3) dto:'+dto); 
                        // i.	Se getCodConvenzionato()=0 e getFirmatario()=’S’ mantengo il nominativo e lo inserisco nell’elenco dei firmatari 	Altrimenti elimino il nominativo
                        if ('0'.equalsIgnoreCase(dto.codConvenzionato) && 'S'.equalsIgnorecase(dto.firmatario)) {
                              System.debug('(4) dto:'+dto); 
                            this.listaCollegati.add(dto);
                        }
                    } else {
                        System.debug('(5) DATA MINORE dto: se la data è minore cosa succede? niente, non entra nella lista:'+dto); 
 //                       this.listaCollegati.add(dto);
                    }                    
                }
            }
        }        

    }

}