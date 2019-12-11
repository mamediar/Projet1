public with sharing class SFACommodity_Controller {


public static final String queueMD = 'Q502';


    @AuraEnabled
//    public static List<sfa_commodity_check_activity_details__c> getActivity(String numPratica, Id idCase){
    public static List<sfa_commodity_check_activity_details__c> getActivity(Id idCase){
        System.debug('-- SFACommodity_Controller -- getActivity ');
//        System.debug('-- numPratica ->  '+ numPratica);
        System.debug('-- idCase ->  '+ idCase);

//        List<sfa_commodity_check_activity_details__c> lisAct = [SELECT Id, Activity_id__c, Allegato_sospeso__c, Categoria__c,
        List<sfa_commodity_check_activity_details__c> lisAct = [SELECT Id, Activity_Id__c, Allegato_sospeso__c, Categoria__c,
        Cod_agente_convenzionato__c, Cod_esito__c, Cod_subagente_pv__c, Data_notifica__c, Data_verifica__c, Activity_Id__r.Duedate__c, 
        Debitore__c, Dipendente__c, Esito__c, Esito_finale_md__c, Nota_compass__c, Nota_societa_esterna__c, Nota_sospesa__c,
//        Num_Pratica__c, OwnerId, pratica_carta__c, question1__c, question2__c, question3__c, Rag_sociale_agente_convenzionato__c,
        Num_Pratica__c, pratica_carta__c, question1__c, question2__c, question3__c, Rag_sociale_agente_convenzionato__c,
        Rag_sociale_subagente_pv__c, Ritardo_dealer__c, Name, Societa__c, Tipo_prodotto__c, Activity_Id__r.NumeroPratica__c,Activity_id__r.Account.Region_name__c
        FROM sfa_commodity_check_activity_details__c
        WHERE Activity_Id__c = : idCase LIMIT 1]; 

        //System.debug('lisAct ' + lisAct.size());


        return lisAct;

    }


    @AuraEnabled
    public static Boolean getSospendi(Id idCase,String notaSospesa, String q1, String q2, String q3){
        System.debug('-- SFACommodity_Controller -- getSospendi ');
        System.debug('-- idCase ->  '+ idCase);
        System.debug('-- notaSospesa -> '+notaSospesa);
        System.debug('-- q1 -> '+q1);
        System.debug('-- q2 -> '+q2);
        System.debug('-- q3 -> '+q3);

        String sNota;

        List<sfa_commodity_check_activity_details__c> lSfa =[SELECT Id, Activity_Id__c, Allegato_sospeso__c, Categoria__c,
        Cod_agente_convenzionato__c, Cod_esito__c, Cod_subagente_pv__c, Data_notifica__c, Data_verifica__c, Activity_Id__r.Duedate__c, 
        Debitore__c, Dipendente__c, Esito__c, Esito_finale_md__c, Nota_compass__c, Nota_societa_esterna__c, Nota_sospesa__c,
//        Num_Pratica__c, OwnerId, pratica_carta__c, question1__c, question2__c, question3__c, Rag_sociale_agente_convenzionato__c,
        Num_Pratica__c, pratica_carta__c, question1__c, question2__c, question3__c, Rag_sociale_agente_convenzionato__c,
        Rag_sociale_subagente_pv__c, Ritardo_dealer__c, Name, Societa__c, Tipo_prodotto__c, Activity_Id__r.NumeroPratica__c,Activity_id__r.Account.Region_name__c
        FROM sfa_commodity_check_activity_details__c
        WHERE Activity_Id__c = : idCase LIMIT 1];

        List<sfa_commodity_check_activity_details__c> uSfa = new List<sfa_commodity_check_activity_details__c>(); 

        System.debug('sNota 2 -> '+ sNota);

        lSfa[0].Nota_Sospesa__c = notaSospesa; 
        lSfa[0].question1__c = q1; 
        lSfa[0].question2__c = q2; 
        lSfa[0].question3__c = q3; 

        uSfa.add(lSfa[0]);

        update uSfa;


        return true;
    }


    @AuraEnabled
    public static Boolean getCompleta(Id idCase,String nota, String q1, String q2, String q3){
        System.debug('-- SFACommodity_Controller -- getCompleta ');
        System.debug('-- idCase ->  '+ idCase);
        System.debug('-- nota -> '+nota);
        System.debug('-- q1 -> '+q1);
        System.debug('-- q2 -> '+q2);
        System.debug('-- q3 -> '+q3);

        String sCateg ;
    
    
        List<Case> lCase = [SELECT Id, Status, OwnerId, Categoria_Riferimento__r.name, Disposition__c FROM Case WHERE Id=:idCase LIMIT 1];
        List<Case> uCase = new list<Case>();

        sCateg = lCase[0].Categoria_Riferimento__r.Name;

        Id idUser = UserInfo.getUserId();

        User u = [SELECT Id, Alias FROM User WHERE Id= :idUser];


        List<sfa_commodity_check_activity_details__c> lSfa =[SELECT Id, Activity_Id__c, Allegato_sospeso__c, Categoria__c,
        Cod_agente_convenzionato__c, Cod_esito__c, Cod_subagente_pv__c, Data_notifica__c, Data_verifica__c, Activity_Id__r.Duedate__c, 
        Debitore__c, Dipendente__c, Esito__c, Esito_finale_md__c, Nota_compass__c, Nota_societa_esterna__c, Nota_sospesa__c,
        Num_Pratica__c, pratica_carta__c, question1__c, question2__c, question3__c, Rag_sociale_agente_convenzionato__c,
        Rag_sociale_subagente_pv__c, Ritardo_dealer__c, Name, Societa__c, Tipo_prodotto__c, Activity_Id__r.NumeroPratica__c,Activity_id__r.Account.Region_name__c
        FROM sfa_commodity_check_activity_details__c
        WHERE Activity_Id__c = : idCase LIMIT 1];



        List<sfa_commodity_check_activity_details__c> uSfa = new List<sfa_commodity_check_activity_details__c>(); 

        String vDate = System.today().format();
        Date sDate = System.today();

        String sNota = 'FIL - '+u.Alias+' - '+vDate+' - '+nota ;

        lSfa[0].Nota_Sospesa__c = ''; 
        lSfa[0].Nota_Compass__c = sNota; 
        lSfa[0].question1__c = q1; 
        lSfa[0].question2__c = q2; 
        lSfa[0].question3__c = q3;
        lSfa[0].Data_verifica__c = Date.valueOf(sdate); 

        switch on sCateg {
            when 'Commodity Check Anomaly' {
                lSfa[0].Cod_esito__c = 'AO253';
                lSfa[0].Esito__c = 'Branch_Activity_Complete';
                XCS_Disposition__c xd = XCS_DispositionUtils.findDispositionByExternalID('AO253');
                lCase[0].Disposition__c = xd.Id;
            }
            when 'Commodity Check Critical' {
                lSfa[0].Cod_esito__c = 'AO250';
                lSfa[0].Esito__c = 'Branch_Activity_Complete';
                XCS_Disposition__c xd = XCS_DispositionUtils.findDispositionByExternalID('AO250');
                lCase[0].Disposition__c = xd.Id;
            }
            when else {
                lSfa[0].Cod_esito__c = 'AO256';
                lSfa[0].Esito__c = 'Complete';
                XCS_Disposition__c xd = XCS_DispositionUtils.findDispositionByExternalID('AO256');
                lCase[0].Disposition__c = xd.Id;
            }
        }

        Id queueId;
        queueId= GroupUtils.getQueue(queueMD).Id;

        lCase[0].ownerId = queueId;

        System.debug('notas -> '+ lSfa[0].Nota_Sospesa__c); 
        System.debug('notac -> '+ lSfa[0].Nota_Compass__c); 
        System.debug('q1 -> '+ lSfa[0].question1__c); 
        System.debug('q2 -> '+ lSfa[0].question2__c); 
        System.debug('q3 -> '+ lSfa[0].question3__c); 
        System.debug('data verifica -> '+ lSfa[0].Data_verifica__c);
        System.debug('lSfa[0].Cod_Esito -> ' + lSfa[0].Cod_esito__c);
        System.debug('lSfa[0].Esito -> ' + lSfa[0].Esito__c);
        System.debug('lCase.Disposition__c -> ' + lCase[0].Disposition__c);
        System.debug('lCase.OwnerId -> ' + lCase[0].OwnerId);

        String sTipo;
        if(lSfa[0].pratica_carta__c=='C'){
            sTipo = 'CA';
        }else If(lSfa[0].pratica_carta__c=='P'){
            sTipo = 'CO';
        }


        invioNoteOCS(lSfa[0].Nota_Compass__c,'',lSfa[0].Num_Pratica__c,sTipo);
        XCSNoteUtils.postANote(lSfa[0].id,'Commodity',lSfa[0].Nota_Compass__c);


        uSfa.add(lSfa[0]);
        uCase.add(lCase[0]);

//        update uSfa;
//        update uCase;


        return true;
    }

    private static OCSGestioneNoteResponse invioNoteOCS(String notaOCS,String codiceCliente, String numPratica, String tipoMessaggio){
        String strUserAlias = [select Alias from User where Id=:UserInfo.getUserId()].Alias;
        return OCSGestioneNoteInvoker.gestioneNote(strUserAlias,codiceCliente,numPratica, tipoMessaggio, 'A','P',notaOCS ); // SCRIVO NOTA OCS 
    }



    @AuraEnabled
    public static Map<String,String>  getUserMap(){
        Map<String,String> sMap = new Map<String,String>();
        Id idUser = UserInfo.getUserId();
      
        sMap.put('idUser', idUser);

        String sProfile = [SELECT Profile.Name FROM User WHERE Id = :idUser].Profile.Name;
        System.debug('-- sProfile --> '+ sProfile);
        sMap.put('Profile', sProfile);

        String sFiliale = [SELECT DefaultQueueId__c FROM User WHERE Id = :idUser].DefaultQueueId__c;
        System.debug('-- sFiliale --> '+ sFiliale);
        sMap.put('Filiale', sFiliale);


        return sMap;

    }


    @AuraEnabled
    public static Map<String,String> getDatiPratica(String numPratica){
        System.debug('-- SFACommodity_Controller -- getDatiPratica');
        System.debug('-- numPratica --> '+ numPratica);
        Boolean b = false;

        Map<String,String> rdp = new Map <String,String>();

        if(b==true){
            rdp.put('numeroPratica',numPratica);
            rdp.put('codCliente','CLIENTE TEST');
            rdp.put('cognome','GIULIANI TEST');
            rdp.put('nome','FABIO TEST');
            rdp.put('ragioneSociale','RAGIONE SOCIALE TEST');
            rdp.put('telefonoCasa','123456789');
            rdp.put('codDealer','DEALER TEST');
            rdp.put('statoDealer','ITALIA TEST');
            rdp.put('telCellulare','340123456789');
            rdp.put('telDatore','9876543210');
            rdp.put('codClienteCoob','COOBB TEST');
            rdp.put('cognomeCoob','LIMNGELLI TEST');
            rdp.put('nomeCoob','PATRIZIA TEST');
            rdp.put('ragioneSocialeCoob','RAGIONE COOBB TEST');
            rdp.put('telefonoCasaCoob','5201478963');
            rdp.put('telCellulareCoob','3698521470');
            rdp.put('telDatoreCoob','0246810');
            rdp.put('dataLiquidazione','20191030');
            rdp.put('descrizioneBene','camera TEST');
            rdp.put('codDestFinanziamento','MED');
            rdp.put('descDestFinanziamento','spese mediche e sanitarie');
            rdp.put('tipoProdotto','PAPF');
            rdp.put('numRata','24');
            rdp.put('importoRata','190');
            rdp.put('finanziato','36000');
            rdp.put('ragioneSocialeDealer','RAG SOC DEALER TEST');
            rdp.put('canale','PW4');

        }else{

            OCSRecuperaDatiPraticaCommodityInvoker.Response res =  OCSRecuperaDatiPraticaCommodityInvoker.invoke(numPratica);
            
            rdp.put('numeroPratica',res.recuperaDatiPraticaCommodityResponse.datiPraticaCommodityDTO.numeroPratica);
            rdp.put('codCliente',res.recuperaDatiPraticaCommodityResponse.datiPraticaCommodityDTO.codCliente);
            rdp.put('cognome',res.recuperaDatiPraticaCommodityResponse.datiPraticaCommodityDTO.cognome);
            rdp.put('nome',res.recuperaDatiPraticaCommodityResponse.datiPraticaCommodityDTO.nome);
            rdp.put('ragioneSociale',res.recuperaDatiPraticaCommodityResponse.datiPraticaCommodityDTO.ragioneSociale);
            rdp.put('telefonoCasa',res.recuperaDatiPraticaCommodityResponse.datiPraticaCommodityDTO.telefonoCasa);
            rdp.put('codDealer',res.recuperaDatiPraticaCommodityResponse.datiPraticaCommodityDTO.codDealer);
            rdp.put('statoDealer',res.recuperaDatiPraticaCommodityResponse.datiPraticaCommodityDTO.statoDealer);
            rdp.put('telCellulare',res.recuperaDatiPraticaCommodityResponse.datiPraticaCommodityDTO.telCellulare);
            rdp.put('telDatore',res.recuperaDatiPraticaCommodityResponse.datiPraticaCommodityDTO.telDatore);
            rdp.put('codClienteCoob',res.recuperaDatiPraticaCommodityResponse.datiPraticaCommodityDTO.codClienteCoob);
            rdp.put('cognomeCoob',res.recuperaDatiPraticaCommodityResponse.datiPraticaCommodityDTO.cognomeCoob);
            rdp.put('nomeCoob',res.recuperaDatiPraticaCommodityResponse.datiPraticaCommodityDTO.nomeCoob);
            rdp.put('ragioneSocialeCoob',res.recuperaDatiPraticaCommodityResponse.datiPraticaCommodityDTO.ragioneSocialeCoob);
            rdp.put('telefonoCasaCoob',res.recuperaDatiPraticaCommodityResponse.datiPraticaCommodityDTO.telefonoCasaCoob);
            rdp.put('telCellulareCoob',res.recuperaDatiPraticaCommodityResponse.datiPraticaCommodityDTO.telCellulareCoob);
            rdp.put('telDatoreCoob',res.recuperaDatiPraticaCommodityResponse.datiPraticaCommodityDTO.telDatoreCoob);
            rdp.put('dataLiquidazione',res.recuperaDatiPraticaCommodityResponse.datiPraticaCommodityDTO.dataLiquidazione);
            rdp.put('descrizioneBene',res.recuperaDatiPraticaCommodityResponse.datiPraticaCommodityDTO.descrizioneBene);
            rdp.put('codDestFinanziamento',res.recuperaDatiPraticaCommodityResponse.datiPraticaCommodityDTO.codDestFinanziamento);
            rdp.put('descDestFinanziamento',res.recuperaDatiPraticaCommodityResponse.datiPraticaCommodityDTO.descDestFinanziamento);
            rdp.put('tipoProdotto',res.recuperaDatiPraticaCommodityResponse.datiPraticaCommodityDTO.tipoProdotto);
            rdp.put('numRata',res.recuperaDatiPraticaCommodityResponse.datiPraticaCommodityDTO.numRata);
            rdp.put('importoRata',res.recuperaDatiPraticaCommodityResponse.datiPraticaCommodityDTO.importoRata);
            rdp.put('finanziato',res.recuperaDatiPraticaCommodityResponse.datiPraticaCommodityDTO.finanziato);
            rdp.put('ragioneSocialeDealer',res.recuperaDatiPraticaCommodityResponse.datiPraticaCommodityDTO.ragioneSocialeDealer);
            rdp.put('canale',res.recuperaDatiPraticaCommodityResponse.datiPraticaCommodityDTO.canale);

        }
        


        return rdp;
        
    }

    @AuraEnabled
    public static Map<String,String> getDatiCarta(String numPratica){
        System.debug('-- SFACommodity_Controller -- getDatiCarta');
        System.debug('-- numPratica --> '+ numPratica);
        Boolean b = false;

        Map<String,String> rdc = new Map <String,String>();

        if(b==true){
            rdc.put('numeroPratica',numPratica);
            rdc.put('codCliente','COD CLIENTE TEST');
            rdc.put('codDealer','COD DEALER TEST');
            rdc.put('codProdotto','COD PRODOTTO TEST');
            rdc.put('descProdotto','DESC PRODOTTO TEST');
            rdc.put('dataRichiesta','20191031');
            rdc.put('fido','50000');
            rdc.put('ragioneSociale','RAG SOC TEST');
            rdc.put('ragioneSocialeDealer','RAG SOC DEALER TEST');
            rdc.put('statoDealer','IT');
            rdc.put('telCellulare','38012345678');
            rdc.put('telDatore','0655281773');
            rdc.put('telCase','065281475');

        }else{

            OCSRecuperaDatiCartaDealerInvoker.Response res =  OCSRecuperaDatiCartaDealerInvoker.invoke(numPratica);
            
            rdc.put('numeroPratica',res.recuperaDatiCartaDealerResponse.numeroPratica);
            rdc.put('codCliente',res.recuperaDatiCartaDealerResponse.codCliente);
            rdc.put('codDealer',res.recuperaDatiCartaDealerResponse.codDealer);
            rdc.put('codProdotto',res.recuperaDatiCartaDealerResponse.codProdotto);
            rdc.put('descProdotto',res.recuperaDatiCartaDealerResponse.descProdotto);
            rdc.put('dataRichiesta',res.recuperaDatiCartaDealerResponse.dataRichiesta);
            rdc.put('fido',res.recuperaDatiCartaDealerResponse.fido);
            rdc.put('ragioneSociale',res.recuperaDatiCartaDealerResponse.ragioneSociale);
            rdc.put('ragioneSocialeDealer',res.recuperaDatiCartaDealerResponse.ragioneSocialeDealer);
            rdc.put('statoDealer',res.recuperaDatiCartaDealerResponse.statoDealer);
            rdc.put('telCellulare',res.recuperaDatiCartaDealerResponse.telCellulare);
            rdc.put('telDatore',res.recuperaDatiCartaDealerResponse.telDatore);
            rdc.put('telCase',res.recuperaDatiCartaDealerResponse.telCase);
        }
        
        return rdc;
    }

    @AuraEnabled
    public static List<ContentDocumentLink> finishUploadFile(String recordId, String documentId, String nameFile, String Descr){  
        
        ContentVersion cv = [select id from contentversion where contentdocumentid = :documentId];
        ContentDistribution cd = new ContentDistribution();
        ContentDocument cDoc = [SELECT Id, Description FROM ContentDocument WHERE id=:documentId];
        ContentDocument uDoc = new ContentDocument();

        cDoc.Description = Descr;
//        cd.ContentVersionId = cv.id;
//        cd.PreferencesAllowViewInBrowser= true;
//        cd.PreferencesLinkLatestVersion=true;
//        cd.PreferencesNotifyOnVisit=false;
//        cd.PreferencesPasswordRequired=false;
//        cd.PreferencesAllowOriginalDownload= true;        
        update cDoc;
        
        //        return createRecordForUploadFile();
        return getFile(recordId);
    }
 
    @AuraEnabled
    public static List<ContentDocumentLink> getFile(String recordId){  
        
        System.debug('recordId '+ recordId);
        List<ContentDocumentLink> cdl = [SELECT id,ContentDocumentId,LinkedEntityId,ContentDocument.title,ContentDocument.FileExtension, ContentDocument.FileType,  ContentDocument.CreatedDate, ContentDocument.ArchivedDate 
                                         FROM ContentDocumentLink 
                                         WHERE LinkedEntityId  = : recordId];
        
        return cdl;
    }
    
    @AuraEnabled
    public static string Attachment(Id DownloadAttachmentID, String s){
        
		String fullFileURL;
        String URlDownload;

        if(s == 'D'){
            ContentVersion oldCV = [Select Id,Title from ContentVersion Where ContentDocumentId=:DownloadAttachmentID and IsLatest = true ];
            System.Debug('Old LV INitial :'+ oldCV.Id);
            fullFileURL = URL.getSalesforceBaseUrl().toExternalForm();
            URlDownload = fullFileURL+'/sfc/servlet.shepherd/version/download/'+oldCV.Id;
            system.debug('Download URL:' +URlDownload);
            return URlDownload;
        }else{
//            ContentVersion dCV = [Select Id,Title from ContentVersion Where ContentDocumentId=:DownloadAttachmentID and IsLatest = true ];
//            delete dCV;
            ContentDocument dCD = [SELECT Id FROM ContentDocument WHERE id=:DownloadAttachmentID ];
            delete dCD;
            return 'delete';
        }
    }
}