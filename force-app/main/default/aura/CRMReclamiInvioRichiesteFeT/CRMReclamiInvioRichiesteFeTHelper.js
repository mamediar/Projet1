({
    getData : function(cmp) {
        console.log('init del case');
        var objectId = cmp.get('v.objectId');        
        var action = cmp.get("c.getReclamo");
        console.log('objectId ' + objectId);
        action.setParams({
            'reclamoId': objectId
        });         
        action.setCallback(this, function(response){
            if (response.getState() == 'SUCCESS'){
                cmp.set('v.createdDateLocale', (new Date(response.getReturnValue()['CreatedDate'])).toLocaleDateString());
                cmp.set('v.lastModifiedDateLocale', (new Date(response.getReturnValue()['LastModifiedDate'])).toLocaleDateString());
                cmp.set('v.reclamo',response.getReturnValue());
                cmp.set('v.codCliente',response.getReturnValue()['getCodice_Cliente__c']);
                cmp.set('v.accountId',response.getReturnValue()['AccountId']);
                cmp.set('v.categoriaId',response.getReturnValue()['Categoria_Riferimento__c']);
              
                this.getAccount(cmp);
                this.getCategoria(cmp);
                this.loadStandardTest(cmp, event);
                this.loadMessaggio(cmp);
                
            }
            else
                console.log('uuups la callBack fallisce');
        });
        $A.enqueueAction(action); 		
    },
    
   loadMessaggio : function(cmp) {
       
        var codiceCliente = cmp.get('v.accountId');
       
        var action = cmp.get("c.loadMessaggioCTRL");       
        action.setParams({
            'token': cmp.get('v.token')
        });         
        action.setCallback(this, function(response){
            if (response.getState() == 'SUCCESS'){
                cmp.set('v.messaggioEmail',response.getReturnValue());
               
            }
           
        });
       	
        $A.enqueueAction(action); 		
    },
    
    getAccount : function(cmp) {
        console.log('sono nell init dell account');
        var codiceCliente = cmp.get('v.accountId');
        console.log('accountId =  ' + codiceCliente);
        var action = cmp.get("c.getCliente");       
        action.setParams({
            'accountId': codiceCliente
        });         
        action.setCallback(this, function(response){
            if (response.getState() == 'SUCCESS'){
                cmp.set('v.cliente',response.getReturnValue());
                console.log('success call back');
                console.log(JSON.stringify(cmp.get('v.cliente')));
            }
            else
                console.log('uuups la callBack fallisce');
        });
        $A.enqueueAction(action); 		
    },
    
    
    getCategoria : function(cmp) {
        var action = cmp.get("c.getCategoria");
        action.setParam('categoriaId',cmp.get('v.reclamo')['Categoria_Riferimento__c']);
        action.setCallback(this, function(response){
            if (response.getState() == 'SUCCESS'){
                cmp.set('v.categoria', response.getReturnValue());
            
            }
            else
                console.log('uuups la callBack fallisce');
        });
        $A.enqueueAction(action); 
    },
    
    loadStandardTest : function (cmp){
        var action = cmp.get("c.loadTesti");
        var categoria = cmp.get('v.categoria');
        var societa_reclamo = cmp.get('v.reclamo').Referenced_Company__c;


        var societa = societa_reclamo!=null ? societa_reclamo : societa_cliente
        
        action.setParams({
            'categoria': categoria,
            'societa' : societa
        });
        
        action.setCallback(this, function(response){
            if (response.getState() == 'SUCCESS'){
                var x = response.getReturnValue();
                cmp.set('v.listaTitoli',response.getReturnValue());
            
            }   else
                console.log('uuups la callBack fallisce');
        });
        $A.enqueueAction(action);
        
    },

    inserisciTestoStandard : function(cmp, event){
        //var selezione = cmp.get("v.stdtextSelected");
        var selezione = cmp.find("standardTxt").get('v.value');
        
        if(selezione == null || selezione == undefined || selezione.length == 0){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Errore!",
                "message": "Seleziona un valore",
                "type" : "error"
            });
            toastEvent.fire();
            return ;
        }
        cmp.set("v.spinner", true);
        var action=cmp.get('c.getMessageStandard');
          action.setParams({
              'idTesto':selezione,
              'caseId' : cmp.get('v.objectId')
          });
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                cmp.set('v.messaggio',resp.getReturnValue());
            }
             cmp.set("v.spinner", false);
        });
        $A.enqueueAction(action);
    },

    inviaRispostaDefinitiva : function(cmp, event, helper){
	  cmp.set('v.showModal',false);
        
        var action = cmp.get("c.finalConfirm");
        var testo = cmp.get('v.testoStandardValue');
        if(cmp.get('v.testoStandardValue') == 'Seleziona')testo = 'Nessuno';
            
        action.setParams({
            'myCase' : cmp.get('v.reclamo'),
            'frode': cmp.get('v.frodeAccertata'),
            'testoStandard': cmp.get('v.testoStandard'),
            'testoStandardValue': testo,
            'firma': cmp.get('v.firmaDigitale'),
            'allegati' : cmp.get('v.staticFileList'),
            'allegatiOriginali' : cmp.get('v.staticFileList').length,
            'messaggio' : cmp.get('v.messaggio')
        });         
   
        action.setCallback(this, function(response){
       
            if (response.getState() == 'SUCCESS'){
                console.log(response.getReturnValue());
                this.finish(cmp, event);
                cmp.set('v.isNotSent',false);
            }
            else{
                console.log('uuups la callBack fallisce... why?');
            }
             cmp.set("v.spinner", false);
        });
         cmp.set("v.spinner", true);
        $A.enqueueAction(action); 
    },
    
    finish: function(cmp, event) { 
        /*var sendMsgEvent = $A.get("e.ltng:sendMessage"); 
        sendMsgEvent.setParams({
            "message": "Finish", 
            "channel": "toVisualForcePage" 
        }); 
        sendMsgEvent.fire(); */
        //cmp.set('v.msg', 'Risposta salvata correttamente');
        //this.showSuccessToast(cmp);
        //window.open('/'+cmp.get('v.objectId'));
        alert('Risposta salvata correttamente');
    },
    
    loadFiles : function(cmp,event,helper){
        var action = cmp.get("c.getFiles");
        action.setParam('recordId', cmp.get('v.objectId'));
        action.setCallback(this, function(response){
            if (response.getState() == 'SUCCESS'){
                console.log('la response di getFiles è = ' + response.getReturnValue());
                cmp.set('v.staticFileList',response.getReturnValue());      
                cmp.set('v.filesVecchi',response.getReturnValue());
                console.log('staticFiles = '+JSON.stringify(cmp.get('v.staticFileList'))); 
                cmp.set('v.quantitaFile', cmp.get('v.staticFileList').length);
                console.log('ci sono ' + cmp.get('v.quantitaFile') + ' files');
                console.log('file vecchi = ' + cmp.get('v.fileVecchi'));
                cmp.set('v.idf',response.getReturnValue()[0]['Id']);
                console.log('udf = '+cmp.get('v.idf'));
            }   
            else
                console.log('uuups la callBack fallisce');
        });
        $A.enqueueAction(action);        
    },

    readUrlParams: function (cmp) {
        var getUrlParameter = function getUrlParameter(sParam) {
            var sPageURL = decodeURIcmp(window.location.search.substring(1)),
                sURLVariables = sPageURL.split('&'),
                sParameterName,
                i;

            for (i = 0; i < sURLVariables.length; i++) {
                sParameterName = sURLVariables[i].split('=');
                if (sParameterName[0] === sParam) {
                    return sParameterName[1] === undefined ? true : sParameterName[1];
                }
            }
        };

        cmp.set("v.objectId", getUrlParameter('objectid'));
    },

    setFirmaDigitale: function (cmp) {
        var action = cmp.get("c.getUserName");
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var name = response.getReturnValue();
                if (!name.includes('Guest')) {
                    cmp.set("v.firmaDigitale", name);
                    cmp.find('firma-digitale').set('v.readonly', true);
                }
            }
            else if (state === 'ERROR') {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        cmp.set('v.msg', errors[0].message);
                        this.showErrorToast(cmp);
                    }
                } else {
                    cmp.set('v.msg', 'Unknown error');
                    this.showErrorToast(cmp);
                }
            }
        })

        $A.enqueueAction(action);
    },

    isBlank: function (input) {
        var value = input.get('v.value');
        if (value === undefined || value === null || value == '' || value == ' ') {
            return true;
        }
        return false;
    },
    
    showSuccessToast : function(cmp) {
        cmp.find('notifLib').showToast({
            "variant": "success",
            "title": "Success!",
            "message": cmp.get('v.msg')
        });
    },

    showErrorToast : function(cmp) {
        cmp.find('notifLib').showToast({
            "variant": "error",
            "title": "Error!",
            "message": cmp.get('v.msg')
        });
    },

    showInfoToast : function(cmp) {
        cmp.find('notifLib').showToast({
            "variant": "info",
            "title": "Info",
            "message": cmp.get('v.msg')
        });
    },

    showWarningToast : function(cmp) {
        cmp.find('notifLib').showToast({
            "variant": "warning",
            "title": "Warning!",
            "message": cmp.get('v.msg')
        });
    },
	
	showNotice : function(cmp) {
        cmp.find('notifLib').showNotice({
            "variant": "info",
            "header": "Info",
            "message": cmp.get("v.notifMsg"),
            closeCallback: function() {
                
            }
        });
    },

    showSpinner: function(cmp) {
        cmp.set('v.showSpinner', true);
    },

    hideSpinner: function(cmp) {
        cmp.set('v.showSpinner', false);
    }
                    
})