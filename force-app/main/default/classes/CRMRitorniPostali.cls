public without sharing class CRMRitorniPostali {   

    public class IdRequiredException extends Exception{}
    public class DataRequiredException extends Exception{}
    
    public static final String CLOSED='Closed';
    public static final String CRM_RETURN_MESSAGE='Salvataggio eseguito.\nChiudere la richiesta.';
    public static final String FILIALE_RETURN_MESSAGE='Non procedere alla ristampa della lettera.\nLa Welcome letter sarà automaticamente rispedita al cliente';


    public static final String Q85='Q85';
    public static final String Q80='Q80';

    public static final String OUT_RP_OK_APPOINTMENT='DP1146'; //rickiamato
    public static final String OUT_RP_KO_NOPHONE='DP2292'; //nessun recapito
    public static final String OUT_RP_KO_DECESSO= 'DP2290';//decesso
    public static final String OUT_RP_KO_WRONGPHONE= 'DP2300';//numeroErrato
    public static final String OUT_RP_KO_LIMITREACH ='DP2302'; //Raggiunto limite tentativi contatto
    public static final String OUT_RP_KO_NOREACH='DP2330'; //irraggiungibile
    public static final String OUT_RP_KO_NOTRECALL='DP2289'; //Cliente non collabora, non richiamare
    public static final String OUT_RP_KO_WAITPOSTE= 'DP2287'; //attesa documento poste
    public static final String OUT_RP_KO_MISSING= 'DP1156'; //non risponde al telefono
    public static final String OUT_RP_OK_CHANGEADDRESS= 'DPCHANGE'; //non risponde al telefono
 
    private final static List<String> lstOKEsti=new List<String>();
    static {
        for(RitorniPostaliUtils.ESITI_POSITIVI e : RitorniPostaliUtils.ESITI_POSITIVI.values()){           
            lstOKEsti.add(e.name());
        }        
    }

    public static final Integer MAX_TRIAL=3;
    public static final Integer RECALL_HOURS=12;
    //definsco mappa esito disposition
    public static final Map<String,String> mapEsito=new Map<String,String>{
                                    'NoPhone'=>OUT_RP_KO_NOPHONE,
                                    'Appointment' => OUT_RP_OK_APPOINTMENT,
                                    'WrongPhone' => OUT_RP_KO_WRONGPHONE,
                                    'NoReach' => OUT_RP_KO_NOREACH,
                                    'Missing' => OUT_RP_KO_MISSING,
                                    'Modifica' => OUT_RP_OK_CHANGEADDRESS,
                                    'KONotRecall' => RitorniPostaliUtils.ESITO_DA_NON_CONTATTARE,
                                    'RID' => RitorniPostaliUtils.ESITO_CLIENTE_PASSATO_A_RID,
                                    'AlreadyDone' => RitorniPostaliUtils.ESITO_BP_RISPEDITI_RICEVUTI,
                                    'Estinta' => RitorniPostaliUtils.ESITO_PRATICA_ESTINTA,
                                    'RifiutaCarta' => RitorniPostaliUtils.ESITO_CLIENTE_RIFIUTA_CARTA,
                                    'SentReceivedCarta' => RitorniPostaliUtils.ESITO_CARTA_RISPEDITA_RICEVUTA,
                                    'Other' => RitorniPostaliUtils.ESITO_DOC_NON_RIPRODOTTA_ALTRO,
                                    'Decesso' => RitorniPostaliUtils.ESITO_DICHIARATO_DECESSO
                            };    

    private static String textNote='cc - {3} - {0} - Tipo Chiamata: {1} - Interlocutore: {2} - ';
    private static String textNoteIDM='cc - {3} - {0} - {1} - Note: {2}';
    static String aliasUser;
    static String userBranch;
    
    @AuraEnabled
    public static string CreateNote (Id caseId, Id ritornoPostaleId, String interlocutore,
                                    String interlocutoreAltro,String tipoChiamata,
                                    String  esito, String esitoPositive, String sendCopy,
                                    String reasonNoRequest, String note,String userDateTime){
		
        //check data null
        if(caseId==null || ritornoPostaleId==null) throw new IdRequiredException('caseId and ritornoPostaleId empty');
        if(interlocutore=='' || tipoChiamata=='' || esito=='') throw new DataRequiredException('Ritorni postali data required missing');
        if(esito=='Appointment' && userDateTime=='') throw new AuraHandledException('Data/Ora appuntamento non valorizzata');
         //get user info (alias & branch)
         User usr = [select alias,Area__c, UserRoleId from user where id = :UserInfo.getUserId()];
         aliasUser = usr.alias;
         userBranch = [select Name from UserRole where id = :usr.UserRoleId].Name;                              
        //get data                             
        Case c=[select id, Branch__r.OCS_external_id__c, Categoria_Riferimento__r.External_Id__c,RecallDate__c, ownerId, 
            Account.OCS_External_Id__c,TentativoNum__c,
            (select id,NewCap__c,NewAddress__c,NewCity__c,NewProv__c,new_address__c,Original_Address__c,Branch_id__c from ritorni_postali__r) from case where id=:caseId]; // new Case(Id=caseId);
       
        RitorniPostali__c rp=[select id,OCSAnag__c,Original_Address__c,new_address__c from RitorniPostali__c where Id=:ritornoPostaleId];
       
        String category=c.Categoria_Riferimento__r.External_Id__c;
        String codCliente=c.Account.OCS_External_Id__c;
        String filiale = c.Branch__r.OCS_external_id__c;                          
       
        //verificare se sono la filiale perchè in tal caso non devo re-inviare alla filiale
        boolean isFiliale=PermissionUtils.isBranch(UserInfo.getUserId());
                                        
        integer trialNum= (c.TentativoNum__c==null) ? 0 : (Integer) c.TentativoNum__c;
        boolean flagInviaFiliale= (
                                    !isFiliale && (esito=='KO' || esito=='NoPhone' ||  
                                    esito=='KONotRecall' || (
                                        trialNum>=MAX_TRIAL-1 && ( esito=='WrongPhone' || esito=='Missing'  || esito=='NoReach'  )
                                        )
                                    )
                                );
       
        boolean esito85=false;
        boolean notaOCS=false;
        
        String type=''; 
        if(category=='2272') type='Contatto – Invio Copia';
        else if (category=='2273') type='Contatto – Invio Originale' ;        
        String esitoCase='';
		       
        List<String> lstNotePlaceholder=new List<String>{aliasUser,tipoChiamata,interlocutore,userBranch};
        String noteHeader=String.format(textNote,lstNotePlaceholder);
        if(esito=='Appointment'){
            //Chiede di essere richiamato il <data> alle <ore>:<minuti>         
            String strTime=userDateTime.substring(11,16);
            Datetime aptDate = (DateTime)JSON.deserialize('"' + userDateTime + '"', DateTime.class);                
            Integer offset = UserInfo.getTimezone().getOffset(aptDate);            
            noteHeader+='Chiede di essere richiamato il '+aptDate.format('dd/MM/yyyy',UserInfo.getTimeZone().getID())+' alle '+aptDate.time();
            system.debug('NOTE HEADER '+noteHeader);            
          
            /*
           Recupera gli altri eventuali ritorni postali per lo stesso cliente con esito vuoto o esito “Chiede di essere richiamato” o “Non risponde al telefono” o “Numero errato” o “Irraggiungibile” e per ogni elemento
            Effettua l’update sulla tabella equilon.ritorni_postali
            Effettua l’update del case
            Inserisce la nota OCS (vedi la nota a piè di pagina numero 5)
            */
           
            processRitorniPostali(c, rp, Q80,OUT_RP_OK_APPOINTMENT , noteHeader, aliasUser,NotaOCS,flagInviaFiliale,trialNum);
            c.RecallDate__c=aptDate;
            setEsito(c,rp,mapEsito.get(esito));
            notaOCS=true;

        } 
        else if(esito=='NoPhone'){ 
            //nessun recapito            
            if(flagInviaFiliale){
                
                 //Inviata alla filiale per tentativo finale
                 noteHeader+='Inviata alla filiale per tentativo finale';                 
                 inviaFiliale(c, rp, filiale); 
                
            } 
            
            setEsito(c,rp,mapEsito.get(esito));           
            processRitorniPostali(c, rp, Q80,mapEsito.get(esito) , noteHeader, aliasUser,NotaOCS,flagInviaFiliale,trialNum);
            
        }           
        else if(!isFiliale && esito=='WrongPhone' && ++trialNum<MAX_TRIAL){            
            // - Numero errato  - Tentativo n <num_tentativi_call>                                                   
                noteHeader+='Numero errato  - Tentativo n '+trialNum;
                manageTrialNum( c, rp,  aliasUser, trialNum, esito,  noteHeader,flagInviaFiliale);                  
        }
        else if(!isFiliale && esito=='Missing' && ++trialNum<MAX_TRIAL ){                                       
            //- Non risponde al telefono errato  - Tentativo n <num_tentativi_call>
                noteHeader+='Non risponde al telefono errato  - Tentativo n '+trialNum;
                manageTrialNum( c, rp,  aliasUser, trialNum, esito,  noteHeader,flagInviaFiliale);    
        }
        else if(!isFiliale && esito=='NoReach' && ++trialNum <MAX_TRIAL ){            
                //- Irraggiungibile errato  - Tentativo n <num_tentativi_call>               
                noteHeader+='Irraggiungibile errato  - Tentativo n '+trialNum;
               manageTrialNum( c, rp,  aliasUser, trialNum, esito,  noteHeader,flagInviaFiliale);                          
        }
        
        else if(esito=='Modifica'){
            //Indirizzo Variato da <indirizzo_orig> a <nuovo indirizzo>
            noteHeader+='Indirizzo Variato da '+rp.Original_Address__c+' a '+rp.New_Address__c;
            //verifica che indirizzo è effettivamente diverso da attuale
            //salva valori indirizzo
            if(type=='Contatto – Invio Copia'){
                //update case status chiuso
                c.status=CLOSED;
                if(sendCopy=='SI') mapEsito.put('Modifica',RitorniPostaliUtils.ESITO_DOC_RIPRODOTTA); //'Documentazione riprodotta';
                else if (sendCopy=='NO') mapEsito.put('Modifica',mapEsito.get(esitoPositive));
                if(esitoCase=='Altro') mapEsito.put('Modifica',RitorniPostaliUtils.ESITO_DOC_NON_RIPRODOTTA_ALTRO); //come può questo essere una disposition
            }
            else if(type=='Contatto – Invio Originale'){
                //crea nota
                //Attesa rientro doc poste
                noteHeader+=' - Attesa rientro doc poste';
                //assegna alla coda 85
                assegnaCoda(c,rp,Q85);
                sendCopy='NO';
                esitoCase='Altro'; //quale sarebbe la causale x esito
                mapEsito.put('Modifica', RitorniPostaliUtils.ESITO_DOC_NON_RIPRODOTTA_ALTRO );
                esito85=true;
            }
            /*****
            o	Effettua l’update dei dati sulla tabella equilon.ritorni_postali
            o	Effettua l’update del case (con nota annessa)
            o	Recupera gli altri eventuali ritorni postali sulla coda 80 con esito vuoto o esito “Chiede di essere richiamato” o “Non risponde al telefono” o “Numero errato” o “Nessun Recapito” o “Irraggiungibile” e per ogni elemento effettua delle lavorazioni specifiche             
            ****/
            processRitorniPostali(c, rp, Q80, mapEsito.get(esito), noteHeader, aliasUser,NotaOCS,flagInviaFiliale,trialNum);
            setEsito(c,rp,mapEsito.get(esito));
        }           
        else if(esito=='KONotFound'){
            //verifica esito KO (????)
        }       
        else if(esito=='OK1'){
            //gestito in modo centralizzato            
            if(type=='Contatto – Invio Copia'){
                //- Richiesta copia documentazione a sistema: <SI/NO>
                 if(sendCopy=='SI'){
                    //Documentazione riprodotta
                    mapEsito.put('OK1',RitorniPostaliUtils.ESITO_DOC_RIPRODOTTA);
                }
                if(sendCopy=='NO'){
                    //Motivo: <motivo_no_richiesta
                    mapEsito.put('OK1', mapEsito.get(esitoPositive)  );
                }
                else if(sendCopy=='Altro'){
                    //Motivo: <motivo_no_richiesta + Nota inserita
                    mapEsito.put('OK1', RitorniPostaliUtils.ESITO_DOC_NON_RIPRODOTTA_ALTRO  );
                }
            }
            else if(type=='Contatto – Invio originale'){
                //– Attesa rientro doc Poste
                // CODA 85????
                mapEsito.put('OK1',RitorniPostaliUtils.ESITO_ATTESA_DOC_POSTE);                
            }
            setEsito(c,rp,mapEsito.get(esito));
            processRitorniPostali(c, rp, Q80, mapEsito.get(esito), noteHeader, aliasUser,NotaOCS,flagInviaFiliale,trialNum);
        }
        else if(esito=='KONotRecall'){ //anche questo caso invia a filiale
            //▪	imposta esito a “Cliente non collabora, non richiamare”
            //Nota???
            if(flagInviaFiliale){
                //assegna a coda 90
            }
             
            setEsito(c,rp,mapEsito.get(esito));
            processRitorniPostali(c, rp, Q80, mapEsito.get(esito), noteHeader, aliasUser,NotaOCS,flagInviaFiliale,trialNum);

        }
        else if(esito == 'Decesso'){
            
            noteHeader+='Dichiarato Decesso';
            esito85=true;
            setEsito(c,rp,OUT_RP_KO_DECESSO);
            //c.Status=CLOSED;
            processRitorniPostali(c, rp, Q80, OUT_RP_KO_DECESSO, noteHeader, aliasUser,NotaOCS,flagInviaFiliale,trialNum);
        }
        
        //gestisco il caso in cui la filiale ritorni esito negativo
        if(isFiliale && !lstOKEsti.contains(mapEsito.get(esito))){
            //chiude il caso e imposta esito negativo
           
            if(type=='Contatto – Invio originale') {
            	assegnaCoda(c,rp,Q85); 
            } else {
                c.status=CLOSED; 
            }
                       
            setEsito(c,rp,mapEsito.get(esito));           
        }
        // supero ilnumero di tentativi
        if(trialNum>=MAX_TRIAL){
            //NOTA
            //- Raggiunto numero massimo tentativi di contatto
            noteHeader+='Raggiunto numero massimo tentativi di contatto';
            //ESITO - Raggiunto numero massimo di tentativi di contatto
            //salvo il numero di tentativi
            c.TentativoNum__c=trialNum;
            setEsito(c,rp,OUT_RP_KO_LIMITREACH);
            //effettua update dati equilon.ritorni_postali
            //update case con nota annessa
            //recupera altri elementi con il seguente esito:
            // CODA 80 vuoto OR “Chiede di essere richiamato” o “Non risponde al telefono” o “Numero errato” o “Nessun Recapito” o “Irraggiungibile”
            processRitorniPostali(c, rp, Q80, OUT_RP_KO_LIMITREACH, noteHeader, aliasUser,NotaOCS,flagInviaFiliale,trialNum);
            //effettua lavorazioni specifiche               
            //se non è un esito positivo mando alla filiale
            if(flagInviaFiliale && !lstOKEsti.contains(mapEsito.get(esito)))   inviaFiliale(c, rp, filiale);
        } 
        System.debug('--- invio OK ESITO '+esito+' flagInviaFiliale '+flagInviaFiliale+' mapEsito '+mapEsito.get(esito)+
                        ' contains '+lstOKEsti.contains(mapEsito.get(esito))+ ' FINAL '+ 
                        (flagInviaFiliale && (lstOKEsti.contains(mapEsito.get(esito)) || mapEsito.get(esito)==RitorniPostaliUtils.ESITO_DICHIARATO_DECESSO)));
        //gestisco caso in cui non invio a filiale x caso positivo
        if(!flagInviaFiliale && (lstOKEsti.contains(mapEsito.get(esito)) || mapEsito.get(esito)==RitorniPostaliUtils.ESITO_DICHIARATO_DECESSO)  ){         
            if(type=='Contatto – Invio Copia'){
                //update case status
                c.Status=CLOSED;
                esitoCase=mapEsito.get(esito);
                if(sendCopy=='SI') {
                    esitoCase=RitorniPostaliUtils.ESITO_DOC_RIPRODOTTA; //'Documentazione riprodotta';
                    noteHeader+='Documentazione riprodotta';
                }
                else if (sendCopy=='NO'){
                     esitoCase=mapEsito.get(esitoPositive); //reason no 
                      //Motivo: <motivo_no_richiesta
                      NoteHeader+='Motivo: '+esitoPositive;
                }
                else if(sendCopy=='Altro'){
                    esitoCase=RitorniPostaliUtils.ESITO_DOC_NON_RIPRODOTTA_ALTRO; //come può questo essere una disposition
                    NoteHeader+='Motivo: Altro '+esitoPositive;
                }

                setEsito(c,rp,esitoCase);
            }        
            //DA CAPIRE SE E QUANDO AVVIENE X CONTATTO INVIO ORIGINALE
            else if(type=='Contatto – Invio Originale'){
                if(!esito85){
                    //crea nota
                    //Attesa rientro doc poste
                    //da verificare
                    noteHeader+='Attesa rientro doc poste';                    
                    //da verificare
                    setEsito(c,rp,OUT_RP_KO_WAITPOSTE);
                }
                //assegna alla coda 85
                system.debug('-- assign to coda 85 INVIO ORIGINALE');
                assegnaCoda(c,rp,Q85);
            }            
        }

        if(note!=''){
            // - Note: <note>
            noteHeader+= ' - Note: '+note;
        }
        //PROCESSA RITORNI POSTALI AVVIENE SEMPRE
        //if(!isFiliale) processRitorniPostali(c, rp, Q80, mapEsito.get(esito), noteHeader, aliasUser,NotaOCS,flagInviaFiliale);
         if(flagInviaFiliale ) inviaFiliale(c,rp,filiale);  
        //salvo nota indipendente dall'esito
        XCSNoteUtils.postANote(caseId, 'Nota', noteHeader);
        //invio nota OCS
        if(notaOCS) OCSGestioneNoteInvoker.filtraNote( aliasUser, codCliente,'','', 'A', 'P',   noteHeader);

        //Al termine imposta sul case un flag=0 di default 
        //imposto dati chiamata 
        c.TipoChiamata__c=tipoChiamata;
        c.Interlocutore__c=interlocutore; 
        c.InterlocutoreAltro__c=interlocutoreAltro;
        
        rp.CallDispReceiver__c=interlocutore;

    	update c;
        update rp;
        //Case c1=[select id,ownerId, (select id,queueid__c from ritorni_postali__r ) from case where id=:c.id];
        //system.assertequals(c1.ownerid,c1.ritorni_postali__r[0].queueId__c);
                
        return (isFiliale)?FILIALE_RETURN_MESSAGE:CRM_RETURN_MESSAGE;
    }
    
    public static void inviaFiliale(Case c,RitorniPostali__c rp,String filiale){
                		
            	String strBranchID = [Select id, ocs_external_id__c from Account where ocs_external_id__c = :filiale].id;
                c.ownerId=GroupUtils.getQueue(filiale).id;                              
                c.Branch__c = strBranchID;               
                rp.QueueId__c = c.ownerId; //id coda
                rp.FlagNeedBranchCall__c = 1;
    }
    
    public static void assegnaCoda(Case c,RitorniPostali__c rp,String coda){
              
            String queueId=GroupUtils.getQueue(coda).id;
            c.ownerId=queueId;                       
            rp.QueueId__c=queueId; //id coda 
    }
    
    //processa ritorni postali esistenti relativi allo stesso cliente
    public static void processRitorniPostali( Case master,RitorniPostali__c rp,String coda,String dispositionCode,String note,String aliasUser,boolean notaOCS,boolean flagInviaFiliale,integer trialNum){
    // CODA 80 vuoto OR “Chiede di essere richiamato” o “Non risponde al telefono” o “Numero errato” o “Nessun Recapito” o “Irraggiungibile
        List<String> lstEsitiProcess=new List<String>{
            /*
            XCS_DispositionUtils.findDispositionByExternalID(OUT_RP_KO_WRONGPHONE).id, //numero errato
            XCS_DispositionUtils.findDispositionByExternalID(OUT_RP_KO_NOPHONE).id,  //Nessun Recapito
            XCS_DispositionUtils.findDispositionByExternalID(OUT_RP_KO_NOREACH).id, //“Irraggiungibile 
            XCS_DispositionUtils.findDispositionByExternalID(OUT_RP_OK_APPOINTMENT).id //chiede di essere richiamato
            */
            OUT_RP_KO_WRONGPHONE,OUT_RP_KO_NOPHONE,OUT_RP_KO_NOREACH,OUT_RP_OK_APPOINTMENT
        }; 
        if(dispositionCode=='') throw new AuraHandledException('Esito non valorizzato');
        Id dispositionId=XCS_DispositionUtils.findDispositionByExternalID(dispositionCode).id;
       String queueId=GroupUtils.getQueue(coda).id;
       List<RitorniPostali__c> lstRitorniPostali= [select id,CasoCorrispondente__c,OCSAnag__c,Branch_Id__c from RitorniPostali__c where
             OCSAnag__c=:rp.OCSAnag__c and id <> :rp.id and QueueId__c=:queueId  and CasoCorrispondente__r.status<>:CLOSED and 
                (CasoCorrispondente__r.Disposition__r.External_Id__c in :lstEsitiProcess or CasoCorrispondente__r.Disposition__c='') ];
        List<Id> lstCaseId=new List<Id>();
        
        for(RitorniPostali__c r : lstRitorniPostali)  lstCaseId.add(r.CasoCorrispondente__c);
        List<RitorniPostali__c> lstRP=new List<RitorniPostali__c>();
        if( lstCaseId.size()>0 ){ //se trovo dei casi da processare
            List<Case> lstCase=[select id,Account.OCS_External_Id__c,Categoria_Riferimento__r.External_Id__c, 
            (select id,queueid__c,Branch_Id__c from ritorni_postali__r) from case where id=:lstCaseId];
            for(Case c : lstCase ){
                processEsitoRitorniPostali(master, c, c.ritorni_postali__r[0], dispositionId, note, flagInviaFiliale,trialNum);
                lstRP.add(c.ritorni_postali__r[0]);
            }
            
            update lstCase;
            update lstRP;
           

        }
    }        
    
    private static void processEsitoRitorniPostali(Case master, Case c,RitorniPostali__c rp,Id dispositionId,String note,boolean flagInviaFiliale ,integer trialNum){
        //Documentazione riprodotta esito OK
        Id dispositionDocRiprodotta=XCS_DispositionUtils.findDispositionByExternalID(RitorniPostaliUtils.ESITO_DOC_RIPRODOTTA).id;
        Id dispositionNessunRecapito=XCS_DispositionUtils.findDispositionByExternalID(RitorniPostaliUtils.ESITO_NESSUN_RECAPITO).id;
        Id dispositionAttesaDocPoste=XCS_DispositionUtils.findDispositionByExternalID(RitorniPostaliUtils.ESITO_ATTESA_DOC_POSTE).id;
        c.Disposition__c=dispositionId; //salvo esito master        
        //analizzo il caso in cui esito master Documentazione Riprodotta 2303 ESITO_DOC_RIPRODOTTA
        if(!flagInviaFiliale && c.Categoria_Riferimento__r.External_Id__c==RitorniPostaliUtils.CAT_INVIO_ORIGINALE) assegnaCoda(c,rp,Q85);

        if(dispositionId==dispositionDocRiprodotta )  c.disposition__c=dispositionAttesaDocPoste; //RitorniPostaliUtils.ESITO_ATTESA_DOC_POSTE;                     
        if( (!flagInviaFiliale || dispositionId==dispositionNessunRecapito) && c.Categoria_Riferimento__r.External_Id__c==RitorniPostaliUtils.CAT_INVIO_COPIA) c.status=CLOSED;
        
        //usare setEsito
        //setEsito(c, rp, dispositionCode)
        
        //setup address
        RitorniPostali__c rpMaster=master.Ritorni_Postali__r[0];
        rp.NewAddress__c=rpMaster.NewAddress__c;
        rp.NewCap__c=rpMaster.NewCap__c;
        rp.NewCity__c=rpMaster.NewCity__c;    
        rp.NewProv__c=rpMaster.NewProv__c;

        //invio alla rispettiva filiale
        //if(flagInviaFiliale ) inviaFiliale( c, rp,'F'+rp.Branch_id__c);
        if(flagInviaFiliale ) inviaFiliale( c, rp, c.Branch__r.OCS_External_id__c);
        //inserisce nota OCS
        String codCliente=c.Account.OCS_External_Id__c;
        //if(notaOCS )
        //inserisce nota OCS
        OCSGestioneNoteInvoker.filtraNote( aliasUser, codCliente,'','', 'A',  'P',  note);
        //ipotizziamo che ogni volta ci sia una nota OCS c'è anche 1a nota sul case ma non è detto
        //XCSNoteUtils.postANote(c.Id, 'Nota', note);
    }
    private static void manageTrialNum(Case c,RitorniPostali__c rp, String aliasUser,Integer trialNum,String esito, String noteHeader,boolean flagInviaFiliale ){
        c.TentativoNum__c=trialNum;
        c.RecallDate__c=System.now().addHours(RECALL_HOURS);
        setEsito(c,rp,mapEsito.get(esito));        
        processRitorniPostali(c, rp, Q80, mapEsito.get(esito), noteHeader, aliasUser,true,flagInviaFiliale,trialNum);  
    }
    private static void setEsito(Case c,RitorniPostali__c rp, String dispositionCode){
        System.debug('--setEsito '+dispositionCode);
        if(dispositionCode=='') throw new AuraHandledException('esito non valorizzato');
        System.assert(dispositionCode!='');       
        XCS_Disposition__c disposition=XCS_DispositionUtils.findDispositionByExternalID(dispositionCode);         
        c.Disposition__c=disposition.id;
        //TODO
        //CallDispText__c sui ritorni postali
        rp.CallDispText__c=disposition.name;
    }

    private static void InsertOCSNote(String aliasUser,String codCliente,String noteHeader){
        OCSGestioneNoteInvoker.filtraNote( aliasUser, codCliente,'','', 'A', 'P',   noteHeader);
    }

     @AuraEnabled
    public static Id getRitornoPostale(Id caseId){
        try{
            return [select id from RitorniPostali__c where CasoCorrispondente__c=:caseId][0].id;
        }catch(Exception e){
            throw new AuraHandledException('Ritorno postale relativo non trovato');
        }
        
    }

    @AuraEnabled
    public static Integer eventManager(Id caseId){
       
        return RitorniPostaliEventsManager.queryOpen(caseId);
        //quando torna 0 deve chiudere 
        //se invio originale deve salvare esito
        
    }

    @AuraEnabled 
    public static Boolean isFiliale(){
        return PermissionUtils.isBranch(UserInfo.getUserId());
    }
    
    @AuraEnabled //imposta esito quando operatore è IDM
    public static string IDMProcessEsito(Id caseId, id ritornoPostaleId, String note){
        /***
        Se l’esito del ritorno era “Attesa Doc Poste”, l’esito diventa “Documentazione Re-inviata”
        Se l’esito del ritorno era diverso da “Attesa Doc Poste”, l’esito diventa “Documentazione non Re-inviata”
        Il case passa in stato “CHIUSO” 
        Effettua l’update sulla tabella equilon.ritorni_postali
        Effettua l’update del case
        Inserisce la nota OCS (vedi la nota a piè di pagina numero 5).
****/
//check data null
        if(caseId==null || ritornoPostaleId==null) throw new IdRequiredException('caseId and ritornoPostaleId empty');
        //if(esito=='') throw new DataRequiredException('Ritorni postali esito missing');
        String tipoChiamata='';
        Case c=[select id,status,Disposition__r.External_Id__c, account.OCS_External_Id__c from case where id=:caseId];
        RitorniPostali__c rp= [select id,Processato__c from RitorniPostali__c where CasoCorrispondente__c=:c.id];
        String esito=c.Disposition__r.External_Id__c;
        if(esito==RitorniPostaliUtils.ESITO_ATTESA_DOC_POSTE) {
            esito=RitorniPostaliUtils.ESITO_DOC_REINVIATA;
            tipoChiamata='Documentazione reinviata al Cliente';
        } else {
            esito=RitorniPostaliUtils.ESITO_DOC_NON_REINVIATA;
            tipoChiamata='Documentazione Archiviata';
        }
        
        c.status=CLOSED;
        setEsito(c,rp,esito);

        List<String> lstNotePlaceholder=new List<String>{aliasUser,tipoChiamata,note};
        String noteHeader=String.format(textNoteIDM,lstNotePlaceholder);
        InsertOCSNote(aliasUser,c.Account.OCS_External_Id__c, noteHeader);
        update c;
        rp.Processato__c=1;
        update rp;
        return CRM_RETURN_MESSAGE;
    }
    
}