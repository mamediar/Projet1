public class CRMReclamiInsClienteContainerCtrl {
    @AuraEnabled
    public static List<InfoPraticaOutput> getInfoPratiche(String dataJSON,String societa){
        List<InfoPraticaOutput> res=new List<InfoPraticaOutput>();
        Boolean compass=societa.equals(XCSCompassConstants.COMPASS);
        List<Object> data=(List<Object>)JSON.deserialize(dataJSON,(compass?List<OCSPratica>.class:List<OCSPraticaFuturo>.class));
        System.debug('CRMReclamiInsClienteContainerCtrl getInfoPratiche data: ' + data);
        if(data.size()>0){
            for(Object p:data){
                system.debug('@@@ ---> '+p);
                if(compass){
                    res.add(buildOutputCompass((OCSPratica)p));
                }
                else{
                    res.add(buildOutputFuturo((OCSPraticaFuturo)p));
                }
            }
        }
        System.debug('CRMReclamiInsClienteContainerCtrl getInfoPratiche res: '+res);
        return res;
    }
    
    @AuraEnabled
    public static List<OCSCliente> makeCoobbligati(OCSPratica pratica,String societa){
		system.debug('RecInsCliContCtrl_pratica: '+pratica);

			  system.debug('RecInsCliContCtrl_pratica.elencoCoob.SIZE: '+pratica.elencoCoobbligati.size());
            system.debug('RecInsCliContCtrl_pratica.elencoCoob: '+pratica.elencoCoobbligati);
            if(pratica.elencoCoobbligati!=null && pratica.elencoCoobbligati.size()>0){
                List<Account> accList=AccountUtils.makeAccounts(pratica.elencoCoobbligati,societa);
                for(OCSCliente c:pratica.elencoCoobbligati){
                    for(Account a:accList){
                        if(c.codCliente.equals(a.getCodice_Cliente__c)){
                            System.debug('inserimento container recalmi IMPOSSIBLE IF');
                            c.SFId=a.Id;
                            break;
                        }
                    }
                }
            }
            
        return pratica.elencoCoobbligati;
    }
    
    private static InfoPraticaOutput buildOutputCompass(OCSPratica p){
        InfoPraticaOutput res=new InfoPraticaOutput();
        res.societa= XCSCompassConstants.COMPASS;
        res.tipo=p.tipoPratica;
        res.numPratica=p.numPratica;
        res.cartaRes=res.tipo.equalsIgnoreCase('CA')?OCSRecuperaInfoCartaInvoker.callRecInfoCarta(res.numPratica):null;
        res.praticaRes=res.tipo.equalsIgnoreCase('CO')?OCS_recuperaInfoPraticaInvoker.callAggiornaDati(res.numPratica):null;
        OCSRecuperaPacchettiServiziResponse pacchettiServiziRes=OCSRecuperaPacchettiServiziInvoker.callRecPacchServ(res.tipo,res.numPratica);
        List<OCSRecuperaPacchettiServiziResponse.PacchettoServizioDTO> pacchettiServizi=pacchettiServiziRes.recuperaPacchettiServiziResponse.elencoPacchettiServizi;
        List<OCSPratica.PacchettoAssicurativo> pacchettiAssicurativi=new List<OCSPratica.PacchettoAssicurativo>();
        if(pacchettiServizi != null){
            for(OCSRecuperaPacchettiServiziResponse.PacchettoServizioDTO ps:pacchettiServizi){
                OCSPratica.PacchettoAssicurativo temp=new OCSPratica.PacchettoAssicurativo();
                temp.codice=ps.codServizio;
                temp.descrizione=getDescServizio(ps.codServizio);
                pacchettiAssicurativi.add(temp);
            }
        }
        res.pacchettiAssicurativi=pacchettiAssicurativi;
        
 /*       res.info='Tipologia: '+res.tipo;
        res.info+='\nNumero Pratica: '+res.numPratica;
        res.info+='\nStato: '+p.statoPratica+' '+p.desStatoPratica;
        res.info2='PAN: '+p.pan;
        res.info2+='\nClass.: '+p.classifRecupero;
        res.info2+='\nUff. Class.: '+getUffClass(res.tipo,p.codRecuperatore);
        res.info2+='\nMod. Pag.: '+p.tipoPagamento;
        res.info2+='\nDealer: '+p.venditore+' '+ getRagSocDealer(p.venditore);
        res.assicurazioni=''; */
        String Tipo='';
        String ModPagam='';
        if(res.tipo=='CO'){
            Tipo='Consumo';
        }
        else if(res.tipo=='CA'){
            Tipo='Carta';
        }
        else if (res.tipo=='CQ' || res.tipo=='C'){
            Tipo='CQS';
    	}
        else if (res.tipo=='CP'){
            Tipo='CPay';
    	}
        else if (res.tipo=='D'){
            Tipo='Delegazione';
    	}
        
        if(p.tipoPagamento =='BP'){
            ModPagam='Bollettino Postale';
        }
        else if(p.tipoPagamento =='CR'){
             ModPagam='Carta';
        }
        else if(p.tipoPagamento =='RI'){
            ModPagam='Rid';
        }
        system.debug('Dealer :::: '+ p.dealerCode);
        res.tipologia = Tipo;
        res.numPratica2 = res.numPratica != null ? res.numPratica : '';
        res.stato =  p.codStatoPratica +' - '+ p.desStatoPratica;
        res.pan = p.pan != null ? p.pan : '';
        res.classe = p.classifRecupero != null ? p.classifRecupero : '';
        res.uffClass = getUffClass(res.tipo, p.codRecuperatore);
        res.modPag = ModPagam;
        res.dealer = p.dealerCode+' '+ getRagSocDealer(p.dealerCode); 

        if(pacchettiServiziRes!=null){
            if(pacchettiServizi.size()>0){
                if((pacchettiServizi[0].codServizio+' '+ getDescServizio(pacchettiServizi[0].codServizio))!= null)
                	res.assicurazioni = pacchettiServizi[0].codServizio+' '+ getDescServizio(pacchettiServizi[0].codServizio);
                                                                                                                                                                       
                res.info2+='\nAssicurazioni 1 :'+pacchettiServizi[0].codServizio+' '+getDescServizio(pacchettiServizi[0].codServizio);
                if(pacchettiServizi.size()>1){
                    res.assicurazioni+='; ' + pacchettiServizi[1].codServizio+' '+getDescServizio(pacchettiServizi[1].codServizio);
                    res.info2+='\n2 :'+pacchettiServizi[1].codServizio+' '+getDescServizio(pacchettiServizi[1].codServizio);
                    if(pacchettiServizi.size()>2){
                        res.assicurazioni+='; '+pacchettiServizi[2].codServizio+' '+getDescServizio(pacchettiServizi[2].codServizio);
                        res.info2+='\n3 :'+pacchettiServizi[2].codServizio+' '+getDescServizio(pacchettiServizi[2].codServizio);
                    }
                }
            }
        }
        return res;
    }
    
    private static String getUffClass(String tipo, String codRec){
        String res='';        
        List<office_classificazione_recupero__mdt> descrizione = [SELECT Descrizione__c FROM office_classificazione_recupero__mdt
                                                                  WHERE Codice_Recuperatore__c =: codRec AND Tipo_Pratica__c =: tipo];
        
        if(descrizione.size() > 0){
            System.debug('descrizione = ' + descrizione[0].descrizione__c);
            res = descrizione[0].descrizione__c;
        }
        return res;
    }
    
    private static String getRagSocDealer(String venditore){
        String res = '';
        List<Account> acc = [SELECT name FROM account WHERE getCodice_Cliente__c =: venditore];
        
        if(acc.size() > 0)
            res = acc[0].name;
        
        return res;
    }
    
    private static InfoPraticaOutput buildOutputFuturo(OCSPraticaFuturo p){
        InfoPraticaOutput res=new InfoPraticaOutput();
     //   SYSTEM.DEBUG('res_buildOutputFuturo : '+ res);
		 SYSTEM.DEBUG('res_buildOutputFuturo_OCSPraticaFuturo : '+ p.assicImpiegoRagSoc);
        res.societa=XCSCompassConstants.FUTURO;
  /*      res.tipo=p.tipoPratica;
        res.numPratica=p.numPratica;
        res.info='\nTipologia2: '+res.tipo;
        res.info+='\nNumero Pratica: '+res.numPratica;
        res.info+='\nStato: '+p.codStatoPratica+' '+p.desStatoPratica;
        res.info2='ATC: '+p.aziendaRagSoc;
        res.info2+='\nAssic. Impiego/Pensione: '+p.assicImpiegoRagSoc;
        res.info2+='\nAssic. Vita: '+p.assicVitaRagSoc;
        res.info2+='\nPartner: '+p.agenteRagSoc;
        res.info2+='\nClass.: '+p.classifRecupero;
        res.info2+='\nUff. Class.: '+ getUffClassFuturo(p.classifRecupero);
   */   
        String Tipo='';
        
        if(p.tipoPratica=='CO'){
            Tipo='Consumo';
        }
        else if(p.tipoPratica=='CA'){
            Tipo='Carta';
        }
        else if (p.tipoPratica=='CQ' || p.tipoPratica=='C'){
            Tipo='CQS';
    	}
        else if (p.tipoPratica=='CP'){
            Tipo='CPay';
    	}
        else if (p.tipoPratica=='D'){
            Tipo='Delegazione';
    	}
        
        
        
        res.numPratica=p.numPratica;
   	    res.tipologia = Tipo;
        res.numPratica2 = res.numPratica != null ? res.numPratica : '';
        res.aziendaRagSoc = p.aziendaRagSoc;
        res.stato = p.codStatoPratica +' - '+ p.desStatoPratica;
        res.assicImpiegoRagSoc = p.assicImpiegoRagSoc;
        res.assicVitaRagSoc = p.assicVitaRagSoc;
        res.classe = p.classifRecupero != null ? p.classifRecupero : '';
        res.uffClass = getUffClassFuturo(p.classifRecupero);
        res.agenteRagSoc = p.agenteRagSoc != null ? p.agenteRagSoc : '';
        
        
        
     /*   
        
       SYSTEM.DEBUG('res.info2 : '+res.info2);
        res.tipologia = res.tipo != null ? res.tipo : '';
        res.numPratica2 = res.numPratica != null ? res.numPratica : '';
        //res.stato = p.statoPratica != null ? p.statoPratica +' '+ p.desStatoPratica != null ? p.desStatoPratica : ' ' : ' ';
        //res.pan = p.pan != null ? p.pan : '';
        res.classe = p.classifRecupero != null ? p.classifRecupero : '';
        res.uffClass = getUffClass(res.tipo, p.codRecuperatore);
        //res.modPag = p.tipoPagamento != null ? p.tipoPagamento : '';
        //res.dealer = p.venditore+' '+ getRagSocDealer(p.venditore);     


*/



        return res;
    }
    
    public static String getUffClassFuturo(String classifRecupero){
        System.debug('CRMReclamiInsClienteContainerCtrl getUffClassFuturo CLASSIFRECUPERO: ' + classifRecupero);
        List<office_classificazione_recupero__mdt> infoPratList = [SELECT Descrizione__c FROM office_classificazione_recupero__mdt 
                                                                   WHERE Codice_Recuperatore__c = :classifRecupero AND Societa__c = :XCSCompassConstants.FUTURO];
        if(infoPratList.size()>0)  
            return infoPratList[0].Descrizione__c;
        else 
            return '';
    }  
    
    private static String getDescServizio(String codServizio) {
        String res = '';
        List<servizi_assicurativi__mdt> serv=[select Company_Name__c from servizi_assicurativi__mdt where Label=:codServizio];
        if(serv.size()>0){
            res=serv[0].Company_Name__c;
        }
        return res;
    }
    
    public class InfoPraticaOutput{
        @AuraEnabled
        public String numPratica{get;set;}
        @AuraEnabled
        public String societa{get;set;}
        @AuraEnabled
        public string tipo{get;set;}
        @AuraEnabled
        public String info{get;set;}
        @AuraEnabled
        public String info2{get;set;}
        @AuraEnabled
        public String assicurazioni{get;set;}
        @AuraEnabled
        public List<OCSPratica.PacchettoAssicurativo> pacchettiAssicurativi{get;set;}
        @AuraEnabled
        public OCSRecuperaInfoCartaResponse cartaRes{get;set;}
        @AuraEnabled
        public OCS_recuperaInfoPraticaResponse praticaRes{get;set;}


        @AuraEnabled
        public string tipologia{get;set;}
        @AuraEnabled
        public string numPratica2{get;set;}
        @AuraEnabled
        public string classe{get;set;}
        @AuraEnabled
        public string stato{get;set;}
        @AuraEnabled
        public string pan{get;set;}
        @AuraEnabled
        public string uffClass{get;set;}
        @AuraEnabled
        public string modPag{get;set;}
        @AuraEnabled
        public string dealer{get;set;}
        
        @AuraEnabled
        public string assicImpiegoRagSoc{get;set;}
        @AuraEnabled
        public string aziendaRagSoc{get;set;}
        @AuraEnabled
        public string assicVitaRagSoc{get;set;}
        @AuraEnabled
        public string agenteRagSoc{get;set;}
 
    }
}