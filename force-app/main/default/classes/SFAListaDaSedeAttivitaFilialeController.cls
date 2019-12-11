public class SFAListaDaSedeAttivitaFilialeController {
    
    //case record type
    public static final String RECORD_TYPE_CASE = 'Liste_da_Sede';

    //Disposition level 1
    public static final String POSITIVO = 'Positivo';
    public static final String NEGATIVO = 'Negativo';
    public static final String SOSPESO = 'Sospeso';

    //case status
    public static final String CHIUSO = 'Chiuso';

    @AuraEnabled
    public static List<Case> getCaseList(){
        //TODO: impostare il filtro per prendere i case per filiale; (partendo dall'utente loggato)

        String query = 'SELECT Id,DealerName__c,CaseNumber,OwnerId,Priority,DueDate__c,ParentId,AccountId, ';
        query += 'Account.Name,Account.ShippingStreet,Account.ShippingPostalCode,Account.ShippingCity, ';
        query += 'Account.RecordType.Name,SFA_ListeCaricate__r.Tipo_Attivita__c, ';
        query += 'Categoria_Riferimento__c,Data_Visibilita__c,Totale__c,Branch__r.Name, ';
        query += 'Da_Esitare__c,Sospesi_Da_Esitare__c,Categoria_Riferimento__r.Name,Owner.Name, ';
        //query += 'SFA_ListeCaricate__r.Tipo_Attivita__r.Name,SFA_ListeCaricate__c,SFA_ListeCaricate__r.Nome_Lista__c ';
        query += 'SFA_ListeCaricate__r.Tipo_Attivita__r.Name,SFA_ListeCaricate__r.Tipo_Attivita__r.Descrizione__c,SFA_ListeCaricate__c,SFA_ListeCaricate__r.Nome_Lista__c, ';
        query += 'SFA_ListeCaricate__r.Tipo_Attivita__r.RSS_External_Id_act_code__c ';
        query += 'FROM Case ';
        query += 'WHERE ParentId = null '; 
        query += 'AND Status !=: CHIUSO ';
        query += 'AND RecordType.DeveloperName =: RECORD_TYPE_CASE ';
        query += 'AND Data_Visibilita__c <= TODAY ';
        query += 'ORDER BY LastModifiedDate DESC NULLS FIRST';
        return Database.query(query);
        //RSS_External_Id_act_code__c
    }

    @AuraEnabled
    public static List<Case> getCaseChildList(Id parentCaseId){
        String query = 'SELECT Id,DealerName__c,CaseNumber,OwnerId,Priority,DueDate__c,ParentId,AccountId, ';
        query += 'Account.Name,Account.ShippingStreet,Account.ShippingPostalCode,Account.ShippingCity, ';
        query += 'Account.RecordType.Name,SFA_ListeCaricate__r.Tipo_Attivita__c, ';
        query += 'Categoria_Riferimento__c,Data_Visibilita__c,Totale__c,Branch__r.Name, ';
        query += 'Da_Esitare__c,Sospesi_Da_Esitare__c,Categoria_Riferimento__r.Name,Owner.Name, ';
        //query += 'SFA_ListeCaricate__r.Tipo_Attivita__r.Name,SFA_ListeCaricate__c,SFA_ListeCaricate__r.Nome_Lista__c ';
        query += 'SFA_ListeCaricate__r.Tipo_Attivita__r.Name,SFA_ListeCaricate__r.Tipo_Attivita__r.Descrizione__c,SFA_ListeCaricate__c,SFA_ListeCaricate__r.Nome_Lista__c, ';
        query += 'SFA_ListeCaricate__r.Tipo_Attivita__r.RSS_External_Id_act_code__c ';
        query += 'FROM Case ';
        query += 'WHERE ParentId =: parentCaseId '; 
        query += 'AND Status !=: CHIUSO ';
        query += 'ORDER BY LastModifiedDate DESC NULLS FIRST ';
        return Database.query(query);
    }
    
    @AuraEnabled
    public static List<XCS_dealers_conv_activity_disp__c> getCaseEsitiList(Id caseActivity){
        //String query = 'SELECT Id,SFA_TipologiaLista__c,XCS_Disposition__c,XCS_Disposition__r.Parent__r.Name,FullDispositionName__c ';
        String query = 'SELECT Id,Codice_Attivita_Lista_da_Sede__c,Esito_1__c,Esito_1__r.Name,Esito_2__c,Esito_2__r.Name,FullDispositionName__c ';
        query += 'FROM XCS_dealers_conv_activity_disp__c ';
        query += 'WHERE Codice_Attivita_Lista_da_Sede__c =: caseActivity ';
        query += 'ORDER BY LastModifiedDate DESC NULLS FIRST ';
        return Database.query(query);
    }

/*
    private static Date recuperoDataRiferimento(String dealerOCSExternalId) {
        String codiceIntermediario = dealerOCSExternalId.Substring(1);
        OCSRecuperaLogAzioniIntermedResponse response = OCSRecuperaLogAzioniIntermedInvoker.recuperaLogAzioniIntermediario(codiceIntermediario);
        List<OCSRecuperaLogAzioniIntermedResponse.Elenco> listaStati = response.recuperaLogAzioniIntermediarioResponse.elenco;
        Date dataRiferimento = null;
        if (listaStati != null) {
            
           for (Integer i=0; i<listaStati.size(); i++) {
                dataRiferimento = DateUtils.parseFromYYYYMMDDString(listaStati.get(i).dataRiferimento);
           }
        }
        return dataRiferimento;
    }
*/

    private static void creaDocumentiXAccollo(String IdAccollo){
        List<SFAConvenzDealerDocumentsList__c> lstDocumenti = [SELECT Name, Id, IdDocument__c, CodDocument__c, Document__c, FlgEsclusione__c FROM SFAConvenzDealerDocumentsList__c];
        Map<String, String> mapDocumentiId = new Map<String, String>();
        for (SFAConvenzDealerDocumentsList__c documento : lstDocumenti) {
             mapDocumentiId.put(documento.IdDocument__c, documento.Id);
        }
        List<SFAConvenzDealerDocumentsTipoConvCO__c> lstDocumentiObbligatori = [SELECT Name, Id, IdDocumentTipoConv__c, IdxDocument__c, TipoConv__c, DateStart__c, DocumentType__c, DocumentDetails__c, DateEnd__c FROM SFAConvenzDealerDocumentsTipoConvCO__c WHERE TipoConv__c = 'ACC_GDO' AND DocumentType__c = 'mandatory' AND DateStart__c <= today AND DateEnd__c >= today];
        System.debug('creaDocumentiXAccollo lstDocumentiObbligatori :: ' + JSON.serialize(lstDocumentiObbligatori)); 
        List<SFAConvenzDealerDocumentsTipoConvCO__c> lstDocumentiAddizionali =  [SELECT Name, Id, IdDocumentTipoConv__c, IdxDocument__c, TipoConv__c, DateStart__c, DocumentType__c, DocumentDetails__c, DateEnd__c FROM SFAConvenzDealerDocumentsTipoConvCO__c WHERE TipoConv__c = 'ACC_GDO' AND DocumentType__c = 'additional' AND DateStart__c <= today AND DateEnd__c >= today];
        System.debug('creaDocumentiXAccollo lstDocumentiAddizionali :: ' + JSON.serialize(lstDocumentiAddizionali));
        List<SFADossierDocumento__c> lstAccolloDocumento = new List<SFADossierDocumento__c>(); 
        for (SFAConvenzDealerDocumentsTipoConvCO__c documento : lstDocumentiObbligatori) {
            SFADossierDocumento__c AccolloDocumento = new SFADossierDocumento__c();
            AccolloDocumento.Dossier__c = IdAccollo; //Creato in precedenza
            AccolloDocumento.SFAConvenzDealerDocumentsList__c = mapDocumentiId.get(documento.IdxDocument__c);
            AccolloDocumento.TipoConv__c = documento.TipoConv__c;
            AccolloDocumento.DocumentType__c = 'mandatory';
            lstAccolloDocumento.add(AccolloDocumento);
         }

        for (SFAConvenzDealerDocumentsTipoConvCO__c documento : lstDocumentiAddizionali) {
            SFADossierDocumento__c AccolloDocumento = new SFADossierDocumento__c();
            AccolloDocumento.Dossier__c = IdAccollo; //Creato in precedenza
            AccolloDocumento.SFAConvenzDealerDocumentsList__c = mapDocumentiId.get(documento.IdxDocument__c);
            AccolloDocumento.TipoConv__c = documento.TipoConv__c;
            AccolloDocumento.DocumentDetails__c = documento.DocumentDetails__c;
            AccolloDocumento.DocumentType__c = 'additional';
            lstAccolloDocumento.add(AccolloDocumento);    
         }
        try {       
            insert lstAccolloDocumento;
        }
        catch(exception e){
            system.debug('ERORR_INSERT: '+ e.getMessage());
        }
    } 

    private static void creaAccolloXSottoscrizioneUtente(Case caseSelected) {
        // per attività Sottoscrizione Utente
        if (caseSelected.SFA_ListeCaricate__r.Tipo_Attivita__r!=null && ('50' == caseSelected.SFA_ListeCaricate__r.Tipo_Attivita__r.RSS_External_Id_act_code__c)) {
            Case nuovoCaseAccollo = CaseUtils.getCase(RecordTypeUtil.SFA_CONVENZIONAMENTO,XCS_CategoriaUtil.SFA_CONVENZIONAMENTO_GESTIONE_ACCOLLO_DEALER);
            nuovoCaseAccollo = XCS_DispositionUtils.aggiungiDispositionCase(nuovoCaseAccollo, XCS_DispositionUtils.NUOVO_ACCOLLO);
            nuovoCaseAccollo.AccountId = caseSelected.AccountId; //Id dealer in contesto
            nuovoCaseAccollo.StepAttivitaConvenzionamento__c=SFAConvenzionamento.GAD_DocumentiObbligatori;   
    //        nuovoCaseAccollo.ActivityType__c=CaseUtils.SFA_GESTIONE_ACCOLLO_DEALER;   //new activity di Gestione Dossier
            nuovoCaseAccollo.Subject=CaseUtils.SFA_SUBJECT_GESTIONE_ACCOLLO;
            nuovoCaseAccollo.DataCreazioneDossier__c=datetime.now();
            Group queue = [SELECT Id, DeveloperName FROM Group WHERE ID=:caseSelected.OwnerId];
            nuovoCaseAccollo.OCSExternalFilialeConvenzionato__c = queue.DeveloperName; //filialeQueue; // Coda di filiale che dovra lavorare l'accollo
            Account dealerCaseSelected = [SELECT Id, OCS_External_Id__c FROM Account WHERE Id=:caseSelected.AccountId];
            System.debug('creaAccolloXSottoscrizioneUtente dealerCaseSelected.Id:'+dealerCaseSelected.Id);
            nuovoCaseAccollo = CaseUtils.assignToFilialeQueueByDealer(nuovoCaseAccollo,dealerCaseSelected.OCS_External_Id__c);
            SFAGestioneAccolloDealerAction.StatoAttributoData sad = SFAGestioneAccolloDealerAction.getStatoAttributoData(dealerCaseSelected.OCS_External_Id__c);
            insert nuovoCaseAccollo;           
            String caseNumber = [SELECT Id, CaseNumber FROM Case WHERE Id = :nuovoCaseAccollo.Id][0].CaseNumber;
            // Accollo: aspetta
            Dossier__c Accollo = new Dossier__c();
            Accollo.IdAttivita__c = nuovoCaseAccollo.Id;
            Accollo.Tipo__c = 'Accollo';
  //          Accollo.Dossier__c = DossierEsistente.Id;
            Accollo.DataRiferimento__c =  sad.dataRiferimento;  // Data ultima attivazione de delaer(In calce alla mail come recuperarla)
            Accollo.Name = DateUtils.formatDateYYMMDD(Date.today())+'-'+caseNumber;
            insert Accollo;  // Tipologia di Accollo
            Accolli_Type_List__c gdoType = [SELECT Id FROM Accolli_Type_List__c where Accollo_Type_Code__c ='ACC_GDO'];
            Accolli_Type__c accType = new Accolli_Type__c();
            accType.Accollo_Id__c=Accollo.Id;
            accType.AccolloType__c = gdoType.Id;
            accType.Rimozione_Logica__c= false;
            insert accType;
            creaDocumentiXAccollo(Accollo.Id);
        }
    }
    
    @AuraEnabled
    public static Boolean setEsitoCase(Case caseSelected, XCS_dealers_conv_activity_disp__c esito, String note){
        
        if(caseSelected!=null && esito!=null){
            //caseSelected.Disposition__c = esito.XCS_Disposition__c;
            caseSelected.Disposition__c = esito.Esito_2__c != null ? esito.Esito_2__c : esito.Esito_1__c;
            system.debug('@@@ LEVEL 2: '+esito.Esito_1__c);
            //if(esito.XCS_Disposition__r.Parent__r.Name != null){
            if(esito.Esito_1__r.Name != null){
                //String level = esito.XCS_Disposition__r.Parent__r.Name;
                String level = esito.Esito_1__r.Name;
               // system.debug('@@@ LEVEL 1: '+level);
                if(level.equalsIgnoreCase(POSITIVO) || level.equalsIgnoreCase(NEGATIVO)){
                    caseSelected.Status = CHIUSO;
                    if (level.equalsIgnoreCase(POSITIVO)) {
                        creaAccolloXSottoscrizioneUtente(caseSelected);
                    }
                }else if(level.equalsIgnoreCase(SOSPESO)){ 
                     caseSelected.Status = SOSPESO;
                }
            }

            if(String.isNotBlank(note)){
                caseSelected.Note__c = note;
            }

            update caseSelected;
            Case parent = getCaseChildInfo(caseSelected);
            system.debug('parent RET: '+parent);
            //update parent;
            return true;
        }

        return false;
    }

    @AuraEnabled
    public static Case getCaseChildInfo(Case parentCase){

        Integer childDaEsitare = 0;
        Integer childSospesiDaEsitare = 0;

        if(parentCase.ParentId!=null){
            //richiamo la funzione per il padre
            Case parent = [
                SELECT Id,Totale__c,Da_Esitare__c,Sospesi_Da_Esitare__c,ParentId,Disposition__c,Disposition__r.Parent__c,Disposition__r.Parent__r.Name
                FROM Case
                WHERE Id =: parentCase.ParentId
            ];
            getCaseChildInfo(parent);
        
        }else{

            List<Case> childCaseList = [
                SELECT Id,Totale__c,Da_Esitare__c,Sospesi_Da_Esitare__c,ParentId,Disposition__c,Disposition__r.Parent__c,Disposition__r.Parent__r.Name 
                FROM Case
                WHERE ParentId =: parentCase.Id
            ];
            if(childCaseList.size() > 0){
                parentCase.Totale__c = childCaseList.size();

                for(Case childCase : childCaseList){

                    if(childCase.Disposition__c == null){
                        childDaEsitare++;
                    }else{

                        if(childCase.Disposition__r.Parent__c != null && childCase.Disposition__r.Parent__r.Name.equalsIgnoreCase(SOSPESO)){
                            childSospesiDaEsitare++;
                        } 
                        
                    }
                    
                }

                parentCase.Da_Esitare__c = childDaEsitare;
                parentCase.Sospesi_Da_Esitare__c = childSospesiDaEsitare;
                if(System.isBatch()){
                    return parentCase;
                }else{

                    Integer childCaseChiusi = [
                        SELECT count() 
                        FROM Case
                        WHERE ParentId =: parentCase.Id AND Status != 'Chiuso'
                    ];

                    if(childCaseChiusi==0){
                        parentCase.Status='Chiuso';
                    }                    
                    update parentCase;
                }
                
            }

        }
        return parentCase;
  
    }

    @AuraEnabled
    public static String getfilialeFromOwnerId(Id ownerId){
        String filiale = [SELECT Name FROM Group WHERE Id =: ownerId].Name;
        return filiale;
    }

    /*
    @AuraEnabled
    public static Integer getTotalCase(Id parentCaseId){
        String query = 'SELECT count() FROM Case ';
        query += 'WHERE ParentId =: parentCaseId '; 
        return Database.countquery(query);
    }

    @AuraEnabled
    public static Integer getCaseDaEsitare(Case caseSelected){
        String query = 'SELECT count() FROM Case ';
        query += 'WHERE ParentId =: parentCaseId ';
        query += 'AND Disposition__c = null'; 
        return Database.countquery(query);
    }

    @AuraEnabled
    public static Integer getCaseSospesiDaEsitare(Case caseSelected){
        String query = 'SELECT count() FROM Case ';
        query += 'WHERE ParentId =: parentCaseId ';
        query += 'AND Disposition__r.Parnt__r.Name =: SOSPESO';
        return Database.countquery(query);
    }*/

}