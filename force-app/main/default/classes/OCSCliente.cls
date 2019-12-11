/**
 * @File Name          : OCSCliente.cls
 * @Description        : 
 * @Author             : sabrina vitali
 * @Group              : 
 * @Last Modified By   : sabrina vitali
 * @Last Modified On   : 29/10/2019, 16:54:02
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    21/10/2019   sabrina vitali     Initial Version
**/
public class OCSCliente {

    //per controllo pratiche in lavorazione
    private static final List<String> FLAGS_CO=new List<String>{'RE','RT'};
    private static final List<String> FLAGS_CA=new List<String>{'AN','RT'};
    private static final List<String> FLAGS_CQ=new List<String>{'RS','RT','AP'};
    private static final List<Integer> STATES_OK_CO=new List<Integer>{5,10,20,30};
    private static final List<Integer> STATES_KO_CO=new List<Integer>{40,45,90,91,95,96,97};
    private static final List<Integer> STATES_OK_CA=new List<Integer>{5,20};
    private static final List<Integer> STATES_KO_CA=new List<Integer>{30,40,50,60,70};
    private static final List<Integer> STATES_OK_CQ=new List<Integer>{5,10,15,20,30};
    private static final List<Integer> STATES_KO_CQ=new List<Integer>{40,50,55,60,80,85,90,95,96,97};
    //per controllo pratiche da retrocedere
    private static final List<String> ATTR_CO=new List<String>{'RT','RE','AN','CA'};
    private static final List<Integer> STATE_CO=new List<Integer>{40,45,90,91,95,96,97};
    private static final List<String> ATTR_CA=new List<String>{'RT','AN','CA'};
    private static final List<Integer> STATE_CA=new List<Integer>{30,40,50,60,70};
    private static final List<Integer> STATE_CO2030=new List<Integer>{20,30};
    private static final List<Integer> STATE_CA1020=new List<Integer>{10,20};


    @AuraEnabled
    public String cognome{get;set;}
    @AuraEnabled
    public String codCliente{get;set;}
    @AuraEnabled
    public String nome{get;set;}
    @AuraEnabled
    public String dataNascita{get;set;}
    
    @AuraEnabled
    public Date dataNascitaDate{
        get{
      
        String res = ''; 
       /* if(!String.isBlank(dataNascita) && !'0'.equalsIgnoreCase(dataNascita) && ){
            res += dataNascita.subString(0, 4) + '-';
            res += dataNascita.subString(4, 6) + '-';
            res += dataNascita.subString(6);
        }*/
            if(dataNascita == null) return null;
            if(dataNascita.contains('/')){
                List<String> lista = dataNascita.split('/');
                //Considero se inizia per anno
                if(lista[0].length() == 4) return Date.newInstance(Integer.valueOf(lista[0]), Integer.valueOf(lista[1]), Integer.valueOf(lista[2]));
                return Date.newInstance(Integer.valueOf(lista[2]), Integer.valueOf(lista[1]), Integer.valueOf(lista[0]));
            }
            else if(dataNascita.contains('-')){
                List<String> lista = dataNascita.split('-');
                if(lista[0].length() == 4) return Date.newInstance(Integer.valueOf(lista[0]), Integer.valueOf(lista[1]), Integer.valueOf(lista[2]));
                return Date.newInstance(Integer.valueOf(lista[2]), Integer.valueOf(lista[1]), Integer.valueOf(lista[0]));
            }
            if(!String.isBlank(dataNascita) && !'0'.equalsIgnoreCase(dataNascita)  ){
                res += dataNascita.subString(0, 4) + '-';
                res += dataNascita.subString(4, 6) + '-';
                res += dataNascita.subString(6);
            }
            return String.isBlank(res)?null:date.valueOf(res);
        } set;}

    @AuraEnabled
    public String dataNascitaItaliana{get{
        String res = ''; 
        if(!String.isBlank(dataNascita) && !'0'.equalsIgnoreCase(dataNascita)){
            res += dataNascita.subString(6) + '/' + dataNascita.subString(4, 6) + '/' + dataNascita.subString(0, 4) ;
        }
        return res;
    } set;}


