//----------------------------------------------------------------------
//-- - Class Name   : OCSObjectFactory
//-- - Autor        : 
//-- - Date         : 05/06/2019
//-- - Description  : 
//-- - Version      : 1.0
//----------------------------------------------------------------------
public class OCSObjectsFactory {
    
    public static OCSPratica makePratica(Map<String,String> data){
        system.debug('----------------------------------------------------------------------------------');
        system.debug('-- Class Name: OCSObjectFactory  - Method Name : makePratica'); 
        system.debug('-- Variable Name: data  - Value: ' + data); 

        OCSPratica res=new OCSPratica();
        res.abi=data.get('abi');
        res.numPratica=data.get('numPratica');
        res.codCliente=data.get('codCliente');
        res.cab=data.get('cab');
        res.numConto=data.get('numConto');
        res.iban=data.get('iban');
        res.statoPratica=data.get('statoPratica');
        res.tipoPagamento=data.get('tipoPagamento');
        res.prodotto=data.get('prodotto');
        res.filiale=data.get('filiale');
        res.dataEstinzione=data.get('dataEstinzione');
        res.tipoPratica=data.get('tipoPratica');
        res.dataCaricamento=data.get('dataCaricamento');
        res.pan=data.get('pan');
        res.convenzionato=data.get('convenzionato');
        res.puntoVendita=data.get('puntoVendita');
        res.venditore=data.get('venditore');
        res.agente=data.get('agente');
        res.subAgente=data.get('subAgente');
        res.flagRecupero=data.get('flagRecupero');
        res.classifRecupero=data.get('classifRecupero');
        res.societa=data.get('societa');
        res.elencoCoobbligati = DeserializeCoobb(data.get('elencoCoobbligati'));
        res.codStatoPratica=data.get('codStatoPratica');
        res.codAttributoPratica=data.get('codAttributoPratica');
        res.desStatoPratica=data.get('desStatoPratica');
        res.desAttributoPratica=data.get('desAttributoPratica');
        res.codRecuperatore=data.get('codRecuperatore');
        res.desRecuperatore=data.get('desRecuperatore');
        res.canale=data.get('canale');
        res.cedCom=data.get('cedCom');
        return res;
    }
    
    public static OCSCliente[] DeserializeCoobb(string Coobbligati){
        if(string.isEmpty(coobbligati))
          return new list<OCSCliente>();
        return (OCSCliente[])JSON.deserialize(Coobbligati,OCSCliente[].class);
    }
    
    public static OCSPratica makePratica(OCSRecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO p){
        system.debug('----------------------------------------------------------------------------------');
        system.debug('-- Class Name: OCSObjectFactory  - Method Name : makePratica'); 
        system.debug('-- Variable Name: p  - Value: ' + p); 

        OCSPratica res=new OCSPratica();
        res.abi=p.abi;
        res.agente=p.agente;
        res.cab=p.cab;
        res.canale=p.canale;
        res.classifRecupero=p.classifRecupero;
        res.codAttributoPratica=p.codAttributoPratica;
        res.codCliente=p.codCliente;
        res.codRecuperatore=p.codRecuperatore;
        res.codStatoPratica=p.codStatoPratica;
        res.convenzionato=p.convenzionato;
        res.dataCaricamento=p.dataCaricamento;
        res.dataEstinzione=p.dataEstinzione;
        res.desAttributoPratica=p.desAttributoPratica;
        res.desRecuperatore=p.desRecuperatore;
        res.desStatoPratica=p.desStatoPratica;
        res.elencoCoobbligati=makeClienti(p.elencoCoobbligati);
        res.filiale=p.filiale;
        res.flagRecupero=p.flagRecupero;
        res.iban=p.iban;
        res.numConto=p.numConto;
        res.numPratica=p.numPratica;
        res.pan=p.pan;
        res.prodotto=p.prodotto;
        res.puntoVendita=p.puntoVendita;
        res.societa=p.societa;
        res.statoPratica=p.statoPratica;
        res.subAgente=p.subAgente;
        res.tipoPagamento=p.tipoPagamento;
        res.tipoPratica=p.tipoPratica;
        res.venditore=p.venditore;
        return res;
    }
    
