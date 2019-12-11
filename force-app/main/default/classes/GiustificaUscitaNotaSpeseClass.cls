public with sharing class GiustificaUscitaNotaSpeseClass {

	
	@AuraEnabled
	public static InitWrapper initApex(SFA_NotaSpese__c theNotaSpese,Date dataTimbrature){
        
		User currentUser = getCurrentUser();
		List<Account> dealerList = getDealers(theNotaSpese);
		List<Map<String,String>> autoPicklist = getAutoPicklist();
		List<String> indirizziList = new List<String>();
		for(Account dealer : dealerList){
			if(String.isNotBlank(dealer.ShippingStreet) && String.isNotBlank(dealer.ShippingCity))
				indirizziList.add(dealer.ShippingStreet + ' ' + dealer.ShippingCity);
		}
		CalcolaDistanzeRequest request = new CalcolaDistanzeRequest();
		request.calcolaDistanzeRequest = new CalcolaDistanzeRequest.CalcolaDistanzeRequestInner();
		request.calcolaDistanzeRequest.indirizzoFiliale = theNotaSpese.Branch__r.ShippingStreet + theNotaSpese.Branch__r.ShippingCity;
		request.calcolaDistanzeRequest.elencoIndirizziIntermedi = indirizziList;
        
		CalcolaDistanzeResponse distanzaResponse = getKmPercorsi(request);

		InitWrapper iW = new InitWrapper(dealerList,distanzaResponse,dataTimbrature,autoPicklist,currentUser);	
		return iW; 
	}

	@AuraEnabled
	public static String sendNotaSpese(SFA_NotaSpese__c theNotaSpese,String theWrapperJson){

		InitWrapper theWrapper = (InitWrapper)JSON.deserialize(theWrapperJson,InitWrapper.Class);
		System.debug(theWrapper);
		NotaSpeseZucchettiRequest requestNotaSpese = createNotaSpeseRequest(theNotaSpese,theWrapper);
		/*
		if (theNotaSpese.TipoAuto__c == 'F')
			theNotaSpese.Status__c = 'Da Approvare';
		else	
			theNotaSpese.Status__c = 'Chiusa';
        */
        theNotaSpese.Status__c = 'Da Approvare';
		NotaSpeseZucchettiResponse response = NotaSpeseZucchettiInvoker.invoke(requestNotaSpese);
		update theNotaSpese;
		return response.resultCode;
	}

	private static NotaSpeseZucchettiRequest createNotaSpeseRequest(SFA_NotaSpese__c theNotaSpese,InitWrapper theWrapper){

		NotaSpeseZucchettiRequest requestNotaSpese = new NotaSpeseZucchettiRequest();
		requestNotaSpese.codiceUtente = theWrapper.currentUser.Alias;
		requestNotaSpese.pcodestrdl = '';
		requestNotaSpese.pcodestsub = '';
		requestNotaSpese.pcodfiscale = '';
		requestNotaSpese.panno = theNotaSpese.Date__c.year().format();
		requestNotaSpese.pmese = theNotaSpese.Date__c.month().format();
		requestNotaSpese.pidstateini = 'IT';
		requestNotaSpese.pidcityini = theNotaSpese.Branch__r.ShippingPostalCode;
		requestNotaSpese.pdataini = theNotaSpese.Date__c.year().format() + theNotaSpese.Date__c.month().format() + theNotaSpese.Date__c.day().format();
		requestNotaSpese.poraini = theNotaSpese.OraInizioUscita__c.hour().format() +':'+ theNotaSpese.OraInizioUscita__c.minute().format();
		requestNotaSpese.pidstatefin = 'IT';
		requestNotaSpese.pidcityfin = theNotaSpese.Branch__r.ShippingPostalCode;
		requestNotaSpese.pdatafin = theNotaSpese.Date__c.year() + theNotaSpese.Date__c.month().format() + theNotaSpese.Date__c.day().format();
		requestNotaSpese.porafin = theNotaSpese.OraFineUscita__c.hour().format() +':'+ theNotaSpese.OraFineUscita__c.minute().format();
		requestNotaSpese.pmotitr = '08';
		requestNotaSpese.pdefore = theWrapper.currentUser.Profile.Name != 'Branch Manager' ? 'S' : 'N';
		requestNotaSpese.pannotazioni = '';
		if(theNotaSpese.TipoAuto__c == 'F' || theNotaSpese.TipoAuto__c == 'NA' || theNotaSpese.TipoAuto__c == 'NAA')
			requestNotaSpese.pitinerario = '';
		else
			requestNotaSpese.pitinerario = theNotaSpese.Tratta__c;
		requestNotaSpese.ptipoauto = tipoAutoTranscodingMap.get(theNotaSpese.TipoAuto__c);
		requestNotaSpese.pmodauto = getModAuto(theNotaSpese.TipoAuto__c,theWrapper.datiUtenteZucchetti);
		requestNotaSpese.ptiporimb = getTipoRimborso(theWrapper.dealerList,theNotaSpese.Branch__r);
		requestNotaSpese.pantarga = theNotaSpese.TargaVeicolo__c;
		requestNotaSpese.pdistanza = theWrapper.kmPercorsi.format();
		if(theNotaSpese.TipoAuto__c == 'P')
			requestNotaSpese.pnotekm = theNotaSpese.TargaVeicolo__c;
		else
			requestNotaSpese.pnotekm = noteKmTranscodingMap.get(theNotaSpese.TipoAuto__c);

		return requestNotaSpese;

	}


	private static User getCurrentUser(){
        String utenteId = UserInfo.getUserId();
        return [SELECT FirstName, LastName,Id,Name, Alias,DefaultQueueId__c,Profile.Name FROM User WHERE Id =: utenteId];
    }

	private static String getTipoRimborso(List<Account> dealerList,Account branch){
		String tipoRimborso = '1';
		for(Account dealer : dealerList){

			if(dealer.ShippingCity != branch.ShippingCity){
				tipoRimborso = '2';
				break;
			}
		}

		return tipoRimborso;

	}

	private static String getModAuto(String tipoAuto,OCSrecuperaDatiUtenteZucchettiResponse.recuperaDatiUtenteZucchettiResponse datiUtenteZucchetti){
		Map<String,String> modAutoTranscodingMap = new Map<String,String>{
		'F' => '00',
		'P' => '00',
		'FA' => '00',
		'NAA' => '',
		'NA' => ''
		};

		if(tipoAuto == 'A')
			return datiUtenteZucchetti.modelloAuto;
		else
			return modAutoTranscodingMap.get(tipoAuto);

	}

	private static List<Account> getDealers(SFA_NotaSpese__c theNotaSpese){
		
		List<SFA_PianificaAttivita__c> attivitaPianificateList = [SELECT Id, Dealer__r.Name ,Dealer__r.OCS_External_Id__c,Dealer__r.ShippingStreet,Dealer__r.ShippingCity 
				FROM SFA_PianificaAttivita__c 
				WHERE SFA_Nota_Spese__c =: theNotaSpese.Id];

		List<Account> dealerList = new List<Account>();
		for(SFA_PianificaAttivita__c pa : attivitaPianificateList){
			dealerList.add(pa.Dealer__r);
		}

		return dealerList;

	}

	private static List<Map<String,String>> getAutoPicklist(){
        Schema.DescribeFieldResult fieldResult = SFA_NotaSpese__c.TipoAuto__c.getDescribe();
        return (List<Map<String,String>>) JSON.deserialize(JSON.serialize(fieldResult.getPicklistValues()),List<Map<String,String>>.Class);
    }

	private static CalcolaDistanzeResponse getKmPercorsi(CalcolaDistanzeRequest request){

        CalcolaDistanzeResponse response = CalcolaDistanzeInvoker.invoke(request);
        return response;
    }

	public class InitWrapper{
		@AuraEnabled
		public List<Account> dealerList;
		@AuraEnabled
		public Decimal kmPercorsi;
		@AuraEnabled
		public OCSrecuperaDatiUtenteZucchettiResponse.recuperaDatiUtenteZucchettiResponse datiUtenteZucchetti;
		@AuraEnabled
		public OCSrecuperaTimbratureZucchettiResponse.elencoTimbrature[] timbratureList;
		@AuraEnabled
		public List<Map<String,String>> autoPicklist;
		@AuraEnabled
		public User currentUser;

		public InitWrapper(List<Account> dealerList,CalcolaDistanzeResponse distanzaResponse,Date dataTimbrature,List<Map<String,String>> autoPicklist,User currentUser){
			this.dealerList= dealerList;
			this.kmPercorsi= distanzaResponse.calcolaDistanzeResponse.distanzaTotale != null ? Decimal.valueOf(Double.valueOf(distanzaResponse.calcolaDistanzeResponse.distanzaTotale)/1000).setscale(2) : 0;
			this.datiUtenteZucchetti = OCSrecuperaDatiUtenteZucchettiInvoker.callRecuperaDatiUtenteZucchetti(currentUser.Alias).recuperaDatiUtenteZucchettiResponse;
			if(datiUtenteZucchetti == null){
				AuraHandledException e= new AuraHandledException('utente non trovato');
				e.setMessage('utente non trovato');
				throw e;
        	}
			OCSrecuperaTimbratureZucchettiResponse responseTimbrature = OCSrecuperaTimbratureZucchettiInvoker.callrecuperaTimbratureZucchetti(this.datiUtenteZucchetti.idCompany, this.datiUtenteZucchetti.idEmploy, dataTimbrature);
			if(responseTimbrature == null || responseTimbrature.recuperaTimbratureZucchettiResponse == null || responseTimbrature.recuperaTimbratureZucchettiResponse.elencoTimbrature == null){
				AuraHandledException e= new AuraHandledException('Timbratura utente non trovato');
				e.setMessage('Timbratura non disponibile per la data '+dataTimbrature);
				throw e;
        	}
			this.timbratureList = responseTimbrature.recuperaTimbratureZucchettiResponse.elencoTimbrature;
			this.autoPicklist = autoPicklist;
			this.currentUser = currentUser;
		}


	}

	private static Map<String,String> tipoAutoTranscodingMap = new Map<String,String>{
		'F' => '',
		'P' => 'P',
		'A' => 'A',
		'FA' => 'A',
		'NAA' => '',
		'NA' => ''
	};

	private static Map<String,String> noteKmTranscodingMap = new Map<String,String>{
		'F' => 'Utilizzo auto filiale senza nota spese',
		'A' => 'Utilizzo auto aziendale',
		'FA' => 'Utilizzo auto filiale con allegato',
		'NAA' => 'Uscita senza auto (con allegato)',
		'NA' => 'Uscita senza auto'
	};

}