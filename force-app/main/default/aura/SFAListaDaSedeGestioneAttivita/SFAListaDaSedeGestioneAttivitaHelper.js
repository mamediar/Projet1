({
    doInit : function(component, event, helper) {
        
        //all'init vengono prelevate tutte le attività con ListaDaSedeActive__c = true 
        //per mostrare i valori nella picklist Tipo Di Attività
        
        var action = component.get('c.getCategoryList');  
        
        var categoryObject = [];
        
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                var categoryList = response.getReturnValue();
                console.log('@@@ catList: '+categoryList.length);
                if(categoryList.length>0){
                    
                    component.set('v.categoryList',categoryList);
                    
                    for(var i=0; i<categoryList.length; i++){
                        var item = {
                            //"label": categoryList[i].Name,
                            "label": categoryList[i].Descrizione__c,
                            //"value": categoryList[i].Id,
                            //"label": categoryList[i].XCS_Attivita__c != null ? XCS_Attivita__r.Name : null,
                            //"label": categoryList[i].XCS_Attivita__r.Name,
                            //"value": categoryList[i].XCS_Attivita__c
                            //"value": categoryList[i].SFA_TipologiaLista__c
                            //"value": categoryList[i].Codice_Attivita_Lista_da_Sede__c
                            "value": categoryList[i].Id

                        };
                        categoryObject.push(item);
                    }
                    
                    component.set('v.categoryOptions', categoryObject);
                }
                this.hideSpinner(component);
            }
            
        }));
        
        $A.enqueueAction(action);
    },

    getDispositionsLevel1 : function(component, event, helper) {

        var action = component.get('c.getDispositionLevel1');

        var level1Object = [];

        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                var level1List = response.getReturnValue();
                console.log('@@@ catList: '+level1List.length);
                if(level1List.length>0){
                    
                    component.set('v.level1OptionsList',level1List);
                    for(var i=0; i<level1List.length; i++){
                        var item = {
                            "label": level1List[i].Name,
                            "value": level1List[i].Id
                        };
                        level1Object.push(item);
                    }

                    component.set('v.level1Options', level1Object);
                }
            }
        }));

        $A.enqueueAction(action);


    },

    getDispositionsList : function(component, event, helper) {
        
        //1. selezionando il Livello 1 (positivo - negativo - sospeso) da UI verranno mostrate 
        //   tutte le disposition attive (ListaDaSedeActive__c = true) relative 
        //2. selezionando il tipo di attività da UI verranno mostrati tutti gli esiti corrispondenti
        
        var action = component.get('c.getDispositionList');  
        var dispositionObject = [];

        component.set('v.dispositionName','');
        
        var blank = '';
        var cat = component.find("categoryType").get("v.value") != null ? component.find("categoryType").get("v.value") : null;

        var flevel = this.isBlank(component.find("level1").get("v.value")) != null ? component.find("level1").get("v.value") : null;
        
        var change = event.getSource().get("v.name");
        console.log('---------'+change);
        
        if(change === 'categoryType'){
            this.resetForm(component, event, helper);
            this.loadSpinner(component);
            component.set('v.newActivityId',cat);
        }else if(change === 'level1'){
            this.getNameLevel1(component, event, helper);
        }
		this.setSelected(component, event, helper);
        
        
        action.setParams({
            firstLevel : flevel
        }); 
        
        console.log('LV1: '+flevel);
        console.log('categoryType: '+cat);
        
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                var dispositionList = response.getReturnValue();
                console.log('@@@ dispList: '+dispositionList.length);
                if(dispositionList.length>0){
                    
                    component.set('v.dispositionList',dispositionList);
                    
                    for(var i=0; i<dispositionList.length; i++){
                        var item = {
                            "label": dispositionList[i].Name,
                            "value": dispositionList[i].Id,
                        };
                        dispositionObject.push(item);
                    }
                    component.set('v.dispositionOptions', dispositionObject);
                }
                else{
                    component.set('v.dispositionOptions', []);
                }
                if(change === 'categoryType'){
                    this.getAllRecordCreated(component, event, helper);
                    this.hideSpinner(component);
                }

                this.getCategory(component, event, helper);
            }
        }));
        $A.enqueueAction(action);
    },
    
    setSelected : function(component, event, helper){
        var cat = component.find("categoryType").get("v.value") != null ? component.find("categoryType").get("v.value") : component.find("newActivity").get("v.value") != null ? component.find("newActivity").get("v.value") : null;
        var dis = component.find("dispositionType").get("v.value") != null ? component.find("dispositionType").get("v.value") : null;
        component.set('v.categorySelected',cat);
        component.set('v.dispositionSelected',dis);
    },

    setSelectedEsito: function(component, event, helper) {
        //var numberEditedRecords = component.find("table").get("v.selectedRows");
        var editedRecords = component.find("table").getSelectedRows();
    
        if (editedRecords.length == 1) {
            component.set("v.esitoSelectedLv1",editedRecords[0].parentName);
            component.set("v.esitoSelectedLv2",editedRecords[0].dispName);
        }else if (editedRecords.length == 0 || editedRecords.length > 1) {
            component.set("v.esitoSelectedLv1",'');
            component.set("v.esitoSelectedLv2",'');
        }
    },

    resetForm : function(component, event, helper){
        component.find("level1").set("v.value",null);
        component.find("dispositionType").set("v.value",null);
        component.set('v.allRecordInsered',[]);
        component.set('v.outputActivityTmp',[]);
    },

    resetAllValue : function(component, event, helper){
        component.find("categoryType").set("v.value",null);
        component.find("level1").set("v.value",null);
        component.find("dispositionType").set("v.value",null);
        component.find("newActivity").set("v.value",null);
        component.set('v.categorySelected',null);
        component.set('v.dispositionSelected',null);
        component.set('v.outputActivityTmp',[]);
        component.set('v.newActivityId',null);
    },
    
    setHeaderColumns: function(component, event, helper) {
        
        component.set("v.headerColumns", [
            {label: 'Livello 1', fieldName: 'parentName', type: 'text'},
            {label: 'Livello 2', fieldName: 'dispName', type: 'text'},
            {label: 'Categoria', fieldName: 'catName', type: 'text'}            
        ]);
    },
    
    isBlank : function(x){
        
        if(x === '' || x === null || x === undefined){
            return true;
        }else{
            return false;
        }
        
    },
    /*
    insertRecord : function(component, event, helper){
        
        //funzionalità richiamata premendo il tasto Aggiungi Esito da UI, che permette di inserire un esito se:
        //1. vengono compilate le tre picklist: tipo attività - livello1 - livello2
        //2. non esiste un record dello stesso tipo a parità di (tipo attività - livello1 - livello2)  
        
        var action = component.get('c.createGestisciAttivita');
        
        var categoryId = component.find("categoryType").get("v.value");
        var dispositionId = component.find("dispositionType").get("v.value");
        var level = component.find("level1").get("v.value");
        
        if(this.isBlank(dispositionId) || this.isBlank(level)){
            component.set("v.toastMsg", "Compilare tutti i campi obbligatori, contrassegnati con l'asterisco(*)");
            this.showToastError(component);
        }else{
            
            var outputList = component.get('v.outputActivityList');
            
            console.log('categoryId: '+categoryId);
            console.log('dispositionId: '+dispositionId);
            
            this.setSelected(component, event, helper);
            
            action.setParams({
                categoryId : categoryId,
                dispositionId : dispositionId
            });
            
            action.setCallback(this, $A.getCallback(function (response) {
                var state = response.getState();
                
                if (state === "SUCCESS") {
                    var activity = response.getReturnValue();
                    if(activity.length > 0){
                        console.log('creato');
                        this.getAllRecordCreated(component, event, helper); 
                    }
                    else{
                        console.log('esito gia esistente');
                        component.set("v.toastMsg", "Questo tipo di esito è già presente");
                        this.showToastError(component);
                    }
                }
                
            }));
            
            $A.enqueueAction(action);
        }
    },*/

    insertRecordToList : function(component, event, helper){

        //funzionalità richiamata premendo il tasto Aggiungi Esito da UI, che permette di inserire un esito (a video, non  a DB) se:
        //1. vengono compilate le tre picklist: tipo attività - livello1 - livello2
        //2. non esiste un record dello stesso tipo a parità di (tipo attività - livello1 - livello2)  
        
        var action = component.get('c.createGestisciAttivita');
        
        var categoryId = component.find("categoryType").get("v.value");
        var dispositionId = component.find("dispositionType").get("v.value");
        var levelId = component.find("level1").get("v.value");
        
        component.set('v.newActivityInsered',false);

        if(levelId==null){
            component.set("v.toastMsg", "Compilare tutti i campi obbligatori, contrassegnati con l'asterisco(*)");
            this.showToastError(component);
        }
        else{
            
            var outputList = component.get('v.outputActivityList');
            var outputActivityTmp = component.get('v.outputActivityTmp');
            var pushEnabled = outputList != null ? true : false
            
            var newActivity = component.find("newActivity").get("v.value");

            if(!pushEnabled && this.isBlank(newActivity)){
                component.set("v.toastMsg", "Selezionare/Creare un tipo di attività a cui assegnare un esito");
                this.showToastError(component);
            }else{

                console.log('categoryId: '+categoryId);
                console.log('dispositionId: '+dispositionId);
                this.setSelected(component, event, helper);

                var recordInsered = component.get('v.allRecordInsered');
                var levelName = component.get('v.levelName');
                var dispositionName = component.get('v.dispositionName');
                var categoryName = component.get('v.categoryName');
                
                //controllo se esiste gia un esito
                var isInsert = true;
               
                if(recordInsered.length > 0){

                    for(var i=0; i<recordInsered.length; i++){
                        var str = dispositionName.replace(/\s/g,'');
                        if(recordInsered[i] === levelName+str){
                            isInsert = false;
                        }
                    }
                    if(isInsert){
                        recordInsered.push(levelName+str);
                        component.set('v.allRecordInsered',recordInsered);
                    }

                }else{
                    var str = dispositionName.replace(/\s/g,'');
                    component.set('v.allRecordInsered',levelName+str);
                }
                
                //se non esiste lo inserisco nella tabella, non a DB
                if(isInsert){
                
                    action.setParams({
                        categoryId : categoryId,
                        levelId : levelId,
                        dispositionId : dispositionId,

                    });
                    
                    action.setCallback(this, $A.getCallback(function (response) {
                        var state = response.getState();
                        
                        if (state === "SUCCESS") {
                            
                            var activity = response.getReturnValue();
                            
                            if(activity && pushEnabled){
                                
                                var obj = {
                                    parentName: levelName,
                                    dispName : dispositionName,
                                    catName : categoryName,
                                    catId : categoryId,
                                    levId : levelId,
                                    disId : dispositionId,
                                    Id : ''
                                }
                                outputActivityTmp.push(obj);
                                outputList.push(obj);
                                component.set('v.outputActivityList',outputList);
                                component.set('v.outputActivityTmp',outputActivityTmp);
                                component.set("v.toastMsg", "Esito aggiunto correttamente");
                                this.showToastSuccess(component);
                                
                            }else if (activity && !pushEnabled){
                                var arr = [];
                                var obj = {
                                    parentName: levelName,
                                    dispName :  dispositionName,
                                    catName : categoryName,
                                    catId : categoryId,
                                    levId : levelId,
                                    disId : dispositionId,
                                    Id : ''
                                }
                                arr.push(obj);
                                component.set('v.outputActivityList',arr);
                                component.set('v.outputActivityTmp',arr);
                                component.set("v.toastMsg", "Esito aggiunto correttamente");
                                this.showToastSuccess(component);

                            }
                            else if(!activity){
                                console.log('esito gia esistente');
                                component.set("v.toastMsg", "Questo tipo di esito è già presente");
                                this.showToastError(component);

                            }
                            
                        }
                        
                        
                    }));
                    
                    $A.enqueueAction(action);
                
                }
                else{
                    console.log('esito gia esistente');
                    component.set("v.toastMsg", "Questo tipo di esito è già presente");
                    //component.set('v.outputActivityTmp',[]);
                    this.showToastError(component);
                }
            }
        }
    },

    insertUpdate : function(component, event, helper){
        
        //funzionalità richiamata premendo il tasto Inserisci/Modifica da UI dove:
        //1. bisogna selezionare almeno un record della lista degli esiti
        //2. si procede all'inserimento dei record selezionati a DB
        
        //var numberEditedRecords =  component.find("table").get("v.selectedRows");
        //var editedRecords =  component.find("table").getSelectedRows();
        //var action = component.get('c.insertRecord');
        
        var categoryId = component.find("categoryType").get("v.value");
        var newActivity = component.find("newActivity").get("v.value");
        
        var categoryEmpty = (this.isBlank(categoryId) && this.isBlank(newActivity)) ? true : false;
        //if(numberEditedRecords.length > 0){

            if(!categoryEmpty){

                //inserimento nuova attività in XCS_Categoria__c nel caso in cui non ne venga selezionata una pre-esistente 
                if(this.isBlank(categoryId) && !this.isBlank(newActivity)){
                    this.insertNewActivity(component, event, helper);
                }else{
                    this.insertNewRecord(component, event, helper,categoryId);
                    component.set("v.categorySelected",categoryId);
                }

                //action.setParams({
                //    recordToInsert : editedRecords
                //});
                //
                //action.setCallback(this, $A.getCallback(function (response) {
                //    var state = response.getState();
                //    
                //    if (state === "SUCCESS") {
                //        var activity = response.getReturnValue();
                //        
                //        if(activity){
                //            console.log('inserimento');
                //            this.getAllRecordCreated(component, event, helper);
                //            this.doInit(component, event, helper);
                //            component.find("categoryType").set("v.value",component.get('v.newActivityId'));
                //            component.set("v.toastMsg", "Inserimento avvenuto con successo");
                //            this.showToastSuccess(component);
                //        }
                //    }
                //}));
                //
                //$A.enqueueAction(action); 

            }else{
                component.set("v.toastMsg", "Selezionare/Creare un tipo di attività prima di inserire un esito");
                this.showToastError(component);
            }                   
                    
        //}else{
        //    component.set("v.toastMsg", "Selezionare almeno un esito da inserire");
        //    this.showToastError(component);
        //}

    },

    insertNewActivity : function(component, event, helper){

        //funzionalità che permette di inserire una nuova attività in XCS_Categoria__c
        var action = component.get('c.insertCategory');
        var newActivity = component.find("newActivity").get("v.value");
        var dispositionId = component.find("dispositionType").get("v.value");
        
        action.setParams({
            categoryName : newActivity,
            dispositionId : dispositionId
        });

        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var activity = response.getReturnValue();
                
                if(activity!=null){
                    console.log('categoria inserita');
                    component.set('v.newActivityId',activity);
                    component.set('v.newActivityInsered',true);
                    this.insertNewRecord(component, event, helper, activity);
                }else{
                    component.set("v.toastMsg", "Una attività con questo nome è già presente nel sistema");
                    this.showToastError(component);
                }

            }

        }));

        $A.enqueueAction(action);

    },
    insertNewRecord : function(component, event, helper, activityId){

        //funzionalità  richiamata premendo il tasto Inserisci/Modifica da UI che permette di inserire
        //uno o più record in XCS_dealers_conv_activity_disp__c

        var action = component.get('c.insertRecord');
        var option = activityId != null ? component.get('v.newActivityId') : component.find("categoryType").get("v.value");
        //var editedRecords =  component.find("table").getSelectedRows();
        //var outputList = component.get('v.outputActivityList');
        var outputList = component.get('v.outputActivityTmp');
        

        action.setParams({
            //recordToInsert : editedRecords,
            recordToInsert : outputList,
            idActivity : activityId
        });
        
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var activity = response.getReturnValue();
                
                if(activity){
                    console.log('inserimento');
                    //this.getAllRecordCreated(component, event, helper);
                    component.find("newActivity").set("v.value",null);
                    component.find("categoryType").set("v.value",option);
                    component.set('v.categorySelected',activityId);
                    component.set('v.newActivityId',activityId);
                    //component.set('v.categorySelected',component.find("categoryType").get("v.value"));
                    component.find("level1").set("v.value",null);
                    component.find("dispositionType").set("v.value",null);
                    component.set('v.outputActivityTmp',[]);
                    //this.getDispositionsList(component, event, helper);
                    this.getAllRecordCreated(component, event, helper);
                    //component.set('v.outputActivityTmp',[]);
                    //component.set('v.outputActivityList',activity);
                    component.set("v.toastMsg", "Inserimento avvenuto con successo");
                    this.showToastSuccess(component);
                    this.doInit(component, event, helper);
                }
            }
        }));
        
        $A.enqueueAction(action);

    },

    removeRecord : function(component, event, helper){
        
        //funzionalità richiamata premendo il tasto Elimina Esito da UI dove:
        //1. bisogna selezionare almeno un record della lista degli esiti
        //2. si procede all'eliminazione dei record selezionati a DB
        
        var editedRecords =  component.find("table").getSelectedRows();

        var inseredforcheck = component.get('v.allRecordInsered');
        var insered = component.get('v.outputActivityTmp');

        var action = component.get('c.removeActivity');

        var newActivity = component.get('v.newActivityInsered');
        if(newActivity){
            this.getDispositionsList(component, event, helper);
            //component.set('v.outputActivityTmp',[]);
            //component.set('v.allRecordInsered',[]);
        }


        var newActivityCreated = this.isBlank(component.find("newActivity").get("v.value")) ? false : true;
        if(newActivityCreated){


            if(inseredforcheck.length>0){
                for(var i = 0; i<editedRecords.length; i++){
                    var element = editedRecords[i].parentName + editedRecords[i].dispName.replace(/\s/g,'');
                    for(var j = 0; j<inseredforcheck.length; j++){
                        if(inseredforcheck[j] === element){
                            inseredforcheck[j] = '';
                        }
                    }
                }
                component.set('v.allRecordInsered',inseredforcheck);
            }


            if(insered.length>0){
                for(var i = 0; i<editedRecords.length; i++){
                    var element = editedRecords[i].parentName + editedRecords[i].dispName.replace(/\s/g,'');
                    for(var j = 0; j<insered.length; j++){
                        if(insered[j].parentName+insered[j].dispName.replace(/\s/g,'') === element){
                            insered.splice(j,1);
                        }
                    }
                }
                component.set('v.outputActivityList',insered);
            }
            //component.find('table').set('v.selectedRows',[]);

        }else{

            //var inseredforcheck = component.get('v.allRecordInsered');
            //var insered = component.get('v.outputActivityTmp');

            if(editedRecords.length > 0){

                action.setParams({
                    recordToDelete : editedRecords
                });
                
                action.setCallback(this, $A.getCallback(function (response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        var activity = response.getReturnValue();
                        if(activity){
                            console.log('eleiminato');
                            this.getAllRecordCreated(component, event, helper);
                            component.set("v.toastMsg", "Eliminazione avvenuta con successo");
                            this.showToastSuccess(component);   
                            
                            if(inseredforcheck.length>0){
                                for(var i = 0; i<editedRecords.length; i++){
                                    var element = editedRecords[i].parentName + editedRecords[i].dispName.replace(/\s/g,'');
                                    for(var j = 0; j<inseredforcheck.length; j++){
                                        if(inseredforcheck[j] === element){
                                            inseredforcheck[j] = '';
                                        }
                                    }
                                }
                                component.set('v.allRecordInsered',inseredforcheck);
                            }

                            if(insered.length>0){
                                for(var i = 0; i<editedRecords.length; i++){
                                    var element = editedRecords[i].parentName + editedRecords[i].dispName.replace(/\s/g,'');
                                    for(var j = 0; j<insered.length; j++){
                                        if(insered[j].parentName+insered[j].dispName.replace(/\s/g,'') === element){
                                            insered.splice(j,1);
                                        }
                                    }
                                }
                                component.set('v.outputActivityTmp',insered);
                            }
                            component.find('table').set('v.selectedRows',[]);
                            /*FIX 0001597*/
                            component.set("v.esitoSelectedLv1",'');
            				component.set("v.esitoSelectedLv2",'');
                            /*END FIX 0001597*/
                            //this.getAllRecordCreated(component, event, helper);
                            /*
                            if(insered.length>0 && inseredforcheck>0){

                                for(var i=0; i<insered.length; i++){
                                    var level = insered[i].parentName;
                                    var str = insered[i].dispName.replace(/\s/g,'');
                                    inseredforcheck[i] = level+str;
                                }
                                component.set('v.allRecordInsered',inseredforcheck);
                            }*/

                        }
                        this.hideSpinner(component);
                    }
                }));
                
                $A.enqueueAction(action);                    
                        
            }else{
                component.set("v.toastMsg", "Selezionare almeno un esito da eliminare");
                this.showToastError(component);
            }
            /*
            */

        }

    },
    
    getAllRecordCreated : function(component, event, helper){
        
        //funzionalità utilizzata per mostrare la lista esistente/aggiornata degli esiti a video:
        //1. dopo aver selezionato almeno una attività
        //2. dopo aver inserito un esito
        //3. dopo aver eliminato un esito
        
        //var picklistvalue = component.find("categoryType").get("v.value");
        //var categoryId = this.isBlank(picklistvalue) ? component.get('v.newActivityId') : picklistvalue;
        
        var categoryId = component.get('v.newActivityId');
    	var dispositionId = component.get('v.dispositionSelected');
        
        var visibleRecord = component.get('v.outputActivityTmp');

        //var removeAction = event.getSource().get("v.name");
        var removeAction = event.getSource().getLocalId();
        var actionRemove =  removeAction === 'buttonRemove' ? true : false;

        var action = component.get('c.getGestisciAttivita');
        
        action.setParams({
            categoryId : categoryId,
            dispositionId : dispositionId
        });
        this.loadSpinner(component);
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
            	var activity = response.getReturnValue();
                
                if(activity.length > 0){
                    var arr = [];
                    for(var i = 0; i<activity.length; i++){
                        var obj = {
                            //parentName: activity[i].XCS_Disposition__r.Parent__r.Name,
                            //dispName : activity[i].XCS_Disposition__r.Name,
                            parentName: activity[i].Esito_1__r.Name,
                            dispName : activity[i].Esito_2__c != null ? activity[i].Esito_2__r.Name : '',
                            //catName : activity[i].SFA_TipologiaLista__r.Name,
                            //catName : activity[i].Codice_Attivita_Lista_da_Sede__r.Name,
                            catName : activity[i].Codice_Attivita_Lista_da_Sede__r.Descrizione__c != null ? activity[i].Codice_Attivita_Lista_da_Sede__r.Descrizione__c : '',
                            Id : activity[i].Id
                        }
                        arr.push(obj);
                    }

                    //component.set('v.outputActivityList',arr);
                    //component.set("v.categorySelected",categoryId);
                    if(actionRemove && visibleRecord.length>0){
                        
                        var valueToConcat = [];

                        for(var j = 0; j<visibleRecord.length; j++){
                            var level =  visibleRecord[j].parentName;
                            var str = visibleRecord[j].dispName != null ? visibleRecord[j].dispName.replace(/\s/g,'') : '';
                            var recordInsered = level+str;

                            for(var i = 0; i<activity.length; i++){
                                //var level =  activity[i].XCS_Disposition__r.Parent__r.Name;
                                var level =  activity[i].Esito_1__r.Name;
                                //var str = activity[i].XCS_Disposition__r.Name.replace(/\s/g,'');
                                var str = activity[i].Esito_2__c != null ? activity[i].Esito_2__r.Name.replace(/\s/g,'') : '';
                                var recordDB = level+str;

                                if(recordDB === recordInsered){
                                    break;
                                }else if(!valueToConcat.includes(visibleRecord[j])){
                                    valueToConcat.push(visibleRecord[j]);
                                }
                            }
                        }

                        if(valueToConcat.length>0){
                            var concatArray = [];
                            concatArray = arr.concat(valueToConcat);
                            component.set('v.outputActivityList',concatArray);
                            //component.set('v.outputActivityTmp',[]);
                        }else{
                            component.set('v.outputActivityList',arr);
                        }

                    }else{
                        component.set('v.outputActivityList',arr);
                    }
                    /*
                    if(visibleRecord.length>0){
                        var concatArray = [];
                        concatArray = arr.concat(visibleRecord);
                        component.set('v.outputActivityList',concatArray);
                    }else{
                        component.set('v.outputActivityList',arr);
                    }*/
                    
                }else{
                    //component.set('v.outputActivityList',[]);
                    if(visibleRecord.length > 0){
                        component.set('v.outputActivityList',visibleRecord);
                    }else{
                        component.set('v.outputActivityList',[]);
                    }
                }
                this.hideSpinner(component);
            }
            
        }));
        $A.enqueueAction(action);
        
    },

    getCategory : function(component, event, helper){

        var action = component.get('c.getCategoryName');
        var categoryId = component.find("categoryType").get("v.value");
        
        if(categoryId != null){

            action.setParams({
                categoryId : categoryId
            });
            
            action.setCallback(this, $A.getCallback(function (response) {
                var state = response.getState();
                
                if (state === "SUCCESS") {
                    var categoryName = response.getReturnValue();
                    if(!this.isBlank(categoryName)){
                        console.log('CATEGORY_NAME: '+categoryName);
                        component.set('v.categoryName',categoryName);
                    }
                }
            }));
            $A.enqueueAction(action);
        }
        else{
            //prendi nuova attività
            var newActivity = component.find("newActivity").get("v.value");
            console.log('ACTIVITY_NAME: '+newActivity);
            //return component.get('v.newActivity');
            component.set('v.categoryName',newActivity);
        }

    },
    getNameLevel1 : function(component, event, helper){

        var action = component.get('c.getLevel1Name');
        var levelId = component.find("level1").get("v.value");

        action.setParams({
            levelId : levelId
        });
        
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var levelName = response.getReturnValue();
                if(!this.isBlank(levelName)){
                    console.log('LEVEL_NAME: '+levelName);
                    component.set('v.levelName',levelName);
                }
            }
        }));
        $A.enqueueAction(action);        

    },
    getDisposition : function(component, event, helper){

        var action = component.get('c.getDispositionName');
        var dispositionId = component.find("dispositionType").get("v.value");
        var level = component.find("level1").get("v.value");

        action.setParams({
            dispositionId : dispositionId
        });
        
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var dispositionName = response.getReturnValue();
                if(!this.isBlank(dispositionName)){
                    console.log('DISPOSITION_NAME: '+dispositionName);
                    component.set('v.dispositionName',dispositionName);
                }
            }
        }));
        $A.enqueueAction(action);
    },
    
    loadSpinner : function(component, event, helper) {
        console.log('showSpinner');
        component.set("v.showSpinner", true);
    },
    
    hideSpinner : function(component, event, helper) {
        component.set("v.showSpinner", false);
        console.log('hideSpinner');
    }, 
    
    showToastSuccess: function(component) {
        component.find('notifLib').showToast({
            "title": "Success",
            "message": component.get("v.toastMsg"),
            "variant": "success"
        });
    },
    
    showToastError: function(component) {
        component.find('notifLib').showToast({
            "title": "Error",
            "message": component.get("v.toastMsg"),
            "variant": "error"
        });
    },    
    
})