    public static OCSPraticaFuturo makePraticaFuturo(Map<String,String> data){
        system.debug('----------------------------------------------------------------------------------');
        system.debug('-- Class Name: OCSObjectFactory  - Method Name : makePraticaFuturo'); 
        system.debug('-- Variable Name: data  - Value: ' + data); 

        OCSPraticaFuturo res=new OCSPraticaFuturo();
        res.numPratica=data.get('numPratica');
        res.codCliente=data.get('codCliente');
        res.dataCaricamento=data.get('dataCaricamento');
        res.tipoPratica=data.get('tipoPratica');
        res.codStatoPratica=data.get('codStatoPratica');
        res.codAttributoPratica=data.get('codAttributoPratica');
        res.desStatoPratica=data.get('desStatoPratica');
        res.desAttributoPratica=data.get('desAttributoPratica');
        res.dataContratto=data.get('dataContratto');
        res.dataEstinzioneAnticipata=data.get('dataEstinzioneAnticipata');
        res.flagRecupero=data.get('flagRecupero');
        res.classifRecupero=data.get('classifRecupero');
        res.codRecuperatore=data.get('codRecuperatore');
        res.desRecuperatore=data.get('desRecuperatore');
        res.aziendaCod=data.get('aziendaCod');
        res.aziendaRagSoc=data.get('aziendaRagSoc');
        res.aziendaIndirizzo=data.get('aziendaIndirizzo');
        res.aziendaCap=data.get('aziendaCap');
        res.aziendaLocalita=data.get('aziendaLocalita');
        res.aziendaProv=data.get('aziendaProv');
        res.aziendaSedeCod=data.get('aziendaSedeCod');
        res.aziendaSedeRagSoc=data.get('aziendaSedeRagSoc');
        res.aziendaSedeIndirizzo=data.get('aziendaSedeIndirizzo');
        res.aziendaSedeCap=data.get('aziendaSedeCap');
        res.aziendaSedeLocalita=data.get('aziendaSedeLocalita');
        res.aziendaSedeProv=data.get('aziendaSedeProv');
        res.agenteCod=data.get('agenteCod');
        res.agenteRagSoc=data.get('agenteRagSoc');
        res.subAgenteCod=data.get('subAgenteCod');
        res.subAgenteRagSoc=data.get('subAgenteRagSoc');
        res.bancaCod=data.get('bancaCod');
        res.bancaRagSoc=data.get('bancaRagSoc');
        res.filBancaCod=data.get('filBancaCod');
        res.filBancaRagSoc=data.get('filBancaRagSoc');
        res.assicVitaCod=data.get('assicVitaCod');
        res.assicVitaRagSoc=data.get('assicVitaRagSoc');
        res.assicImpiegoCod=data.get('assicImpiegoCod');
        res.assicImpiegoRagSoc=data.get('assicImpiegoRagSoc');
        return res;
    } 
    
    public static List<OCSPratica> makePratiche(OCSRecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO[] data){
        system.debug('----------------------------------------------------------------------------------');
        system.debug('-- Class Name: OCSObjectFactory  - Method Name : makePratiche'); 
        system.debug('-- Variable Name: data  - Value: ' + data); 

        List<OCSPratica> res=new List<OCSPratica>();
        try{
            for(OCSRecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO t:data){
                res.add(makePratica(t.getMap()));
            }
        }
        catch(Exception e){
            System.debug('makePratiche Exception, data was null');
            res=new List<OCSPratica>();
        }
        
        return res;
    }
    
    public static List<OCSPraticaFuturo> makePratiche(OCSRecuperaDatiFuturoResponse.DatiPraticaFuturoDTO[] data){
        system.debug('----------------------------------------------------------------------------------');
        system.debug('-- Class Name: OCSObjectFactory  - Method Name : makePratiche'); 
        system.debug('-- Variable Name: data  - Value: ' + data); 

        List<OCSPraticaFuturo> res=new List<OCSPraticaFuturo>();
        try{
            for(OCSRecuperaDatiFuturoResponse.DatiPraticaFuturoDTO t:data){
                res.add(makePraticaFuturo(t.getMap()));
            }
        }
        catch(Exception e){
            System.debug('makePratiche Exception, data was null');
            res=new List<OCSPraticaFuturo>();
        }
        
        return res;
    }
    
