({
	checkIfOk:function(cmp){
		var res=true;
        var attrMap={'dataComunicazione':'Data Comunicazione','dataRicezione':'Data Ricezione',
                     'dataRicezioneIDM':'Data Ricezione IDM','dataCaricamento':'Data Caricamento',
                     'risarcimentoSelection':'Risarcimento','abbuonoSelection':'Abbuono',
                     'modalitaInvioDettagli':'Modalità Invio'};
        if(cmp.get('v.isScadenzaChangeable')){
            attrMap['scadenzaReclamo']='Scadenza Reclamo';
        }
        if(cmp.get('v.showDecisione')){
            attrMap['dataDecisione']='Data Decisione';
        }
        if(cmp.get('v.campiCase')['Referenced_Company__c']!='Futuro'){
            attrMap['rimborsoSelection']='Rimborso';
            if(cmp.get('v.campiCase')['Referenced_Company__c']=='Compass'){
                attrMap['standAloneSelection']='Stand Alone';
            }
        }
        else{
            attrMap['futuroOutput']=cmp.get('v.futuroMessage');
        }
        var msg='';
        Object.keys(attrMap).forEach(function(temp){
            if(!cmp.get('v.'+temp)){
                res=false;
                msg+=attrMap[temp]+', ';
            }
        });
        cmp.set('v.errorMessage',msg==''?msg:msg.substring(0,msg.length-2));

        //20190717: anomalia 0001249
        if (res) {
            res = this.checkDatesValue(cmp);
        }
        return res;
    },
    setScadenzaReclamoReadOnly : function(component,event,helper){
        var tipo;
        var tipoName = component.get('v.tipoName');
        var c = component.get('v.campiCase');
        if(tipo==null || tipo== undefined){
            tipo = c.Tipo_Reclamo__c;
        }else{
            tipo = tipoName;
        }
        var societa = c.Referenced_Company__c;
        var action = component.get('c.isScadenzaReclamoReadOnly');

        action.setParams({
            societa : societa,
            tipoReclamo : tipo
        });

        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                var response = resp.getReturnValue();
                
                component.set('v.isReadOnly',resp.getReturnValue());
            }
        });
        $A.enqueueAction(action);

    },

    //20190717: anomalia 0001249
    checkDatesValue:function(cmp){
        var res=true;
        var today = new Date();
        var todayMonth = '' + (today.getMonth() + 1);
        var todayDay = '' + today.getDate();
        var todayYear = today.getFullYear();

        if (todayMonth.length < 2) todayMonth = '0' + todayMonth;
        if (todayDay.length < 2) todayDay = '0' + todayDay;

        today = [todayYear, todayMonth, todayDay].join('-');
        var dataComunicazione=cmp.get('v.dataComunicazione');
        var dataRicezione=cmp.get('v.dataRicezione');
        var dataRicezioneIDM=cmp.get('v.dataRicezioneIDM');
        var dataDecisione=cmp.get('v.dataDecisione');
        res=dataRicezione<=today && dataRicezione>=dataComunicazione;
        if (!res) {
            cmp.set('v.errorMessage', 'La data di ricezione deve essere maggiore di quella di comunicazione e non può essere una data futura.');
        }
        return res;
    },
    
    buildOutputObj:function(cmp){
        var res={};
        var attrList=['dataComunicazione','dataRicezione','dataRicezioneIDM','dataCaricamento',
                      'dataDecisione',
                      'scadenzaReclamo','risarcimentoOutput','abbuonoOutput','rimborsoOutput',
                      'standaloneOutput','modalitaInvioDettagli','attribuzioneReclamo','futuroOutput'];
        attrList.forEach(function(temp){
            res[temp]=cmp.get('v.'+temp);
        });
        return res;
    },
    
      buildInputRisarcimento:function(cmp){
        var res={};
        res['selection']=cmp.get('v.risarcimentoSelection');
        res['value']=cmp.get('v.risarcimentoValue');
        return res;
    },
    
    buildInputAbbuono:function(cmp){
        var res={};
        res['selection']=cmp.get('v.abbuonoSelection');
        res['value']=cmp.get('v.abbuonoValue');
        return res;
    },
    
     buildInputRimborso:function(cmp){
        var res={};
        res['selection']=cmp.get('v.rimborsoSelection');
        res['value']=cmp.get('v.rimborsoValue');
        return res;
    },
    
    getCurrentModalita : function(cmp){
        console.log('modalita init ' + cmp.get('v.campiCase')['Id']);
        var action = cmp.get('c.getMod');
        action.setParam('recordId',cmp.get('v.campiCase')['Id']);
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                console.log('res = ' + resp.getReturnValue());
                cmp.set('v.modalitaInvioDettagliForInit',resp.getReturnValue());
                console.log('fet = ' + cmp.get('v.modalitaInvioDettagliForInit'));
            }
        });
        $A.enqueueAction(action);

    },
    getDecisione : function(cmp){
        
        var tipo = cmp.get('v.tipoName');

        if(tipo=='5412'){
            
            var action = cmp.get('c.getDecisione');
            action.setParam('recordId',cmp.get('v.campiCase')['Id']);
            action.setCallback(this,function(resp){
                if(resp.getState()=='SUCCESS'){
                    //cmp.set('v.showDecisione',resp.getReturnValue());
                    var x = resp.getReturnValue();
                    cmp.set('v.showDecisione',true);
                    
                    //cmp.set('v.dataDecisione',resp.getReturnValue());
                }
            });
            $A.enqueueAction(action);
        }else{
            cmp.set('v.showDecisione',false);
        }


    }
})