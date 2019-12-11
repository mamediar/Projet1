({
    init:function(cmp,event,helper){
        
        var today = new Date();
        cmp.set('v.today', today.getFullYear() +'-' + (today.getMonth() + 1) + '-' + today.getDate());
        console.log("CRMReclamiGestioneHeaderControllerJs");
        helper.getAssicurazioni(cmp);
        cmp.set('v.status',cmp.get('v.campiCase')['Status']);
          cmp.set('v.codaDettagli',cmp.get('v.campiCase')['OwnerId']);
          var c = cmp.get('v.campiCase');
          
          cmp.set('v.codaName',c.Owner.Name);
          cmp.set('v.catName',c.Categoria_Riferimento__r.Name);
          cmp.set('v.tipoName',c.Tipo_Reclamo__c);
        
          
          
        cmp.set("v.tipoDettagliContainerTipo", cmp.get('v.campiCase')['Tipo_Reclamo__c']);

        var tipo = cmp.get('v.tipoDettagliContainerTipo');
        
        if(tipo == '5412'){
            
            cmp.set('v.showDecisione',true);
        }else if(tipo == 'Decisione'){
            
            cmp.set('v.showDecisione',true);
        }else{
            
            cmp.set('v.showDecisione',false);
        }
        
        if(cmp.get('v.delegaPresente') == 'Si' || cmp.get('v.delegaPresente') == true || cmp.get('v.delegaPresente') == 'true')		        
            cmp.set('v.delegaPresente','Si');
        else if(cmp.get('v.delegaPresente') == 'No' || cmp.get('v.delegaPresente') == false || cmp.get('v.delegaPresente') == 'false')	
            cmp.set('v.delegaPresente','No');
        
        if(cmp.get('v.accessoDati') == 'Si' || cmp.get('v.accessoDati') == true || cmp.get('v.accessoDati') == 'true')		        
            cmp.set('v.accessoDati','Si');
        else if(cmp.get('v.accessoDati') == 'No' || cmp.get('v.accessoDati') == false || cmp.get('v.accessoDati') == 'false')	
            cmp.set('v.accessoDati','No');
        
        if(cmp.get('v.reclamoCompleto') == 'Si' || cmp.get('v.reclamoCompleto') == true || cmp.get('v.reclamoCompleto') == 'true')		        
            cmp.set('v.reclamoCompleto','Si');
        else if(cmp.get('v.reclamoCompleto') == 'No' || cmp.get('v.reclamoCompleto') == false || cmp.get('v.reclamoCompleto') == 'false')	
            cmp.set('v.reclamoCompleto','No');
  
        var action=cmp.get('c.getInitValues');
        action.setParam('societa',cmp.get('v.aziendaSelezionata'));
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                if(cmp.get('v.aziendaSelezionata')=='MBCredit Solutions'){
                    cmp.set('v.listaValoriTipoCache',resp.getReturnValue()['tipiList']);
                    helper.buildTipoValues(cmp);
                }
                else{
                    cmp.set('v.listaValoriTipo',resp.getReturnValue()['tipiList']);
                }
              
                cmp.set('v.descrizioneTipo',helper.getDescrizioneTipo(cmp));
             
                cmp.set('v.isAssicurazione',cmp.get('v.descrizioneTipo').includes('Assicurazione'));
                cmp.set('v.isOk',helper.checkIfOk(cmp));
                cmp.set('v.outputObj',helper.buildOutputObj(cmp));
                
                
                var action2 = cmp.get('c.getInitTipo');
                action2.setParam('idCase',cmp.get('v.recordId'));
                action2.setParam('societa',cmp.get('v.aziendaSelezionata'));

                action2.setCallback(this,function(resp){
                    if(resp.getState()=='SUCCESS'){
                        var tipo_mdt = resp.getReturnValue();
                        cmp.set('v.tipoDettagliContainerTemp', tipo_mdt);
                        cmp.set('v.tipoDettagliContainerTipo', tipo_mdt.External_Id__c);
                        var action3=cmp.get('c.isDataScadenzaWritable');
                      
                        action3.setParam('tipo_mdt',cmp.get('v.tipoDettagliContainerTemp'));
                        action3.setParam('societa',cmp.get('v.aziendaSelezionata'));
                        action3.setCallback(this,function(resp){
                            if(resp.getState()=='SUCCESS'){
                                cmp.set('v.isScadenzaChangeable',resp.getReturnValue());
                                helper.refresh(cmp);
                            }
                            helper.hideSpinner(cmp);
                        });
                        helper.showSpinner(cmp);
                        $A.enqueueAction(action3);        
//--------------------------------------------------------------------
//-- - FINE MODIFICA
//--------------------------------------------------------------------
                    }
                    else console.log('fail init gestione Header Container');
                    console.log("Step 2.2");
                    helper.hideSpinner(cmp);
                    
                });
                helper.showSpinner(cmp);
                console.log("lancio action 2");
                $A.enqueueAction(action2);
                
            }
            helper.hideSpinner(cmp);
        });
        helper.showSpinner(cmp);
        $A.enqueueAction(action);
        //helper.getGroupUser(cmp);
        helper.takeUserList(cmp,event,helper);
        //helper.getCurrentGroupUser(cmp);
    },
    
    //Boris Inizio
    aggiornaHeader:function(cmp,event,helper){
        helper.refresh(cmp, event);
    },
    //Boris Fine
    
    handleChange:function(cmp,event,helper){

        var label=event.getSource().get('v.label');
        
        if(label=='Data Decisione:'){
            //Data_Decisione__c 
            //var d = cmp.get('v.campiCase')['Data_Decisione__c'];
            var value=event.getSource().get('v.value');
            cmp.set('v.dataDecisione',value);
            var value2 = cmp.get('v.dataDecisione');
            
        }
        if(label=='Accesso ai Dati:'){
            
            helper.clacolaScadenza(cmp,event,helper);
        }
        
        if(label=='Coda:'){
            helper.takeUserList(cmp,event,helper);
        }

        if(label=='Area:'){
            helper.buildTipoValues(cmp);
        }
        if(label=='Tipo'){
            cmp.get('v.listaAss').forEach(function(temp){

                var tipoDettaglio = cmp.get('v.tipoDettagliContainerTipo');
                
                
            });
            
            cmp.set('v.descrizioneTipo',helper.getDescrizioneTipo(cmp));
            //cmp.set('v.isAssicurazione',cmp.get('v.tipoDettagliContainerTipo')=='5410');
            var action=cmp.get('c.isDataScadenzaWritable');
//            action.setParam('tipo',cmp.get('v.tipoDettagliContainer'));
            action.setParam('tipo',cmp.get('v.tipoDettagliContainerTipo'));
            action.setParam('societa',cmp.get('v.campiCase')['Referenced_Company__c']);
            action.setCallback(this,function(resp){
                if(resp.getState()=='SUCCESS'){
                   
                    cmp.set('v.isScadenzaChangeable',resp.getReturnValue());
                }
            });
            $A.enqueueAction(action);        
        }        
        cmp.set('v.isOk',helper.checkIfOk(cmp));
        cmp.set('v.outputObj',helper.buildOutputObj(cmp));
        cmp.set('v.tipoDettagli',cmp.get('v.tipoDettagliContainer'));   
        helper.refresh(cmp, event);
    },
    
    handleGroupUser : function(cmp,event,helper){
        console.log(cmp.get('v.utenteGruppoAssegnato'));
    },
    
    all : function(cmp,event,helper){
       cmp.set('v.tipoDettagliContainerTemp','Selezionare');
    },
    
    blur : function(cmp,event,helper){
        cmp.set('v.tipoDettagliContainerTemp','Selezionare');
        console.log('blur');
    },
    
    buildInputAbbuono:function(cmp){
        var res={};
        res['selection']=cmp.get('v.abbuonoSelection');
        res['value']=cmp.get('v.abbuonoValue');
        return res;
    },
    
   
    salvaReclamoGestioneHeader : function(cmp,event, helper){
      	
        var area = cmp.get('v.areaDettagli');
        if(!area)
        	area = cmp.get('v.campiCase')['Area__c']
            
        var coda = cmp.get('v.codaDettagli');
        
        var tipo = cmp.get('v.tipoDettagliContainerTipo');
    
     
        var tipoCode = cmp.get('v.tipoDettagli');

        
       
        if(!tipo){
         
            tipo = cmp.get('v.campiCase')['Tipo_Reclamo__c'];
        }
        
        var res = true;
        
        var categoria;
        if(cmp.get('v.categoriaDettagli'))
         categoria = cmp.get('v.categoriaDettagli')['Id'];
        else
            categoria = cmp.get('v.campiCase')['Categoria_Riferimento__c'];
            
        var reclamoCompleto = cmp.get('v.reclamoCompleto');
        var accessoDati = cmp.get('v.accessoDati');
        var delegaPresente = cmp.get('v.delegaPresente');
        var status = cmp.get('v.status');
        var dataDecisione = cmp.get('v.dataDecisione');
        var assegnato = cmp.find("assegnato").get('v.value');
        
        var caseHeader = {};        
        caseHeader['categoria'] = categoria;
        caseHeader['reclamoCompleto'] = reclamoCompleto;
        caseHeader['accessoDati'] = accessoDati;
        caseHeader['delegaPresente'] = delegaPresente;
        caseHeader['status'] = status;
        caseHeader['tipo'] = tipo;
        
        caseHeader['coda'] = coda;
        caseHeader['dataDecisione'] = dataDecisione;
        caseHeader['assegnato'] = assegnato;

        //data scadenza
        //helper.clacolaScadenza(cmp,event,helper);

        return caseHeader;
    },

    makeCaseGestione : function(cmp,event,helper){
        var res = {};
        res['categoriaId'] = cmp.get('v.categoriaDettagli')['Id'];
        res['reclamoCompleto'] = cmp.get('v.reclamoCompleto');
        res['accessoDati'] = cmp.get('v.accessoDati');
        res['delegaPresente'] = cmp.get('v.delegaPresente');
        res['status'] = cmp.get('v.status');
        res['tipo'] = cmp.get('v.tipoDettagliContainerTipo');
        return res;
    },
   
    updateComponent :function(cmp, event, helper){
        var evt = cmp.getEvent("aggiorna");
        evt.fire();
    },
    
    refresh : function(cmp, event, helper){
       helper.refresh(cmp, event);
        
    },

    takeUserList : function(component, event, helper){
        //component.set('v.utenteGruppoAssegnato','');
        helper.takeUserList(component, event, helper);
    },

    setAssegnato : function(component, event, helper){
        helper.takeUserList(component, event, helper);
        var selezionato = component.find("assegnato").get('v.value');
        component.set('v.utenteGruppoAssegnato',selezionato);
        
    },
    clacolaScadenza: function(component, event, helper){
        helper.clacolaScadenza(cmp,event,helper);
    }
    
})