    public static OCSCliente makeCliente(Map<String,String> data){
        system.debug('----------------------------------------------------------------------------------');
        system.debug('-- Class Name: OCSObjectFactory  - Method Name : makeCliente(Map<String,String> data)'); 
        system.debug('-- Variable Name: data  - Value: ' + data); 
        system.debug('-- Variable Name: nascita  - Value: ' + data.get('dataNascita')); 

        OCSCliente res=new OCSCliente();
        res.cognome=data.get('cognome');
        res.codCliente=data.get('codCliente');
        res.nome=data.get('nome');
        res.dataNascita=data.get('dataNascita');
        res.luogoNascita=data.get('luogoNascita');
        res.provNascita=data.get('provNascita');
        res.sesso=data.get('sesso');
        res.codFiscale=data.get('codFiscale');
        res.piva=data.get('piva');
        res.indirizzo=data.get('indirizzo');
        res.cap=data.get('cap');
        res.localita=data.get('localita');
        res.provincia=data.get('provincia');
        res.paeseEstero=data.get('paeseEstero');
        res.email=data.get('email');
        res.tipoDocumento=data.get('tipoDocumento');
        res.numDocumento=data.get('numDocumento');
        res.ufficioRilascio=data.get('ufficioRilascio');
        res.luogoRilascio=data.get('luogoRilascio');
        res.provRilascio=data.get('provRilascio');
        res.dataRilascio=data.get('dataRilascio');
        res.denominazioneAzienda=data.get('denominazioneAzienda');
        res.formaGiuridica=data.get('formaGiuridica');
        res.tipoAnagrafica=data.get('tipoAnagrafica');
        res.dataScadenza=data.get('dataScadenza');
        res.telefonoCasa=data.get('telefonoCasa');
        res.telCellulare=data.get('telCellulare');
        res.tipoRapporto=data.get('tipoRapporto');
        res.dataDepennamento=data.get('dataDepennamento');
        res.ndg=data.get('ndg');
        res.ragioneSociale=data.get('ragioneSociale');
		system.debug('----------------------------------------------------------------------------------');
        system.debug('-- Class Name: OCSObjectsFactory  - Method Name : makeCliente'); 
        system.debug('-- Variable Name: res(final)  - Value: ' + res); 
        return res;
    }
    
    public static OCSCliente makeCliente(Account a){
        system.debug('----------------------------------------------------------------------------------');
        system.debug('-- Class Name: OCSObjectFactory  - Method Name : makeCliente(Account a)'); 
        system.debug('-- Variable Name: data  - Value: ' + a); 
        system.debug('-- Variable Name: nascita  - Value: ' + a.Data_Nascita__c+''); 

        OCSCliente res=new OCSCliente();
        res.cognome=a.LastName;
        res.codCliente=a.getCodice_Cliente__c;
        res.nome=a.FirstName;
       // res.dataNascita=a.Data_Nascita__c+''; commentata per verificare una funzionalità
        res.luogoNascita=a.Luogo_Nascita__pc; 
        res.provNascita=a.Provincia_Nascita__pc;
        res.sesso=a.Sesso__pc;
        res.codFiscale=a.Codice_Fiscale__pc;
        res.piva=a.Partita_IVA__pc;
        res.indirizzo=a.PersonMailingStreet;
        res.cap=a.PersonMailingPostalCode;
        res.localita=a.PersonMailingCity;
        res.provincia=a.PersonMailingCountry;
        res.paeseEstero=a.LastName;
        res.email=a.PersonEmail;
        res.tipoDocumento=a.Tipo_documento__pc;
        res.numDocumento=a.Numero_Documento__pc;
        res.ufficioRilascio=a.Ufficio_Rilascio__c;
        res.luogoRilascio=a.Luogo_Rilascio__pc;
        res.provRilascio=a.Provincia_Rilascio__pc;
        res.dataRilascio=a.Data_Rilascio__pc+'';
        res.denominazioneAzienda=a.Denominazione_Azienda__c;
        res.formaGiuridica=a.Forma_Giuridica__c;
        res.tipoAnagrafica=a.Tipo_Anagrafica__pc;
        res.dataScadenza=a.Data_Scadenza__pc+'';
        res.telefonoCasa=a.Telefono_Casa__c;
        res.telCellulare=a.Telefono_Cellulare__c;
        res.tipoRapporto=a.Tipo_Rapporto__c;
        res.dataDepennamento=a.Data_Depennamento__c+'';
        res.ndg=a.ndg__c;
        res.denominazione=a.FirstName+' '+a.LastName;
        res.ragioneSociale=res.denominazioneAzienda;
        res.SFId=a.Id;
        return res;
    }
    
