/**
 * @File Name          : PV3261VariazioneTelefoniInserimento.cls
 * @Description        : 
 * @Author             : sabrina vitali
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 24/10/2019, 13:36:57
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    17/7/2019, 17:38:46   sabrina vitali     Initial Version
**/ 
public class PV3261VariazioneTelefoniInserimento extends PVAction {

	public class PV3261VariazioneTelefoniInserimentoForm extends PVForm {
		@AuraEnabled public OCSRecuperaDatiClienteResponse.recuperaDatiClienteResponse datiCliente {get; set;}
		@AuraEnabled public List<OCSPratica> praticheCA {get; set;}
		//@AuraEnabled public VariazioneTelefoniInput variazioneTelefoniInput{get; set;}
		@AuraEnabled public String operatoreTel {get; set;}
		
		@AuraEnabled public String variazioneCel {get; set;}
		@AuraEnabled public String annulla {get; set;}
		@AuraEnabled public String forzatura {get; set;}
		@AuraEnabled public String variazioni {get; set;}
		@AuraEnabled public String flagCellulare {get; set;}
		@AuraEnabled public String flagFisso {get; set;}
		@AuraEnabled public String flagFax {get; set;}
		@AuraEnabled public String flagAlternativo {get; set;}

		public String noteAggiornamentoCA {get; set;}
	}

	@AuraEnabled
	public static void conferma(PV3261VariazioneTelefoniInserimentoForm datiForm){
		System.debug('@@@@ PV3261VariazioneTelefoniInserimentoForm : praticheCA    :   ' + datiForm.praticheCA);
		System.debug('@@@@ PV3261VariazioneTelefoniInserimentoForm : variazioneCel    :   ' + datiForm.variazioneCel);
		System.debug('@@@@ PV3261VariazioneTelefoniInserimentoForm : annulla    :   ' + datiForm.annulla);
		System.debug('@@@@ PV3261VariazioneTelefoniInserimentoForm : forzatura    :   ' + datiForm.forzatura);
		System.debug('@@@@ PV3261VariazioneTelefoniInserimentoForm : variazioni    :   ' + datiForm.variazioni);
		System.debug('@@@@ PV3261VariazioneTelefoniInserimentoForm : operatoreTel    :   ' + datiForm.operatoreTel);
		System.debug('@@@@ PV3261VariazioneTelefoniInserimentoForm : flagCellulare    :   ' + datiForm.flagCellulare);
		System.debug('@@@@ PV3261VariazioneTelefoniInserimentoForm : flagFisso    :   ' + datiForm.flagFisso);
		System.debug('@@@@ PV3261VariazioneTelefoniInserimentoForm : flagFax    :   ' + datiForm.flagFax);
		System.debug('@@@@ PV3261VariazioneTelefoniInserimentoForm : flagAlternativo    :   ' + datiForm.flagAlternativo);
		datiForm.categoriaPV = PVInserimentoController.getCommonComponents('1757');
		System.debug('@@@@ datiForm : categoriaPV    :   ' + datiForm.categoriaPV);
		new PV3261VariazioneTelefoniInserimento().execute(datiForm);
	}

