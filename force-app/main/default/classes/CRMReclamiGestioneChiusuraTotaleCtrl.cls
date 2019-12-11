public without sharing  class CRMReclamiGestioneChiusuraTotaleCtrl {
        
    @AuraEnabled
    public static Case getCase(String recordId){
        System.debug('return case of chiusura');
        return [Select Abbuono_Chiusura__c, Importo_Abbouno_Chiusura__c,
                Has_Rimborso_Accordato__c, Rimborso_Accordato_Importo__c,
                F_Has_Rimborso_Commissioni_Out__c, F_Rimborso_Commissioni_Importo_Out__c,
                F_Has_Rimborso_Provvigioni_Out__c, F_Rimborso_Provvigioni_Importo_Out__c,
                F_Has_Rimborso_Assicurativo_Out__c, F_Rimborso_Assicurativo_Importo_Out__c,
                F_Rimborso_Varie_Importo_Out__c, F_Has_Rimborso_Varie_Out__c,
                F_Has_Rimborso_Spese_Legali_Out__c, F_Rimborso_Spese_Legali_Importo_Out__c,
                Has_Risarcimento_accordato__c, Risarcimento_Accordato_Importo__c,
                Has_Fondato__c,
                Accolto__c,
                Has_Allegati_Completi__c,
                Has_SIC__c, SIC__c,
                Has_Assicurative__c, Societa_Assicurative__c,
                Has_Recupero__c, Societa_di_Recupero__c,
                Has_Invio_Risposta_IDM__c,
                Attesa_Riscontro_Cliente__c,
                Decisione__c,
                Intervento_Autorita__c,
                Attesa_Assegno__c,Has_Responsabilita__c,Status  
                from case where id =: recordId];
    }
    
    /*
    @AuraEnabled
    public static List<String> getResponsabilita(String recordId){
        Case c = new Case(Id = recordId);
        List<String> responsabilita = AccountUtils.parsgetBranchFromId(XCSReclamiUtils.parsResponsabilitaBranch(c));
        System.debug('responsabilita = ' + responsabilita);
        return responsabilita;
    }
    */
    
    @AuraEnabled
    public static void salvaChiusuraReclamo(String recordId, Boolean isAbbuono, Double abbuonoImporto,
                                            Boolean isRimborso, Double rimborsoImporto,  Boolean isRimborsoComm, Double rimborsoImportoComm,
                                            Boolean isRimborsoProv, Double rimborsoImportoProv,  Boolean isRimborsoPrem, Double rimborsoImportoPrem,
                                            Boolean isRimborsoVar, Double rimborsoImportoVar, Boolean isRimborsoLeg, Double rimborsoImportoLeg,
                                            Boolean isRisarcimento, Double risarcimentoImportoValue, Boolean isFondato,
                                            String accolto, Boolean isAllegatiCompleti, Boolean isSic, String sic,
                                            Boolean isSocAss, String socAss, Boolean isSocRec, String socRec,
                                            Boolean isIdm, Boolean isRiscontro, Boolean isAssegno, String decisione,
                                            String autorita){
                                                /*
                                          System.debug('accolto = ' + accolto);
                                          System.debug('soc recuper = ' + socRec);      
                                          System.debug('autorita = ' + autorita);
                                          System.debug('sic = ' + sic);
                                                
                                                Case c = new Case(Id = recordId,
                                                                  Abbuono_Chiusura__c  = isAbbuono,
                                                                  Importo_Abbouno_Chiusura__c = abbuonoImporto,
                                                                  Has_Rimborso_Accordato__c = isRimborso,
                                                                  Rimborso_Accordato_Importo__c = rimborsoImporto,
                                                                  F_Has_Rimborso_Commissioni_Out__c = isRimborsoComm,
                                                                  F_Rimborso_Commissioni_Importo_Out__c = rimborsoImportoComm,
                                                                  F_Has_Rimborso_Provvigioni_Out__c = isRimborsoProv, 
                                                                  F_Rimborso_Provvigioni_Importo_Out__c = rimborsoImportoProv,
                                                                  F_Has_Rimborso_Assicurativo_Out__c = isRimborsoPrem, 
                                                                  F_Rimborso_Assicurativo_Importo_Out__c = rimborsoImportoPrem,
                                                                  F_Has_Rimborso_Varie_Out__c = isRimborsoVar,
                                                                  F_Rimborso_Varie_Importo_Out__c = rimborsoImportoVar,
                                                                  F_Has_Rimborso_Spese_Legali_Out__c = isRimborsoLeg,
                                                                  F_Rimborso_Spese_Legali_Importo_Out__c = rimborsoImportoLeg,
                                                                  Has_Risarcimento_accordato__c = isRisarcimento,
                                                                  Risarcimento_Accordato_Importo__c = risarcimentoImportoValue,
                                                                  Has_Fondato__c = isFondato,
                                                                  Accolto__c = accolto,
                                                                  Has_Allegati_Completi__c = isAllegatiCompleti,
                                                                  Has_SIC__c = isSic,
                                                                  SIC__c = sic,
                                                                  Has_Assicurative__c = isSocAss,
                                                                  Societa_Assicurative__c = socAss,
                                                                  Has_Recupero__c = isSocRec,
                                                                  Societa_di_Recupero__c = socRec,
                                                                  Has_Invio_Risposta_IDM__c = isIdm,
                                                                  Attesa_Riscontro_Cliente__c  = isRiscontro,
                                                                  Attesa_Assegno__c = isAssegno,
                                                                  Decisione__c = decisione,
                                                                  Intervento_Autorita__c = autorita
                                                                 );        
                                                try{
                                                update c;
                                                }
                                                catch(Exception e ){
                                                    System.debug('did not update anything...');
                                                }
*/
                                            }
    

    @AuraEnabled
    public static Map<String,Map<String,String>> getInitValues(case idcase){
        /*
perchè una mappa di mappe? la chiave della prima mappa identifica il campo(Picklist), mentre il valore è una
altra mappa in cui la chiave è la label e il valore è il developer name della label(questo perchè a video devo mostrare
i nomi dei valori delle picklist, ma lato back end devo lavorare con i developer Name)*/
        
        Map<String,Map<String,String>> ress = new Map<String,Map<String,String>>();        

        Map<String,String> accoltoApiLabel = new Map<String,String>();
        Map<String,String> decisioneApiLabel = new Map<String,String>();
        Map<String,String> interventoApiLabel = new Map<String,String>();
        Map<String,String> assicurazioniApiLabel = new Map<String,String>();
        Map<String,String> recuperoApiLabel = new Map<String,String>();
        Map<String,String> sicApiLabel = new Map<String,String>();
        
        
        
        Schema.DescribeFieldResult fieldResultMod=Case.Accolto__c.getDescribe();
        List<Schema.PicklistEntry> ple=fieldResultMod.getPicklistValues();
         
        
        for(Schema.PicklistEntry pickListVal:ple){
            accoltoApiLabel.put(pickListVal.getLabel(), pickListVal.getValue());
        }

        Schema.DescribeFieldResult fieldResultDecisione=Case.Decisione__c.getDescribe();
        List<Schema.PicklistEntry> pleDec=fieldResultDecisione.getPicklistValues();  
        for(Schema.PicklistEntry pickListVal:pleDec){
            decisioneApiLabel.put(pickListVal.getLabel(), pickListVal.getValue());
        }
        
        Schema.DescribeFieldResult fieldResultModI=Case.Intervento_Autorita__c.getDescribe();
        List<Schema.PicklistEntry> pleI=fieldResultModI.getPicklistValues();  
        for(Schema.PicklistEntry pickListVal:pleI){
            interventoApiLabel.put(pickListVal.getLabel(), pickListVal.getValue());
        }
        
        Schema.DescribeFieldResult fieldResultModAss=Case.Societa_Assicurative__c.getDescribe();
      	System.debug('xxx = ' + fieldResultModAss.dependentpicklist);
        List<Schema.PicklistEntry> pleAss=fieldResultModAss.getPicklistValues();  
        for(Schema.PicklistEntry pickListVal:pleAss){
            assicurazioniApiLabel.put(pickListVal.getLabel(), pickListVal.getValue());           
        }
           
        Schema.DescribeFieldResult fieldResultModRec=Case.Societa_di_Recupero__c.getDescribe();
        List<Schema.PicklistEntry> pleRec=fieldResultModRec.getPicklistValues();  
        for(Schema.PicklistEntry pickListVal:pleRec){
            recuperoApiLabel.put(pickListVal.getLabel(), pickListVal.getValue());
        }

        Schema.DescribeFieldResult fieldResultModSic=Case.SIC__c.getDescribe();
        List<Schema.PicklistEntry> pleSic=fieldResultModSic.getPicklistValues();  
        for(Schema.PicklistEntry pickListVal:pleSic){
            sicApiLabel.put(pickListVal.getLabel(), pickListVal.getValue());
        }
                 
     
        List<String> Responsabilita = AccountUtils.parsgetBranchFromId(XCSReclamiUtils.parsResponsabilitaBranch(idcase));
        
        System.debug('responsabilita = ' + Responsabilita);
        
        ress.put('sic',sicApiLabel);
        ress.put('recupero',recuperoApiLabel);
        ress.put('assicurazioni',assicurazioniApiLabel);
        ress.put('intervento',interventoApiLabel);
        ress.put('decisione',decisioneApiLabel);
        ress.put('accolto',accoltoApiLabel);
   
        return ress;
        
    }

     @AuraEnabled
    public static Boolean getHasResponsabilita(Id idCase){
        return [SELECT Has_Responsabilita__c FROM Case WHERE Id =: idCase].Has_Responsabilita__c;
    }

    @AuraEnabled
   public static List<responsabilita__mdt> setValoriResponsabilita(String societa, Id idCase){

        List<responsabilita__mdt> respList = new List<responsabilita__mdt>();

        List<XCS_Responsabilita__c> xcsResponsabilita = [
            SELECT Id, Related_Case__c, Name 
            FROM XCS_Responsabilita__c
            WHERE Related_Case__c =: idCase
        ];
        system.debug('@@@ setValoriResponsabilita_XCS_Responsabilita__c: '+xcsResponsabilita);
        if(xcsResponsabilita.size()>0){

            List<String> nameResp = new List<String>();
            for(XCS_Responsabilita__c resp : xcsResponsabilita){
                nameResp.add(resp.Name);
                system.debug('@@@ setValoriResponsabilita_resp.Name:'+resp.Name);
            }
            
            respList = [
                SELECT Id, Label, Name__c, Societa__c, DeveloperName 
                FROM responsabilita__mdt
                WHERE Societa__c =: societa
                AND DeveloperName IN: nameResp
                ORDER BY Name__c
            ];
            system.debug('@@@ setValoriResponsabilita_responsabilita__mdt:'+respList);
        }
        return respList;

    }
    
    @AuraEnabled
    public static List<responsabilita__mdt> getResponsabilita(String societa, List<responsabilita__mdt> respSelected){

        system.debug('@@@ getResponsabilita societa: '+societa);
        system.debug('@@@ getResponsabilita NOT IN : '+respSelected);
        List<responsabilita__mdt> respList = new List<responsabilita__mdt>();

        if(respSelected.size()==0){

            respList = [
                SELECT Id, Label, Name__c, Societa__c, DeveloperName 
                FROM responsabilita__mdt
                WHERE Societa__c =: societa
                ORDER BY Name__c
            ];

        }else{

        

            respList = [
                SELECT Id, Label, Name__c, Societa__c, DeveloperName 
                FROM responsabilita__mdt
                WHERE Societa__c =: societa 
                //AND Id NOT IN :respSelected
                ORDER BY Name__c
            ]; 

        }

        return respList;
    }

    
    @AuraEnabled
    public static List<responsabilita__mdt> getResponsabilitaSearched(String societa, String respValueToFound){

        system.debug('@@@ getResponsabilita societa: '+societa);
        system.debug('@@@ getResponsabilita LIKE : '+respValueToFound);
        
        List<responsabilita__mdt> respList = new List<responsabilita__mdt>();

        if(String.isNotBlank(respValueToFound)){
            
            respList = [
                SELECT Id, Label, Name__c, Societa__c, DeveloperName 
                FROM responsabilita__mdt
                WHERE Societa__c =: societa 
                AND Name__c LIKE :respValueToFound+'%'
                ORDER BY Name__c
            ]; 

        }else{

            respList = [
                SELECT Id, Label, Name__c, Societa__c, DeveloperName 
                FROM responsabilita__mdt
                WHERE Societa__c =: societa
                ORDER BY Name__c
            ];

        }

        return respList;
    }

    @AuraEnabled
    public static void createRecordResponsabilita(Id idCase, Id accId, List<String> respSelected){

        system.debug('@@@ getResponsabilita resp passed: '+respSelected);

        List<XCS_Responsabilita__c> xcsResponsabilita = new List<XCS_Responsabilita__c>();
        
        List<responsabilita__mdt> respList = [
            SELECT Id, Label, Name__c, Societa__c, DeveloperName 
            FROM responsabilita__mdt
            WHERE Id IN: respSelected
            ORDER BY Name__c
        ];

        system.debug('@@@ respList: '+respList);

        delete[SELECT id FROM XCS_Responsabilita__c WHERE Related_Case__c =: idCase];

        if(respList.size()>0){
            for(responsabilita__mdt resp : respList){
                XCS_Responsabilita__c newResp = new XCS_Responsabilita__c();
                newResp.Related_Case__c = idCase;
                newResp.Name = resp.DeveloperName;
                newResp.Related_Account__c = accId;

                xcsResponsabilita.add(newResp);

            }

            Case c = [SELECT Id, Has_Responsabilita__c, Referenced_Company__c FROM Case WHERE Id =: idCase];

            if(xcsResponsabilita.size()>0){

                //Case c = [SELECT Id, Has_Responsabilita__c, Referenced_Company__c FROM Case WHERE Id =: idCase];
                c.Has_Responsabilita__c = true;
                update c;
                insert xcsResponsabilita;
            }else{
                c.Has_Responsabilita__c = false;
                update c;
            }
            
        }
        
    }

    @AuraEnabled
    public static void createRecordCaseIDM(Id idCase, List<Attachment> selectedFile){

        system.debug('@@@ idCase passed: '+idCase);
        List<Case> childList = [SELECT Id, ParentId FROM Case WHERE ParentId =: idCase];
        if(childList.size()>0){
            return;
        }else{

            List<Case> caseList = [             
                SELECT Abbuono_Chiusura__c,Abbuono_Richiesta__c,Accolto__c,AccountId,AccountName__c,Account_Futuro_MBCS__c,ActivityType__c,Anno__c,Assegnatario__c,Autorizzazione_Livello_1__c,Autorizzazione_Livello_2__c,CategoriaExternalId__c,Categoria_Riferimento__c,Categoria_Rif_Parent__c,Categoria_TKTII__c,Categoria__c,Classe_Debito__c,CodiceDealer__c,CodiceDenuncia__c,Codice_Assicurazione_1__c,Codice_Assicurazione_2__c,Codice_Assicurazione_3__c,Codice_Cliente__c,codice_eer__c,Codice_Recuperatore__c,codice_uid_chiamata__c,Comments,Compensazione__c,ContactEmail,ContactFax,ContactId,ContactMobile,ContactPhone,Contatto_Precedente__c,DataAnalisi__c,DataInvioOutsourcer__c,DataSegnalazione__c,Data_Decisione__c,Data_Ricezione_IDM__c,Data_Ricezione__c,Data_Visibilita__c,Da_Esitare__c,Decisione__c,Delega_Presente__c,Description,DescrizioneMotivo__c,Descrizione_Assicurazione_1__c,Descrizione_Assicurazione_2__c,Descrizione_Assicurazione_3__c,DispositionAccount__c,DispositionData__c,DispositionName__c,DispositionUser__c,Disposition__c,DueDate__c,EsitiVerificaAutonomia__c,EsitoTelefonata__c,Esito__c,External_Id__c,Fido__c,F_Codice_OCS_SubAgente__c,F_Data_Contratto__c,F_Data_Estinzione__c,F_Has_Rimborso_Assicurativo_In__c,F_Has_Rimborso_Assicurativo_Out__c,F_Has_Rimborso_Commissioni_In__c,GestioneFax_Esito__c,Has_Acceso_Dati__c,Has_Allegati_Completi__c,Has_Assicurative__c,Has_Firma_Digitale__c,Has_Fondato__c,Has_Invio_Risposta_IDM__c,Has_Recupero__c,Has_Responsabilita__c,Has_Rimborso_Accordato__c,Has_Rimborso__c,Has_Risarcimento_accordato__c,Has_SIC__c,Importo_Abbouno_Chiusura__c,Importo_Abbuono_Richiesta__c,Importo_Compensazione__c,Importo_Rimborso__c,Inadempimento_Grave__c,Inadempimento__c,InterlocutoreAltro__c,Interlocutore__c,Irregolarita__c,IsAutonomiaConvenzionamentoSede__c,
                Is_Frode__c,Lettera_Risposta__c,Livello_Autorizzazione__c,Modalita_Invio__c,Motivo__c,Note__c,NumeroGiorni__c,NumeroPratica__c,numero_chiamate__c,Numero_Progressivo_Reclamo__c,Numero_Reclamo__c,OCSExternalFilialeConvenzionato__c,OCSLottoId__c,Origin,OwnerId,Owner_User__c,Pagamenti__c,pan__c, ParentId,ParentSuppliedPhone__c,Partita_Iva__c,Progressivo_Annuale_Assicurazione__c,Reason,Reclamo_Completo__c,RecordTypeId,Referenced_Company__c,Scadenza_Reclamo__c,SIC__c,SLA_Date__c,sla_minutes__c,SMSInviatiNum__c,Societa_Assicurative__c,Societa_di_Recupero__c,Sospesi_Da_Esitare__c,Sottocategoria__c,Sottotipologia__c,SourceId,Stage_Inadempimento__c,Subject,Subject_Lettera_Risposta__c,Owner.Name
          
                FROM Case 
                WHERE Id =: idCase
            ];

            if(caseList.size()>0){

                //List<String> queueIDM = new List<String>{'DN_52','DN_300','DN_343'};
                //SELECT Id, Name, DeveloperName FROM Group WHERE DeveloperName IN ('Q251','Q299','Q344')
                Map<String,String> queueIDM = new Map<String, String>();
                queueIDM.put('Compass','Q251');
                queueIDM.put('Futuro','Q299');
                queueIDM.put('Creditech','Q344');
                queueIDM.put('MBCredit Solutions','Q344');

                if(caseList.size()>0){
                    Case caseIDM = caseList.get(0).clone(false, true, false, false);
                    caseIDM.ParentId = caseList.get(0).Id;

                    if(caseList.get(0).Referenced_Company__c!=null){
                        /*List<CodaXSocieta__mdt> queue = [SELECT Societa__c, Label, DeveloperName, Id FROM CodaXSocieta__mdt WHERE Societa__c =: caseList.get(0).Referenced_Company__c AND DeveloperName IN: queueIDM];*/
                        List<Group> queue = [
                            SELECT Id, Name, DeveloperName 
                            FROM Group 
                            WHERE DeveloperName =: queueIDM.get(caseList.get(0).Referenced_Company__c) 
                        ];

                        caseIDM.OwnerId = queue.get(0)!=null ? queue.get(0).Id : null;
                    }
                    
   
                    caseIDM.Status = 'Ricevuto';
                    caseIDM.Subject = caseList.get(0).Subject + ' - Stampa IDM';
                    insert caseIDM;

                    system.debug('@@@ caseIDM selectedFile: '+selectedFile);

                    if(selectedFile.size()>0){
                        List<ContentDocumentLink> cdlink = new List<ContentDocumentLink>();
                        system.debug('@@@ dentro if : '+caseIDM.Id+' - '+selectedFile);
                        for(Attachment att : selectedFile){
                            List<String> lst = new List<String>();
                            for(String spl : att.Description.split('=')){
                                lst.add(spl);
                            }
                            system.debug('----lst-0-----'+lst.get(0));
                            system.debug('----lst-1-----'+lst.get(1));
                            ContentDocumentLink cdl = XCSReclamiUtils.createContentDocumentLink(lst.get(0), caseIDM.Id);
                            cdlink.add(cdl);
                        }
                        if(cdlink.size()>0){
                            insert cdlink;
                        }
                    }

                    system.debug('@@@ caseIDM.Id: '+caseIDM.Id);
                    system.debug('@@@ caseIDM.OwnerId/queue: '+caseIDM.Owner.Name);
                    system.debug('@@@ caseIDM.Status: '+caseIDM.Status);

                    caseList.get(0).Status = 'Stampa IDM';
                    List<Reclami_Timestamp__c> lista = new List<Reclami_Timestamp__c>();
                    lista.add(XCSReclamiUtils.createFeedItem(caseList.get(0).Id, System.now(), 'send to IDM',  UserInfo.getName(), false));
                    insert lista;

                    update caseList.get(0);
                    system.debug('@@@ caseList.get(0).Status: '+caseList.get(0).Status);

                }
            }
        }
    }

    
}