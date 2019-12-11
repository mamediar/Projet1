({
    //Inizio Boris
    initHelper : function(cmp){
         cmp.set("v.spinner", true);
        var action=cmp.get('c.loadStdtexts');
        action.setParams({'categExternalId' : cmp.get('v.categoriaDettagli')['External_Id__c'],
                          'societa' : cmp.get('v.aziendaSelezionata')});
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
               
                console.log('Response');
                console.log(resp.getReturnValue());
                var obj= [];
                for(var i=0 ; i<resp.getReturnValue().length ; i++){
                    var temp = {
                        "label" : resp.getReturnValue()[i].label,
                        "value" : resp.getReturnValue()[i].value
                    }
					obj.push(temp);
                   
                   
   
                }
                cmp.set('v.stdtextsLabels',null);
                cmp.set('v.stdtextSelected', null);
                cmp.set('v.stdtextsLabels',obj);
                var x = cmp.get('v.stdtextsLabels');
                
            }
            
            
            var action2=cmp.get('c.getCase');
            action2.setParams({
                ident : cmp.get("v.campiCase").Id
            });
            
            
            cmp.set("v.spinner", false);
            action2.setCallback(this,function(resp2){
                  if(resp.getState()=='SUCCESS'){
                      var c = JSON.parse(resp2.getReturnValue());
                      cmp.set("v.caseObj", c);
                      cmp.set("v.textAreaValue", c.Lettera_Risposta__c);
                      var event = cmp.getEvent("richiedoAutorizzazione");
                      event.fire();
                     
                  }
                
            });
            
             $A.enqueueAction(action2);
            
        });
        $A.enqueueAction(action);
        
        
        
        
    },
    
    inserisciTestoStandard : function(cmp, event){
        var selezione = cmp.get("v.stdtextSelected");
        
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
        var idCase;
        
        if(cmp.get('v.caseObj')){
            var ca = cmp.get('v.caseObj').Id;
            idCase = ca;
        } 
        
        console.log('Boris ');
       var s = JSON.stringify(cmp.get('v.caseObj'));
           console.log(s);
          action.setParams({
              'idTesto':selezione,
              'idCase': idCase
          });
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                cmp.set('v.textAreaValue',resp.getReturnValue());
            }
             cmp.set("v.spinner", false);
        });
        $A.enqueueAction(action);
    },
    
    inserisciParagrafoStandard : function(cmp, event){
        var selezione = cmp.get("v.stdtextSelected");
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
        var idCase;
        if(cmp.get('v.caseObj')){
            var ca = cmp.get('v.caseObj').Id;
            idCase = ca.Id;
        } 
        var action=cmp.get('c.getMessageStandard');
        action.setParams({
            'idTesto':selezione,
              'idCase': idCase
        });
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                var textAreaValue = cmp.get("v.textAreaValue");
                var response = textAreaValue+'\n\n'+resp.getReturnValue();
                cmp.set('v.textAreaValue',response);
            }
            cmp.set("v.spinner", false);
        });
        $A.enqueueAction(action);
    },
    
    creaLetteraHelper : function(cmp){
        cmp.set("v.spinner", true);
        var action=cmp.get('c.generateAndAttach');
        var getFirma=cmp.get('v.getFirmaDigitale');

        action.setParams({'fileBody' : cmp.get('v.textAreaValue'),
                          'c' : cmp.get('v.campiCase'),
                          'getFirmaDigitale' : getFirma,
                          'textLabel' : cmp.get('v.stdtextSelected'),
                          'codCliente':cmp.get('v.clienteSelezionato').codCliente,
                          'nome' : cmp.get('v.clienteSelezionato').nome,
                          'cognome': cmp.get('v.clienteSelezionato').cognome
                         });

        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                var attList=cmp.get('v.fileList');
                attList.push(resp.getReturnValue());
                cmp.set('v.fileList',attList);
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Successo",
                    "message": "Allegato generato con successo",
                    "type" : "success"
                });
                toastEvent.fire();
                this.fireUpdate(cmp);
                $A.get('e.force:refreshView').fire();
                var agg = cmp.getEvent('aggiorna');
                agg.fire();
            }
            else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Errore!",
                    "message": "Si è verificato un errore",
                    "type" : "error"
                });
            toastEvent.fire();
            }
            cmp.set("v.spinner", false);
        });
        $A.enqueueAction(action);
    },

    
    salvaLettera : function(cmp, event){
        var action=cmp.get('c.salvaLetteraCtrl');
       
      
        action.setParams({
            'idCase': cmp.get("v.campiCase").Id,
            'testo' : cmp.get("v.textAreaValue")
        });
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                var textAreaValue = cmp.get("v.textAreaValue");
                var response = textAreaValue+'\n\n'+resp.getReturnValue();
                cmp.set('v.textAreaValue',response);
            }
            cmp.set("v.spinner", false);
        });
        if(cmp.get("v.textAreaValue") != undefined){
             cmp.set("v.spinner", true);
            $A.enqueueAction(action);
        }
    },
    
     
    fireUpdate : function(cmp){
         var cmpEvent = cmp.getEvent("aggiorna");
        cmpEvent.fire();

    }
   
    //Fine Boris
   

    
  
})