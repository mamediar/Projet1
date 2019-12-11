public class XCSReclamiLetteraRispostaCtrl {
    
    @TestVisible private Case currentCase {get;set;}
    
    public String firmaDigitale{get;set;}
    public String body{get;set;}
    public Boolean putFirma{get;set;}
    //Boris
    public String idDocumento {get;set;} 
    public String idorganizzazione {get;set;}
    public String baseUrl{get;set;} 
    public List<XCS_Mittente__c> listaMittenti;
    public String mittenti{get;set;}
    public String data{get;set;}
    public String firma{get;set;}
    public List<String> listaMittentiTesto{get;set;}
    
    public XCSReclamiLetteraRispostaCtrl(ApexPages.StandardController std){

        idDocumento = [Select id, LastModifiedDate  From Document Where developerName = 'Compass_Logo'].Id;
        idorganizzazione = UserInfo.getOrganizationId();
        this.currentCase = (Case)std.getRecord();
        this.currentCase = [Select id, ownerId, Lettera_Risposta__c , NumeroPratica__c, Tipo_Pratica__c, Referenced_Company__c  FROM Case Where id = :currentCase.id];
        listaMittenti = [SELECT Id, Name, Case__c, Citta__c, Via__c, Tipologia__c, Salutation__c, Provincia__c, Principale__c, Predefinito__c, Name__c, External_Id__c, Incident_Id__c, Codice_Postale__c, Autorita__c FROM XCS_Mittente__c Where case__c = :currentCase.Id];
        this.mittenti = getListaMittenti();
        
        baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        String company = ApexPages.currentPage().getParameters().get('company');
        putfirma = ApexPages.currentPage().getParameters().get('getFirma').equals('true');
		
        String textLabel = ApexPages.currentPage().getParameters().get('textLabel');
        
        OCSCliente cliente = new OCSCliente();
        cliente.codCliente = ApexPages.currentPage().getParameters().get('codCliente');
        cliente.nome = ApexPages.currentPage().getParameters().get('nome');
        cliente.cognome = ApexPages.currentPage().getParameters().get('cognome'); 
        Datetime oggi = System.now();
        data = 'Milano, '+ oggi.format('dd/MM/yyyy');
		firma = getFirma(currentCase.ownerId, currentCase.referenced_company__c);	
        
        this.body = CRMReclamiGestioneRispostaLetteraCtrl.replaceSpecialStrings(currentCase.Lettera_Risposta__c , currentCase, cliente);
        if(body!=null){
            this.body = body.escapeHtml4();
            this.body = body.replace('\r\n','<br/>');
            this.body = body.replace('\n\r','<br/>');
            this.body = body.replace('\r','<br/>');
            this.body = body.replace('\n','<br/>');
            this.body = body.replace('&#39;','\'');
        }
        
        //Model per Mittenti
        Map<XCS_Mittente__c, List<XCS_Mittente__c>> mappaMittenti = new Map<XCS_Mittente__c, List<XCS_Mittente__c>>();
		XCS_Mittente__c mittentePrincipale =  listaMittenti[0];       
       
        for(Integer i=0;i<listaMittenti.size(); i++){
            List<XCS_Mittente__c> temp = new List<XCS_Mittente__c>();
           if(listaMittenti[i].id != mittentePrincipale.id) temp.add(mittentePrincipale); //Primo Mittente in E,p.c.
            mappaMittenti.put(listaMittenti[i], temp ); //Mittente in testa;

            for(Integer j=0;j<listaMittenti.size(); j++){
                XCS_Mittente__c mittenteDaAgg = listaMittenti[j];
                if(mittenteDaAgg.Id != mittentePrincipale.id && i!=j) temp.add(mittenteDaAgg);
            }  
        }
        
        for(XCS_Mittente__c temp : mappaMittenti.keySet()){
            System.debug('Chiave'+' '+temp);
            System.debug('Valori'+' '+mappaMittenti.get(temp));
        }
        //Fine Model per Mittenti
        
        //View per Mittenti
       listaMittentiTesto = new List<String>();
      	
        for(XCS_Mittente__c key : mappaMittenti.keySet()){
            
            Mittente view = new Mittente(key);
            String bodyMitt ='<span style="font-weight:bold;margin-left:80px;">'+view.toString()+'</span>';
            //E p.c. --> if(lista != vuoto)
            Boolean isDiv=false;
            if(mappaMittenti.get(key).size() > 0){
                bodyMitt += '<div><div style="font-weight:bold;">E, p.c.:</div>';
                isDiv=true;
            } 
            bodyMitt +='<br/>';
            for(XCS_Mittente__c value : mappaMittenti.get(key)){
                 Mittente v = new Mittente(value);
                bodyMitt+='<span style="font-weight:bold;margin-left:80px;">'+v.toString()+'</span>';
                if(isDiv){
                    isDiv=false;
                    bodyMitt+='</div>';
                }
            }
            listaMittentiTesto.add(bodyMitt);
            
        }
        
        
        //Fine view per Mittenti
        
    }
    
    
//https://compass--dev3--c.cs84.visual.force.com/apex/XCSReclamiLetteraRisposta?id=5005E000005qbcFQAQ&company=Compass&getFirma=true    
    public static String getFirma(String owner, String societa){
        if(!owner.startsWith('00G')) return '' ;
        Group coda = [SELECT Id, Name, DeveloperName, RelatedId, Type, Email FROM Group where id = :owner];
        String dn;
        if(coda.DeveloperName.contains('Q')) dn= coda.DeveloperName.replace('Q','DN_');
        else  dn= coda.DeveloperName.replace('F','DN_');
        return [SELECT Id, DeveloperName, MasterLabel, Email__c, Firma__c, Societa__c FROM CodaXSocieta__mdt where developerName = :dn].Firma__c;

        
        
    }
    
    public void init(){
        /*Map<String,String> params=System.currentPageReference().getParameters();
        this.firmaDigitale=getFirmaDigitaleName(params);
        this.body=params.get('msgBody');
        this.putFirma=Boolean.valueOf(String.isNotEmpty(params.get('putFirma')) ? params.get('putFirma') : 'false');
        System.debug('XCSReclamiLetteraRispostaCtrl init values:\nfirmaDigitale: '+firmaDigitale+'\nbody: '+body+'\nputFirma: '+putFirma);*/
    }
    
    private static String getFirmaDigitaleName(Map<String,String> params){
        //valore di default, se non trova la static resource, stampa il logo di compass
        String res='CompassLogo';
        if(String.isNotEmpty(params.get('firmaDigitale'))){
            res=params.get('firmaDigitale');
        }
        return res;
    }
    
    public String getListaMittenti(){
      
        if(listaMittenti == null) return '';
        String testoMit = '<div>';
        
        for(Integer i=0;i<listaMittenti.size();i++){
            Mittente temp = new Mittente(listaMittenti[i]);
            if(i > 0) testoMit+='<span>E, p.c.:<span>';
            testoMit+=temp.toString() + '<br/>';

        }
        testoMit+='</div>';
        return testoMit;
    }
    
    public class Mittente implements Comparable{
        XCS_Mittente__c mitt;
        
        public Mittente(XCS_Mittente__c mitt){
            this.mitt = mitt;
        }
        
        public override String toString(){
            String s = '';
            s+=mitt.Salutation__c != null ? mitt.Salutation__c.capitalize()+'<br/>' : '';
            s+=mitt.Name__c != null ? mitt.Name__c.capitalize()+'<br/>' : '';
            s+=mitt.Via__c !=null ? mitt.Via__c.capitalize()+'<br/>' : '';
            s+=mitt.codice_postale__c !=null ? mitt.Codice_Postale__c.capitalize()+' ': '';
            s+=mitt.citta__c != null ? mitt.citta__c.capitalize()+' ' :' ';
            s+=mitt.Provincia__c != null ? mitt.Provincia__c+'<br/>': '';
            s+='';
            return s;
        }
        
        public Integer compareTo(Object o){
        	XCS_Mittente__c mittente = (XCS_Mittente__c) o;
            if(mittente.Predefinito__c) return -1;
            if(mitt.Predefinito__c) return -1;
            return 1;
        }
    }
}