@RestResource(urlMapping='/SegnalazioneDealer/*')
//::  /services/apexrest/SegnalazioneDealer/creazioneAttivitaSegnalazioneDealer
global with sharing class SFAConvenzionamentoChiamataForm {  

    @HttpPost
    global static esitoSegnalazione creazioneAttivitaSegnalazioneDealer(InputForm req) {
        esitoSegnalazione resp = new esitoSegnalazione(); 
        
        List<Account> lstDealer = [SELECT Id, Status__c, Codice_Fiscale__c, Partita_IVA__pc, ParentId, OCS_External_Id__c 
                                   FROM Account 
                                   WHERE RecordType.Name = 'Dealer' AND (Codice_Fiscale__c=:req.partitaIVAoCF OR Partita_IVA__c=:req.partitaIVAoCF)];
        System.debug('lstDealer riga 139:: '+lstDealer);
        if(lstDealer.size()<1){
           try{
               System.debug('***riga 142');
               //***********Account Dealer:
               Account dealerSegnalato=new Account();
               String OCSExternalFiliale='F'+integer.valueof(req.entityId);
               Date today=Date.today();
               String provincia=req.provincia;
               dealerSegnalato.RecordTypeId=RecordTypeUtil.getDealerRecordType();   
               dealerSegnalato.Name=req.ragioneSociale;  
               dealerSegnalato.DataSegnalazione__c=today;
               dealerSegnalato.Partita_IVA__c=req.partitaIVAoCF; //il campo Partita_IVA__c può accettare una stringa lunga masssimo 11
               dealerSegnalato.Codice_fiscale__c=req.partitaIVAoCF;
               dealerSegnalato.ShippingStreet=req.indirizzo;  
               dealerSegnalato.ShippingPostalCode=req.CAP;
               dealerSegnalato.ShippingCity=req.citta;
               
               if(provincia.trim().length()>2){
                   resp.message='Lunghezza massima consentita per la provincia è di 2 caratteri.';
                   resp.error=1;
               } else {
                   dealerSegnalato.ShippingState=req.provincia;  
                   dealerSegnalato.DealerPersonaRiferimentoCellulare__c=req.telefonoCellulare;     //riporto sull'account del dealer i dati della persona che l'ha segnalato (contatto di riferimento) ----> essenzialmente perchè mi serve riportarli nell'email che invio alla fiuliale (nell'email template non possi usare due "whatId", quindi o uso il contact o uso l'account per questo mi riporto i dati del contact che mi servono nell'account) 
                   dealerSegnalato.DealerPersonaRiferimentoTelefono__c=req.telefono;  
                   dealerSegnalato.DealerPersonaRiferimentoEmail__c =req.emailPersonaDiRiferimento; 
                   dealerSegnalato.DealerPersonaRiferimento__c=req.personaDiRiferimento;   					
                   dealerSegnalato.Dealership_Code__c=req.codiceAccordo;
                   dealerSegnalato.Call_Center_Segnalatore__c=req.nomeCallCenter;
                   dealerSegnalato.Macroarea__c=req.settoreMerceologico;
                   dealerSegnalato.CodiceAgente__c ='12';
                   dealerSegnalato.Status__c ='IS';
                   dealerSegnalato.FlagAllProfRist__c ='S';
                   dealerSegnalato.FlagAllProforma__c ='S';
                   dealerSegnalato.FlagProfRist__c ='S';
                   dealerSegnalato.FlagProforma__c ='S';
                   dealerSegnalato.Note__c =req.note;
                   List<Account> filialeAssociata=AccountUtils.getBranch(OCSExternalFiliale.substring(1, OCSExternalFiliale.length()));
                   if(filialeAssociata.size()<1){
                       System.debug('nessuna filiale con questo entityId ('+req.entityId+') è stata censita');
                   } else {  
                       dealerSegnalato.Branch__c=filialeAssociata[0].id; 
                   }               
                   insert dealerSegnalato;
    
                   //***********Crea contatto di riferimento:
                   Contact dealerSegnalatoContact=new Contact(); 
                   dealerSegnalatoContact.AccountId=dealerSegnalato.Id;
                   dealerSegnalatoContact.MobilePhone=req.telefonoCellulare; 
                   dealerSegnalatoContact.Phone=req.telefono;  
                   dealerSegnalatoContact.Email=req.emailPersonaDiRiferimento; 
                   if(String.isEmpty(req.personaDiRiferimento)){
                       dealerSegnalatoContact.LastName='_';   
                   } else {
                       dealerSegnalatoContact.LastName=req.personaDiRiferimento;   
                   }
                   dealerSegnalatoContact.IsContactDiRiferimentoDealer__c=true;
                   insert dealerSegnalatoContact; 
                                   
                   
                   
    
                   
                   //***********Crea nuova attività con stato "Segnalazione Dealer": 
                   Case attivitaSegnalazioneDealer=CaseUtils.getCase(RecordTypeUtil.SFA_CONVENZIONAMENTO,XCS_CategoriaUtil.SFA_CONVENZIONAMENTO_SEGNALAZ_DEALER);
                   attivitaSegnalazioneDealer.AccountId=dealerSegnalato.id;
                   attivitaSegnalazioneDealer.Categoria_Riferimento__r = XCS_CategoriaUtil.getCategoryForExternalId(XCS_CategoriaUtil.SFA_CONVENZIONAMENTO_SEGNALAZ_DEALER);
                   attivitaSegnalazioneDealer.Subject=CaseUtils.SFA_SUBJECT_SEGNALAZ_DEALER;
                   attivitaSegnalazioneDealer.OCSExternalFilialeConvenzionato__c=OCSExternalFiliale;
                   attivitaSegnalazioneDealer.DataSegnalazione__c=today;
                   List<Group> coda=GroupUtils.getQueueList(OCSExternalFiliale);
                   if (coda.size()>0){
                       attivitaSegnalazioneDealer.OwnerId=coda[0].Id;  
                       attivitaSegnalazioneDealer.Utente_Lavorazione__c=coda[0].Id;  
                       System.debug('attivitaSegnalazioneDealer CODA riga 209 attivitaSegnalazioneDealer.OwnerId:: '+attivitaSegnalazioneDealer.OwnerId); 
                   }
                   if (req.codiceBancaSegnalatrice.length()>=10){
                       req.codiceBancaSegnalatrice=req.codiceBancaSegnalatrice.substring(0, 8);
                   } 
                   if(!String.isEmpty(req.codiceBancaSegnalatrice)){
                       req.codiceBancaSegnalatrice=String.valueof(integer.valueof(req.codiceBancaSegnalatrice));
                       List<Account> dealerBanca=AccountUtils.getDealer('ParentId',req.codiceBancaSegnalatrice);
                       if (dealerBanca.size()>0){
                           if(!String.isEmpty(dealerBanca[0].ParentId)){
                               attivitaSegnalazioneDealer.Banca_Segnalatrice__c=dealerBanca[0].ParentId;  //se trova una banca parent di questo sportello allora la "banca segnalatrice" sarà questa trovata, altrimenti sarà la banca passata
                               Account dealerBancaPadre=[SELECT id, Name from Account where id=:dealerBanca[0].ParentId][0];
                               dealerSegnalato.BancaSegnalatrice__c=dealerBancaPadre.Name;
                           } else {
                               attivitaSegnalazioneDealer.Banca_Segnalatrice__c=dealerBanca[0].Id;
                               dealerSegnalato.BancaSegnalatrice__c=dealerBanca[0].Name;
                           }
                       }
                   }   
                   insert attivitaSegnalazioneDealer;
                   update dealerSegnalato;
                   
                   //Allega nota al case:
                   XCSNoteUtils.postANote(attivitaSegnalazioneDealer.id,CaseUtils.SFA_SUBJECT_SEGNALAZ_DEALER,req.note);
                   
                   //invio emailPersonaDiRiferimento alla filiale con i dettagli della segnalazione da gestire:
                   String emailTemplateSegnalazioneDealer='SFA_Convenzionamento_MailSegnalazioneDealer';
                   List<String> lstOCSExternal=new List<String>();
                   lstOCSExternal.add(OCSExternalFiliale);
                   RoleUtils.lstIndirizziEmail lstIndirizziEmail= RoleUtils.recoverListRolesEmail(lstOCSExternal);   //creo un oggetto per memorizzarmi la rsposta della classe e poi recupero gli indirizzi delle filiali e coord e regional a cui inviare l'email, oltre al template che wserve (da chiedere ad Alessio)
                   List<String> ccAddressCoordinatoriRegionalManager= new List<String>();
                   ccAddressCoordinatoriRegionalManager.addAll(lstIndirizziEmail.emailCoordinatoriArea);
                   ccAddressCoordinatoriRegionalManager.addAll(lstIndirizziEmail.emailRegionalManager);
                   Messaging.SingleEmailMessage messageMailsFiliali = EmailUtils.generateEmail(emailTemplateSegnalazioneDealer,lstIndirizziEmail.emailFiliali,ccAddressCoordinatoriRegionalManager,dealerSegnalato.id);
                   EmailUtils.sendEmail(messageMailsFiliali); 
                   System.debug('Error riga 196:: '+messageMailsFiliali);
                   System.debug('Error riga 197:: '+resp.error);
               }
        	}catch (Exception ex) {
                resp.message=ex.getMessage();
                resp.error=1;  
                System.debug('Error riga 204:: '+resp.error);
            }
            
                
        } else {
            Account dealerRecuperato=lstDealer[0];
            List<Case> lstattivitaSegnalazioneDealer=[SELECT id, isClosed, CategoriaExternalId__c, Disposition__c, Categoria_Riferimento__c,CreatedDate,Esito__c FROM Case WHERE AccountId=:dealerRecuperato.id];
            Date sevenDaysAgo=Date.today()-7;
            Boolean segnalazioneRecenteORifiutata=false;
            Boolean processoDiConvenzionamentoInCorso=false; 
			String dispositioEsternalId;
            for (Case attivita:lstattivitaSegnalazioneDealer){
                if(!String.isEmpty(attivita.Disposition__c)){
					dispositioEsternalId=XCS_DispositionUtils.getDispositionExternalId(attivita.Disposition__c);
                } else {
                    dispositioEsternalId='';  //va resettata la dispositioEsternalId perchè altrimenti rimane memorizzata quella del ciclo precedente
                }
                if(attivita.CategoriaExternalId__c==XCS_CategoriaUtil.SFA_CONVENZIONAMENTO_SEGNALAZ_DEALER && (attivita.CreatedDate>sevenDaysAgo || (dispositioEsternalId==XCS_DispositionUtils.NON_INTERESSATO || dispositioEsternalId==XCS_DispositionUtils.NONFATTIBILE_PERSETTORE || dispositioEsternalId==XCS_DispositionUtils.NONFATTIBILE_ALTRO || dispositioEsternalId==XCS_DispositionUtils.RIFIUTO_DA_FILIALE || dispositioEsternalId==XCS_DispositionUtils.CONVENZ_GIA_ATTIVA ) )){
                    segnalazioneRecenteORifiutata=true;
                //} else if(attivita.CategoriaExternalId__c==XCS_CategoriaUtil.SFA_CONVENZIONAMENTO_NEW_DEALER_PROSPECT || attivita.CategoriaExternalId__c==XCS_CategoriaUtil.SFA_CONVENZIONAMENTO_GESTIONE_DOSSIER_DEALER) {   //NB MOLTO IMPORTANTE ma devo vedere se per quel dealer il processo è stato chiuso negativamenete e quindi può essere ripresentata una nuova segnalazione!
				} else if(attivita.IsClosed==false){
                    processoDiConvenzionamentoInCorso=true;
                }
            }

            if((!String.isEmpty(dealerRecuperato.OCS_External_Id__c) && (!('CH'.equals(dealerRecuperato.Status__c)) && !('AN'.equals(dealerRecuperato.Status__c)) && !('RE'.equals(dealerRecuperato.Status__c)))) || (segnalazioneRecenteORifiutata) || (processoDiConvenzionamentoInCorso)) 
            {
                resp.error=2;
                System.debug('dealerRecuperato riga 252:: '+dealerRecuperato);
                System.debug('Error riga 220:: '+resp.error);
            } 
            
            else {

                try{
                    System.debug('***riga 142');
                    //***********Account Dealer:
                    Account dealerSegnalato=new Account();
                    dealerSegnalato.Id = dealerRecuperato.Id;
                    String OCSExternalFiliale='F'+integer.valueof(req.entityId);
                    Date today=Date.today();
                    String provincia=req.provincia;
                    dealerSegnalato.RecordTypeId=RecordTypeUtil.getDealerRecordType();   
                    dealerSegnalato.Name=req.ragioneSociale;  
                    dealerSegnalato.DataSegnalazione__c=today;
                    dealerSegnalato.Partita_IVA__c=req.partitaIVAoCF; //il campo Partita_IVA__c può accettare una stringa lunga masssimo 11
                    dealerSegnalato.Codice_fiscale__c=req.partitaIVAoCF;
                    dealerSegnalato.ShippingStreet=req.indirizzo;  
                    dealerSegnalato.ShippingPostalCode=req.CAP;
                    dealerSegnalato.ShippingCity=req.citta;
                    
                    if(provincia.trim().length()>2){
                        resp.message='Lunghezza massima consentita per la provincia è di 2 caratteri.';
                        resp.error=1;
                    } else {
                        dealerSegnalato.ShippingState=req.provincia;  
                        dealerSegnalato.DealerPersonaRiferimentoCellulare__c=req.telefonoCellulare;     //riporto sull'account del dealer i dati della persona che l'ha segnalato (contatto di riferimento) ----> essenzialmente perchè mi serve riportarli nell'email che invio alla fiuliale (nell'email template non possi usare due "whatId", quindi o uso il contact o uso l'account per questo mi riporto i dati del contact che mi servono nell'account) 
                        dealerSegnalato.DealerPersonaRiferimentoTelefono__c=req.telefono;  
                        dealerSegnalato.DealerPersonaRiferimentoEmail__c =req.emailPersonaDiRiferimento; 
                        dealerSegnalato.DealerPersonaRiferimento__c=req.personaDiRiferimento;   					
                        dealerSegnalato.Dealership_Code__c=req.codiceAccordo;
                        dealerSegnalato.Call_Center_Segnalatore__c=req.nomeCallCenter;
                        dealerSegnalato.Macroarea__c=req.settoreMerceologico;
                        dealerSegnalato.CodiceAgente__c ='12';
                        dealerSegnalato.Status__c ='IS';
                        dealerSegnalato.FlagAllProfRist__c ='S';
                        dealerSegnalato.FlagAllProforma__c ='S';
                        dealerSegnalato.FlagProfRist__c ='S';
                        dealerSegnalato.FlagProforma__c ='S';
                        dealerSegnalato.Note__c =req.note;
                        List<Account> filialeAssociata=AccountUtils.getBranch(OCSExternalFiliale.substring(1, OCSExternalFiliale.length()));
                        if(filialeAssociata.size()<1){
                            System.debug('nessuna filiale con questo entityId ('+req.entityId+') è stata censita');
                        } else {  
                            dealerSegnalato.Branch__c=filialeAssociata[0].id; 
                        }               
                        update dealerSegnalato;
            
                        //***********Crea contatto di riferimento:
                        Contact dealerSegnalatoContact=new Contact(); 
                        dealerSegnalatoContact.AccountId=dealerSegnalato.Id;
                        dealerSegnalatoContact.MobilePhone=req.telefonoCellulare; 
                        dealerSegnalatoContact.Phone=req.telefono;  
                        dealerSegnalatoContact.Email=req.emailPersonaDiRiferimento; 
                        if(String.isEmpty(req.personaDiRiferimento)){
                            dealerSegnalatoContact.LastName='_';   
                        } else {
                            dealerSegnalatoContact.LastName=req.personaDiRiferimento;   
                        }
                        dealerSegnalatoContact.IsContactDiRiferimentoDealer__c=true;
                        insert dealerSegnalatoContact; 
                                        
                        List<Case> lstattivitaSegnalazioneDealerDaGestire =
                        [SELECT id, isClosed, CategoriaExternalId__c, Disposition__c, Categoria_Riferimento__c,CreatedDate,Esito__c 
                        FROM Case 
                        WHERE AccountId=:dealerRecuperato.id AND isClosed = false AND CategoriaExternalId__c = :XCS_CategoriaUtil.SFA_CONVENZIONAMENTO_SEGNALAZ_DEALER
                        ORDER BY CreatedDate DESC];
                            
                        if (lstattivitaSegnalazioneDealerDaGestire.size() > 0) {
                            Case attivitaSegnalazioneDealerDaGestire = new Case();
                            attivitaSegnalazioneDealerDaGestire.Id = lstattivitaSegnalazioneDealerDaGestire[0].Id;

                            if (req.codiceBancaSegnalatrice.length()>=10){
                                req.codiceBancaSegnalatrice=req.codiceBancaSegnalatrice.substring(0, 8);
                            } 
                            if(!String.isEmpty(req.codiceBancaSegnalatrice)){
                                req.codiceBancaSegnalatrice=String.valueof(integer.valueof(req.codiceBancaSegnalatrice));
                                List<Account> dealerBanca=AccountUtils.getDealer('ParentId',req.codiceBancaSegnalatrice);
                                if (dealerBanca.size()>0){
                                    if(!String.isEmpty(dealerBanca[0].ParentId)){
                                        attivitaSegnalazioneDealerDaGestire.Banca_Segnalatrice__c=dealerBanca[0].ParentId;  //se trova una banca parent di questo sportello allora la "banca segnalatrice" sarà questa trovata, altrimenti sarà la banca passata
                                        Account dealerBancaPadre=[SELECT id, Name from Account where id=:dealerBanca[0].ParentId][0];
                                        dealerSegnalato.BancaSegnalatrice__c=dealerBancaPadre.Name;
                                    } else {
                                        attivitaSegnalazioneDealerDaGestire.Banca_Segnalatrice__c=dealerBanca[0].Id;
                                        dealerSegnalato.BancaSegnalatrice__c=dealerBanca[0].Name;
                                    }
                                }
                            }   
                            update attivitaSegnalazioneDealerDaGestire;
                            update dealerSegnalato;
                            
                        }
            
                        else {
                            //***********Crea nuova attività con stato "Segnalazione Dealer": 
                            Case attivitaSegnalazioneDealer=CaseUtils.getCase(RecordTypeUtil.SFA_CONVENZIONAMENTO,XCS_CategoriaUtil.SFA_CONVENZIONAMENTO_SEGNALAZ_DEALER);
                            attivitaSegnalazioneDealer.AccountId=dealerSegnalato.id;
                            attivitaSegnalazioneDealer.Categoria_Riferimento__r = XCS_CategoriaUtil.getCategoryForExternalId(XCS_CategoriaUtil.SFA_CONVENZIONAMENTO_SEGNALAZ_DEALER);
                            attivitaSegnalazioneDealer.Subject=CaseUtils.SFA_SUBJECT_SEGNALAZ_DEALER;
                            attivitaSegnalazioneDealer.OCSExternalFilialeConvenzionato__c=OCSExternalFiliale;
                            attivitaSegnalazioneDealer.DataSegnalazione__c=today;
                            List<Group> coda=GroupUtils.getQueueList(OCSExternalFiliale);
                            if (coda.size()>0){
                                attivitaSegnalazioneDealer.OwnerId=coda[0].Id;  
                                attivitaSegnalazioneDealer.Utente_Lavorazione__c=coda[0].Id;  
                                System.debug('attivitaSegnalazioneDealer CODA riga 209 attivitaSegnalazioneDealer.OwnerId:: '+attivitaSegnalazioneDealer.OwnerId); 
                            }
                            if (req.codiceBancaSegnalatrice.length()>=10){
                                req.codiceBancaSegnalatrice=req.codiceBancaSegnalatrice.substring(0, 8);
                            } 
                            if(!String.isEmpty(req.codiceBancaSegnalatrice)){
                                req.codiceBancaSegnalatrice=String.valueof(integer.valueof(req.codiceBancaSegnalatrice));
                                List<Account> dealerBanca=AccountUtils.getDealer('ParentId',req.codiceBancaSegnalatrice);
                                if (dealerBanca.size()>0){
                                    if(!String.isEmpty(dealerBanca[0].ParentId)){
                                        attivitaSegnalazioneDealer.Banca_Segnalatrice__c=dealerBanca[0].ParentId;  //se trova una banca parent di questo sportello allora la "banca segnalatrice" sarà questa trovata, altrimenti sarà la banca passata
                                        Account dealerBancaPadre=[SELECT id, Name from Account where id=:dealerBanca[0].ParentId][0];
                                        dealerSegnalato.BancaSegnalatrice__c=dealerBancaPadre.Name;
                                    } else {
                                        attivitaSegnalazioneDealer.Banca_Segnalatrice__c=dealerBanca[0].Id;
                                        dealerSegnalato.BancaSegnalatrice__c=dealerBanca[0].Name;
                                    }
                                }
                            }   
                            insert attivitaSegnalazioneDealer;
                            update dealerSegnalato;

                            //Allega nota al case:
                            XCSNoteUtils.postANote(attivitaSegnalazioneDealer.id,CaseUtils.SFA_SUBJECT_SEGNALAZ_DEALER,req.note);
                        }
                        
                        //invio emailPersonaDiRiferimento alla filiale con i dettagli della segnalazione da gestire:
                        String emailTemplateSegnalazioneDealer='SFA_Convenzionamento_MailSegnalazioneDealer';
                        List<String> lstOCSExternal=new List<String>();
                        lstOCSExternal.add(OCSExternalFiliale);
                        RoleUtils.lstIndirizziEmail lstIndirizziEmail= RoleUtils.recoverListRolesEmail(lstOCSExternal);   //creo un oggetto per memorizzarmi la rsposta della classe e poi recupero gli indirizzi delle filiali e coord e regional a cui inviare l'email, oltre al template che wserve (da chiedere ad Alessio)
                        List<String> ccAddressCoordinatoriRegionalManager= new List<String>();
                        ccAddressCoordinatoriRegionalManager.addAll(lstIndirizziEmail.emailCoordinatoriArea);
                        ccAddressCoordinatoriRegionalManager.addAll(lstIndirizziEmail.emailRegionalManager);
                        Messaging.SingleEmailMessage messageMailsFiliali = EmailUtils.generateEmail(emailTemplateSegnalazioneDealer,lstIndirizziEmail.emailFiliali,ccAddressCoordinatoriRegionalManager,dealerSegnalato.id);
                        EmailUtils.sendEmail(messageMailsFiliali); 
                        System.debug('Error riga 196:: '+messageMailsFiliali);
                        System.debug('Error riga 197:: '+resp.error);
                    }
                }catch (Exception ex) {
                    resp.message=ex.getMessage();
                    resp.error=1;  
                    System.debug('Error riga 204:: '+resp.error);
                }

            }
        }
        return resp;
    }
    
    
    global class InputForm {
        global String ragioneSociale;
        global String partitaIVAoCF;
        global String indirizzo;
        global String CAP;
        global String citta;
        global String provincia;
        global Integer codiceAccordo;
        global String note;       
        global String emailPersonaDiRiferimento;
        global String telefono; 
        global String telefonoCellulare;
        global String personaDiRiferimento;
        global String codiceBancaSegnalatrice;       
        global String settoreMerceologico;
        global String entityId;
        global String nomeCallCenter;
    }    
    
    
    
    global class esitoSegnalazione {
        global Integer error;
        global String message;
    }
    
    
    
}