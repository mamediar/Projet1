({
	init : function(cmp,event,helper){
        helper.initHelper(cmp);
        //let button = cmp.find("btn-InviaEmail");
        //button.set('v.disabled',true);
	},
    
    addAddress : function(cmp,event,helper){
        helper.addAddressHelper(cmp,event.getSource().get('v.label'));
    },
    
    removePill : function(cmp,event,helper){
        event.preventDefault();

    },
    
    insertMail : function(cmp,event,helper){
        if(event.key=='Enter' || event.key=='enter'){
            helper.addAddressFromInput(cmp,event.target.id);
        }
    },
    
    doRicercaDestinatario : function(cmp,event,helper){
        helper.doRicercaHelper(cmp);
    },
    
    checkAllegati : function(cmp,event,helper){
        cmp.set('v.areAllegatiChecked',!cmp.get('v.areAllegatiChecked'));
    },
    
    inviaRisposta : function(cmp,event,helper){
        var allegati = cmp.find('inserimentoAllegati').get('v.allegatiSelezionati');
        var allegatiSelezionati = cmp.get('v.allegatiSelezionati');
        
        var tuttoOk=true;
        tuttoOk=helper.checkDestinatari(cmp);
        //helper.inviaRispostaHelper(cmp,allegatiSelezionati);
        if(tuttoOk){
            tuttoOk=helper.checkAllegati(cmp,allegatiSelezionati);

            if(tuttoOk){

                //alert('Confermare di aver visionato gli allegati.');
                var presavisione = cmp.get('v.valuecheckallegati');
                if(presavisione.length == 0){
                    helper.showToast(cmp, 'Errore', 'error', 'Confermare di aver visionato gli allegati.');
                }else{
                    helper.inviaRispostaHelper(cmp,allegatiSelezionati);
                }

                
            }else{
                helper.showToast(cmp, 'Errore', 'error', 'Selezionare almeno un allegato.');
            }

        }
        else{
            //alert('Inserire almeno un destinatario.');
            helper.showToast(cmp, 'Errore', 'error', 'Inserire almeno un destinatario.');
            return;
        }
        /*
        if(tuttoOk){
            helper.inviaRispostaHelper(cmp,allegatiSelezionati);
        }
        else{
            //alert('Confermare di aver visionato gli allegati.');
            var presavisione = cmp.get('v.valuecheckallegati');
            if(presavisione.length == 0){
                helper.showToast(cmp, 'Errore', 'error', 'Confermare di aver visionato gli allegati.');
            }
            //return;
        }*/
    },
    reset:function(component,event,helper){
       helper.reset(component, event);
    },

    prendiVisione : function(component,event,helper){
        //helper.reset(component, event);
        var presavisione = component.get('v.valuecheckallegati');
        let button = component.find("btn-InviaEmail");

        if(presavisione.length>0){
            button.set('v.disabled',false);
        }else{
            button.set('v.disabled',true);
            //helper.showToast(component, 'Errore', 'error', 'Confermare di aver visionato gli allegati.');
        }
    }
})