    @AuraEnabled
    public String luogoNascita{get;set;}
    @AuraEnabled
    public String provNascita{get;set;}
    @AuraEnabled
    public String sesso{get;set;}
    @AuraEnabled
    public String codFiscale{get;set;}
    @AuraEnabled
    public String piva{get;set;}
    @AuraEnabled
    public String indirizzo{get;set;}
    @AuraEnabled
    public String cap{get;set;}
    @AuraEnabled
    public String localita{get;set;}
    @AuraEnabled
    public String provincia{get;set;}
    @AuraEnabled
    public String paeseEstero{get;set;}
    @AuraEnabled
    public String email{get;set;}
    @AuraEnabled
    public String tipoDocumento{get;set;}
    @AuraEnabled
    public String numDocumento{get;set;}
    @AuraEnabled
    public String ufficioRilascio{get;set;}
    @AuraEnabled
    public String luogoRilascio{get;set;}
    @AuraEnabled
    public String provRilascio{get;set;}
    @AuraEnabled
    public String dataRilascio{get;set;}
    @AuraEnabled
    public Date dataRilascioDate{get{
        System.debug('Data Rilascio '+dataRilascio);
        if(dataRilascio == null || dataRilascio.length() < 6) return null;
        String res = '';   
        if(!String.isBlank(dataRilascio) && !'0'.equalsIgnoreCase(dataRilascio)){
            res += dataRilascio.subString(0, 4) + '-';
            res += dataRilascio.subString(4, 6) + '-';
            res += dataRilascio.subString(6);
        }
        return String.isBlank(res)?null:date.valueOf(res);
    } set;}
    @AuraEnabled
    public String denominazioneAzienda{get;set;}
    @AuraEnabled
    public String formaGiuridica{get;set;}
    @AuraEnabled
    public String tipoAnagrafica{get;set;}
    @AuraEnabled
    public String dataScadenza{get;set;}
    @AuraEnabled
    public Date dataScadenzaDate{get{
        System.debug('Data Scadenza '+dataScadenza);
        if(dataScadenza == null || dataScadenza.length() < 6) return null;
        String res = '';   
        if(!String.isBlank(dataScadenza) && !'0'.equalsIgnoreCase(dataScadenza)){
            res += dataScadenza.subString(0, 4) + '-';
            res += dataScadenza.subString(4, 6) + '-';
            res += dataScadenza.subString(6);
        }
        return String.isBlank(res)?null:date.valueOf(res);
    } set;}
    
    @AuraEnabled public String dataScadenzaSlashed {get{
         System.debug('Data Scadenza '+dataScadenza);
        if(dataScadenza == null || dataScadenza.length() < 6) return null;
        String res = '';   
        if(!String.isBlank(dataScadenza) && !'0'.equalsIgnoreCase(dataScadenza)){
            res += dataScadenza.subString(6) + '/';
            res += dataScadenza.subString(4, 6) + '/';
            res += dataScadenza.subString(0, 4);
        }
        return res;
    } set;}
    
    @AuraEnabled
    public String telefonoCasa{get;set;}
    @AuraEnabled
    public String telCellulare{get;set;}
    @AuraEnabled
    public String tipoRapporto{get;set;}
    @AuraEnabled
    public String dataDepennamento{get;set;}
    @AuraEnabled
    public String ndg{get;set;}
    @AuraEnabled
    public String denominazione{get{return nome+' '+cognome;}set;}
    @AuraEnabled
    public String ragioneSociale{get;set;}
    @AuraEnabled
    public String SFId{get;set;}
    @AuraEnabled
    public List<OCSPratica> pratiche{get;set;}
    @AuraEnabled
    public List<OCSPraticaFuturo> praticheFuturo{get;set;}
    
    public OCSCliente(){
        this.pratiche = new List<OCSPratica>();
        this.praticheFuturo = new List<OCSPraticaFuturo>();
    }
    
    //prendi carte ("CA")
    public List<OCSPratica> getCA() {
        List<OCSPratica> tmp = new List<OCSPratica>();
        for(OCSPratica a : pratiche) {
            if('CA'.equalsIgnoreCase(a.tipoPratica))
                tmp.add(a);
        }        
        return tmp;        
    }
    
    //prendi contratti ("CO")
    public List<OCSPratica> getCO() {  
        List<OCSPratica> tmp = new List<OCSPratica>();
        for(OCSPratica a : pratiche) {
            if('CO'.equalsIgnoreCase(a.tipoPratica))
                tmp.add(a);
        }        
        return tmp;
        
    }
    
    //prendi cessionequinto ("CQ")
    public List<OCSPratica> getCQ() { 
        List<OCSPratica> tmp = new List<OCSPratica>();
        for(OCSPratica a : pratiche) {
            if('CQ'.equalsIgnoreCase(a.tipoPratica))
                tmp.add(a);
        }        
        return tmp;        
    }
    
    public List<OCSPratica> getAssicurazioni(){
        List<OCSPratica> res = new List<OCSPratica>();
        if(!pratiche.isEmpty()) {          
            for(OCSPratica p : pratiche){
                if(p.dataCaricamento != null && String.isNotBlank(p.societa))
                    res.add(p);
            }
        }
        return res;
    }
    
