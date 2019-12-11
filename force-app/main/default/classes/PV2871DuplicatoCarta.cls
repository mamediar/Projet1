public with sharing class PV2871DuplicatoCarta extends PVAction {

    public class Indirizzo {
        @AuraEnabled
        public String cap {
            get {
				return cap;
			}
			set {
                cap = value != null ? value.trim() : value;
			}
        }
        @AuraEnabled
        public String capRischio {
            get {
				return capRischio;
			}
			set {
                capRischio = value != null ? value.trim() : value;
			}
        }
        @AuraEnabled
        public String civico {
            get {
				return civico;
			}
			set {
                civico = value != null ? value.trim() : value;
			}
        }
        @AuraEnabled
        public String indirizzo {
            get {
				return indirizzo;
			}
			set {
                indirizzo = value != null ? value.trim() : value;
			}
        }
        @AuraEnabled
        public String localita {
            get {
				return localita;
			}
			set {
                localita = value != null ? value.trim() : value;
			}
        }
        @AuraEnabled
        public String nazione {
            get {
				return nazione;
			}
			set {
                nazione = value != null ? value.trim() : value;
			}
        }
        @AuraEnabled
        public String provincia {
            get {
				return provincia;
			}
			set {
                provincia = value != null ? value.trim() : value;
			}
        }
        @AuraEnabled
        public String tipoIndirizzo {
            get {
				return tipoIndirizzo;
			}
			set {
                tipoIndirizzo = value != null ? value.trim() : value;
			}
        }

        public Indirizzo() {
            this('', '', '', '', '', '', '', '');
        }

        public Indirizzo(String cap, String capRischio, String civico, String indirizzo, String localita, String nazione, String provincia, String tipoIndirizzo) {
            this.cap = cap;
            this.capRischio = capRischio;
            this.civico = civico;
            this.indirizzo = indirizzo;
            this.localita = localita;
            this.nazione = nazione;
            this.provincia = provincia;
            this.tipoIndirizzo = tipoIndirizzo;
        }
    }

    public class DatiDuplicatoCarta{
        @AuraEnabled
        public String numeroCarta { get; set; }
        @AuraEnabled
        public String emettitore { get; set; }
        @AuraEnabled
        public String bloccoCarta { get; set; }
        @AuraEnabled
        public String dataValidita { get; set; }
        @AuraEnabled
        public String dataRientroProduzione { get; set; }
        @AuraEnabled
        public String origine { get; set; }
        @AuraEnabled
        public Double commissioni { get; set; }
        @AuraEnabled
        public Boolean applicaCommissioni { get; set; }
        @AuraEnabled
        public Boolean mostraScript { get; set; }
        @AuraEnabled
        public String as400Status { get; set; }
        @AuraEnabled
        public String as400Errore { get; set; }
        @AuraEnabled
        public Boolean errore { get; set; }

        public DatiDuplicatoCarta() {
            this.commissioni = 0;
            this.applicaCommissioni = false;
            this.mostraScript = false;
            this.errore = false;
        }
    }

    @AuraEnabled
    public static List<Indirizzo> getIndirizziCliente(String codiceCliente) {
        List<Indirizzo> indirizzi;

        try {

            HttpResponse httpResponse = WebServiceInvoker.recuperaIndirizziCliente(codiceCliente);

            if (httpResponse != null) {


                OCSRecuperaIndirizziClienteResponse response = OCSRecuperaIndirizziClienteInvoker.callRecIndirizzi(codiceCliente);
                System.debug('---> [PV2871DuplicatoCarta - getIndirizzi] response: ' + response);

                if (response != null && response.statusCode == 200 && response.resultCode == 0 ) {
                    indirizzi = new List<Indirizzo>();

                        if (response.recuperaIndirizziClienteResponse.elencoIndirizzi != null) {
                            for(OCSRecuperaIndirizziClienteResponse.IndirizzoDTO indirzzoDTO : response.recuperaIndirizziClienteResponse.elencoIndirizzi) {
                                indirizzi.add(new Indirizzo(indirzzoDTO.cap, indirzzoDTO.capRischio, indirzzoDTO.civico, indirzzoDTO.indirizzo, indirzzoDTO.localita, indirzzoDTO.nazione, indirzzoDTO.provincia, indirzzoDTO.tipoIndirizzo));
                            }
                        }

                }
            }
        } catch (Exception e) {
            System.debug('---> [PV2871DuplicatoCarta - getIndirizzi] Exception: ' + e.getMessage());
            indirizzi = null;
        }

        System.debug('---> [PV2871DuplicatoCarta - getIndirizzi] indirizzi: ' + indirizzi);
        return indirizzi;
    }

    @AuraEnabled
    public static DatiDuplicatoCarta getDatiDuplicatoCarta(String numeroCarta) {
        DatiDuplicatoCarta datiDuplicatoCarta = new DatiDuplicatoCarta();
        OCSCartaDatiFinanziariResponse cartaDatiFinanziari = OCSCartaDatiFinanziariInvoker.cartaDatiFinanziari(numeroCarta);

        if (cartaDatiFinanziari != null && cartaDatiFinanziari.statusCode == 200 && cartaDatiFinanziari.resultCode == 0 && cartaDatiFinanziari.datiCartaDatiFinanziariResponse != null) {

            datiDuplicatoCarta.numeroCarta = numeroCarta;
            datiDuplicatoCarta.emettitore = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.emettitore;
            datiDuplicatoCarta.bloccoCarta = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.blocco;
            datiDuplicatoCarta.dataValidita = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.dataValidita;
            datiDuplicatoCarta.as400Status = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.as400Status;
            datiDuplicatoCarta.as400Errore = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.as400Errore;

            if(cartaDatiFinanziari.datiCartaDatiFinanziariResponse.as400Status == 'OK') {
                if (datiDuplicatoCarta.bloccoCarta == 'PT') {
                    datiDuplicatoCarta.mostraScript = true;
                    datiDuplicatoCarta.applicaCommissioni = false;
                } else if (datiDuplicatoCarta.bloccoCarta == 'SX') {
                    datiDuplicatoCarta.mostraScript = true;
                    datiDuplicatoCarta.applicaCommissioni = true;
                } else if (datiDuplicatoCarta.bloccoCarta == 'PE') {
                    datiDuplicatoCarta.mostraScript = true;
                    datiDuplicatoCarta.applicaCommissioni = true;
                } else if (datiDuplicatoCarta.bloccoCarta == 'XI') {
                    datiDuplicatoCarta.mostraScript = false;
                    datiDuplicatoCarta.applicaCommissioni = true;
                } else if (datiDuplicatoCarta.bloccoCarta == 'LL') {
                    datiDuplicatoCarta.mostraScript = false;
                    datiDuplicatoCarta.applicaCommissioni = true;
                } else {
                    datiDuplicatoCarta.mostraScript = false;
                    OCSRecuperaInfoCartaResponse infoCarta = OCSRecuperaInfoCartaInvoker.callRecInfoCarta(datiDuplicatoCarta.numeroCarta);

                    if (infoCarta != null && infoCarta.statusCode == 200 && infoCarta.resultCode == 0 && infoCarta.recuperaInfoCartaResponse != null) {
                        datiDuplicatoCarta.dataRientroProduzione = infoCarta.recuperaInfoCartaResponse.dataRientroProduzione;
                        datiDuplicatoCarta.origine = infoCarta.recuperaInfoCartaResponse.origine;
                        gestioneBlocchiLVVI(datiDuplicatoCarta);
                        //TODO Completare le logiche
                    }
                    else {
                        datiDuplicatoCarta.errore = true;
                    }
                }
            }
            else {
                datiDuplicatoCarta.errore = true;
            }
        }
        else {
            datiDuplicatoCarta.errore = true;
        }

        return datiDuplicatoCarta;
    }

    private static void gestioneBlocchiLVVI(DatiDuplicatoCarta datiDuplicatoCarta) {

        if(datiDuplicatoCarta.dataValidita != null && datiDuplicatoCarta.dataValidita.length() == 8 && datiDuplicatoCarta.dataRientroProduzione != null && datiDuplicatoCarta.dataRientroProduzione.length() == 8) {

            // Data richiesta duplicato carta
            Date dataRiferimento = System.today();

            // Data validità: per il calcolo va considerato sempre il primo giorno del mese
            Integer dataValiditaYear = Integer.valueOf(datiDuplicatoCarta.dataValidita.substring(0, 4));
            Integer dataValiditaMonth = Integer.valueOf(datiDuplicatoCarta.dataValidita.substring(4, 6));
            Integer dataValiditaDay = 1;
            Date dataValidita = Date.newInstance(dataValiditaYear, dataValiditaMonth, dataValiditaDay);

            // Data rientro produzione
            Integer dataRientroProduzioneYear = Integer.valueOf(datiDuplicatoCarta.dataRientroProduzione.substring(0, 4));
            Integer dataRientroProduzioneMonth = Integer.valueOf(datiDuplicatoCarta.dataRientroProduzione.substring(4, 6));
            Integer dataRientroProduzioneDay = Integer.valueOf(datiDuplicatoCarta.dataRientroProduzione.substring(6, 8));
            Date dataRientroProduzione = Date.newInstance(dataRientroProduzioneYear, dataRientroProduzioneMonth, dataRientroProduzioneDay);

            if(datiDuplicatoCarta.bloccoCarta == 'LV') {

                if(datiDuplicatoCarta.origine.equalsIgnoreCase('RINNOVO')) {
                    // Se dataRiferimento >= 4 settimane dalla data di validità si applicano commissioni
                    datiDuplicatoCarta.applicaCommissioni = dataRiferimento >= dataValidita.addDays(7*4);
                }
                else {
                    // Se dataRientroProduzione >= 6 settimane si applicano commissioni
                    datiDuplicatoCarta.applicaCommissioni = dataRientroProduzione <= dataRiferimento.addDays(-7*6);
                }
            }
            else if(datiDuplicatoCarta.bloccoCarta == 'VI') {

                //Se cliente BP
                if(datiDuplicatoCarta.emettitore == '3' || datiDuplicatoCarta.emettitore == '003') {
                    if(datiDuplicatoCarta.origine.equalsIgnoreCase('RINNOVO')) {
                        //TODO
                    }
                    else {
                        //TODO
                    }
                }
            }
        }
        else {
            datiDuplicatoCarta.errore = true;
        }
    }

/*****************************************************************************************************************/

    public class PV2871DuplicatoCartaForm extends PVForm {

    }

    @AuraEnabled
    public static void conferma(PV2871DuplicatoCartaForm datiForm) {
        System.debug('---> [PV2871DuplicatoCarta - conferma] datiForm: ' + datiForm);
        new PV2871DuplicatoCarta().execute(datiForm);
    }

    public void execute(PVForm form) {
        String messaggio_errore = '';

        try {
            PV2871DuplicatoCartaForm myForm = (PV2871DuplicatoCartaForm) form;
            System.debug('---> [PV2871DuplicatoCarta - execute] PVForm: ' + myForm);
            commonExecute(myForm);
        } catch (Exception e) {
            messaggio_errore = e.getMessage();
        } finally {
            if (messaggio_errore != '') {
                gestisciException(messaggio_errore);
            }
        }
    }

    public override Case completaCasePostVendita(Case casoPV, PVForm form) {
        return casoPV;
    }

    public override String recuperaNotaSpecificaPV(PVForm form, Case casoPV) {
        return '';
    }

    public override XCS_Messaggio__c preparaMessaggioOCS(PVForm form, XCS_Messaggio__c xcs_messaggio) {
        PV2871DuplicatoCartaForm myForm = (PV2871DuplicatoCartaForm) form;
        xcs_messaggio.NumPratica__c = myForm.pratica.numPratica;
        xcs_messaggio.TipoPratica__c = myForm.pratica.tipoPratica;
        xcs_messaggio.CodCliente__c = myForm.pratica.codCliente;
        return xcs_messaggio;
    }
}