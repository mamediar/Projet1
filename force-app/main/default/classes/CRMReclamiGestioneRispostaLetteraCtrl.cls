public without sharing class CRMReclamiGestioneRispostaLetteraCtrl {
    
    /**
     * Boris Inizio*/
    
    @AuraEnabled
    public static String getCase(String ident){
        Case c = [Select id, lettera_risposta__c from Case where id = :ident];
        return JSON.serialize(c);
    }
    
    @AuraEnabled
    public static List<ComboBox> loadStdtexts(String categExternalId,String societa){        
        Categ_stdtexts__mdt categText = [select Standard_Texts__c from categ_stdtexts__mdt
                                         where Societa__c =: societa and Id_Categoria__c =: categExternalId];
                
        String costante;
        if(societa == 'Compass') costante='C_';
        else if(societa == 'Futuro') costante = 'F_';
        else costante='M_';
		List<String> listaTesti = categText.Standard_Texts__c.split('/');
        for(Integer i=0; i<listaTesti.size(); i++) listaTesti[i] = costante+''+listaTesti[i];

        if(societa == 'MBCredit Solutions') societa = 'Creditech'; 
        List<stdtexts__mdt> stdText = [select Label, developerName  
                                       from stdtexts__mdt
                                       where Societa__c=:societa and DeveloperName in:listaTesti];
     	
        List<ComboBox> listaCB = new List<ComboBox>();
        for(stdtexts__mdt temp : stdtext){
             listaCB.add(new ComboBox((temp.label).capitalize(), temp.developerName));
        }
        listaCB.sort();
        
       
        return listaCB;
    }
    
    public class ComboBox implements Comparable{
        @AuraEnabled
        public String label{get;set;}
        @AuraEnabled
        public String value{get;set;}
        
        public ComboBox(String label, String value){
            this.label = label;
            this.value= value;
        }
        
        public Integer compareTo(Object obj){
            Combobox temp = (Combobox) obj;
            return label.compareTo(temp.label);
        }
     
        
    }
    
    @AuraEnabled
    public static String getMessageStandard(String idTesto){ 
        String testo =  [select body__c from stdtexts__mdt where DeveloperName = :idTesto].body__c;
        
        Map<String, String> mappaReplace = new Map<String, String>();
        mappaReplace.put('_x000D_', '\n');
        mappaReplace.put('&#39;', '\'');
       
        for(String s : mappaReplace.keySet()){
             testo = testo.replace(s,mappaReplace.get(s));
        } 
        return testo;
    }
    
    @AuraEnabled
    public static String getMessageStandard(String idTesto, String idCase){ 
        String testo =  [select body__c from stdtexts__mdt where DeveloperName = :idTesto].body__c;
        
        Map<String, String> mappaReplace = new Map<String, String>();
        mappaReplace.put('_x000D_', '\n');
        mappaReplace.put('&#39;', '\'');
        if(idCase!=null && idCase.length() >5){
           
            Case c2 = [
                SELECT id, Numero_Reclamo__c, Account.FirstName, Account.OCS_External_Id__c, Account.LastName, Owner.Name, Tipo_Prodotto_Descrizione__c,
                Tipo_Pratica__c, NumeroPratica__c
                FROM case WHERE id = :idCase
            ];

            String codCliente = c2.Account != null ? c2.Account.OCS_External_Id__c != null ? c2.Account.OCS_External_Id__c : '' : '';
            String codPratica = c2.NumeroPratica__c != null ? c2.NumeroPratica__c : '';
            String tipoPratica = c2.Tipo_Pratica__c != null ? c2.Tipo_Pratica__c : '';

            String agg_abi = '';
            String agg_cab = '';
            String agg_cc = '';
            String agg_datadepennamento = '';
            String agg_datarevoca = '';
            String agg_importo = '';
            String agg_nomebanca = '';
            //OCSDatiAggiuntiviReclamiResponse callDatiAgguntiviReclami (String codCliente, String codPratica, String tipoPratica){
            OCSDatiAggiuntiviReclamiResponse response = OCSDatiAggiuntiviReclamiInvoker.callDatiAgguntiviReclami(codCliente.replace('C',''),codPratica,tipoPratica);
            if(response!=null){
                system.debug('@@@ response'+response.datiAggiuntiviReclamiResponse);

                OCSDatiAggiuntiviReclamiResponse.DatiAggiuntiviReclamiResponseDTO resp = response.datiAggiuntiviReclamiResponse;
                if(resp!=null){
                agg_abi = resp.abi  != null ? resp.abi  : '';
                agg_cab = resp.cab  != null ? resp.cab  : '';
                agg_cc = resp.cc  != null ? resp.cc  : '';
                agg_datadepennamento = resp.datadepennamento  != null ? resp.datadepennamento  : '';
                agg_datarevoca = resp.datarevoca  != null ? resp.datarevoca  : '';
                agg_importo = resp.importo  != null ? resp.importo  : '';
                agg_nomebanca = resp.nomebanca  != null ? resp.nomebanca  : '';
                }
            }
            
            //OCSDatiAggiuntiviReclamiResponse value
            mappaReplace.put('$dati_agg_abi', agg_abi);
            mappaReplace.put('$dati_agg_cab', agg_cab);
            mappaReplace.put('$dati_agg_cc', agg_cc);
            mappaReplace.put('$dati_agg_datadepennamento', agg_datadepennamento);
            mappaReplace.put('$dati_agg_datarevoca', agg_datarevoca);
            mappaReplace.put('$dati_agg_importo', agg_importo);
            mappaReplace.put('$dati_agg_nomebanca', agg_nomebanca);

            //Case value
            mappaReplace.put('$incidents.c$ccint_number', c2.Numero_Reclamo__c!=null ? c2.Numero_Reclamo__c : '');
            mappaReplace.put('$incidents.c$owners',c2.Owner!=null ? c2.Owner.Name!=null ? c2.Owner.Name : '' : '');
            mappaReplace.put('$incidents.c$tipo_prod_descr',c2.Tipo_Prodotto_Descrizione__c!=null ? c2.Tipo_Prodotto_Descrizione__c : '');//es.C_191
            
            String name_first = '';
            String mane_last = '';
            String ocs_anag_co = '';

            if(c2.Account!=null){
                name_first = c2.Account.FirstName!=null ? c2.Account.FirstName : '';
                mane_last = c2.Account.LastName!=null ? c2.Account.LastName : '';
                ocs_anag_co = c2.Account.OCS_External_Id__c!=null ? c2.Account.OCS_External_Id__c : '';
            }
            
            mappaReplace.put('$contacts.name.first',name_first);
            mappaReplace.put('$contacts.name.last',mane_last);
            mappaReplace.put('$contacts.c$ocs_anag_co',ocs_anag_co);
            
        } 
        system.debug('S_TESTO: '+testo);
        for(String s : mappaReplace.keySet()){
            testo = testo.replace(s,mappaReplace.get(s));
        } 
        
        system.debug('S_TESTO_RETURNED: '+testo);
        return testo;
    }
    
    @AuraEnabled
    public static Attachment generateAndAttach(String fileBody, Case c, String getFirmaDigitale, String textLabel, String codCliente, String nome, String cognome){
        insert XCSReclamiUtils.createFeedItem(c.id, Datetime.now(), 'printed', UserInfo.getName(), true);
               
        
        Case caso = new Case();
        caso.id = c.id;
        caso.Lettera_Risposta__c  = fileBody;
     
        update caso;
        
        String fileName=c.Numero_Reclamo__c+'_'+DateTime.now()+'.rtf';

        PageReference pg = new PageReference('/apex/XCSReclamiLetteraRisposta');
        pg.getParameters().put('Id', c.Id);
        pg.getParameters().put('company', c.Referenced_Company__c);
        pg.getParameters().put('getFirma', getFirmaDigitale+'');
        pg.getParameters().put('textLabel', textLabel);
        pg.getParameters().put('nome', nome);
        pg.getParameters().put('cognome', cognome);
        pg.getParameters().put('codCliente', codCliente);
        
        Blob blb = Test.isRunningTest() ? Blob.valueOf('TEST') : pg.getContent();
        system.debug('pg.getContent(): '+pg.getContent());
        
        //String base64Content = JSON.deserialize(fileBody, String.class);

        //String b64 = EncodingUtil.base64Encode( Blob.valueOf(fileBody));
        //blb = EncodingUtil.base64Decode(base64Content);
        //----------------------------------------------------
        /*system.debug('STRING valueOf blb: '+fileBody);
        Blob beforeblob = Blob.valueOf(fileBody);
        system.debug('BLOB valueOf blb: '+beforeblob);
        String paramvalue = EncodingUtil.base64Encode(beforeblob);
        paramvalue+='==';
        system.debug('STRING 64 paramvalue: '+paramvalue);
        Blob blb2 = Blob.valueOf(paramvalue);
        system.debug('BLOB blb2: '+blb2);*/
        //-----------------------------------------------------

        

        Attachment a=new Attachment();
        a.Body=blb;
        a.ParentId=c.Id;
        a.Name=fileName;
        a.ContentType='text/rtf';

        List<Attachment> attList = new List<Attachment>();
        attList.add(a);

        XCSReclamiUtils.createFile(attList,c.Id);
        List<Attachment> attList2 = XCSReclamiUtils.documentToAttachment(c.Id);



       
        return attList2[0];
    }
    
    @AuraEnabled
    public static void salvaLetteraCtrl(String idCase, String testo){
        Case c = new Case();
        c.Id = Id.valueOf(idCase);
        c.Lettera_Risposta__c = testo;
        update c;
        
    }
    //Boris Fine
    @AuraEnabled
    public static String loadText(String textLabel,Case currentCase,OCSCliente cliente){
        String res='';
        list<stdtexts__mdt> resList=[select Body__c from stdtexts__mdt where Societa__c=:currentCase.Referenced_Company__c and Label=:textLabel];
        if(resList.size()>0){
            res=resList[0].Body__c;
            res=replaceSpecialStrings(res,currentCase,cliente);
        }
        system.debug('----------------------------------------------------------------------------------');
        system.debug('-- Class Name: CRMReclamiGestioneRispostaLetteraCtrl - Method Name : loadText'); 
        system.debug('-- Variable Name: res  - Value: ' + res); 

        return res;
    }
    

    
    public static String replaceSpecialStrings(String template,Case c,OCSCliente cliente){
      
        
        return template;
    }
    
    private static String buildOwnersString(OCSCliente c){
        String res='';
        
        return res;
    }
    
    private static String getFirmaDigitaleName(){
        String res='CompassLogo';
        
        return res;
    }
}