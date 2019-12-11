//----------------------------------------------------------------------
//-- - Class Name   : XCSReclamiUtils
//-- - Autor        : 
//-- - Date         : 10/03/2018
//-- - Description  : Descrizione Prova
//-- - Version      : 1.0
//----------------------------------------------------------------------

public without sharing  class XCSReclamiUtils{

    public static final List<String> rule_autorita = new List<String>{'5413','5414','5415','5416','5417','5418'};
    public static final List<String> rule_altro = new List<String>{'5411','5412','4138'};
    public static final String rule_reclamo = '4137';
    public static final String rule_collector = '4176';
    public static final List<String> rule_ass_reclamo = new List<String>{'5445','5409'};
    public static final List<String> rule_ass_altro = new List<String>{'5446','5410'};
    public static final List<String> queue = new List<String>{'DN_300','DN_52','DN_343'};
    
    public static XCSReclamiInput getInputObj(String inputJson, String societa){    
        System.debug('XCSReclamiUtils getInputObj : input Json = ' + inputJson);
        Object res;
        if(XCSCompassConstants.COMPASS.equals(societa))
            res=Json.deserialize(inputJson, XCSReclamiInputCompass.class);
        else if(XCSCompassConstants.FUTURO.equals(societa)){
            res=Json.deserialize(inputJson, XCSReclamiInputFuturo.class);
        }
        else{
            res=Json.deserialize(inputJson, XCSReclamiInputMBC.class);
        }
        
        System.debug('XCSReclamiUtils getInputObj res: '+res);
        return (XCSReclamiInput)res;
    }
    
     public static Case creaReclamo(XCSReclamiInput data, String societa, List<Attachment> fileList, Case reclamoSelezionato ){
		system.debug('---------------------------------------------------------------------------------------');
		system.debug('-- Class Name: XCSReclamiUtils - Method Name: creaReclamo'); 

        Case res = CaseUtils.makeReclamo();
        res = buildReclamo(res,data,societa,fileList,reclamoSelezionato);
        
        
        //Associazione cliente
        setCliente(res, data.clienteSelezionatoContainer);
        System.debug('******************************************************** insert reclamo = ' + res);
         Id coda = res.OwnerId;
         res.OwnerId=UserInfo.getUserId();
        insert res;
        
        //Allegati
        attachFiles(res.Id, fileList);
        
        //Associazione mittenti
         setMittenti(res.Id, data.mittentiList);
         res.OwnerId = coda;
         update res;
         return res;
    } 
    /*
    public static Case creaReclamo(XCSReclamiInput data, String societa, List<ContentDocument> fileList, Case reclamoSelezionato ){
		system.debug('---------------------------------------------------------------------------------------');
		system.debug('-- Class Name: XCSReclamiUtils - Method Name: creaReclamo'); 

        Case res = CaseUtils.makeReclamo();
        res = buildReclamo(res,data,societa,fileList,reclamoSelezionato);
        
        
        //Associazione cliente
        setCliente(res, data.clienteSelezionatoContainer);
        System.debug('******************************************************** insert reclamo = ' + res);
        insert res;
        
        //Allegati
        attachFiles(res.Id, fileList);
        
        //Associazione mittenti
        setMittenti(res.Id, data.mittentiList);
        
        return res;
    }*/

    public static List<XCS_Responsabilita__c> ResponsabilitaBranch (Case reclamoSelezionato)
    {  
        return [select Related_Account__c from XCS_Responsabilita__c where Related_Case__c =:reclamoSelezionato.Id];
    }
    
    public static List<string> parsResponsabilitaBranch (Case reclamoSelezionato)
    {  
        List<String> lString = new List<String>();
        for(XCS_Responsabilita__c r : ResponsabilitaBranch(reclamoSelezionato))
        {
            lString.add(r.Related_Account__c); 
        }
        return lString;
    }
    
    
    public static Case salvaReclamo(XCSReclamiInput data, String societa, List<Attachment> fileList, Case reclamoSelezionato, Boolean isQueueChanged, String recordId ){
        
        Case res = CaseUtils.makeReclamo();
        res.id = recordId;
        res = buildReclamo(res,data,societa,fileList,reclamoSelezionato); 

        setCliente(res, data.clienteSelezionatoContainer);
        update res;

        setMittenti(res.Id, data.mittentiList);
        return res;
    }
    
    private static Case buildReclamo(Case res, XCSReclamiInput data, String societa, List<Attachment> fileList, Case reclamoSelezionato ){
        res = buildReclamoBody(res,data,societa);
        res = buildBodyChiusura(res,data);
        system.debug('data: '+data);
        system.debug('data.dettagliOutputObj: '+data.dettagliOutputObj);
        system.debug('data.dettagliOutputObj.codaSelezionata: '+data.dettagliOutputObj.codaSelezionata);
        system.debug('data.dettagliOutputObj.codaSelezionata.DeveloperName: '+data.dettagliOutputObj.codaSelezionata.DeveloperName);
        //Assegnazione Coda
        res.OwnerId = GroupUtils.getQueue('Q'+data.dettagliOutputObj.codaSelezionata.DeveloperName.substring(3,data.dettagliOutputObj.codaSelezionata.DeveloperName.length())).Id;
        
        //Attribuzione reclamo
        res=attribuzioneReclamo(res, data.dettagliOutputObj.attribuzioneReclamo);
        
        //Contatto precedente
        Schema.DescribeFieldResult fieldResult = Case.Contatto_Precedente__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry pickListVal:ple){
            if(pickListVal.getLabel().equals(data.dettagliOutputObj.contattoPrecedente)){
                res.Contatto_Precedente__c = pickListVal.getValue();
            }
        }
        
        //Inadempimento
        if(societa.equals('Compass')){
            res=setInadempimento(res,data);
        }
        
        //Calcolo del numero del reclamo con Associazione a reclamo precedente
        res=setReclamoNumber(res, reclamoSelezionato);
        System.debug('XCSReclamiUtils creaReclamo res: ' + res);
        
        //Calcolo livello di approvazione
        res=setApprovazione(res,data);
        
        return res;
    }
    
    private static Case buildReclamoBody(Case res, XCSReclamiInput data, String societa){
        res.Referenced_Company__c=societa; 
        
        res = buildReclamoBodyCommon(res, data);
        if(XCSCompassConstants.COMPASS.equals(societa)){
            res=buildReclamoBody(res,(XCSReclamiInputCompass)data);
        }
        else if(XCSCompassConstants.FUTURO.equals(societa)){
            res=buildReclamoBody(res,(XCSReclamiInputFuturo)data);
        }
        else{
            res=buildReclamoBody(res,(XCSReclamiInputMBC)data);
        }
        return res;
    }
    
    private static Case buildReclamoBodyCommon(Case res, XCSReclamiInput data){
        res=buildBodyDettagliHeader(res, data);
        res=buildBodyDettagliRadio(res, data);
        String societaAbbr=res.Referenced_Company__c.equals(XCSCompassConstants.COMPASS) ? 'C' : res.Referenced_Company__c.equals(XCSCompassConstants.FUTURO) ? 'F' : 'R';
        String descrizioneTipo=[select Descrizione__c from CRM_RCL_Tipologia_Reclamo__mdt where Societa__c=:societaAbbr and External_Id__c=:res.Tipo_Reclamo__c].Descrizione__c;
        if(descrizioneTipo.contains(XCSCompassConstants.ASSICURAZIONE)){
            res = buildBodyDettagliAggiuntivi(res, data);
        }
        return res;
    }
    
    private static Case buildBodyDettagliHeader(Case res, XCSReclamiInput data){
     
        res.Tipo_Reclamo__c = data.dettagliOutputObj.headerOutput.tipoDettagli;
        res.DataSegnalazione__c = Date.valueOf(data.dettagliOutputObj.headerOutput.dataComunicazione);
        res.Data_Ricezione__c = Date.valueOf(data.dettagliOutputObj.headerOutput.dataRicezione);
        res.Data_Ricezione_IDM__c = Date.valueOf(data.dettagliOutputObj.headerOutput.dataRicezioneIDM);

   
        res.Data_Decisione__c = null;
  
        if(data!=null && data.dettagliOutputObj!= null && data.dettagliOutputObj.headerOutput!=null && data.dettagliOutputObj.headerOutput.dataDecisione!=null){
            res.Data_Decisione__c = Date.valueOf(data.dettagliOutputObj.headerOutput.dataDecisione);
        }
//--------------------------------------------------------------------
//-- - FINE MODIFICA
//--------------------------------------------------------------------


        Schema.DescribeFieldResult fieldResult = Case.Modalita_Invio__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry pickListVal:ple){
            if(pickListVal.getLabel().equals(data.dettagliOutputObj.headerOutput.modalitaInvioDettagli)){
                res.Modalita_Invio__c=pickListVal.getValue();
            }
        }  
        res.Delega_Presente__c = Boolean.valueOf(data.dettagliOutputObj.headerOutput.delegaPresente);
        res.Has_Acceso_Dati__c = Boolean.valueOf(data.dettagliOutputObj.headerOutput.accessoDati);

        system.debug('----------------------------------------------------------------------------------');
		system.debug('-- Class Name: XCSReclamiUtils  - Method Name : buildBodyDettagliHeader'); 
		system.debug('-- Variable Name: Scadenza_Reclamo__c  - Value: ' + res.Scadenza_Reclamo__c); 

        if(res.Has_Acceso_Dati__c){
            
            res.Scadenza_Reclamo__c = res.Data_Ricezione__c+12;
        }
        else{
            res.Scadenza_Reclamo__c = res.Data_Ricezione__c+27;
        }
        System.debug('sono in xcsreclamiUtils, buildBodyDettagliHeader data.dettagliOutputObj.headerOutput = ' + data.dettagliOutputObj.headerOutput);
        System.debug('sono in xcsreclamiUtils, buildBodyDettagliHeader IsGrave = ' + data.dettagliOutputObj.headerOutput.isGrave);
        if(!(data.dettagliOutputObj.headerOutput.isGrave == null))            
            res.Inadempimento_Grave__c = Boolean.valueOf(data.dettagliOutputObj.headerOutput.isGrave);
        
        if(res.Inadempimento_Grave__c){
            res.Reclamo_Completo__c = Boolean.valueOf(data.dettagliOutputObj.headerOutput.reclamoCompleto);
        }
        res.Categoria_Riferimento__c = data.dettagliOutputObj.headerOutput.categoriaDettagli.Id;
        return res;
    }
    
    private static Case buildBodyDettagliRadio(Case res, XCSReclamiInput data){
        System.debug('---------------------------------------------------------------------------------------');
        System.debug('-- Class Name: XCSReclamiUtils - Method Name: buildBodyDettaglioradio'); 
        System.debug('data = ' + json.serialize(data));
        System.debug('data = ' + data);
//        System.debug('data.dettagliOutputObj.radioOutput.rimborsoOutput = ' + data.dettagliOutputObj.radioOutput.rimborsoOutput.selection);
//        System.debug('data.dettagliOutputObj.radioOutput.rimborsoOutput = ' + data.dettagliOutputObj.radioOutput.rimborsoOutput.value);
//        System.debug('data.dettagliOutputObj.radioOutput = ' + data.dettagliOutputObj.radioOutput);
//        System.debug('data.dettagliOutputObj.radioOutput.comuniOutput = ' +  data.dettagliOutputObj.radioOutput.comuniOutput);
//        System.debug('data.dettagliOutputObj.radioOutput.comuniOutput.abbuonoOutput = ' +  data.dettagliOutputObj.radioOutput.comuniOutput.abbuonoOutput);
//        System.debug('data.dettagliOutputObj.radioOutput.comuniOutput.risarcimentoOutput = ' +  data.dettagliOutputObj.radioOutput.comuniOutput.risarcimentoOutput);
        
        //comuni
        res.Abbuono_Richiesta__c = data.dettagliOutputObj.radioOutput.comuniOutput.abbuonoOutput.selection.equals('Si');
        res.Importo_Abbuono_Richiesta__c = data.dettagliOutputObj.radioOutput.comuniOutput.abbuonoOutput.value;
        res.Compensazione__c = data.dettagliOutputObj.radioOutput.comuniOutput.risarcimentoOutput.selection.equals('Si');
        res.Importo_Compensazione__c = data.dettagliOutputObj.radioOutput.comuniOutput.risarcimentoOutput.value;
        
        //futuro
        if(res.Referenced_Company__c.equals(XCSCompassConstants.FUTURO)){
            XCSReclamiDettagliOutputDTO.FuturoOutputDTO temp = data.dettagliOutputObj.radioOutput.futuroOutput;
            res.F_Has_Rimborso_Commissioni_In__c = temp.commissioniOutput.selection.equals(XCSCompassConstants.SI);
            res.F_Rimborso_Commissioni_Importo_In__c = temp.commissioniOutput.value;
            res.F_Has_Rimborso_Provvigioni_In__c = temp.provvAccOutput.selection.equals(XCSCompassConstants.SI);
            res.F_Rimborso_Provvigioni_Importo_In__c = temp.provvAccOutput.value;
            res.F_Has_Rimborso_Assicurativo_In__c = temp.premioAssOutput.selection.equals(XCSCompassConstants.SI);
            res.F_Rimborso_Assicurativo_Importo_In__c = temp.premioAssOutput.value;
            res.F_Has_Rimborso_Varie_In__c = temp.varieOutput.selection.equals(XCSCompassConstants.SI);
            res.F_Rimborso_Varie_Importo_In__c = temp.varieOutput.value;
            res.F_Has_Rimborso_Spese_Legali_In__c = temp.speseLegaliOutput.selection.equals(XCSCompassConstants.SI);
            res.F_Rimborso_Spese_Legali_Importo_In__c = temp.speseLegaliOutput.value;
        }
        
        
        //Compass/mbc
        else{
            //originale per inserimento
            res.Has_Rimborso__c = data.dettagliOutputObj.radioOutput.rimborsoOutput.selection.equals(XCSCompassConstants.SI);
            //implementata per gestione !?
            //res.Has_Rimborso__c = data.dettagliOutputObj.radioOutput.comuniOutput.rimborsoOutput.selection.equals(XCSCompassConstants.SI);
            
            //System.debug('data.dettagliOutputObj.radioOutput.comuniOutput.rimborsoOutput.value = ' +  data.dettagliOutputObj.radioOutput.comuniOutput.rimborsoOutput.value);
            res.Importo_Rimborso__c = data.dettagliOutputObj.radioOutput.rimborsoOutput.value;
            if(res.Referenced_Company__c.equals(XCSCompassConstants.COMPASS)){
                res.Stand_Alone__c = data.dettagliOutputObj.radioOutput.standaloneOutput.selection.equals(XCSCompassConstants.SI);
            }
        }
        
        return res;
    }
    
    @AuraEnabled
    public static boolean isFrode(String categoria, String societa){
        List<categ_frodi__mdt> listaF = [SELECT Id, DeveloperName, External_Id__c, Societa__c, Flag_Frodi__c FROM categ_frodi__mdt Where Societa__c=:societa and External_Id__c = :categoria];
    	return !(listaF == null || listaF.size()==0);
    }
    
    private static Case buildBodyDettagliAggiuntivi(Case res, XCSReclamiInput data){
        System.debug('data.dettagliOutputObj.aggiuntiviOutput = '+data.dettagliOutputObj.aggiuntiviOutput);
        /* Che è sta roba??? bisogna agganciarla anche nel javascript? perchè non vedo riscontro diretto nel component????
*/
        res.Trattabile__c = data.dettagliOutputObj.aggiuntiviOutput.trattabile.equals(XCSCompassConstants.TRATTABILE);
        res.Tipo_Prodotto_Vita__c = data.dettagliOutputObj.aggiuntiviOutput.tipoProdottoVita;
        res.Tipo_Prodotto_Danni__c = data.dettagliOutputObj.aggiuntiviOutput.tipoProdottoDanni;
        res.Area_Aziendale__c = data.dettagliOutputObj.aggiuntiviOutput.areaAziendale;
        res.Tipo_Proponente__c = data.dettagliOutputObj.aggiuntiviOutput.tipoProponente;
        res.Area_Geo_Proponente__c = data.dettagliOutputObj.aggiuntiviOutput.areaGeograficaProponente;
        res.Tipo_Reclamante__c = data.dettagliOutputObj.aggiuntiviOutput.tipoReclamante;
        
        return res;
    }
    
    private static Case buildBodyChiusura(Case res, XCSReclamiInput data){
        //
        /*
System.debug('data = ' + data);

res.Attesa_Assegno__c = data.dettagliOutputObj.chiusuraOutput.AssegnoOutput.selection.equalsIgnoreCase('Si');
res.Decisione__c = data.dettagliOutputObj.chiusuraOutput.Decisione.value;
*/       
        return res;
    }
    
    //dati relativi alla pratica, nel caso 'Compass'
    private static Case buildReclamoBody(Case res, XCSReclamiInputCompass data){
        
        res.Is_Sconosciuto__c = data.isSconosciuto();
        OCSPratica p = data.getPratica();
        if(p != null){
            res.NumeroPratica__c = p.numPratica;
            res.PAN__c = p.pan;
            res.Tipo_Pratica__c = p.tipoPratica;
            res.Tipo_Prodotto__c = p.prodotto;
            res.Stato_Pratica__c = p.statoPratica;
            res.Modalita_Pagamento__c = p.tipoPagamento;
            res.Data_Creazione_Pratica__c = getDate(p.dataCaricamento);
            //res.Dealer__c
            //res.Decisione__c=
            res.Classe_Debito__c = p.classifRecupero;
            res.Attributi_Pratica__c = p.codAttributoPratica + ' ' + p.desAttributoPratica;
            if(p.elencoCoobbligati != null && p.elencoCoobbligati.size() > 0){
                res.Coobbligato_1__c = p.elencoCoobbligati[0].SFId;
                if(p.elencoCoobbligati.size()>1){
                    res.Coobbligato_2__c = p.elencoCoobbligati[1].SFId;
                    if(p.elencoCoobbligati.size()>2){
                        res.Coobbligato_3__c = p.elencoCoobbligati[2].SFId;
                    } 
                }
            }
            if(p.pacchettiAssicurativi != null && p.pacchettiAssicurativi.size() > 0){
                res.Codice_Assicurazione_1__c = p.pacchettiAssicurativi[0].codice;
                res.Descrizione_Assicurazione_1__c = p.pacchettiAssicurativi[0].descrizione;
                if(p.pacchettiAssicurativi.size()>1){
                    res.Codice_Assicurazione_2__c = p.pacchettiAssicurativi[1].codice;
                    res.Descrizione_Assicurazione_2__c = p.pacchettiAssicurativi[1].descrizione;
                    if(p.pacchettiAssicurativi.size()>2){
                        res.Codice_Assicurazione_3__c = p.pacchettiAssicurativi[2].codice;
                        res.Descrizione_Assicurazione_3__c = p.pacchettiAssicurativi[2].descrizione;
                    }
                }
            }
        }
        return res;
    }
    
    //dati relativi alla pratica, nel caso 'Futuro'
    private static Case buildReclamoBody(Case res, XCSReclamiInputFuturo data){
        
        res.Is_Sconosciuto__c = data.isSconosciuto();
        
        OCSPraticaFuturo p = data.getPratica();
        if(p != null){
        res.NumeroPratica__c = p.numPratica;
        res.Data_Creazione_Pratica__c = getDate(p.dataCaricamento);
        res.Tipo_Pratica__c= p.tipoPratica;
        res.Stato_Pratica__c= p.codStatoPratica + '|' + p.desStatoPratica;
        res.Attributi_Pratica__c = p.codAttributoPratica +' '+ p.desAttributoPratica;
        res.F_Data_Contratto__c =  + getDate(p.dataContratto);
        res.F_Data_Estinzione__c = getDate(p.dataEstinzioneAnticipata);
        res.Has_Recupero__c = p.flagRecupero.equalsIgnoreCase('S');
        res.Classe_Debito__c = p.classifRecupero;
        res.Codice_Recuperatore__c = p.codRecuperatore + ' ' + p.desRecuperatore;
        res.F_Codice_OCS_Azienda__c = P.aziendaCod;
        res.F_Ragione_Sociale_Agente__c = p.aziendaRagSoc;
        res.F_Indirizzo_Azienda__c = p.aziendaIndirizzo;
        //res. = p.aziendaCap;
        //res. = p.aziendaLocalita;
        //res. = p.aziendaProv;
        //res. = p.aziendaSedeCod;
        //res. = p.aziendaSedeRagSoc;
        //res. = p.aziendaSedeIndirizzo;
        //res. = p.aziendaSedeCap;
        //res. = p.aziendaSedeLocalita;
        //res. = p.aziendaSedeProv;
        res.F_Codice_OCS_Agente__c = p.agenteCod;
        res.F_Ragione_Sociale_Agente__c = p.agenteRagSoc;
        res.F_Codice_OCS_SubAgente__c = p.subAgenteCod;
        res.F_Ragione_Sociale_SubAgente__c = p.subAgenteRagSoc;
        res.F_Codice_OCS_Banca__c = p.bancaCod;
        res.F_Ragione_Sociale_Banca__c = p.bancaRagSoc;
        res.F_Ragione_Sociale_Filiale__c = p.filBancaCod;
        res.F_Ragione_Sociale_Filiale__c = p.filBancaRagSoc;
        res.F_Assic_Vita__c = p.assicVitaCod;
        //res. = p.assicVitaRagSoc;
        res.F_Assic_Impiego_Pensione__c = p.assicImpiegoCod;
        //res. = p.assicImpiegoRagSoc;
        }
        return res;
    } 
    
    //Metodo per MBCS (da capire se si deveno riempire ulteriori campi oppure no)
    private static Case buildReclamoBody (Case res, XCSReclamiInputMBC data){
        res.Is_Sconosciuto__c = data.isSconosciuto();
        return res;
    }
    
    private static Case attribuzioneReclamo(Case res, List<String> data){
        String values = '';
        for(String s:data){
            values += s + ';';
        }
        res.Attribuzione__c = values.length() > 0 ? values.substring(0, values.length() -1): '';
        return res;
    }
    
    private static Case setInadempimento(Case res, XCSReclamiInput data){
        System.debug('case res = ' + res);
        if(getGrave(data.dettagliOutputObj.headerOutput.categoriaDettagli, XCSCompassConstants.COMPASS ) && 
           data.dettagliOutputObj.headerOutput.delegaPresente.equals( XCSCompassConstants.SI ) &&
           data.dettagliOutputObj.codaSelezionata.DeveloperName == 'Q57'){
               res.Inadempimento_Grave__c = data.dettagliOutputObj.sezInadempimentoOutput.gravitaDettagli.equalsIgnoreCase('Uff. Legale – Grave') ? true : false;
               res.Stage_Inadempimento__c = data.dettagliOutputObj.sezInadempimentoOutput.stageInadempimento;
               res.F_T_Received_Count__c = data.dettagliOutputObj.sezInadempimentoOutput.FTReceived;
               res.F_T_Sent_Count__c = data.dettagliOutputObj.sezInadempimentoOutput.FTSent;
               
           } 
        return res;
    }
    @AuraEnabled
    public static Boolean getGrave(XCS_Categoria__c categ,String societa){
        List<categ_grave__mdt>  resList =  new List<categ_grave__mdt>();
        if(categ != null){  
       		resList=[select Id from categ_grave__mdt where Societa__c=:societa and External_Id__c=:categ.External_Id__c];
        }    
        if(resList == null)return false;
        
        return resList.size()>0;
    }
    @AuraEnabled
    public static Boolean getGrave(String categ,String societa){
        List<categ_grave__mdt> resList=[select Id
                                        from categ_grave__mdt
                                        where Societa__c=:societa and External_Id__c=:categ];
        if(resList == null)return false;
        return resList.size()>0;
    }
    
    private static Case setReclamoNumber(Case res, Case reclamoPrecedente){
        res = calcolaNumeroProgressivo(res, reclamoPrecedente, isAssicurazione(res.Tipo_Reclamo__c));
        //assegna eventualmente al parent
        if(reclamoPrecedente != null && String.isNotEmpty(reclamoPrecedente.Id)){
            res.ParentId = reclamoPrecedente.Id;
        }
        return res;
    }
    
    private static Case calcolaNumeroProgressivo(Case res,Case reclamoPrecedente,Boolean isAssicurazione){
        
        if(isAssicurazione){
            res = calcolaNumeroProgressivoAss(res,reclamoPrecedente);
        }
        else{
            res = calcolaNumeroProgressivoNonAss(res,reclamoPrecedente);
        }
        return res;
    } 
    
    private static Case calcolaNumeroProgressivoAss(Case res,Case reclamoPrecedente){
        System.debug('rec precedente = ' + reclamoPrecedente);
        System.debug('res = ' + res);
        if(reclamoPrecedente != null){
            Integer SubNum = VerificaSubNumber(reclamoPrecedente);
            res.Subnumber_Reclamo__c = SubNum + 1 + '';
            //se il parent è anch'esso assicurativo
            if(reclamoPrecedente.Progressivo_Annuale_Assicurazione__c!=null){
                res.Progressivo_Annuale_Assicurazione__c = reclamoPrecedente.Progressivo_Annuale_Assicurazione__c;
                
                res.Anno__c = reclamoPrecedente.Anno__c;
            }
            //se il parent non è assicurativo
            else{
                res.Numero_Progressivo_Reclamo__c = reclamoPrecedente.Numero_Progressivo_Reclamo__c;
                res.Progressivo_Annuale_Assicurazione__c =  XCSReclamiNumProgressivoUtils.getProgAnnAss();
                res.Anno__c = Datetime.now().format('YYYY');
            }
            
        }
        else{
            res.Subnumber_Reclamo__c = '1';
            res.Progressivo_Annuale_Assicurazione__c = XCSReclamiNumProgressivoUtils.getProgAnnAss();
            res.Anno__c = Datetime.now().format('YYYY');
        }
        res.Numero_Reclamo__c = res.Progressivo_Annuale_Assicurazione__c + '.' + res.Subnumber_Reclamo__c + '/' + res.Anno__c;
        return res;
    }
    
    private static Case calcolaNumeroProgressivoNonAss(Case res,Case reclamoPrecedente){
        
        if(reclamoPrecedente!=null){
            Integer SubNum = VerificaSubNumber(reclamoPrecedente);
            res.Subnumber_Reclamo__c = SubNum + 1 + '';
            //se il parent non è assicurativo
            if(reclamoPrecedente.Numero_Progressivo_Reclamo__c!=null){
                res.Numero_Progressivo_Reclamo__c = reclamoPrecedente.Numero_Progressivo_Reclamo__c;
            }
            else{
                res.Numero_Progressivo_Reclamo__c = reclamoPrecedente.Progressivo_Annuale_Assicurazione__c;
            }
        }
        else{
            res.Subnumber_Reclamo__c = '1';
            res.Numero_Progressivo_Reclamo__c = XCSReclamiNumProgressivoUtils.getNumProgRec();
        }
        res.Numero_Reclamo__c=res.Numero_Progressivo_Reclamo__c + '-' + res.Subnumber_Reclamo__c;
        
        return res;
    }
    
    private static Integer VerificaSubNumber(Case reclamoPrecedente){
      
        String SubN ='';
        if(reclamoPrecedente.Numero_Progressivo_Reclamo__c != null){
            if(reclamoPrecedente.parentId == '' || reclamoPrecedente.parentId == null){
                  System.debug('CHECK1');
                List<Case> Precedenti = [select Subnumber_Reclamo__c from case where ParentId=:reclamoPrecedente.Id and Numero_Progressivo_Reclamo__c =:reclamoPrecedente.Numero_Progressivo_Reclamo__c order by Subnumber_Reclamo__c DESC];  
               if(Precedenti.size() > 0)
                	SubN = Precedenti[0].Subnumber_Reclamo__c;
                else
                   SubN =reclamoPrecedente.Subnumber_Reclamo__c;
            }
            else{
                  System.debug('CHECK2');
              List<Case> Precedenti = [select Subnumber_Reclamo__c from case where Numero_Progressivo_Reclamo__c =:reclamoPrecedente.Numero_Progressivo_Reclamo__c order by Subnumber_Reclamo__c DESC];  
              system.debug('Precedenti[0].Subnumber_Reclamo__c'+Precedenti[0].Subnumber_Reclamo__c);
              SubN = Precedenti[0].Subnumber_Reclamo__c;
            }
        }
        else{
            if(reclamoPrecedente.parentId == '' || reclamoPrecedente.parentId == null){
                  System.debug('CHECK3');
                system.debug('reclamoPrecedente.parentId: '+reclamoPrecedente.parentId);
                 system.debug('reclamoPrecedente.Progressivo_Annuale_Assicurazione__c:' + reclamoPrecedente.Progressivo_Annuale_Assicurazione__c);
                List<Case> Precedenti = [select Subnumber_Reclamo__c from case where ParentId=:reclamoPrecedente.Id and Progressivo_Annuale_Assicurazione__c =:reclamoPrecedente.Progressivo_Annuale_Assicurazione__c order by Subnumber_Reclamo__c DESC];  
                if(Precedenti.size() > 0)
                	SubN = Precedenti[0].Subnumber_Reclamo__c;
                else
                   SubN = reclamoPrecedente.Subnumber_Reclamo__c;
            }	
            else{
                  System.debug('CHECK4');
              List<Case> Precedenti = [select Subnumber_Reclamo__c from case where Progressivo_Annuale_Assicurazione__c =:reclamoPrecedente.Progressivo_Annuale_Assicurazione__c order by Subnumber_Reclamo__c DESC];  
              SubN = Precedenti[0].Subnumber_Reclamo__c;
            }
        }
        
      return  Integer.valueOf(SubN); 
    }
    
    private static Boolean isAssicurazione(String extIdTipo){
        
        List<CRM_RCL_Tipologia_Reclamo__mdt> tipi = [select Id,Descrizione__c from CRM_RCL_Tipologia_Reclamo__mdt where External_Id__c=:extIdTipo];
        return tipi.size() > 0 && tipi[0].Descrizione__c.contains(XCSCompassConstants.ASSICURAZIONE);
    }
    
    private static Case setApprovazione(Case res,XCSReclamiInput data){
        
        List<rules__mdt> rules = [select DeveloperName,Label__c,External_Id__c,Tipi_Associati__c
                                  from rules__mdt
                                  where Societa__c=:res.Referenced_Company__c];
        if(!String.isNotEmpty(res.Autorizzazione_Livello_1__c)){
            res.Autorizzazione_Livello_1__c=XCSCompassConstants.NESSUNO;
            res.Autorizzazione_Livello_2__c=XCSCompassConstants.NESSUNO;
        }
        
        Integer authLv = 0;
        if(!checkAuthBase(res.OwnerId)){
            authLv = 1;
        }
        if(checkAddedRules1(res, rules, data.dettagliOutputObj.headerOutput.categoriaDettagli)){
            authLv = 2;
        }
        if(checkAddedRules2(res, rules)){
            authLv = 0;
        }
        res.Livello_Autorizzazione__c=authLv;
        return res;
    }
    
    private static Boolean checkAuthBase(String queueId){
        String queueName=GroupUtils.getQueueName(queueId);
        System.debug('XCSReclamiUtils checkAuthBase queueName: '+queueName);
        return queueName.contains(XCSCompassConstants.IDM_RESPONSE_STAFF);
    }
    
    private static Boolean checkAddedRules1(Case c,List<rules__mdt> rules,XCS_Categoria__c categ){
        Boolean res = false;
        if(checkRulesForTipo(rules, c.Tipo_Reclamo__c, new List<String>{XCSCompassConstants.AUTORITA})){
            res = true;
        }
        if(checkRulesForTipo(rules, c.Tipo_Reclamo__c, new List<String>{XCSCompassConstants.RECLAMO}) && checkIfGrave(categ,c.Referenced_Company__c)){
            res = true;
        }
        System.debug('XCSReclamiUtils checkAddedRules1 res: '+res);
        return res;
    }
    
    private static Boolean checkAddedRules2(Case c, List<rules__mdt> rules){
        Boolean res = false;
        if(!checkRulesForTipo(rules, c.Tipo_Reclamo__c, new List<String>{XCSCompassConstants.AUTORITA}) && !checkRulesForTipo(rules, c.Tipo_Reclamo__c, new List<String>{XCSCompassConstants.RECLAMO})){
            res = true;
            //la regola ASS. RECLAMO prevede Nessuna autorizzazione solo nel caso in cui è stato specificato NO nel campo DELEGA PRESENTE
            //quindi se è ASS. RECLAMO e delega presente = SI pongo a false
            if(checkRulesForTipo(rules, c.Tipo_Reclamo__c, new List<String>{XCSCompassConstants.ASS_RECLAMO}) && c.Delega_Presente__c){
                res = false;
            }
        }
        System.debug('XCSReclamiUtils checkAddedRules2 res: '+res);
        return res;
    }
    
    private static Boolean checkIfGrave(XCS_Categoria__c categ,String societa){
        Boolean res=false;
        List<categ_grave__mdt> resList=[select id from categ_grave__mdt where Societa__c=:societa and External_id__c=:categ.External_Id__c];
        res=resList.size()>0;
        return res;
    }
    
    public static Boolean checkRulesForTipo(List<rules__mdt> rules, String tipo, List<String> namesToCheck){
 
        Boolean res = false;
        String descrizioneTipo=getDescrizioneTipo(tipo);
        for(rules__mdt r:rules){
            if(namesToCheck.contains(r.Label__c)){
                List<String> tempList = r.Tipi_Associati__c.split('/');
                if(tempList.contains(descrizioneTipo)){
                    res=true;
                    break;
                }
            }
        }
        return res;
    }
    
    private static String getDescrizioneTipo(String tipoExtId){
        String res='';
        List<CRM_RCL_Tipologia_Reclamo__mdt> resList=[select Descrizione__c from CRM_RCL_Tipologia_Reclamo__mdt where External_Id__c=:tipoExtId];
        if(resList.size()>0){
            res=resList[0].Descrizione__c;
        }
        return res;
    }
    
