({
    buildTipoValues:function(cmp){
        var cacheList=cmp.get('v.listaValoriTipoCache');
        cmp.set('v.listaValoriTipo',[]);
        var resList=[];
        cacheList.forEach(function(temp){
            var tempList=temp['Descrizione__c'].split(' ');
            if(tempList[tempList.length-1]==cmp.get('v.areaDettagli')){
                resList.push(temp);
            }
        });
        cmp.set('v.listaValoriTipo',resList);
        console.log('listaValoriTipo = ' + cmp.get('v.listaValoriTipo'));
    },
    
    getDescrizioneTipo:function(cmp){
        var tipi=cmp.get('v.listaValoriTipo');
        var tipoSel=cmp.get('v.tipoDettagliContainer');
        var res='';
        tipi.forEach(function(temp){
            if(temp['External_Id__c']==tipoSel){
                res=temp['Descrizione__c'];
                return;
            }
        });
        return res;
    },
    
    checkIfOk:function(cmp){
        var res=true;
        var msg='';
        var attrMap={'tipoDettagli':'Tipo','delegaPresente':'Delega Presente',
                     'accessoDati':'Accesso ai Dati','categoriaDettagli':'Categoria'};
        if(cmp.get('v.isGrave')){
            attrMap['reclamoCompleto']='Reclamo Completo';
        }
        if(cmp.get('v.aziendaSelezionata')=='MBCredit Solutions'){
            attrMap['areaDettagli']='Area';
        }
        Object.keys(attrMap).forEach(function(temp){
            if(!cmp.get('v.'+temp)){
                res=false;
                msg+=attrMap[temp]+', ';
            }
        });
        cmp.set('v.errorMessage',msg!=''?msg.substring(0,msg.length-2):'');
        return res;
    },
    
    buildOutputObj:function(cmp){
        var res={};
        var attrList=['tipoDettagli','delegaPresente','accessoDati','categoriaDettagli',
                      'areaDettagli','isGrave','status'];
        if(cmp.get('v.isGrave')){
            attrList.push('reclamoCompleto');
        }
        attrList.forEach(function(temp){
            if(['accessoDati','reclamoCompleto','delegaPresente','isGrave'].includes(temp)){
                res[temp]=cmp.get('v.'+temp)=='true';
            }
            res[temp]=cmp.get('v.'+temp);
        });
        return res;
    },
    
    getGroupUser : function (cmp){
        console.log('Sono in HandleGroupUser');
        var action = cmp.get("c.loadUserGroup");       
        action.setCallback(this, function(response){
            if (response.getState() == 'SUCCESS'){
                //cmp.set('v.listaUtenti',response.getReturnValue());                       
            }   
            else
                console.log('uuups la callBack fallisce');
        });
        $A.enqueueAction(action);        
    },
    
    getCurrentGroupUser : function(cmp){
        var action = cmp.get("c.getCurrentUser");
        action.setParam('recordId',cmp.get('v.recordId'));
        action.setCallback(this, function(response){
            if (response.getState() == 'SUCCESS'){
                console.log('la response è = ' + response.getReturnValue());
                if(response.getReturnValue()){
                    cmp.set('v.utenteGruppoAssegnato',response.getReturnValue());
                	console.log('utente è = ' + cmp.get('v.utenteGruppoAssegnato'));	
                }
            }   
            else
                console.log('uuups la callBack fallisce');
        });
        $A.enqueueAction(action); 
    },
    
    getAssicurazioni : function(cmp,event,helper){
        var action = cmp.get("c.getAss");
        action.setParam('societa',cmp.get('v.campiCase')['Referenced_Company__c']);
        action.setCallback(this, function(response){
            if (response.getState() == 'SUCCESS'){
              cmp.set('v.listaAss',response.getReturnValue());
                }
            
            else
                console.log('uuups la callBack fallisce');
        
        });
        $A.enqueueAction(action); 
        
    },
    handleChange2 : function(cmp,event,helper){
        console.log('--------------------------------------------------------------------------------------');
        console.log('-- Controller JS: CRMReclamiGestioneHeaderContainerHelper.js - Method:handleChange2'); 
        cmp.set('v.descrizioneTipo',helper.getDescrizioneTipo(cmp));
        //cmp.set('v.isAssicurazione',cmp.get('v.tipoDettagliContainerTipo')=='5410');
        var action=cmp.get('c.isDataScadenzaWritable');
    
        action.setParam('tipo',cmp.get('v.tipoDettagliContainer'));
        action.setParam('societa',cmp.get('v.campiCase')['Referenced_Company__c']);
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                cmp.set('v.isScadenzaChangeable',resp.getReturnValue());
            }
        });
        $A.enqueueAction(action);        
    },
    
    refresh : function(component, event){
        var codaComponent = component.find("CodaInserimentoDettagli");
        if(codaComponent!=undefined) codaComponent.refresh();
        //this.takeUserList(component, event, null);
        //this.clacolaScadenza(component, event);
    },
    
    showSpinner : function(cmp){
        var x = cmp.get("v.isLoading");
        x++;
        cmp.set("v.isLoading", x);
    },
    hideSpinner : function(cmp){
        var x = cmp.get("v.isLoading");
        x--;
        cmp.set("v.isLoading", x);
    },

    takeUserList : function(component, event, helper){

        var action = component.get("c.takeUsersFromQueue");
        var codaSelezionata = component.get("v.codaDettagli");
        
        action.setParams({
            codaId : codaSelezionata
        });
        action.setCallback(this,function(response){
            var x = response.getState();
            if(response.getState()=='SUCCESS'){
                var resp = response.getReturnValue();
                
                if(resp.length>0){
                    var items = [];
                    for(var i=0; i<resp.length; i++){
                        var item = {
                            "label" : resp[i].Name,
                            "value" : resp[i].Id
                        };
                        items.push(item);
                    }
                    component.set('v.listaUtenti',items);
                }
                
            }
        });
        $A.enqueueAction(action);  
    },

    clacolaScadenza: function(component, event, helper){

        var accessoDatiValue = component.get('v.accessoDati');
        var accessoDati = accessoDatiValue == 'Si' ? true : false;
        
        var action = component.get("c.calcolaScadenzaReclamo");
        action.setParams({
            caseId : component.get('v.recordId'),
            accessoDati : accessoDati
        });
        action.setCallback(this,function(response){
            var x = response.getState();
            
            if(response.getState()=='SUCCESS'){
                var resp = response.getReturnValue();
                
                component.set('v.scadenzaReclamo',resp.Scadenza_Reclamo__c);
                console.log('data scadenza aggiornata');
            }
        });
        $A.enqueueAction(action);
        

    }

     
})