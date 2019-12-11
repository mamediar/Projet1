({
	init:function(cmp,event,helper){
        if(cmp.get('v.aziendaSelezionata')=='Compass'){
            var p=cmp.get('v.praticaSelezionata');
            var codDealer=helper.getCodiceDealer(p);
            var action=cmp.get('c.getConvenzionato');
            action.setParam('codCliente',codDealer);
            action.setCallback(this,function(resp){    
                if(resp.getState()=='SUCCESS'){
                    var mdp=p?p['tipoPagamento']:'';
                    
                    if(mdp =='BP'){
            			mdp='Bollettino Postale';
                    }
                    else if(mdp=='CR'){
                        mdp='Carta';
                    }
                    else if(mdp=='RI'){
                        mdp='Rid';
                    }
                    var r=resp.getReturnValue();
                    cmp.set('v.pan',p?p['pan']:'');
                    cmp.set('v.modPagamento',mdp);
                    cmp.set('v.filiale',p?p['filiale']:'');
                    cmp.set('v.codOCSConvenzionato',codDealer);
                    cmp.set('v.ragSocialeConvenzionato',r['Name']);
                    cmp.set('v.indirizzoConvenzionato',r['ShippingStreet']);
                    //TODO da vedere quale campo di OCSPratica contiene il NOME della filiale, NON il codice
                    console.log('FILIALE:'+cmp.get('v.filiale'));
                    var action2 =cmp.get('c.GetNomeFiliale');
                    var filiale= cmp.get('v.filiale');
                    action2.setParam('filiale',filiale);
                    
            		action2.setCallback(this,function(resp2){    
                	if(resp2.getState()=='SUCCESS'){
                       console.log('NOMEFILIALE:'+ resp2.getReturnValue());
                       cmp.set('v.NomeFiliale' , resp2.getReturnValue());
                	}
                    
                    //TODO da vedere quale campo di OCSPratica contiene il NOME della filiale, NON il codice
                	});
            		$A.enqueueAction(action2);
                }
            });
            $A.enqueueAction(action);
        }
        else{
            var c=cmp.get('v.clienteSelezionato');
            cmp.set('v.pan',c['pratiche'][0]['pan']);
        }
	}
})