/*     private static void attachFiles(String caseId, List<Attachment> fileList){
        //List<ContentVersion> listaCV = new List<ContentVersion>();
        //for(Attachment a:fileList){
        //    ContentVersion temp = new ContentVersion();
        //    temp.versionData = EncodingUtil.base64Decode(a.Body + '');
        //    temp.parentId = a.ParentId;
        //    a.Body = EncodingUtil.base64Decode(a.Body + '');
        //    a.ParentId = caseId;
        //}
        //try{
        //    insert fileList;
        //}
        //catch(Exception e){
        //    
        //}
        
        list<ContentVersion> contVers = new list<ContentVersion>();
        list<ContentDocumentLink> cdlCont = new list<ContentDocumentLink>(); 
        
        for(Attachment a:fileList){
        
        contVers.add(new ContentVersion(Title = a.Name,
                                        PathOnClient = a.Name,
                                        ContentLocation = 'S',                                                        
                                        VersionData = EncodingUtil.base64Decode(a.Body + '')));
        }
        
        insert contVers;
        
        Map<Id, ContentVersion> mappa = new Map<Id, ContentVersion>([SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: contVers]);
        
        for(ContentVersion ctv: contVers){                                        
                    ContentDocumentLink cdl = new ContentDocumentLink();
                    cdl.ContentDocumentId = mappa.get(ctv.id).ContentDocumentId;
                    cdl.LinkedEntityId = caseId;
                    cdl.ShareType = 'V';
                    cdlCont.add(cdl);                   
                }
        insert cdlCont;
        
    } */
