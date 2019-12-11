public class VenditaAssicurazioneGRController {  
    
    @TestVisible
    private class initVariables{
        @TestVisible @AuraEnabled private List<OCSPratica> assicurazioniPosseduteData {get; set;}
        @TestVisible @AuraEnabled private List<OCSPratica> cartePerPagamentoData {get; set;}
        @TestVisible @AuraEnabled private List<OCSPratica> ibanPerPagamentoData {get; set;}       
        @TestVisible @AuraEnabled private List<ProductOption> productOptions {get; set;}                
        @TestVisible @AuraEnabled private String clientAddress {get; set;}
        @TestVisible @AuraEnabled private String clientFullName {get; set;}
        @TestVisible @AuraEnabled private String evoOffice {get; set;}
        @TestVisible @AuraEnabled private String scriptTelefonataStretch {get; set;}
 	
        @TestVisible
        initVariables(){
            assicurazioniPosseduteData = new List<OCSPratica>();
            cartePerPagamentoData = new List<OCSPratica>();
            ibanPerPagamentoData = new List<OCSPratica>();
            productOptions = new List<ProductOption>();
        }
    }
    
    @TestVisible
    private class APIVariables{
        @TestVisible @AuraEnabled private List<OCSCartaDatiFinanziariResponse.DatiCartaDatiFinanziariResponseDTO> cartaDatiFinanziariData {get; set;}
        @TestVisible @AuraEnabled private List<OCSRecuperaMovAutViaggiantiResponse.MovimentoViaggianteDTO> movimentiViaggiantiData {get; set;}
        @TestVisible @AuraEnabled private List<OCSRecuperaMovAutViaggiantiResponse.AutorizzazioneViaggianteDTO> autorizzazioniData {get; set;}
        @TestVisible @AuraEnabled private Boolean flagCartaDatiFinanziariError {get; set;}        
        
        @TestVisible
        APIVariables(){
            cartaDatiFinanziariData = new List<OCSCartaDatiFinanziariResponse.DatiCartaDatiFinanziariResponseDTO>();
            movimentiViaggiantiData = new List<OCSRecuperaMovAutViaggiantiResponse.MovimentoViaggianteDTO>();
            autorizzazioniData = new List<OCSRecuperaMovAutViaggiantiResponse.AutorizzazioneViaggianteDTO>();
        }
    }
    
    @TestVisible
    private class ProductOption{
        @TestVisible @AuraEnabled private String label {get; set;}
        @TestVisible @AuraEnabled private String value {get; set;}        
    }    
    
    @AuraEnabled 
    public static initVariables doInit(String codCliente, String formattedProfileName, String caseId){
        initVariables res = new initVariables();
        OCSRecuperaDatiPostvenditaResponse response = OCSRecuperaDatiPostvenditaInvoker.callRecDatiPV(codCliente);
        List<Product2> productList = new List<Product2>();
        
        List<OCSCliente> tempClientList = OCSObjectsFactory.makeClienti(response);
        
        Case currentCase = [SELECT Id, Esito__c FROM Case WHERE Id =: caseId];
        productList = [SELECT Description, productCode FROM Product2 WHERE isActive = true];
        
        if(!tempClientList.isEmpty()){   
            //System.debug('ASSICURAZIONI TODAY: ' + tempClientList[0].getAssicurazioniToday());
            res.assicurazioniPosseduteData = tempClientList[0].getAssicurazioni();                                
            res.cartePerPagamentoData = tempClientList[0].getCALogic();//tempClientList[0].getCA();
            res.ibanPerPagamentoData = tempClientList[0].getIbanPerPagamentoList();
            res.clientFullName = tempClientList[0].nome + ' ' + tempClientList[0].cognome;
            res.clientAddress = tempClientList[0].indirizzo + ', ' +
                				tempClientList[0].cap + ', ' + 
                				tempClientList[0].localita + ', ' + 
                				tempClientList[0].provincia;
        }  
        
        res.evoOffice = PermissionUtils.isCallCenterInterno() ? '00000000               O' : '00000000               I';
        res.scriptTelefonataStretch = ('Richiesta inserita con recall'.equalsIgnoreCase(currentCase.Esito__c)) ? 'Outbound' : ('Inviata doc precontrattuale'.equalsIgnoreCase(currentCase.Esito__c)) ? '3699' : 'Altri';
        
        for(Product2 p : productList){
            ProductOption tempProductOption = new ProductOption();
            tempProductOption.label = p.Description;
            tempProductOption.value = p.ProductCode;
            res.ProductOptions.add(tempProductOption);
        }
        

        return res;                
    }  
    
    @AuraEnabled 
    public static APIVariables callWebServices(String numeroPratica){
        APIVariables res = new APIVariables();
        
        List<OCSCartaDatiFinanziariResponse.DatiCartaDatiFinanziariResponseDTO> cartaDatiFinanziariResponseList = new List<OCSCartaDatiFinanziariResponse.DatiCartaDatiFinanziariResponseDTO>();        	
        List<OCSRecuperaMovAutViaggiantiResponse.MovimentoViaggianteDTO> movimentiViaggianti = new List<OCSRecuperaMovAutViaggiantiResponse.MovimentoViaggianteDTO>();
        List<OCSRecuperaMovAutViaggiantiResponse.AutorizzazioneViaggianteDTO> autorizzazioniViaggiantiList = new List<OCSRecuperaMovAutViaggiantiResponse.AutorizzazioneViaggianteDTO>();
        
        OCSCartaDatiFinanziariResponse cartaDatiFinanziariResponse = OCSCartaDatiFinanziariInvoker.cartaDatiFinanziari(numeroPratica);
        OCSRecuperaMovAutViaggiantiResponse recuperaMovAutViaggiantiResponse = OCSRecuperaMovAutViaggiantiInvoker.recuperaMovAutViaggianti(numeroPratica);

        cartaDatiFinanziariResponseList.add(cartaDatiFinanziariResponse.datiCartaDatiFinanziariResponse); 
        movimentiViaggianti = recuperaMovAutViaggiantiResponse.recuperaMovimentiAutorizzazioniViaggiantiResponse.recuperaMovViaggiantiResponse.elencoMovimenti;
        autorizzazioniViaggiantiList = recuperaMovAutViaggiantiResponse.recuperaMovimentiAutorizzazioniViaggiantiResponse.recuperaAutViaggiantiResponse.elencoAutorizzazioni;
        
        res.cartaDatiFinanziariData = cartaDatiFinanziariResponseList;
        res.movimentiViaggiantiData = movimentiViaggianti;
       
        res.autorizzazioniData = autorizzazioniViaggiantiList;
        res.flagCartaDatiFinanziariError = !cartaDatiFinanziariResponse.isStatusOK();
        
        return res;
    }
    
    @AuraEnabled
    public static List<OCSPratica> callUpdateOCS(String codCliente){
        List<OCSPratica> res = new List<OCSPratica>();
        OCSRecuperaDatiPostvenditaResponse response = OCSRecuperaDatiPostvenditaInvoker.callRecDatiPV(codCliente);
        List<OCSCliente> tempClientList = OCSObjectsFactory.makeClienti(response);
        if(!tempClientList.isEmpty()) res = tempClientList[0].getAssicurazioniToday(); 
        return res;
    }
    
    @AuraEnabled
    public static String schedule(String caseId, Datetime schedulingDate){               
        Case currentCase = [SELECT Id FROM Case WHERE Id =: caseId]; 
        //String profileName = [SELECT Profile.Name from User WHERE Id =: UserInfo.getUserId()].Profile.Name;
                
        currentCase.RecallDate__c = schedulingDate;
        currentCase.Esito__c = 'Richiesta inserita con recall';          
        
        CaseUtils.assignToQueue(currentCase.Id, (PermissionUtils.isNET() ? 'Q313' : 'Q360'));
        
        update currentCase;        
        return 'Outbound';
    }
    
    @AuraEnabled
    public static void upshot(String caseId, String interestValue, String interestValueOutput, List<Object> products, String modalitaInvioContratto, Datetime schedulingDate ,String noteVendita){
        /*********20190621 REMOVED BUILD******
         * 
        Case currentCase = [SELECT Id, Account.PersonEmail, Owner.Name FROM Case WHERE Id =: caseId];                
        User userInfo = [SELECT Id, Alias from User WHERE Id =: UserInfo.getUserId()];
        List<String> staticResourcesNameList = new List<String>();
        
        //userInfo.Profile.Name = userInfo.Profile.Name.replace(' ', '_');

        for(Object o : products){
            String staticResourceName = 'Informativa_Assicurazione_' + o + '_';            
            staticResourceName += (PermissionUtils.isCallCenterInterno()) ? userInfo.Alias : PermissionUtils.getPermissionName();
            staticResourcesNameList.add(staticResourceName);
        } 
        
        StaticResource[] staticResources = [SELECT Id, Name, Body FROM StaticResource WHERE Name IN : staticResourcesNameList];
        
        for(StaticResource s : staticResources){
            if('posta'.equalsIgnoreCase(modalitaInvioContratto))
                CompassUtils.attachFile(CompassUtils.fileNewInstance(s.Body, 'Informativa Assicurazzione', 'pdf'), caseId);
            else if('email'.equalsIgnoreCase(modalitaInvioContratto)){
                System.debug('DENTRO EMAIL');
                List<String> emailAddresses = new List<String>();                            
                List<Id> attachments = new List<Id>();
                emailAddresses.add(currentCase.Account.PersonEmail);
                if(!Test.isRunningTest()) attachments.add(CompassUtils.fileNewInstance(s.Body, 'Informativa Assicurazzione', 'pdf'));
                Messaging.SingleEmailMessage email = EmailUtils.generateEmail('Informativa_Assicurazione', emailAddresses, attachments);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            }
        }
         
        if('non_interessato'.equalsIgnoreCase(interestValue) || 'Irreperibile'.equalsIgnoreCase(interestValue) || 'Pratica caricata'.equalsIgnoreCase(interestValueOutput))
            currentCase.Status = 'Closed';        

        if(schedulingDate != null) schedule(currentCase.Id, schedulingDate);
        
        currentCase.CrmVenAssInvioDoc__c = modalitaInvioContratto;
        currentCase.Esito__c = interestValueOutput;
        currentCase.Note__c = noteVendita;
        
        update currentCase;
*****/
    }
    
}