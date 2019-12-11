public class SFAConvenzionamNewDealAcquisitAVCtrller {
	private static final String SFA_NEW_DEALER_ACQUISITION = 'SFA_NEW_DEALER_ACQUISITION';

    @AuraEnabled
    public static Dati getDealerAcquisition(String caseId ) {
        String dispositionExternalId='';
		Dati dati = new Dati();

		Case caseAttivita = 
			[SELECT Id, AccountId, Disposition__c, OCSExternalFilialeConvenzionato__c, OwnerId 
			FROM Case 
			WHERE Id = :caseId][0];
        
        dati.dealerAcquisitionId=caseAttivita.AccountId;
		dati.OCSExternalFiliale=caseAttivita.OCSExternalFilialeConvenzionato__c;
        
        
        String genericMessage='Attività di convenzionamento già esitata e consegnata alla Filiale.';
        XCS_Disposition__c disposition = new XCS_Disposition__c();
        if(!String.isEmpty(caseAttivita.Disposition__c)){
            disposition = [SELECT Id, Name, External_Id__c FROM XCS_Disposition__c WHERE Id = :caseAttivita.Disposition__c][0];                 
            dispositionExternalId=disposition.External_Id__c;
            System.debug('###dati.disposition 1:: '+dati.disposition);            
        }        
        dati.disposition=disposition;
        
        SFAConvenzionamento.DatiMessage datiMessage=SFAConvenzionamento.getFinalMessageToVisualize(caseId,SFAConvenzionamento.queueAV,dispositionExternalId,'DCR/AV',genericMessage);
		dati.IsAttivitaInManoAdAV=datiMessage.queueOwnerActivity;
        dati.message=datiMessage.message;

        System.debug('***dati.disposition:: '+dati.disposition);

        List<ReportCerved__c> report=	[SELECT Id 
			FROM ReportCerved__c 
			WHERE DealerId__c = :dati.dealerAcquisitionId AND IsReportValido__c = true ORDER BY CreatedDate DESC];        //recupero solo il report valido, dovrebbe essercene uno solo ma per sicurezza li ordino in maniera decrescente e prendo solo l'ultimo generato valido
			
        if(report.size()>0){
            dati.reportCervedId = report[0].Id;
        }

		return dati;
		
	}

    @AuraEnabled
    public static void assignCaseAndSendEmail(String caseId, String dealerAcquisitionId, XCS_Disposition__c newDisposition, String OCSExternalFiliale, String nota ) {
        String emailTemplate;
        Case caseDealer = SFAConvenzionamento.getCase(caseId);
        List<String> lstAddresses= new List<String>();
        
        AccountUtils.saveNote(dealerAcquisitionId,nota);

        
        List<String> dispositionsFiliale = new list<String> {'DP1812', 'DP1813', 'DP1831', 'DP1815'};
        List<String> dispositionsMD = new list<String> {'DP2932'};
        System.debug('************prima assign:: '); 
        if(dispositionsFiliale.contains(newDisposition.External_Id__c)){   
            caseDealer=SFAConvenzionamento.utenteLavorazione(caseDealer,OCSExternalFiliale,false);
            caseDealer.DataTermineLavoro__c=Date.today();
            //setta email template a Filiale::
            if (newDisposition.External_Id__c=='DP1812'){
                System.debug('DP1812');
                emailTemplate='SFA_Convenzionamento_NewDealerAcquisitionDaAVaFiliale_ApprovaConvenzione';
                caseDealer=SFAConvenzionamento.stepLavorazione(caseDealer,SFAConvenzionamento.NDA_VerificaAnagraficaECollegati,false);
            } else if (newDisposition.External_Id__c=='DP1813') {        
                System.debug('DP1813');
                emailTemplate='SFA_Convenzionamento_NewDealerAcquisitionDaAVaFiliale_RifiutaConvenzione';
                caseDealer=SFAConvenzionamento.stepLavorazione(caseDealer,SFAConvenzionamento.NDA_CompletaInfoEControlli3,false);
            } else if (newDisposition.External_Id__c=='DP1831') {    
                System.debug('DP1831');
                emailTemplate='SFA_Convenzionamento_NewDealerAcquisitionDaAVaFiliale_ModificaDati';
                caseDealer=SFAConvenzionamento.stepLavorazione(caseDealer,SFAConvenzionamento.NDA_CompletaInfoEControlli2,false);
            } else if (newDisposition.External_Id__c=='DP1815') {
                System.debug('DP1815');
                emailTemplate='SFA_Convenzionamento_NewDealerAcquisitionDaAVaFiliale_RichiediInfoAggiuntive';
                caseDealer=SFAConvenzionamento.stepLavorazione(caseDealer,SFAConvenzionamento.NDA_CompletaInfoEControlli2,false);
            }
             caseDealer=CaseShareUtil.emptyCaseShare(caseDealer);
            
            //email a filiale e relativo manager::
            List<String> lstOCSExternal=new List<String>();
            lstOCSExternal.add(OCSExternalFiliale);
            System.debug('lstIndirizziEmail riga 216:: '); 
            RoleUtils.lstIndirizziEmail lstIndirizziEmail= RoleUtils.recoverListRolesEmail(lstOCSExternal);   //creo un oggetto per memorizzarmi la rsposta della classe e poi recupero gli indirizzi delle filiali e coord e regional a cui inviare l'email, oltre al template che wserve (da chiedere ad Alessio)
            System.debug('lstIndirizziEmail riga 217:: '+lstIndirizziEmail);             
            lstAddresses.addAll(lstIndirizziEmail.emailFiliali);
            lstAddresses.addAll(lstIndirizziEmail.emailManagerFiliali);
            System.debug('lstAddresses riga 221:: '+lstAddresses); 
            Messaging.SingleEmailMessage messageMails = EmailUtils.generateEmail(emailTemplate,lstAddresses,dealerAcquisitionId);
            EmailUtils.sendEmail(messageMails);            
            
            
        } else if (dispositionsMD.contains(newDisposition.External_Id__c)){ 
            
            System.debug('************Prima dell\'update'); 
            caseDealer=SFAConvenzionamento.stepLavorazione(caseDealer,SFAConvenzionamento.NDA_FormInizialeMD,false);
            caseDealer=CaseShareUtil.setStringInCaseShare(caseDealer,SFAConvenzionamento.sharingToMD);
			caseDealer=SFAConvenzionamento.utenteLavorazione(caseDealer,SFAConvenzionamento.queueMD,false);            
            System.debug('************caseDealer per vedere utente lavorazione: '+caseDealer.Utente_Lavorazione__c); 
            //popolare il campo AccountShare (usato per la sharingRule)
            AccountShareUtil.appendStringToAccountShare(caseDealer.AccountId,SFAConvenzionamento.sharingToMD);        
            
            //email a Monitoraggio Dealer::
            emailTemplate='SFA_Convenzionamento_NewDealerAcquisitionDaAVaFiliale_RichiediInfoAMonitoraggio';
            String EmailMD= CompassParametersUtils.getValue('monitoraggioDealer.mail');
            lstAddresses.add(EmailMD);
            Messaging.SingleEmailMessage messageMails = EmailUtils.generateEmail(emailTemplate,lstAddresses,dealerAcquisitionId);
            EmailUtils.sendEmail(messageMails);
            
        }
        
        System.debug('************caseDealer per vedere utente lavorazione prima update: '+caseDealer.Utente_Lavorazione__c); 
        update caseDealer;    
        Case caseDealer2 = SFAConvenzionamento.getCase(caseId);
        System.debug('************caseDealer per vedere utente lavorazione dopo update: '+caseDealer2.Utente_Lavorazione__c);
	}

 	public class Dati {
        @AuraEnabled
        public Id dealerAcquisitionId {get; set;}
        @AuraEnabled
        public Id reportCervedId {get; set;}     
        @AuraEnabled
        public String OCSExternalFiliale {get; set;} 
        @AuraEnabled
        public String message {get; set;}        
        @AuraEnabled
        public Boolean IsAttivitaInManoAdAV {get; set;}         
        @AuraEnabled
        public XCS_Disposition__c disposition {get; set;}        
    }    
    
 
    
    
}