/*
    private static void attachFiles(Id caseId, List<ContentDocument> fileList){
        
        createFile(fileList,caseId);
        
    } */   
    private static void attachFiles(Id caseId, List<Attachment> fileList){   
        createFile(fileList,caseId);  
    }  
    
    private static void setMittenti(String caseId, List<XCS_Mittente__c> mittenti){
      

        List<XCS_Mittente__c> mittentiList = new List<XCS_Mittente__c>();
        for(XCS_Mittente__c m:mittenti){
            XCS_Mittente__c mit = new XCS_Mittente__c();
            mit = m;
          
            mit.Case__c = caseId;
            mittentiList.add(mit);
        }
        try{
            insert mittentiList;
        }
        catch(Exception e){}
   
    }
    
    private static void setCliente(Case res, OCSCliente c){
        
        if(res.Referenced_Company__c.equals(XCSCompassConstants.COMPASS)){
            res.AccountId = c.SFId;
            System.debug('XCSReclamiUtils setCliente accountId(Compass): ' + res.AccountId);
        }else{
            res.Account_Futuro_MBCS__c = c.SFId;
            System.debug('XCSReclamiUtils setCliente Account_Futuro_MBCS__c(Futuro/MBCS): ' + res.Account_Futuro_MBCS__c);
        }
    }
    
    private static Date getDate(String data){
        System.debug('data getDate = ' + data);
        Date res;
        try{
             res = 
                data != null ? 
                Date.valueOf( 
                    data.contains('/') ?
                    data.split('/')[2] + '-' + data.split('/')[1] + '-' + data.split('/')[0] :
                    data.length() == 8 ?
                    data.substring(0,4) + '-' + data.substring(4,6)+ '-' + data.substring(6,8) :
                    data) :
            null;
        }
        catch(Exception e){
            res = null;
        }

        return res;
    }
    
    public static String getIdReclamiUser(Id idUser){        
        return [Select RNT_profile_id__c from user where id =: idUser].RNT_profile_id__c;          
    }
   
    
    //Boris
    public static Reclami_Timestamp__c createFeedItem(String caseId, DateTime d, String evento, String utente, Boolean saveTime)  {
       Reclami_Timestamp__c  post = new Reclami_Timestamp__c();
        post.CaseId__c = caseId;
        post.Data__c = d;
        post.evento__c =  evento;
        post.Utente__c = UserInfo.getUserId();
        return post;
    }
        
    public static String getDate(Datetime t, Boolean saveTime){
        if(t ==null) return ' ';
        String s;
        if(t.day() < 10) s='0'+t.day();
        else s=t.day()+'';
        s+='-';
        if(t.month() < 10) s+='0'+t.month();
        else s+=t.month()+'';
        s+='-';
        s+=t.year();
        if(!savetime) return s;
        s+=' ';
        if(t.hour() < 10) s+='0'+t.hour()+':';
        else s+=t.hour()+':';
        if(t.minute() < 10) s+='0'+t.minute();
        else s+=t.minute();
        
        return s;
    }    
        
    public static void createFeedItemForGestione(String caseId){
        
        FeedItem post = new FeedItem();
        FeedItem post1 = new FeedItem();
        FeedItem post2 = new FeedItem();
        FeedItem post3 = new FeedItem();
        FeedItem post4 = new FeedItem();
        
        post.Title = '[TIMESTAMP]';
        post.Body = 'sent for authorization';
        post.ParentId = caseId;
        
        post1.Title = '[TIMESTAMP]';
        post1.Body = 'date authorized';
        post1.ParentId = caseId;
        
        post2.Title = '[TIMESTAMP]';
        post2.Body = 'date not authorized o rejected';
        post2.ParentId = caseId;
        
        post3.Title = '[TIMESTAMP]';
        post3.Body = 'assigned to account';
        post3.ParentId = caseId;
        
        post4.Title = '[TIMESTAMP]';
        post4.Body = 'assigned to queue';
        post4.ParentId = caseId;                
        
        insert post;
        insert post1;
        insert post2;
        insert post3;
        insert post4;
        
    }  
    
    public static void createFeedItemForChiusura(String caseId){
        
        FeedItem post = new FeedItem();
        FeedItem post1 = new FeedItem();
        FeedItem post2 = new FeedItem();
        
        post.Title = '[TIMESTAMP]';
        post.Body = 'printed';
        post.ParentId = caseId;
        
        post1.Title = '[TIMESTAMP]';
        post1.Body = 'complaint closed';
        post1.ParentId = caseId;
        
        post2.Title = '[TIMESTAMP]';
        post2.Body = 'send to IDM';
        post2.ParentId = caseId;        
        
        insert post;
        insert post1;
        insert post2;
        
        
    } 
    public static Case creaReclamo(XCSReclamiInput data, String societa, List<Attachment> fileList, Case reclamoSelezionato, String coda, String codCategoria, Boolean delegaPresente ){
		system.debug('---------------------------------------------------------------------------------------');
		system.debug('-- Class Name: XCSReclamiUtils - Method Name: creaReclamo'); 

        Case res = CaseUtils.makeReclamo();
        res = buildReclamo(res,data,societa,fileList,reclamoSelezionato);
        
        
        //Associazione cliente
        setCliente(res, data.clienteSelezionatoContainer);
        system.debug('@@@TIPO: '+data.dettagliOutputObj.headerOutput.tipoDettagli);
        String tipoReclamo = data.dettagliOutputObj.headerOutput.tipoDettagli;
        res.Tipo_Autorizzazione__c = setLivelloAutorizzazione(societa, tipoReclamo, coda, codCategoria, delegaPresente);
        if(societa == 'Compass'){
          
            System.debug(data);
            if(data.praticaSelezionataContainer != null){
            	Integer num_filiale = Integer.valueOf(data.praticaSelezionataContainer.filiale);
            	String filialeDN = 'F'+num_filiale ;
            	res.branch__c = [Select id from Account where OCS_External_id__c = :filialeDN].id;
            }
        }
        System.debug('******************************************************** insert reclamo = ' + res);
        insert res;
        
        //Allegati
        attachFiles(res.Id, fileList);
        
        //Associazione mittenti
        setMittenti(res.Id, data.mittentiList);
        
        return res;
    } 
