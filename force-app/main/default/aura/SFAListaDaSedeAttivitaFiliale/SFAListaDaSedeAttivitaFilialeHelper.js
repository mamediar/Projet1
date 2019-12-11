({
    doInit : function(component, event, helper) {
        
		var action = component.get('c.getCaseList'); 
        
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                //var totalCase = this.getTotal(caseList[i].Id);
                //var daEsitare = this.getDaEsitare(caseList[i].Id);
                //var sospesiDaEsitare = this.getSospesiDaEsitare(caseList[i].Id);
                
                var caseList = response.getReturnValue();
                console.log('@@@ caseList: '+caseList.length);
                
                if(caseList.length>0){

                    //var filiale = this.getfiliale(caseList[i].OwnerId);
                    
                    var arr = [];
                    for(var i = 0; i<caseList.length; i++){
                        var obj = {
                            Id : caseList[i].Id,
                            //number : caseList[i].CaseNumber, 
                            //caseName : caseList[i].SFA_ListeCaricate__r.Name + caseList[i].SFA_ListeCaricate__r.SFA_TipologiaLista__r.Name,
                            caseName : 'NOME LISTA',
                            //filiale : filiale != null ? filiale : '',
                            filiale : caseList[i].Owner.Name,
                            //accName : caseList[i].AccountId != null ? caseList[i].Account.Name : null,
                            tipoLista : caseList[i].SFA_ListeCaricate__c != null ? caseList[i].SFA_ListeCaricate__r.Nome_Lista__c : null,
                            //data : caseList[i].Data_Visibilita__c,
                            totale : caseList[i].Totale__c,
                            daEsitare : caseList[i].Da_Esitare__c,
                            sospesiDaEsitare : caseList[i].Sospesi_Da_Esitare__c,
                            catId : caseList[i].Categoria_Riferimento__c
                            //daConvenzionare : caseList[i].Da_convenzionare__c,
                            //accolli : caseList[i].Accolli_da_gestire__c,
                        }
                        arr.push(obj);
                        
                    }
                    component.set('v.caseList',arr);
                    
                }
            }
            
        }));
        
        $A.enqueueAction(action);
    },
    
    getfiliale : function(caseownerId) {

        var action = component.get('c.getfilialeFromOwnerId');
        action.setParams({
            ownerId : caseownerId
        });
        
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var filiale = response.getReturnValue();
                if(filiale!=null){
                    return filiale;
                }else{
                    return null;
                }
            }
        }));
        $A.enqueueAction(action);

    },
    
    
    
    /*doInit : function(component, event, helper) {
        
		var action = component.get('c.getCaseList'); 
        
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {

                //var totalCase = this.getTotal(caseList[i].Id);
                //var daEsitare = this.getDaEsitare(caseList[i].Id);
                //var sospesiDaEsitare = this.getSospesiDaEsitare(caseList[i].Id);
                
                var caseList = response.getReturnValue();
                console.log('@@@ caseList: '+caseList.length);
                if(caseList.length>0){

                    //var filiale = this.getfiliale(caseList[i].OwnerId);
                    
                    var arr = [];
                    for(var i = 0; i<caseList.length; i++){
                        var obj = {
                            Id : caseList[i].Id,
                            //number : caseList[i].CaseNumber, 
                            caseName : caseList[i].Categoria_Riferimento__r.Name + caseList[i].Tipologia_Lista__r.Tipologia_Attivita__c,
                            //filiale : filiale != null ? filiale : '',
                            filiale : 'Filiale',
                            //accName : caseList[i].AccountId != null ? caseList[i].Account.Name : null,
                            tipoLista : caseList[i].Tipologia_Lista__c ? caseList[i].Tipologia_Lista__r.Name : null,
                            data : caseList[i].Data_Visibilita__c,
                            totale : caseList[i].Totale__c,
                            daEsitare : caseList[i].Da_Esitare__c,
                            sospesiDaEsitare : caseList[i].Sospesi_da_esitare__c,
                            catId : caseList[i].Categoria_Riferimento__c
                            
                            //daConvenzionare : caseList[i].Da_convenzionare__c,
                            //accolli : caseList[i].Accolli_da_gestire__c,
                        }
                        arr.push(obj);
                    }
                    component.set('v.caseList',arr);
                }
            }
            
        }));
        
        $A.enqueueAction(action);
    },
    
    getfiliale : function(caseownerId) {

        var action = component.get('c.getfilialeFromOwnerId');
        action.setParams({
            ownerId : caseownerId
        });
        
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var filiale = response.getReturnValue();
                if(filiale!=null){
                    return filiale;
                }else{
                    return null;
                }
            }
        }));
        $A.enqueueAction(action);

    },*/
    
    setHeaderColumns: function(component, event, helper) {
        
        component.set("v.headerColumns", [
            //{label: 'Case Number', fieldName: 'number', type: 'text'},
            {label: 'Nome Lista', fieldName: 'tipoLista', type: 'text'},
            {label: 'Filiale', fieldName: 'filiale', type: 'text'},
            {label: '# Totale', fieldName: 'totale', type: 'number', cellAttributes: { alignment: 'left' }}, 
            {label: '# Da Esitare', fieldName: 'daEsitare', type: 'number', cellAttributes: { alignment: 'left' }}, 
            {label: '# Sospesi Da Esitare', fieldName: 'sospesiDaEsitare', type: 'number', cellAttributes: { alignment: 'left' }}  
            //{label: '# Da Convenzionare', fieldName: 'daConvenzionare', type: 'Number'}, 
            //{label: '# Accolli Da Gestire', fieldName: 'accolli', type: 'Number'}
        ]);
    },
    
    getChildCase: function(component, event, helper) {
        var editedRecords =  component.find("table").getSelectedRows();

        if(editedRecords.length > 0){

            var action = component.get('c.getCaseChildList');
            
            action.setParams({
                parentCaseId : editedRecords[0].Id
            });
            
            action.setCallback(this, $A.getCallback(function (response) {
                
                var state = response.getState();
                
                if (state === "SUCCESS") {
                    
                    var caseChildList = response.getReturnValue();
                    console.log('caseChildList'+caseChildList.length);
                    if(caseChildList.length > 0){
                        component.set("v.caseChildList",caseChildList);
                        component.set("v.selectedItem",true);
                    }else{
                        component.set("v.selectedItem",false);
                    }
                }
            }));
            $A.enqueueAction(action);
        }
        
    },
    /*
    getTotal : function(component, event, helper){

        var editedRecords =  component.find("table").getSelectedRows();
        var action = component.get('c.getTotalCase');
            
            action.setParams({
                parentCaseId : editedRecords[0].Id
            });
            
            action.setCallback(this, $A.getCallback(function (response) {
                
                var state = response.getState();
                
                if (state === "SUCCESS") {
                    var totalCase = response.getReturnValue();
                    
                }
            }));
            $A.enqueueAction(action);
    },

    daEsitare : function(component, event, helper){

        var editedRecords =  component.find("table").getSelectedRows();
        var action = component.get('c.getCaseDaEsitare');
            
            action.setParams({
                parentCaseId : editedRecords[0].Id
            });
            
            action.setCallback(this, $A.getCallback(function (response) {
                
                var state = response.getState();
                
                if (state === "SUCCESS") {


                }
            }));
            $A.enqueueAction(action);
    },

    sospesiDaEsitare : function(component, event, helper){

        var editedRecords =  component.find("table").getSelectedRows();
        var action = component.get('c.getCaseSospesiDaEsitare');
            
            action.setParams({
                parentCaseId : editedRecords[0].Id
            });
            
            action.setCallback(this, $A.getCallback(function (response) {
                
                var state = response.getState();
                
                if (state === "SUCCESS") {


                }
            }));
            $A.enqueueAction(action);
    },

    */

    openModal : function(component, event, helper){

        var buttonPressed = event.currentTarget.getAttribute("name");
        var index = event.currentTarget.getAttribute("data-index");
        var caseList = component.get('v.caseChildList');
        
        var childSelected = caseList[index];

        component.set('v.caseChildSelected',childSelected);

        
        console.log('buttonPressed: '+buttonPressed);
        if(buttonPressed === 'rivedi'){
            component.set('v.showRivediAttivita',true);
        }else if(buttonPressed === 'dettaglio'){
            component.set('v.showDettaglioDealer',true);
        }else{
            if(childSelected.SFA_ListeCaricate__r.Tipo_Attivita__r.RSS_External_Id_act_code__c === '50'){
                component.set('v.showUtenzeNominative',true);
            }else{
                component.set('v.showEsitazioneAttivita',true);
            }
        }
        component.set('v.showModal',true);
    },
    goEsitaAttivita : function(component, event, helper){
        component.set('v.showUtenzeNominative',false);
        component.set('v.showEsitazioneAttivita',true);
    }
})