public class SFAListaDaSedeReadFileCSVBatch implements Queueable{
	public List<SFAListaDaSedeReadHelper> listaDealer;
    public List<SFAListaDaSedeReadHelper> listInOut;
    public List<SFAListaDaSedeReadHelper> listInError;
    public String [] file;
    public List<String> fields;
    public String tipo_attivita;
    public String nome_lista;
    public String tipo_lista;
    public String nome_tipo_lista;
    public Date data_visibilita;
    public Integer dealerError;
    private SFA_ListaCheckWrapper listaCheck;
    public Map<String, Integer> ocsCodeMap;
    public Map<String, Integer> pIvaMap;
    public SFAListaDaSedeReadFileCSVBatch(String fileData,List<String> fields, String tipo_attivita, String nome_lista, String tipo_lista, Date data_visibilita) {
        this.file = new String[]{};
        this.file = fileData.split('\n');          
        this.fields=fields;            
        this.tipo_attivita=tipo_attivita;            
        this.nome_lista=nome_lista;            
        this.tipo_lista=tipo_lista;            
        this.nome_tipo_lista=[SELECT Name FROM SFA_TipologiaLista__c WHERE Id =: this.tipo_attivita].Name;
		this.data_visibilita=data_visibilita;            
        this.dealerError=dealerError;       
        this.listaCheck = new SFA_ListaCheckWrapper();
        this.ocsCodeMap= new Map<String, Integer>();
        this.pIvaMap= new Map<String, Integer>();
        this.listaDealer = new List<SFAListaDaSedeReadHelper>();
    	this.listInOut = new List<SFAListaDaSedeReadHelper>();
        this.listInError = new List<SFAListaDaSedeReadHelper>();
    }
    public void execute(QueueableContext  context) {
        List<SFAListaDaSedeReadHelper> myList = new List<SFAListaDaSedeReadHelper>();
        for (Integer i=1,j=this.file.size();i<j;i++){
            try{
                String[] inputvalues = new String[]{};
                    //System.debug('Lettura line: '+i);
                    inputvalues = this.file[i].split(';');
                if(inputvalues.size()<26) {
                    listaCheck.addElem(this.tipo_lista, '--Blank--', '', '', '', 'Errore alla riga '+i+': Delimitatore errato / numero di campi errato.');
                    continue;
                }
                SFAListaDaSedeReadHelper obj = new SFAListaDaSedeReadHelper();
                if(!ocsCodeMap.containsKey(inputvalues[0])) {
                    ocsCodeMap.put(inputvalues[0],1);
                }
                else {
                    ocsCodeMap.put(inputvalues[0],ocsCodeMap.get(inputvalues[0])+1);
                }
                if(!pIvaMap.containsKey(inputvalues[13])) {
                    pIvaMap.put(inputvalues[13],1);
                }
                else {
                    pIvaMap.put(inputvalues[13],pIvaMap.get(inputvalues[13])+1);
                }
                Account acc=new Account();
                acc.OCS_External_id__c = inputvalues[0];
                acc.Name = inputvalues[1];
                //acc.Contact.RagioneSociale__c = inputvalues[1]; //problemi al pc
                acc.Tipo_Intermediario__c = inputvalues[5];
                acc.Tipo_Accordo_New__c = inputvalues[6];
                acc.Type_Anag__c = inputvalues[7];
                //acc.Data_Nascita__c = dateToParse(inputvalues[8]);
                //acc.PersonBirthdate = dateToParse(inputvalues[8]);
                //acc.Birthcity__c = inputvalues[9];
                //acc.Luogo_Nascita__pc = inputvalues[9];
                //acc.Birthprovince__c = inputvalues[10];
                //acc.Provincia_Nascita__pc = inputvalues[10];
                //acc.Sesso__pc =inputvalues[11];  	problemi al pc
                acc.Codice_Fiscale__c = inputvalues[12];
                acc.Partita_IVA__c = inputvalues[13];
                acc.CodiceAgente__c = inputvalues[14];
                //acc.Agent__c = inputvalues[15]; //agent_name è lookup
                //acc.Sub_Agent__c = inputvalues[17];
                acc.Macroarea__c = inputvalues[18];
                acc.ProdottoDominanteMacroarea__c = inputvalues[19];
                acc.BillingStreet = inputvalues[20];
                acc.ShippingCity = inputvalues[21];
                //?? = inputvalues[22]; //province da capire come mappare
                acc.ShippingPostalCode = inputvalues[23];
                acc.Phone = inputvalues[24];
                acc.Fax = inputvalues[25];
                acc.BusinessEmail__c = inputvalues[26];                
                obj.codice_filiale = inputvalues[2];		
                // correzione Dotti (mantis 0001895): serve a levare gli 0 davanti al codice filiale di 2 cifre
                if (!String.isEmpty(inputvalues[2]) && inputvalues[2].isNumeric()) {
                    String codiceFiliale = String.valueOf(Integer.valueOf(inputvalues[2]));
                    obj.codice_filiale = codiceFiliale;
                }
                if (String.isEmpty(inputvalues[3])|| !inputvalues[3].isNumeric()) {
                    listaCheck.addElem(this.tipo_lista, '--Blank--', '', '', '', 'Errore alla riga '+i+': Area filiale vuoto o non numerico');
                    continue;                   
                }
                obj.area_filiale = inputvalues[3];
                obj.regione_filiale = inputvalues[4];
                obj.accountObj=acc;
                //?? = inputvalues[28]; // da capire come mappare
                //?? = inputvalues[29]; // da capire come mappare
                //?? = inputvalues[31]; // da capire come mappare
                //?? = inputvalues[32]; // da capire come mappare
                //?? = inputvalues[35]; // da capire come mappare
                System.debug('Account toString @@@ '+acc);
                System.debug('Account PIVA toString @@@ '+acc.Partita_IVA__c);
                myList.add(obj);
            }catch(Exception e){
                System.debug('exception'+e.getMessage());   
                System.debug('exception'+e.getCause());   
                System.debug('exception'+e.getLineNumber());   
                System.debug('exception'+e.getStackTraceString());   
            }  
        }
        listaDealer = myList;
        List<CAP_2_Branch__c> caps = [SELECT Id, CAP_Generico__c, CAP__c, Comune__c, OCS_External_Id__c, Provincia__c, Regione__c FROM CAP_2_Branch__c];
        for(Integer i=0; i<listaDealer.size(); ) {
            SFAListaDaSedeReadHelper a = listaDealer.get(i);
            Boolean errorRow = false;   
            System.debug(LoggingLevel.DEBUG, '#Inizio controllo che OCS / PIva Valorizzato');
            if((a.accountObj.OCS_External_Id__c==null || (a.accountObj.OCS_External_Id__c!=null && a.accountObj.OCS_External_Id__c.equals(''))) && (a.accountObj.Partita_IVA__c==null || (a.accountObj.Partita_IVA__c!=null && a.accountObj.Partita_IVA__c.equals('')))) { 			//controllo che OCS sia univoco nella vista
                listaCheck.addElem(this.tipo_lista, a.accountObj.Name, a.accountObj.OCS_External_Id__c, a.accountObj.Partita_IVA__c, a.accountObj.Codice_Fiscale__c, 'Check fallito: OCS Code e Partita IVA non valorizzati');
                errorRow = true;
            }
            System.debug(LoggingLevel.DEBUG, '#Inizio controllo Partita_IVA__c.length()==11');
            if ((a.accountObj.OCS_External_Id__c==null || (a.accountObj.OCS_External_Id__c!=null && a.accountObj.OCS_External_Id__c.equals(''))) && a.accountObj.Partita_IVA__c!=null && a.accountObj.Partita_IVA__c.length()!=11) {
                listaCheck.addElem(this.tipo_lista, a.accountObj.Name, a.accountObj.OCS_External_Id__c, a.accountObj.Partita_IVA__c, a.accountObj.Codice_Fiscale__c, 'Check fallito: Partita IVA di 11 caratteri -> '+a.accountObj.Partita_IVA__c.length());
                errorRow = true;
            }
            System.debug(LoggingLevel.DEBUG, '#Fine controllo Partita_IVA__c.length()==11');
            System.debug(LoggingLevel.DEBUG, '#Fine controllo che OCS / PIva Valorizzato');
            System.debug(LoggingLevel.DEBUG, '#Inizio controllo che OCS sia univoco nella Lista');
            if(a.accountObj.OCS_External_Id__c!=null && !a.accountObj.OCS_External_Id__c.equals('') && ocsCodeMap.get(a.accountObj.OCS_External_Id__c)>1) { 			//controllo che OCS sia univoco nella vista
                listaCheck.addElem(this.tipo_lista, a.accountObj.Name, a.accountObj.OCS_External_Id__c, a.accountObj.Partita_IVA__c, a.accountObj.Codice_Fiscale__c, 'Check fallito: OCS Code non univoco -> '+a.accountObj.OCS_External_Id__c);
                errorRow = true;
            }
            System.debug(LoggingLevel.DEBUG, '#Fine controllo che OCS sia univoco nella Lista');
            System.debug(LoggingLevel.DEBUG, '#Inizio controllo che Partita_IVA__c sia univoco nella vista');
            if(a.accountObj.Partita_IVA__c!=null && !a.accountObj.Partita_IVA__c.equals('') && pIvaMap.get(a.accountObj.Partita_IVA__c)>1) { 			//controllo che Partita_IVA__c sia univoco nella vista
                listaCheck.addElem(this.tipo_lista, a.accountObj.Name, a.accountObj.OCS_External_Id__c, a.accountObj.Partita_IVA__c, a.accountObj.Codice_Fiscale__c, 'Check fallito: Partita IVA non univoco -> '+a.accountObj.Partita_IVA__c);
                errorRow = true;
            }
            System.debug(LoggingLevel.DEBUG, '#Fine controllo che Partita_IVA__c sia univoco nella vista');
            System.debug(LoggingLevel.DEBUG, '#Inizio controllo Codice_Fiscale__c.length()==11 / 16');
            if(String.isNotBlank(a.accountObj.Codice_Fiscale__c) && (a.accountObj.Codice_Fiscale__c.length()!=11 && a.accountObj.Codice_Fiscale__c.length()!=16)) {
                listaCheck.addElem(this.tipo_lista, a.accountObj.Name, a.accountObj.OCS_External_Id__c, a.accountObj.Partita_IVA__c, a.accountObj.Codice_Fiscale__c, 'Check fallito: Codice Fiscale di 11 o 16 caratteri -> '+a.accountObj.Codice_Fiscale__c.length());
                errorRow = true;
            }
            System.debug(LoggingLevel.DEBUG, '#Fine controllo Codice_Fiscale__c.length()==11 / 16');
            System.debug(LoggingLevel.DEBUG, '#Inizio controllo tipo_lista');
            if((nome_tipo_lista=='H3G ACCORDO 3117: NUOVI PUNTI VENDITA DI MASTER ATTIVI' || nome_tipo_lista=='H3G ACCORDO: NUOVI CONVENZIONAMENTI') && (a.accountObj.PersonEmail==null || (a.accountObj.PersonEmail!=null && a.accountObj.PersonEmail==''))) {                     //sarà con EXTERNAL ID di TIPOLOGIA_LISTA
                listaCheck.addElem(this.tipo_lista, a.accountObj.Name, a.accountObj.OCS_External_Id__c, a.accountObj.Partita_IVA__c, a.accountObj.Codice_Fiscale__c, 'Check fallito: Per il tipo lista \''+nome_tipo_lista+'\' il campo Email deve essere valorizzato.');
                errorRow = true;
            }
            System.debug(LoggingLevel.DEBUG, '#Fine controllo tipo_lista');
            /*System.debug(LoggingLevel.DEBUG, '#Inizio controllo che OCS sia univoco nella vista');
            if(a.accountObj.RagioneSociale__pc==null) {
                listaCheck.addElem(a.accountObj.OCS_External_Id__c, a.accountObj.Partita_IVA__c, a.accountObj.Codice_Fiscale__c, 'Check fallito: il campo Ragione Sociale deve essere valorizzata');
                errorRow = true;
            }
            System.debug(LoggingLevel.DEBUG, '#Fine controllo che OCS sia univoco nella vista');*/
            System.debug(LoggingLevel.DEBUG, '#Inizio controllo Tipo_Intermediario__c');
            if(a.accountObj.Tipo_Intermediario__c==null || (a.accountObj.Tipo_Intermediario__c!=null && a.accountObj.Tipo_Intermediario__c.equals('') || (a.accountObj.Tipo_Intermediario__c!=null && !'CV,SA,PV'.contains(a.accountObj.Tipo_Intermediario__c)) || (a.accountObj.Tipo_Intermediario__c!=null && a.accountObj.Tipo_Intermediario__c.equals('AG') && (a.accountObj.OCS_External_Id__c==null || (a.accountObj.OCS_External_id__c!=null && a.accountObj.OCS_External_Id__c.equals('')))))) {
                listaCheck.addElem(this.tipo_lista, a.accountObj.Name, a.accountObj.OCS_External_Id__c, a.accountObj.Partita_IVA__c, a.accountObj.Codice_Fiscale__c, 'Check fallito: Tipo_Intermediario__c vuoto oppure non valido');
                errorRow = true;
            }
            System.debug(LoggingLevel.DEBUG, '#Fine controllo Tipo_Intermediario__c');
            
            if(errorRow) {
                listInError.add(listaDealer.remove(i));
            }
            else {
                i++;
            }
        }
        System.debug('listInExam: '+listaDealer.size());   //LISTA CHE STO ELABORANDO IN OK!
        System.debug('listInError: '+listInError.size());  //LISTA DI RECORD IN ERRORE
        listaCheck.insertList();
        if(listaDealer.size()==0) {
            
            SFA_ListeCaricate__c listaCaricate = [SELECT Id, Nome_Lista__c, Data_Caricamento__c, Data_Visibilita__c FROM SFA_ListeCaricate__c WHERE Id = :tipo_lista];
            listaCaricate.Numero_righe__c=this.listInOut.size();
            upsert listaCaricate;
            System.debug('FINISH ALL BATCHES');
        }
        else {
	        ID jobID = Database.executeBatch(new SFAListaDaSedeCheckDealerBatch(this.tipo_attivita, this.tipo_lista, this.data_visibilita, this.listaDealer, this.listInError),200);
        }
    }
    private static Date dateToParse(String dateOCS){
        /*System.debug('OCSRecuperaDatiPostvenditaController dateToParse input: '+dateOCS);
        Date res = null; 
        try{
            res = 
            (
                (dateOCS != '0' && dateOCS != null) ? 
                (
                    dateOCS.contains('/') ?
                    Date.parse(dateOCS):
                    Date.newInstance(Integer.valueOf(dateOCS.substring(0, 4)), 
                                     Integer.valueOf(dateOCS.substring(4,6)),
                                     Integer.valueOf(dateOCS.substring(6)))
                ): 
                null
            );
        }
        catch(Exception e){
            System.debug('AccountUtils dateToParse Exception, message: '+e.getCause()+'\n'+e.getStackTraceString());
        }
        return res;*/
        return null;
    }
    public class SFA_ListaCheckWrapper {
        public List<SFA_ListaCheck__c> listaCheck {get; set;}
        
