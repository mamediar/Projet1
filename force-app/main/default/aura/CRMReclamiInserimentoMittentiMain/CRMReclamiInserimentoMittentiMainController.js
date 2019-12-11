({
    
    init:function(cmp, event, helper){
        var cliente=cmp.get('v.clienteSelezionato');
        var CaseEsistente=cmp.get('v.CaseEsistente');
        if(cliente){
            if(CaseEsistente){
                var Copiato = cmp.get('v.ClienteCopiato');
                console.log('CLIENTE_COPIATO'+Copiato);
                if(Copiato=='' || Copiato ==null || Copiato == "undefined"){
                    
                    cmp.set('v.ClienteCopiato',1);
                }
            }
        }
    },
    
    nuovo:function(cmp,event,helper){
        cmp.set('v.mittenteSelezionatoListaMitt',null);
        cmp.set('v.stepInserimentoMittenti','nuovo');
    },
    
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
        var pratica=cmp.get('v.praticaSelezionata');
        var cliente=cmp.get('v.clienteSelezionato');
        var codCli = cliente.codCliente; 
        var coobbl = cmp.get('v.listaClienteCoobbligati');
        console.log('Coobbligati');
        var coobList=[];
        var list=[];
        if(pratica){
            if(pratica['elencoCoobbligati']){	
            	coobList=pratica['elencoCoobbligati']?pratica['elencoCoobbligati']:[];
        		console.log(coobList);
        		coobList.forEach(function(temp){
            	console.log(temp);
            	temp['tipoRapporto']='CO';
                if(temp.codCliente != codCli)
            		list.push(temp);
              	
                });
                 cmp.set('v.listaCoobbligati',list);
                
                var Copiato = cmp.get('v.CoobligatoCopiato');
            	console.log('Coobligato_COPIATO'+ Copiato);
            	if(Copiato=='' || Copiato ==null || Copiato == "undefined"){
                	helper.copiaCoobbligatoHelper(cmp,helper);
                    cmp.set('v.CoobligatoCopiato',1);
                }
                else{
                     cmp.set("v.toastMsg", "Coobligato già Copiato");
            		 helper.showToastError(cmp);
                }
                    
            }
            else{
                cmp.set("v.toastMsg", "Nessun Coobbligato");
                helper.showToastError(cmp);
                //alert('Nessun Coobbligato');
            }
        }
        else{
            cmp.set("v.toastMsg", "Nessuna pratica selezionata");
            helper.showToastError(cmp);
            //alert('Nessuna pratica selezionata.');
        }
    }
})