    public List<OCSPratica> getAssicurazioniToday(){
        List<OCSPratica> res = new List<OCSPratica>();
        Date today = Date.today(); 
        if(!pratiche.isEmpty()) {          
            for(OCSPratica p : pratiche){
                if(p.dataCaricamento != null && String.isNotBlank(p.societa)){
                    Date dateToCompare = date.parse(p.dataCaricamento);
                    System.debug(dateToCompare);
                    if(today.isSameDay(dateToCompare))
                        res.add(p);                    
                }
            }
        }
        return res;
    }
    
    public List<OCSPratica> getIbanPerPagamentoList(){
        List<OCSPratica> res = new List<OCSPratica>();        
        for(OCSPratica p : pratiche){            
            if('RI'.equalsIgnoreCase(p.tipoPagamento)){ 
                if('CO'.equalsIgnoreCase(p.tipoPratica)){
                    if('40'.equalsIgnoreCase(p.statoPratica))
                        res.add(p);
                }                
                if('CA'.equalsIgnoreCase(p.tipoPratica)){
                    if(('50'.equalsIgnoreCase(p.statoPratica) || '60'.equalsIgnoreCase(p.statoPratica)) && !'DS'.equalsIgnoreCase(p.codAttributoPratica) && !'RV'.equalsIgnoreCase(p.codAttributoPratica))
                        res.add(p);
                }                       
            }            
        }
        return res;        
    }
    
    //Questo metodo restituisce tutte le carte secondo le logiche del processo Vendita Assicurazioni
    public List<OCSPratica> getCALogic(){
        List<OCSPratica> cartePerPagamentoList = new List<OCSPratica>();
        List<OCSPratica> CAList = getCA();
        
        for(OCSPratica p : CAList){
            if('50'.equalsIgnoreCase(p.statoPratica)){
                OCSCartaDatiFinanziariResponse CDFResponse = OCSCartaDatiFinanziariInvoker.cartaDatiFinanziari(p.numPratica);
                System.debug('getCALogic in OCSCliente.apxc: ' + CDFResponse);
                if(!'S'.equalsIgnoreCase(CDFResponse.datiCartaDatiFinanziariResponse.flagAttivazioneCarta)){
                    List<String> emettitoreRows = CompassParametersUtils.getListValues('venditaAssicurazioni.emettitoreList');
                    if(!emettitoreRows.contains(CDFResponse.datiCartaDatiFinanziariResponse.emettitore)){
                        cartePerPagamentoList.add(p);
                    }
                }
            }            
        }
        return cartePerPagamentoList;
    }

    //per controllo pratiche in lavorazione
    public Boolean hasPraticheInLavorazione(){
        Boolean res=false;
                
        for(OCSPratica d: pratiche){
            String type=d.tipoPratica;
            Integer state=Integer.valueOf(d.codStatoPratica);
            String code=d.codAttributoPratica;
            if('CO'.equalsIgnoreCase(type)){
                if((FLAGS_CO.contains(code) && STATES_OK_CO.contains(state)) || STATES_KO_CO.contains(state) ){
                    res=true;
                    break;
                }
            }
            else if('CA'.equalsIgnoreCase(type)){
                if((FLAGS_CA.contains(code) && STATES_OK_CA.contains(state)) || STATES_KO_CA.contains(state) ){
                    res=true;
                    break;
                }
            }
            else{
                if((FLAGS_CQ.contains(code) && STATES_OK_CQ.contains(state)) || STATES_KO_CQ.contains(state) ){
                    res=true;
                    break;
                }
            }
        }
        return res;
    }    
    
    //per controllo pratiche da retrocedere                        
    public List<OCSPratica> praticheDaRetrocedere(){
        Boolean res=false;
        List<OCSPratica> praticheDaRetrocedere = new List<OCSPratica>();
        for(OCSPratica p:pratiche){
            String type=p.tipoPratica;
            Integer cod_stato=Integer.valueOf(p.codStatoPratica);
            String cod_attributo=p.codAttributoPratica;
            if('CO'.equalsIgnoreCase(type)){
                if(5 != cod_stato){
                    // da commento rss: CS 210317 - Piroddi dice che in stato 05 non è possibile retrocedere quindi non vanno mostrate
                    if(10 == cod_stato){
                        if(!'CA'.equalsIgnoreCase(cod_attributo)){
                            praticheDaRetrocedere.add(p);
                        }
                    }
                    else if(STATE_CO2030.contains(cod_stato)){
                        if(!ATTR_CO.contains(cod_attributo)){
                            praticheDaRetrocedere.add(p);
                        }
                    }
                    else if(!STATE_CO.contains(cod_stato) && !'CA'.equalsIgnoreCase(cod_attributo) ){
                        praticheDaRetrocedere.add(p);
                    }
                }    
            }
            else if('CA'.equalsIgnoreCase(type)){
                if(5 != cod_stato){
                    // da commento rss: CS 210317 - Piroddi dice che in stato 05 non è possibile retrocedere quindi non vanno mostrate
                    if(STATE_CA1020.contains(cod_stato)){
                        if(!ATTR_CA.contains(cod_attributo)){
                            praticheDaRetrocedere.add(p);
                        }
                    }
                    else if(!STATE_CA.contains(cod_stato) && !'CA'.equalsIgnoreCase(cod_attributo) ){
                        praticheDaRetrocedere.add(p);
                    }
                }
            }
        }
        return praticheDaRetrocedere;
    }