        public SFA_ListaCheckWrapper() {
            this.listaCheck= new List<SFA_ListaCheck__C>();
        }
        public void insertList() {
            if(this.listaCheck.size()<=200)
                insert listaCheck;
            else {
                List<SFA_ListaCheck__c> t = new List<SFA_ListaCheck__c>();
                for(Integer i=0; i<listaCheck.size();i++) {
                    if(i>0 && math.mod(i,200)==0) {
                        insert t;
                        t = new List<SFA_ListaCheck__c>();
                    }
                    else {
                        t.add(listaCheck.get(i));
                    }
                }
                if(t.size()>0) 
                    insert t;
            }
        }
        public void addElem(String idLista, String namec,String ocs_code, String piva, String codicefiscale, String errormessaggio) {
            SFA_ListaCheck__c c =  new SFA_ListaCheck__c();
            if(ocs_code.length()>80)
                c.Name = namec.substring(0, 77)+'...';
            else if (namec==null || (namec!=null && namec.length()==0)) c.Name='';
            else c.Name = namec;
            if(ocs_code.length()>20)
                c.OCS_Code__c = ocs_code.substring(0, 17)+'...';
            else c.OCS_Code__c = ocs_code;
            if(piva.length()>20)
            	c.P_IVA__c = piva.substring(0, 17)+'...';
            else c.P_IVA__c = piva;
            if(codicefiscale.length()>16)
            	c.CodiceFiscale__c = codicefiscale.substring(0, 13)+'...';
            else c.CodiceFiscale__c = codicefiscale;
            if(errormessaggio.length()>255)
            	c.ErrorMessage__c = errormessaggio.substring(0, 252)+'...';
            else c.ErrorMessage__c = errormessaggio;
            c.SFA_ListeCaricate__c=idLista;
            this.listaCheck.add(c);
        }
    }
}