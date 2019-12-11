public class SinistriAssicurativiCtrl {
    
    /*
///////////////////////////////////
Sezione Lightning component
///////////////////////////////////
*/  
    
 
    private static String STATO_RICEVUTO = 'Ricevuto';
    private static String STATO_SOSPESO = 'Sospeso';
    private static String STATO_CHIUSO = 'Chiuso';   
    public final static String CATEGORIA_CASE_SINISTRO = '2234';   
    public final static String RECORD_TYPE_CASE_SINISTRI = 'CRM_Sinistri_Assicurativi';   

    @AuraEnabled
    public static Boolean isAlico(){
        Profile profilo = [Select id, name from Profile Where id = :UserInfo.getProfileId()];
        UserRole ruolo = [SELECT Id, DeveloperName FROM UserRole Where id = :UserInfo.getUserRoleId()];
        return profilo.name == 'Alico' || ruolo.DeveloperName == 'Alico';
    }
    
    @AuraEnabled
    public static String createRecordForUploadFile(){
        List<Sinistro_assicurativo__c> lista = [Select id from Sinistro_Assicurativo__c Where hasattachment__c = false and recordtype.developerName = 'crma_sinistri_chiusi_xls'];
        if(lista != null && lista.size() > 0)    return lista[0].id;
        RecordType rt = [Select id from RecordType where DeveloperName = 'crma_sinistri_chiusi_xls'];
        RecordType rt_case = [Select id from RecordType where SobjectType = 'Case' AND DeveloperName =: RECORD_TYPE_CASE_SINISTRI];

        Case caseSx = new Case();         
     	caseSx.Description='Sinistro Assicurativo';
    	caseSx.Categoria_Riferimento__c = [Select id, name from XCS_Categoria__c where External_Id__c =:CATEGORIA_CASE_SINISTRO ].id;
        caseSx.RecordTypeId = rt_case.id;


        insert caseSx;    

        Sinistro_assicurativo__c sx = new Sinistro_Assicurativo__c();
        sx.RecordTypeId =rt.id; 
        sx.hasattachment__c= false;
        sx.isRead__c = false;
        sx.CaseId__c = caseSx.Id;
        insert sx;

        return sx.id;
        
    }
    
    @AuraEnabled
    public static String finishUploadFile(String recordId, String documentId){  
        
        ContentVersion cv = [select id from contentversion where contentdocumentid = :documentId];
        ContentDistribution cd = new ContentDistribution();
        cd.Name = 'File ';
        cd.ContentVersionId = cv.id;
        cd.PreferencesAllowViewInBrowser= true;
        cd.PreferencesLinkLatestVersion=true;
        cd.PreferencesNotifyOnVisit=false;
        cd.PreferencesPasswordRequired=false;
        cd.PreferencesAllowOriginalDownload= true;
        insert cd;
        
        Sinistro_assicurativo__c sx = new Sinistro_Assicurativo__c();
        sx.id = recordId;
        sx.hasattachment__c= true;
        sx.ContentDistribution__c = cd.id;
        update sx; 
        
        
        return createRecordForUploadFile();
        
    }
    
    @AuraEnabled
    public static String recuperaAnagraficaWS(String nome, String cognome, String dataNascita, String codiceFiscale, String numeroPratica,
                                              String codiceCliente, String ragioneSociale, String pan)
    {
        if(dataNascita!=null && dataNascita.length() > 0){
            List<String> data = dataNascita.split('-');
              dataNascita = data[0]+''+data[1]+''+data[2]; 
        }
        System.debug('#### data nascita '+dataNascita);
        OCSRecuperaPraticheAssicurateResponse response = OCSRecuperaPraticheAssicurateInvoker.callRecuperaPraticheAssicurate(numeroPratica, codiceCliente, cognome,  nome,codiceFiscale, dataNascita,ragioneSociale, pan);
        
        OCSRecuperaPraticheAssicurateResponse.init(response.elencoPratiche);
        
        return JSON.serialize(response.elencoPratiche);                                       
    }
    
    public class ResponseException extends Exception{} 
    
    
    
    
    @AuraEnabled
    public static Integer inserisciSinistroWS(String assicurazione, String numPratica, String tipoPratica, String dataSinistro,
                                              String tipoSinistro, String cognome, String nome, String note, String dataNascita, String luogoNascita, String cf, 
                                              String noteAss, String dataInizioCopertura, String dataFineCopertura)
    {
        
        
        List<String> listaData = dataSinistro.split('-');
        
        Date dataSx = Date.newInstance(Integer.valueof(listaData[0]), Integer.valueof(listaData[1]), Integer.valueof(listaData[2]));
        if(dataSx > System.today()) return 2;
        List<Sinistro_Assicurativo__c> lista = [Select id From Sinistro_Assicurativo__c Where Data_Sinistro__c =:dataSx AND Tipologia_Sinistro__c =:tipoSinistro  AND CaseId__c IN (SELECT ID FROM Case WHERE NumeroPratica__c =:numPratica)];
        if(lista.size() > 0) return 1;
        String flagReadOnly = 'N'; 
        
        if(dataSinistro!=null && dataSinistro.length() > 0){
            List<String> data = dataSinistro.split('-');
            dataSinistro = data[2]+''+data[1]+''+data[0];
        }
        
        
        
        Sinistro_Assicurativo__c sx = new Sinistro_Assicurativo__c();
        System.debug(dataInizioCopertura);
        
        if(String.isNotBlank(dataInizioCopertura)){
            sx.Data_Inizio_Copertura__c =  Date.newInstance(Integer.valueof(dataInizioCopertura.split('-')[2]), Integer.valueof(dataInizioCopertura.split('-')[1]), Integer.valueof(dataInizioCopertura.split('-')[0]));
        }else{
            sx.Data_Inizio_Copertura__c =null;
        }
        if(String.isNotBlank(dataFineCopertura)){
            sx.Data_Fine_Copertura__c = Date.newInstance(Integer.valueof(dataFineCopertura.split('-')[2]), Integer.valueof(dataFineCopertura.split('-')[1]), Integer.valueof(dataFineCopertura.split('-')[0]));
        }else{
            sx.Data_Fine_Copertura__c  = null;
        }
        sx.Note_Assicurazione__c = noteAss;
        sx.Assicurazione__c = assicurazione;
        sx.Data_Apertura__c = System.today();
        sx.Coda__c = '84';
        sx.Flag_err__c= false;
        sx.Data_Sinistro__c = dataSx;
        sx.Tipologia_Sinistro__c= tipoSinistro;
        
        sx.Note__c = note;
   
        RecordType rt_case = [Select id from RecordType where SobjectType = 'Case' AND DeveloperName =: RECORD_TYPE_CASE_SINISTRI];
        Case caseSx = new Case();         
     	caseSx.Description='Sinistro Assicurativo';
        caseSx.subject='Sinistro Assicurativo';
    	caseSx.Categoria_Riferimento__c = [Select id, name from XCS_Categoria__c where External_Id__c =:CATEGORIA_CASE_SINISTRO ].id;
       	caseSx.NumeroPratica__c = numPratica;
        caseSx.RecordTypeId = rt_case.id;
       	caseSx.Tipo_Pratica__c = tipoPratica;
        
        //Inserimento Anagrafica
        Account aggiornato = new Account();
        aggiornato.Data_Nascita__c = null;
        if(aggiornato.Data_Nascita__c != null) aggiornato.Data_Nascita__c = Date.newInstance(Integer.valueof(dataNascita.split('-')[2]), Integer.valueof(dataNascita.split('-')[1]), Integer.valueof(dataNascita.split('-')[0]));
        aggiornato.FirstName = nome;
        aggiornato.LastName = cognome;
        aggiornato.Codice_Fiscale__pc = cf;
        aggiornato.Luogo_Nascita__pc = luogoNascita;        
        
        OCSAperturaSinistroResponse response;
        response= OCSAperturaSinistroInvoker.callApeSinistro('ALICO', numPratica, tipoPratica, dataSinistro, tipoSinistro, cognome, nome,flagReadOnly);
        if(!response.resultMessage.contains('Error')){
            
            caseSx.Status=STATO_RICEVUTO; // Ricevuto
            sx.Compagnia__c = response.datiAperturaSinistroResponse.compagnia;
            sx.Luogo_Elaborazione__c = response.datiAperturaSinistroResponse.luogoElab;
            sx.Data_Elaborazione__c = convertStringToDate(response.datiAperturaSinistroResponse.dataElab,'\\.');
            sx.Polizza__c = response.datiAperturaSinistroResponse.polizza;
            //caseSx.Nominativo_Assicurato__c = response.datiAperturaSinistroResponse.nominativoAssicurato;
            sx.Data_Sinistro__c = convertStringToDate(response.datiAperturaSinistroResponse.dataSinistro,'\\.');
            sx.Importo_Indennizzato__c = response.datiAperturaSinistroResponse.saldoResiduo;
            sx.Rata__c = response.datiAperturaSinistroResponse.rata;
            sx.Decorrenza__c = convertStringToDate(response.datiAperturaSinistroResponse.dataPrimoUtilizzo,'\\.');
            sx.Contraente__c = response.datiAperturaSinistroResponse.contraente;
            caseSx.PAN__c =  response.datiAperturaSinistroResponse.pan;
            sx.Piano_Ammortamento__c = response.datiAperturaSinistroResponse.pianoAmmortamento;  
            List<OCSAperturaSinistroResponse.AperturaSinistroScarto> scartoList = response.datiAperturaSinistroResponse.scarti;
            System.debug('############  list response  '+scartoList);
            if(scartoList != null && scartoList.size()>0  ){
                OCSAperturaSinistroResponse.AperturaSinistroScarto scarto = scartoList[0];
                sx.Anomalia__c = scarto.desScarto;
                sx.Data_Sinistro__c = convertStringToDate2(scarto.dataSinistro);
                caseSx.Status=STATO_SOSPESO;
            }
            sx.Luogo_Elaborazione__c = response.datiAperturaSinistroResponse.luogoElab;
            sx.Data_Elaborazione__c = convertStringToDate(response.datiAperturaSinistroResponse.dataElab,'\\.');
            
            if(String.isNotBlank(response.datiAperturaSinistroResponse.codCliente ))aggiornato.OCS_External_id__c  = 'C'+response.datiAperturaSinistroResponse.codCliente;
        }
  		else  caseSx.Status=STATO_SOSPESO;
        
        System.debug(caseSx.Status);
        
        Map<Account, Account> mappa = new Map<Account, Account>();
        System.debug('Stampo prima di inserirlo in map');
        System.debug(aggiornato);
        mappa.put(aggiornato, null);
        XCSGestioneAnagrafica.deduplica(mappa, true);
      
        System.debug('stampo chiave');
        System.debug(aggiornato);
        //aggiornato= mappa.get(aggiornato);
        System.debug('stampo valore');
        System.debug(mappa.get(aggiornato));
        
        Id account = aggiornato.id !=null ? aggiornato.id : mappa.get(aggiornato).id;
        caseSx.AccountId = account;
              
        // inserimento Case
        insert caseSx;  
 
        sx.CaseId__c = caseSx.Id;
        insert sx;
        
        if(caseSx.Tipo_Pratica__c == 'CO' && (sx.assicurazione__c == 'AIGR1' || sx.assicurazione__c == 'AIGR2' ||
                                          sx.assicurazione__c == 'AIGR3' || sx.assicurazione__c == 'AIGR4') && sx.Tipologia_Sinistro__c == 'DC')
        {
            
            PV5864RESRecessoServiziInserimento.PV5864RESRecessoServiziForm datiForm = new PV5864RESRecessoServiziInserimento.PV5864RESRecessoServiziForm();
            datiForm = (PV5864RESRecessoServiziInserimento.PV5864RESRecessoServiziForm) PV5864RESRecessoServiziInserimento.prepareFormExternal(datiForm, '5864', null);
            datiForm.cliente = new OCSCliente();
            //datiForm.cliente.email = 'POSTVENDITA@EMAIL.TEST';
            datiForm.cliente.codCliente =  aggiornato.Codice_Cliente__c;
            datiForm.cliente.cognome = aggiornato.LastName;
            datiForm.cliente.nome = aggiornato.FirstName;
            datiForm.cliente.denominazioneAzienda = aggiornato.FirstName+' '+aggiornato.LastName;
            String dataN = '';
            if(aggiornato.Data_Nascita__c!=null) {
                dataN = aggiornato.Data_Nascita__c.year()+''+aggiornato.Data_Nascita__c.month()+''+aggiornato.Data_Nascita__c.day();
            }
            datiForm.cliente.dataNascita = dataN;
            datiForm.categoriaPV = [Select id From XCS_Categoria__c Where external_id__c  = '5864'];
            PV5864RESRecessoServiziInserimento.conferma(datiForm);
        }
        
        return 0; 
    }
    
    public static Date convertStringToDate(String data, String separator){
        if(data == null || data.length() ==0) return null;
        List<String> dataList = data.split(separator);
        return Date.newInstance(Integer.valueOf(dataList[2]), Integer.valueOf(dataList[1]), Integer.valueOf(dataList[0]));
    }
    
    public static Date convertStringToDate2(String data){
        if(data == null || data.length() ==0) return null;
        String giorno = data.length() >7 ? data.substring(0,2) : data.substring(0,1);
        String mese = data.length() >7 ? data.substring(2,4) : data.substring(1,3);
        String anno = data.length() >7 ? data.substring(4,8) : data.substring(3,7);
        System.debug(data);
        System.debug('Giorno '+giorno+'/'+mese+'/'+anno);
        return Date.newInstance(Integer.valueOf(anno), Integer.valueOf(mese), Integer.valueOf(giorno));
    }
    
    @AuraEnabled
    public static String ricerca(String stato, Integer pratica){ 
        
        system.debug('stato - pratica '+stato+' - '+pratica);
        String flagStato='';
        Switch on stato {
            when 'all'{
                System.debug('all');
                flagStato='';
                
            }
            when 'openLast15'{
                flagStato=' and CaseId__r.Status in (\''+STATO_SOSPESO+'\',\''+STATO_RICEVUTO+'\') and Data_Apertura__c  = LAST_N_DAYS:15 ';
                System.debug('openLast15');
            }
            when 'closedLast15'{
                flagStato=' and CaseId__r.Status in (\''+STATO_CHIUSO+'\') and Data_Apertura__c  = LAST_N_DAYS:15 ';
                System.debug('closedLast15');
            }
            when 'openClosedLast15'{
                flagStato=' and CaseId__r.Status in (\''+STATO_CHIUSO+'\',\''+STATO_RICEVUTO+'\',\''+STATO_SOSPESO+'\') and Data_Apertura__c  = LAST_N_DAYS:15 ';
                System.debug('closedLast15');
            }
            when 'allOpen'{
                flagStato=' and CaseId__r.Status in (\''+STATO_RICEVUTO+'\',\''+STATO_SOSPESO+'\') ';
                System.debug('allOpen');
            }
            when 'allClosed'{
                flagStato=' and CaseId__r.Status in (\''+STATO_CHIUSO+'\')' ;
                System.debug('allClosed');
            }
            when else{
                System.debug('default operation');
            }
        } 
        
        String empty='';
        String whereCondPratica = (String.valueOf(pratica).equals('-1'))?'':' and CaseId__r.NumeroPratica__c= \''+String.valueOf(pratica)+'\'';
        String query = 'SELECT Id,Data_Apertura__c, CaseId__r.NumeroPratica__c, CaseId__r.Tipo_Pratica__c, Data_Sinistro__c, Tipologia_Sinistro__c, CaseId__r.Status, Esito__c, CaseId__r.AccountId,  Anomalia__c  FROM Sinistro_Assicurativo__c where ((CaseId__r.AccountId != null and CaseId__r.NumeroPratica__c !=null and CaseId__r.Tipo_Pratica__c != null and Data_Sinistro__c!=null and Tipologia_Sinistro__c!=null and CaseId__r.Status!=null) OR (Anomalia__c !=null) ) '+whereCondPratica+flagStato+ ' Order By Data_Apertura__c ,Createddate desc limit 1000';
        // query += ' limit 100';
        System.debug(query);
        List<Sinistro> sinistri = new List<Sinistro>(); 
        List<Sinistro_Assicurativo__c> sinistriAssicurativiList = Database.query(query);
        
        if(sinistriAssicurativiList==null || sinistriAssicurativiList.size() == 0) return JSON.serialize(sinistriAssicurativiList);
        for(Sinistro_Assicurativo__c c: sinistriAssicurativiList){
            System.debug(c);
                if(c.CaseId__r.Status == null)c.CaseId__r.Status='';
            else if(c.CaseId__r.Status.equals(STATO_RICEVUTO))c.CaseId__r.Status = 'Aperto';
            else if(c.CaseId__r.Status.equals(STATO_SOSPESO))c.CaseId__r.Status = 'Apertura in Corso';
            String nameAccount = null;
            if (!String.isBlank(c.CaseId__r.AccountId)) {
              	Account accSinistro = [SELECT Name From Account WHERE ID=:c.CaseId__r.AccountId];
                nameAccount = accSinistro.Name;
            }
            
            sinistri.add(new Sinistro(c.Id,nameAccount,c.CaseId__r.NumeroPratica__c,c.CaseId__r.Tipo_Pratica__c,  ((c.Data_Sinistro__c!=null)?c.Data_Sinistro__c.format():null), c.Tipologia_Sinistro__c,c.CaseId__r.Status,c.Esito__c,c.Anomalia__c,c.Data_Apertura__c));
        }
        sinistri.sort();
        System.debug('#####   list elenco sinistri '+sinistri);
        
        return JSON.serialize(sinistri);
    }
    
    
    
    
    
    
///////////////////////////////////
//Sezione REPORT - Pagine Visualforce
///////////////////////////////////
    
    public String title{public get;set;}
    public String body{public get;set;}
    public String titlePreconvalida{public get;set;}
    public String subject{public get;set;}
    public String datePreconvalida{public get;set;}
    public String contractNumber{public get;set;}
    public String tipo{public get;set;}
    public String dateAssicurato{public get;set;}
    public String  importo{public get;set;}
    public String  cliente{public get;set;}
    public String  polizza{public get;set;}
    public String  decorrenza{public get;set;}
    public String  rata{public get;set;}
    public Blob b{get;set;}
    public String saldoResiduo{public get;set;}
    public String tipoPr{public get;set;}
    
    public String idDocumento{get;set;}
    public String idOrganizzazione{get;set;}
    public String ultimaMod{get;set;}
    
    public SinistriAssicurativiCtrl(){
        String parDisp = ApexPages.currentPage().getParameters().get('parDisp');
        Switch on parDisp {
            
            when 'E'{
                getElencoSinistri();
            }
            when 'L'{
                Id id = ApexPages.currentPage().getParameters().get('id');
                getLetteraPreconvalida(id);
            }
            when 'A'{
                Id id = ApexPages.currentPage().getParameters().get('id');
                getPianoAmmortamentoEC(id);
            }
            
        }
    }
    public void getElencoSinistri(){
        String stato = ApexPages.currentPage().getParameters().get('stato');
        String pratica = ApexPages.currentPage().getParameters().get('pratica');
        system.debug('valori query string '+stato+' - '+pratica);
        
        String flagStato='';
        Switch on stato {
            when 'all'{
                System.debug('all');
                flagStato='';
                
            }
            when 'openLast15'{
                flagStato=' and CaseId__r.Status in (\''+STATO_SOSPESO+'\',\''+STATO_RICEVUTO+'\') and CreatedDate = LAST_N_DAYS:15 ';
                System.debug('openLast15');
            }
            when 'closedLast15'{
                flagStato=' and CaseId__r.Status in (\''+STATO_CHIUSO+'\') and CreatedDate = LAST_N_DAYS:15 ';
                System.debug('closedLast15');
            }
            when 'openClosedLast15'{
                flagStato=' and CaseId__r.Status in (\''+STATO_CHIUSO+'\',\''+STATO_RICEVUTO+'\',\''+STATO_SOSPESO+'\') and CreatedDate = LAST_N_DAYS:15 ';
                System.debug('closedLast15');
            }
            when 'allOpen'{
                flagStato=' and CaseId__r.Status in (\''+STATO_SOSPESO+'\',\''+STATO_RICEVUTO+'\') ';
                System.debug('allOpen');
            }
            when 'allClosed'{
                flagStato=' and CaseId__r.Status in (\''+STATO_CHIUSO+'\')' ;
                System.debug('allClosed');
            }
            when else{
                System.debug('default operation');
            }
        } 
        
        body = '<table style=" text-align: center; border: 1px solid #000;">';
        List<Sinistro> elenco = new List<Sinistro>(); 
        
        String empty ='';
        String whereCondPratica = (String.valueOf(pratica).equals('-1'))?'':' and CaseId__r.NumeroPratica__c= \''+String.valueOf(pratica)+'\'';
        String query = 'SELECT Id,Data_Apertura__c, CaseId__r.NumeroPratica__c,CaseId__r.Tipo_Pratica__c, Data_Sinistro__c, Tipologia_Sinistro__c, CaseId__r.Status, Esito__c, Anomalia__c,CaseId__r.AccountId  FROM Sinistro_Assicurativo__c where ((CaseId__r.AccountId != null and CaseId__r.NumeroPratica__c !=null and CaseId__r.Tipo_Pratica__c != null and Data_Sinistro__c!=null and Tipologia_Sinistro__c!=null and CaseId__r.Status!=null) OR (Anomalia__c !=null) ) '+whereCondPratica+flagStato+ ' Order By Data_Apertura__c ,Createddate desc limit 1000';
        
        List<Sinistro_Assicurativo__c> sinistriAssicurativiList = Database.query(query);
        
        for(Sinistro_Assicurativo__c c: sinistriAssicurativiList){
            if(c.CaseId__r.Status == null)c.CaseId__r.Status='';
            else if(c.CaseId__r.Status.equals(STATO_RICEVUTO))c.CaseId__r.Status = 'Aperto';
            else if(c.CaseId__r.Status.equals(STATO_SOSPESO))c.CaseId__r.Status = 'Apertura in Corso';
            
        	String nameAccount = null;
            if (!String.isBlank(c.CaseId__r.AccountId)) {
              	Account accSinistro = [SELECT Name From Account WHERE ID=:c.CaseId__r.AccountId];
                nameAccount = accSinistro.Name;
            }
            
            elenco.add(new Sinistro(c.Id, nameAccount,c.CaseId__r.NumeroPratica__c,c.CaseId__r.Tipo_Pratica__c,   ((c.Data_Sinistro__c!=null)?c.Data_Sinistro__c.format():null), c.Tipologia_Sinistro__c, c.CaseId__r.Status,c.Esito__c,c.Anomalia__c,c.Data_Apertura__c));
        }
        
        //Titolo
        title = 'Elenco_sinistri_CU';//+codice+'_'+dataAttuale;// System.now fornisce data e ora attuali
        
        //Colonna Intestazione
        Sinistro header = new SinistroHeader('','Nominativo','Numero pratica','Tipo pratica', 'Data sinistro', 'Tipo Sinistro','Stato Sinistro', 'Esito', 'Anomalie',null);
        
        if(elenco.size()>0){
            elenco.sort();
            elenco.add(0, header);
        }
        else elenco.add(header);
        
        for(Sinistro s : elenco) body+=s.toString();
        
        body += '</table>';
        
    } 
    
    public void getLetteraPreconvalida(Id idSalesforce){
        System.debug(' getLetteraPreconvalida id pass from controller '+idSalesforce);
        String query = 'SELECT Id,Luogo_Elaborazione__c, CaseId__r.AccountId , CaseId__r.Description, Saldo_Residuo__c,Rata__c,Decorrenza__c,Polizza__c,Importo_Indennizzato__c,Data_Elaborazione__c,Data_Inizio_Copertura__c, CaseId__r.NumeroPratica__c, CaseId__r.Tipo_Pratica__c, Data_Sinistro__c, Tipologia_Sinistro__c,CaseId__r.Status, Esito__c, Anomalia__c  FROM Sinistro_Assicurativo__c where Id = :idSalesforce';
        Sinistro_Assicurativo__c sinistriAssicurativo = Database.query(query);
        
        idDocumento = [Select id, LastModifiedDate  From Document Where developerName = 'Compass_Logo'].Id;
        idorganizzazione = UserInfo.getOrganizationId();
        
        titlePreconvalida= 'lettera_preconvalida_'+Datetime.now();
        subject =sinistriAssicurativo.CaseId__r.Description;
        datePreconvalida = sinistriAssicurativo.Luogo_Elaborazione__c+' '+((sinistriAssicurativo.Data_Elaborazione__c!=null)?sinistriAssicurativo.Data_Elaborazione__c.format():'');
        contractNumber=sinistriAssicurativo.CaseId__r.NumeroPratica__c ;
        tipo=sinistriAssicurativo.Tipologia_Sinistro__c;
        tipoPr = sinistriAssicurativo.CaseId__r.Tipo_Pratica__c;
        dateAssicurato=(sinistriAssicurativo.Data_Inizio_Copertura__c!=null)?sinistriAssicurativo.Data_Inizio_Copertura__c.format():'';
        importo=sinistriAssicurativo.Importo_Indennizzato__c;
        String nameAccount = '';
        if (!String.isEmpty(sinistriAssicurativo.CaseId__r.AccountId)) {
        	Account accSinistro = [SELECT Name From Account WHERE ID=:sinistriAssicurativo.CaseId__r.AccountId];
        	nameAccount = accSinistro.Name;    
        }
        cliente=nameAccount;
        
        polizza=sinistriAssicurativo.Polizza__c;
        decorrenza=(sinistriAssicurativo.Decorrenza__c!=null)?sinistriAssicurativo.Decorrenza__c.format():'';
        rata=sinistriAssicurativo.Rata__c;
        saldoResiduo=sinistriAssicurativo.Saldo_Residuo__c;
    }  
    
    public void getPianoAmmortamentoEC(Id idSalesforce){
        String query = 'SELECT Id,Piano_Ammortamento__c ,Data_Inizio_Copertura__c, CaseId__r.NumeroPratica__c, Data_Sinistro__c, Esito__c, Anomalia__c  FROM Sinistro_Assicurativo__c where Id = :idSalesforce';
        Sinistro_Assicurativo__c sinistriAssicurativo = Database.query(query);
        if(sinistriAssicurativo!=null && sinistriAssicurativo.Piano_Ammortamento__c!=null){
            sinistriAssicurativo.Piano_Ammortamento__c = sinistriAssicurativo.Piano_Ammortamento__c.replace('&#124;','|');
        
            sinistriAssicurativo.Piano_Ammortamento__c = sinistriAssicurativo.Piano_Ammortamento__c.replace('\\r\\n',' ');
        }else{
            sinistriAssicurativo.Piano_Ammortamento__c = '';
        }
        
        
        this.title = 'Piano_Ammortamento';
        body=sinistriAssicurativo.Piano_Ammortamento__c;
        
    }  
    
    public virtual class Sinistro implements Comparable{
        
        String id,nominativo, numeroPratica, tipoPratica, dataSinistro, tipoSinistro, statoSinistro, esito, anomalie;
        Date dataApertura;
        
        public Sinistro(String id, String nominativo, String numeroPratica, String tipoPratica, String dataSinistro,String tipoSinistro, String statoSinistro, String esito, String anomalie,Date dataApertura){
            this.id = normalizza(id);
            this.nominativo = normalizza(nominativo);
            this.numeroPratica = normalizza(numeroPratica);
            this.tipoPratica = normalizza(tipoPratica);
            this.dataSinistro = normalizza(dataSinistro);
            this.tipoSinistro = normalizza(tipoSinistro);
            this.statoSinistro = normalizza(statoSinistro);
            this.esito = normalizza(esito);
            this.anomalie = normalizza(anomalie);
            this.dataApertura = dataApertura;
            
        }
        
        private String normalizza(String s){
            return s == null ? '' : s;
        }
        
        
        
        public Integer compareTo(Object obj){
            if(obj!=null){
                System.debug('######## order date ');
            	Sinistro sinistro = (Sinistro) obj;
                if(sinistro.dataApertura < this.dataApertura) return -1;
                if(sinistro.dataApertura > this.dataApertura) return 1;
            }
            
            return 0;
        }
        
        public virtual override String toString(){
            String s ='<tr style=" text-align: center; "><td style=" text-align: center; border: 1px solid #000;">'+nominativo+'</td>';
            s+='<td style=" text-align: center; border: 1px solid #000;">'+numeroPratica+'</td>';
            s+='<td style=" text-align: center; border: 1px solid #000;">'+tipoPratica+'</td>';
            s+='<td style=" text-align: center; border: 1px solid #000;">'+dataSinistro+'</td>';
            s+='<td style=" text-align: center; border: 1px solid #000;">'+tipoSinistro+'</td>';
            s+='<td style=" text-align: center; border: 1px solid #000;">'+statoSinistro+'</td>';
            s+='<td style=" text-align: center; border: 1px solid #000;">'+esito+'</td>';
            s+='<td style=" text-align: center; border: 1px solid #000;">'+anomalie+'</td></tr>';
            return s;
        }
    } 
    
    public class SinistroHeader extends Sinistro{
        
        SinistroHeader(String id, String nominativo, String numeroPratica, String tipoPratica, String dataSinistro,String tipoSinistro, String statoSinistro, String esito, String anomalie,Date dataApertura){
            super(id, nominativo, numeroPratica, tipoPratica, dataSinistro, tipoSinistro, statoSinistro, esito, anomalie,dataApertura);
        }
        
        public override String toString(){
            String s ='<tr style=" text-align: center; "><th style=" text-align: center; border: 1px solid #000;">'+nominativo+'</th>';
            s+='<th style=" text-align: center; border: 1px solid #000;">'+numeroPratica+'</th>';
            s+='<th style=" text-align: center; border: 1px solid #000;">'+tipoPratica+'</th>';
            s+='<th style=" text-align: center; border: 1px solid #000;">'+dataSinistro+'</th>';
            s+='<th style=" text-align: center; border: 1px solid #000;">'+tipoSinistro+'</th>';
            s+='<th style=" text-align: center; border: 1px solid #000;">'+statoSinistro+'</th>';
            s+='<th style=" text-align: center; border: 1px solid #000;">'+esito+'</th>';
            s+='<th style=" text-align: center; border: 1px solid #000;">'+anomalie+'</th></tr>';
            return s;
        }
    }
    
}