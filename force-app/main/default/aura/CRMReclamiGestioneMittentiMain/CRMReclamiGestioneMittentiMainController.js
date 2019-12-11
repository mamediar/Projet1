//----------------------------------------------------------------------
//-- - Controller JS Name : CRMReclamiGestioneMittentiMainController.js
//-- - Autor              : Fabio Giuliani(Lynx)
//-- - Date               : 21/05/2019
//-- - Description        : 
//-- - Version            : 1.0
//----------------------------------------------------------------------
({
    init:function(cmp,event,helper){
        console.log('---------------------------------------------------------------------');
		console.log('-- - Controller JS: CRMReclamiGestioneMittentiMainController        '+cmp.get('v.mittentiList')); 

        var cliente=cmp.get('v.clienteSelezionato');
        if(cliente){
            helper.copiaClienteHelper(cmp,helper);
        }
       
    },    
    
    nuovo:function(cmp,event,helper){
        console.log('--------------------------------------------------------------------------------------');
        console.log('-- Controller JS : CRMReclamiGestioneMittentiMainController - Method: nuovo'+cmp.get('v.mittentiList')); 

        cmp.set('v.mittenteSelezionatoListaMitt',null);
        cmp.set('v.stepInserimentoMittenti','nuovo');
    },
    
   /* copiaCliente:function(cmp,event,helper){
        console.log('--------------------------------------------------------------------------------------');
        console.log('-- Controller JS : CRMReclamiGestioneMittentiMainController - Method: copiaCliente'+cmp.get('v.mittentiList')); 
        var cliente=cmp.get('v.clienteSelezionato');
        if(cliente){
            helper.copiaClienteHelper(cmp,helper);
        }
        else{
            alert('Nessun cliente selezionato.');
        }
    },*/
    
        copiaCliente:function(cmp,event,helper){
        var cliente=cmp.get('v.clienteSelezionato');
        if(cliente){
            var Copiato = cmp.get('v.ClienteCopiato');
            console.log('CLIENTE_COPIATO'+Copiato);
            if(Copiato=='' || Copiato ==null || Copiato == "undefined"){
            	helper.copiaClienteHelper(cmp,helper);
             	cmp.set('v.ClienteCopiato',1);
        	}
            else{
                cmp.set("v.toastMsg", "Cliente già Copiato");
            	helper.showToastError(cmp);
            }
        }
        else{
            cmp.set("v.toastMsg", "Nessun cliente selezionato");
            helper.showToastError(cmp);
            //alert('Nessun cliente selezionato.');
        }
    },
    
    copiaCoobbligato:function(cmp,event,helper){
        console.log('--------------------------------------------------------------------------------------');
        console.log('-- Controller JS : CRMReclamiGestioneMittentiMainController - Method: copiaCoobbligato'+cmp.get('v.mittentiList')); 
        var pratica=cmp.get('v.praticaSelezionata');
        if(pratica){
            if(pratica['elencoCoobbligati']){
                helper.copiaCoobbligatoHelper(cmp,helper);
            }
            else{
                alert('Nessun Coobbligato');
            }
        }
        else{
            alert('Nessuna pratica selezionata.');
        }
    }
})