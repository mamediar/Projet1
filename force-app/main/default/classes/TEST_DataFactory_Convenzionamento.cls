@IsTest
public class TEST_DataFactory_Convenzionamento {

     public static void SetupAccolli(){
         
        Integer myIntDateE = integer.valueOf('30');
   		Integer myIntMonthE = integer.valueOf('12');
   		Integer myIntYearE = integer.valueOf('3999');
   		Date dataFine = Date.newInstance(myIntYearE, myIntMonthE, myIntDateE);
        
        Integer myIntDateS = integer.valueOf('01');
   		Integer myIntMonthS = integer.valueOf('12');
   		Integer myIntYearS = integer.valueOf('2016');
   		Date dataInizio = Date.newInstance(myIntYearS, myIntMonthS, myIntDateS);
        
        Integer myIntDateR = integer.valueOf('21');
   		Integer myIntMonthR = integer.valueOf('09');
   		Integer myIntYearR = integer.valueOf('2019');
   		Date dataRif = Date.newInstance(myIntYearR, myIntMonthR, myIntDateR);
        
        List<XCS_Disposition__c> DispositionList = new List<XCS_Disposition__c>();
        List<Accolli_Type_List__c> AccolliTypeList = new List<Accolli_Type_List__c>();
        List<SFAConvenzDealerDocumentsList__c> DocumentsList = new List<SFAConvenzDealerDocumentsList__c>();
        List<SFAConvenzDealerDocumentsTipoConvCO__c> ListDocConvCO = new List<SFAConvenzDealerDocumentsTipoConvCO__c>();
        List<Account> AccountList = new List<Account>();
        List<XCS_Categoria__c> CategoriaList = new List<XCS_Categoria__c>();
        List<Dossier__c> DossAccList = new List<Dossier__c>();
        List<SFADossierDocumento__c> DossierDocumList = new List<SFADossierDocumento__c>();
        
        XCS_Categoria__c CategDossier = new XCS_Categoria__c (External_Id__c = '1879',  Name = 'Gestione Dossier Convenzionamento');
        CategoriaList.add(CategDossier);
        
        XCS_Categoria__c CategAccollo = new XCS_Categoria__c (External_Id__c = '3709',  Name = 'Gestione Accolli Filiale');   
        CategoriaList.add(CategAccollo);
        
         XCS_Categoria__c CategDaSede = new XCS_Categoria__c (External_Id__c = '2324',  Name = 'Gestione Accolli Convenzionamento');   
        CategoriaList.add(CategDaSede);
         
        FObject obj = new FObject('User', 1);
        obj.setDefinition('username','static value(test@lynxspa.com)');
		obj.setDefinition('ProfileId', 'static lookup(Profile) field(Name) value(Branch Employee) source(salesforce)');
		obj.insertRecords(true);
         
        System.assert(obj.getInsertedRecords().size()>0,'USER NOT INSERTED');      
        User u=(User)(obj.getInsertedRecords()[0]);        
        User UserId=[select id from user where username=:u.username][0];
         
         
        insert CategoriaList;
        
        ApiRest__c ApiRest1 = new ApiRest__c(ref__c= 'CompassInternal',Method__c = 'POST' ,Test_Response__c='{"statusCode":200,"status":"OK","resultMessage":"Ok","resultCode":0,"recuperaLogAzioniIntermediarioResponse":{"elenco":[{"utente":"9K","stato":"AT","dataRiferimento":"20190921"},{"utente":"00","stato":"IS" ,"dataRiferimento":"20190911"}]}}',Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaLogAzioniIntermediario',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      		
        insert ApiRest1;
        
       	ApiRest__c ApiRest2 = new ApiRest__c(Method__c = 'POST' , Test_Response__c= '', Test_Request__c = 'testRequest', Mock__c = false, User__c = 'CDSLF00',Password__c = 'P00FLSDC' , Name =RientroAddendumConvenzionatoInvoker.SERVICE_NAME,Ref__c='CompassInternal',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
        insert ApiRest2;
        
        ApiUtil__c ApiUtil1 = new ApiUtil__c (Name='CompassInternal',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute',Password__c='P00FLSDC',Ref__c ='CompassInternal',User__c ='CDSLF00');
        insert ApiUtil1;
        
        XCS_Disposition__c DispCF = new XCS_Disposition__c(External_Id__c = 'DP1908', Livello__c = 2,  Name = 'Dossier Convenzionamento');
        DispositionList.add(DispCF);
        XCS_Disposition__c DispCF0 = new XCS_Disposition__c(External_Id__c = 'DP3740', Livello__c = 2,  Name = 'Accollo Completo Filiale');
        DispositionList.add(DispCF0);
        XCS_Disposition__c DispCF1 = new XCS_Disposition__c(External_Id__c = 'DP3741', Livello__c = 2,  Name = 'Accollo incompleto IDM');
        DispositionList.add(DispCF1);
        XCS_Disposition__c DispCF2 = new XCS_Disposition__c(External_Id__c = 'DP3742', Livello__c = 2,  Name = 'Accollo completo IDM');
        DispositionList.add(DispCF2);
        XCS_Disposition__c DispCF3 = new XCS_Disposition__c(External_Id__c = 'DP3743', Livello__c = 2,  Name = 'Accollo incompleto MD');
        DispositionList.add(DispCF3);
        XCS_Disposition__c DispCF8 = new XCS_Disposition__c(External_Id__c = 'DP5518', Livello__c = 2,  Name = 'Accollo annullato MD');
        DispositionList.add(DispCF8);
        XCS_Disposition__c DispCF5 = new XCS_Disposition__c(External_Id__c = 'DP3745', Livello__c = 2,  Name = 'Accollo approvato MD');
        DispositionList.add(DispCF5);
        XCS_Disposition__c DispCF6 = new XCS_Disposition__c(External_Id__c = 'DP3746', Livello__c = 2,  Name = 'Accollo respinto MD');
        DispositionList.add(DispCF6);
        XCS_Disposition__c DispCF4 = new XCS_Disposition__c(External_Id__c = 'DP3744', Livello__c = 2,  Name = 'Accollo sospeso MD');
        DispositionList.add(DispCF4);
        
        insert DispositionList;
        
        RecordType Rec = [Select Id from RecordType where DeveloperName='Dealer'];
      //  RecordType RecCon = [Select Id from RecordType where DeveloperName='Person Account'];
        
        Accolli_Type_List__c TipiAccolloGDO = new Accolli_Type_List__c (Accollo_Type_Code__c='ACC_GDO',Accollo_Type_Desc_Abrev__c='Addendum GDO',Accollo_Type_Desc__c='Addendum (Precarico GDO - Utenze nominative - Volantino Dealer');
        AccolliTypeList.add(TipiAccolloGDO); 
        Accolli_Type_List__c TipiAccolloDEL = new Accolli_Type_List__c (Accollo_Type_Code__c='ACC_DEL',Accollo_Type_Desc_Abrev__c='	Delega',Accollo_Type_Desc__c='Delega');
 		AccolliTypeList.add(TipiAccolloDEL);

        insert AccolliTypeList;
        
        SFAConvenzDealerDocumentsList__c  DocListM = new SFAConvenzDealerDocumentsList__c ( CodDocument__c ='ADD_GDO', Document__c ='Addendum GDO Proposta',IdDocument__c='43');
        DocumentsList.add(DocListM);
        SFAConvenzDealerDocumentsList__c  DocListA = new SFAConvenzDealerDocumentsList__c ( CodDocument__c ='DOCAGG', Document__c ='Documentazione Aggiuntiva',IdDocument__c='29');
        DocumentsList.add(DocListA);
        SFAConvenzDealerDocumentsList__c DocListDel = new SFAConvenzDealerDocumentsList__c(CodDocument__c ='ACCDL_1',Document__c='Originale del modulo Delega (COM046)',IdDocument__c='10');
        DocumentsList.add(DocListDel);
        
        SFAConvenzDealerDocumentsList__c  DocListDossM = new SFAConvenzDealerDocumentsList__c ( CodDocument__c ='DIC_ANT', Document__c ='Dichiarazione corso Antiriciclaggio',IdDocument__c='42');
        DocumentsList.add(DocListDossM);
        SFAConvenzDealerDocumentsList__c  DocListDossA = new SFAConvenzDealerDocumentsList__c ( CodDocument__c ='ISDLGT', Document__c ='Delega (COM046) e Copia fronte e retro dei documenti d identità dei soggetti delegati',IdDocument__c='15');
        DocumentsList.add(DocListDossA); 
         
        insert DocumentsList;
        
        SFAConvenzDealerDocumentsTipoConvCO__c DocConvCoM = new SFAConvenzDealerDocumentsTipoConvCO__c(DateEnd__c= dataFine,DateStart__c=dataInizio, DocumentDetails__c='Addendum GDO Proposta',DocumentType__c='mandatory',IdxDocument__c='43',TipoConv__c='ACC_GDO');
        ListDocConvCO.add(DocConvCoM);
        SFAConvenzDealerDocumentsTipoConvCO__c DocConvCoA = new SFAConvenzDealerDocumentsTipoConvCO__c(DateEnd__c= dataFine,DateStart__c=dataInizio, DocumentDetails__c='Documentazione Aggiuntiva',DocumentType__c='additional',IdxDocument__c='29',TipoConv__c='ACC_GDO');
        ListDocConvCO.add(DocConvCoA);
        SFAConvenzDealerDocumentsTipoConvCO__c DocConvCoDel = new SFAConvenzDealerDocumentsTipoConvCO__c(DateEnd__c= dataFine,DateStart__c=dataInizio, DocumentDetails__c='Originale del modulo Delega (COM046)',DocumentType__c='mandatory',IdxDocument__c='10',TipoConv__c='ACC_DEL');
        ListDocConvCO.add(DocConvCoDel);
         
        SFAConvenzDealerDocumentsTipoConvCO__c DocDossierM = new SFAConvenzDealerDocumentsTipoConvCO__c(DateEnd__c= dataFine,DateStart__c=dataInizio, DocumentDetails__c='Dichiarazione corso Antiriciclaggio',DocumentType__c='mandatory',IdxDocument__c='42',TipoConv__c='Q_CV');
        ListDocConvCO.add(DocDossierM);
        SFAConvenzDealerDocumentsTipoConvCO__c DocDossierA = new SFAConvenzDealerDocumentsTipoConvCO__c(DateEnd__c= dataFine,DateStart__c=dataInizio, DocumentDetails__c='Delega (COM046) e Copia fronte e retro dei documenti d identità dei soggetti delegati',DocumentType__c='additional',IdxDocument__c='15',TipoConv__c='Q_CV');
        ListDocConvCO.add(DocDossierA);
        
        insert ListDocConvCO;
            
        Account Acc1 = new Account ( Name= 'Test1Accollo', RecordTypeId = Rec.id , Codice_Fiscale__c  = 'RTUMRN89C02R800Q', OCS_External_Id__c = 'D123456', Tipo_Intermediario__c='PV',DealerPersonaRiferimentoEmail__c ='io@tu.it', Telefono_Cellulare__c='023546272');
 		AccountList.add(Acc1);        
        Account Acc2 = new Account ( Name= 'Test2Accollo', RecordTypeId = Rec.id , Codice_Fiscale__c  = 'RTUMRN89C02R800R', OCS_External_Id__c = 'D123457', Tipo_Intermediario__c='',DealerPersonaRiferimentoEmail__c ='io@tu.it', Telefono_Cellulare__c='023546274');
 		AccountList.add(Acc2); 
        Account Acc3 = new Account ( Name= 'Test3Accollo', RecordTypeId = Rec.id , Codice_Fiscale__c  = 'RTUMRN89C02R800G', OCS_External_Id__c = 'D123458', Tipo_Intermediario__c='CV',DealerPersonaRiferimentoEmail__c ='io@tu.it', Telefono_Cellulare__c='023546274');
 		AccountList.add(Acc3); 
        Account Acc4 = new Account ( Name= 'Test4Accollo', RecordTypeId = Rec.id , Codice_Fiscale__c  = 'RTUMRN89C02R800K', OCS_External_Id__c = 'D123459', Tipo_Intermediario__c='PV',DealerPersonaRiferimentoEmail__c ='io@tu.it', Telefono_Cellulare__c='023546273');
 		AccountList.add(Acc4); 
        Account Acc5 = new Account ( Name= 'Test5Accollo', RecordTypeId = Rec.id , Codice_Fiscale__c  = 'RTUMRN89C02R800N', OCS_External_Id__c = 'D123460', Tipo_Intermediario__c='PV',DealerPersonaRiferimentoEmail__c ='io@tu.it', Telefono_Cellulare__c='023546273');
 		AccountList.add(Acc5); 
    //    Account AcCont = New Account(RecordTypeId= RecCon.id, Lastname ='XXX', OCS_External_Id__c='N00000');
    //    AccountList.add(AcCont); 
         
        insert AccountList;
         
    //    Contact Cont = New Contact (lastname='yyy',AccountId = AcCont.Id ); 
    //    insert Cont;
        Date today = Date.today();
        
        Case CaseDossier = CaseUtils.getCase(RecordTypeUtil.SFA_CONVENZIONAMENTO,XCS_CategoriaUtil.SFA_CONVENZIONAMENTO_GESTIONE_DOSSIER_DEALER);
        CaseDossier = XCS_DispositionUtils.aggiungiDispositionCase(CaseDossier, XCS_DispositionUtils.NUOVO_DOSSIER);
        CaseDossier.AccountId = Acc3.id;
        CaseDossier.StepAttivitaConvenzionamento__c=SFAConvenzionamento.GDD_DocumentiObbligatori;   
        CaseDossier.Subject=CaseUtils.SFA_SUBJECT_GESTIONE_DOSSIER;
        caseDossier.Status='Gestito';
        CaseDossier.DataCreazioneDossier__c=datetime.now();
      //  CaseList.add(CaseDossier);
        insert CaseDossier;
        String caseNumber = [SELECT Id, CaseNumber FROM Case WHERE Id = :CaseDossier.Id][0].CaseNumber;
        
        Dossier__c dossier = new Dossier__c();
        dossier.IdAttivita__c = CaseDossier.Id;
        dossier.Tipo__c = 'Dossier';
        dossier.TipoChecklist__c = 'Q_CV';
        dossier.DataRiferimento__c = dataRif;
        dossier.Name = DateUtils.formatDateYYMMDD(today)+'-'+caseNumber;
        DossAccList.add(dossier);
      
        
        Case CaseAccollo = CaseUtils.getCase(RecordTypeUtil.SFA_CONVENZIONAMENTO,XCS_CategoriaUtil.SFA_CONVENZIONAMENTO_GESTIONE_ACCOLLO_DEALER);
        CaseAccollo = XCS_DispositionUtils.aggiungiDispositionCase(CaseAccollo, XCS_DispositionUtils.NUOVO_ACCOLLO);
        CaseAccollo.AccountId = Acc4.id;
        CaseAccollo.StepAttivitaConvenzionamento__c=SFAConvenzionamento.GAD_DocumentiObbligatori;   
        CaseAccollo.Subject=CaseUtils.SFA_SUBJECT_GESTIONE_ACCOLLO;
        CaseAccollo.DataCreazioneDossier__c=datetime.now();
        
        Insert CaseAccollo;
        
        String caseNumber2 = [SELECT Id, CaseNumber FROM Case WHERE Id = :CaseAccollo.Id][0].CaseNumber;
        
        Dossier__c Accollo = new Dossier__c();
        Accollo.IdAttivita__c = CaseAccollo.Id;
        Accollo.Tipo__c = 'Accollo';
        Accollo.DataRiferimento__c = Date.today()-5;
        Accollo.Name = DateUtils.formatDateYYMMDD(Date.today())+'-'+caseNumber2;
        DossAccList.add(Accollo);
        
       
        Case CaseAccollo2 = CaseUtils.getCase(RecordTypeUtil.SFA_CONVENZIONAMENTO,XCS_CategoriaUtil.SFA_CONVENZIONAMENTO_GESTIONE_ACCOLLO_DEALER);
        CaseAccollo2 = XCS_DispositionUtils.aggiungiDispositionCase(CaseAccollo2, XCS_DispositionUtils.NUOVO_ACCOLLO);
        CaseAccollo2.AccountId = Acc5.id;
        CaseAccollo2.StepAttivitaConvenzionamento__c=SFAConvenzionamento.GAD_DocumentiObbligatori;   
        CaseAccollo2.Subject=CaseUtils.SFA_SUBJECT_GESTIONE_ACCOLLO;
        CaseAccollo2.OCSExternalFilialeConvenzionato__c='F80';
        CaseAccollo2.Owner_User__c = UserId.Id;
        CaseAccollo2.DataCreazioneDossier__c=datetime.now();
        
        Insert CaseAccollo2;
        
        String caseNumber3 = [SELECT Id, CaseNumber FROM Case WHERE Id = :CaseAccollo2.Id][0].CaseNumber;
        
        Dossier__c Accollo2 = new Dossier__c();
        Accollo2.IdAttivita__c = CaseAccollo2.Id;
        Accollo2.Tipo__c = 'Accollo';
        Accollo2.DataRiferimento__c = Date.today()-5;
        Accollo2.Name = DateUtils.formatDateYYMMDD(Date.today())+'-'+caseNumber3;
        DossAccList.add(Accollo2);
        
        insert DossAccList;
         
        SFAConvenzDealerDocumentsList__c DocListMand = [SELECT Id FROM SFAConvenzDealerDocumentsList__c where IdDocument__c='43'];
        SFAConvenzDealerDocumentsList__c DocListAddiz = [SELECT Id FROM SFAConvenzDealerDocumentsList__c where IdDocument__c='29'];
         
        SFADossierDocumento__c AccolloDocumento = new SFADossierDocumento__c();
        AccolloDocumento.Dossier__c = Accollo2.Id;
        AccolloDocumento.SFAConvenzDealerDocumentsList__c =DocListMand.Id;
        AccolloDocumento.TipoConv__c = 'ACC_GDO';
        AccolloDocumento.Rimozione_Logica__c=false;
        AccolloDocumento.DocumentType__c = 'mandatory';
        DossierDocumList.add(AccolloDocumento);
         
        SFADossierDocumento__c AccolloDocumentoA = new SFADossierDocumento__c();
        AccolloDocumentoA.Dossier__c = Accollo2.Id;
        AccolloDocumentoA.SFAConvenzDealerDocumentsList__c =DocListAddiz.Id;
        AccolloDocumentoA.TipoConv__c = 'ACC_GDO';
        AccolloDocumentoA.Rimozione_Logica__c=false;
        AccolloDocumentoA.DocumentType__c = 'additional';
        DossierDocumList.add(AccolloDocumentoA);
        
         
        SFADossierDocumento__c DossierDocumento = new SFADossierDocumento__c();
        DossierDocumento.Dossier__c = dossier.Id;
        DossierDocumento.SFAConvenzDealerDocumentsList__c =DocListMand.Id;
        DossierDocumento.TipoConv__c = 'ACC_GDO';
        DossierDocumento.Rimozione_Logica__c=false;
        DossierDocumento.DocumentType__c = 'mandatory';
        DossierDocumList.add(DossierDocumento);
         
        SFADossierDocumento__c DossierDocumentoA = new SFADossierDocumento__c();
        DossierDocumentoA.Dossier__c = dossier.Id;
        DossierDocumentoA.SFAConvenzDealerDocumentsList__c =DocListAddiz.Id;
        DossierDocumentoA.TipoConv__c = 'ACC_GDO';
        DossierDocumentoA.Rimozione_Logica__c=false;
        DossierDocumentoA.DocumentType__c = 'additional';
        DossierDocumList.add(DossierDocumentoA); 
         
        insert DossierDocumList;

        
        Accolli_Type_List__c AccDel =[SELECT Id from Accolli_Type_List__c where Accollo_Type_Code__c='ACC_GDO'] ;
        
        Accolli_Type__c jO = New Accolli_Type__c();
        jO.Accollo_Id__c=Accollo2.Id;
        jO.AccolloType__c=AccDel.id;
        jo.Rimozione_Logica__c =false;
        Insert jO;    
        
     }
    
    public static void  SetupDossier(){    
                
   		Integer myIntDateE = integer.valueOf('30');
   		Integer myIntMonthE = integer.valueOf('12');
   		Integer myIntYearE = integer.valueOf('3999');
   		Date dataFine = Date.newInstance(myIntYearE, myIntMonthE, myIntDateE);
        
        Integer myIntDateS = integer.valueOf('01');
   		Integer myIntMonthS = integer.valueOf('12');
   		Integer myIntYearS = integer.valueOf('2016');
   		Date dataInizio = Date.newInstance(myIntYearS, myIntMonthS, myIntDateS);
        
        Integer myIntDateR = integer.valueOf('21');
   		Integer myIntMonthR = integer.valueOf('09');
   		Integer myIntYearR = integer.valueOf('2019');
   		Date dataRif = Date.newInstance(myIntYearR, myIntMonthR, myIntDateR);
        
        List<XCS_Disposition__c> DispositionList = new List<XCS_Disposition__c>();
        List<Accolli_Type_List__c> AccolliTypeList = new List<Accolli_Type_List__c>();
        List<SFAConvenzDealerDocumentsList__c> DocumentsList = new List<SFAConvenzDealerDocumentsList__c>();
        List<SFAConvenzDealerDocumentsTipoConvCO__c> ListDocConvCO = new List<SFAConvenzDealerDocumentsTipoConvCO__c>();
        List<Account> AccountList = new List<Account>();
        List<XCS_Categoria__c> CategoriaList = new List<XCS_Categoria__c>();
        List<Dossier__c> DossAccList = new List<Dossier__c>();
         List<SFADossierDocumento__c> DossierDocumList = new List<SFADossierDocumento__c>();
        
         FObject obj = new FObject('User', 1);
        obj.setDefinition('username','static value(test@lynxspa.com)');
		obj.setDefinition('ProfileId', 'static lookup(Profile) field(Name) value(Branch Employee) source(salesforce)');
		obj.insertRecords(true);
         
        System.assert(obj.getInsertedRecords().size()>0,'USER NOT INSERTED');      
        User u=(User)(obj.getInsertedRecords()[0]);        
        User UserId=[select id from user where username=:u.username][0];
        
        XCS_Categoria__c CategDossier = new XCS_Categoria__c (External_Id__c = '1879',  Name = 'Gestione Dossier Convenzionamento');
        CategoriaList.add(CategDossier);
        
        insert CategoriaList;
        
        ApiRest__c ApiRest1 = new ApiRest__c(ref__c= 'CompassInternal',Method__c = 'POST' ,Test_Response__c='',Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaLogAzioniIntermediario',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      		
        insert ApiRest1;
        ApiRest__c ApiRest2 = new ApiRest__c(ref__c= 'CompassInternal',Method__c = 'POST' ,Test_Response__c='',Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.collegatiDealerRuoli',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      		
		insert ApiRest2;
        
        ApiUtil__c ApiUtil1 = new ApiUtil__c (Name='CompassInternal',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute',Password__c='P00FLSDC',Ref__c ='CompassInternal',User__c ='CDSLF00');
        insert ApiUtil1;
        
        XCS_Disposition__c DispCF = new XCS_Disposition__c(External_Id__c = 'DP1908', Livello__c = 2,  Name = 'Dossier Convenzionamento');
        DispositionList.add(DispCF);
        XCS_Disposition__c DispCF0 = new XCS_Disposition__c(External_Id__c = 'DP1909', Livello__c = 2,  Name = 'Dossier - Completo - in spedizione');
        DispositionList.add(DispCF0);
        XCS_Disposition__c DispCF1 = new XCS_Disposition__c(External_Id__c = 'DP1912', Livello__c = 2,  Name = 'Dossier - Incompleto - IDM');
        DispositionList.add(DispCF1);
        XCS_Disposition__c DispCF2 = new XCS_Disposition__c(External_Id__c = 'DP1911', Livello__c = 2,  Name = 'Dossier Disponibile');
        DispositionList.add(DispCF2);
        XCS_Disposition__c DispCF3 = new XCS_Disposition__c(External_Id__c = 'DP1914', Livello__c = 2,  Name = 'Dossier - Incompleto - MD');
        DispositionList.add(DispCF3);
        XCS_Disposition__c DispCF5 = new XCS_Disposition__c(External_Id__c = 'DP1913', Livello__c = 2,  Name = 'Dossier - Approvato');
        DispositionList.add(DispCF5);
        XCS_Disposition__c DispCF6 = new XCS_Disposition__c(External_Id__c = 'DP1915', Livello__c = 2,  Name = 'Dossier - Respinto (Delaer CH)');
        DispositionList.add(DispCF6);
        XCS_Disposition__c DispCF4 = new XCS_Disposition__c(External_Id__c = 'DP2086', Livello__c = 2,  Name = 'Dossier - Sospeso - MD');
        DispositionList.add(DispCF4);
        
        insert DispositionList;
        
    	XCS_CompassParameters__c CSParam = new XCS_CompassParameters__c(Name='monitoraggioDealer.mail',Value__c='luca.ravicini@lynxspa.com');
		insert  CSParam; 
        
        RecordType Rec = [Select Id from RecordType where DeveloperName='Dealer'];
        RecordType RecCon = [Select Id from RecordType where DeveloperName='PersonAccount'];
        
        SFAConvenzDealerDocumentsList__c  DocListM = new SFAConvenzDealerDocumentsList__c ( CodDocument__c ='DIC_ANT', Document__c ='Dichiarazione corso Antiriciclaggio',IdDocument__c='42');
        DocumentsList.add(DocListM);
        SFAConvenzDealerDocumentsList__c  DocListA = new SFAConvenzDealerDocumentsList__c ( CodDocument__c ='ANTIR', Document__c ='E necessario il Questionario Antiriciclaggio? (Titolare effettivo diverso dal firmatario della convenzione o piu titolari effettivi)',IdDocument__c='16');
        DocumentsList.add(DocListA);
        SFAConvenzDealerDocumentsList__c  DocListI = new SFAConvenzDealerDocumentsList__c ( CodDocument__c ='DOCID', Document__c ='Copia fronte e retro di un documento',IdDocument__c='13');
        DocumentsList.add(DocListI);
        
        insert DocumentsList;
        
        SFAConvenzDealerDocumentsTipoConvCO__c DocConvCoM = new SFAConvenzDealerDocumentsTipoConvCO__c(DateEnd__c= dataFine,DateStart__c=dataInizio, DocumentDetails__c='Dichiarazione corso Antiriciclaggio',DocumentType__c='mandatory',IdxDocument__c='42',TipoConv__c='Q_CV');
        ListDocConvCO.add(DocConvCoM);
        SFAConvenzDealerDocumentsTipoConvCO__c DocConvCoA = new SFAConvenzDealerDocumentsTipoConvCO__c(DateEnd__c= dataFine,DateStart__c=dataInizio, DocumentDetails__c='Questionario Antiriciclaggio',DocumentType__c='additional',IdxDocument__c='16',TipoConv__c='Q_CV');
        ListDocConvCO.add(DocConvCoA);
        SFAConvenzDealerDocumentsTipoConvCO__c DocConvCoI = new SFAConvenzDealerDocumentsTipoConvCO__c(DateEnd__c= dataFine,DateStart__c=dataInizio, DocumentDetails__c='',DocumentType__c='identity',IdxDocument__c='13',TipoConv__c='Q_CV');
        ListDocConvCO.add(DocConvCoI);
        
        insert ListDocConvCO;
            
        Account Acc1 = new Account ( Name= 'Test1Dossier', RecordTypeId = Rec.id , Codice_Fiscale__c  = 'RTUMRN89C02R800Q', OCS_External_Id__c = 'D123456', Tipo_Intermediario__c='CV',DealerPersonaRiferimentoEmail__c ='io@tu.it', Telefono_Cellulare__c='023546272');
 		AccountList.add(Acc1);        
        Account Acc2 = new Account ( Name= 'Test2Dossier', RecordTypeId = Rec.id , Codice_Fiscale__c  = 'RTUMRN89C02R800R', OCS_External_Id__c = 'D123457', Tipo_Intermediario__c='',DealerPersonaRiferimentoEmail__c ='io@tu.it', Telefono_Cellulare__c='023546274');
 		AccountList.add(Acc2); 
        Account Acc3 = new Account ( Name= 'Test3Dossier', RecordTypeId = Rec.id , Codice_Fiscale__c  = 'RTUMRN89C02R800G', OCS_External_Id__c = 'D123458', Tipo_Intermediario__c='CV',DealerPersonaRiferimentoEmail__c ='io@tu.it', Telefono_Cellulare__c='023546274');
 		AccountList.add(Acc3); 
        Account Acc4 = new Account ( Name= 'Test4Dossier', RecordTypeId = Rec.id , Codice_Fiscale__c  = 'RTUMRN89C02R800K', OCS_External_Id__c = 'D123459', Tipo_Intermediario__c='PV',DealerPersonaRiferimentoEmail__c ='io@tu.it', Telefono_Cellulare__c='023546273');
 		AccountList.add(Acc4); 
        Account AcCont = New Account(RecordTypeId= RecCon.id, Lastname ='XXX', OCS_External_Id__c='N00000');
        AccountList.add(AcCont); 
         
        insert AccountList;
         
     //   Contact Cont = New Contact (lastname='yyy',AccountId = AcCont.Id ); 
     //   insert Cont;
        
        Date today = Date.today();
        
        Case CaseDossier = CaseUtils.getCase(RecordTypeUtil.SFA_CONVENZIONAMENTO,XCS_CategoriaUtil.SFA_CONVENZIONAMENTO_GESTIONE_DOSSIER_DEALER);
        CaseDossier = XCS_DispositionUtils.aggiungiDispositionCase(CaseDossier, XCS_DispositionUtils.NUOVO_DOSSIER);
        CaseDossier.AccountId = Acc3.id;
        CaseDossier.StepAttivitaConvenzionamento__c=SFAConvenzionamento.GDD_DocumentiObbligatori;   
        CaseDossier.Subject=CaseUtils.SFA_SUBJECT_GESTIONE_DOSSIER;
        caseDossier.Status='Gestito';
        caseDossier.OCSExternalFilialeConvenzionato__c='F80';
        caseDossier.Owner_User__c = UserId.Id;
        CaseDossier.DataCreazioneDossier__c=datetime.now();
      //  CaseList.add(CaseDossier);
        insert CaseDossier;
        String caseNumber = [SELECT Id, CaseNumber FROM Case WHERE Id = :CaseDossier.Id][0].CaseNumber;
        
        Dossier__c dossier = new Dossier__c();
        dossier.IdAttivita__c = CaseDossier.Id;
        dossier.Tipo__c = 'Dossier';
        dossier.TipoChecklist__c = 'Q_CV';
        dossier.DataRiferimento__c = dataRif-10;
        dossier.Name = DateUtils.formatDateYYMMDD(today)+'-'+caseNumber;
        DossAccList.add(dossier);
        insert DossAccList;
  /*      
        SFADossierDocumento__c DossierDocumento = new SFADossierDocumento__c();
        DossierDocumento.Dossier__c = dossier.Id;
        DossierDocumento.SFAConvenzDealerDocumentsList__c =DocListM.Id;
        DossierDocumento.TipoConv__c = 'Q_CV';
        DossierDocumento.Rimozione_Logica__c=false;
        DossierDocumento.DocumentType__c = 'mandatory';
        DossierDocumList.add(DossierDocumento);
         
        SFADossierDocumento__c DossierDocumentoA = new SFADossierDocumento__c();
        DossierDocumentoA.Dossier__c = dossier.Id;
        DossierDocumentoA.SFAConvenzDealerDocumentsList__c =DocListA.Id;
        DossierDocumentoA.TipoConv__c = 'Q_CV';
        DossierDocumentoA.Rimozione_Logica__c=false;
        DossierDocumentoA.DocumentType__c = 'additional';
        DossierDocumList.add(DossierDocumentoA); 

   		insert DossierDocumList;*/        
    }
    
    public static Map<String,List<String>> PopolaMappa() {

		Map<String,List<String>> serviceIdResponseMap = new Map<String,List<String>>();
		List<String> responses = new List<String>();
        responses.add('{"statusCode":200,"status":"OK","resultMessage":"Ok","resultCode":0,"recuperaLogAzioniIntermediarioResponse":{"elenco":[{"utente":"9K","stato":"AT","dataRiferimento":"20190921"},{"utente":"00","stato":"IS" ,"dataRiferimento":"20190911"}]}}');
        serviceIdResponseMap.put('recuperaLogAzioniIntermediario', responses);

		List<String> responses2 = new List<String>();
        responses2.add('{"statusCode":200,"status":"OK","resultCode": 0, "resultMessage": "Ok", "datiCollegatiDealerRuoli": [{ "codCliente": "10984485","cognome": "LOIBN", "nome": "ERMELINDO","firmatario": "N","rappresentante": "N","referente": "N","socio": "S","titolare": "N","responsabileISVAP": "N"}]}');
        serviceIdResponseMap.put('collegatiDealerRuoli', responses2);
        
        List<String> responses3 = new List<String>();
        responses3.add('{"statusCode":200,"status":"OK",resultCode":0,"resultMessage":"Ok","rientroAddendumConvenzionatoResponse":{"elenco":[{"partimestp":"20190924145651829507","codice":"16039294","stato":"003","tipint":"5","datainv":"20190911","nota":"003"}]}}');
        serviceIdResponseMap.put('rientroAddendumConvenzionato', responses3);
        
		return serviceIdResponseMap;
    } 
}