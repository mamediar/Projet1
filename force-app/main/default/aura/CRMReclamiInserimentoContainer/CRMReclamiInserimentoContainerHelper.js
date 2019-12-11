//----------------------------------------------------------------------
//-- - Controller JS Name : CRMReclamiInserimentoContainerHelper.js
//-- - Autor              : 
//-- - Date               : 22/05/2019
//-- - Description        : 
//-- - Version            : 1.0
//----------------------------------------------------------------------
({
    checkAll:function(cmp,helper){
      
        var res=true;
        
        res=helper.checkDettagli(cmp);
        if(res){
            res=helper.checkCliente(cmp);
        }
        if(res){
            res=helper.checkMittenti(cmp);
        }
        if(res){
            res=helper.checkAllegati(cmp);
        }
        return res;
    },
    
    checkAllegati:function(cmp){
      
        var res=cmp.get('v.fileList').length>0;
        if(!res){
            //cmp.set('v.errorMessage','Inserire almeno un Allegato.');
            this.showToast(cmp, 'Errore','Error', 'Inserire almeno un Allegato.');

        }
        return res;
    },
    
    checkDettagli:function(cmp){
        console.log('---------------------------------------------------------------------------');
        console.log('Controller JS: CRMReclamiInserimentoContainerHelper - Method: checkDettagli'); 
        var res=cmp.get('v.isDettagliOk');
        var msg=cmp.get('v.dettagliErrorMessage');
        if(!res){
         
            
            this.showToast(cmp, 'Errore','error', 'Compilare i seguenti campi nei dettagli: '+msg);

            
        }
        return res;
    },
    
    checkCliente:function(cmp){
        console.log('----------------------------------------------------------------------');
        console.log('Controller JS: CRMReclamiInserimentoContainerHelper - Method: checkCliente'); 
        var res=true;
        if(!cmp.get('v.clienteSelezionatoContainer')){
            res=false;
            //cmp.set('v.errorMessage','Per salvare il reclamo è necessario inserire un cliente');
            this.showToast(cmp, 'Errore','error', 'Per salvare il reclamo è necessario inserire un cliente');

        }
        else if(cmp.get('v.aziendaSelezionata')!='MBCredit Solutions' && !cmp.get('v.praticaSelezionataContainer') && !cmp.get('v.isSconosciuto')){
           res=false;
            this.showToast(cmp, 'Errore','Error', 'Per salvare il reclamo è necessario selezionare una pratica');

            //res=false;
            //cmp.set('v.errorMessage','Per salvare il reclamo è necessario selezionare una pratica');
        }
        return res;
    },
    
    checkMittenti:function(cmp){
        console.log('----------------------------------------------------------------------');
        console.log('Controller JS: CRMReclamiInserimentoContainerHelper - Method: checkMittenti'); 
        var res=true;
        if(!cmp.get('v.mittentiList') || cmp.get('v.mittentiList').length<=0){
            res=false;
            //cmp.set('v.errorMessage','Per salvare il reclamo è necessario inserire almeno un mittente');
       		  this.showToast(cmp, 'Errore','error', 'Per salvare il reclamo è necessario inserire almeno un mittente');
        }
        return res;
    },
    
    salvaReclamoHelper:function(cmp,helper){
    	cmp.set("v.spinner",true);
        var action=cmp.get('c.creaReclamo');

        var coda = cmp.find('coda_dettaglio').get('v.codaSelezionata');
        var cat = cmp.get('v.categoriaDettagli');
        var codCategoria = cat.External_Id__c;
        var delega = cmp.find('coda_dettaglio').get('v.delegaPresente');

        action.setParam('inputJson',JSON.stringify(helper.makeInput(cmp)));
        action.setParam('societa',cmp.get('v.aziendaSelezionata'));
        action.setParam('fileList',cmp.get('v.fileList'));
        action.setParam('reclamoSelezionato',cmp.get('v.reclamoSelezionato'));
        action.setParam('coda',coda.DeveloperName);
        action.setParam('codCategoria',codCategoria);
        action.setParam('delegaPresente',delega);
        
        action.setCallback(this,function(resp){ 
            if(resp.getState()=='SUCCESS'){
                cmp.set('v.reclamoIdAfterSave', resp.getReturnValue()['Id']);
                helper.allegaFeedItem(cmp);              

                var eurl=$A.get("e.force:navigateToURL");
              
                eurl.setParams({
//                  "url":'https://compass--dev.lightning.force.com/lightning/o/Case/list?filterName=Recent'
                    "url":'/lightning/o/Case/list?filterName=Recent'
                });
                eurl.fire();
       
            }
            else{
                var errors = resp.getError();
                
                this.showToast(cmp, 'Errore','error', 'Errore nella creazione del Reclamo '+errors[0].message);
            }
            cmp.set("v.spinner",false);
        });
        $A.enqueueAction(action);
    },
    
    makeInput:function(cmp){
        console.log('-----------------------------------------------------------------------');
        console.log('Controller JS: CRMReclamiInserimentoContainerHelper - Method: makeInput'); 

        var res={};
        var attrList=['dettagliOutputObj','clienteSelezionatoContainer','praticaSelezionataContainer',
                      'infoPraticaSelezionata','mittentiList','isSconosciuto'];
        attrList.forEach(function(temp){
            if(temp!='infoPraticaSelezionata'){
                res[temp]=cmp.get('v.'+temp);
            }
            else if(cmp.get('v.'+temp)){
                res['pacchettiAssicurativi']=cmp.get('v.'+temp)['pacchettiAssicurativi'];
            }
        });
        console.log('----------------------------------------------------------------------');
        console.log('Controller JS: CRMReclamiInserimentoContainerHelper - Method: makeInput'); 
        console.log('Variable Name: res  - Value: ' + JSON.stringify(res)); 

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      //  res['dettagliOutputObj']['sezInadempimentoOutput']['filiale'] = cmp.get('v.filiale') != null ? cmp.get('v.filiale') : '' ;
        return res;
    },
    
    isReclamoFrode:function(cmp){ 
        console.log('----------------------------------------------------------------------');
        console.log('Controller JS: CRMReclamiInserimentoContainerHelper - Method: isReclamoFrode'); 
      //  return cmp.get('v.isGrave');
    },
    
     
    sendFandTFrode : function(cmp,event,helper){
        console.log('----------------------------------------------------------------------');
        console.log('Controller JS: CRMReclamiInserimentoContainerHelper - Method: sendFandTFrode'); 

        console.log('sono in sendFandTFrode con = ' + cmp.get('v.reclamoIdAfterSave'));
        var action = cmp.get("c.sendEmailForwardAndTrackFrode");
        action.setParam('recordId',cmp.get('v.reclamoIdAfterSave'));
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                console.log('email inviata???');
            }
            
        });
        $A.enqueueAction(action);
    },
    
    sendFandTChatterInadempimento : function(cmp,event,helper){
        console.log('----------------------------------------------------------------------');
        console.log('Controller JS: CRMReclamiInserimentoContainerHelper - Method: sendFandTChatterInadempimento'); 

        var action = cmp.get("c.postOnChatterInadempimento");
        action.setParam('recordId',cmp.get('v.reclamoIdAfterSave'));
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                console.log('messaggio postato?');
            }            
        });
        $A.enqueueAction(action);
    },

    allegaFeedItem : function(cmp,event,helper){
        var action = cmp.get("c.insertFeedItem");
        action.setParam('recordId',cmp.get('v.reclamoIdAfterSave'));
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                console.log('feedItem postato?');
            }            
        });
        $A.enqueueAction(action);
        
    },
    
    //metodo che controlla se la categoria è una frode...
    //osservazione: il fatto che la categoria selezionata sia una frode deriva da una verifica statica
    //del file di mapping presente nei documenti. non è presente alcun flag a livello del database!?
    //quindi posso controllare "Staticamente" se è frode inserendo i valori direttamente in JS!?
    isCategoriaFrode : function(cmp,event,helper){
        console.log('----------------------------------------------------------------------');
        console.log('Controller JS: CRMReclamiInserimentoContainerHelper - Method: isCategoriaFrode'); 
        
        var cat = cmp.get('v.categoriaDettagli')['External_Id__c'];
        console.log('categoria = ' + cat);        
        if(cat == 2011 || cat == 2052 || cat == 2179 ||
           cat == 2180 || cat == 2053 || cat == 2181 ||
           cat == 2182 || cat == 3479 || cat == 3480 ||
           cat == 3451)
            
            return true;                
    },
    
    //
    isInadempimento : function(cmp,event,helper){
        console.log('----------------------------------------------------------------------');
        console.log('Controller JS: CRMReclamiInserimentoContainerHelper - Method: isInadempimento'); 
        
        console.log('categoria dettagli = ' + cmp.get('v.categoriaDettagli'));
        var isInademp;
        var action = cmp.get('c.isInadempimentoSelected');
        action.setParam('categoriaDettagli',cmp.get('v.categoriaDettagli'));
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                isInademp = resp.getReturnValue();                
            }            
        });
        $A.enqueueAction(action);
        return isInademp;
      
    },
    
    showToast : function(component, title, type, message ) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type":type
            
        });
        toastEvent.fire();
    }
    
    
})