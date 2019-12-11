public class SFAConvenz_NDA_FormVerificaAnagCtrller {

    @AuraEnabled
    public static DatiDealerCollegati getDealerCollegati(String caseId ) {
        
		SFAConvenzionamento.Dati dati = new SFAConvenzionamento.Dati();
        dati=SFAConvenzionamento.getConvenzioneDati(caseId);
        

        DatiDealerCollegati datiDealerCollegati=new DatiDealerCollegati();
		datiDealerCollegati.dealer=dati;
        datiDealerCollegati.collegati=SFAConvenzionamento.getCollegatiERuolo(dati.dealerId);        
        
        switch on dati.dealerInfo.Tipo_Intermediario__c {
            when 'CV' {		
                datiDealerCollegati.optionsTipoIntermediario2.add('PV');
                datiDealerCollegati.optionsTipoIntermediario2.add('SA');
            }	
            when 'PV' {		
                datiDealerCollegati.optionsTipoIntermediario2.add('CV');
                datiDealerCollegati.optionsTipoIntermediario2.add('SA');                        
            }
            when 'SA' {		
                datiDealerCollegati.optionsTipoIntermediario2.add('PV');
                datiDealerCollegati.optionsTipoIntermediario2.add('CV');                        
            }
        }        
		return datiDealerCollegati;		
	} 
    
    @AuraEnabled
    public static SFAConvenzionamento.CategoriaEStepLavorazione getCategoriaEStepLavorazione(String caseId) {
        return SFAConvenzionamento.getCategoriaEStepLavorazione(caseId);	
	}    

    //Verifica dati inseriti riguardanti il dealer e i collegati nel componente principale e chiamata al servizio NormalizzaIndirizzo 
    @AuraEnabled
    public static DatiVerifica segnalaErroreSalvataggio(String dealerAcquisitionId, String Partita_IVA, String Codice_Fiscale, Boolean PIVAeCFrequired, String telefonoSede, String ShippingStreet, String ShippingPostalCode, String provincia , String citta , String MobilePhone , String tipoIntermediarioDealer, String tipoIntermediarioDealer2Selezionato  ) {
        DatiVerifica datiVerifica= new DatiVerifica();
        datiVerifica.errorSave=false;
        Account dealer=SFAConvenzionamento.getDealerById(dealerAcquisitionId);
        /*if (PIVAeCFrequired && (String.isEmpty(Partita_IVA) || String.isEmpty(Codice_Fiscale))){   //controlla se CF e P.IVA quando obbligatori sono stati inseriti o meno 
            
            if(String.isEmpty(Partita_IVA)){
                datiVerifica.message.add('-P.IVA convenzionato');
            }
            
        	if(String.isEmpty(Codice_Fiscale)){    
                datiVerifica.message.add('-Codice Fiscale convenzionato');
            }  
            datiVerifica.errorSave=true;    //si è verificato un errore di salvataggio, di conseguenza la variabile va settata a true
        }
        
        if (PIVAeCFrequired && String.isEmpty(Codice_Fiscale)){   //controlla se CF e P.IVA quando obbligatori sono stati inseriti o meno   
            datiVerifica.message.add('-Codice Fiscale convenzionato');
            datiVerifica.errorSave=true;    //si è verificato un errore di salvataggio, di conseguenza la variabile va settata a true
        }        
        
        //controllo generico se CF e P.IVA  inseriti sono corretti formalmente oppure no
        if(!String.isEmpty(Codice_Fiscale) && dealer.Type_Anag__c!='G'){
            if(!ValidationUtils.isCodiceFiscaleValido(Codice_Fiscale)){
                datiVerifica.message.add('-CF non inserito correttamente');
                datiVerifica.errorSave=true;
        	}
        }

		if(!String.isEmpty(Partita_IVA)){  //partita IVA potrebbe esere uguale al codice fiscale 
            if(!ValidationUtils.isCodiceFiscaleValido(Partita_IVA) && !ValidationUtils.isPartitaIVAValida(Partita_IVA)){   
                datiVerifica.message.add('-P.IVA non inserita correttamente');
                datiVerifica.errorSave=true;
            }
        }   */     
        if (PIVAeCFrequired)
        {
            if(dealer.Forma_Giuridica__c=='DIN'){
                if(string.isEmpty(Codice_Fiscale)){
                    datiVerifica.message.add('-Popolare Codice Fiscale');
                        datiVerifica.errorSave=true;
                }
                else
                {	
                    if(!ValidationUtils.isCodiceFiscaleValido(Codice_Fiscale)){
                        datiVerifica.message.add('-CF non inserito correttamente');
                        datiVerifica.errorSave=true;
                    }
                }
                if(String.isEmpty(Partita_IVA)){
                    datiVerifica.message.add('-Popolare P.IVA ');
                    datiVerifica.errorSave=true;
                }
            }
            else{
                if(String.isEmpty(Partita_IVA)){
                    datiVerifica.message.add('-Popolare P.IVA ');
                    datiVerifica.errorSave=true;
                }
                else{
                    if(!ValidationUtils.isPartitaIVAValida(Partita_IVA)){   
                        datiVerifica.message.add('-P.IVA non inserita correttamente');
                        datiVerifica.errorSave=true;
                    }
                }
                if(string.isEmpty(Codice_Fiscale)){
                    datiVerifica.message.add('-Popolare Codice Fiscale');
                        datiVerifica.errorSave=true;
                }	
            }
        } 
        if(String.isEmpty(ShippingStreet) || String.isEmpty(ShippingPostalCode) || String.isEmpty(provincia) || String.isEmpty(citta)){   //l'indirizzo di sede è obbòligatorio
            datiVerifica.message.add('-Completare correttamente i dati relativi all\'indirizzo di sede');
            datiVerifica.errorSave=true;            
        }
        
        if(telefonoSede == null || string.isEmpty(telefonoSede)){
           datiVerifica.message.add('-Popolare il numero di telefono Fisso');
           datiVerifica.errorSave=true; 
        }
        else{
        	if(!ValidationUtils.isTelefonoValido(telefonoSede)){
                datiVerifica.message.add('-Correggere il numero di telefono Fisso');
                datiVerifica.errorSave=true; 
            }
        }
        
        if (!String.isEmpty(MobilePhone)){
            if(!ValidationUtils.isCellValido(MobilePhone)){
                datiVerifica.message.add('-Correggere il numero di telefono cellulare');
                datiVerifica.errorSave=true; 
            }
        }
        
        
        //controlla che CAP e COMUNE corrispondano::
        if(!String.isEmpty(ShippingPostalCode)){
            ShippingPostalCode = ShippingPostalCode.replaceAll('\\s+', '');   //removes eventually the blank spaces into the string
        }
        list<XCS_Town__c>  cap_comune = [SELECT Id, Comune__c, CAP__c, Provincia__c FROM XCS_Town__c 
                                         WHERE Catastale__c!=null AND CAP__c!='0' 
                                         AND Comune__c=:citta AND CAP__c=:ShippingPostalCode];
        if(cap_comune.size()==0){
            datiVerifica.message.add('-CAP e Località di residenza del convenzionato non corrispondono');
            datiVerifica.errorSave=true;  
        }
        
		//VERIFICA I DATI DEI COLLEGATI::
		List<Contact> collegatiList=SFAConvenzionamento.getCollegati(dealerAcquisitionId);
        String nomeCollegato,cognomeCollegato;
        Boolean coNomeInserted;
        String collegatoName;
        for (Contact co:collegatiList){
            	//co.MailingPostalCode = co.MailingPostalCode.replaceAll('\\s+', ''); //tolgo eventuali spazi nel postal code perchè poi devo fare un confronto
                coNomeInserted=false;
            	if (co.Tipo_Anagrafica__c=='G'){
                    collegatoName=co.RagioneSociale__c;
                } else {
                    cognomeCollegato=String.IsEmpty(co.LastName)?'':co.LastName;
                    nomeCollegato=String.IsEmpty(co.FirstName)?'':co.FirstName;
                    collegatoName=cognomeCollegato +' '+nomeCollegato;
                }
                //P.VA o C.F. obbligatori:            
                if(String.isEmpty(co.Partita_IVA__c)){
                    if(!coNomeInserted){
                        datiVerifica.message.add('*** '+ collegatoName +' ***');
                        coNomeInserted=true;
                    }                
                    datiVerifica.message.add('-Inserire Partita IVA');
                    datiVerifica.errorSave=true;  
                }
                if (String.isEmpty(co.Codice_Fiscale__c) ){
                    if(!coNomeInserted){
                        datiVerifica.message.add('*** '+ collegatoName +' ***');
                        coNomeInserted=true;
                    }                
                    datiVerifica.message.add('-Inserire Codice Fiscale');
                    datiVerifica.errorSave=true;  
                }            
            
            
            
                //Indirizzo di residenza:
                if(String.isEmpty(co.MailingCity) || String.isEmpty(co.MailingState) || String.isEmpty(co.MailingPostalCode) || String.isEmpty(co.MailingStreet)){   //l'indirizzo di sede è obbòligatorio
                    if(!coNomeInserted){
                        datiVerifica.message.add('*** '+ collegatoName +' ***');
                        coNomeInserted=true;
                    }               
                    datiVerifica.message.add('-Completare correttamente i dati relativi all\'indirizzo di sede');                            
                    datiVerifica.errorSave=true;            
                }
            
            	//dati essenziali di anagrafica per il collegato FISICO/PRIVATO...  o di sede/attività per il collegato GIURIDICO 
                if(co.Tipo_Anagrafica__c=='G'){   
                    if(String.isEmpty(co.RagioneSociale__c) || co.DataInizioAttivita__c==null || String.isEmpty(co.CittaSede__c)){
                        if(!coNomeInserted){
                            datiVerifica.message.add('*** '+ collegatoName +' ***');
                            coNomeInserted=true;
                        }
						datiVerifica.errorSave=true;    //se entrioamo qui siamo sicuri che un errore nel salvataggio c'è 
                        
                        if(String.isEmpty(co.RagioneSociale__c)){
                            datiVerifica.message.add('-Completare la Ragione Sociale');    
                        }
                         if(co.DataInizioAttivita__c==null){
                            datiVerifica.message.add('-Completare la data di inizio attività');    
                        }
                        if(String.isEmpty(co.CittaSede__c)){
                            datiVerifica.message.add('-Completare la città di sede');    
                        }                        
                        
                    }                     
                } else {    //il collegato non è GIURIDICO    
                    if(String.isEmpty(co.LastName) || String.isEmpty(co.FirstName)|| String.isEmpty(co.Luogo_Nascita__c)|| co.Birthdate==null || String.isEmpty(co.Provincia_Nascita__c) || String.isEmpty(co.Sesso__c)){
                        if(!coNomeInserted){
                            datiVerifica.message.add('*** '+ collegatoName +' ***');
                            coNomeInserted=true;
                        }
						datiVerifica.errorSave=true;    //se entrioamo qui siamo sicuri che un errore nel salvataggio c'è 
                        if(String.isEmpty(co.LastName)){
                            datiVerifica.message.add('-Completare il cognome');    
                        }
                        if(String.isEmpty(co.FirstName)){
                            datiVerifica.message.add('-Completare il nome');    
                        }
                        if(String.isEmpty(co.Luogo_Nascita__c)){
                            datiVerifica.message.add('-Completare la località di nascita');    
                        }   
                        if(String.isEmpty(co.Provincia_Nascita__c)){
                            datiVerifica.message.add('-Completare la provincia di nascita');    
                        }                        
                        if(co.Birthdate==null){
                            datiVerifica.message.add('-Completare la data di nascita');    
                        }
                        if(String.isEmpty(co.Sesso__c)){
                            datiVerifica.message.add('-Completare il sesso');    
                        }                        
                        
                    
                    } else {
                        //controllare che il CF corrisponda coi dati inseriti    //QUESTO CONTROLLO NON L'HO VERIFICATO QUINDI VERIFICARLO
                        if(!String.isEmpty(co.Codice_Fiscale__c)){
                            CodiceFiscaleAnagrafica.Anagrafica anag = new CodiceFiscaleAnagrafica.Anagrafica();
                            anag.dataNascita = co.Birthdate;
                            System.debug('°°°°°°°°°°°°°°°°°°°°°°co.Birthdate:: '+co.Birthdate);
                            anag.sesso=co.Sesso__c;
                            Boolean CFValido=CodiceFiscaleValidationUtils.isCodiceFiscaleValido(co.Codice_Fiscale__c, anag);
                            if (!CFValido){
                                if(!coNomeInserted){
                                    datiVerifica.message.add('*** '+ collegatoName +' ***');
                                    coNomeInserted=true;
                                }                            
                                datiVerifica.message.add('-Codice Fiscale e Data di nascita non corrispondenti');                            
                                system.debug('#####CF NON valido!');  
                                datiVerifica.errorSave=true;                            
                            }
                        }
                    }
                    
                }
            
                //controlla che CAP e COMUNE corrispondano::
                /*System.debug('*** co.MailingPostalCode ' + co.MailingPostalCode);
            	System.debug('*** co.MailingCity ' + co.MailingCity);
            	System.debug('*** cittaCAPmap ' + JSON.serialize(cittaCAPmap));
                if(co.MailingPostalCode!=cittaCAPmap.get(co.MailingCity)){   //se il CAP inserito (MailingPostalCode) e quello vero salvato nell map (cittaCAPmap.get(co.MailingCity)) non corrispondono
                    if(!coNomeInserted){
                        datiVerifica.message.add('*** '+ collegatoName +' ***');
                        coNomeInserted=true;
                    }
					datiVerifica.message.add('-CAP e Località non corrispondono'); 
                    datiVerifica.errorSave=true;   
                }*/
            
				List<XCS_Town__c>  cap_comuneCo = new List<XCS_Town__c>();
                cap_comuneCo = [SELECT Id, Comune__c, CAP__c, Provincia__c FROM XCS_Town__c 
                                WHERE Catastale__c!=null AND CAP__c!='0' 
                                AND Comune__c=:co.MailingCity AND CAP__c=:co.MailingPostalCode];
                if(cap_comuneCo.size()==0){
                    if(!coNomeInserted){
                        datiVerifica.message.add('*** '+ collegatoName +' ***');
                        coNomeInserted=true;
                    }
					datiVerifica.message.add('-CAP e Località non corrispondono'); 
                    datiVerifica.errorSave=true;  
                }            

            
        }
        

        if(!datiVerifica.errorSave){
            //Account dealer=[SELECT id, Tipo_Intermediario_2__c, ShippingStreet, ShippingPostalCode, ShippingState, ShippingCity, ShippingCountry FROM Account WHERE id=:dealerAcquisitionId][0];    //aggiungere tutti i campi che si necessita avere
            dealer.Tipo_Intermediario_2__c=tipoIntermediarioDealer2Selezionato;

            //chiama Normalizza Indirizzo e popola la datable
            OCSNormalizzaIndirizzoResponse response = OCSNormalizzaIndirizzoInvoker.callNormalizzaIndirizzo('',ShippingStreet,'',ShippingPostalCode,citta,provincia,'','');
            OCSNormalizzaIndirizzoInvoker.DatiChiamataOCS datiChiamataOCS=OCSNormalizzaIndirizzoInvoker.processaResponse(response);  
            System.debug('datiChiamataOCS:: '+datiChiamataOCS);
            datiVerifica.datiChiamataOCS=datiChiamataOCS;
            
            if(datiChiamataOCS.chiamataOK){   
                if(datiChiamataOCS.indirizziElenco.size()==1){   //se l'elenco è fatto di un'indirizzo solo lo salvo direttamente
                    dealer.ShippingStreet=datiChiamataOCS.indirizziElenco[0].indirizzo; 
                    dealer.ShippingPostalCode=datiChiamataOCS.indirizziElenco[0].cap; 
                    dealer.ShippingState=datiChiamataOCS.indirizziElenco[0].provincia; 
                    dealer.ShippingCity=datiChiamataOCS.indirizziElenco[0].localita; 
                    dealer.ShippingCountry=datiChiamataOCS.indirizziElenco[0].nazione; 
                }  
            }
            update dealer;     //ATTENZIONE:: c'è da togliere questo da qui! perchè è una DML 
        }
        
        
        System.debug('#####datiVerifica :'+ datiVerifica );
        
        return datiVerifica;
		
	} 
    
    @AuraEnabled
    public static void salvaProvinciaECitta(String dealerAcquisitionId, String provincia , String citta) {        
		Account dealer =[SELECT Id, ShippingCity, ShippingState FROM Account  WHERE Id = :dealerAcquisitionId][0];
        dealer.ShippingState=provincia; 
        dealer.ShippingCity=citta; 
		update dealer;
        
    }
        
    @AuraEnabled
    public static DatiVerifica salvaDatiAggiuntiviCollegato(String collegatoId, String provincia , String citta, String provinciaNascita, String cittaNascita, Boolean isCollegatoRappresentante, Boolean isCollegatoFirmatario , String selectedcontactRelationId, String indirizzo) {
        System.debug('*** salvaDatiAggiuntiviCollegato - indirizzo :: ' + indirizzo);
        DatiVerifica datiVerifica= new DatiVerifica();
        datiVerifica.errorSave=false;
		Contact collegato =[SELECT Id, MailingState, MailingCity,MailingPostalCode, MailingStreet,Provincia_Nascita__c,Luogo_Nascita__c FROM Contact  WHERE Id = :collegatoId][0];
        collegato.MailingStreet = indirizzo;
        collegato.MailingState=provincia; 
        collegato.MailingCity=citta; 
        collegato.Provincia_Nascita__c=provinciaNascita;
        collegato.Luogo_Nascita__c=cittaNascita;
        System.debug('@@@@@@@@@@@isCollegatoRappresentante:: '+isCollegatoRappresentante);
        System.debug('@@@@@@@@@@@isCollegatoFirmatario:: '+isCollegatoFirmatario);
        AccountContactRelation accountContactCollegato = [SELECT Id, isCollegatoRappresentante__c, isCollegatoFirmatario__c FROM AccountContactRelation WHERE Id=:selectedcontactRelationId ][0];
        accountContactCollegato.isCollegatoRappresentante__c=isCollegatoRappresentante;
        accountContactCollegato.isCollegatoFirmatario__c=isCollegatoFirmatario;
        
        //chiama Normalizza Indirizzo e popola la datable
        
        OCSNormalizzaIndirizzoResponse response = OCSNormalizzaIndirizzoInvoker.callNormalizzaIndirizzo('',collegato.MailingStreet,'',collegato.MailingPostalCode,collegato.MailingCity,collegato.MailingState,'','');
        System.debug('*** OCSNormalizzaIndirizzoResponse :: ' + JSON.serialize(response));
        OCSNormalizzaIndirizzoInvoker.DatiChiamataOCS datiChiamataOCS=OCSNormalizzaIndirizzoInvoker.processaResponse(response);
        System.debug('datiChiamataOCS:: '+datiChiamataOCS);
        datiVerifica.datiChiamataOCS=datiChiamataOCS;
        datiVerifica.errorSave=datiChiamataOCS.chiamataOK;
        if(datiChiamataOCS.chiamataOK){
            if(datiChiamataOCS.indirizziElenco.size()==1){   //se l'elenco è fatto di un'indirizzo solo lo salvo direttamente
                collegato.MailingStreet=datiChiamataOCS.indirizziElenco[0].indirizzo; 
                collegato.MailingPostalCode=datiChiamataOCS.indirizziElenco[0].cap; 
                collegato.MailingState=datiChiamataOCS.indirizziElenco[0].provincia; 
                collegato.MailingCity=datiChiamataOCS.indirizziElenco[0].localita; 
                collegato.MailingCountry=datiChiamataOCS.indirizziElenco[0].nazione; 
            }  
        }

        
        update collegato;
        update accountContactCollegato; 
        return datiVerifica;
    }

    @AuraEnabled
    public static void rimuoviRipristinaCollegato(String accountContactRelationCollegatoId) {
        AccountContactRelation accountContactRelationCollegato = [SELECT Id, isCollegatoEliminato__c  FROM AccountContactRelation WHERE Id=:accountContactRelationCollegatoId][0];
        accountContactRelationCollegato.isCollegatoEliminato__c=!accountContactRelationCollegato.isCollegatoEliminato__c;
        update accountContactRelationCollegato;    
    }

    @AuraEnabled
    public static void salvaIndirizzoDealerDaDatatable(String dealerId, String indirizzo , String localita, String cap, String provincia, String nazione) {      
		Account dealer =[SELECT Id, ShippingCity, ShippingCountry, ShippingPostalCode, ShippingState, ShippingStreet FROM Account  WHERE Id = :dealerId][0];
        dealer.ShippingStreet=indirizzo; 
        dealer.ShippingPostalCode=cap; 
        dealer.ShippingState=provincia; 
        dealer.ShippingCity=localita; 
        dealer.ShippingCountry=nazione;                 
		update dealer;
        
    }
    
    @AuraEnabled
    public static void salvaIndirizzoCollegatoDaDatatable(String collegatoId, String indirizzo , String localita, String cap, String provincia, String nazione) {      
		Contact collegato =[SELECT Id, MailingState, MailingCity,MailingPostalCode, MailingStreet  FROM Contact  WHERE Id = :collegatoId][0];
        collegato.MailingStreet=indirizzo; 
        collegato.MailingPostalCode=cap; 
        collegato.MailingState=provincia; 
        collegato.MailingCity=localita; 
        collegato.MailingCountry=nazione;                 
		update collegato;   
    }    
    
    @AuraEnabled
    public static OCSCensimentoAnagConvenzionatoResponse travasaSuOCSPrimoServizio(String dealerAcquisitionId) {        
        //CHIAMATA PRIMO SERVIZIO OCS:
        List<String> collegatiIds=SFAConvenzionamento.getCollegatiIds(dealerAcquisitionId);
        OCSCensimentoAnagConvenzionatoResponse responseOCS1 = OCSCensimentoAnagConvenzionatoInvoker.callCensimentoAnagConvenzionato(dealerAcquisitionId,collegatiIds); 		
        return responseOCS1;   
    }        
            
    @AuraEnabled
    public static OCSCensimentoAnagConvenzionatoInvoker.DatiOCS processaRispostaPrimoServizio(String dealerAcquisitionId, OCSCensimentoAnagConvenzionatoResponse responsePrimoServizio) {
		System.debug('BEFORE processaResponse');
        OCSCensimentoAnagConvenzionatoInvoker.DatiOCS datiOCS= OCSCensimentoAnagConvenzionatoInvoker.processaResponse(responsePrimoServizio, dealerAcquisitionId);        		
        System.debug('AFTER processaResponse');
        System.debug('responsePrimoServizio:: '+responsePrimoServizio);
        return datiOCS;

    }  
    
	@AuraEnabled
    public static DatiChiamate travasaSuOCSSecondoTerzoQuartoServizio(String dealerAcquisitionId, List<Contact> collegatiList) {        
		DatiChiamate datiChiamate = new DatiChiamate();
		datiChiamate.chiamataOK=false;
		//CHIAMATA SECONDO SERVIZIO OCS:
		System.debug('Chiamata secondo servizio');
        OCSCensimentoAnagIntegrativaResponse responseOCS2 = OCSCensimentoAnagIntegrativaInvoker.callCensimentoAnagIntegrativa(dealerAcquisitionId);         
        if(responseOCS2.isOK()){   //responseOCS2.resultMessage=='Ok'
            //CHIAMATA TERZO SERVIZIO
            OCSCensimentoCollegatiResponse responseOCS3 = OCSCensimentoCollegatiInvoker.callCensimentoCollegati(dealerAcquisitionId);
            if(responseOCS3.isOK()){
                //CHIAMATA QUARTO SERVIZIO
                System.debug('Chiamata quarto servizio');
                OCSCensimentoAccordoResponse responseOCS4 = OCSCensimentoAccordoInvoker.callCensimentoAccordo(dealerAcquisitionId);
                if(responseOCS4.isOK()){
                    System.debug('Chiamata quarto servizio OK');
                    datiChiamate.chiamataOK=true;
                } else {
                    datiChiamate.message.add('Problema nella chiamata del servizio "Censimento Accordo".');                   
                    System.debug('Problema nel chiamare il servizio "Censimento Accordo" (Quarto)');
                }                        
            } else {
                //PROCESSA RISPOSTA TERZO SERVIZIO
                List<String> message3= OCSCensimentoCollegatiInvoker.processaResponse(responseOCS3, dealerAcquisitionId);
                if(message3[0]==null){  //faccio questo controllo perchè ci sono condizioni per cui anche se la chiamata non va a buon fine, non viene restituito un messaggio di errore 
                    datiChiamate.message.add('Problema nella chiamata del servizio "Censimento Collegati".');
                } else {
                    datiChiamate.message=message3;
                }                
                System.debug('Problema nel chiamare il servizio "Censimento Collegati" (Terzo)');
            }    
        } else {
            //PROCESSA RISPOSTA SECONDO SERVIZIO
            List<String> message2= OCSCensimentoAnagIntegrativaInvoker.processaResponse(responseOCS2);
            if(message2[0]==null){
                System.debug('NULL message2:: '+message2);
                datiChiamate.message.add('Problema nella chiamata del servizio "Censimento Anagrafica Integrativa".');
            } else {
                System.debug('NOT NULL message2:: '+message2);
                datiChiamate.message=message2;
            } 
            System.debug('SERVICE MESSAGE:: '+datiChiamate.message);
            System.debug('Problema nel chiamare il servizio "Censimento Anagrafica Integrativa" (Secondo)');
        }
        
        return datiChiamate;   
    } 
    
    @AuraEnabled
    public static void passaAStepRecuperoIntese(String caseId) {
        SFAConvenzionamento.updateStepLavorazione(caseId,SFAConvenzionamento.NDA_InteseEDocumenti);
    }
    
    
    

 	public class DatiVerifica {
        @AuraEnabled
        public List<String> message {get { if (message == null ) message = new List<String>(); return message; } set;}
        @AuraEnabled
        public Boolean errorSave {get; set;}     
        @AuraEnabled
        public OCSNormalizzaIndirizzoInvoker.DatiChiamataOCS datiChiamataOCS {get; set;}            
        //@AuraEnabled
        //public List<String> optionsTipoIntermediario2 {get { if (optionsTipoIntermediario2 == null ) optionsTipoIntermediario2 = new List<String>(); return optionsTipoIntermediario2; } set;}        
    } 


 	public class DatiOCS {
        @AuraEnabled
        public List<String> message {get { if (message == null ) message = new List<String>(); return message; } set;}
        @AuraEnabled
        public Boolean errorSave {get; set;}  
    }     

 	public class DatiDealerCollegati {
        @AuraEnabled
        public List<SFAConvenzionamento.CollegatiObject> collegati {get { if (collegati == null ) collegati = new List<SFAConvenzionamento.CollegatiObject>(); return collegati; } set;}
        //@AuraEnabled
        //public SFAConvenzionamento.Collegati collegati {get { if (collegati == null ) collegati = new SFAConvenzionamento.Collegati(); return collegati; } set;}
        @AuraEnabled
        public SFAConvenzionamento.Dati dealer {get { if (dealer == null ) dealer = new SFAConvenzionamento.Dati(); return dealer; } set;}    
        @AuraEnabled
        public List<String> optionsTipoIntermediario2 {get { if (optionsTipoIntermediario2 == null ) optionsTipoIntermediario2 = new List<String>(); return optionsTipoIntermediario2; } set;}        
    }    
  
 	public class DatiChiamate {
        @AuraEnabled
        public List<String> message {get { if (message == null ) message = new List<String>(); return message; } set;}
        @AuraEnabled
        public Boolean chiamataOK {get; set;}          
    }    
}