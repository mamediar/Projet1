({
    init: function(cmp, event){
      console.log("CRMReclamiInserimentoDettagliSelezioneCodaControllerJs");
        var x = cmp.get('v.aziendaSelezionata');
        var isReclamoCompleto = cmp.get('v.reclamoCompleto') != null && cmp.get('v.reclamoCompleto') == 'Si';
        
        var action=cmp.get('c.getQueues');
        action.setParam('societa',cmp.get('v.aziendaSelezionata'));
        action.setParam('tipo',cmp.get('v.tipo'));
        action.setParam('categoria',cmp.get('v.categoriaDettagli'));
        action.setParam('delega_presente',cmp.get('v.delegaPresente'));
        action.setParam('stageInadempimento',cmp.get('v.inadempimentoStage')); 
        action.setParam('reclamo_completo', isReclamoCompleto); 
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                var listaCode = resp.getReturnValue();
                var codaDefault = listaCode[0];
                console.log(resp.getReturnValue());
                console.log('@@@Boris');
                cmp.set('v.listaCodeFiltrata',resp.getReturnValue());
               // cmp.set('v.codaSelezionata', codaDefault);
               this.setCodaIniziale(cmp, event);
            }
            else{
                var errors = resp.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                                    errors[0].message);
                    }
                }
                
            }
            this.hideSpinner(cmp);
            console.log("CRMReclamiInserimentoDettagliSelezioneCodaControllerJs FINE");
        });
        this.showSpinner(cmp);      
        $A.enqueueAction(action);
    },
    
    setCodaIniziale: function(cmp, event){
        var listaCode = cmp.get("v.listaCodeFiltrata");
        cmp.set('v.codaSelezionata',listaCode[0]);
        
        var action  = cmp.get("c.setCodaInizialeCTRL");
        action.setParam('recordId',cmp.get('v.recordId'));
        action.setParam('societa',cmp.get('v.aziendaSelezionata'));
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                var codaSelezionata = resp.getReturnValue();
                var allQueues = cmp.get('v.listaCodeFiltrata');
                var flag = false;
                for(var i=0; i<allQueues.length;i++){
                    if(allQueues[i].DeveloperName == codaSelezionata.DeveloperName){
                        cmp.set('v.codaSelezionata', codaSelezionata);
                        cmp.set('v.codaTemp', codaSelezionata);
                        flag=true;
                        break;
                    }
                }
                if(!flag){
                    cmp.set('v.codaSelezionata', allQueues[0]);
                    cmp.set('v.codaTemp', allQueues[0]);
                }
               
               	
                
                this.setOwner(cmp, codaSelezionata.DeveloperName);
                this.hideSpinner(cmp);      
            }
        });
        if(cmp.get("v.recordId") != null){
            this.showSpinner(cmp);      
            $A.enqueueAction(action);
        }
    },
    
    setOwner : function(cmp, codaDevName){
        var action  = cmp.get("c.getOwnerCtrl");
        action.setParam('coda',codaDevName);
        action.setParam('societa',cmp.get('v.aziendaSelezionata'));
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                cmp.set('v.codaDettagli', resp.getReturnValue());
                 this.hideSpinner(cmp);      
            }
        });
         this.showSpinner(cmp);      
        $A.enqueueAction(action);
    
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
    }
   
    
    
})