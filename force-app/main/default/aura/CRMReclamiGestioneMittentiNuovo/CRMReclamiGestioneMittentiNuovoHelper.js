({
    initHelper:function(cmp,helper){
        console.log('2-B -----> Init Helper');
        
        var m=cmp.get('v.mittenteSelezionatoListaMitt');
        console.log('2-B ----> Il cliente è ' + JSON.stringify(m));
        if(m){
            cmp.set('v.tipoMittente',m['Tipologia__c']);
            cmp.set('v.isPrincipale',m['Principale__c']);
            cmp.set('v.nomeCognomeMittente',m['Name__c']);
            cmp.set('v.indirizzoMittente',m['Via__c']);
            cmp.set('v.cittaMittente',m['Citta__c']);
            cmp.set('v.provinciaMittente',m['Provincia__c']);
            cmp.set('v.capMittente',m['Codice_Postale__c']);
            cmp.set('v.salutoMittente',m['Salutation__c']);
            console.log('2-B ---> imposto saluto mittente con ' + JSON.stringify(m['Salutation__c']));
        }
    },
    
    buildSalutiValues:function(cmp){
        console.log('2-B ----> Build Saluti');
        var salutiAvvocato=['EGREGIO SIGNOR AVV.','EGREGI SIGNORI AVV.','GENTILE SIGNORA AVV.','GENTILI SIGNORE AVV.'];
        var salutiDottore=['EGREGIO SIGNOR DOTT.','EGREGI SIGNORI DOTT.','GENTILE SIGNORA DOTT.SSA','GENTILI SIGNORE DOTT.SSE'];
        var salutiAltro=['EGREGIO SIGNORE','EGREGI SIGNORI','GENTILE SIGNORA','GENTILI SIGNORE'];
        var salutiGenerico=['SPETTABILE'];
        var salutiMap={
            'AVVOCATO':salutiAvvocato,
            'DOTTORE':salutiDottore,
            'ALTRO':salutiGenerico.concat(salutiAltro).concat(salutiAvvocato).concat(salutiDottore),
            'AUTORITA':salutiGenerico,
            'SOCIETA':salutiGenerico,
            'INDIRIZZI PREDEFINITI':salutiGenerico
        };
        cmp.set('v.salutiValues',salutiMap[cmp.get('v.tipoMittente')]);
        console.log('2-B ----> Build Saluti ----> v.salutiValues = '+ salutiMap[cmp.get('v.tipoMittente')]);
        if(cmp.get('v.mittenteSelezionatoListaMitt')){
            console.log('2-B ----> Build Saluti ----> If');
            var saluto=cmp.get('v.mittenteSelezionatoListaMitt')['Salutation__c'];
            console.log('2-B ----> Build Saluti ----> If ----> saluto = ' + saluto);
            cmp.set('v.salutoMittente',null);
            cmp.set('v.salutoMittente',saluto);
        }
        
    },
    
    buildIndirizziValues:function(cmp){
        var action=cmp.get('c.buildIndirizzi');
        action.setParam('societa',cmp.get('v.aziendaSelezionata'));
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                var list=[];
                cmp.set('v.indirizziValues',resp.getReturnValue());
                resp.getReturnValue().forEach(function(temp){
                    list.push(temp['Name__c']);
                });
                cmp.set('v.indirizziPredefiniti',list);
            }
        });
        $A.enqueueAction(action);
    },
    
    salvaMittente:function(cmp){
        console.log('2-B ----> Salva mittente');
        var action=cmp.get('c.makeMittente');
        action.setParams({
            'da':cmp.get('v.isPrincipale'),
            'tipo':cmp.get('v.tipoMittente'),
            'autorita':cmp.get('v.tipoMittente')=='AUTORITA',
            'nomeCognomeMittente':cmp.get('v.nomeCognomeMittente'),
            'indirizzoMittente':cmp.get('v.indirizzoMittente'),
            'cittaMittente':cmp.get('v.cittaMittente'),
            'provinciaMittente':cmp.get('v.provinciaMittente'),
            'capMittente':cmp.get('v.capMittente'),
            'saluti':cmp.get('v.salutoMittente')
        });
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                var mittentiList=cmp.get('v.mittentiList');
                mittentiList.push(resp.getReturnValue());
                cmp.set('v.mittentiList',mittentiList);
                cmp.set('v.stepInserimentoMittenti','main');
                console.log('2-B ----> Salva mittente if Call back');
            }
        });
        $A.enqueueAction(action);
    },
    
    salvaIndPred:function(cmp){
        var action=cmp.get('c.makeMittenteFromIndPred');
        action.setParam('ip',cmp.get('v.indirizzoPredefinitoMittente'));
        action.setParam('principale',cmp.get('v.isPrincipale'));
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                var mitList=cmp.get('v.mittentiList');
                mitList.push(resp.getReturnValue());
                cmp.set('v.mittentiList',mitList);
                cmp.set('v.stepInserimentoMittenti','main');
            }
        });
        $A.enqueueAction(action);
    },
    
    salvaModifiche:function(cmp){
        console.log('2-B ---> Salva modifiche');
        var mittente=cmp.get('v.mittenteSelezionatoListaMitt');
        console.log('2-B ---> Salva modifiche mittente = ' + JSON.stringify(mittente));
        
        mittente['Principale__c']=cmp.get('v.isPrincipale');
        mittente['Tipologia__c']=cmp.get('v.tipoMittente');
        mittente['Predefinito__c']=cmp.get('v.tipoMittente')=='INDIRIZZI PREDEFINITI';
        mittente['Autorita__c']=cmp.get('v.tipoMittente')=='AUTORITA';
        mittente['Name__c']=cmp.get('v.nomeCognomeMittente');
        mittente['Name']=cmp.get('v.nomeCognomeMittente');
        mittente['Via__c']=cmp.get('v.indirizzoMittente');
        mittente['Citta__c']=cmp.get('v.cittaMittente');
        mittente['Provincia__c']=cmp.get('v.provinciaMittente');
        mittente['Codice_Postale__c']=cmp.get('v.capMittente');
        mittente['Salutation__c']=cmp.get('v.salutoMittente');
        cmp.set('v.mittenteSelezionatoListaMitt',null);
        cmp.set('v.mittentiList',cmp.get('v.mittentiList'));
        cmp.set('v.stepInserimentoMittenti','main');
        console.log('2-B salva modifiche saluto mittente = ' + cmp.get('v.salutoMittente'));
        console.log('2-B salva modifiche mittente[Name] = ' + mittente['Name']);
        console.log('2-B salva modifiche  mittente[Codice_Postale__c] = ' +  mittente['Codice_Postale__c']);
        console.log('2-B salva modifiche  mittente[Salutation__c] = ' +  mittente['Salutation__c']);
    },
    
    selectIndirizzoHelper:function(cmp){
        var indList=cmp.get('v.indirizziValues');
        var indSel=null;
        indList.forEach(function(temp){
            if(temp['Name__c']==cmp.get('v.indirizzoPredefinito')){
                indSel=temp;
                cmp.set('v.tipoMittente','INDIRIZZI PREDEFINITI');
                cmp.set('v.isPrincipale',indSel['Principale__c']);
                cmp.set('v.nomeCognomeMittente',indSel['Name__c']);
                cmp.set('v.indirizzoMittente',indSel['Indirizzo__c']);
                cmp.set('v.cittaMittente',indSel['Citta__c']);
                cmp.set('v.provinciaMittente',indSel['Provincia__c']);
                cmp.set('v.capMittente',indSel['Cap__c']);
                cmp.set('v.salutoMittente',indSel['Saluto__c']);                
                return;
            }
        });
        cmp.set('v.indirizzoPredefinitoMittente',indSel);
    },
    
    checkIfok:function(cmp){
        var attrList=['tipoMittente'];
        var res=true;
        if(cmp.get('v.tipoMittente')=='INDIRIZZI PREDEFINITI'){
            attrList.push('indirizzoPredefinito');
        }
        attrList.forEach(function(temp){
            console.log('valori : ' + cmp.get('v.'+temp));
            if(!cmp.get('v.'+temp)){
                
                res=false;
                return;
            }
        });
        return res;
    },
})