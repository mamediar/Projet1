({
    
    doInit: function(component, event, helper) {
               
        helper.controllCategory(component, event); 
        
        var action = component.get("c.getCodiciFiliale");
        var IsCodDealer = false;
        var IsPartitaIva = false;
        action.setCallback(this, function(data) {
            let retVal = data.getReturnValue();
            let region  = retVal != null ? retVal.Region_Name__c : '?';
            let area    = retVal != null ? retVal.OCSAreaId__c : '?';
            let filiale = retVal != null ? retVal.OCS_External_Id__c : '?' 
            var pad = "000"
            let codFilialeNoF = filiale.replace("F", "")
            let codFilialePadded = (pad + codFilialeNoF).slice(-pad.length)
            let codice = region + ' / ' + area + ' / ' + codFilialePadded + ' - '
            component.set("v.CodiciFiliale", codice);                       
        });
        $A.enqueueAction(action);
        if($A.util.isUndefined(component.get("v.CatId"))==false){
           var action = component.get("c.Ufficio");
            action.setParam('CatExternalId',component.get('v.CatId'));        
            action.setCallback(this, function(data) {
                let retVal = data.getReturnValue();
                let Ufficio = retVal;           
                component.set("v.TipoUfficio", Ufficio);
                if(component.get("v.TipoUfficio") == 0){
                    //helper.showToast('Ufficio abilitato alla creazione.','success');
                }else if($A.util.isUndefined(component.get("v.TipoUfficio"))){
                    //helper.showToast('Ufficio non definito per questa categoria.','error');
                }else{
                    helper.showToast('Ufficio non abilitato alla creazione.','error');
                    
                    var homeEvent = $A.get("e.force:navigateToObjectHome");
                    homeEvent.setParams({
                        "scope": "Case"
                    });
                    homeEvent.fire();

                }
            });        
            $A.enqueueAction(action); 
        }
                   
        var action = component.get("c.getRecordType");               
        action.setCallback(this, function(data) {
            let retVal = data.getReturnValue();
            let RecordTypeId = retVal;           
            component.set("v.Ticket.RecordTypeId", RecordTypeId);                         
        });        
        $A.enqueueAction(action);
        
		if($A.util.isUndefined(component.get("v.CatId"))==false){
            var action = component.get("c.getCategoria");
            console.log('categoria ID: ' + component.get('v.CatId'));
            action.setParam('catId',component.get('v.CatId'));
            action.setCallback(this, function(data) {
                let retVal = data.getReturnValue();
                console.log('retVal:' + retVal);
                let RecordTypeId = retVal;           
                component.set("v.SottoCategoriaScelta", retVal.Name);
                component.set("v.CategoriaScelta", retVal.Parent__r.Name);                    
            });        
            $A.enqueueAction(action);
        }
    },
    
    handleUploadFinished: function (component, event, helper) {
               
        var MapFilesToLink = (component.get("v.MapAttach") != null ) ? component.get("v.MapAttach"):  {};
        var fileInput = component.find("fuploader").get("v.files");
        var file = fileInput[0];
      
            helper.showToast(file.name+' caricato correttamente.','success');

            var self = this;             
            var objFileReader = new FileReader();     
            objFileReader.onload = function() {           
            var fileContents = objFileReader.result;    
            var base64 = 'base64,';
            var dataStart = fileContents.indexOf(base64) + base64.length;                
    
            fileContents = fileContents.substring(dataStart);               
            MapFilesToLink[file.name]=fileContents;
            component.set("v.MapAttach",MapFilesToLink);
        };        
        objFileReader.readAsDataURL(file);        
        component.set("v.FileUpload",true);
    },
    
    
    searchDealer: function (component, event, helper) {
        var action = component.get("c.getDealer");
        var CodDealer = component.get("v.CodDealer");
        if(CodDealer!=null && CodDealer!=''){
            helper.showSpinner(component, event);
            action.setParam('CodDealer',component.get('v.CodDealer'));            
            action.setCallback(this, function(data) {
                let retVal = data.getReturnValue();
                let Dealer = retVal;

                if(Dealer!=null){
                    console.log('DP Dealer: '+JSON.stringify(Dealer));
                    for(let i = 0; i < Dealer.length; i++){
                        if(Dealer[i].OCS_External_Id__c){
                            component.set("v.CodDealerFromApex", Dealer[i].OCS_External_Id__c);
                        }
                        component.set("v.RagioneSociale", Dealer[i].Name);
                        component.set("v.Ticket.AccountId", Dealer[i].Id);
                        if(component.get('v.RagioneSociale')==''){ 
                            component.set("v.DealerExistInSF",false);
                        }else{
                            component.set("v.DealerExistInSF",true);
                        }
                    }
                    //component.set("v.DealerExistInSF",true);
                }else{
                    component.set("v.RagioneSociale", null);
                    component.set("v.DealerExistInSF",false);
                    helper.showToast('Non sono stati recuperati i dati del dealer.','error');                   
                }
                helper.hideSpinner(component, event);
            });
            $A.enqueueAction(action);            
        }else{
            helper.showToast('Codice Dealer non definito!','error');
            component.set("v.DealerExistInSF",false);
            component.set("v.RagioneSociale", null);
        }
    },
    
    searchCliente: function (component, event, helper) {
        var action = component.get("c.getCliente");
        var CodCliente = component.get("v.CodiceCliente");
        var Profilo = component.get("v.Profilo");        
        action.setParam('CodCliente',component.get('v.CodiceCliente'));
        if(CodCliente!=''){
            helper.showSpinner(component, event);
            action.setCallback(this, function(data) {
                let retVal = data.getReturnValue();
                let Account = retVal;
                if(Account!=null){
                    let AccId  = retVal != null ? retVal.Id : '?';
                    component.set("v.Ticket.AccountId",AccId);
                    let Nome  = retVal != null ? retVal.FirstName : '?';
                    component.set("v.Nome",Nome);
                    let Cognome    = retVal != null ? retVal.LastName : '?';

                    component.set("v.Cognome",Cognome);
                    component.set("v.ClienteTrovato",true);
                    component.set("v.InfoCliente", data.getReturnValue());                   
                }else{
                    helper.showToast('Non sono stati recuperati i dati del cliente.','error');
                    component.set("v.InfoCliente", null);
                    component.set("v.ClienteTrovato",false);
                }
                helper.hideSpinner(component, event);
            });
            $A.enqueueAction(action);
            
        }else{
            helper.showToast('Codice Cliente non definito.','error');
        }           
    },
    
    searchPratica: function (component, event, helper) {
        var action = component.get("c.getPratica");
        var tipoDocComp = component.get("v.TipoDocMT");
        var numeroPraticaComp = component.get("v.Ticket.NumeroPratica__c").trim();
               
        action.setParams({
            numeroPratica : numeroPraticaComp,
            tipoDoc : tipoDocComp
        });
        
        if(numeroPraticaComp!=' '){
            helper.showSpinner(component, event);
            action.setCallback(this, function(data) {
                if(data.getState()=='SUCCESS'){

                    var retVal = data.getReturnValue();
                    var Cliente = retVal;
                    var Pratica;
                    var CliLength;       
                    if(Cliente!=null){ 
                        for(let i = 0; i < Cliente.length; i++){
                            CliLength = Cliente.length; 
                            component.set("v.Nome",Cliente[i].nome);
                            component.set("v.Cognome",Cliente[i].cognome);  
                            component.set("v.CodiceCliente",Cliente[i].codCliente);
               
                            Pratica = JSON.stringify(Cliente[i].pratiche);
                            Pratica = Cliente[i].pratiche;                       
                            for(let p = 0; p < Pratica.length; p++){
                                component.set("v.Prodotto",Pratica[p].prodotto);
                                component.set("v.DataSott",Pratica[p].dataCaricamento);
                            }                           
                        }
                        if(CliLength!=null){
                            component.set("v.ClienteTrovato",true);                    
                            component.set("v.InfoCliente", Cliente); 
                            component.set("v.InfoPratica", Pratica);
                            if(component.get("v.Cat_COD_PRT_WS")==true){
                                helper.SearchLivelloFirma(component, event);
                            }
                            
                        }else{
                            helper.showToast('Pratica/Cliente non trovato!','error');
                            component.set("v.ClienteTrovato",false);
                            component.set("v.DataManuale",false);
                        }                          
                    }else{
                        helper.showToast('Pratica/Cliente non trovato!','error');
                    }
                }else{
                    helper.showToast('La ricerca ha dato errore!','error');
                }
            helper.hideSpinner(component, event);
            });
            $A.enqueueAction(action);
            
        }else{
            helper.showToast('Inserire il numero pratica','error');
        }       
    },
    
    SearchDataDelHelp: function (component, event, helper) {
        var action = component.get("c.getDataDelibera");
        var tipoDocComp = component.get("v.TipoDocMT");
        var numeroPraticaComp = component.get("v.Ticket.NumeroPratica__c");
          
        action.setParams({
            numeroPratica : numeroPraticaComp,
            tipoDoc : tipoDocComp
        });
        
        if(numeroPraticaComp!=''){
            helper.showSpinner(component, event);
            action.setCallback(this, function(data) {
                if(data.getState()=='SUCCESS'){
                    var retVal = data.getReturnValue();
                    var DataDel;    
                    var DataApprovazioneResponse;
                    
                    if(retVal!=null){
                            DataApprovazioneResponse = retVal.recuperaDataApprovazioneResponse.dataApprovazione;

                            if(DataApprovazioneResponse!=null){
                                component.set("v.DataUltimaDelibera",DataApprovazioneResponse);
                                var anno = DataApprovazioneResponse.substring(0, 4);
                                var mese = DataApprovazioneResponse.substring(4, 6);
                                var giorno = DataApprovazioneResponse.substring(6, 8);
                            
                                var mydate = new Date(anno, mese, giorno);
                                component.set('v.DataUltimaDelibera', mydate.getFullYear() + "-" + (mydate.getMonth()) + "-" + mydate.getDate());

                                component.set("v.ClienteTrovato",true);
                                component.set("v.DataManuale",false);
                            }else{
                               component.set("v.DataManuale",true);
                               component.set('v.DataUltimaDelibera', null);
                               component.set("v.ClienteTrovato",false);
                               helper.showToast('Data non trovata!','error'); 
                            }
                            
                                                   
                    }else{
                       
                        component.set("v.DataManuale",true);

                        helper.showToast('Data non trovata!','error');
                    }
                }else{
                    helper.showToast('La ricerca ha dato errore!','error');
                }
            	helper.hideSpinner(component, event);
            });
            $A.enqueueAction(action);
        }else{
            helper.showToast('Inserire il numero pratica da ricercare.','error');
        }        
    },
    
    create : function(component, event, helper) {
        console.log('Controlli per la creazione del Ticketing.');
        
        //getting the Ticket information
        var Ticket = component.get("v.Ticket");
        var CodDealer = component.get("v.CodDealer");
        var RagSociale = component.get("v.RagioneSociale");
        var NumProtocollo = component.get("v.NumeroProtocollo");
        var CodCarta = component.get("v.CodiceCarta");
        var CanAcquisizione1 = component.get("v.CanaleAcquisizione1");
        var CanAcquisizione2 = component.get("v.CanaleAcquisizione2");
        var PartitaIva = component.get("v.PartitaIva");
        var CodiceFiscale = component.get("v.CodiceFiscale");
        var CodPratica = component.get("v.Ticket.NumeroPratica__c");
        var DataUltimaDel = component.get("v.DataUltimaDelibera");
        var CodiceCliente = component.get("v.CodiceCliente");
        var Profilo = component.get("v.Profilo");
        
        //Validation
        if($A.util.isEmpty(Ticket.Subject) || $A.util.isUndefined(Ticket.Subject)){
            helper.showToast('Subject non è definito!','error');
            return;
        } 
        if(component.get("v.Cat_COD_DEALER") == true &&  component.get("v.RagioneSociale")==null){
            helper.showToast('Codice dealer o PV obbligatori.','error');
            return;
        }
        if($A.util.isEmpty(Ticket.Description) || $A.util.isUndefined(Ticket.Description)){
            helper.showToast('Descrizione vuota.','error');
            return;
        }
        if(component.get("v.FileUpload") == false  && component.get("v.Cat_ATTACH") == true){
            helper.showToast(component.get("v.Err_ATTACH") != null ? component.get("v.Err_ATTACH") : 'Allegato obbligatorio.','error');
            return;
        }
        if(component.get("v.FileUpload") == false  && component.get("v.Cat_ATTACH_INSTRUCTION") == true){
            helper.showToast(component.get("v.Err_ATTACH_INSTRUCTION") != null ? component.get("v.Err_ATTACH_INSTRUCTION") : 'Allegato obbligatorio.','error');
            return;
        }
        if(component.get("v.Cat_COD_CA") == true &&  $A.util.isUndefined(CodCarta)){
            helper.showToast(component.get("v.Err_COD_CA") != null ? component.get("v.Err_COD_CA") : 'Codice Carta obbligatorio.','error');
            return;
        }
        if(component.get("v.Cat_NUM_PROTC") == true &&  ($A.util.isUndefined(NumProtocollo) || NumProtocollo=='')){            
            helper.showToast(component.get("v.Err_NUM_PROTC") != null ? component.get("v.Err_NUM_PROTC") : 'Numero protocollo obbligatorio.','error');
            return;
        }
        if((component.get("v.Cat_CHN_ACQ") == true) && $A.util.isEmpty(CanAcquisizione1)){ 
            helper.showToast(component.get("v.Err_CHN_ACQ") != null ? component.get("v.Err_CHN_ACQ") : 'Canale acquisizione obbligatorio.','error');
            return;
        }
        if((component.get("v.Cat_CHN_MAP") == true) && $A.util.isEmpty(CanAcquisizione2)){ 
            helper.showToast(component.get("v.Err_CHN_MAP") != null ? component.get("v.Err_CHN_MAP") : 'Canale acquisizione obbligatorio.','error');
            return;
        }        
        if((component.get("v.Cat_COD_PRT") == true &&  $A.util.isUndefined(CodPratica)) || (component.get("v.ClienteTrovato") == false  && component.get("v.Cat_COD_PRT") == true)){
            helper.showToast(component.get("v.Err_COD_PRT") != null ? component.get("v.Err_COD_PRT") : 'Ricerca pratica obbligatoria.','error');
            return;
        }
        if((component.get("v.Cat_COD_PRT_WS") == true &&  $A.util.isUndefined(CodPratica)) || (component.get("v.ClienteTrovato") == false  && component.get("v.Cat_COD_PRT_WS") == true)){
            helper.showToast(component.get("v.Err_COD_PRT_WS") != null ? component.get("v.Err_COD_PRT_WS") : 'Ricerca pratica obbligatoria.','error');
            return;
        } 
        if(component.get("v.Cat_COD_PRT_DELIB") == true && DataUltimaDel==null){  
            helper.showToast(component.get("v.Err_COD_PRT_DELIB") != null ? component.get("v.Err_COD_PRT_DELIB") : 'Ricerca Data ultima delibera obbligatoria.','error');
            return;
        }
        if(component.get("v.Cat_P_IVA") == true &&  ($A.util.isUndefined(PartitaIva) || PartitaIva=='')){
            helper.showToast(component.get("v.Err_P_IVA") != null ? component.get("v.Err_P_IVA") : 'Partita iva obbligatoria.','error');
            return;
        }
        if(component.get("v.Cat_COD_CLIENTE") == true &&  component.get("v.ClienteTrovato") == false){
            helper.showToast(component.get("v.Err_COD_CLIENTE") != null ? component.get("v.Err_COD_CLIENTE") : 'Ricerca Cliente obbligatoria.','error');
            return;
        }
    	if(component.get("v.Cat_COD_CLIENTE") == true  &&  $A.util.isUndefined(Profilo)){
            helper.showToast('Profilo obbligatorio.','error');
            return;
        }
        if(component.get("v.Cat_COD_FISCALE") == true &&  $A.util.isUndefined(CodiceFiscale)){ 
            helper.showToast(component.get("v.Err_COD_FISCALE") != null ? component.get("v.Err_COD_FISCALE") : 'Codice Fiscale obbligatorio.','error');
            return;
        }
        if($A.util.isEmpty(Ticket.Priority) || $A.util.isUndefined(Ticket.Priority)){
            helper.showToast('Priorità Ticketing non definito!','error');
            return;
        }
        //Calling the Apex Function
        
        var action = component.get("c.CatSFid");       
        action.setParam('CatExternalId',component.get('v.CatId')); 
        
        action.setCallback(this, function(data) {
            let retVal = data.getReturnValue();
            let CatSFid = retVal;           
            component.set("v.Ticket.Categoria_Riferimento__c", CatSFid);
            helper.createCase(component, event);            
        });        
        $A.enqueueAction(action);        
    },
    
    backNavigate: function (component, event, helper) {
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:PVInserimento",
            componentAttributes: {
                
            }
        });
        evt.fire();         
    }
    
})