    //controllo carte attive
    public List<OCSPratica> getCarteAttive(){
        List<OCSPratica> carteAttive = new List<OCSPratica>();
        for(OCSPratica p:pratiche) {
            System.debug('******** carta: ' + p.numPratica + ' - ' + p.tipoPratica + ' - ' + p);
            if('CA'.equalsIgnoreCase(p.tipoPratica) && isCartaActive(p,OCSRecuperaInfoCartaInvoker.callRecInfoCarta(p.numPratica))){
                System.debug('******** carta attiva: ' + p.numPratica + ' - ' + p.tipoPratica + ' - ' + p);
                carteAttive.add(p);
            }
        }
        return carteAttive;
    }
    
    //per controllo carte attive
    public static boolean isCartaActive(OCSPratica carta,OCSRecuperaInfoCartaResponse infoCarta) {
        boolean bool = true;
        System.debug('******** infocarta ' + infoCarta);
        if(checkFlags(carta.codAttributoPratica))  {
            bool = false;
        }
        //esiste anche chartAt(numero del carattere alla posizione che vuoi) (meno performante)
        if(infoCarta.recuperaInfoCartaResponse.emettitore.length() == 3 && infoCarta.recuperaInfoCartaResponse.emettitore.substring(0, 1) == '1')
            bool = false;
        if(infoCarta.recuperaInfoCartaResponse.emettitore.length() == 2 && infoCarta.recuperaInfoCartaResponse.dataInvioPositivo == '') {
            if('05'.equals(carta.codStatoPratica) ||
               '10'.equals(carta.codStatoPratica) ||
               '20'.equals(carta.codStatoPratica) ||
               '30'.equals(carta.codStatoPratica))
                bool = false;     
        }
        if(infoCarta.recuperaInfoCartaResponse.emettitore.length() == 2 && '60'.equals(carta.codStatoPratica) && 'LL'.equals(carta.codAttributoPratica))
            bool = false;
        if('70'.equals(carta.codStatoPratica))
            bool = false;
        if('60'.equals(carta.codStatoPratica)) {
            if('RU'.equals(carta.codAttributoPratica) || 'XS'.equals(carta.codAttributoPratica) || 'XZ'.equals(carta.codAttributoPratica))
                bool = false;
        }
        if(!isExpDateOk(infoCarta.recuperaInfoCartaResponse.dataScadenza)){
            System.debug('carta non attiva per data' + carta.numPratica);
            bool=false;
        }
        return bool;
    }
    
    //per controllo carte attive
    public static Boolean checkFlags(String attributo){
        return('RT'.equalsIgnoreCase(attributo) ||
               'AN'.equalsIgnoreCase(attributo) ||
               'CV'.equalsIgnoreCase(attributo) ||
               'CE'.equalsIgnoreCase(attributo) ||
               'DK'.equalsIgnoreCase(attributo) ||
               'FP'.equalsIgnoreCase(attributo) ||
               'KO'.equalsIgnoreCase(attributo) ||
               'LG'.equalsIgnoreCase(attributo) ||
               'PP'.equalsIgnoreCase(attributo) ||
               'RI'.equalsIgnoreCase(attributo) ||
               'TE'.equalsIgnoreCase(attributo) ||
               'UI'.equalsIgnoreCase(attributo) ||
               'XD'.equalsIgnoreCase(attributo) ||
               'IA'.equalsIgnoreCase(attributo));
    }
    
    public static Boolean isExpDateOk(String expDate){  
        boolean res=true;
        System.debug('*** expDate : ' + expDate);
        if(expDate == null)
            res = false;
        else{
            date now = date.today();
            String day = expDate.substring(0, 4);
            String month = expDate.substring(4, 6);
            String year = expDate.substring(6,8);
            date myDate = Date.newInstance(Integer.valueOf(day),Integer.valueOf(month),Integer.valueOf(year)); 
            System.debug('*** myDate : ' + myDate);
            System.debug('*** myDate.daysBetween(now) : ' + myDate.daysBetween(now));
            System.debug('*** now.daysBetween(myDate) : ' + now.daysBetween(myDate));
            if(myDate < now.addDays(30)){
                System.debug('***SCAdUTA');
                res = false;
            }
            /*if(myDate.daysBetween(now) < 30 && (myDate.daysBetween(now) > 0 || myDate.daysBetween(now) == 0))
                res = false;
            */    
        }
        System.debug('*** res : ' + res);
        return res;
    }    
}