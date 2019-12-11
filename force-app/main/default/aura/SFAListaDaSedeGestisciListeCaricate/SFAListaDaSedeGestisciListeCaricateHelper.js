({
    getListeCaricateList : function(component) {
        
        var action = component.get('c.getListeCaricate');
        action.setParams({
            "Limits": component.get('v.initRows'),
            "showOnly" : component.get('v.showOnly') 
        });
        action.setCallback(this, function(response) {          
            var state = response.getState();
            if (state === "SUCCESS" ) {
                /*var showToast = $A.get("e.force:showToast");
                showToast.setParams({
                    'title' : 'Load',
                    'message' : 'Opportunity Load Sucessfully.'
                });
                showToast.fire();*/
                var Opplist = response.getReturnValue();
                Opplist.forEach(function(entry) {
                    entry.Nome_Attivita=entry.Tipo_Attivita__r.Descrizione__c;
                    //entry.Chiuso__c = entry.Chiuso__c==true ? 'SI' : 'NO';
                });
                component.set("v.Opplist", Opplist);
                var nextlimit=component.get("v.initRows")+component.get('v.Count');
                component.set("v.initRows", nextlimit);
                
            }
        });
        $A.enqueueAction(action);
        
    },
    columnsandquickactions: function(component){

        var showOnly = component.get('v.showOnly');

        if(showOnly){

            component.set('v.columns', [
                /*{label:'Name',fieldName:'Name', type:'text',shortable:true},
                {label:'Account Name', fieldName:'AccountId', type:'Account Name',shortable:true},
                {label: 'Phone', fieldName: 'Phone', type: 'phone'},
                {label: 'Stage', fieldName:'StageName', type:'text'},
                {label: 'Close Date', fieldName:'CloseDate', type:'text'},*/
                {label: 'Ordine di visualizzazione', fieldName : 'Ordine_Visualizzazione__c', type: 'number'},
                {label: 'Nome Lista', fieldName : 'Nome_Lista__c', type: 'text'},
                {label: 'Data Visibilità', fieldName : 'Data_Visibilita__c', type: 'date'},
                {label: 'Tipo Attività', fieldName : 'Nome_Attivita', type: 'text'},
                {label: '# Caricati', fieldName : 'Numero_Righe__c', type: 'number', cellAttributes: { alignment: 'left' }},
                {label: 'Data Caricamento', fieldName : 'Data_Caricamento__c', type: 'date', typeAttributes:{
                    year: "numeric",
                    month: "long",
                    day: "2-digit",
                    hour: "2-digit",
                    minute: "2-digit"
                }},
                //{label: 'Chiusa', fieldName : 'Chiuso__c', type: 'boolean', editable: true},
            ]);
        }else{

            component.set('v.columns', [
                /*{label:'Name',fieldName:'Name', type:'text',shortable:true},
                {label:'Account Name', fieldName:'AccountId', type:'Account Name',shortable:true},
                {label: 'Phone', fieldName: 'Phone', type: 'phone'},
                {label: 'Stage', fieldName:'StageName', type:'text'},
                {label: 'Close Date', fieldName:'CloseDate', type:'text'},*/
                {label: 'Ordine di visualizzazione', fieldName : 'Ordine_Visualizzazione__c', type: 'number', editable: true},
                {label: 'Nome Lista', fieldName : 'Nome_Lista__c', type: 'text'},
                {label: 'Data Visibilità', fieldName : 'Data_Visibilita__c', type: 'date', editable: true},
                {label: 'Tipo Attività', fieldName : 'Nome_Attivita', type: 'text'},
                {label: '# Caricati', fieldName : 'Numero_Righe__c', type: 'number', cellAttributes: { alignment: 'left' }},
                {label: 'Data Caricamento', fieldName : 'Data_Caricamento__c', type: 'date', typeAttributes:{
                    year: "numeric",
                    month: "long",
                    day: "2-digit",
                    hour: "2-digit",
                    minute: "2-digit"
                }},
                {label: 'Chiusa', fieldName : 'Chiuso__c', type: 'boolean', editable: true},
            ]);
        }
    },
   totalListeCaricate : function(component) {
        var action = component.get('c.totalListeCaricate');
        action.setParams({
           "showOnly" : component.get('v.showOnly') 
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" ) {
                var resultData = response.getReturnValue();
                component.set('v.totalResult', resultData);
            }
        });
        $A.enqueueAction(action);
    },
    saveEdition :   function(component, draftValues, showError) {
        if(draftValues.length!=1){
            if(showError==true) {
              	component.set("v.toastMsg", "ERRORE: E\' possibile modificare solo una lista alla volta");
            	this.showToastError(component);
            	component.set('v.draftValues', []);   
            } 
            return;
        }

        var resultData = component.get('v.Opplist');
        var ordineVisual=1;
        for (var i = 0; i < draftValues.length;i++) { 
            if(draftValues[i].Chiuso__c!=null && draftValues[i].Chiuso__c==true) {
                draftValues[i].Ordine_Visualizzazione__c=999;
                debugger;
                //close all related case
                this.closeAllCase(component,draftValues);
            }
            else if(draftValues[i].Chiuso__c!=null && draftValues[i].Chiuso__c==false) {
                draftValues[i].Ordine_Visualizzazione__c=ordineVisual++;
            }
        }
        for (var i = 0; i < draftValues.length;i++) {
    		if(draftValues[i].Chiuso__c!=null) continue; 
            for (var j = 0; j < resultData.length; j++){
                if(resultData[j].Id==draftValues[i].Id && draftValues[i].Data_Visibilita__c!=null) {
                    draftValues[i].Ordine_Visualizzazione__c=resultData[j].Ordine_Visualizzazione__c;
                    break;
                }
            }
        }
        var newList=[];
        draftValues.forEach(function(item, index, array) {
            if(item.Ordine_Visualizzazione__c!=null && newList[item.Ordine_Visualizzazione__c-1]!=null) {
                if(showError==true) {
                    component.set("v.toastMsg", "Errore ordine di visualizzazione errato");
                    this.showToastError(component);
                    component.set('v.draftValues', []);
                }
                return;
            }
            else {
                if(item.Ordine_Visualizzazione__c!=null && parseInt(item.Ordine_Visualizzazione__c)!=999) 
                	newList[item.Ordine_Visualizzazione__c-1] = item;
                else {
                    if(newList[999]==null) newList[999]= item;
                    else {
                    	newList.push(item);
                    }
                }
            }
        });
        var j=0;
        debugger;
        for (var i = 0; i < resultData.length;) { 
            if(newList[j]!=null) { j++; }
            var trovato=false;
            try {
                draftValues.forEach(function(item, index, array) {
                    if(resultData[i].Id==item.Id) {
                        trovato=true;
                        i++;
                        throw "Exception";
                    }
                });
            } catch (e) {
                console.log(e);
            }
            if(!trovato) {
                if(resultData[i].Ordine_Visualizzazione__c!=999)
                	resultData[i].Ordine_Visualizzazione__c=j+1;
                newList[j++]=resultData[i++];
            }
        }
        // da sistemare se si modifica la data visibilita
        //ricalcolo degli indici dell'array
        var newList2 = newList.filter(function (item) { return item != undefined });
        var action = component.get('c.updateListeCaricate');
        action.setParams({
            "Liste": newList2
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" ) {
                //second-call
                this.closeAllCase(component,draftValues);

                for(var i=0;i<newList2.length;i++) {
                    for(var j=0;j<resultData.length;j++) {
                        if(newList2[i].Id == resultData[j].Id) {
                            if(newList2[i].Ordine_Visualizzazione__c!=null)
                            	resultData[j].Ordine_Visualizzazione__c = parseInt(newList2[i].Ordine_Visualizzazione__c);
                            if(newList2[i].Data_Visibilita__c!=null)
                            	resultData[j].Data_Visibilita__c = newList2[i].Data_Visibilita__c;
                            if(newList2[i].Chiuso__c!=null)
                            	resultData[j].Chiuso__c = newList2[i].Chiuso__c;
                            break;
                        }
                    }
                }
                resultData.sort( function ( a, b ){
                      if ( a.Ordine_Visualizzazione__c < b.Ordine_Visualizzazione__c ){
                        return -1;
                      }
                      if ( a.Ordine_Visualizzazione__c > b.Ordine_Visualizzazione__c ){
                        return 1;
                      }
                      return 0;
                });
                if(showError==true) {
                    component.set("v.toastMsg", "Modifica alla Lista effettuata con successo!");
                    this.showToastSuccess(component);
                }
                component.set('v.Opplist', resultData); 
                component.set('v.draftValues', []); 
            }
        });
        $A.enqueueAction(action);

    },

    closeAllCase : function(component,draftValues){

        debugger;

        var action = component.get('c.closeAllRelatedCase');
        action.setParams({
            draftValues : draftValues
        });

        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var x = response.getReturnValue();
                console.log('@@@ call batch: '+x);
                debugger;
            }
        }));
        $A.enqueueAction(action);

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
    
    showToastWarning: function(component) {
        component.find('notifLib').showToast({
            "title": "Warning",
            "message": component.get("v.toastMsg"),
            "variant": "warning"
        });
    }
})