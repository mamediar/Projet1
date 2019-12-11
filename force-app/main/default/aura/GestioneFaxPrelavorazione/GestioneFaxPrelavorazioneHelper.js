({
    isPrelavorazioneEnabled : function (cmp) {
        
        var action = cmp.get('c.hasTaskAssociati');
        action.setParam('recordId', cmp.get('v.recordId'));
        action.setCallback(this,function(response){
            console.log('SONO DOPO DEL CALLBACK');
            console.log('IS PRELAVORAZIONE ENABLED ::::: >' + response.getReturnValue());
            
            var state = response.getState();
            console.log('STATE:::::::::::::::> ' + state);
            if (state == 'SUCCESS'){
                cmp.set('v.isPrelavorazioneDisabled', response.getReturnValue());  
            }
        });
        $A.enqueueAction(action);
    },

    getOptions : function ( )
    {
        return [
            { "tipo" : "ok", "label" : "Gestisci", "value" : "gestisci", "category_id" : "", "queue_id" : "", "disposition_id" : "" },
            { "tipo" : "ko", "label" : "Illegibile", "value" : "illegibile", "category_id" : "", "queue_id" : "", "disposition_id" : "DP4718"  },
            { "tipo" : "ko", "label" : "Non Cliente", "value" : "non-cliente", "category_id" : "", "queue_id" : "", "disposition_id" : "DP4719"  },
            { "tipo" : "ko", "label" : "Non Riconosciuto", "value" : "non-riconosciuto", "category_id" : "", "queue_id" : "Q254", "disposition_id" : "DP4720"  },
            { "tipo" : "ko", "label" : "Doppio", "value" : "gestisci", "doppio" : "", "queue_id" : "", "disposition_id" : "DP4721"  },
            { "tipo" : "inoltro", "label" : "Inoltro a Generico", "value" : "generico", "category_id" : "3627", "queue_id" : "Q501", "disposition_id" : ""  },
            { "tipo" : "inoltro", "label" : "Inoltro a Attivazione Zone a Rischio", "value" : "zone-rischio", "category_id" : "3628", "queue_id" : "Q501", "disposition_id" : ""  },
            { "tipo" : "inoltro", "label" : "Inoltro a Reclami", "value" : "reclami", "category_id" : "3629", "queue_id" : "Q501", "disposition_id" : ""  },
            { "tipo" : "inoltro", "label" : "Inoltro a CS Interno", "value" : "cs-interno", "category_id" : "3630", "queue_id" : "Q501", "disposition_id" : ""  },
            { "tipo" : "inoltro", "label" : "Inoltro a COL", "value" : "col", "category_id" : "3631", "queue_id" : "Q501", "disposition_id" : ""  },
            { "tipo" : "inoltro", "label" : "Inoltro a  Futuro 0248244796", "futuro" : "gestisci", "category_id" : "", "queue_id" : "Q501", "disposition_id" : "DP4722"  },
            { "tipo" : "inoltro", "label" : "Inoltro a Denunce", "value" : "denunce", "category_id" : "", "queue_id" : "Q198", "disposition_id" : "DP5409"  },
            { "tipo" : "inoltro", "label" : "Inoltro a Generico NB", "value" : "generico-nb", "category_id" : "", "queue_id" : "Q198", "disposition_id" : "DP5410"  }  
          ]
    },

    getSelectOptions : function () {
        var opts = this.getOptions();
        console.log ( opts );
        var results = [];
        opts.forEach( function(item, index) {
            results.push( { label : item.label, value : item.value + ';' + index } );  
        })
        
        return results;
    },
    
    setOptions : function(cmp) {     
        var opts = this.getSelectOptions();
        cmp.set('v.esitoOptions', opts );
        cmp.set('v.esitoSize', '6' );
    
    },

    chooseDisposition : function ( cmp, scelta ){
        var toast = $A.get('e.force:showToast');
        var action = cmp.get('c.saveDisposition');
        var objId = cmp.get('v.recordId');
        var spinner = cmp.find('spinnerComponent');
        spinner.incrementCounter();
        action.setParams ( { 'caseId' : objId,  'scelta' : JSON.stringify(scelta) } );
        action.setCallback(this, function( response ){
            spinner.decreaseCounter();
            if ( response.getState() == 'SUCCESS' )
            {
                toast.setParams({
                    title: 'Operazione avvenuta con successo',
                    type : 'success',
                    message : ' '
                });
                toast.fire();
                this.closeTab( cmp )
            }
        } );
        $A.enqueueAction(action);
    },
    
    
    loadQueueMailFax : function(cmp){
        var action = cmp.get('c.getQueueMailFax');
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                var result = response.getReturnValue();
                cmp.set('v.inoltroOptions', result);
            }
        });
        $A.enqueueAction(action);
    },
    
    loadProductsHelper : function(cmp){
        var action = cmp.get('c.loadProducts');  
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                var result = response.getReturnValue();
                cmp.set('v.prodottiOptions', result);
                console.log('prodottiOPTIONS ::::> ');
                console.log(cmp.get('v.prodottiOptions')[0]);
            }
        });
        $A.enqueueAction(action);
    },
    
    loadConfigsHelper : function (cmp) {
        var action = cmp.get('c.loadConfigs');
        action.setCallback(this,function(response){
            if(response.getState() == 'SUCCESS') {
                var result = response.getReturnValue();
                cmp.set('v.loadedConfig', result);
            }
        });
        $A.enqueueAction(action);
    },
    
    getCategorieHelper : function (cmp) {
        var action = cmp.get('c.getCategorie');
        action.setCallback(this,function(response){
            if(response.getState() == 'SUCCESS') {
                var result = response.getReturnValue();
                cmp.set('v.loadedCategorie', result);
            }
        });
        $A.enqueueAction(action);
    },

    filtroTipoPratica : function(cmp) {
        cmp.get("v.prodottiOptions").forEach(function(tmp){
            if(tmp['MasterLabel'] == cmp.get('v.prodottoSelezionato')){
                if(tmp['DeveloperName'] == 'Nessuna_pratica_azione_sul_cliente')
                    cmp.set('v.filtroTipoPratica','');
                else
                    cmp.set('v.filtroTipoPratica',tmp['NotUniqueLabel__c']);                
            }
        });
        console.log('filtro = ' + cmp.get('v.filtroTipoPratica'));
    },
    
    loadCategorieHelper : function(cmp) {
        console.log(cmp.get('v.prodottoSelezionato'));
        console.log('prodotti option = ' + JSON.stringify(cmp.get('v.prodottiOptions')));
        cmp.set('v.categoriaSelezionata', '');
        console.log('CATEGORIA SELEZIONATA MALE :::::::::::::::> ' + cmp.get('v.categoriaSelezionata'));
        
        var configs = cmp.get('v.loadedConfig');
        var prodotti = cmp.get('v.prodottiOptions');
        var categorie = cmp.get('v.loadedCategorie');
        var idCategorieSelezionate =[];
        var categorieSelezionate = [];
        var count = 0;
        var prodottoSelezionato = cmp.get('v.prodottoSelezionato');
        
        if(prodottoSelezionato) {
            
            var idProdottoSelezionato =  (prodotti.find(function(temp){
                return temp.MasterLabel == prodottoSelezionato;
            }).idProdotto__c);
            
            
            
            configs.forEach(function(temp){
                if(temp.idProdotto__c == idProdottoSelezionato) {
                    idCategorieSelezionate.push(temp.idCategoria__c) ;  
                }
            });
            
            while (count < idCategorieSelezionate.length) {
                categorie.forEach(function(temp){
                    if(temp.idAzione__c == idCategorieSelezionate[count]){
                        categorieSelezionate.push(temp.Label__c);
                    }
                });
                count++;
            };
            cmp.set('v.categoriaOptions', categorieSelezionate.sort());
        }
        else
            cmp.set('v.categoriaOptions', '');
        
    },
    
    sideShow : function(element){
        element.style.setProperty('display', 'block');
        var elementOffsetWidth = element.offsetWidth;
        element.style.setProperty('width', 0);
        setTimeout(function(){element.style.setProperty('width', (elementOffsetWidth + 'px'));}, 1);
    },
    
    sideHide : function(element){
        var currentWidth = element.offsetWidth;
        setTimeout(function(){element.style.setProperty('width', 0);}, 1);        
        setTimeout(function(){
            element.style.setProperty('display', 'none');
            //element.style.removeProperty('display');
            element.style.removeProperty('width');
        }, 301);                 
    },
    
    rollShow : function(element){
        element.style.setProperty('display', 'block');
        var elementOffsetHeight = element.offsetHeight + 2;
        element.style.setProperty('height', 0);
        setTimeout(function(){element.style.setProperty('height', (elementOffsetHeight + 'px'));}, 1);
        setTimeout(function(){element.style.setProperty('height', 'auto');}, 301);
    },
    
    rollHide : function(element){
        var currentHeight = element.offsetHeight;
        element.style.setProperty('height', (currentHeight + 'px'));
        setTimeout(function(){element.style.setProperty('height', 0);}, 1);        
        setTimeout(function(){
            element.style.setProperty('display', 'none');
            //element.style.removeProperty('display');
            element.style.removeProperty('height');
        }, 301); 
    },
    
    checkIfDuplicated : function (cmp,idProdotto,idCategoria,emettitoreValue,prodottoValue,categoriaValue,pratica,presaVisione,helper) {
        
        var actionDuplicated = cmp.get('c.hasTaskDuplicate');
        
        actionDuplicated.setParams({
            'prodId': idProdotto,
            'catId' : idCategoria,
            'codiceCliente' : pratica.codCliente,
            'numeroPratica' : pratica.numPratica,
            'checkDuplicated' : cmp.get('v.runCheckDuplicated'),
            'recordId' : cmp.get('v.recordId')
        });
        
        console.log('idProdotto :::::> ' +idProdotto); 
        console.log('idCategoria :::::> ' +idCategoria); 
        console.log('codCliente :::::> ' +pratica.codCliente);
        console.log('numPratica :::::> ' +pratica.numPratica);
        
        actionDuplicated.setCallback(this,function(response){
            var state = response.getState();
            console.log('STATE CHECKIFDUPLICATED :::::> '+ state);
            if(state == 'SUCCESS'){
                var isTaskduplicated = response.getReturnValue();
                cmp.set('v.isTaskDuplicated' , isTaskduplicated);
                console.log('SONO NELLA CALLBACK DI CHECKIFDUPLICATED');
                console.log('CHECKIFDUPLICATED ::::> ' + isTaskduplicated);
                helper.checkEmettitore(cmp,idProdotto,idCategoria,emettitoreValue,prodottoValue,categoriaValue,isTaskduplicated,pratica,presaVisione,helper);
            }
        });
        $A.enqueueAction(actionDuplicated);
        
    },
    
    createTaskHelper : function (cmp,event,helper) {
        var toast = $A.get('e.force:showToast');
        cmp.set('v.isLoading', true);
        var presaVisione = cmp.find('presaVisione').get('v.value');
        var presaVisioneText = cmp.find('presaVisioneText').getElement();
        var pratica = cmp.get('v.pratica');
        var prodottiMdt = cmp.get('v.prodottiOptions');
        var categorieMdt = cmp.get('v.loadedCategorie');
        var configMdt = cmp.get('v.loadedConfig');
        var prodottoSelezionato = cmp.get('v.prodottoSelezionato');
        var categoriaSelezionata = cmp.get('v.categoriaSelezionata');
        
        var idProdotto,idCategoria,emettitoreValue,prodottoValue,categoriaValue,checkDuplicated;
        var isTaskduplicated = cmp.get('v.isTaskduplicated');
        var isEmettitoreOk;
        
        console.log('-------------INIZIO CHIAMATE-----------------');
        
        prodottiMdt.find(function(temp){
            if (temp.MasterLabel == prodottoSelezionato){
                cmp.set('v.idProdottoSelezionato', temp.idProdotto__c);
                cmp.set('v.labelProdottoSelezionato', temp.MasterLabel);
                emettitoreValue = temp.Emettitore_Carta__c;
                prodottoValue = temp.NotUniqueLabel__c;
                console.log('PRODOTTOVALUE ::::> ' + prodottoValue);
                console.log('EMETTITORE :::::> ' + temp.Emettitore_Carta__c);
                return idProdotto = temp.idProdotto__c;
            }
        });  
          
        categorieMdt.find(function(temp){
            if(temp.Label__c == categoriaSelezionata){
                cmp.set('v.idCategoriaSelezionata', temp.idAzione__c);
                cmp.set('v.labelCategoriaSelezionata', temp.Label__c);
                categoriaValue = temp.Label__c;
                console.log('CATEGORIAVALUE :::::> ' + categoriaValue);
                console.log('PRODOTTOVAULE :::::> ' + prodottoValue);
                return idCategoria = temp.idAzione__c;
            }
        });
        
        configMdt.find(function(temp){
            if(temp.idCategoria__c == idCategoria && temp.idProdotto__c == idProdotto){
                cmp.set('v.runCheckDuplicated', temp.check_duplicated__c); 
                return checkDuplicated = temp.check_duplicated__c;
            }
        }); 
        
        console.log('CHECK DUPLICATED :::::> ' + checkDuplicated);  
        
       /////////////////////////////////////////checkDuplicated = true perché bisogna sempre verificare se c'è la presenza di task uguali 
       // il parametro runCheckDuplicated invece stabilisce se la ricerca di task uguali debba essere svolta sul Case stesso associato al task (quindi check_duplicated = false)
       // oppure se la ricerca debba essere estesa a tutti gli altri case esistenti (check_duplicated = true)
        checkDuplicated = true;
        
        if ( emettitoreValue && pratica )  {
            if(checkDuplicated){
                helper.checkIfDuplicated(cmp,idProdotto,idCategoria,emettitoreValue,prodottoValue,categoriaValue,pratica,presaVisione,helper);
                isTaskduplicated = cmp.get('v.isTaskDuplicated');
                
            }
            else {
                isEmettitoreOk=false;
                helper.taskCreationChecking(cmp,idProdotto,idCategoria,emettitoreValue,prodottoValue,categoriaValue,isTaskduplicated,isEmettitoreOk,pratica,presaVisione);
            }
        }
        
        else{
            if ( !emettitoreValue && pratica ) {
                if(checkDuplicated){
                    helper.checkIfDuplicated(cmp,idProdotto,idCategoria,emettitoreValue,prodottoValue,categoriaValue,pratica,presaVisione,helper);
                    isTaskduplicated = cmp.get('v.isTaskDuplicated');
                } 
                else {
                    isEmettitoreOk=false;
                    helper.taskCreationChecking(cmp,idProdotto,idCategoria,emettitoreValue,prodottoValue,categoriaValue,isTaskduplicated,isEmettitoreOk,pratica,presaVisione);
                }
            }
            else {
                isEmettitoreOk=false;
                helper.taskCreationChecking(cmp,idProdotto,idCategoria,emettitoreValue,prodottoValue,categoriaValue,isTaskduplicated,isEmettitoreOk,pratica,presaVisione);
            }
        }
        
    },
    
    taskCreationChecking : function(cmp,idProdotto,idCategoria,emettitoreValue,prodottoValue,categoriaValue,isTaskduplicated,isEmettitoreOk,pratica,presaVisione) {
        var toast = $A.get('e.force:showToast');
        var presaVisione = cmp.find('presaVisione').get('v.value');
        var presaVisioneText = cmp.find('presaVisioneText').getElement();
        
        
        console.log('presaVisione ::::> ' + presaVisione);
        console.log('prodottoValue ::::> ' + prodottoValue);
        console.log('categoriaValue ::::> ' + categoriaValue);
        console.log('pratica ::::> ' + pratica);
        console.log('isTaskduplicated ::::> ' + isTaskduplicated);
        console.log('emettitoreValue ::::> ' + emettitoreValue);
        console.log('isEmettitoreOk ::::> ' + isEmettitoreOk);
     
        var prodottoList = prodottoValue.split("#");
        
        var prodottoIsOK = false;
        for (var i = 0 ; i < prodottoList.length ; i++)
        {
            console.log("LOOP: " + i);
            if(prodottoList[i] == pratica.tipoPratica)
            {
                prodottoIsOK = true;
            }
        }
        console.log("prodottoisOK :====>" + prodottoList + "////"  +prodottoIsOK);
        //  console.log('pratica.tipoPratica ::::> ' + pratica.tipoPratica);
        
        
        if(presaVisione && 
           prodottoValue && 
           categoriaValue && 
           pratica != null &&
           !isTaskduplicated &&
           ((emettitoreValue  && isEmettitoreOk ) || ( !emettitoreValue )) &&
           (prodottoIsOK || prodottoValue == 'Nessuna pratica azione sul cliente')) {
            console.log('prodottovalue = ' + prodottoValue);
            console.log('pratica.TipoPratica = ' + pratica.tipoPratica);
            console.log('isTaskduplicated dentro iF CHECKTASKCREATION ::::> ' + isTaskduplicated);
            
            console.log("CODICE CLIENTE::::::::::::::> " + pratica.codCliente);
            console.log('sono prima di aggiungi taskidProdottoSelezionato');
            if(cmp.get('v.labelProdottoSelezionato') == 'Nessuna pratica azione sul cliente')
                cmp.set('v.labelProdottoSelezionato',cmp.get('v.prodottoSelezionato'));
            var creazioneTask = cmp.get('c.aggiungiCaseFiglio');
            creazioneTask.setParams ({
                'caseId' : cmp.get('v.recordId'),
                'prodotto' : cmp.get('v.labelProdottoSelezionato'),
                'categoria' : cmp.get('v.labelCategoriaSelezionata'),
                'codiceCliente' : pratica.codCliente,
                'codicePratica' : pratica.numPratica, 
                'idCategoria' : cmp.get('v.idCategoriaSelezionata'),
                'idProdotto' : cmp.get('v.idProdottoSelezionato'),
                'clienteOcs'  :  cmp.get('v.clienteSelezionato')
            });
            console.log('sono prima di aggiungi task');
            $A.enqueueAction(creazioneTask);
            
            cmp.set('v.isLoading', false);
            cmp.set('v.isSelectionDisabled', true);
            cmp.set('v.isPrelavorazioneDisabled', true);
            // cmp.set('v.prodottoSelezionato', '');
            // cmp.set('v.categoriaSelezionata', '');
            // cmp.set('v.categoriaOptions', '');
            $A.get('e.force:refreshView').fire();
            
            toast.setParams({
                title: 'Operazione avvenuta con successo',
                type : 'success',
                message : ' '
            });
            toast.fire();
        } 
        
        else {
            console.log('prodottovalue = ' + prodottoValue);
            console.log('pratica.TipoPratica = ' + pratica);
            toast.setParams({
                title : !presaVisione ? 'Dichiara di aver letto il FAX prima di procedere' :
                !prodottoValue ? 'Selezionare un prodotto prima di procedere' :
                !categoriaValue ? 'Selezionare una categoria prima di procedere' :
                pratica == null ? 'Selezionare il cliente e la rispettiva pratica prima di procedere' :
                isTaskduplicated ? 'Già è presente un altro task con la stessa coppia prodotto/categoria' :
                (!prodottoIsOK) ? 'La tipologia della pratica non corrisponde con il prodotto selezionato' :
                !isEmettitoreOk ? 'Emettitore OCS e del prodotto selezionato non corrispondono' : 'Emettitore OCS e del prodotto selezionato non corrispondono' ,
                type : 'error',
                message : ' '
            });
            cmp.set('v.isLoading', false); 
            //  cmp.set('v.prodottoSelezionato', '');
            //  cmp.set('v.categoriaSelezionata', '');
            //  cmp.set('v.categoriaOptions', '');
            toast.fire();
            
            if(!presaVisione){
                
                
                
                
                
                $A.util.addClass(presaVisioneText, 'slds-text-color_error');
                $A.util.addClass(presaVisioneText, 'slds-text-heading_medium');
            }
        }
        
    },
    
    checkEmettitore : function (cmp,idProdotto,idCategoria,emettitoreValue,prodottoValue,categoriaValue,isTaskduplicated,pratica,presaVisione,helper) {
        
        var action = cmp.get('c.getEmettitore');
        var isEmettitoreOk;
        action.setParam( 'numPratica', (cmp.get('v.pratica').numPratica) );
        action.setCallback(this,function(response){
            var state = response.getState();
            if (state == 'SUCCESS'){
                var res = response.getReturnValue();
                console.log('EMETTITORE DA OCS :::::> ' + res);
                if(pratica){
                    if(pratica.tipoPratica == "CA"){
                        if(emettitoreValue){ 
                            if(helper.checkEmettitoreMulti(res,emettitoreValue)){
                                console.log('EMETTITORE OCS = A EMETTITORE PRODOTTO ');
                                console.log('emettitoreValue:::::> ' + emettitoreValue);
                                isEmettitoreOk=true;
                            }
                            else{
                                console.log('EMETTITORE OCS NON UGUALE A EMETTITORE PRODOTTO ');
                                isEmettitoreOk=false;
                            }
                        }
                    }
                    else
                    {
                            isEmettitoreOk=true;
                    }
                }
            }
            console.log('isTaskduplicated NEL CHECKEMETTITORE :::::> ' +isTaskduplicated);
            helper.taskCreationChecking(cmp,idProdotto,idCategoria,emettitoreValue,prodottoValue,categoriaValue,isTaskduplicated,isEmettitoreOk,pratica,presaVisione);
        });
        $A.enqueueAction(action);
    },
    
    checkEmettitoreMulti : function(res,emettitoriValue){
      	var isEmettitoreOk = false;
        var emettitoriValueList = emettitoriValue.split(";");
        for(var i = 0; i < emettitoriValueList.length; i++){
            if(res == emettitoriValueList[i]){
                isEmettitoreOk = true;
            }
        }
        return isEmettitoreOk;
    },
    
    getNotUniqueLabelForOCS : function(cmp){
        
    },

    closeTab : function(component){
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId
            var tabToClose = response.parentTabId ? response.parentTabId : response.tabId;
            workspaceAPI.closeTab({tabId: tabToClose});
        })
    }
    
})