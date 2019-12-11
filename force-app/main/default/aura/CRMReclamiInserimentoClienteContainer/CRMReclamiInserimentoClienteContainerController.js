({
    init:function(cmp,event,helper){
        console.log('***************************************************************************');
        console.log('-- - Controller JS : CRMReclamiInserimentoClienteContainerController.js '); 
        console.log('isSconosciuto ************************************ ' + cmp.get('v.isSconosciuto'));
        
        //console.log('Inserimento Cliente container init');
        if(cmp.get('v.clienteSelezionatoContainer')){
            cmp.set('v.clienteSelezionato',cmp.get('v.clienteSelezionatoContainer'));
        }
        if(cmp.get('v.praticaSelezionataContainer')){
            cmp.set('v.praticaSelezionata',cmp.get('v.praticaSelezionataContainer'));
        }
    },
    
    onListaClientiChange:function(cmp,event,helper){
        var clienti = cmp.get('v.listaClienti');
        var showalert2 = cmp.get('v.showAlert2');
        
        if(showalert2){
            //helper.alert2(cmp);
            
        }else if(clienti){
            if(clienti.length==0){
                helper.alert(cmp);
            }
            else
                helper.navigate(cmp,clienti[0]);
            
        }
        
    },
    
    onClienteChange:function(cmp,event,helper){
        var source=event.getSource();
        var clienteSel=cmp.get('v.clienteSelezionato');
        cmp.set('v.clienteSelezionatoContainer',clienteSel);
        if(clienteSel){
            var listaPratiche=[];
            listaPratiche=cmp.get('v.aziendaSelezionata')!='Futuro'?clienteSel['pratiche']:clienteSel['praticheFuturo'];
            if((listaPratiche == null || listaPratiche.length == 0) && !cmp.get('v.isSconosciuto')) {
                cmp.find('notifLib').showNotice({
                    "variant":"error",
                    "header":"Attenzione!",
                    "message":"Nessuna pratica trovata"
                });
                cmp.set('v.stepInserimentoCliente',1);
            }
            else cmp.set('v.listaPratiche',listaPratiche);
        }
    },
    
    onListaPraticheChange:function(cmp,event,helper){        
        var listaPratiche=cmp.get('v.listaPratiche');
        console.log('listaPratiche = ' + listaPratiche);
        var societa=cmp.get('v.aziendaSelezionata');
        if(societa!='MBCredit Solutions' && listaPratiche && listaPratiche.length>0){
            console.log('sono nell if');
            var action=cmp.get('c.getInfoPratiche');
            action.setParam('dataJSON',JSON.stringify(listaPratiche));
            action.setParam('societa',societa);
            cmp.set("v.spinner", true);
            action.setCallback(this,function(resp){
                if(resp.getState()=='SUCCESS'){
                    var listaInfo=resp.getReturnValue(); 
                    cmp.set('v.listaInfoPratiche',listaInfo);
                    console.log('Boris è stato qui ClienteContainerController');
                    console.log(listaInfo);
                    helper.navigate(cmp,cmp.get('v.clienteSelezionato'));
                    console.log('ho fatto il navigate');
                }
                cmp.set("v.spinner", false);
            });
            $A.enqueueAction(action);
        }
        else if(listaPratiche){
            cmp.set('v.stepInserimentoCliente',4);
        }
    },
    
    onPraticaChange:function(cmp,event,helper){
        console.log('sono in onPraticaChange');
        var praticaSel=cmp.get('v.praticaSelezionata');
        console.log('praticaSel = ' + praticaSel);
        console.log(praticaSel);
        var action=cmp.get('c.makeCoobbligati');
        action.setParam('pratica',praticaSel);
        action.setParam('societa','Compass');
		if(praticaSel == null)
			return;
        
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                praticaSel['elencoCoobbligati']=resp.getReturnValue();
                cmp.set('v.praticaSelezionataContainer',praticaSel);
                helper.navigate(cmp,cmp.get('v.praticaSelezionata'));
                console.log('ho fatto il navigate di praticaChange');
            }
            cmp.set("v.spinner", false);
        });
        if(cmp.get('v.aziendaSelezionata')=='Compass'){
            cmp.set("v.spinner", true);
            $A.enqueueAction(action);
        }
        else{
            cmp.set('v.praticaSelezionataContainer',praticaSel);
            helper.navigate(cmp,cmp.get('v.praticaSelezionata'));
        }
    }
})