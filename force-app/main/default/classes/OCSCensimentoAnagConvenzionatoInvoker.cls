public class OCSCensimentoAnagConvenzionatoInvoker {
    
	public static final String messaggioAnagraficaInserita = 'Anagrafica inserita';
    
    public static OCSCensimentoAnagConvenzionatoResponse callCensimentoAnagConvenzionato (String dealerId, List<String> collegatiIds) {
		List<OCSCensimentoAnagConvenzionatoRequest.ELenco> elenco=processaRequest(dealerId,collegatiIds);        
        OCSCensimentoAnagConvenzionatoRequest req = new OCSCensimentoAnagConvenzionatoRequest();
        req.censimentoAnagraficaConvenzionatoRequest.elenco = elenco;  
        OCSCensimentoAnagConvenzionatoResponse response = (OCSCensimentoAnagConvenzionatoResponse) ApiUtils.callApi('ocs.censimentoAnagraficaConvenzionato', req, OCSCensimentoAnagConvenzionatoResponse.class);
        return response;
    }    
    
    
    public static OCSCensimentoAnagConvenzionatoResponse callCensimentoAnagTitolare (String titolareId) {
		List<OCSCensimentoAnagConvenzionatoRequest.ELenco> elenco=processaRequest(titolareId);        
        OCSCensimentoAnagConvenzionatoRequest req = new OCSCensimentoAnagConvenzionatoRequest();
        req.censimentoAnagraficaConvenzionatoRequest.elenco = elenco;  
        OCSCensimentoAnagConvenzionatoResponse response = (OCSCensimentoAnagConvenzionatoResponse) ApiUtils.callApi('ocs.censimentoAnagraficaConvenzionato', req, OCSCensimentoAnagConvenzionatoResponse.class);
        return response;
    }     
	

    //CENSIMENTO ANAGRAFICA DEALER E COLLEGATI
    public static DatiOCS processaResponse (OCSCensimentoAnagConvenzionatoResponse response, String dealerId) {   
        DatiOCS datiOCS = new DatiOCS();
        datiOCS.chiamataOK=true;
        Account dealer=[SELECT id, OCS_External_Id__c FROM Account WHERE id=:dealerId][0];
        Map<Id, Contact> collegatiMap= new Map<Id, Contact>();
        //List<Contact> collegatiList=SFAConvenzionamento.getCollegatiNonCancellati(dealerId,true);
        List<Contact> collegatiList=SFAConvenzionamento.getCollegati(dealerId);
        System.debug('*** INVOKER OCS CENSIM SERVIZIO collegatiList:: '+collegatiList);
        System.debug('collegatiList.size():: '+collegatiList.size());
        for(Contact co:collegatiList){
            collegatiMap.put(co.Id,co);
            System.debug('CICLO co.Id:: '+co.Id);
            System.debug('CICLO collegatiMap:: '+collegatiMap);
        }
        
        if(response.isOK()){   
            for(OCSCensimentoAnagConvenzionatoResponse.ELenco resElenco:response.censimentoAnagraficaConvenzionatoResponse.elenco){
                if (resElenco.flagrnt=='O'){   //DEALER
                    //process the response for the DEALER:
                    if(Integer.valueof(resElenco.ngr500Controparte)!=0){   //risposta andata a buon fine!
                        dealer.OCS_External_Id__c=AccountUtils.getDealerExternalId(resElenco.ngr500Controparte);
                    } else {   //errore chiamata!
                       datiOCS.chiamataOK=false;
                       datiOCS.message.add('-Convenzionato: '+resElenco.segnala);   
                    }
                } else {    //COLLEGATI
                    if(Integer.valueof(resElenco.ngr500Controparte)!=0){   //risposta andata a buon fine
                        System.debug('resElenco.codrnt:: '+resElenco.codrnt);
                        System.debug('collegatiMap.get(resElenco.codrnt):: '+collegatiMap.get(resElenco.codrnt));
                        collegatiMap.get(resElenco.codrnt).OCS_External_Id__c=resElenco.ngr500Controparte;
                    } else {
                       datiOCS.chiamataOK=false;
                       datiOCS.message.add('-Collegato "'+resElenco.ngr500RagSociale1 + resElenco.ngr500RagSociale2 + '": ' +resElenco.segnala);   
                    }
                    
                }
                
            }
        } else {
            datiOCS.chiamataOK=false;
            datiOCS.message.add('Chiamata del servizio OCS "Censimento Anagrafica Convenzionato" non andata a buon fine. Rivolgersi all\'amministratore di sistema.');              
        }
		
        if (datiOCS.chiamataOK){   //solo nel caso in cui tutto sia andato bene allora aggiorno il dealer e i collegati
            System.debug('INVOKER collegatiMap.values():: '+collegatiMap.values());
            System.debug('INVOKER collegatiList:: '+collegatiList);           
            update dealer;
            System.debug('DEALER UPDATED:: ');
            update collegatiList;
        }
        System.debug('INVOKER chiamataOK?:: '+datiOCS.chiamataOK);
        datiOCS.dealer=dealer;
        datiOCS.collegati=collegatiList;
        
		return datiOCS;

        
    }      

    public static List<OCSCensimentoAnagConvenzionatoRequest.ELenco> processaRequest (String dealerId, List<String> collegatiIds) {
        Account dealer=SFAConvenzionamento.getDealerById(dealerId);
        Contact dealerContact =SFAConvenzionamento.getContactDiRiferimentoDealer(dealerId);
        List<Contact> collegati=SFAConvenzionamento.getCollegatiNonCancellati(dealerId,true);
		

     	
        //String dealerProvAbbreviata=[SELECT Id, Provincia_Desc__c, Provincia__c FROM XCS_Town__c WHERE Provincia_Desc__c=:dealer.ShippingState][0].Provincia__c; 
        //Get the abbreviated province of each COLLEGATO:
        /*List<String> coProvList = new List<String>();
        for(Contact co:collegati){
            coProvList.add(co.MailingState);
        }      
        Map<String,String> mapProvCollegati=SFAConvenzionamento.getMapProvinciaEstesaEdAbbreviata(coProvList);*/
        System.debug('collegati: '+collegati);
        System.debug('dealerContact: '+dealerContact);  
        OCSCensimentoAnagConvenzionatoRequest.ELenco elencoDealer = new OCSCensimentoAnagConvenzionatoRequest.ELenco();
		List<OCSCensimentoAnagConvenzionatoRequest.ELenco> elenco = new List<OCSCensimentoAnagConvenzionatoRequest.ELenco>();
        System.debug('elenco: '+elenco);       
        
		//DEALER::
        if(!String.isEmpty(dealer.Name)){
            if(dealer.Name.length()>30){
                elencoDealer.ngr500RagSociale1=dealer.Name.touppercase().substring(0,30);
                elencoDealer.ngr500RagSociale2 = dealer.Name.touppercase().substring(30, dealer.Name.length()>60?60:dealer.Name.length());            
            } else {
                elencoDealer.ngr500RagSociale1=dealer.Name.touppercase();
            }
        }
       if (dealer.Type_Anag__c=='F'){    //dealer.Type_Anag__c=='P' non è un'opzione da prevedere     //ATTENZIONE: in realtà forse potremmo salvarli nell'Account e nel contact!!! perchè sono dati del dealer e NON del contact di riferimento visto che l'anagrafica sarebbe FISICA!!!!    
		 System.debug('++++++++++++++++++++++++++++ SONO DENTRO L\'IF DELL\'ANAGRAFICA FISICA');
         elencoDealer.ngr500Cognome=String.IsEmpty(dealerContact.LastName)?'':dealerContact.LastName.touppercase();    
         elencoDealer.ngr500Nome=String.IsEmpty(dealerContact.FirstName)?'':dealerContact.FirstName.touppercase();
         elencoDealer.ngr500Sesso=dealerContact.Sesso__c;
         System.debug('!!!!!!!!!!!!!!!!!!!ngr500NascitaData:: '+dealerContact.Birthdate);
         elencoDealer.ngr500NascitaData=dealerContact.Birthdate==null?'0':DateUtils.formatDateYYYYMMDD(dealerContact.Birthdate);
         System.debug('!!!!!!!!!!!!!!!!!!!elencoDealer.ngr500NascitaData:: '+elencoDealer.ngr500NascitaData);
         elencoDealer.ngr500NascitaLoc=dealerContact.Luogo_Nascita__c;
         elencoDealer.ngr500NascitaProv=dealerContact.Provincia_Nascita__c;     
       } else {
          elencoDealer.ngr500NascitaData='0';
       }

        
        if (dealer.Type_Anag__c!='A'){  
            System.debug('dealer.Partita_IVA__c: '+dealer.Partita_IVA__c); 
            if(!String.isEmpty(dealer.Partita_IVA__c) && dealer.Partita_IVA__c.length()==11){    //l'ho aggiunto io questo controllo in quanto può capitare che passo una partita IVA > 11
                elencoDealer.ngr500PartitaIva=dealer.Partita_IVA__c;
            }            
            if (String.isEmpty(dealer.Codice_Fiscale__c))
                elencoDealer.ngr500CodiceFiscale=dealer.Partita_IVA__c;
            else
                elencoDealer.ngr500CodiceFiscale=dealer.Codice_Fiscale__c;
        }

        elencoDealer.ngr500TipoAnagrafica=dealer.Type_Anag__c; 
        elencoDealer.acFormaGiuridica=dealer.Forma_Giuridica__c;     
        
        
        //STREET::
        if(dealer.ShippingStreet.length()>30){
            elencoDealer.ngr500Indirizzo1=dealer.ShippingStreet.substring(0,30);
            elencoDealer.ngr500Indirizzo2 = dealer.ShippingStreet.substring(30, dealer.ShippingStreet.length()>60?60:dealer.ShippingStreet.length());            
        } else {
            elencoDealer.ngr500Indirizzo1=dealer.ShippingStreet;
        }        
        
        //CITY::
        if (!String.isEmpty(dealer.ShippingCity) && dealer.ShippingCity.length() > 24){
            elencoDealer.ngr500Localita = dealer.ShippingCity.substring(0,24);
        } else {
            elencoDealer.ngr500Localita = dealer.ShippingCity;
        }
    
        elencoDealer.ngr500Provincia=dealer.ShippingState; 
        elencoDealer.ngr500Cap=dealer.ShippingPostalCode.trim();
        elencoDealer.ngr500Telefono=dealerContact.Phone;
        elencoDealer.ngr500Telefono2=dealerContact.Fax;
        elencoDealer.ngr500TelefonoCel=dealerContact.MobilePhone;
        elencoDealer.ngr500Email=checkEmailPec(dealerContact.Email); 
        elencoDealer.ngr500DtPrivacyIstrutt='0';
        elencoDealer.ngr500DtPrivacyOfferte='0';
        elencoDealer.ngr500DtPrivacySensibili='0';
        elencoDealer.ngr500DataConsInfoSic='0';
        elencoDealer.ngr500TipoSegnalaz='CPO';
        elencoDealer.ngr500CampDataAtt='0';
        elencoDealer.ngr500Modalita='S';
        elencoDealer.codrnt=dealer.Id;
        elencoDealer.flagrnt='O';
        elencoDealer.acSottogruppo=dealer.Sae__c;
        elencoDealer.acRamogruppo=dealer.Rae__c;
        elencoDealer.acAteco=dealer.COD_Ateco__c;
        elenco.add(elencoDealer);
        
        
        
        //COLLEGATI:
        String nomeCompleto,codiceFiscale, indirizzoResidenzaCompleto='',indirizzoResidenzaStreet,indirizzoResidenzaCity,indirizzoResidenzaState,indirizzoResidenzaPostalCode,indirizzoResidenzaCountry;
        for(Contact co:collegati){
            OCSCensimentoAnagConvenzionatoRequest.ELenco elencoCollegato = new OCSCensimentoAnagConvenzionatoRequest.ELenco();
            if(!String.isEmpty(co.LastName)){      //questo controllo perchè se è null mi stampa nella stringa il 'null' al posto del LastName
                nomeCompleto = co.LastName.touppercase();
                if(!String.isEmpty(co.FirstName)){
                    nomeCompleto = nomeCompleto.touppercase() +' '+co.FirstName.touppercase();
                }
            } else if(!String.isEmpty(co.FirstName)){
                nomeCompleto = co.FirstName.touppercase();
            }
            
            if(!String.isEmpty(nomeCompleto)){                            
                if(nomeCompleto.length()>30){
                    elencoCollegato.ngr500RagSociale1=nomeCompleto.touppercase().substring(0,30);
                    elencoCollegato.ngr500RagSociale2 = nomeCompleto.touppercase().substring(30, nomeCompleto.length()>60?60:nomeCompleto.length());            
                } else {
                    elencoCollegato.ngr500RagSociale1=nomeCompleto.touppercase();
                }                    
			}
            
            if(co.LastName.length()>30){
                elencoCollegato.ngr500RagSociale1=nomeCompleto.touppercase().substring(0,30);
                elencoCollegato.ngr500RagSociale2 = nomeCompleto.touppercase().substring(30, nomeCompleto.length()>60?60:nomeCompleto.length());            
            } else {
                elencoCollegato.ngr500RagSociale1=nomeCompleto.touppercase();
            }            
 
            if(co.LastName!=null){
                if (co.LastName.length()>30) {
                    elencoCollegato.ngr500Cognome=co.LastName.touppercase().substring(0,30);
            	} else {
                    elencoCollegato.ngr500Cognome=co.LastName.touppercase();  
                }
            }
            
            if(!String.isEmpty(co.LastName) && co.FirstName != null ){ 
                if (co.FirstName.length()>30) {
                    elencoCollegato.ngr500Nome=co.FirstName.touppercase().substring(0,30);
            	} else {
                    elencoCollegato.ngr500Nome=co.FirstName.touppercase();  
                }
            }             
            
            
            
			codiceFiscale=co.Codice_Fiscale__c;
            if (String.isEmpty(co.Codice_Fiscale__c)){	
              elencoCollegato.ngr500TipoAnagrafica='A'; 
            } else if (co.Codice_Fiscale__c.length()==11){	
              elencoCollegato.ngr500PartitaIva=co.Codice_Fiscale__c;     	 	
              elencoCollegato.ngr500TipoAnagrafica='A';
            } else {
              elencoCollegato.ngr500CodiceFiscale=co.Codice_Fiscale__c; 
              elencoCollegato.ngr500TipoAnagrafica='P';	
            }
            
            //costruire l'indirizzo completo del collegato
            indirizzoResidenzaStreet=String.isEmpty(co.MailingStreet)?'':co.MailingStreet;
            indirizzoResidenzaCity=String.isEmpty(co.MailingCity)?'':co.MailingCity;
            indirizzoResidenzaState=String.isEmpty(co.MailingState)?'':co.MailingState;
            indirizzoResidenzaPostalCode=String.isEmpty(co.MailingPostalCode)?'':co.MailingPostalCode.trim();
            indirizzoResidenzaCountry=String.isEmpty(co.MailingCountry)?'':co.MailingCountry;
            indirizzoResidenzaCompleto=indirizzoResidenzaStreet+', '+indirizzoResidenzaCity+', '+indirizzoResidenzaState+', '+indirizzoResidenzaPostalCode+', '+indirizzoResidenzaCountry;
            indirizzoResidenzaCompleto=indirizzoResidenzaCompleto.removeStart(', ');
            if (elencoCollegato.ngr500TipoAnagrafica=='P'){ 
                if (String.isEmpty(indirizzoResidenzaCompleto))
                    elencoCollegato.ngr500TipoAnagrafica='A'; 
                else
                    elencoCollegato.ngr500TipoAnagrafica='P';  
            }
			elencoCollegato.ngr500Sesso=String.isEmpty(co.Sesso__c)?'':co.Sesso__c;
            
            if (co.Birthdate!=null){
                System.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@elencoCollegato.ngr500NascitaData data non nulla: '+elencoCollegato.ngr500NascitaData);
                elencoCollegato.ngr500NascitaData=DateUtils.formatDateYYYYMMDD(co.Birthdate);	
                elencoCollegato.ngr500NascitaLoc=String.isEmpty(co.Luogo_Nascita__c)?'':co.Luogo_Nascita__c;
                elencoCollegato.ngr500NascitaProv=String.isEmpty(co.Provincia_Nascita__c)?'':co.Provincia_Nascita__c;
            } else {
                elencoCollegato.ngr500NascitaData='0';
                System.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@elencoCollegato.ngr500NascitaData data nulla: '+elencoCollegato.ngr500NascitaData);
            }          

            if(indirizzoResidenzaCompleto.length()>30){
                elencoCollegato.ngr500Indirizzo1=indirizzoResidenzaCompleto.substring(0,30);
                elencoCollegato.ngr500Indirizzo2 = indirizzoResidenzaCompleto.substring(30, indirizzoResidenzaCompleto.length()>60?60:indirizzoResidenzaCompleto.length());            
            } else {
                elencoCollegato.ngr500Indirizzo1=indirizzoResidenzaCompleto;
            }            
            
            if (indirizzoResidenzaCity.length() > 24){
                elencoCollegato.ngr500Localita = indirizzoResidenzaCity.substring(0,24);
            } else {
                elencoCollegato.ngr500Localita = indirizzoResidenzaCity;
            }
            
            elencoCollegato.ngr500Provincia=co.MailingState;        
            elencoCollegato.ngr500Cap=indirizzoResidenzaPostalCode;              
            elencoCollegato.ngr500Telefono=String.valueof(String.isEmpty(co.HomePhone)?'':co.HomePhone);    
            elencoCollegato.ngr500TelefonoCel=String.valueof(String.isEmpty(co.MobilePhone)?'':co.MobilePhone);   
            elencoCollegato.ngr500Email=checkEmailPec(co.Email);
            elencoCollegato.ngr500DtPrivacyIstrutt='0';
            elencoCollegato.ngr500DtPrivacyOfferte='0';
            elencoCollegato.ngr500DtPrivacySensibili='0';
            elencoCollegato.ngr500DataConsInfoSic='0';
            elencoCollegato.ngr500TipoSegnalaz='CPO';
            elencoCollegato.ngr500CampDataAtt='0';
            elencoCollegato.ngr500Modalita='S';
            elencoCollegato.codrnt=co.Id;  
            elencoCollegato.flagrnt='C';
            elenco.add(elencoCollegato);	            
            
        }

        return elenco;
    }
    
	//CENSIMENTO ANAGRAFICA TITOLARE    
    public static DatiOCStitolare processaResponseTitolare(OCSCensimentoAnagConvenzionatoResponse response, String titolareId) {   
        DatiOCStitolare datiOCS = new DatiOCStitolare();
        datiOCS.chiamataOK=true;
        //Contact titolare=[SELECT id, OCS_External_Id__c FROM Contact WHERE id=:titolareId][0];
		Contact titolare=new Contact(Id=titolareId);
        
        if(response.isOK()){   
            for(OCSCensimentoAnagConvenzionatoResponse.ELenco resElenco:response.censimentoAnagraficaConvenzionatoResponse.elenco){
                if(Integer.valueof(resElenco.ngr500Controparte)!=0){   //risposta andata a buon fine
                    System.debug('resElenco.codrnt:: '+resElenco.codrnt);
                    titolare.OCS_External_Id__c=resElenco.ngr500Controparte;
                } else {
                    datiOCS.chiamataOK=false;
                    datiOCS.message=resElenco.segnala;   
                }
                
            }
        } else {
            datiOCS.chiamataOK=false;
            datiOCS.message='Chiamata del servizio OCS "Censimento Anagrafica Convenzionato" non andata a buon fine. Rivolgersi all\'amministratore di sistema.';              
        }
        
        if (datiOCS.chiamataOK){   //solo nel caso in cui tutto sia andato bene allora aggiorno il dealer e i collegati
            update titolare;
        } 
        
		return datiOCS;
    }
    
    public static List<OCSCensimentoAnagConvenzionatoRequest.ELenco> processaRequest (String titolareId) {
        String titProvAbbreviata='',nomeCompleto,codiceFiscale, indirizzoResidenzaCompleto='',indirizzoResidenzaStreet,indirizzoResidenzaCity,indirizzoResidenzaState,indirizzoResidenzaPostalCode,indirizzoResidenzaCountry;

        Contact co = [SELECT Id, LastName, FirstName, OCS_External_Id__c, Sesso__c, Luogo_Nascita__c, Birthdate, Codice_Fiscale__c, Partita_IVA__c, 
                                       Email, HomePhone, MobilePhone, MailingAddress, MailingCity, MailingCountry, MailingPostalCode, MailingState, MailingStreet, RagioneSociale__c, 
                                       DataInizioAttivita__c, CittaSede__c, Provincia_Nascita__c, Tipo_Anagrafica__c, IsResidenteEstero__c 
                                   	   FROM Contact 
                                       WHERE id=:titolareId ];

       
        OCSCensimentoAnagConvenzionatoRequest.ELenco elencoTitolare = new OCSCensimentoAnagConvenzionatoRequest.ELenco();
		List<OCSCensimentoAnagConvenzionatoRequest.ELenco> elenco = new List<OCSCensimentoAnagConvenzionatoRequest.ELenco>();
        System.debug('elenco: '+elenco);       
                
        if(co.LastName!=null){    //questo controllo perchè se è null mi stampa nella stringa il 'null' al posto del LastName
            nomeCompleto = co.LastName.touppercase();
            if(co.FirstName!=null){
                nomeCompleto = nomeCompleto.touppercase() +' '+co.FirstName.touppercase();
            }
        } else if(co.FirstName!=null){
            nomeCompleto = co.FirstName.touppercase();
        }
        
        if(nomeCompleto!=null){                            
            if(nomeCompleto.length()>30){
                elencoTitolare.ngr500RagSociale1=nomeCompleto.touppercase().substring(0,30);
                elencoTitolare.ngr500RagSociale2 = nomeCompleto.touppercase().substring(30, nomeCompleto.length()>60?60:nomeCompleto.length());            
            } else {
                elencoTitolare.ngr500RagSociale1=nomeCompleto.touppercase();
            }                    
        }
        
        if(co.LastName.length()>30){
            elencoTitolare.ngr500RagSociale1=nomeCompleto.touppercase().substring(0,30);
            elencoTitolare.ngr500RagSociale2 = nomeCompleto.touppercase().substring(30, nomeCompleto.length()>60?60:nomeCompleto.length());            
        } else {
            elencoTitolare.ngr500RagSociale1=nomeCompleto.touppercase();
        }            
        
        if(co.LastName!=null){
            if (co.LastName.length()>30) {
                elencoTitolare.ngr500Cognome=co.LastName.touppercase().substring(0,30);
            } else {
                elencoTitolare.ngr500Cognome=co.LastName.touppercase();  
            }
        }
        
        if(co.FirstName!=null){
            if (co.FirstName.length()>30) {
                elencoTitolare.ngr500Nome=co.FirstName.touppercase().substring(0,30);
            } else {
                elencoTitolare.ngr500Nome=co.FirstName.touppercase();  
            }
        }            
        
        codiceFiscale=co.Codice_Fiscale__c;
        if (String.isEmpty(co.Codice_Fiscale__c)){	
            elencoTitolare.ngr500TipoAnagrafica='A'; 
        } else if (co.Codice_Fiscale__c.length()==11){	
            elencoTitolare.ngr500PartitaIva=co.Codice_Fiscale__c;     	 	
            elencoTitolare.ngr500TipoAnagrafica='A';
        } else {
            elencoTitolare.ngr500CodiceFiscale=co.Codice_Fiscale__c; 
            elencoTitolare.ngr500TipoAnagrafica='P';	
        }
        
        //costruire l'indirizzo completo del collegato
        indirizzoResidenzaStreet=String.isEmpty(co.MailingStreet)?'':co.MailingStreet;
        indirizzoResidenzaCity=String.isEmpty(co.MailingCity)?'':co.MailingCity;
        indirizzoResidenzaState=String.isEmpty(co.MailingState)?'':co.MailingState;
        indirizzoResidenzaPostalCode=String.isEmpty(co.MailingPostalCode)?'':co.MailingPostalCode.trim();
        indirizzoResidenzaCountry=String.isEmpty(co.MailingCountry)?'':co.MailingCountry;
        indirizzoResidenzaCompleto=indirizzoResidenzaStreet+', '+indirizzoResidenzaCity+', '+indirizzoResidenzaState+', '+indirizzoResidenzaPostalCode+', '+indirizzoResidenzaCountry;
        indirizzoResidenzaCompleto=indirizzoResidenzaCompleto.removeStart(', ');
        if (elencoTitolare.ngr500TipoAnagrafica=='P'){ 
            if (String.isEmpty(indirizzoResidenzaCompleto))
                elencoTitolare.ngr500TipoAnagrafica='A'; 
            else
                elencoTitolare.ngr500TipoAnagrafica='P';  
        }
        
        elencoTitolare.ngr500Sesso=String.isEmpty(co.Sesso__c)?'':co.Sesso__c;
        
        if (co.Birthdate!=null){
            System.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@elencoTitolare.ngr500NascitaData data non nulla: '+elencoTitolare.ngr500NascitaData);
            elencoTitolare.ngr500NascitaData=DateUtils.formatDateYYYYMMDD(co.Birthdate);	
            elencoTitolare.ngr500NascitaLoc=String.isEmpty(co.Luogo_Nascita__c)?'':co.Luogo_Nascita__c;
            elencoTitolare.ngr500NascitaProv=String.isEmpty(co.Provincia_Nascita__c)?'':co.Provincia_Nascita__c;
        } else {
            elencoTitolare.ngr500NascitaData='0';
            System.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@elencoTitolare.ngr500NascitaData data nulla: '+elencoTitolare.ngr500NascitaData);
        }          
        
        
        if(indirizzoResidenzaCompleto.length()>30){
            elencoTitolare.ngr500Indirizzo1=indirizzoResidenzaCompleto.substring(0,30);
            elencoTitolare.ngr500Indirizzo2 = indirizzoResidenzaCompleto.substring(30, indirizzoResidenzaCompleto.length()>60?60:indirizzoResidenzaCompleto.length());            
        } else {
            elencoTitolare.ngr500Indirizzo1=indirizzoResidenzaCompleto;
        }            
        
        
        if (indirizzoResidenzaCity.length() > 24){
            elencoTitolare.ngr500Localita = indirizzoResidenzaCity.substring(0,24);
        } else {
            elencoTitolare.ngr500Localita = indirizzoResidenzaCity;
        }
                
        elencoTitolare.ngr500Provincia=indirizzoResidenzaState; //titProvAbbreviata;    
        elencoTitolare.ngr500Cap=indirizzoResidenzaPostalCode;               
        elencoTitolare.ngr500Telefono=String.valueof(String.isEmpty(co.HomePhone)?'':co.HomePhone);    
        elencoTitolare.ngr500TelefonoCel=String.valueof(String.isEmpty(co.MobilePhone)?'':co.MobilePhone);   
        elencoTitolare.ngr500Email=checkEmailPec(co.Email); 
        elencoTitolare.ngr500DtPrivacyIstrutt='0';
        elencoTitolare.ngr500DtPrivacyOfferte='0';
        elencoTitolare.ngr500DtPrivacySensibili='0';
        elencoTitolare.ngr500DataConsInfoSic='0';
        elencoTitolare.ngr500TipoSegnalaz='CPO';
        elencoTitolare.ngr500CampDataAtt='0';
        elencoTitolare.ngr500Modalita='S';
        elencoTitolare.codrnt=co.Id; 
        elencoTitolare.flagrnt='C';
        elenco.add(elencoTitolare);	            

        return elenco;
    }  

    private static String checkEmailPec(String email){
        if(!String.isEmpty(email)){
            if(ValidationUtils.isEmailPECValida(email)){
                email='';   //se si tratta di un'email PEC allora al servizio viene passata una stringa vuota
            }            
        }
        return email;
    }
    
 	public class DatiOCS {
        @AuraEnabled
        public List<String> message {get { if (message == null ) message = new List<String>(); return message; } set;}
        @AuraEnabled
        public Boolean chiamataOK {get; set;} 
        @AuraEnabled
        public Account dealer {get { if (dealer == null ) dealer = new Account(); return dealer; } set;} 
        @AuraEnabled
        public List<Contact> collegati {get { if (collegati == null ) collegati = new List<Contact>(); return collegati; } set;}         
    }   
    
 	public class DatiOCStitolare {
        @AuraEnabled
        public String message {get; set;}  
        @AuraEnabled
        public Boolean chiamataOK {get; set;}          
    }    
    
    
}