({
    handleSubmit : function(cmp, event, helper) {
       console.log(cmp.get('v.endDate'));     
       
    },
    handleSuccess: function(cmp,event,helper){
        let action = cmp.get('c.cloneScript');
            console.log('ciaoooo sono nekl hanfle submit');
            let oldScript = cmp.get('v.ScriptRecord');
            
            let IdoldScript = cmp.get('v.idScript');
        	let text = cmp.get('v.text');
        	let esecuzione;
        	let controllDate;
        if(IdoldScript == null || IdoldScript == undefined)
        text == null || text == undefined || text.trim() === "<p>        </p>"? (helper.toastMancante(cmp,event,"E' necessario compilare il campo testo per salvare lo script.","error","Attenzione!"), esecuzione = false):esecuzione = true;
        else oldScript.Text__c == null || oldScript.Text__c == undefined || oldScript.Text__c.trim() === "<p>     </p>"? (helper.toastMancante(cmp,event,"E' necessario compilare il campo testo per salvare lo script.","error","Attenzione!"), esecuzione = false):esecuzione = true;
        if(IdoldScript == null || IdoldScript == undefined)
        cmp.find('dataInizio').get('v.value') > cmp.find('dataFine').get('v.value')? (helper.toastMancante(cmp,event,"La data di fine durata dello script deve essere maggiore della data d'inizio.","error","Attenzione!"), controllDate = false):controllDate = true;
        else cmp.find('dataInizio').get('v.value') > cmp.find('dataFine').get('v.value')? (helper.toastMancante(cmp,event,"La data di fine durata dello script deve essere maggiore della data d'inizio.","error","Attenzione!"), controllDate = false):controllDate = true;
        console.log(esecuzione, controllDate, text)
           if(esecuzione && controllDate){ 
            action.setParams({'idoldScript':IdoldScript, 
                              'text':cmp.get('v.text') == undefined ?oldScript.Text__c :  cmp.get('v.text'),
                              'sectioncode':cmp.get('v.sectiontype') == undefined ?  oldScript.SectionType__c :cmp.get('v.sectiontype'),
                              'sectiontype':cmp.get('v.sectioncode') == undefined ?   oldScript.SectionCode__c :cmp.get('v.sectioncode'),
                              'tipocamp':cmp.get('v.tipocampagna') == undefined ? oldScript.TipoCampagna__c :cmp.get('v.tipocampagna'),
                              'active': true,
                              'endDate':cmp.find('dataFine').get('v.value') ,
                              'startDate':cmp.find('dataInizio').get('v.value'),
                              'actioncodelvl2':cmp.get('v.actioncodelvl2') == undefined ? oldScript.ActionCodeLvl2__c :cmp.get('v.actioncodelvl2') ,
                              'actioncode':cmp.get('v.actioncode') == undefined ?   oldScript.ActionCode__c : cmp.get('v.actioncode') ,
                              'codprod':cmp.get('v.codprod')== undefined ? oldScript.CodProd__c:cmp.get('v.codprod') ,
                              'codprodlvl2':cmp.get('v.codprodlvl2')== undefined ?  oldScript.CodProdLvl2__c :cmp.get('v.codprodlvl2') });
            action.setCallback(this, (response) => { 
                let state = response.getState();
                console.log(state);
                if (state == 'SUCCESS') {
                    let results = response.getReturnValue();
                    
                Object.keys(results) == "noUP"? helper.toastMancante(cmp,event,"E' necessario modificare la data d'inizio script per usufruire della funzione salva e clona","error","Attenzione!") :helper.toastSucc(cmp,event);
                }
            });
        $A.enqueueAction(action);
               }
        
       
    },
    closeModelIndirizzoDealer: function(cmp,event,helper){
        cmp.set('v.openModaleScriptEdit',false);
        
    },
    handleLoad: function(cmp,event,helper){
        console.log('vediamo ',cmp.get('v.actioncodelvl2') , ' ', 
        cmp.get('v.actioncode')
        );
        let message;
        let tipo;
        let titolo;
        let actionCodeCtrl;
        if(cmp.get('v.tipocampagna') == 'PP' && cmp.get('v.actioncode') == null) actionCodeCtrl = true 
        else if(cmp.get('v.tipocampagna') == 'CC' && cmp.get('v.actioncode') == null) actionCodeCtrl = false
        if(cmp.get('v.actioncodelvl2') == null||cmp.get('v.codprodlvl2') == null||actionCodeCtrl == true){ 
            tipo = "warning" 
            titolo="Attenzione" 
            message = "Valore mancante, impossibile creare lo script" 
            cmp.set('v.showButton', false) 
            helper.toastMancante(cmp,event,message, tipo, titolo);    
        }
       else{ cmp.set('v.showButton', true);}
        
    }
    
})