/* 
    public static Case creaReclamo(XCSReclamiInput data, String societa, List<ContentDocument> fileList, Case reclamoSelezionato, String coda, String codCategoria, Boolean delegaPresente ){
		system.debug('---------------------------------------------------------------------------------------');
		system.debug('-- Class Name: XCSReclamiUtils - Method Name: creaReclamo'); 

        Case res = CaseUtils.makeReclamo();
        res = buildReclamo(res,data,societa,fileList,reclamoSelezionato);
        
        
        //Associazione cliente
        setCliente(res, data.clienteSelezionatoContainer);
        system.debug('@@@TIPO: '+data.dettagliOutputObj.headerOutput.tipoDettagli);
        String tipoReclamo = data.dettagliOutputObj.headerOutput.tipoDettagli;
        res.Tipo_Autorizzazione__c = setLivelloAutorizzazione(societa, tipoReclamo, coda, codCategoria, delegaPresente);
        System.debug('******************************************************** insert reclamo = ' + res);
        insert res;
        
        //Allegati
        attachFiles(res.Id, fileList);
        
        //Associazione mittenti
        setMittenti(res.Id, data.mittentiList);
        
        return res;
    }    
*/
    public static String setLivelloAutorizzazione(String societa, String tipoReclamo, String coda, String codCategoria, Boolean delegaPresente){

        Map<Integer,String> mapAutorization = new Map<Integer,String>();
        mapAutorization.put(0,'4132');//Nessuno
        mapAutorization.put(1,'4133');//1° livello
        mapAutorization.put(2,'4134');//2° livello

        String autorizzazione = mapAutorization.get(0);

        if(queue.contains(coda)){
            autorizzazione = mapAutorization.get(0);
        }else{
            autorizzazione = mapAutorization.get(1);
        }

        if(rule_autorita.contains(tipoReclamo)){
            autorizzazione = mapAutorization.get(2);

        }else if(rule_reclamo.contains(tipoReclamo)){

            if(String.isNotBlank(codCategoria)){
                if(getGrave(codCategoria,societa)){
                    autorizzazione = mapAutorization.get(2);//se è stata selezionata una categoria che ha l’attributo GRAVE 
                }
            }
            
        }else if(rule_ass_reclamo.contains(tipoReclamo)){
            if(!delegaPresente){
                autorizzazione = mapAutorization.get(0); //nel caso in cui è stato specificato NO nel campo DELEGA
            }
        }
        
        return autorizzazione;
                        
    } 


    public class CreateItemFeed implements Comparable{
        @AuraEnabled
        public String data;
        @AuraEnabled
        public String evento;
        @AuraEnabled
        public String utente;
        
        public CreateItemFeed(String data, String evento, String utente){
            
            this.data = data;
            this.evento = evento;
            this.utente = utente;
        }
        
        public CreateItemFeed(){}
        
        
        public Integer compareTo(Object obj){
            CreateItemFeed feed = (CreateItemFeed)obj;
            if(data <= feed.data) return 1;
            return -1;
        }
    } 

    public static boolean isGrave(String categ, String societa){
       List<categ_grave__mdt> listGrave = [SELECT Id, DeveloperName, MasterLabel, External_Id__c, Flag_Grave__c, Societa__c FROM categ_grave__mdt Where External_Id__c = :categ AND societa__c =:societa];
       return listGrave!=null && listGrave.size() >0 && listGrave[0].Flag_Grave__c;
    }

    //MS_ATTACHMENT **********************************************************************************
    public static ContentVersion createContentVersion(String name, Blob body){
        ContentVersion contentVersion = new ContentVersion();
        contentVersion.ContentLocation = 'S'; // S = Stored in Salesforce
        contentVersion.PathOnClient = name;
        contentVersion.Title = name;
        contentVersion.VersionData = body;//EncodingUtil.base64Encode(body);
        return contentVersion;
    }

    public static ContentDocumentLink createContentDocumentLink(Id contentDocumentId, Id parentId){
        ContentDocumentLink contentDocumentLink = new ContentDocumentLink();
        contentDocumentLink.ContentDocumentId = contentDocumentId;
        contentDocumentLink.LinkedEntityId = parentId;
        contentDocumentLink.ShareType = 'I'; // Inferred permission
        contentDocumentLink.Visibility = 'AllUsers';
        return contentDocumentLink;
    }
  
    
    public static  List<Id> createFile(List<Attachment> documentList, Id parentId){
        List<Id> listaId = new List<Id>();
        system.debug('@@@ createFile(List<ContentDocument> documentList, Id parentId)');
        system.debug('@@@ documentList: '+documentList);
        system.debug('@@@ Id parentId: '+parentId);

        if(!documentList.isEmpty()){
             
            List<ContentVersion> contentVersions = new List<ContentVersion>();

            for(Attachment attach : documentList){

                if(attach.Description==null){
                    system.debug('@@@ PROCESSED attach.Name: '+attach.Name);
                    system.debug('@@@ PROCESSED attach.Description: '+attach.Description);
                    //Insert ContentVersion
                    ContentVersion cVersion = new ContentVersion();
                    cVersion.ContentLocation = 'S'; //S-Document is in Salesforce. E-Document is outside of Salesforce. L-Document is on a Social Netork.
                    cVersion.PathOnClient = attach.Name;//File name with extention
                    //cVersion.Origin = 'H';//C-Content Origin. H-Chatter Origin.
                    cVersion.OwnerId = attach.OwnerId != null ? attach.OwnerId : UserInfo.getUserId();
                    System.debug(cVersion);//Owner of the file
                    cVersion.Title = attach.Name;//Name of the file
                    try{
                        system.debug('TRY');
                        cVersion.VersionData = EncodingUtil.base64Decode(attach.Body + '');//File content
                    }catch(Exception e){
                        system.debug('CATCH');
                        cVersion.VersionData = attach.Body;
                    }
                    contentVersions.add(cVersion);
                }
            }
            system.debug('@@@ SPZ BEFORE contentVersions: '+contentVersions);
            insert contentVersions;
            system.debug('@@@ SPZ AFTER contentVersions: '+contentVersions);
            //After saved the Content Verison, get the ContentDocumentId
            List<ContentVersion> conDocument = [SELECT ContentDocumentId FROM ContentVersion WHERE Id IN:contentVersions];
            
            List<ContentDocumentLink> contentDocumentLinks = new List<ContentDocumentLink>();
            
            for(ContentVersion cntVersion : conDocument){
                //Insert ContentDocumentLink
                ContentDocumentLink cDocLink = new ContentDocumentLink();
                cDocLink.ContentDocumentId = cntVersion.ContentDocumentId;//Add ContentDocumentId
                system.debug('@@@ SPZ cntVersion.ContentDocumentId: '+cntVersion.ContentDocumentId);
                cDocLink.LinkedEntityId = parentId;//Add attachment parentId
                cDocLink.ShareType = 'I';//V - Viewer permission. C - Collaborator permission. I - Inferred permission.
                cDocLink.Visibility = 'AllUsers';//AllUsers, InternalUsers, SharedUsers
                contentDocumentLinks.add(cDocLink);
                listaId.add(cntVersion.id); 
            }

            insert contentDocumentLinks;
          
           

        }
         return listaId;
    }

    public static List<Attachment> documentToAttachment(Id parentId){

        List<Attachment> attachList = new List<Attachment>();

        List<ContentDocumentLink> fileRetrieved = [
            SELECT ContentDocumentId,Id,IsDeleted,LinkedEntityId,ShareType,Visibility 
            FROM ContentDocumentLink
            WHERE LinkedEntityId =: parentId 
            //AND  ContentDocumentId IN: documentList
        ];
        system.debug('MS_ATTACHEMNT_XCSReclamiUtils fileRetrieved: '+fileRetrieved);

        if(!fileRetrieved.isEmpty()){
            List<Id> documentId = new List<Id>();
            for (ContentDocumentLink file : fileRetrieved) {
                if(!documentId.contains(file.ContentDocumentId)){
                    documentId.add(file.ContentDocumentId);
                }
            }
            system.debug('MS_ATTACHEMNT_XCSReclamiUtils documentId: '+documentId);        
        

            List<ContentVersion> lastVesrsion = [
                SELECT Id, Title, FileType, Description, VersionNumber, ContentDocumentId, VersionData, CreatedDate  
                FROM ContentVersion WHERE ContentDocumentId IN :documentId AND IsLatest = true
            ];
            system.debug('MS_ATTACHEMNT_XCSReclamiUtils lastVesrsion: '+lastVesrsion); 
            
            if(!lastVesrsion.isEmpty()){

                for(ContentVersion lv : lastVesrsion){
                    Attachment att = new Attachment();
                    //att.Id = lv.ContentDocumentId;
                    att.Body = lv.VersionData;
                    att.ContentType = lv.CreatedDate.format('dd-MM-yyyy HH:mm');
                    att.Description = String.valueOf(lv.ContentDocumentId) + '=' + getUrlForDownloadFile(lv.ContentDocumentId);
                    att.Name = lv.Title;
                    //att.CreatedDate = lv.CreatedDate;   
                    //att.Url = getUrlForDownloadFile(lv.ContentDocumentId);
                    att.ParentId = parentId;
                    
                    attachList.add(att);
                }   
            }

        }
        system.debug('MS_ATTACHEMNT_XCSReclamiUtils: '+attachList);
        return attachList;
    }

    @AuraEnabled
    public static String getUrlForDownloadFile(Id fileToDownloadId){
        ContentVersion fileToDownload = [SELECT Id,Title FROM ContentVersion WHERE ContentDocumentId=:fileToDownloadId AND IsLatest = true];
        System.Debug('Old LV INitial :'+ fileToDownload.Id);
        System.Debug('Old Lock :'+ fileToDownload.Title);
        String fullFileURL = URL.getSalesforceBaseUrl().toExternalForm();
        String URlDownload = fullFileURL+'/sfc/servlet.shepherd/version/download/'+fileToDownload.Id;
        System.Debug('URlDownload :'+ URlDownload);
        system.debug('Download URL:' +URlDownload);
        return URlDownload;
    }
    //MS_ATTACHMENT_END********************************************************************************

    //MS_MESSAGGIO*************************************************************************************
    @AuraEnabled
    public static void writeXCSMessaggio(Case c){

        if(c != null){
            
            List<Case> caseList = [SELECT AccountId,owner.name,Abbuono_Chiusura__c, Has_Risarcimento_accordato__c, Has_Rimborso_Accordato__c , createddate,Categoria_Riferimento__c, Account.OCS_External_Id__c, Note__c, NumeroPratica__c, Numero_Reclamo__c, Tipo_Pratica__c FROM Case WHERE Id =: c.Id]; 

            if(!caseList.isEmpty()){

                Case c1 = caseList.get(0);
                system.debug('writeXCSMessaggio c1: '+c1);
                String aliasUser =  [SELECT Alias FROM User WHERE Id=:UserInfo.getUserId()].Alias;
                Id rtype =  [SELECT Id FROM RecordType WHERE DeveloperName = 'Note' and SobjectType = 'XCS_Messaggio__c'].Id;

                XCS_Messaggio__c mex = new XCS_Messaggio__c();
                mex.Modalita__c = 'A';
                mex.TipoNote__c = 'P';
                mex.CodCliente__c = c1.AccountId!=null ? c1.Account.OCS_External_Id__c!=null ? c1.Account.OCS_External_Id__c : '' : '';
                mex.NumPratica__c = c1.NumeroPratica__c;
                mex.Numero__c = c1.Numero_Reclamo__c;
                mex.TipoPratica__c = c1.Tipo_Pratica__c;
               
                XCS_Categoria__c categoriaObj = [Select id, name, livello__c, 
                                                        parent__r.id,  parent__r.Name,parent__r.livello__c from XCS_Categoria__c where id=:c1.Categoria_Riferimento__c ];
                  //Inserisco foglia
                String categoria= categoriaObj.name;
                while(true){
                     categoriaObj = [Select id, name, livello__c, parent__r.id,  parent__r.Name,parent__r.livello__c from XCS_Categoria__c where id=:categoriaObj.parent__c];
                    if(categoriaObj.Livello__c !=0) categoria = categoriaObj.name + ' - '+categoria;
                    else break;
                    
                }
    
                String rimborso = c1.Has_Rimborso_Accordato__c  ? 'SI' : 'NO';
                String abbuono =  c1.Abbuono_Chiusura__c ? 'SI' : 'NO';
                String risarcimento = c1.Has_Risarcimento_accordato__c  ? 'SI' : 'NO';
                mex.Testo__c = 'Chiuso reclamo '+c1.numero_reclamo__c+' richiesta CRM '+c1.createddate.format('aaaaMMdd')+' categoria '+categoria+' in gestione a '
                    +c1.Owner.Name+' (Abbuono : '+abbuono+', Rimborso : '+rimborso+' risarcimento : '+risarcimento+')' ;
                
                mex.Utente__c = aliasUser;
                mex.RecordTypeId = rtype;
                system.debug('writeXCSMessaggio mex: '+mex);
                insert mex;
            }
        }
    }	
    //MS_MESSAGGIO_END********************************************************************************
    
    //MS_CORRISPONDENZA*******************************************************************************
    @AuraEnabled
    public static void creaCorrispondenza(Case c, String testo, List<String> documentList){   
              
        if(c == null || !(String.isNotBlank(testo))) return;
        //Creo Feed
        System.debug('*********' + testo);
        ContentNote nota = new ContentNote();
        nota.Title = 'Corrispondenza';
        nota.Content = Blob.valueOf(testo.escapeXML());
        insert nota;
        
        System.debug('*************Nota : ' + nota);
        
        ContentDocumentLink link_Case_Nota =new ContentDocumentLink();
        
        link_Case_Nota.ContentDocumentId = nota.id;
        link_Case_Nota.LinkedEntityId = c.Id;
        link_Case_Nota.ShareType = 'I'; 
        link_Case_Nota.Visibility = 'AllUsers';
        
        insert link_Case_Nota;
        
        System.debug('*************DocumentLink : ' + link_Case_Nota);
        
        List<String> documentIdList = new List<String>();
        
        if(documentList != null && !documentList.isEmpty()){
            
            List<ContentDocumentLink> linkList_Nota_Att = new List<ContentDocumentLink>();
            
            List<ContentVersion> lastVesrsion = [
                SELECT Id, Title, FileType, Description, VersionNumber, PathOnClient, ContentDocumentId, VersionData, CreatedDate  
                FROM ContentVersion WHERE id IN :documentList AND IsLatest = true
            ];
            SYstem.debug('+++++' + lastVesrsion );
            system.debug('#####' + documentList);
            
            if(!lastVesrsion.isEmpty()){
                List<ContentVersion> newlastVesrsion = new List<ContentVersion>();
                //inserisco l'id della nota nella description del content version
                for(ContentVersion lv : lastVesrsion){
                    ContentVersion cVersion = new ContentVersion();
                    cVersion = lv.clone();
                    cVersion.PathOnClient = lv.PathOnClient;
                    cVersion.Description = nota.id;
                    newlastVesrsion.add(cVersion);
                    
                }
                //update lastVesrsion;
                System.debug('@#@#@#@#@#' + newlastVesrsion);
                insert newlastVesrsion;
                system.debug('MS_CORRISPONDENZA newlastVesrsion: '+newlastVesrsion); 
            }
            
        }
    }
    @AuraEnabled
    public static void creaCorrispondenza(Case c, String testo, List<Attachment> documentList){
                
        if(c == null || !(String.isNotBlank(testo))) return;
        //Creo Feed
        System.debug('*********' + testo);
        ContentNote nota = new ContentNote();
        nota.Title = 'Corrispondenza';
        nota.Content = Blob.valueOf(testo.escapeXML());
        insert nota;
        
        System.debug('*************Nota : ' + nota);
        
        ContentDocumentLink link_Case_Nota =new ContentDocumentLink();
        
        link_Case_Nota.ContentDocumentId = nota.id;
        link_Case_Nota.LinkedEntityId = c.Id;
        link_Case_Nota.ShareType = 'I'; 
        link_Case_Nota.Visibility = 'AllUsers';
        
        insert link_Case_Nota;
        
        System.debug('*************DocumentLink : ' + link_Case_Nota);
        
        List<String> documentIdList = new List<String>();
        
        if(documentList != null && !documentList.isEmpty()){
            
            List<ContentDocumentLink> linkList_Nota_Att = new List<ContentDocumentLink>();
            
            for(Attachment attach : documentList){
                
                if(attach.Description != null){
                    String documentId = attach.Description.split('=').get(0);
                    if(!documentIdList.contains(documentId)){
                        documentIdList.add(documentId);             
                    }
                }
            }
            
            List<ContentVersion> lastVesrsion = [
                SELECT Id, Title, FileType, Description, VersionNumber, PathOnClient, ContentDocumentId, VersionData, CreatedDate  
                FROM ContentVersion WHERE ContentDocumentId IN :documentIdList AND IsLatest = true
            ];
            
            if(!lastVesrsion.isEmpty()){
                List<ContentVersion> newlastVesrsion = new List<ContentVersion>();
                //inserisco l'id della nota nella description del content version
                for(ContentVersion lv : lastVesrsion){
                    ContentVersion cVersion = new ContentVersion();
                    cVersion = lv.clone();
                    cVersion.PathOnClient = lv.PathOnClient;
                    cVersion.Description = nota.id;
                    newlastVesrsion.add(cVersion);
                    
                }
                //update lastVesrsion;
                insert newlastVesrsion;
                system.debug('MS_CORRISPONDENZA newlastVesrsion: '+newlastVesrsion); 
            }
            
        }
        
    }
    //MS_CORRISPONDENZA_END****************************************************************************
    
    
    public static void sendEmailDebug(String testo){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'boris90@live.it'};
            mail.setToAddresses(toAddresses);
        mail.setSubject('Debug');
        mail.setPlainTextBody(testo);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
        
        
    }
    
    
    
    public class Corrispondenza{
        public Case c {get;set;}
        public String testo {get;set;}
        public List<String> allegati {get;set;} //Setto gli Id
        
        public Corrispondenza(Case c, String testo, List<String> allegati){
            this.c = c;
            this.testo = testo;
            this.allegati = allegati;
        }
    }
    
    
    //MS_READONLY**************************************************************************************
    @AuraEnabled
    public static Boolean isReclamoReadOnly(Id caseId){
        if(caseId!=null){
            Case c = [SELECT Id, Status, OwnerId FROM Case WHERE Id =:caseId];
         Id currUserId = UserInfo.getUserId();
            List<User> userGroupList = takeUsersFromQueue(c.OwnerId);
            if(!userGroupList.isEmpty()){
                Profile p = [Select id, name from profile Where id=:userInfo.getProfileId()];
                if(p.name.contains('Manager') && c.Status == 'Gestito'){
                    for(User usr : userGroupList){
                        if(usr.Id == currUserId){
                            return false; //il reclamo chiuso può essere modificato dai manager di quella coda
                        } 
                    }
                } 
                else if(p.name.equals('System Administrator')) return false; //il reclamo può essere modificato
                
                for(User usr : userGroupList){
                    if(usr.Id == currUserId){
                        return false; //il reclamo può essere modificato
                    } 
                }
            }
        }
        return true; //il reclamo è readOnly, non può essere modificato dall'utente  
    }
    
    @AuraEnabled
    public static List<User> takeUsersFromQueue(Id codaId){
        system.debug('takeUsersFromQueue: '+ codaId);
        
        List<User> lUser = new List<User>();
        
        List<GroupMember> lGM = [SELECT UserOrGroupId FROM GroupMember WHERE GroupId = :codaId];
        System.debug('lGM -> ' + lGM);
        List<Id> lGroup = new List<Id>();
        List<Id> lGroup2 = new List<Id>();
        
        if(lGM.size()>0){
            for(GroupMember gm : lGM){
                if(!lGroup.contains(gm.UserOrGroupId)){
                    lGroup.add(gm.UserOrGroupId);
                }
            }
            if(lGroup.size()>0){
                List<Group> groupRElated = [SELECT RelatedId FROM Group where id IN:lGroup];
                
                if(groupRElated.size()>0){
                    for(Group g : groupRElated){
                        if(!lGroup2.contains(g.RelatedId)){
                            lGroup2.add(g.RelatedId);
                        }
                    }
                    lUser = [SELECT Id, Name FROM User WHERE UserRoleId IN :lGroup2 ORDER BY Name ASC NULLS FIRST];
                }
            }
            
        }
        System.debug('lUser -> ' + lUser);
        return lUser;
    }
    //MS_READONLY_END**********************************************************************************
}