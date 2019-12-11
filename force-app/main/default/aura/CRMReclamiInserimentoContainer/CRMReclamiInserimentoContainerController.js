//----------------------------------------------------------------------
//-- - Controller JS Name : CRMReclamiInserimentoContainerController.js
//-- - Autor              : 
//-- - Date               : 22/05/2019
//-- - Description        : 
//-- - Version            : 1.0
//----------------------------------------------------------------------
({
    init:function(cmp,event,helper){
        cmp.set('v.stepInserimentoCliente',1);
    },
    
    reset : function(cmp, event){
        var button = event.getSource();
        var choose = button.get("v.value");
        console.log(choose);
       	if(choose == 'modal') cmp.set("v.showMessage", true);
        else if(choose == 'Si'){
            cmp.set("v.showMessage", false);
            $A.get('e.force:refreshView').fire();
            cmp.set("v.aziendaSelezionata",'');
    

            //-----------------------
            console.log('--------RESET-------');
            cmp.set('v.listaClienti',null);
            cmp.set('v.clienteSelezionato',null);
            cmp.set('v.stepInserimentoCliente',1);
            cmp.set('v.listaPratiche',null);
            cmp.set('v.praticaSelezionata',null);
            cmp.set('v.praticaSelezionataContainer',null);
            cmp.get('v.listaInfoPratiche',null);
            cmp.set('v.infoPraticaSelezionata',null);
            cmp.set('v.clienteSelezionatoContainer',null);
            cmp.set('v.reclamoSelezionato',null);
            cmp.set('v.categoriaDettagli',null);
            cmp.set('v.reclamoIdAfterSave',null);
            cmp.set('v.filiale',null);
            //-----------------------

        }
        else cmp.set("v.showMessage", false);
    },
    
    salvaReclamo:function(cmp,event,helper){
        var categoria = cmp.get("v.categoriaDettagli");
        if(categoria == null || categoria == undefined || categoria.length <=0){
            helper.showToast(cmp, 'Errore', 'error','Categoria non valorizzata');
            return;
        }
        
        var categoria = cmp.get("v.categoriaDettagli");
        if(categoria == null || categoria == undefined || categoria.length <=0){
            helper.showToast(cmp, 'Errore', 'error','Categoria non valorizzata');
            return;
        }
        
        var isAllOk=helper.checkAll(cmp,helper);
  
        if(!isAllOk){
            var msg = cmp.get('v.errorMessage')
            helper.showToast(cmp, 'Errore','Error', msg);

          
        }else{
           
            helper.salvaReclamoHelper(cmp,helper);
            
            if(helper.isCategoriaFrode(cmp)){
                //helper.sendFandTFrode(cmp);
                console.log('------------------------------------------------------------------------------');
                console.log('Controller JS: CRMReclamiInserimentoContainerController - Method: salvaReclamo'); 
                console.log('if(helper.isCategoriaFrode(cmp))  - Value: ' + helper.isCategoriaFrode(cmp)); 
                console.log('TEXT: la categoria è una frode'); 
            }else{
                console.log('------------------------------------------------------------------------------');
                console.log('Controller JS: CRMReclamiInserimentoContainerController - Method: salvaReclamo'); 
                console.log('if(helper.isCategoriaFrode(cmp))  - Value: ' + helper.isCategoriaFrode(cmp)); 
                console.log('TEXT: la categoria non è una frode'); 
            }
            if(helper.isInadempimento(cmp)){
               // helper.sendFandTChatterInadempimento(cmp);
                console.log('------------------------------------------------------------------------------');
                console.log('Controller JS: CRMReclamiInserimentoContainerController - Method: salvaReclamo'); 
                console.log('if(helper.isInadempimento(cmp))  - Value: ' + helper.isInadempimento(cmp)); 
                console.log('TEXT: la categoria è un inadempimento'); 
            }else{
                console.log('------------------------------------------------------------------------------');
                console.log('Controller JS: CRMReclamiInserimentoContainerController - Method: salvaReclamo'); 
                console.log('if(helper.isInadempimento(cmp))  - Value: ' + helper.isInadempimento(cmp)); 
                console.log('TEXT: la categoria non è un inadempimento'); 
            }
        }
        
        //to delete 
        /*
        //controllare se è frode, inadempimento, .. nel caso mandare un bel F&T
        //vedi controller apex di questo componente e pensa a come strutturare il tutto
        //Osservazione: bisogna prima inserire il reclamo e dopo nella callback mettere l invio email
        //anche perchè nella mail vanno inseriti alcuni campi che devono essere PRIMA inseriti in DB
        //e poi recuperati (ossia : numero_reclamo)
        
        
        //da scommentare
        //helper.sendFandTFrode(cmp);
        //helper.sendFandTChatterInadempimento(cmp);
        */
    },
    
    getOrgPath:function(cmp,event,helper){
        console.log('------------------------------------------------------------------------');
        console.log('Controller JS: CRMReclamiInserimentoContainerHelper - Method: getOrgPath'); 

        var action = cmp.get("c.pathOrg");
//        action.setParam('recordId',cmp.get('v.reclamoIdAfterSave'));
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
		        cmp.set('v.orgPath',resp.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
})