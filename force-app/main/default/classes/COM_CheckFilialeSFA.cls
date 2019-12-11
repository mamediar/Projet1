public with sharing class COM_CheckFilialeSFA {


    @AuraEnabled
    public static Case getActivity(String numPratica){

        Case actCase = [SELECT Id 
        FROM Case
        WHERE NumeroPratica__C = :numPratica];

        return actCase;
        
    }

    @AuraEnabled
    public static Map<String,String> getDatiPratica(String numPratica){

        Map<String,String> rdp = new Map <String,String>();

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

        return rdp;
        
    }


    @AuraEnabled
    public static List<ContentDocumentLink> finishUploadFile(String recordId, String documentId, String nameFile){  
        
        ContentVersion cv = [select id from contentversion where contentdocumentid = :documentId];
        ContentDistribution cd = new ContentDistribution();
        
        cd.Name = nameFile;
        cd.ContentVersionId = cv.id;
        cd.PreferencesAllowViewInBrowser= true;
        cd.PreferencesLinkLatestVersion=true;
        cd.PreferencesNotifyOnVisit=false;
        cd.PreferencesPasswordRequired=false;
        cd.PreferencesAllowOriginalDownload= true;        
        insert cd;
        
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
    
}