    public static OCSCliente makeClienteFuturoMBCS(Account_Futuro_MBCS__c a){
        system.debug('----------------------------------------------------------------------------------');
        system.debug('-- Class Name: OCSObjectFactory  - Method Name : makeClientefuturoMBCS(Account_Futuro_MBCS__c a)'); 
        system.debug('-- Variable Name: a  - Value: ' + a); 
        system.debug('-- Variable Name: nascita  - Value: ' + a.Birthdate__c+''); 

        OCSCliente res=new OCSCliente();
        res.cognome=a.LastName__c;
        res.codCliente=a.External_Id__c;
        res.nome=a.FirstName__c;
        //res.dataNascita=a.Birthdate__c+''; commentata per verificare una funzionalità
        res.luogoNascita=a.Birthcity__c;
        res.provNascita=a.Birthprovince__c;
        res.sesso=a.Sesso__c;
        res.codFiscale=a.Codice_Fiscale__c;
        res.indirizzo=a.Street__c;
        res.cap=a.Zip_Code__c;
        res.localita=a.City__c;
        res.provincia=a.Province__c;
        res.email=a.Email__c;
        res.telefonoCasa=a.Phone__c;
        res.telCellulare=a.Mobile__c;
        res.denominazione=a.FirstName__c+' '+a.LastName__c;
        res.ragioneSociale=res.denominazioneAzienda;
        res.SFId=a.Id;
        return res;
    }
    
    public static List<OCSCliente> makeClienti(List<OCSRecuperaDatiPostvenditaResponse.PSVDatiClienteDTO> data){
        system.debug('----------------------------------------------------------------------------------');
        system.debug('-- Class Name: OCSObjectFactory  - Method Name : makeClienti(List<OCSRecuperaDatiPostvenditaResponse.PSVDatiClienteDTO> data)'); 
        List<OCSCliente> res=new List<OCSCliente>();
        try{
            for(OCSRecuperaDatiPostvenditaResponse.PSVDatiClienteDTO t: data){
                OCSCliente temp=makeCliente(t.getMap());
                res.add(temp);
            }
        }
        catch(Exception e){
            System.debug('makeClienti exception, probably "elencoCoobbligati" was null');
        }
        System.debug('OCSObjectsFactory makeClienti res: '+res);
        return res;
    }
    
    public static List<OCSCliente> makeClienti(OCSRecuperaDatiPostvenditaResponse data){
        system.debug('----------------------------------------------------------------------------------');
        system.debug('-- Class Name: OCSObjectFactory  - Method Name : makeClienti(OCSRecuperaDatiPostvenditaResponse data)'); 
        system.debug('-- Variable Name: data  - Value: ' + data); 

        List<OCSCliente> res=new List<OCSCLiente>();
        try{
            for(OCSRecuperaDatiPostvenditaResponse.PSVDatiClienteDTO t:data.cliente){
                OCSCliente temp=makeCliente(t.getMap());
                List<OCSRecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO> tempList=new List<OCSRecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO>();
                try{
                    for(OCSRecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO p:data.pratiche){
                        if(p.codCliente.equals(t.codCliente)){
                            tempList.add(p);
                        }
                    }
                }
                catch(Exception e){
                    System.debug('makeClienti exception, probably "pratiche" was null');
                    tempList=new List<OCSRecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO>();
                }
                List<OCSPratica> tempListOk=makePratiche(tempList);
                temp.pratiche=tempListOk;
                res.add(temp);
            }
        }
        catch(Exception e){
            System.debug('OCSObjectsFactory exception, probably cliente was null');
        }
        System.debug('OCSObjectsFactory makeClienti res: '+res);
        return res;
    }
    
    public static List<OCSCliente> makeClienti(OCSRecuperaDatiFuturoResponse data){
        system.debug('----------------------------------------------------------------------------------');
        system.debug('-- Class Name: OCSObjectFactory  - Method Name : makeClienti(OCSRecuperaDatiFuturoResponse data)'); 
        List<OCSCliente> res=new List<OCSCLiente>();
        if(data.cliente!=null){
            for(OCSRecuperaDatiPostvenditaResponse.PSVDatiClienteDTO t:data.cliente){
                OCSCliente temp=makeCliente(t.getMap());
                List<OCSRecuperaDatiFuturoResponse.DatiPraticaFuturoDTO> tempList=new List<OCSRecuperaDatiFuturoResponse.DatiPraticaFuturoDTO>();
                try{
                    for(OCSRecuperaDatiFuturoResponse.DatiPraticaFuturoDTO p:data.pratiche){
                        if(p.codCliente.equals(t.codCliente)){
                            tempList.add(p);
                        }
                    }
                }
                catch(Exception e){
                    System.debug('makeClienti exception, probably "pratiche" was null');
                    tempList=new List<OCSRecuperaDatiFuturoResponse.DatiPraticaFuturoDTO>();
                }
                List<OCSPraticaFuturo> tempListOk=makePratiche(tempList);
                temp.praticheFuturo=tempListOk; 
                res.add(temp);
            }
        }
        System.debug('OCSObjectsFactory makeClienti res: '+res);
        return res;
    }
}