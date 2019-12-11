public class SFA_PraticheIrregolari_BatchableCrePrat implements Database.Batchable<String>, Database.Stateful, Database.AllowsCallouts {

    List<String> dtos;
    Map<String, Integer> fieldNumberMap = new Map<String, Integer>();
    String caseId;
    Integer fieldNumber;
    String fieldValue;        
    Boolean scartare;
    Boolean trovato;
    Boolean skip;
    Date dataScadenza;
    List<String> lstDealerId = new List<String>();
    Map<String, Id> dealerCodOCSIdMap = new Map<String, Id>();
    List<String> lstFieldNames = new List<String>();       
    List<String> lstCodiciPratiche = new List<String>(); 
    List<SFA_PraticaIrregolare__c> lstPraticheTutte = new List<SFA_PraticaIrregolare__c>();        
    List<SFA_PraticaIrregolare__c> lstPraticheOK = new List<SFA_PraticaIrregolare__c>();   
    List<SFA_PraticaIrregolare__c> lstPraticheDealerNotFound = new List<SFA_PraticaIrregolare__c>();
    List<SFA_PraticaIrregolare__c> lstPraticheBranchDealerNotFound = new List<SFA_PraticaIrregolare__c>();         
    List<Case> lstAttivita_by_dealer_e_irregolarita = new List<Case>();
    
    List<Account> lstDealer = [SELECT Id, Name, RecordType.Name, OCS_External_Id__c, ParentId, Branch__r.OCS_External_Id__c 
                               FROM Account 
                               WHERE RecordType.Name = 'Dealer'];  
    
    List<Account> lstBranch = [SELECT Id, Name, OCS_External_Id__c 
                               FROM Account 
                               WHERE RecordType.Name = 'Branch'];
    List<ContentVersion> conVer;
	List<String> lstBranchId = new List<String>();
	//conVer = [SELECT VersionData FROM ContentVersion WHERE Id = :fileId AND IsLatest = true];
    
	public SFA_PraticheIrregolari_BatchableCrePrat(SFA_PraticheIrregolari_CreazionePratiche.wrapBatchInit wrap) {
        conVer = [SELECT VersionData FROM ContentVersion WHERE Id = :wrap.fileid AND IsLatest = true];
        caseId = wrap.caseId;
        dataScadenza = wrap.dataScadenza;
        this.dtos = wrap.recordCSV;
    }
	
	public Iterable<String> start(Database.BatchableContext context) {
        return this.dtos;
    }

	public void execute(Database.BatchableContext context, List<String> csvRows)
    {  
    	   List<String> csvFieldNames = csvRows[0].split(';');
            for (Integer i = 0; i < csvFieldNames.size(); i++) {
                fieldNumberMap.put(csvFieldNames[i], i);
                lstFieldNames.add(csvFieldNames[i].trim());
            }

            
            Datetime today = Datetime.Now();
            Id dealerOCS;
            for (Integer i = 1; i < csvRows.size(); i++) {
                		skip=false;
                        string[] csvRecordData = csvRows[i].split(';');
                        SFA_PraticaIrregolare__c pratica = new SFA_PraticaIrregolare__c(); 
                        pratica.DataInserimento__c=today;
                		pratica.ActivityId__c=caseId;
                        pratica.DataTermineLavoro__c = dataScadenza;   
                        pratica.Subject__c = 'Pratiche Irregolari';  		                
                        
                        
                        for (String fieldName: csvFieldNames) {
                            fieldNumber = fieldNumberMap.get(fieldName);
                            fieldValue = csvRecordData[fieldNumber];
                            if (fieldName == 'Cod Dealer'){
                                pratica.CodiceDealer__c = fieldValue;}
                            if (fieldName == 'Cod Punto vendita'){
                                pratica.CodicePv__c = fieldValue;}  
                            else if (fieldName == 'Stato Dealer'){
                                pratica.CodiceStatoDealer__c = fieldValue;}
                            else if (fieldName == 'Ragione Sociale'){
                                pratica.RagioneSociale__c = fieldValue;}
                            else if (fieldName == 'Codice Pratica') {
                                if(lstCodiciPratiche.contains(fieldValue)){
                                    skip=true;
                                } else {
                                    pratica.NumeroPratica__c = fieldValue;
                                    pratica.Name = fieldValue;   
                                    lstCodiciPratiche.add(fieldValue);
                                }

                            }
                            else if (fieldName == 'Stato Prat'){
                                pratica.CodiceStatoPratica__c = fieldValue;}
                            else if (fieldName == 'Saldo Totale'){
                                pratica.SaldoTotale__c = fieldValue;}
                            else if (fieldName == 'CURDEL'){
                                pratica.Curdel__c = fieldValue;}
                            else if (fieldName == 'Data Liquidaz'){
                                pratica.DataMandatoLiquidazione__c = fieldValue;}
                            else if (fieldName == 'Dipend'){
                                pratica.Dipendenza__c = fieldValue;}
                            else if (fieldName == 'Riscont Agenzia'){
                                pratica.RiscontroAgenziaItalia__c = fieldValue;}
                            else if (fieldName == 'Riscont Definit'){
                                pratica.RiscontroFinale__c = fieldValue;}
                            else if (fieldName == 'Data Estrazione'){
                                pratica.DataEstrazione__c = fieldValue;}
                            else if (fieldName == 'Data Ricezione'){
                                pratica.DataRicezione__c = fieldValue;}
                            else if (fieldName == 'Targa restituita'){
                                pratica.Targa__c = fieldValue;}
                            else if (fieldName == 'Telaio'){     
                                pratica.Telaio__c = fieldValue;}
                            else if (fieldName == 'Irregolarita')  {    
                                pratica.Irregolarita__c = fieldValue;}
                            else if (fieldName == 'NOTE AGENZIA ITALIA'){
                                pratica.NoteAgenziaItalia__c = fieldValue;}
                            else if (fieldName == 'WARNING'){
                                pratica.Warning__c = fieldValue;}
                        }
                        
                	    if(!skip){   //non skip, quindi la stessa pratica non è stata già censita nello stesso file CSV appena caricato 
                                //recupero il resto di dati necessari da OCS:
                                Map<String, String> fieldInputs = new Map<String, String>();
                                fieldInputs.put('numPratica', pratica.NumeroPratica__c);
                                fieldInputs.put('filtroTipoPratica', 'CO');
                                fieldInputs.put('flagInfoCliente', 'true');   
                                OCSRecuperaDatiPostvenditaResponse response = OCSRecuperaDatiPostvenditaInvoker.callRecDatiPV(fieldInputs);
                                //System.debug('°°°°°°°°°°°°°°°°°°°° DATI POST VENDITA RESPONSE'+JSON.serialize(response));
                            	pratica.ClienteNome__c=response.cliente[0].nome+' '+response.cliente[0].cognome;  
                                pratica.ClienteCodiceFiscale__c=response.cliente[0].codFiscale;
                                pratica.ClienteNatoIl__c=response.cliente[0].dataNascita;
                                pratica.ClienteNatoA__c=response.cliente[0].luogoNascita;             
                                pratica.ClienteNatoProvincia__c=response.cliente[0].provNascita;
                                pratica.ClienteResidenza__c=response.cliente[0].indirizzo+' '+ response.cliente[0].cap +' '+ response.cliente[0].localita  +' '+ response.cliente[0].provincia+' '+response.cliente[0].paeseEstero;  //mettere paese estero che eventualmente conterrà Italia nel caso in cui il clienete risieda in Italia?
                                if (response.pratiche[0].elencoCoobbligati.size()>0){
                                    pratica.CoobbligatoNome__c=response.pratiche[0].elencoCoobbligati[0].nome+' '+response.pratiche[0].elencoCoobbligati[0].cognome;
                                    pratica.CoobbligatoNatoProvincia__c=response.pratiche[0].elencoCoobbligati[0].provNascita;
                                    pratica.CoobbligatoNatoIl__c=response.pratiche[0].elencoCoobbligati[0].dataNascita;
                                    pratica.CoobbligatoNatoA__c=response.pratiche[0].elencoCoobbligati[0].luogoNascita;
                                    pratica.CoobbligatoCodiceFiscale__c=response.pratiche[0].elencoCoobbligati[0].codFiscale;                   
                                }

                                                
                                //recupero dati veicolo:
                                OCS_recuperaInfoPraticaResponse res = OCS_recuperaInfoPraticaInvoker.callAggiornaDati(pratica.NumeroPratica__c);
                                //System.debug('°°°°°°°°°°°°°°°°°°°° DATI INFO PRATICA RESPONSE'+JSON.serialize(res));
                            	pratica.targa__c=res.recuperaInfoPraticaResponse.targa;
                                pratica.telaio__c=res.recuperaInfoPraticaResponse.telaio;
                                pratica.VeicoloImmatricolazione__c=res.recuperaInfoPraticaResponse.annoMeseImmatricolazione;
                                pratica.VeicoloModello__c=res.recuperaInfoPraticaResponse.marcaModello;
                                pratica.VeicoloDescrizione__c=res.recuperaInfoPraticaResponse.descrizioneBene;
                                pratica.VeicoloProdotto__c=res.recuperaInfoPraticaResponse.prodotto;
                
                                
                                scartare=false;
                                if (!lstDealerId.contains('D' + csvRecordData[fieldNumberMap.get('Cod Dealer')])) { 
                                    pratica.EsitoCaricamento__c='Dealer Non Censito';
                                    lstPraticheDealerNotFound.add(pratica);
                                    scartare=true;
                                } else {
                                    for (Account dealer : lstDealer) {
                                        if (dealer.OCS_External_Id__c == 'D' + pratica.CodiceDealer__c && (!lstBranchId.contains(dealer.Branch__r.OCS_External_Id__c) || dealer.Branch__r.OCS_External_Id__c==null) )
                                          { 
                                            pratica.EsitoCaricamento__c='Branch Dealer Non Censito';
                                            lstPraticheBranchDealerNotFound.add(pratica);
                                            scartare=true;
                                            break;  
                                          }                                       
                                    } 
                                }
                                if (!scartare){  
                                    pratica.EsitoCaricamento__c='Pratica caricata';
                                    pratica.Status__c='Pratica - da Gestire';   
                                    if (pratica.RiscontroAgenziaItalia__c.contains('E20')){        
                                        pratica.Irregolarita__c='E20';}
                                    else if (integer.valueOf(pratica.Curdel__c)> 2){    
                                        pratica.Irregolarita__c='REC';}
                                    else if (integer.valueOf(pratica.Curdel__c)<= 2){ 
                                        pratica.Irregolarita__c='IRR';}
                                    
                                    trovato=false;
                                    for (Case attivita:lstAttivita_by_dealer_e_irregolarita){   
                                        if(attivita.CodiceDealer__c==pratica.CodiceDealer__c && attivita.Irregolarita__c==pratica.Irregolarita__c){
                                            trovato=true;  
                                            break;
                                        }
                                    }
                                    if (!trovato){  
                                        Case attivita = new Case(); 
                                        attivita.ActivityType__c = 'SFA_PRAIRR';  
                                        attivita.Status = 'Closed';
                                        attivita.Subject = 'Pratiche Irregolari';
                                        attivita.ParentId = caseId;                    
                                        attivita.Irregolarita__c=pratica.Irregolarita__c;     
                                        attivita.CodiceDealer__c=pratica.CodiceDealer__c;
                                        dealerOCS=dealerCodOCSIdMap.get(pratica.CodiceDealer__c);
                                        attivita.AccountId=dealerOCS;
                                        attivita.DataTermineLavoro__c=pratica.DataTermineLavoro__c;
                                        lstAttivita_by_dealer_e_irregolarita.add(attivita);                    
                                        
                                    }
                                    lstPraticheOK.add(pratica); 
                                 }        
                
                                lstPraticheTutte.add(pratica);
                      	}
                   } 
        
    }
    
    public void finish(Database.BatchableContext context) {
    
    
    
    }
}