	public void execute(PVForm form){
		String messaggio_errore = '';
		try{
			PV3261VariazioneTelefoniInserimentoForm myForm = (PV3261VariazioneTelefoniInserimentoForm) form;
			OCSCliente cliente = myForm.cliente;
			//variazioni solo se il Case non è da annullare
			if(!myForm.annulla.equalsIgnoreCase('S')){
				//eseguo azione CEL per tutte le carte
				if(myForm.variazioneCel.equalsIgnoreCase('S') && myForm.praticheCA.size() > 0){
					myForm.noteAggiornamentoCA = '';
					for(Integer i=0;i<myForm.praticheCA.size();i++){
						OCSVariazioneCellulareInvoker.Request req = new OCSVariazioneCellulareInvoker.Request();
						req.variazioneCellulareRequest.provenienza = 'CA';
						req.variazioneCellulareRequest.tipoIntermediario = 'AG';
						req.variazioneCellulareRequest.intermediario = '12';
						req.variazioneCellulareRequest.procedura = 'CA';
						req.variazioneCellulareRequest.numPratica = myForm.praticheCA[i].numPratica;
						req.variazioneCellulareRequest.cellulare = myForm.datiCliente.telCellulare;
						req.variazioneCellulareRequest.pan = '';
						req.variazioneCellulareRequest.operatoreTel = myForm.operatoreTel;
						req.variazioneCellulareRequest.codRifExt = '';
						req.variazioneCellulareRequest.utente = myForm.userData.user.Alias;

						System.debug('@@@ debugger req ' + req);
						OCSVariazioneCellulareInvoker.Response res = OCSVariazioneCellulareInvoker.invoke(req.variazioneCellulareRequest);
						System.debug('@@@ debugger res ' + res);

						//if(!res.isOK()) {
						if(res.variazioneCellulareResponse.as400Status != 'OK') {
							myForm.noteAggiornamentoCA += '\nErrore da OCS su azione CEL per la carta ' + myForm.praticheCA[i].numPratica + ': ';
							myForm.noteAggiornamentoCA += res.variazioneCellulareResponse.as400Status + ' - ' + res.variazioneCellulareResponse.as400Errore;
						}
					}
				}
				System.debug('myForm.noteAggiornamentoCA' + myForm.noteAggiornamentoCA);

				//variazione telefoni
				OCSVariazioneTelefoniInvoker.Request reqT = new OCSVariazioneTelefoniInvoker.Request();

				reqT.variazioneTelefoniRequest.flagForzaValidazione = myForm.forzatura;
				reqT.variazioneTelefoniRequest.flagFisso = myForm.flagFisso;    
				reqT.variazioneTelefoniRequest.flagCellulare = myForm.flagCellulare;  
				reqT.variazioneTelefoniRequest.flagAlternativo = myForm.flagAlternativo; 
				reqT.variazioneTelefoniRequest.flagFax = myForm.flagFax;     
				reqT.variazioneTelefoniRequest.codCliente = myForm.cliente.codCliente;
				reqT.variazioneTelefoniRequest.telFisso = myForm.datiCliente.telefonoCasa;
				reqT.variazioneTelefoniRequest.telCellulare = myForm.datiCliente.telCellulare;
				reqT.variazioneTelefoniRequest.telAlternativo = myForm.datiCliente.telefonoAlternativo;
				reqT.variazioneTelefoniRequest.telFax = myForm.datiCliente.fax;

				System.debug('@@@ debugger reqT ' + reqT);
				OCSVariazioneTelefoniInvoker.Response resT = OCSVariazioneTelefoniInvoker.invoke(reqT.variazioneTelefoniRequest);
				System.debug('@@@ debugger resT ' + resT);

				System.debug('@@@ debugger resT ' + resT.variazioneTelefoniResponse.esitoElaborazione);
				if(!resT.isOK() || resT.variazioneTelefoniResponse.esitoElaborazione != 'OK'){
					messaggio_errore = 'Errore da OCS: ' + resT.variazioneTelefoniResponse.esitoElaborazione;
				}
				else{
					//Common di PVAction
					commonExecute(myForm);
				}
			}
			else{
				//Common di PVAction
				commonExecute(myForm);
			}
		}catch(Exception e) {
			messaggio_errore = e.getMessage();
			System.debug('TEST EMAIL EXCEPTION ERRORE:' + messaggio_errore);
		}finally{
			if(messaggio_errore != '') {
				gestisciException(messaggio_errore);
			}
		}
	}

	public override Case completaCasePostVendita(Case casoPV,PVForm form){
		//continuare a valorizzare l'oggetto casoPV integrando i dati di questo post vendita
		PV3261VariazioneTelefoniInserimentoForm myForm = (PV3261VariazioneTelefoniInserimentoForm) form;
		if(myForm.annulla.equalsIgnoreCase('S')){
			casoPV.Step_PV__c = '999';
		}
		return casoPV;
	}

	public override String recuperaNotaSpecificaPV(PVForm form, Case casoPV){
		//preparazione nota
		PV3261VariazioneTelefoniInserimentoForm myForm = (PV3261VariazioneTelefoniInserimentoForm) form;
		//7 : Note specifiche PV
		String notaSpecificaPV;
		notaSpecificaPV = myForm.variazioni;
		notaSpecificaPV += myForm.noteAggiornamentoCA;
		return notaSpecificaPV;
	}

	public override XCS_Messaggio__c preparaMessaggioOCS(PVForm form, XCS_Messaggio__c xcs_messaggio){
		//preparazione XCS_Messaggio
		PV3261VariazioneTelefoniInserimentoForm myForm = (PV3261VariazioneTelefoniInserimentoForm) form;
		xcs_messaggio.CodCliente__c = myForm.cliente.codCliente;
		return xcs_messaggio;
	}

	@AuraEnabled
	public static OCSCartaDatiFinanziariResponse.DatiCartaDatiFinanziariResponseDTO recuperaDatiFinanziari(String numeroCarta){
		OCSCartaDatiFinanziariResponse cartaDatiFinanziariResponse = OCSCartaDatiFinanziariInvoker.cartaDatiFinanziari(numeroCarta);
		return cartaDatiFinanziariResponse.datiCartaDatiFinanziariResponse;
	}

