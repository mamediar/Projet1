({
    init:function(cmp,event,helper){
        console.log('INIT XCSReclamiFormContattoSconosciutoCtrl');
        cmp.set('v.isSconosciuto',false);
    },
    
    onButtonPressed:function(cmp,event,helper){
        //bug 1682
        var allValid = cmp.find('field').reduce(
            function(validSoFar, inputCmp) {
                inputCmp.showHelpMessageIfInvalid();

                return validSoFar && inputCmp.get('v.validity').valid;
            }, true);
            //cmp.set("v.popMsg", "Verifica la corretezza dei campi inseriti");
            //helper.showPopupError(cmp,event,helper);

        if (allValid) {

            
            var valid = helper.checkEmail(cmp,event,helper);
            if(!valid){
                cmp.set("v.toastMsg", "Domino campo mail errato");
                helper.showToastError(cmp);
            }

            //bug 1682
            //+controllo di correttezza(al momento solo .it, .org, .com)
            //if(valid){

        //----------------
            if(cmp.get('v.nome') && cmp.get('v.cognome')){
                var keyList=['v.indirizzo','v.localita','v.cap','v.email','v.telefonoCasa','v.telCellulare',
                            'v.cognome','v.nome','v.dataNascita','v.codFiscale'];
                var dataMap={};
                keyList.forEach(function(temp){
                    dataMap[temp.substring(2,temp.length)]=cmp.get(temp)?cmp.get(temp):'';
                });
                var action=cmp.get('c.makeCliente');
                console.log('DatiClienteSconosciuto: '+dataMap);
                console.log(dataMap);
                action.setParam('data',dataMap);
                action.setParam('societa',cmp.get('v.aziendaSelezionata'));
                action.setCallback(this,function(resp){
                    if(resp.getState()=='SUCCESS'){
                        var listaClienti=[];
                        listaClienti.push(resp.getReturnValue());
                        cmp.set('v.isSconosciuto',true);
                        cmp.set('v.clienteSelezionato',resp.getReturnValue());
                        cmp.set('v.listaClienti',listaClienti);
                    }
                    else{
                        cmp.set('v.isSconosciuto',false);
                    }
                });
                $A.enqueueAction(action);
            }
            else{

                cmp.set("v.popMsg", "Per creare un contatto sconosciuto, inserire almeno Nome e Cognome.");
                helper.showPopupError(cmp);
                
            }
            //bug 1682
            //+controllo di correttezza mail
            /*}else{
                cmp.set("v.popMsg", "Il campo mail ha un domino npon valido");
                helper.showPopupError(cmp);
            }*/

        
        }else {
            
            //var x = helper.checkEmail(cmp,event,helper);
            cmp.set("v.toastMsg", "Verifica la corretezza dei campi inseriti");
            helper.showToastError(cmp);
            
        }
        //------------


    },
    checkLength : function(component, event, helper) {
        helper.checkLengthField(component, event, helper);
    }
      
})