	@AuraEnabled
	public static VariazioneTelefoniCheckOutput recuperaDatiCliente(String codCliente){
		OCSCliente cliente;
		OCSRecuperaDatiPostvenditaResponse risposta = OCSRecuperaDatiPostvenditaInvoker.callRecDatiPV(codCliente);
		if(OCSObjectsFactory.makeClienti(risposta).size()>0){
		cliente = OCSObjectsFactory.makeClienti(risposta)[0];
		System.debug('### CLIENTE CREATO');
		}else{System.debug('### LISTA VUOTA ');}
        OCSPratica pratica = new OCSPratica();

		VariazioneTelefoniCheckOutput variazioneTelefoniCheckOutput = new VariazioneTelefoniCheckOutput();
		variazioneTelefoniCheckOutput.messaggioNoVariazione = '';
		variazioneTelefoniCheckOutput.messaggioFax = '';
		variazioneTelefoniCheckOutput.isErroreBloccante = false;
		variazioneTelefoniCheckOutput.richiestaFaxShow = false;

        Boolean isVarCellNonPossibile = false;
        Boolean isStatoFinoa30CF = false;
        Boolean hasOnlyConsumo = true;
        Boolean PrtInIstruttoria = false;
		String isFidoOrStoreCredit = 'N';
		String emettitore = '';
		//salvo le carte da passare alla pagina, verranno reinviate in fase di conferma per non essere riestratte
		variazioneTelefoniCheckOutput.praticheCA = cliente.getCA();

        //estraggo le pratiche da verificare
        for(Integer i=0;i<cliente.pratiche.size();i++){
            pratica = cliente.pratiche[i];
            System.debug('*************pratica : tipo : ' + pratica.tipoPratica + ' - codStato : ' + pratica.codStatoPratica + ' - stato' + pratica.statoPratica + ' - codAttr ' + pratica.codAttributoPratica + '  - des ' + pratica.desStatoPratica);
            if(pratica.tipoPratica.equalsIgnoreCase('CO')){ 
                if(pratica.codStatoPratica <= '30' && pratica.codAttributoPratica <> 'RE' && pratica.codAttributoPratica <> 'RT'){
                    PrtInIstruttoria = true;
                }
            }else{
                hasOnlyConsumo = false;
				System.debug('### CARTA');
            }
            if(pratica.tipoPratica.equalsIgnoreCase('CA')){
				
                if((pratica.codStatoPratica == '60' || pratica.statoPratica == '50' || pratica.statoPratica == '50XX') &&
					pratica.desStatoPratica.toUpperCase() == ('RINNOVO DA ATTIVARE').toUpperCase()){
                        isVarCellNonPossibile = true;
                }else if(pratica.codStatoPratica <> '40' && pratica.codStatoPratica <> '70' && pratica.statoPratica <> '30RT' && pratica.statoPratica <> '30AN'){
                    //linee di fido e store credit non sono da considerare
                    emettitore = (recuperaDatiFinanziari(pratica.numPratica).emettitore);
					System.debug('*************emettitore : ' + emettitore);
                    if(String.isNotBlank(emettitore)){
						if(Integer.ValueOf(emettitore) != 524 && Integer.ValueOf(emettitore) >= 100 && Integer.ValueOf(emettitore) <= 999){
							isFidoOrStoreCredit = 'S';	
						}
						if(isFidoOrStoreCredit.equals('N')){
                        	isVarCellNonPossibile = true;
						}
						if(pratica.codStatoPratica < '30' || pratica.statoPratica.equals('30CF')){
							isStatoFinoa30CF = true;
						}
                    }
                }
            } 
        }	//for

		if(PrtInIstruttoria && hasOnlyConsumo){
			variazioneTelefoniCheckOutput.messaggioNoVariazione = '<B>Non è possibile variare i telefoni in quanto una delle pratiche è in istruttoria.</B>';
			variazioneTelefoniCheckOutput.isErroreBloccante = true;
		}else if(isVarCellNonPossibile && isStatoFinoa30CF){
			variazioneTelefoniCheckOutput.messaggioFax = 'Carta in istruttoria, rimandare il cliente al canale di caricamento.';	
			variazioneTelefoniCheckOutput.richiestaFaxShow = true;
		}else if(isVarCellNonPossibile){
			variazioneTelefoniCheckOutput.messaggioFax = 'Per variare i telefoni è richiesto invio di un fax in quanto una delle carte non è attiva.';
			variazioneTelefoniCheckOutput.richiestaFaxShow = true; 
		}	
		System.debug('### PRIMA DI CHIAMARE ALTRO SERVIZIO');
		OCSRecuperaDatiClienteResponse recuperaDatiClienteRes = OCSRecuperaDatiClienteInvoker.recuperaDatiCliente(codCliente);
		variazioneTelefoniCheckOutput.datiCliente = recuperaDatiClienteRes.recuperaDatiClienteResponse;
		System.debug('###### response daticliente: ' + variazioneTelefoniCheckOutput.datiCliente);
        return variazioneTelefoniCheckOutput;
    }

    public class VariazioneTelefoniCheckOutput{
        @AuraEnabled
        public String messaggioNoVariazione;
        @AuraEnabled
        public String messaggioFax;
        @AuraEnabled
        public Boolean isErroreBloccante;
        @AuraEnabled
        public Boolean richiestaFaxShow;
		@AuraEnabled
		public OCSRecuperaDatiClienteResponse.RecuperaDatiClienteResponse datiCliente;
		@AuraEnabled
		public List<OCSPratica> praticheCA;
    }   
/*
    public class VariazioneTelefoniInput{
        @AuraEnabled
        public String annulla;
        @AuraEnabled
        public String variazioneCel;
        @AuraEnabled
        public String forzatura;
        @AuraEnabled
        public String flagFisso;
        @AuraEnabled
        public String flagCellulare;
        @AuraEnabled
        public String flagAlternativo;
        @AuraEnabled
        public String flagFax;
        @AuraEnabled
        public String variazioni;
    }   
*/	
}